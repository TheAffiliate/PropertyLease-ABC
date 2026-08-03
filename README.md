# Decentralized Property Lease & Escrow System

A Web3 real estate portfolio and escrow management system built as a technical deliverable for the **Africa's Blockchain Club (ABC)** entry assessment. 

This project demonstrates a scalable approach to decentralized tenancy agreements, utilizing the Factory pattern to allow multiple landlords to deploy and manage isolated property portfolios on the blockchain.

## 🏗️ Smart Contract Architecture

The system is composed of two primary contracts:

1. **`LeaseFactory.sol` (The Orchestrator)**
   - Acts as a decentralized factory for deploying new lease portfolios.
   - Allows any user (landlord) to initialize their own independent `PropertyLease` contract.
   - Maps and tracks deployed portfolios securely to the deploying wallet address.

2. **`PropertyLease.sol` (The Core Logic)**
   - Manages the state, financial routing, and time-based mechanics of individual leases.
   - Handles the secure escrow of Ethereum-based security deposits.
   - Tracks monthly rent payments and automatically increments payment due dates.

## 🔒 Key Features & Technical Implementations

- **Role-Based Access Control (RBAC):** Custom `onlyOwner` and `onlyTenant` modifiers ensure that only authorized wallets can interact with specific state-altering functions (e.g., only a tenant can pay rent, only a landlord can terminate a lease).
- **Secure Fund Routing:** Utilizes `payable` functions to handle raw ETH/Wei securely, separating the security deposit escrow from the withdrawable rent treasury to prevent commingling of funds.
- **Time-Locked Mechanics:** Integrates Solidity's global `block.timestamp` and native time units (`days`) to manage recurring payment schedules dynamically.
- **Optimized Data Structures:** Uses highly efficient mappings and custom `structs` to handle property and tenant data, minimizing gas consumption during state updates.

## 💻 Tech Stack
- **Language:** Solidity `^0.8.19`
- **Environment:** Remix IDE
- **Version Control:** Git / GitHub

---
*Developed by Katlego Sebona*