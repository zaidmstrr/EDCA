## Formal Verification 
In this section, we employ the Lean 4 theorem prover [@demoura2021] to
formally verify the core mathematical guarantees of the proposed
consensus and reward mechanisms. Using the `Mathlib` library
[@mathlib2020], we prove the algebraic safety, zero-sum settlement
conservation, and the theoretical resistance to various adversarial
attack vectors. All proofs have been compiled and mathematically
verified using Lean version `v4.33.0-rc2`.

### 1. Truncation Shift Theorem
The following proof verifies that pruning an historical cohort updates an active miner's payout percentage strictly by $\Delta P = \frac{\epsilon(P - q_A)}{W - \epsilon}$, preventing arbitrary value destruction. [View the Lean Proof](Truncation_Shift.lean)

### 2. Dust Redistribution Conservation
The following proof verifies the safety of the base-layer settlement mechanism. It proves that proportionally distributing the aggregated dust ($D_{total}$) among the active set mathematically guarantees that the sum of the final outputs perfectly equals the total block reward ($A_{total}$), ensuring no fractional Satoshis are created or destroyed. [View the Lean Proof](Dust_Redistribution.lean)


### 3. Sybil Resistance
In many cryptographic protocols (such as quadratic funding or specific proof-of-stake voting models), reward equations scale non-linearly based on user count, making them highly vulnerable to Sybil attacks. EDCA's decay factor ($r$) is applied uniformly to the cohort batch rather than scaling by an individual miner's hashrate size, ensuring the payout function is strictly linear. 

Because the protocol is strictly linear, an attacker gains zero mathematical advantage by splitting their hashrate. For example, 10\% of a block reward split across 100 node identities is mathematically identical to 10\% of the reward kept whole. Furthermore, a Sybil attacker incurs a severe economic penalty: settling payouts to multiple identities forces the attacker to pay external network transaction fees to recombine those UTXOs later. The Nash Equilibrium is therefore to mine under a single identity.

We formalize this property in Lean by first proving the baseline 2-split case. Using Lean's \texttt{ring} tactic, we confirm that the scoring formula strictly distributes across two identities. We then generalize this to an $N$-split partition. By applying structural induction over an arbitrary list of workloads, the proof guarantees that dividing hashrate across $N$ distinct identities results in the exact same cumulative payout. [View the Lean Proof](Sybil.lean)

## 4. MEV Opportunity Cost 
When high-value Miner Extractable Value (MEV) enters the mempool, legacy pool miners are incentivized to disconnect and solo-mine the block. Because EDCA distributes the amplified block reward across all retained historical shares, a whale who disconnects forfeits their expected share of that amplified pool reward. The Expected Value (EV) of solo-mining a block is identical to the EV of mining it inside the pool; therefore, applying a decay penalty to a hopper's historical score results in a strict mathematical loss.  

Assume a block reward of $4.0$ BTC, a decay factor of $r = 0.80$, and an attacker with 10% of the network hashrate.  Choice A (Loyal): 10% of the $4.0$ BTC pool reward = 0.40 BTC EV.  Choice B (Hopping): 10% probability to solo-mine $4.0$ BTC = $+0.40$ BTC EV. However, missing the newest pool batch vaporizes 20% of their historical pool weight ($-0.08$ BTC). Total = $0.32$ BTC EV.  The compiler formally guarantees that the opportunity cost of leaving the pool grows in exact, direct proportion to the MEV the attacker attempts to steal.

The following Lean proof formally guarantees that the opportunity cost of leaving the pool grows in exact, direct proportion to the MEV the attacker attempts to steal, rendering the attack mathematically irrational. [View the Lean Proof](MevCost.lean)

## 5. Share Withholding
In a linear blockchain, "Selfish Mining" succeeds because block withholding forces a race to orphan honest chain tips. EDCA operates on a Directed Acyclic Graph (DAG), meaning concurrent shares are never orphaned; they are merged. Consequently, the only mechanical effect of withholding a share is artificially increasing its topological age.

Because the decay factor ($r$) is strictly bounded below $1$, artificially increasing a share's age mathematically decreases its final payout weight. Intra-batch withholding might allow an attacker to temporarily escape the formal decay penalty, but it provides zero economic upside because the DAG still merges their withheld shares concurrently with the honest shares. Honest work never vanishes. Therefore, intra-batch withholding has an expected value gain of $0$, but carries a high risk of accidentally crossing the batch boundary due to network latency, which would trigger a strict mathematical penalty. The Nash Equilibrium remains to broadcast instantly. [View the Lean Proof](Withholding.lean)