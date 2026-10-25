"""Guard reviewed declaration changes and preserve diagnostic output exactly."""
import copy
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
from explicit_typing import digest, units
from name_procedure_ends import ConversionError, statements
from reviewed_source_fixes import apply_fixes, normalize_reviewed_symbols, check_warning_inventory, DEFAULT_MANIFEST


class ReviewedSourceFixTests(unittest.TestCase):
    source = b'      SUBROUTINE S(X)\n      REAL X(3)\n      END SUBROUTINE S\n'

    def manifest(self):
        after = self.source.replace(b'X(3)', b'X(2)')
        return {'procedures': {'S': {'before_sha256': digest(self.source), 'after_sha256': digest(after),
                'replacements': [{'before': 'X(3)', 'after': 'X(2)'}]}}}

    def test_hash_guarded_application_and_idempotence(self):
        m = self.manifest()
        changed = apply_fixes(self.source, m)
        self.assertIn(b'X(2)', changed)
        self.assertEqual(apply_fixes(changed, m), changed)
        self.assertEqual(changed.count(b'\n'), self.source.count(b'\n'))
        with self.assertRaisesRegex(ConversionError, 'changed'):
            apply_fixes(self.source.replace(b'X(3)', b'X(4)'), m)

    def test_result_hash_rejects_tampered_replacements(self):
        m = self.manifest()
        m['procedures']['S']['replacements'][0]['after'] = 'X(1)'
        with self.assertRaisesRegex(ConversionError, 'Unexpected'):
            apply_fixes(self.source, m)

    def test_physical_line_and_column_guards(self):
        for text in ('X(2)\n      CONTINUE', 'X' * 80):
            m = self.manifest()
            m['procedures']['S']['replacements'][0]['after'] = text
            with self.assertRaisesRegex(ConversionError, 'physical lines'):
                apply_fixes(self.source, m)

    def test_symbol_corrections_require_both_recorded_endpoints(self):
        m = json.loads(DEFAULT_MANIFEST.read_text())
        before, after = {}, {}
        for r in m['symbol_reviews']:
            before.setdefault(r['procedure'], {})[r['symbol']] = r['before']
            after.setdefault(r['procedure'], {})[r['symbol']] = r['after']
        self.assertEqual(normalize_reviewed_symbols(before, after, m), before)
        variant = copy.deepcopy(after)
        variant['ITERT']['rhfcn']['attributes'] = variant['ITERT']['rhfcn']['attributes'].replace(' ARRAY-OUTER-DEPENDENCY', '')
        self.assertEqual(normalize_reviewed_symbols(before, variant, m), before)
        for scope, symbol, field, value in [('DQDCRT', 'zr', 'Array spec', 'wrong bound'),
                                             ('ITERT', 'rhfcn', 'type spec', 'type spec : (REAL 8)')]:
            changed = copy.deepcopy(after)
            changed[scope][symbol][field] = value
            with self.assertRaisesRegex(ConversionError, 'did not confirm'):
                normalize_reviewed_symbols(before, changed, m)

    def test_warning_inventory_rejects_missing_added_or_relocated_warnings(self):
        m = {'remaining_warnings': [{'procedure': 'S', 'pattern': 'reviewed warning'}]}
        text = 'source.f:2:8:\nWarning: reviewed warning\n'
        self.assertEqual(check_warning_inventory(text, self.source, m), 1)
        for stderr in ('', text + text, text.replace('reviewed warning', 'new warning'),
                       text.replace(':2:8:', ':99:8:')):
            with self.assertRaises(ConversionError):
                check_warning_inventory(stderr, self.source, m)

    @unittest.skipUnless(shutil.which('gfortran'), 'GNU Fortran required')
    def test_original_and_quoted_formats_emit_identical_bytes(self):
        def program(data):
            lines, scopes = units(data)
            parts = ['      PROGRAM CHECK_FORMATS\n', '      CALL EMIT_MACH1\n',
                     '      CALL EMIT_MACH2\n', '      END\n']
            for name in ('MACH1', 'MACH2'):
                start, _, end = scopes[name]
                parts += [f'      SUBROUTINE EMIT_{name}\n', '      WRITE(*,200) 123\n',
                          '      WRITE(*,210) 456\n', '      WRITE(*,230)\n', '      WRITE(*,240)\n']
                body = lines[start:end]
                for statement in statements(body):
                    if statement.code.strip().upper().startswith('FORMAT'):
                        parts.extend(body[i] for i in statement.lines)
                parts.append('      END\n')
            return ''.join(parts).encode('latin-1')
        outputs = []
        with tempfile.TemporaryDirectory(prefix='nswc-formats-') as folder:
            for filename in ('nswc_orig.f', 'nswc.f'):
                source = Path(folder) / 'formats.f'
                source.write_bytes(program((ROOT / filename).read_bytes()))
                executable = Path(folder) / 'formats.exe'
                build = subprocess.run(['gfortran', '-std=legacy', str(source), '-o', str(executable)],
                                       capture_output=True, timeout=60)
                self.assertEqual(build.returncode, 0, build.stderr.decode())
                result = subprocess.run([str(executable)], capture_output=True, timeout=10)
                self.assertEqual(result.returncode, 0, result.stderr.decode())
                outputs.append(result.stdout)
        self.assertTrue(outputs[0])
        self.assertEqual(outputs[0], outputs[1])


if __name__ == '__main__':
    unittest.main()
