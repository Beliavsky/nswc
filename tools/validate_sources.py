"""Compile all source versions and compare representative numerical results."""

import argparse
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler", default="gfortran", help="GNU Fortran executable")
    args = parser.parse_args()
    baseline = None
    with tempfile.TemporaryDirectory(prefix="nswc-validation-") as folder:
        for source in ("nswc_orig.f", "nswc.f", "nswc.f90"):
            executable = Path(folder) / (source.replace(".", "_") + ".exe")
            command = [args.compiler, "-std=legacy", "-fallow-argument-mismatch",
                       str(ROOT / source), str(ROOT / "tests/source_smoke.f90"),
                       "-o", str(executable)]
            compiled = subprocess.run(command, capture_output=True, text=True)
            if compiled.returncode:
                print(compiled.stderr)
                return 1
            result = subprocess.run([str(executable)], capture_output=True, text=True)
            if result.returncode:
                print(f"{source}: numerical check failed\n{result.stdout}\n{result.stderr}")
                return 1
            if baseline is not None and result.stdout != baseline:
                print(f"{source}: numerical output differs from the original")
                return 1
            baseline = result.stdout
            print(f"{source}: compiled; numerical checks passed "
                  f"({compiled.stderr.count('Warning:')} compiler warnings)")
    print("All three versions produced identical smoke-test output.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
