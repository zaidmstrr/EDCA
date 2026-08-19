import Mathlib
open Finset

theorem dust_redistribution_conservation
  {ι : Type*} (active_set : Finset ι)
  (O : ι → ℝ) (D_total A_total O_active : ℝ)
  (h_O_active : O_active = ∑ i ∈ active_set, O i)
  (h_O_active_nz : O_active ≠ 0)
  (h_total : O_active + D_total = A_total) :
  (∑ i ∈ active_set, (O i + (O i / O_active) * D_total)) = A_total := by
  
  rw [sum_add_distrib]
  rw [← h_O_active]
  
  have h_inner : ∀ i, (O i / O_active) * D_total = O i * (D_total / O_active) := by
    intro i
    ring
    
  simp_rw [h_inner]
  rw [← sum_mul, ← h_O_active]
  
  have h_cancel : O_active * (D_total / O_active) = D_total := by
    exact mul_div_cancel₀ D_total h_O_active_nz
    
  rw [h_cancel]
  exact h_total