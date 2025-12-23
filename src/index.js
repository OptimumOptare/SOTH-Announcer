require('dotenv').config();
const { Client, GatewayIntentBits, EmbedBuilder } = require('discord.js');
const { ethers } = require('ethers');

const fs = require('fs');
const path = require('path');

// Configuration
const RPC_URL = process.env.MONAD_RPC_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS;
const DISCORD_TOKEN = process.env.DISCORD_TOKEN;
const CHANNEL_ID = process.env.DISCORD_CHANNEL_ID;

// Load ABI
const contractABI = require('./abi');

// Initialize Discord Client
const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMessages
    ]
});

// Initialize Wallet and Contract
if (!RPC_URL || !PRIVATE_KEY || !CONTRACT_ADDRESS) {
    console.error('Missing environment variables. Please check .env');
    process.exit(1);
}

const provider = new ethers.JsonRpcProvider(RPC_URL);
const wallet = new ethers.Wallet(PRIVATE_KEY, provider);
const contract = new ethers.Contract(CONTRACT_ADDRESS, contractABI, wallet);

async function checkAndExecute() {
    console.log('Checking contract state...');
    try {
        const [isActive, round, endTime, stakedCount, jackpot, survivorJackpot] = await contract.getRoundInfo();
        const currentTime = Math.floor(Date.now() / 1000);

        console.log(`Round: ${round}, Active: ${isActive}, EndTime: ${endTime}, CurrentTime: ${currentTime}`);

        if (isActive) {
            if (currentTime >= endTime) {
                console.log('Round ended. Calling endRound()...');

                // Keep data for announcement
                const endedRoundNumber = round;
                const startingStakedCount = stakedCount;

                const tx = await contract.endRound({ gasLimit: 6000000 });
                console.log(`endRound tx sent: ${tx.hash}`);
                const receipt = await tx.wait();
                console.log('endRound confirmed.');

                // Parse logs for specific details from the receipt
                const eventData = parseEventsFromReceipt(receipt);

                // Start new round immediately after
                console.log('Starting new round...');
                const txStart = await contract.startRound();
                console.log(`startRound tx sent: ${txStart.hash}`);
                await txStart.wait();
                console.log('New round started.');

                // Announce everything in one go
                await announceDailyUpdate(endedRoundNumber, startingStakedCount, eventData);
            } else {
                console.log('Round is still active. Waiting...');
            }
        } else {
            console.log('Round is not active. Attempting to recover and start new round...');

            // If the round is not active, it means endRound() was likely called (by us or someone else),
            // but we might have missed the announcement.
            // "round" variable here should be the round that just ended.
            const endedRoundNumber = round;

            // Determine "startingStakedCount". 
            // Since the round is over, the current "stakedCount" (survivors) reflects the state AFTER the death.
            // We'll fetch recent events first to see if someone died.

            console.log('Fetching recent events to reconstruct round history...');
            const eventData = await fetchRecentEventsFromChain();

            // If someone died, the count BEFORE endRound was survivors + 1.
            // If no one died, it was survivors + 0.
            const survivorsCount = Number(stakedCount);
            // We need to be careful with BigInt -> Number, but for NFT counts it's safe.
            const startingStakedCount = eventData.burnedTokenId ? (survivorsCount + 1) : survivorsCount;

            console.log(`Recovered State - Round: ${endedRoundNumber}, Survivors: ${survivorsCount}, Died: ${eventData.burnedTokenId ? '#' + eventData.burnedTokenId : 'None'}`);

            console.log('Starting new round...');
            try {
                const txStart = await contract.startRound();
                console.log(`startRound tx sent: ${txStart.hash}`);
                await txStart.wait();
                console.log('New round started.');
            } catch (err) {
                // If startRound fails because it's already active (race condition), just proceed to announce
                console.warn('startRound might have failed or race condition:', err.message);

                // Optional: Check if the error implies the round is ALREADY started.
                // Depending on the contract, calling startRound on active round might revert.
            }

            // Announce using the reconstructed data
            await announceDailyUpdate(endedRoundNumber, startingStakedCount, eventData);
        }
    } catch (error) {
        console.error('Error in checkAndExecute:', error);
    }
}

function parseEventsFromReceipt(receipt) {
    let burnedTokenId = null;
    let jackpotPaid = '0';
    let winner = null;

    for (const log of receipt.logs) {
        try {
            const parsed = contract.interface.parseLog({ topics: log.topics.slice(), data: log.data });
            if (!parsed) continue;

            if (parsed.name === 'NFTBurned') {
                burnedTokenId = parsed.args.tokenId;
            } else if (parsed.name === 'JackpotWon') {
                jackpotPaid = ethers.formatEther(parsed.args.amount);
                winner = parsed.args.winner;
            }
        } catch (e) {
            // ignore
        }
    }
    return { burnedTokenId, jackpotPaid, winner };
}

async function fetchRecentEventsFromChain() {
    // Look back ~20000 blocks (Monad is fast, 200ms block time)
    const currentBlock = await provider.getBlockNumber();
    const fromBlock = currentBlock - 20000;

    let burnedTokenId = null;
    let jackpotPaid = '0';
    let winner = null;

    try {
        const burnedEvents = await contract.queryFilter('NFTBurned', fromBlock, 'latest');
        if (burnedEvents.length > 0) {
            // Get the most recent one
            const lastBurn = burnedEvents[burnedEvents.length - 1];
            burnedTokenId = lastBurn.args.tokenId;
        }

        const jackpotEvents = await contract.queryFilter('JackpotWon', fromBlock, 'latest');
        if (jackpotEvents.length > 0) {
            const lastJackpot = jackpotEvents[jackpotEvents.length - 1];
            jackpotPaid = ethers.formatEther(lastJackpot.args.amount);
            winner = lastJackpot.args.winner;
        }
    } catch (e) {
        console.error('Error fetching logs:', e);
    }

    return { burnedTokenId, jackpotPaid, winner };
}

async function announceDailyUpdate(endedRoundNumber, stakedCount, eventData) {
    if (!client.isReady()) {
        console.log('Discord client not ready, skipping announcement.');
        return;
    }

    const channel = await client.channels.fetch(CHANNEL_ID);
    if (!channel) {
        console.error('Discord channel not found.');
        return;
    }

    const { burnedTokenId, jackpotPaid, winner } = eventData;
    const nextRound = Number(endedRoundNumber) + 1;

    // Construct the message
    const line1 = `# Day ${endedRoundNumber} of Schizo of the Hill`;
    const line2 = `13000 $MON Prizepool`; // Ideally this should be dynamic too, but keeping hardcoded as in original
    const line3 = `${stakedCount} Contestants were competing to become the King of the Hill.`;
    const line4 = burnedTokenId ? `#${burnedTokenId} died on the Hill.` : `No one died on the Hill.`;
    const line5 = `Round ${nextRound} has started. Good Luck Schizos`;

    const message = `${line1}\n${line2}\n${line3}\n\n${line4}\n\n${line5}`;

    // Send as plain message
    await channel.send(message);
    console.log('Announcement sent!');
}

client.once('ready', async () => {
    console.log(`Logged in as ${client.user.tag}!`);

    try {
        // Execute immediately as Railway handles the schedule
        await checkAndExecute();
        console.log('Execution completed.');
    } catch (error) {
        console.error('Execution failed:', error);
        process.exitCode = 1;
    } finally {
        console.log('Destroying client and exiting...');
        client.destroy();
        process.exit();
    }
});

client.login(DISCORD_TOKEN);
