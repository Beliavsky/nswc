"""Build standalone numerical tests against each NSWC source version."""

import argparse
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SOURCES = ("nswc_orig.f", "nswc.f", "nswc.f90")


def test_programs(root=ROOT):
    return [root / "tests/source_smoke.f90", *sorted((root / "tests/fortran").glob("test_*.f90"))]


def run(command, folder, timeout):
    return subprocess.run(command, cwd=folder, capture_output=True, text=True,
                          timeout=timeout, stdin=subprocess.DEVNULL)


def check_result(result, program, baseline):
    if result.returncode:
        raise RuntimeError(f"Exit {result.returncode}\n{result.stdout}\n{result.stderr}")
    if f"{program}: PASS" not in result.stdout:
        raise RuntimeError(f"Missing completion marker (possible premature STOP)\n{result.stdout}\n{result.stderr}")
    if program in baseline and result.stdout != baseline[program]:
        raise RuntimeError(f"Output differs between source versions\n{result.stdout}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--compiler", default="gfortran", help="GNU Fortran executable")
    parser.add_argument("--source", choices=SOURCES, action="append",
                        help="Test only the selected version(s); default: all three")
    parser.add_argument("--test", action="append", help="Select a program by filename stem; repeatable")
    parser.add_argument("--timeout", type=float, default=30, help="Seconds allowed per test execution")
    args = parser.parse_args()
    if Path(args.compiler).is_file():
        args.compiler = str(Path(args.compiler).resolve())
    programs = test_programs()
    if args.test:
        unknown = set(args.test) - {p.stem for p in programs}
        if unknown:
            parser.error(f"Unknown test(s): {', '.join(sorted(unknown))}")
        programs = [p for p in programs if p.stem in args.test]
    if args.timeout <= 0:
        parser.error("--timeout must be positive")
    baseline = {}
    failures = []
    passed = 0
    with tempfile.TemporaryDirectory(prefix="nswc-validation-") as folder:
        for source in args.source or SOURCES:
            obj = Path(folder) / (source.replace(".", "_") + ".o")
            try:
                compiled = run([args.compiler, "-c", "-std=legacy",
                                "-fno-allow-argument-mismatch" if source == "nswc.f90" else "-fallow-argument-mismatch",
                                str(ROOT / source), "-o", str(obj)], folder, 180)
                if compiled.returncode:
                    print(f"{source}: library compilation failed\n{compiled.stderr}", flush=True)
                    failures.append(source)
                    continue
                print(f"{source}: compiled ({compiled.stderr.count('Warning:')} warnings)", flush=True)
            except (OSError, subprocess.TimeoutExpired) as error:
                print(f"{source}: {error}", flush=True)
                failures.append(source)
                continue
            for program in programs:
                label = f"{source} / {program.stem}"
                executable = Path(folder) / (program.stem + ".exe")
                try:
                    linked = run([args.compiler, "-std=legacy", "-ffpe-trap=invalid,zero,overflow",
                                  str(program), str(obj),
                                  "-o", str(executable)], folder, 60)
                    if linked.returncode:
                        raise RuntimeError(f"Test compilation failed\n{linked.stderr}")
                    result = run([str(executable)], folder, args.timeout)
                    check_result(result, program.stem, baseline)
                    baseline[program.stem] = result.stdout
                    passed += 1
                    print(f"PASS: {label}", flush=True)
                except (OSError, subprocess.TimeoutExpired, RuntimeError) as error:
                    failures.append(label)
                    print(f"FAIL: {label}\n{error}", flush=True)
    print(f"{passed} numerical test runs passed; {len(failures)} failures.", flush=True)
    return int(bool(failures))


if __name__ == "__main__":
    raise SystemExit(main())
