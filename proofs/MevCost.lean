import Mathlib

-- Define EDCA geometric score using standard division
noncomputable def miner_score (r : ℝ) (batches : ℕ) (work : ℝ) : ℝ :=
  work * (1 - r^batches) / (1 - r)

theorem mev_snipe_opportunity_cost 
  (r : ℝ) (batches : ℕ) (work B_base F_high : ℝ) 
  (h_batches : 1 ≤ batches) (h_r : 1 - r ≠ 0) :
  miner_score r batches work * (B_base + F_high) 
  - miner_score r (batches - 1) work * (B_base + F_high) 
  = work * (r^(batches - 1) - r^batches) / (1 - r) * (B_base + F_high) := by
  
  unfold miner_score
  
  -- Explicitly relate r^batches to r^(batches - 1)
  have h_pow : r ^ batches = r ^ (batches - 1) * r := by
    calc r ^ batches
      _ = r ^ ((batches - 1) + 1) := by rw [Nat.sub_add_cancel h_batches]
      _ = r ^ (batches - 1) * r ^ 1 := by rw [pow_add]
      _ = r ^ (batches - 1) * r     := by rw [pow_one]
      
  rw [h_pow]
  
  -- field_simp safely clears the (1 - r) denominators using assumption h_r.
  -- ring then verifies the resulting polynomial numerator equality.
  field_simp
  ring