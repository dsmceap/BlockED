const fs = require('fs');
const path = require('path');
const { Wallet } = require('ethers');
require('dotenv').config();

function ensureWalletInEnv() {
    const envPath = path.resolve(__dirname, '../.env');
    const envContent = fs.existsSync(envPath) ? fs.readFileSync(envPath, 'utf-8') : '';

    let envLines = envContent.split('\n').filter(Boolean);
    const hasAddress = envLines.some(line => line.startsWith('ACCOUNT_ADDRESS='));
    const hasKey = envLines.some(line => line.startsWith('PRIVATE_KEY='));

    if (!hasAddress || !hasKey) {
        const wallet = Wallet.createRandom();
        const addressLine = `ACCOUNT_ADDRESS=${wallet.address}`;
        const keyLine = `PRIVATE_KEY=${wallet.privateKey}`;

        console.log('🔐 New wallet generated');
        console.log('Address:', wallet.address);

        if (!hasAddress) envLines.push(addressLine);
        if (!hasKey) envLines.push(keyLine);

        fs.writeFileSync(envPath, envLines.join('\n'));
    }
}
module.exports = { ensureWalletInEnv };
