#!/usr/bin/env python3
"""
Phase 0 Compatibility Test Script
Tests that all viper dependencies can be imported and are compatible.
"""

import sys
import subprocess
from typing import Dict, List, Tuple

def test_import(module_name: str, package_name: str = None) -> Tuple[bool, str]:
    """Test if a module can be imported."""
    if package_name is None:
        package_name = module_name
    
    try:
        __import__(module_name)
        return True, f"✓ {package_name} imported successfully"
    except ImportError as e:
        return False, f"✗ {package_name} import failed: {e}"
    except Exception as e:
        return False, f"✗ {package_name} unexpected error: {e}"

def check_cuda_compatibility() -> Tuple[bool, str]:
    """Check CUDA compatibility across PyTorch and JAX."""
    try:
        import torch
        import jax
        
        torch_cuda = torch.cuda.is_available()
        jax_cuda = len(jax.devices('gpu')) > 0
        
        if torch_cuda and jax_cuda:
            return True, f"✓ CUDA available in both PyTorch and JAX"
        elif torch_cuda:
            return False, f"✗ CUDA available in PyTorch but not JAX"
        elif jax_cuda:
            return False, f"✗ CUDA available in JAX but not PyTorch"
        else:
            return False, f"✗ CUDA not available in either framework"
            
    except Exception as e:
        return False, f"✗ CUDA compatibility check failed: {e}"

def check_version_compatibility() -> List[Tuple[bool, str]]:
    """Check specific version requirements."""
    results = []
    
    # Check flash-attention version
    try:
        import flash_attn
        version = flash_attn.__version__
        if version == "2.5.2":
            results.append((True, f"✓ flash-attention version {version} matches requirement"))
        else:
            results.append((False, f"✗ flash-attention version {version} != 2.5.2"))
    except ImportError:
        results.append((False, "✗ flash-attention not installed"))
    
    # Check Python version compatibility
    python_version = sys.version_info
    if python_version >= (3, 9):
        results.append((True, f"✓ Python {python_version.major}.{python_version.minor} >= 3.9"))
    else:
        results.append((False, f"✗ Python {python_version.major}.{python_version.minor} < 3.9"))
    
    return results

def main():
    """Run all compatibility tests."""
    print("=== Phase 0 Dependency Compatibility Test ===\n")
    
    # Core dependencies
    core_deps = [
        ("torch", "torch"),
        ("triton", "triton"), 
        ("ninja", "ninja"),
        ("einops", "einops"),
        ("transformers", "transformers"),
        ("packaging", "packaging"),
    ]
    
    # Viper-specific dependencies
    viper_deps = [
        ("muon", "muon"),
        ("jax", "jax"),
        ("alpa", "alpa"),
        ("flash_attn", "flash-attention"),
    ]
    
    # Development dependencies
    dev_deps = [
        ("pytest", "pytest"),
        ("hypothesis", "hypothesis"),
    ]
    
    all_passed = True
    
    # Test core dependencies
    print("Core Mamba Dependencies:")
    for module, package in core_deps:
        success, message = test_import(module, package)
        print(f"  {message}")
        if not success:
            all_passed = False
    
    print("\nViper-Specific Dependencies:")
    for module, package in viper_deps:
        success, message = test_import(module, package)
        print(f"  {message}")
        if not success:
            all_passed = False
    
    print("\nDevelopment Dependencies:")
    for module, package in dev_deps:
        success, message = test_import(module, package)
        print(f"  {message}")
        if not success:
            all_passed = False
    
    # Check CUDA compatibility
    print("\nCUDA Compatibility:")
    success, message = check_cuda_compatibility()
    print(f"  {message}")
    if not success:
        all_passed = False
    
    # Check version compatibility
    print("\nVersion Compatibility:")
    for success, message in check_version_compatibility():
        print(f"  {message}")
        if not success:
            all_passed = False
    
    print(f"\n=== Summary ===")
    if all_passed:
        print("✓ All dependencies compatible! Phase 0 environment ready.")
        sys.exit(0)
    else:
        print("✗ Some dependencies failed. Check installation.")
        sys.exit(1)

if __name__ == "__main__":
    main()