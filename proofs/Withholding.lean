import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

-- Define single independent topological share value
noncomputable def share_value (r : ℝ) (age : ℕ) (work : ℝ) : ℝ :=
  work * r^age

/-- Strict Inequality of Topological Delay --/
theorem share_withholding_is_punished
  (r : ℝ) (hr1 : 0 < r) (hr2 : r < 1)         -- Base bounded strictly between 0 and 1
  (work : ℝ) (h_work : 0 < work)              -- Miner workload is strictly positive
  (age delay : ℕ) (h_delay : 0 < delay) :     -- Topological delay is strictly positive
  share_value r age work > share_value r (age + delay) work := by
  
  unfold share_value                          -- Expand share value definition
  
  -- Establish strict inequality of the topological exponents
  have h_age_lt : age < age + delay := by linarith
  
  -- Apply fractional exponent limit mapping for bases < 1
  have h_pow_lt : r^(age + delay) < r^age := by 
    exact pow_lt_pow_right_of_lt_one₀ hr1 hr2 h_age_lt
    
  -- Resolve non-linear arithmetic scale using bounded scalar
  nlinarith [h_pow_lt, h_work]