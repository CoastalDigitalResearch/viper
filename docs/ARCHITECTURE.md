<!-- docs/ARCHITECTURE.md -->
# viper: A Hierarchically‑Sparse Mixture State‑Space Model

## Objective
An 8 B‑parameter language model tuned for IT / code tasks with **≥3 ×** computational efficiency over same‑size Transformers while retaining ≥95 % task accuracy.

## High‑Level Design
| Module | Purpose | Complexity | Active Params |
|--------|---------|------------|---------------|
| **Token Pre‑Processor** | Byte‑pair tokens → routing tags (`syntax`, `semantic`, `control`). | O(L) | – |
| **Tier‑1 Selective‑SSM** | Local structure (≤256 tok) via gated state‑space ops. | O(L·d) | 100 % |
| **Tier‑2 MoE (Top‑2)** | Semantic reasoning via 32 experts (2‑layer GMLP each). | O(k·L·d²), k ≤ 0.2 | ≤20 % |
| **Hyena Conveyor** | Long‑range context through sub‑quadratic conv. | O(L·log L) | 100 % |
| **Output Head** | Projection to vocab. | O(d·V) | 100 % |

Total parameters: **7.43 B**, resident weight after 4‑bit quant = **≈3.7 B**.

## Routing Logic
1. Pre‑processor classifies each token.
2. Router assigns token to ≤2 experts based on combined tag + hidden state.
3. Load‑balance loss keeps traffic even; expected utilisation ≤0.2.

---
