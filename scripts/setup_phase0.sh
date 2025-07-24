#!/bin/bash
# Phase 0 Environment Setup Script
# Sets up all dependencies needed for viper development

set -e  # Exit on any error

echo "=== Viper Phase 0 Setup ==="
echo "Setting up environment for hierarchically-sparse mixture state-space model"
echo

# Check Python version
echo "Checking Python version..."
python_version=$(python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
echo "Python version: $python_version"

if ! python -c "import sys; sys.exit(0 if sys.version_info >= (3, 9) else 1)"; then
    echo "ERROR: Python 3.9+ required, found $python_version"
    exit 1
fi

# Check for CUDA
echo "Checking CUDA availability..."
if command -v nvcc &> /dev/null; then
    nvcc_version=$(nvcc --version | grep "release" | sed -n 's/.*release \([0-9.]*\).*/\1/p')
    echo "NVCC version: $nvcc_version"
else
    echo "WARNING: NVCC not found. CUDA compilation may fail."
fi

# Install PyTorch first (needed for other dependencies)
echo "Installing PyTorch..."
pip install torch>=1.12.0 --index-url https://download.pytorch.org/whl/cu118

# Verify PyTorch CUDA
echo "Verifying PyTorch CUDA support..."
python -c "import torch; print(f'PyTorch CUDA available: {torch.cuda.is_available()}')" || {
    echo "ERROR: PyTorch CUDA verification failed"
    exit 1
}

# Install JAX with CUDA support
echo "Installing JAX with CUDA support..."
pip install -U "jax[cuda12_pip]" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

# Install remaining dependencies
echo "Installing remaining dependencies..."
pip install -r requirements.txt --no-deps  # Avoid conflicts

# Test all imports
echo "Testing dependency compatibility..."
python scripts/test_compatibility.py

echo
echo "=== Phase 0 Setup Complete ==="
echo "Next steps:"
echo "1. Run: python scripts/test_compatibility.py"
echo "2. Proceed to Phase 1: Baseline training"
echo