# 🛡️ Self.xyz SybilShield Enrollment Gateway

[![Base Sepolia](https://img.shields.io/badge/Network-Base_Sepolia-blue?logo=ethereum)](https://sepolia.basescan.org/address/0xEe3c37AC3B48c939540b12f22db07704CF0FAAc4)
[![Solidity](https://img.shields.io/badge/Solidity-0.8.24-lightgrey?logo=solidity)](https://soliditylang.org/)
[![Foundry](https://img.shields.io/badge/Framework-Foundry-orange)](https://getfoundry.sh/)
[![ZK-SNARKs](https://img.shields.io/badge/Privacy-Self.xyz_ZK_Proofs-green)](https://self.xyz)

> **Generic, modular, and privacy-preserving SybilShield enrollment framework for Web3 dapps on Base using Self.xyz Zero-Knowledge (ZK) biometric passport proofs.**

---

## 🌟 Executive Overview & Web3 Paradigm Aim

In Web3 dapps, DAOs, airdrops, quadratic funding, and grant distribution programs, applications face two major challenges:
1. **Sybil Attacks & Bot Farms**: Automated bots create thousands of fake wallets to claim rewards and manipulate voting.
2. **Privacy Invasion**: Traditional KYC forces users to upload plain-text ID cards to centralized databases, creating honeypots for identity theft.

### The Plug-and-Play Solution: Generic ZK SybilShield
This repository provides a **reusable, modular SybilShield enrollment gateway** powered by **Self.xyz**. Any Web3 application (e.g. Dadami, DAOs, Grant Hubs, Airdrop platforms) can import `SelfVerifier.sol` to allow real humans to verify their unique humanity using passport ZK proofs (ICAO 9303 standard) **without revealing their name, passport number, or date of birth on-chain**.

---

## 🔬 Key Web3 Technical Concepts & Architecture

### 1. Off-Chain Prover / On-Chain Verifier Paradigm
- **Off-Chain Prover (Self Pass Mobile App)**: The user scans the NFC chip in their biometric passport. The smartphone generates a **Groth16 ZK-SNARK proof** locally. Personal Identifiable Information (PII) **never leaves the user's phone**.
- **On-Chain Verifier ([SelfVerifier.sol](file:///Users/mohanbn/Projects/Antigravity/06_base_selfxyz_sybilshield_enrollment/contracts/src/SelfVerifier.sol))**: Receives the mathematical ZK proof output payload on Base Sepolia and verifies the cryptographic signature on-chain.

### 2. Nullifier Cryptography (Sybil Resistance)
- A **Nullifier** is a deterministic, blind hash generated from the passport secret: `nullifier = Poseidon(passport_secret)`.
- The smart contract records `nullifierHashes[nullifier] = true`. If a user attempts to register a second wallet with the same physical passport, the contract rejects the transaction with `"Identity already registered"`.

### 3. Scalable Layer-2 Execution on Base
- Operating on **Base L2** ensures lightning-fast transaction settlement and sub-cent gas costs for student verification callbacks.

---

## 📍 Live On-Chain Deployments (Base Sepolia Testnet)

| Contract | Network | Deployed Address | Block Explorer |
| :--- | :--- | :--- | :--- |
| **`SelfVerifier`** | **Base Sepolia** | `0xEe3c37AC3B48c939540b12f22db07704CF0FAAc4` | [View on BaseScan](https://sepolia.basescan.org/address/0xEe3c37AC3B48c939540b12f22db07704CF0FAAc4) |

- **Deployment Tx Hash**: [`0x163b0d034287e7a9bebd17072b75457dc17ac5ac9243c137b9e545c823958ea0`](https://sepolia.basescan.org/tx/0x163b0d034287e7a9bebd17072b75457dc17ac5ac9243c137b9e545c823958ea0)

---

## 🛠️ Project Architecture & Data Schema

```
06_base_selfxyz_sybilshield_enrollment/
├── contracts/
│   ├── src/
│   │   ├── interfaces/
│   │   │   └── ISelfVerificationRoot.sol   # Self.xyz ZK disclosure data structures
│   │   ├── mocks/
│   │   │   └── SelfVerificationRoot.sol    # Base abstract ZK verifier contract
│   │   └── SelfVerifier.sol                # Core enrollment logic & reset hook
│   ├── test/
│   │   └── SelfVerifier.t.sol              # Automated Forge unit test suite
│   ├── foundry.toml                        # Forge compiler & remappings config
│   ├── .env.example                        # Safe public environment template
│   └── .env                                # Protected deployment key storage (.gitignore)
└── frontend/
    ├── index.html                          # Glassmorphic Dapp gateway UI
    └── config.js                           # Externalized environment configuration
```

### On-Chain Data Schema (`SelfVerifier.sol`)
* `isHuman[address => bool]`: Maps wallet address to verified human status.
* `nullifierHashes[uint256 => bool]`: Prevents reuse of the same physical passport across multiple wallets.
* `userIdentifiers[address => uint256]`: Links unique, anonymous user IDs to verified student wallets.
* `userCountries[address => string]`: Stores verified passport issuing country code (e.g. `IND` for India).
* `resetRegistration(address user)`: Dev-mode function enabling developers to clear test state on-chain for repeated testing.

---

## 🧰 Technology Stack

- **Smart Contracts**: Solidity `^0.8.24`
- **Development & Testing**: Foundry (`forge`, `cast`)
- **Zero-Knowledge Protocol**: Self.xyz ZK Passport Verification SDK
- **Blockchain Network**: Base Sepolia Testnet (Chain ID `84532`)
- **Frontend Dapp**: Vanilla HTML5 / Modern CSS3 (Glassmorphism), Ethers.js `v6`, QRCode.js

---

## 🚀 Quickstart & Local Setup

To easily set up this repository in standalone mode (configure environment files, install local dependencies, and compile contracts in one click), run:
```bash
chmod +x setup.sh
./setup.sh
```


### 1. Smart Contract Compilation & Unit Tests
```bash
cd contracts

# Compile Solidity contracts
forge build

# Run automated unit tests
forge test -vv
```

### 2. Deploying to Base Sepolia
```bash
cd contracts

# Copy environment template
cp .env.example .env

# Edit .env with your private key and RPC URL, then run:
source .env && forge create src/SelfVerifier.sol:SelfVerifier \
  --rpc-url $RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --constructor-args $HUB_ADDRESS $CONFIG_ID
```

## 🌐 Multi-Network Testing Guide

Start the local web server:
```bash
cd frontend
python3 -m http.server 8006
```

---

### Option A: Test Live on Base Sepolia Testnet

1. Open **[http://localhost:8006/?network=sepolia](http://localhost:8006/?network=sepolia)** in Chrome with MetaMask.
2. In MetaMask, connect to **Base Sepolia** (`Chain ID: 84532`).
3. Click **Connect MetaMask Wallet** $\rightarrow$ Click **Verify Official ID (Self.xyz)** to reveal the live scannable QR code for the Self Pass Mobile App.

---

### Option B: Test Locally on Anvil Fork (Fast & Free)

1. **Launch the local Anvil fork**:
   ```bash
   anvil --fork-url https://sepolia.base.org --chain-id 31337
   ```
2. Open **[http://localhost:8006/?network=anvil](http://localhost:8006/?network=anvil)** in Chrome with MetaMask.
3. In MetaMask, select **Localhost 8545** (`Chain ID: 31337`).
4. Connect using pre-funded test accounts and use the interactive 3-step proof simulator to test attestation against the preloaded contract state!

---

## 📜 License
MIT License. Built with ❤️ for the Base Ecosystem.

