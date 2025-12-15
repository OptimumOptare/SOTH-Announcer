require('dotenv').config();
const { ethers } = require('ethers');
const contractABI = require('./abi');

// Configuration
const RPC_URL = process.env.MONAD_RPC_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS;

if (!RPC_URL || !PRIVATE_KEY || !CONTRACT_ADDRESS) {
    console.error('Missing environment variables. Please check .env');
    process.exit(1);
}

const provider = new ethers.JsonRpcProvider(RPC_URL);
const wallet = new ethers.Wallet(PRIVATE_KEY, provider);
const contract = new ethers.Contract(CONTRACT_ADDRESS, contractABI, wallet);

async function main() {
    console.log('Checking contract state...');
    try {
        const [isActive, round, endTime, stakedCount, jackpot, survivorJackpot] = await contract.getRoundInfo();
        const currentTime = Math.floor(Date.now() / 1000);

        console.log(`Round: ${round}`);
        console.log(`Active: ${isActive}`);
        console.log(`EndTime: ${endTime} (Current: ${currentTime})`);
        console.log(`Time remaining: ${endTime - BigInt(currentTime)} seconds`);

        console.log('Attempting to call endRound()...');
        const tx = await contract.endRound();
        console.log(`endRound tx sent: ${tx.hash}`);
        const receipt = await tx.wait();
        console.log('endRound confirmed.');

    } catch (error) {
        console.error('Error:', error);
        if (error.data) {
            // Try to parse the revert reason if possible
            try {
                const decodedError = contract.interface.parseError(error.data);
                console.error('Revert Reason:', decodedError ? decodedError.name : error.data);
            } catch (e) {
                console.error('Could not parse revert reason');
            }
        }
    }
}

main();
