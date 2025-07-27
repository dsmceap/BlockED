# Block.Ed
This repo hosts the open source code and documentation of the Block.Ed project and the Blockchain plugin. This project integrates the Moodle LMS platform with blockchain technology to issue and verify tamper-proof course completion certificates/badges using SoulBound Tokens (SBTs) and Decentralized Identifiers (DIDs). The system architecture below consists of 2 main building blocks: The Moodle platform in the left side that can interact with third party microcredential tools (e.g MICOO) and the Blockchain plugin in the right. Focusing on the Blockchain plugin, it consists of the **Blockchain network**, the **Blockchain Plugin Server** and the **Verifier Application**. In this Readme file we throughly present each element and provide open-source code for any possible adopters.

 <img width="1280" height="720" alt="system-architecture" src="https://github.com/user-attachments/assets/ea8499f6-90d6-41b6-b0bc-448afa7f83d7" />
Figure 1: System Architecture


---

## 📌 Overview

This system enables:
- Automatic issuance of certificates upon course completion in Moodle.
- Creation of verifiable SoulBound Tokens stored on the blockchain.
- Decentralized, privacy-preserving certificate verification via mobile app.

---

## 📚 Architecture Components

### 1. **Moodle Platform**
- LMS where students complete courses.
- On course completion:
  - Certificate/badge is generated (name, email, certificate ID, etc..).
  - Data is sent to the **Blockchain Plugin Server** via REST API.

### 2. **Blockchain Plugin Server**
- Acts as an **oracle** connecting Moodle to the blockchain.
- Responsibilities:
  - ✅ Check/Create **Decentralized Identifiers (DIDs)**.
  - 🔗 Generate **SoulBound Tokens (SBTs)**.
  - 🔒 Construct and store **Verifiable Certificate Hashes**.

