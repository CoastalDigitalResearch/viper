# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **viper** - a fork of Mamba SSM that implements a **Hierarchically-Sparse Mixture State-Space Model**. The goal is to create an 8B-parameter language model with ≥3× computational efficiency over Transformers while maintaining ≥95% task accuracy.

**Current Status**: The project is in design/planning phase with detailed architecture documentation but the innovative components are not yet implemented in the codebase.

## Unique Architecture (To Be Implemented)

### Core Innovation: Hierarchically-Sparse MoE
- **Token Pre-Processor**: Routes tokens by type (`syntax`, `semantic`, `control`)  
- **Tier-1 Selective-SSM**: Local structure (≤256 tokens) - O(L·d) complexity
- **Tier-2 MoE**: 32 experts with Top-2 gating - O(k·L·d²) where k ≤ 0.2
- **Hyena Conveyor**: Long-range context - O(L·log L) complexity
- **Target**: 7.43B total parameters, ≤20% active utilization

### Formal Mathematical Foundation
- Complexity proofs formalized in **Lean 4** (`proofs/viper_complexity.lean`)
- Theorem 1: Linear sequence scaling with L > 4d gives efficiency ratio < 0.29
- Theorem 2: Active parameter bound with expected fraction ≤ 0.0125

## Development Pipeline (7 Phases)

### Phase 0: Environment Setup
```bash
# Install specialized dependencies
pip install muon jax alpa flash-attention==2.5.2

# Standard Mamba dependencies  
pip install torch triton ninja einops transformers packaging
```

### Phase 1: Baseline Training
- Train 8B Transformer on CodePile dataset
- Generate `baseline.json` performance metrics

### Phase 2: Prototype Implementation
- Integrate Selective-SSM + Hyena + MoE in JAX
- All `unit_tests/` must pass

### Phase 3: Pre-training
- 1T tokens on 256× A100 GPUs
- Cosine LR schedule starting at 3e-4
- Target: validation loss ≤1% of baseline

### Phase 4: Fine-tuning
- 24h on single A100-80GB
- **Muon optimizer** for matrix weights (see optimizer configuration)

### Phase 5-7: Quantization, Benchmarking, Ablation
- GPT-Q 4-bit quantization
- Performance reporting vs baseline
- Hyperparameter sweeps

## Optimizer Strategy (Muon Integration)

### Parameter Splitting
- **Matrix weights** → Muon optimizer (LR: 0.02)
- **Embeddings, biases, layer-norm** → AdamW (LR: 3e-4)
- **Weight decay**: 0.01 for both
- **Precision**: bfloat16 with Newton-Schulz steps = 5

### Implementation Location
- See `training/utils.py` for `get_muon_param_groups()`

## Development Commands

### Standard Mamba Commands (Current Codebase)
```bash
# Installation
pip install .
MAMBA_FORCE_BUILD=TRUE pip install .  # Force local build

# Testing
pytest tests/
pytest tests/ops/test_selective_scan.py

# Benchmarking existing Mamba
python benchmarks/benchmark_generation_mamba_simple.py --model-name "state-spaces/mamba-2.8b"
```

### Viper-Specific Commands (To Be Implemented)
```bash
# Phase execution
python scripts/run_phase.py --phase 0  # Environment setup
python scripts/run_phase.py --phase 1  # Baseline training

# Complexity verification
lake exe cache get!  # For Lean proofs
lean proofs/viper_complexity.lean

# Training with Muon
python train_viper.py --config configs/viper_8b.yaml
```

## Critical Engineering Principles

### Test-Driven Development (Mandatory)
- **Red → Green → Refactor** cycle only
- No production code without failing tests
- 100% business-behavior coverage required

### Code Quality Standards
- **Python**: 3.12+, `ruff format`, `mypy --strict`, `pytest`
- **Immutable-first**: Pure functions, no hidden mutation
- **Property-based testing**: Use `hypothesis` for invariants
- **Result pattern**: No bare `except`, prefer Result[T, E]

### Safety Checks
- Rollback if Muon/AdamW update-norm ratio > 10× for 100 steps
- Validation loss monitoring during pre-training
- HumanEval-IT ≥95% baseline accuracy requirement

## Key Implementation Challenges

### 1. MoE Routing Logic
- Token classification by pre-processor
- Load-balance loss to maintain ≤20% utilization
- Top-2 gating across 32 experts

### 2. Memory Efficiency
- 4-bit quantization targeting ~3.7GB resident weights
- Sparse activation patterns
- Gradient accumulation strategies

### 3. Performance Validation
- Must achieve theoretical 3× speedup
- Maintain mathematical rigor per Lean proofs
- Benchmark against 8B Transformer baseline

## Current Limitations

- **Architecture not implemented**: Still uses standard Mamba components
- **Training pipeline missing**: JAX integration and Muon optimizer not present  
- **Evaluation framework**: HumanEval-IT benchmarking needs implementation
- **Formal verification**: Lean proof compilation not yet integrated in CI

## Next Development Steps

1. Implement token pre-processor for routing classification
2. Add MoE layer with 32 experts and Top-2 gating
3. Integrate Hyena convolution for long-range dependencies
4. Build Muon optimizer parameter grouping
5. Create JAX training pipeline for distributed pre-training