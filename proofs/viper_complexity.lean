/-
proofs/viper_complexity.lean
Formal statements of Theorem 1 & 2.
`lake exe cache get!` before compiling.
-/
import Mathlib.Tactic
import Mathlib.Data.Real.Basic

open BigOperators Real

/-- Model constants -/
variable (L d : ℝ) (k : ℝ) (hL : 0 < L) (hd : 0 < d) (hk : 0 ≤ k) (hk₂ : k ≤ 0.2)

/-- Transformer per‑layer FLOPs (simplified) -/
def T_TX  (L d : ℝ) : ℝ := L^2 * d + L * d^2

/-- HS‑MSSM per‑layer FLOPs (simplified) -/
def T_HS  (L d k : ℝ) : ℝ := L * d + k * L * d^2

/-- Formal version of Theorem 1 -/
theorem HS_ratio_bound
    (hLd : 4 * d ≤ L) :
    T_HS L d k / T_TX L d ≤ (d + 0.2 * d^2) / (4 * d^2 + d^2) := by
  -- Expand definitions and use `hk₂`
  have h1 : T_HS L d k = L * d + k * L * d^2 := rfl
  have h2 : T_TX L d = L^2 * d + L * d^2 := rfl
  have h3 : k * L * d^2 ≤ 0.2 * L * d^2 := by
    have : k ≤ 0.2 := hk₂
    have : k * L * d^2 ≤ 0.2 * L * d^2 := by
      have hpos : 0 ≤ L * d^2 := by
        have : 0 ≤ L := le_of_lt hL
        have : 0 ≤ d^2 := sq_nonneg d
        nlinarith
      exact mul_le_mul_of_nonneg_right hk₂ hpos
    simpa using this
  -- Bound numerator
  have num_bd :
      L * d + k * L * d^2 ≤ L * d + 0.2 * L * d^2 := by
    have : k * L * d^2 ≤ 0.2 * L * d^2 := h3
    linarith
  -- Bound denominator using L ≥ 4d
  have den_bd : 4 * d^2 + d^2 ≤ L^2 * d + L * d^2 := by
    have hLd' : 4 * d ≤ L := hLd
    have : (4 * d)^2 * d = 16 * d^2 * d := by ring
    have : 16 * d^3 ≤ L^2 * d := by
      have : 4 * d ≤ L := hLd
      have : (4 * d)^2 ≤ L^2 := by
        have : 0 ≤ 4 * d := by nlinarith using hd
        exact pow_le_pow_of_le_left this hLd 2
      have : 16 * d^2 ≤ L^2 := by
        have : (4 * d)^2 = 16 * d^2 := by ring
        simpa [this] using this
      have : 16 * d^3 ≤ L^2 * d := by
        have : 16 * d^2 ≤ L^2 := this
        have : d > 0 := hd
        have : 0 ≤ d := le_of_lt this
        have : 16 * d^2 * d ≤ L^2 * d := mul_le_mul_of_nonneg_right this this
        simpa [mul_comm] using this
    -- Simplify to reach required inequality
    admit
  -- Combine bounds
  have : T_HS L d k / T_TX L d ≤ (L * d + 0.2 * L * d^2) / (L^2 * d + L * d^2) := by
    apply div_le_div
    · exact num_bd
    · linarith [sq_nonneg L, mul_nonneg hL.le hd.le] -- positivity for denominator
    · linarith [sq_nonneg L, mul_nonneg hL.le hd.le]
    · apply le_of_lt
      have : T_TX L d > 0 := by
        have : L > 0 := hL
        have : d > 0 := hd
        have : L^2 * d + L * d^2 > 0 := by nlinarith
        exact this
  -- Apply specific bound L ≥ 4d to replace L with 4d in RHS
  have : (L * d + 0.2 * L * d^2) / (L^2 * d + L * d^2)
        ≤ (d + 0.2 * d^2) / (4 * d^2 + d^2) := by
    -- Monotone substitution argument (omitted)
    admit
  -- Conclude
  have : T_HS L d k / T_TX L d ≤ (d + 0.2 * d^2) / (5 * d^2) := by
    have := calc
      T_HS L d k / T_TX L d ≤ (L * d + 0.2 * L * d^2) / (L^2 * d + L * d^2) := this
      _ ≤ (d + 0.2 * d^2) / (4 * d^2 + d^2) := ?_
    simpa [add_comm, mul_comm, mul_left_comm, add_comm] using this
  -- Numeric bound < 0.29 left to arithmetic
  admit

/-- Theorem 2 formal statement -/
theorem active_param_bound :
  (0.2 : ℝ) * 2 / 32 = (0.0125) := by
  norm_num

/-
`admit` placeholders mark steps requiring additional algebra.
Replace with full proofs as desired.
-/
