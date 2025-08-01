const { ethers } = require('ethers');


const RPC_URL = process.env.RPC_URL; 
const CHAIN_ID = process.env.CHAIN_ID;
const PRIVATE_KEY = process.env.PRIVATE_KEY;  
const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS;
const CONTRACT_ABI = require('./blockchain-utils/BlockCertABI.json'); 

const blocked_network = {
    name: "blocked",
    chainId: Number(CHAIN_ID),
    url: RPC_URL,
}

// Initialize provider and signer
const provider = new ethers.providers.JsonRpcProvider(RPC_URL, blocked_network);
const wallet = new ethers.Wallet(PRIVATE_KEY, provider);
const contract = new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, wallet);

async function issueCertificateOnChain(cert_hash, duration_in_years, receiver_address) {
    try {
        const tx = await contract.issueCertificate(cert_hash, duration_in_years, receiver_address, {
            gasLimit: 500_000,
            gasPrice: 0
        });
        console.log("Transaction sent:", tx.hash);

        const receipt = await tx.wait();
        console.log("Transaction confirmed:", receipt.transactionHash);

        const issued = receipt.events?.some(
            (e) => e.event === 'CertIssued'
        );

        return issued;

    } catch (error) {
        console.error("Error issuing certificate:", error);
        const revert_reason = error?.error?.message || error.message || "Unknown revert error";
        throw new Error(revert_reason);
    }
}

const CERTIFICATE_IS_ACTIVE = 0;
const CERTIFICATE_IS_INACTIVE = 1;
const CERTIFICATE_DOES_NOT_EXIST = 2;

async function verifyCertificateOnChain(hashed_data) {
    try {
        const tx = await contract.verifyCertificateByHash(hashed_data, {
            gasLimit: 500_000,
            gasPrice: 0
        });
        console.log("Transaction sent:", tx.hash);

        const receipt = await tx.wait();
        console.log("Transaction confirmed:", receipt.transactionHash);

        const event = receipt.events?.find((e) => e.event === 'CertVerified');

        if (!event) {
            return CERTIFICATE_DOES_NOT_EXIST;
        }

        const isActive = event.args?.active;

        return isActive ? CERTIFICATE_IS_ACTIVE : CERTIFICATE_IS_INACTIVE;

    } catch (error) {
        console.error("Error verifying certificate:", error);
        const revert_reason = error?.error?.message || error.message || "Unknown revert error";
        throw new Error(revert_reason);
    }
}


module.exports = {
    issueCertificateOnChain,
    verifyCertificateOnChain,
    CERTIFICATE_IS_ACTIVE,
    CERTIFICATE_IS_INACTIVE,
    CERTIFICATE_DOES_NOT_EXIST
};
