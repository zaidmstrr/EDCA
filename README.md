
# Block-Settled EDCA
**Exponentially Decayed Cohort Average for Decentralized DAG Mining Pools**

[![Formal Verification](https://img.shields.io/badge/Verified-Lean%204-blue.svg)](#2-formal-verification)
[![Protocol Specification](https://img.shields.io/badge/Specification-Available-success.svg)](./PAPER.md)

This repo contains the new decentralization payout algorithm specifically created for mining pools based on the Directed-Acyclic-Graph (DAG) architecture. Standard payout algorithms like PPLNS, the geometric method, and shift-PPLNS are traditional approaches that are designed for the linear share chains and rely on sequential state transitions. This runs on a decentralized Directed Acyclic Graph, which can process and add shares concurrently, ensuring that the work from two different miners will be treated as the same if it lies in the very few fraction of time difference and refers to the same DAG tip. 

## Core Protocol Guarantees

By strictly bounding the mathematics to the topological reality of a DAG, Block-Settled EDCA formally guarantees the following game-theoretic defenses:

1. **State Truncation Safety:** To prevent unbounded memory bloat, historical cohorts that decay below the base-layer economic dust limit are dynamically pruned. The Truncation Shift theorem formally guarantees that this continuous pruning preserves exact relative payout equity, ensuring no miner loses settleable value while permanently capping the network's active ledger to a strict $O(1)$ memory footprint.
2. **Zero-Sum Dust Redistribution:** Decentralized payouts natively risk generating unspendable sub-dust UTXOs. The protocol deterministically aggregates and proportionally redistributes these sub-dust outputs to active miners prior to block template construction. This mathematically guarantees that exactly 100% of the block reward is settled on-chain, ensuring zero trapped value and zero destroyed Satoshis.
3. **Sybil Resistance ($N$-Split Linearity):** The payout function is strictly linear. Splitting hashrate across multiple node identities yields exactly zero mathematical advantage, forcing attackers to absorb maximum network fee friction.
4. **MEV "Fee Sniper" Defense:** The opportunity cost of abandoning the pool to solo-mine a high-fee block strictly scales with the amplified Miner Extractable Value (MEV). Pool-hopping is a mathematically negative Expected Value (EV) action.
5. **Selfish Mining Nullification:** Because DAGs merge concurrent shares rather than orphaning them, withholding a share artificially increases its topological age. The continuous exponential decay algorithm ensures that artificially aged shares receive a strictly lesser valuation, penalizing the attacker.

## Repository Navigation

This repository is divided into two primary sections: Protocol Design and Formal Verification

### 1. Protocol Specification
The complete academic and architectural specification for the EDCA mechanism. This document covers the transition from legacy variable-difficulty (Vardiff) systems to uniform difficulty ($D_{bp}$), the underlying economic equations, and the deterministic sub-dust UTXO redistribution logic.
* **[Read the Full Paper](./PAPER.md)**

### 2. Formal Verification
All game-theoretic and economic claims made in the protocol specification have been computationally verified using the **Lean 4** theorem prover. This directory contains the strict algebraic proofs confirming the protocol's linearity and decay bounds.

* **[Read the Economic Theory & Math Setup](/proofs/README.md)**
* **[Truncation Shift Theorem](/proofs/Truncation_Shift.lean)**
* **[Dust Redistribution Conservation](/proofs/Dust_Redistribution.lean)**
* **[Sybil Resistance (Base Case & $N$-Split)](/proofs/Sybil.lean)**
* **[MEV Opportunity Cost](/proofs/MevCost.lean)**
* **[Share Withholding Penalty](/proofs/Withholding.lean)**  

## Verifying the Proofs Locally

To compile and verify the mathematical proofs on your own machine, you will need the [Lean 4 toolchain](https://leanprover.github.io/lean4/doc/setup.html) installed or the web [Lean Compiler](https://live.lean-lang.org/).

## License & Copyright

Copyright (c) 2026 Mohd Zaid.

The protocol specifications, technical documentation, and mathematical proofs in this repository are licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/).  
You are free to share and adapt this material for any purpose, even commercially, provided you give appropriate credit to the original author(s) and distribute your contributions under the same license as the original.

Disclaimer: The Lean 4 proofs and mathematical models are provided "as is" and without warranty. Anyone implementing this protocol is responsible for their own real-world testing and network simulation.
