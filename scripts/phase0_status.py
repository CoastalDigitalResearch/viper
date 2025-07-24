#!/usr/bin/env python3
"""
Phase 0 Status Check
Verifies Phase 0 completion according to EXECUTION_FRAMEWORK.md:
"Done When: All deps resolve"
"""

import subprocess
import sys
from pathlib import Path

def check_phase0_completion() -> bool:
    """Check if Phase 0 is complete according to execution framework."""
    print("=== Phase 0 Status Check ===")
    print("According to EXECUTION_FRAMEWORK.md:")
    print("Phase 0 is 'Done When: All deps resolve'")
    print()
    
    # Run compatibility test
    try:
        result = subprocess.run([
            sys.executable, "scripts/test_compatibility.py"
        ], capture_output=True, text=True)
        
        if result.returncode == 0:
            print("✓ Phase 0 COMPLETE: All dependencies resolve successfully")
            print()
            print("Ready to proceed to Phase 1: Baseline Training")
            return True
        else:
            print("✗ Phase 0 INCOMPLETE: Some dependencies failed")
            print()
            print("To complete Phase 0, run:")
            print("  ./scripts/setup_phase0.sh")
            print()
            print("Failure details:")
            print(result.stdout)
            return False
            
    except Exception as e:
        print(f"✗ Phase 0 status check failed: {e}")
        return False

def main():
    """Main status check."""
    success = check_phase0_completion()
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()