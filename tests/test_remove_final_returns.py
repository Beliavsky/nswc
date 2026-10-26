"""Terminal RETURN cleanup must preserve branch targets and return paths."""
from pathlib import Path
import shutil
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from remove_final_returns import transform_fixed, transform_free, verify


class FinalReturnTests(unittest.TestCase):
    def test_fixed_comments_line_endings_and_early_return(self):
        source = (b'      SUBROUTINE S(X)\r\n      INTEGER X\r\n'
                  b'      IF (X.LT.0) RETURN\r\n      X=X+1\r\n'
                  b'      RETURN\r\nC Keep this comment\r\n\r\n      END SUBROUTINE S\r\n')
        result = transform_fixed(source)
        self.assertEqual(result, source.replace(b'      RETURN\r\n', b''))
        self.assertEqual(transform_fixed(result), result)
        if shutil.which('gfortran'):
            verify(source, result, 'fixed')

    def test_protected_fixed_returns(self):
        for statement, arguments in [('   10 RETURN\n', ''), ('      RETURN 1\n', '*'),
                                     ('      RETURN ! keep\n', ''),
                                     ('      IF (.TRUE.) RETURN\n', ''),
                                     ('      RETURN\n   10 FORMAT(I4)\n', '')]:
            source = ('      SUBROUTINE S(' + arguments + ')\n' + statement + '      END SUBROUTINE S\n').encode()
            self.assertEqual(transform_fixed(source), source)
        sequence = ('      RETURN'.ljust(72) + '00001234\n').encode()
        source = b'      SUBROUTINE S()\n' + sequence + b'      END SUBROUTINE S\n'
        self.assertEqual(transform_fixed(source), source)

    def test_free_module_nested_interface_and_multiple_terminal_returns(self):
        source = '''module m
contains
integer function f(x)
integer, intent(in) :: x
interface
integer function g(x)
integer, intent(in) :: x
end function g
end interface
if (x < 0) return
f = g(x)
return
! preserve this comment
return
end function f
end module m
'''
        result, report = transform_free(source), {}
        self.assertEqual(result, source.replace('\nreturn\n', '\n'))
        self.assertEqual(transform_free(result, report), result)
        self.assertEqual(report['removed'], 0)
        if shutil.which('gfortran'):
            verify(source, result)

    def test_free_protected_returns_and_strings(self):
        for statement in ('10 return', 'return 1', 'return ! keep', 'if (.true.) return'):
            args = '*' if statement == 'return 1' else ''
            source = 'subroutine s(' + args + ")\nprint *, 'return'\n" + statement + '\nend subroutine s\n'
            self.assertEqual(transform_free(source), source)

    def test_hash_refresh_refuses_nonterminal_changes(self):
        from procedure_purity import code_hash
        from refresh_return_review_hashes import refresh
        old = 'subroutine s(x)\ninteger :: x\nx=x+1\nreturn\nend subroutine s\n'
        new = transform_free(old)
        manifest = {'procedures': {'S': {'source_hash': code_hash(old), 'calls': {'abs': 1}}}}
        updated, count = refresh(old, new, manifest)
        self.assertEqual(count, 1)
        self.assertEqual(updated['procedures']['S']['calls'], {'abs': 1})
        self.assertEqual(manifest['procedures']['S']['source_hash'], code_hash(old))
        with self.assertRaisesRegex(ValueError, 'RETURN-only'):
            refresh(old, new.replace('x+1', 'x+2'), manifest)
