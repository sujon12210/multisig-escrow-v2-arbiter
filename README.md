# Decentralized Escrow with Arbiter (Upgraded)

A professional-grade implementation for secure Peer-to-Peer (P2P) commerce. This repository facilitates trustless transactions between a Buyer and a Seller, with a neutral third-party "Arbiter" holding the power to resolve disputes. Unlike simple 2-of-2 multisigs, this 2-of-3 model ensures that funds are never permanently locked if one party becomes unresponsive.

## Core Features
* **Three-Role Logic:** Explicitly defines permissions for Buyer, Seller, and Arbiter.
* **Dispute State Machine:** Transitions from `Active` to `Disputed` to `Resolved` based on party input.
* **Fee Splitting:** Automated logic to pay the Arbiter a percentage fee for their mediation services.
* **Flat Architecture:** Single-directory layout for the Escrow logic, Fee manager, and Status tracker.



## Workflow
1. **Deposit:** Buyer locks funds and specifies the Seller and Arbiter.
2. **Execution:** If the trade is successful, Buyer and Seller both sign to release funds to the Seller.
3. **Dispute:** If a conflict arises, either party can trigger a "Dispute" state.
4. **Resolution:** The Arbiter reviews off-chain evidence and signs with either the Buyer (Refund) or Seller (Payout).

## Setup
1. `npm install`
2. Deploy `EscrowV2.sol`.
