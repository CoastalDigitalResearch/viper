<!-- docs/EXECUTION_FRAMEWORK.md -->
# Viper Execution Framework

| Phase | Task | Done When |
|-------|------|-----------|
| **0 Env** | `pip install -r requirements.txt` (`muon`, `jax`, `alpa`, `flash‑attention==2.5.2`) | All deps resolve |
| **1 Baseline** | Train & profile 8 B Transformer on CodePile. | `baseline.json` saved |
| **2 Prototype** | Integrate Selective‑SSM + Hyena + MoE in JAX. | `unit_tests/` pass |
| **3 Pre‑train** | 1 T tokens, 256× A100, cosine LR 3 e‑4. | Validation loss ≤1 % of baseline |
| **4 Fine‑tune** | 24 h, single A100‑80 G, Muon optimiser (see `optimizer_cfg.yaml`). | HumanEval‑IT ≥95 % baseline |
| **5 Quantise** | GPT‑Q 4‑bit; run regression. | Δaccuracy ≤ 5 % |
| **6 Benchmark** | Record FLOPs, mem, latency vs. baseline. | `perf_report.md` committed |
| **7 Ablate** | Sweep {k, segment len, #experts}. | Pareto front plotted |

Rollback if update‑norm ratio (Muon / AdamW) > 10× for 100 steps.

---
