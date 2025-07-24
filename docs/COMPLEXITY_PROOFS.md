<!-- docs/COMPLEXITY_PROOFS.md -->
# Informal Complexity Proofs (Readable) - see proofs/viper_complexity.lean for the formal statements in Lean 4

## Theorem 1 — Linear Sequence Scaling
Per‑layer cost  
\(T_{HS}(L,d,k)=L·d + k·L·d^{2}\), \(k≤0.2\).  
Transformer cost  
\(T_{TX}(L,d)=L^{2}·d + L·d^{2}\).  
For \(L > 4d\) ⇒ \(T_{HS} / T_{TX} < 0.29\).

### Proof Sketch
1. Drop constant factors; compare dominating terms.  
2. Substitute \(k=0.2\).  
3. Ratio simplifies to \(\frac{d + 0.2d^{2}}{L·d + d^{2}}\).  
4. With \(L > 4d\) the denominator grows ≥ 4× faster, giving < 0.29.

## Theorem 2 — Active Parameter Bound
Let \(N=32\) experts, Top‑2 gating, token dropout \(p=0.2\).  
Expected active fraction \(E[α]=p·2/N = 0.0125 < 0.2\).

---
