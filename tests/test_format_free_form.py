"""Free-form layout, legacy control flow, literals and expression preservation."""
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from format_free_form import format_source, semantic_statements
from validate_free_formatting import without_unary_plus


class FreeFormattingTests(unittest.TestCase):
    def check(self, source, expected):
        formatted = format_source(source)
        self.assertEqual(formatted, expected)
        self.assertEqual(format_source(formatted), formatted)
        self.assertEqual(semantic_statements(source), semantic_statements(formatted))

    def test_labelled_do_with_executable_terminal(self):
        self.check('do 10 i = 1,m1\nj=j-1\ntemp=b1\nb1=tx*b1-b2+bb(j)\n10 b2=temp\nreturn\n',
                   'do 10 i = 1,m1\n   j = j - 1\n   temp = b1\n   b1 = tx*b1 - b2 + bb(j)\n10 b2 = temp\nreturn\n')

    def test_shared_terminal_and_block_do(self):
        self.check('do 20 i=1,n\ndo 20 j=1,n\nx=x+1\n20 continue\ndo k=1,n\nx=x-1\nend do\n',
                   'do 20 i = 1,n\n   do 20 j = 1,n\n      x = x + 1\n20    continue\ndo k = 1,n\n   x = x - 1\nend do\n')

    def test_arithmetic_and_logical_if(self):
        self.check('if(in)002,003,003\n002 if(in.eq.in/2*2)go to 003\n',
                   'if (in) 002,003,003\n002 if (in.eq.in/2*2) go to 003\n')

    def test_block_branches(self):
        self.check('if(x.gt.0)then\ndo i=1,n\nx=x+1\nend do\nelse if(x.lt.0)then\nx=-x\nelse\nx=0\nend if\n',
                   'if (x.gt.0) then\n   do i = 1,n\n      x = x + 1\n   end do\nelse if (x.lt.0) then\n   x = -x\nelse\n   x = 0\nend if\n')

    def test_binary_unary_and_exponent_signs(self):
        self.check('ts(1)=tm(1)*rz(1)-tm(2)*rz(2)\nts(1)=+tm(1)/an\nx=-1.0e-12+a*-b-(-c)\n',
                   'ts(1) = tm(1)*rz(1) - tm(2)*rz(2)\nts(1) = tm(1)/an\nx = -1.0e-12 + a*-b - (-c)\n')

    def test_literals_inline_comments_and_format_are_exact(self):
        self.check('x=+f("A+B!",\'Don\'\'t = X\') ! Leave X+Y alone\n10 format(\'X=+Y\',1pe12.4)\n',
                   'x = f("A+B!",\'Don\'\'t = X\') ! Leave X+Y alone\n10 format(\'X=+Y\',1pe12.4)\n')

    def test_continued_if_and_assignment(self):
        self.check('if(x.gt.0.and. &\n&y.lt.2)z=+x+y\nx= &\n&+a-b\n',
                   'if (x.gt.0.and. &\n   & y.lt.2) z = x + y\nx = &\n   & a - b\n')

    def test_continued_character_payload(self):
        source = 'do i=1,n\ncall f("A + &\n! Intervening comment\n&  B = C")\nend do\n'
        self.check(source, 'do i = 1,n\n   call f("A + &\n! Intervening comment\n      &  B = C")\nend do\n')

    def test_long_expression_wraps_at_token_boundaries(self):
        source = 'x=' + '+'.join(f'a({i})' for i in range(30)) + '\n'
        formatted = format_source(source)
        self.assertTrue(all(len(s) <= 132 for s in formatted.splitlines()))
        self.assertIn(' &\n', formatted)
        self.assertEqual(semantic_statements(source), semantic_statements(formatted))
        self.assertEqual(format_source(formatted), formatted)

    def test_line_endings_and_keyword_array_assignment(self):
        self.check('if(i)=+1\r\ndo=2\r\n', 'if (i) = 1\r\ndo = 2\r\n')

    def test_unsupported_input_fails_before_writing(self):
        for source in ('#define N 2\n', 'x=4HABCD\n', 'x=1; y=2\n', 'do i=1,n\nx=1\n',
                       'x=var&\n&iable\n', 'x=2*&\n&*3\n'):
            with self.assertRaises(ValueError):
                format_source(source)

    def test_compiler_audit_only_removes_unary_plus_wrappers(self):
        self.assertEqual(without_unary_plus('ASSIGN x (U+ (+ a (U+ f(2))))'), 'ASSIGN x (+ a f(2))')
        self.assertEqual(without_unary_plus("(U+ call(')''('))"), "call(')''(')")
        self.assertEqual(without_unary_plus('(U- (+ a b))'), '(U- (+ a b))')

    def test_dot_operator_after_integer_and_real_exponents(self):
        self.check('if(1.eq.n)x=1.e+12-1.e-12\n', 'if (1.eq.n) x = 1.e+12 - 1.e-12\n')

    def test_nested_pure_interface_layout(self):
        self.check('pure real function f(x)\nreal,intent(in)::x\ninterface\npure elemental real function g(x)\nreal,intent(in)::x\nend function g\nend interface\nf=g(x)\nend function f\n',
                   'pure real function f(x)\nreal,intent(in)::x\ninterface\n   pure elemental real function g(x)\n      real,intent(in)::x\n   end function g\nend interface\nf = g(x)\nend function f\n')


if __name__ == '__main__':
    unittest.main()