### 3. **Blockchain Network**
- Stores certificate data in a decentralized, tamper-proof way.
- Uses:
  - 🤖 **Smart Contracts** for automation and data integrity.
  - 🧩 Distributed nodes (Node #1, Node #2, Node #3).

### 4. **Verifier Application**
- Used by employers/organizations for certificate validation.
- Supports:
  - Mobile interface.
  - QR scanning.
  - Direct blockchain verification.

---

## 🚀 Workflow

1. **Student completes a course** in Moodle.
2. Moodle triggers a REST API call to the Blockchain Plugin Server.
3. The server:
   - Registers/checks DIDs.
   - Issues an SBT representing the certificate.
   - Constructs a verifiable certificate hash.
4. Data is stored on the blockchain via smart contracts.
5. Third-party verifiers use a **mobile app** to validate certificates.

---

## ⚙️ Implementation Details

### 🧩 Implementation Point #1: Moodle Plugin
- **REST API Integration**:
  - Sends certificate/user data to Blockchain Plugin Server.
  - Parses and displays the response (e.g., SBT, token hash).
- **Certificate Enrichment**:
  - Embed blockchain token or QR code into certificate.
  - Ensure format compatibility.

### 🖥️ Implementation Point #2: Blockchain Plugin Server
- **DID Handling**:
  - Secure creation/validation of student and certificate DIDs.
- **SBT Management**:
  - Link certificates to blockchain identities.
- **APIs**:
  - `Issue API`: Triggered by Moodle.
  - `Verification API`: Used by mobile app.
  - `Verifiable Hash API`: Returns verifiable DID hash.

### 📱 Implementation Point #3: Verifier Application
- **UI/UX**:
  - Simple input for certificate details or QR scan.
- **Functionality**:
  - Rebuilds DID-based hash.
  - Fetches blockchain data for validation.

---

## 🔐 Decentralized Certificate Hashing

### 🔄 DID Structure

- **Certificate DID**:  
  `did:blocked/{ApplicationKey}/{IssueAuthority}/{CourseMoodleID}/{CertificateID}`

- **Certificate Owner DID**:  
  `did:blocked/{ApplicationKey}/{PlatformUserID}/{Lastname}/{Name}`

### 🧮 Hashing Algorithm


Hash = SHA-256(SHA-256(CertificateID + CertificateOwnerDID))

### 🔗Deploy a private Blockchain network
## Private Quorum Network with QBFT Consensus

This project sets up a private [GoQuorum](https://consensys.net/quorum/) blockchain network using the QBFT consensus algorithm. It is designed for fast development and testing of permissioned blockchain applications.

🧪 QBFT Consensus Overview
QBFT (Quorum Byzantine Fault Tolerance) is a consensus protocol designed for private networks. In QBFT networks:
docs.goquorum.consensys.io

Validators: Approved accounts known as validators validate transactions and blocks.

Block Creation: Validators take turns to create the next block.

Consensus Requirement: Before inserting a block onto the chain, a super-majority (≥ 2/3) of validators must sign the block.

Finality: Blocks in QBFT are final, meaning there are no forks, and valid blocks must be in the main chain.


It's crucial to maintain more than 2/3 of validators active to prevent the network from stalling. 


🛠️ Genesis File Configuration
The genesis.json file defines the initial state and configuration of the blockchain network. Key parameters include:

chainId: Unique identifier for your blockchain network.

qbft: Configuration specific to the QBFT consensus protocol, such as blockperiodseconds, epochlength, and requesttimeoutseconds.

alloc: Pre-funded accounts with their respective balances.

Ensure that the extraData field includes the list of validator addresses. 

🔄 Managing Validators
QBFT allows for dynamic management of validators:

Adding/Removing Validators: Existing validators can propose and vote to add or remove validators using JSON-RPC API methods.

Consensus for Changes: A majority vote (greater than 50%) is required to add or remove a validator.


## 🧩 Features

- QBFT consensus for Byzantine fault-tolerant block finality.
- Static node peering with pre-defined enode addresses.
- Configurable chain parameters and pre-funded accounts.
- Genesis and static-nodes files included.
- Suitable for use with Ansible automation or manual deployment.

## 📁 Directory Structure

├── genesis.json # Custom genesis block configuration for QBFT

├── static-nodes.json # List of enode addresses for peer discovery

└── README.md

## ⚙️ Genesis Configuration

The `genesis.json` includes:
- Chain ID: `1337`
- QBFT settings with `blockperiodseconds` set to 5
- Istanbul and London fork compatibility
- 3 pre-funded accounts for development and testing

```json
"qbft": {
  "policy": 0,
  "epoch": 30000,
  "ceil2Nby3Block": 0,
  "testQBFTBlock": 0,
  "blockperiodseconds": 5,
  "emptyblockperiodseconds": 120,
  "requesttimeoutseconds": 10
}

static-nodes.json defines peer-to-peer connections between 3 nodes:
[
  "enode://<node1>@Χ.Χ.Χ.Χ:30300",
  "enode://<node2>@Χ.Χ.Χ.Χ:30301",
  "enode://<node3>@Χ.Χ.Χ.Χ:30302"
]
```
# Install GoQuorum.

Copy genesis.json and static-nodes.json into your node data directory.

Initialize the chain:
```console
bash
Copy
Edit
geth --datadir node1 init genesis.json
```
Start the node:
```console
bash
Copy
Edit
geth --datadir node1 \
  --networkid 1337 \
  --nodiscover \
  --verbosity 3 \
  --http --http.port 8545 --http.api admin,eth,net,web3,quorum \
  --port 30300 \
  --bootnodes "enode://<peer>"
```

### 📁 Verifier Android App Folder Structure Overview

The Verifier-App folder acts as a repository for the mobile application which can be used to verify Block.Ed eligible certificates.
This folder contains all resources related to the mobile application:

- **📱 `app-release.apk`**  
  The installable Android app for testing.  
  👉 The app can be downloaded and installed on their Android devices to explore the verification process.

- **🧪 `qr-tests/`**  
  Contains QR codes for testing the app's behavior in three different use cases.  
  👉 Useful for demos and validating functionality.

- **💻 `flutter-source/`**  
  The full Flutter source code of the app.  
  👉 For partners or developers who want to explore, customize, or contribute to the mobile application.
