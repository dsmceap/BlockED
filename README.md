# BlockED
This repo hosts the open source code and documentation of the BlockED project and the Blockchain plugin.
This project focuses on the implementation of a Blockchain plugin used for the verification of certificates/badges produced by a Learning Management System (LMS), in our case Moodle platform. The System architecture below consists of 2 main elements: The Moodle platform in the left side that can interact with third party microcredential tools (e.g MICOO) and the Blockchain plugin in the rigth side that consists of the Blockchain network, the Oracle mechanism and the verifier app. In this Readme file we throughly present its element and provide open-source code for any possible adopters.

 <img width="1280" height="720" alt="system-architecture" src="https://github.com/user-attachments/assets/ea8499f6-90d6-41b6-b0bc-448afa7f83d7" />

System explanation
Moodle Platform: is the LMS platform on which students complete courses.
1.	Structure:
   
* Moodle Course: the course that the student must complete.
*	Course Completion: when the student completes the course, the process is activated.
*	Certificate/badge: Moodle generates certificates with details such as name, email, and certificate number.
*	Moodle Database: all data is stored by the Moodle platform in its own database.
2.	Trigger:
 	
  *Triggers the transfer of the certificate data (name, email, certificate number, etc.) to the Blockchain Plugin Server
  *The trigger will be a simple http call to the rest api of the Blockchain Plugin server
3.	Blockchain Plugin Server:

*	It is a dedicated server which acts as an oracle, that connects the platform Moodle to the blockchain.
*	Functions:
  * DID Check & Register: creates or checks Decentralized Identifiers
  * SoulBound Token Creation: creates non-transferable tokens (SoulBound Tokens) to represent the certificate in the blockchain world.
  * Verifiable Certificate Hash: re-constructures unique DID-based credential hashes that are verifiable solely through the blockchain, using specific encryption.
 	
2.	Blockchain Network:
*	The data is stored on a decentralized blockchain network.
*	Includes:
  * Smart Contracts: smart contracts to ensure data integrity and verification.
  * Nodes: data is shared across several blockchain nodes (Node #1, Node #2, Node #3) for security and decentralization.
3.	Verifier Application:
*	It is an application (either mobile or web-based) used by third parties (e.g., employers or organizations) to verify certificates.
*	Role:
  * The application retrieves data from the blockchain over the network and confirms the validity of the certificate directly, without the intervention of third-party applications or even the Blockchain Plugin Server.

Implementation Description
The implementation depicted in the image represents an integrated system that connects the Moodle platform with blockchain technology to facilitate the creation, storage, and verification of certificates.

The process begins on the Moodle platform, where students register and complete courses. Once a student successfully completes a course, the system updates their status to "Course Completed." Moodle then generates a certificate containing essential details such as the student’s name, email, and a unique certificate number. 
At this stage, a trigger is activated to initiate the registration of the certificate on the blockchain.

The trigger transmits the certificate data over to the Blockchain Plugin Server via a REST API. The server creates/generates a non-transferable token, known as a SoulBound Token (SBT), which represents the certificate on the blockchain. This SBT contains details such as the student's DID, certificate data, and issuance date. Additionally, the system securely stores the unique and verifiable certificate hash, which is constructed based on a preconfigured DID schemas of both public and non-public data. The public data will be related to both the certificate as well as the certificate owner. Afterwards, after the construction of the DIDs, a combination of them will be used to construct the unique and verifiable hash of the specific certificate.

Once the Blockchain Plugin Server processes the data, it registers the information on the blockchain. Smart contracts facilitate data storage and processing, ensuring automation and tamper-proof security.

Verification of certificates is conducted through a dedicated application. Third parties, such as employers or educational institutions, can use this application to validate a certificate. By entering the required details, the app retrieves data from the blockchain and confirms the certificate's authenticity. The verification output includes all necessary information to validate the certificate.

This implementation utilizes REST APIs to integrate Moodle with the Blockchain Plugin Server, while the blockchain infrastructure is built on an EVM-based network. 
Implementation Point #1: Configuring Moodle
REST API call:
*	Develop a function that calls the Blockchain Plugin Server API and sends the necessary information, such as certificate or user data.
Response:
*	Reading and decoding the response from the REST API (usually in JSON format)
*	Export the blockchain token or other relevant information returned by the API.
Enrichment of the Certificate:
*	Embedding the blockchain token in the content of the certificate, either as text or as a graphic (e.g., QR code).
*	Ensure that the new information does not alter the existing structure or function of the certificate.
Implementation Point #2: Blockchain Plugin Server
Communication between Application, Verifier, Moodle Plugin and Blockchain network:
*	Create a communication channel between the Moodle and the blockchain server. 
*	Management of requests sent from Moodle and their processing by the server.
Managing Secure Identification and Verification of Users and Certificates:
*	Ensure that users are authenticated in a secure way by creating and verifying Decentralized Identifiers (DIDs). 
*	Create or check an existing DID for each student.
Creation of SBT:
*	Create and register SoulBound Token (SBT) for each certificate representing the student on the blockchain. 
*	Link SBTs to certificate data (e.g., name, email, certificate number).
APIs:
*	Issue API: Moodle plugin sends certificate data upon course completion. 
*	Verification API: Used by the mobile app to confirm certificate authenticity.
*	Verifiable Certificate Hash API: Get a reconstructed verifiable hash of the certificate after its issuance (not a blockchain query).
Implementation Point #3: Verifier Implementation
Mobile User Interface:
*	Development of an application that will allow third-party users (employers, organizations) to verify certificates via the blockchain.
*	User interface (UI) for easy certificate data entry and verification. 


Decentralized Certificate Verification
*	Decentralized and Verifiable Hashing Algorithm: 
*	Generates a tamper-proof hash from public certificate data by constructing unique DIDs based on public and non-public data.
*	The hash is stored on the blockchain and included in a QR code on the certificate.
*	Certificates Decentralized Verification Schema: 
  *	Certificate Public data: Issue Authority / course moodle id / certificate ID No
  * Certificate Owner Public Data: Platform User ID / Lastname / Name 
  * Non-Public Data: Project Name (BLOCKED) / Application Key
*	DIDs Schema:
  *	Certificate DID: “did:blocked/{ Application Key }/{ Issue Authority }/{ course moodle id }/{ certificate ID No }”
  * Certificate Owner DID: “did:blocked/{ Application Key }/{ Platform User ID }/{ Lastname }/{ Name }”
* Unique Verifiable Certificate Hash:
   * Double Hashing [ SHA-256(SHA-256(data)) ]
   *	Data = CertificateId/CertificateOwnerDID
*	Verification Process: 
*	The mobile app reconstructs the DID hash using the same algorithm from the provided input of the public data and combine them with non-public data.
*	The user can verify a certificate using public data without exposing sensitive details.
*	QR code scanning enables instant verification.



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
