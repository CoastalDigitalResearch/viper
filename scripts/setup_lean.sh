#!/bin/bash
# Lean 4 Setup Script for Formal Verification
# Sets up Lean 4 environment for complexity proofs

set -e

echo "=== Setting up Lean 4 for Formal Verification ==="

# Check if Lean is already installed
if command -v lean &> /dev/null; then
    lean_version=$(lean --version | head -n1)
    echo "Lean already installed: $lean_version"
else
    echo "Installing Lean 4..."
    
    # Install elan (Lean version manager)
    curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh -s -- -y
    
    # Add to PATH
    export PATH="$HOME/.elan/bin:$PATH"
    
    # Install latest Lean 4
    elan install leanprover/lean4:stable
    elan default leanprover/lean4:stable
fi

# Set up Mathlib cache
echo "Setting up Mathlib cache..."
cd proofs/
lake exe cache get!

echo "Verifying Lean installation..."
lean --version

echo "Testing complexity proofs..."
lean viper_complexity.lean

echo
echo "=== Lean 4 Setup Complete ==="
echo "Formal proofs can now be verified with: lean proofs/viper_complexity.lean"