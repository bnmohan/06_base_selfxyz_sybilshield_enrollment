# 🛡️ Dadami — Self.xyz SybilShield Enrollment Gateway

[![Base Sepolia](https://img.shields.io/badge/Network-Base_Sepolia-blue?logo=ethereum)](https://sepolia.basescan.org/address/0xEe3c37AC3B48c939540b12f22db07704CF0FAAc4)
[![Solidity](https://img.shields.io/badge/Solidity-0.8.24-lightgrey?logo=solidity)](https://soliditylang.org/)
[![Foundry](https://img.shields.io/badge/Framework-Foundry-orange)](https://getfoundry.sh/)
[![ZK-SNARKs](https://img.shields.io/badge/Privacy-Self.xyz_ZK_Proofs-green)](https://self.xyz)

> **Decentralized, privacy-preserving student identity verification on Base using zero-knowledge (ZK) biometric passport proofs.**

---

## 🌟 Executive Overview & Web3 Paradigm Aim

In traditional Web3 grant distributions, student aid programs, and DAO governance, applications suffer from two critical vulnerabilities:
1. **Sybil Attacks & Bot Farms**: Malicious actors create thousands of synthetic wallets to drain funds intended for real individuals.
2. **Privacy Invasion**: Traditional KYC requires uploading plain-text passports, driver's licenses, and government IDs to centralized servers, exposing users to data breaches and identity theft.

### The Paradigm Solution: Self.xyz Biometric ZK Verification
This prototype implements **Self.xyz Zero-Knowledge Passport Verification** for **Dadami** on **Base**. It enables students to cryptographically prove they are unique, non-sanctioned real human beings holding a valid government biometric passport (ICAO 9303 standard) **without revealing their name, passport number, date of birth, or photo on-chain**.

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

### 3. Launching the Web Dapp
```bash
# Serve frontend folder via HTTP
cd frontend
python3 -m http.server 8000
```
Open **[http://localhost:8000](http://localhost:8000)** in Google Chrome, connect MetaMask to Base Sepolia, and interact with the ZK enrollment gateway!

---

## 📜 License
MIT License. Built with ❤️ for ETHGlobal and the Base Ecosystem.
