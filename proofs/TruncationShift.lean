import Mathlib

theorem truncation_shift 
  (W w_A P ε q_A : ℝ) (hW : W ≠ 0) 
  (h_diff : W - ε ≠ 0) (h_P : w_A = P * W) :
  (w_A - q_A * ε) / (W - ε) - (w_A / W) = 
  (ε * (P - q_A)) / (W - ε) := by
  
  rw [h_P]       -- Express active weight in terms of pool proportion
  field_simp     -- Safely clear denominators using non-zero assumptions
  ring           -- Verify algebraic equivalence of the expanded polynomials