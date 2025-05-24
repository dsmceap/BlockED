# BlockED
This repo hosts the open source code and documentation of the BlockED project and the Blockchain plugin.

Deploy a private Blockchain network
# Private Quorum Network with QBFT Consensus

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

Install GoQuorum.

Copy genesis.json and static-nodes.json into your node data directory.

Initialize the chain:

bash
Copy
Edit
geth --datadir node1 init genesis.json

Start the node:

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
