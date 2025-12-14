require('dotenv').config();
const { Client, GatewayIntentBits, EmbedBuilder } = require('discord.js');
const { ethers } = require('ethers');
const cron = require('node-cron');
const fs = require('fs');
const path = require('path');

// Configuration
const RPC_URL = process.env.MONAD_RPC_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS;
const DISCORD_TOKEN = process.env.DISCORD_TOKEN;
const CHANNEL_ID = process.env.DISCORD_CHANNEL_ID;
// Cron schedule: Default to every 10 minutes to check, or user defined
const SCHEDULE = process.env.CRON_SCHEDULE || '*/10 * * * *';

// Load ABI
const abiPath = path.join(__dirname, '../Smartcontract/SOTHCONTRACT_ABI');
let contractABI;
try {
    const abiFile = fs.readFileSync(abiPath, 'utf8');
    const abiJson = JSON.parse(abiFile);
    contractABI = abiJson.abi;
} catch (error) {
    console.error('Error loading ABI:', error);
    process.exit(1);
}

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
                const finalStakedCount = stakedCount;
                // Note: jackpot might be transferred out, so we rely on logs for winnings, but we can use the pre-tx snapshot for the "Prizepool" display if we assume it was the pot.
                // However, the user says "13.000 $MON Prizepool".

                const tx = await contract.endRound();
                console.log(`endRound tx sent: ${tx.hash}`);
                const receipt = await tx.wait();
                console.log('endRound confirmed.');

                // Start new round immediately after
                console.log('Starting new round...');
                const txStart = await contract.startRound();
                console.log(`startRound tx sent: ${txStart.hash}`);
                await txStart.wait();
                console.log('New round started.');

                // Announce everything in one go
                await announceDailyUpdate(endedRoundNumber, finalStakedCount, receipt);
            } else {
                console.log('Round is still active. Waiting...');
            }
        } else {
            console.log('Round is not active. Starting new round...');
            const txStart = await contract.startRound();
            console.log(`startRound tx sent: ${txStart.hash}`);
            await txStart.wait();
            console.log('New round started.');

            // Only announce new round start if we didn't just end a round (e.g. cold start)
            // But usually we want the full daily report. 
            // If we only started a round without ending one, we verify what the user wants. 
            // User: "There is a end round and Start new round function i need to call once a day."
            // So arguably we should only see the full report. 
            // If just starting, we'll announce just the start.
            await announceNewRoundOnly();
        }
    } catch (error) {
        console.error('Error in checkAndExecute:', error);
    }
}

async function announceDailyUpdate(endedRoundNumber, stakedCount, receipt) {
    if (!client.isReady()) {
        console.log('Discord client not ready, skipping announcement.');
        return;
    }

    const channel = await client.channels.fetch(CHANNEL_ID);
    if (!channel) {
        console.error('Discord channel not found.');
        return;
    }

    // Parse logs for specific details
    let burnedTokenId = null;
    let jackpotPaid = '0';
    let winner = null;

    // We scan for specific events
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
            // Multi-burn logic in contract might burn multiple, but current contract seems to burn 1 in _handleMultiNFTRound
        } catch (e) {
            // ignore
        }
    }

    const nextRound = Number(endedRoundNumber) + 1;
    // Format jackpot - user requested "13.000 $MON Prizepool" style
    // If jackpotPaid is 13000.0, we format it.
    // ethers.formatEther returns a string.
    const formattedJackpot = parseFloat(jackpotPaid).toLocaleString('de-DE', { minimumFractionDigits: 3, maximumFractionDigits: 3 });
    // using de-DE for "13.000" (dot as thousands, comma as decimal) or just mimic user's "13.000" if they meant 13k.
    // Actually "13.000" in US locale is 13.
    // If user is from a locale where . is thousands separator (like DE/EU), then 13.000 is 13k.
    // Given the ambiguity, and "MON" likely being a testnet token, 13k is plausible. 
    // I will use a simple formatter. 
    // The user wrote "13.000" which looks like 13 thousand.
    // I will print the value as is from ethers but maybe formatted.

    // Construct the message
    // "Day 7 of Schizo of the Hill (This is the ending round)"
    const line1 = `Day ${endedRoundNumber} of Schizo of the Hill`;
    // "13.000 $MON Prizepool"
    const line2 = `${formattedJackpot} $MON Prizepool`;
    // "48 Contestants were competing to become the King of the Hill."
    const line3 = `${stakedCount} Contestants were competing to become the King of the Hill.`;
    // "#173 died on the Hill." (If burned)
    const line4 = burnedTokenId ? `#${burnedTokenId} died on the Hill.` : `No one died on the Hill.`;
    // "Round 8 has started. Good Luck Schizos"
    const line5 = `Round ${nextRound} has started. Good Luck Schizos`;

    const message = `${line1}\n${line2}\n${line3}\n\n${line4}\n\n${line5}`;

    // Send as plain message to match the text format requested perfectly
    await channel.send(message);
}

async function announceNewRoundOnly() {
    if (!client.isReady()) return;
    const channel = await client.channels.fetch(CHANNEL_ID);
    if (!channel) return;

    // Get new round info
    const [isActive, round] = await contract.getRoundInfo();
    await channel.send(`Round ${round} has started. Good Luck Schizos`);
}

client.once('ready', () => {
    console.log(`Logged in as ${client.user.tag}!`);

    // Schedule the check
    console.log(`Scheduling bot with schedule: ${SCHEDULE}`);
    cron.schedule(SCHEDULE, () => {
        checkAndExecute();
    });

    // Also run immediately on startup if desired, or just wait for schedule
    // checkAndExecute(); 
});

client.login(DISCORD_TOKEN);
