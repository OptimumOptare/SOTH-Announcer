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
const SCHEDULE = process.env.CRON_SCHEDULE || '*/10 * * * *';

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
                const finalStakedCount = stakedCount;

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
        } catch (e) {
            // ignore
        }
    }

    const nextRound = Number(endedRoundNumber) + 1;


    // Construct the message
    const line1 = `# Day ${endedRoundNumber} of Schizo of the Hill`;
    const line2 = `13000 $MON Prizepool`;
    const line3 = `${stakedCount} Contestants were competing to become the King of the Hill.`;
    const line4 = burnedTokenId ? `#${burnedTokenId} died on the Hill.` : `No one died on the Hill.`;
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
    }, {
        timezone: "UTC"
    });

});

client.login(DISCORD_TOKEN);
