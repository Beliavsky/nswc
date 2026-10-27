"""Value, scope, assignment and argument-escape guards for simple constants."""
import sys
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from module_kinds import DEFINITION as KINDS
from module_simple_constants import transform,DEFINITIONS
from validate_module_simple_constants import verify_values


def module(body):
    return 'module m\nimplicit none\nprivate\n'+KINDS+'public :: f\ncontains\n'+body+'end module m\n'


class SimpleConstantTests(unittest.TestCase):
    def test_parameters_kind_and_complex(self):
        source=module('real(nswc_dp) function f()\nreal(nswc_dp), parameter :: one=1.d0\ncomplex(nswc_sp), parameter :: zero=(0.,0.)\nf=one + real(zero,nswc_dp)\nend function f\n')
        report={};result=transform(source,report)
        self.assertIn('f=nswc_one_dp + real(nswc_zero_csp,nswc_dp)',result)
        self.assertEqual(len(report['selected']),2)
        self.assertEqual(transform(result),result)

    def test_single_initialization_and_mixed_declarations(self):
        source=module('real(nswc_sp) function f(x)\nreal(nswc_sp) :: x, zero, &\n & one, y\nzero=0.0\none=1.0\ny=max(one,x)\nf=y+zero\nend function f\n')
        report={};result=transform(source,report)
        self.assertIn('real(nswc_sp) :: x, y',result)
        self.assertNotIn('zero=0.0',result)
        self.assertIn('max(nswc_one_sp,x)',result)
        self.assertEqual(len(report['selected']),2)

    def test_unsafe_variable_uses_stay_local(self):
        base='real(nswc_sp) function f(x)\nreal(nswc_sp) :: x, one\n{body}\nend function f\n'
        for body in ['one=1.0\none=2.0\nf=one',
                     'if (x>0) one=1.0\nf=one',
                     'f=one\none=1.0',
                     'one=1.0\ncall change(one)\nf=one',
                     'one=1.0\nf=change(one)',
                     'one=1.0\nf=one\nif (x>0) one=2.0',
                     'one=2.0\nf=one']:
            with self.subTest(body=body):
                report={};transform(module(base.format(body=body)),report)
                self.assertEqual(report['selected'],[])

    def test_shadowed_intrinsic_is_not_trusted(self):
        source=module('real(nswc_sp) function f()\nreal(nswc_sp) :: one, max\nexternal max\none=1.0\nf=max(one)\nend function f\n')
        report={};transform(source,report)
        self.assertEqual(report['selected'],[])

    def test_machine_probes_arrays_other_values_and_nested_scopes(self):
        for body in [
            'subroutine mach1\nreal(nswc_sp), parameter :: one=1.0\nend subroutine mach1\n',
            'subroutine f\nreal(nswc_sp), parameter :: two(2)=[2.,4.]\nend subroutine f\n',
            'subroutine f\nreal(nswc_sp), parameter :: one=2.0\nend subroutine f\n',
            'subroutine f\nreal(nswc_sp), parameter :: one=1.0\ncontains\nsubroutine g\nprint *,one\nend subroutine g\nend subroutine f\n',
            'subroutine f(one)\nreal(nswc_sp) :: one\none=1.0\nend subroutine f\n',
            'subroutine f\nreal(nswc_sp) :: one\nsave one\none=1.0\nend subroutine f\n',
            'subroutine f\nreal(nswc_sp) :: one\none=1.0\nentry alternate\nprint *,one\nend subroutine f\n']:
            report={};transform(module(body),report)
            self.assertEqual(report['selected'],[])

    def test_comments_strings_and_keyword_names(self):
        source=module("subroutine f\nreal(nswc_sp), parameter :: one=1.0\nprint *, 'one' ! one\ncall cb(one=one)\nend subroutine f\n")
        result=transform(source)
        self.assertIn("'one' ! one",result)
        self.assertIn('call cb(one=nswc_one_sp)',result)
        with self.assertRaisesRegex(ValueError,'Reserved'):
            transform(source.replace(':: one=',':: nswc_one_sp='))

    @unittest.skipUnless(shutil.which('gfortran'),'GNU required')
    def test_compiler_values_and_private_constants(self):
        source=module('real(nswc_sp) function f()\nreal(nswc_sp) :: one\none=1.0\nf=one\nend function f\n')
        report={};result=transform(source,report);verify_values(report)
        with tempfile.TemporaryDirectory() as work:
            path=Path(work);(path/'m.f90').write_text(result)
            r=subprocess.run(['gfortran','-c','m.f90'],cwd=work,capture_output=True,text=True)
            self.assertEqual(r.returncode,0,r.stderr)
            (path/'bad.f90').write_text('program p\nuse m, only: nswc_one_sp\nend program p\n')
            r=subprocess.run(['gfortran','-fsyntax-only','bad.f90'],cwd=work,capture_output=True,text=True)
            self.assertNotEqual(r.returncode,0)

if __name__=='__main__':unittest.main()
