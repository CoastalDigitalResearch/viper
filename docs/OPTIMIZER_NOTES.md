<!-- docs/OPTIMIZER_NOTES.md -->
# Muon Integration

* **Param split**: matrix weights → Muon; embeddings, biases, layer‑norm → AdamW.  
* **LRs**: Muon 0.02, AdamW 3 e‑4.  
* **Weight Decay**: 0.01 both.  
* **Scheduler**: 100‑step warm‑up, cosine decay.  
* **Precision**: bfloat16; Muon Newton‑Schulz steps = 5.  

See `training/utils.py` for `get_muon_param_groups`.

---
