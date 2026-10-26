"""Preserve computed-transfer edges and statement-function scopes and kinds."""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from modernize_obsolescent import computed_gotos, compile_dump, review, transform
from modernize_remaining_features import strict_standard
from fortran_procedures import procedure_blocks
from validate_explicit_typing import symbols


@unittest.skipUnless(shutil.which('gfortran'), 'GNU Fortran required')
class ObsolescentTests(unittest.TestCase):
    def checked(self, source, driver):
        with tempfile.TemporaryDirectory(prefix='nswc-obsolescent-test-') as work:
            before = compile_dump(source, work)
            manifest = review(source, symbols(before[0], True))
            result = transform(source, manifest)
            self.assertEqual(transform(result, manifest), result)
            for optimization in ('-O0', '-O2'):
                outputs = []
                for text, standard in ((source, '-std=legacy'), (result, strict_standard())):
                    path = Path(work) / 'input.f90'
                    path.write_text(text + driver)
                    run = subprocess.run(['gfortran', optimization, standard, '-pedantic-errors',
                                          str(path), '-o', 'probe.exe'], cwd=work,
                                         capture_output=True, text=True, timeout=60)
                    self.assertEqual(run.returncode, 0, run.stderr)
                    run = subprocess.run([str(Path(work) / 'probe.exe')], capture_output=True,
                                         text=True, timeout=10)
                    self.assertEqual(run.returncode, 0, run.stderr)
                    outputs.append(run.stdout)
                self.assertEqual(*outputs)
        return result, manifest

    def test_duplicate_targets_bounds_and_selector_evaluated_once(self):
        source = '''subroutine route(i,out,calls)
implicit none
integer,intent(in)::i
integer,intent(out)::out,calls
calls=0
5 go to (10,20,10), selector() ! repeated destination
out=-1
return
10 out=10
return
20 out=20
contains
integer function selector()
calls=calls+1
selector=i
end function selector
end subroutine route
'''
        driver = '''program probe
implicit none
integer::i,out,calls,expected
do i=-3,7
call route(i,out,calls)
expected=-1
if(i==1.or.i==3) expected=10
if(i==2) expected=20
if(out/=expected.or.calls/=1) error stop 'computed transfer semantics'
print *,i,out,calls
end do
end program probe
'''
        result, manifest = self.checked(source, driver)
        self.assertIn('5 select case (selector())', result)
        self.assertEqual(result.count('go to 10'), 2)
        self.assertIn('! repeated destination', result)
        self.assertNotIn('case default', result)
        self.assertEqual(manifest['summary']['computed_gotos'], 1)

    def test_host_capture_shadowing_chained_helpers_and_result_kinds(self):
        source = '''pure subroutine helper(x,z,out,c,flag)
implicit none
double precision,intent(in)::x
complex,intent(in)::z
double precision,intent(out)::out
complex,intent(out)::c
logical,intent(out)::flag
double precision::offset,t,first,second
complex::w,conjugate
logical::positive
first(t)=t+offset
second(t)=2d0*first(t)
conjugate(w)=cmplx(real(w),-aimag(w))
positive(t)=t>=x
offset=3d0
out=second(x)
offset=7d0
out=out+second(x)
c=conjugate(z)
flag=positive(x)
end subroutine helper
'''
        driver = '''program probe
implicit none
double precision::out
complex::c
logical::flag
call helper(2d0,(3.,4.),out,c,flag)
if(out/=28d0.or.c/=(3.,-4.).or..not.flag) error stop 'helper semantics'
print *,out,c,flag
end program probe
'''
        result, manifest = self.checked(source, driver)
        self.assertEqual(result.count('   pure function '), 4)
        self.assertEqual(manifest['procedures']['HELPER']['functions']['first']['type'], 'double precision')
        self.assertIn('double precision, intent(in) :: t', result)
        self.assertIn('nswc_sf_result = t+offset', result)
        with self.assertRaisesRegex(ValueError, 'source changed'):
            transform(source.replace('offset=3d0', 'offset=4d0'), manifest)

    def test_array_assignments_comments_and_strings_are_not_candidates(self):
        source = '''subroutine arrays(goto)
implicit none
real,intent(out)::goto(2)
goto(1)=1.
goto(2)=2.
print *, 'go to (10,20),i' ! left(x)=x
end subroutine arrays
'''
        result, manifest = self.checked(source, 'program probe\nreal::x(2)\ncall arrays(x)\nend program probe\n')
        self.assertEqual(result, source)
        self.assertEqual(manifest['summary']['statement_functions'], 0)

    def test_reader_and_dump_keep_internal_names_scoped(self):
        source = '''module m
implicit none
contains
subroutine a()
contains
pure integer function f(x)
integer,intent(in)::x
f=x
end function f
end subroutine a
subroutine b()
contains
pure integer function f(x)
integer,intent(in)::x
f=x+1
end function f
end subroutine b
end module m
'''
        self.assertEqual(set(procedure_blocks(source)), {'A', 'B'})
        with tempfile.TemporaryDirectory() as work:
            dump = compile_dump(source, work)[0]
        self.assertEqual(set(symbols(dump)), {'M', 'A', 'B'})
        self.assertEqual(set(symbols(dump, include_internal=True)), {'M', 'A', 'B', 'A::F', 'B::F'})
        self.assertNotIn('x', symbols(dump)['A'])

    def test_continued_computed_transfer(self):
        source = '''integer function f(i)
integer::i
go to (10, &
! keep this explanation
 &20), i+1
f=-1
return
10 f=10
return
20 f=20
end function f
'''
        result = computed_gotos(source)
        self.assertIn('select case (i+1)', result)
        self.assertIn('! keep this explanation', result)
        with tempfile.TemporaryDirectory() as work:
            self.assertEqual(compile_dump(source, work)[0], compile_dump(result, work)[0])


if __name__ == '__main__':
    unittest.main()
