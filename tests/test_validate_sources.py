"""Guard against false passes in the executable test runner."""

from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
from validate_sources import check_result, run, test_programs


class ValidationRunnerTests(unittest.TestCase):
    def test_all_standalone_programs_are_discovered(self):
        programs = test_programs()
        self.assertEqual(len(programs), 15)
        self.assertEqual(len({p.stem for p in programs}), len(programs))
        for path in programs:
            text = path.read_text()
            self.assertIn(path.stem + ": PASS", text)

    def test_nonzero_exit_is_not_hidden_by_pass_marker(self):
        result = subprocess.CompletedProcess([], 1, "driver: PASS\n", "failed")
        with self.assertRaisesRegex(RuntimeError, "Exit 1"):
            check_result(result, "driver", {})

    def test_premature_stop_is_not_a_pass(self):
        result = subprocess.CompletedProcess([], 0, "", "STOP")
        with self.assertRaisesRegex(RuntimeError, "Missing completion marker"):
            check_result(result, "driver", {})

    def test_version_output_comparison(self):
        output = "1.0\ndriver: PASS\n"
        result = subprocess.CompletedProcess([], 0, output, "")
        check_result(result, "driver", {})
        check_result(result, "driver", {"driver": output})
        with self.assertRaisesRegex(RuntimeError, "Output differs"):
            check_result(result, "driver", {"driver": "2.0\ndriver: PASS\n"})

    def test_run_isolated_and_noninteractive(self):
        with tempfile.TemporaryDirectory() as folder:
            code = "import os,sys; print(os.getcwd()); print(repr(sys.stdin.read()))"
            result = run([sys.executable, "-c", code], folder, 10)
            self.assertEqual(result.returncode, 0)
            self.assertEqual(Path(result.stdout.splitlines()[0]).resolve(), Path(folder).resolve())
            self.assertEqual(result.stdout.splitlines()[1], "''")

    def test_timeout_is_enforced(self):
        with tempfile.TemporaryDirectory() as folder:
            with self.assertRaises(subprocess.TimeoutExpired):
                run([sys.executable, "-c", "import time; time.sleep(10)"], folder, 0.1)


if __name__ == "__main__":
    unittest.main()
