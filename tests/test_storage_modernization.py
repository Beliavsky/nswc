"""Storage aliases must retain their views, lifetime, precision and scope."""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
ROOT = Path(__file__).resolve().parents[1]
from generate_module import module_source
from modernize_obsolescent import compile_dump
from modernize_remaining_features import strict_standard
from storage_modernization import (common_views, equivalence_free, equivalence_review,
                                   module_state, state_layout)


class StorageModernizationTests(unittest.TestCase):
    def test_periodic_flag_bridge_is_only_in_temporary_test_build(self):
        from validate_module import standalone_caller, state_test_module
        production = (ROOT / 'nswc_mod.f90').read_text()
        public = 'public :: nswc_state_cblkt_ncmplx'
        self.assertNotIn(public, production)
        self.assertIn(public, state_test_module(production))
        caller = standalone_caller((ROOT / 'tests/fortran/test_blktri_periodic.f90').read_text(), {'BLKTRI'})
        self.assertNotIn('common /cblkt/', caller)
        self.assertIn('ncmplx => nswc_state_cblkt_ncmplx', caller)
        self.assertIn('if (ncmplx /= mode) stop 2', caller)

    @unittest.skipUnless(shutil.which('gfortran'), 'GNU Fortran required')
    def test_adaptive_callback_requires_derivative_array(self):
        from callback_interfaces import abstract_interfaces
        self.assertIn('derivative(*)', abstract_interfaces())
        with tempfile.TemporaryDirectory(prefix='nswc-derivative-contract-') as work:
            module = Path(work) / 'callbacks.f90'
            module.write_text('module callbacks\nimplicit none\n' + abstract_interfaces() + '\nend module callbacks\n')
            r = subprocess.run(['gfortran', '-c', '-std=f2008', '-pedantic-errors', str(module)],
                               cwd=work, capture_output=True, text=True, timeout=30)
            self.assertEqual(r.returncode, 0, r.stderr)
            # The optional procedure contract uses an assumed-size array;
            # procedure-pointer characteristics also distinguish explicit shape.
            for shape, valid in (('(*)', True), ('(9)', False), ('', False)):
                probe = Path(work) / 'probe.f90'
                probe.write_text('''program probe
use callbacks, only: nswc_cb_value_derivative
implicit none
procedure(nswc_cb_value_derivative), pointer :: fn
fn=>callback
contains
double precision function callback(x,derivative)
double precision,intent(in)::x
double precision,intent(out)::derivative''' + shape + '''
derivative=1d0
callback=x
end function callback
end program probe
'''.replace('derivative=1d0', 'derivative(1)=1d0' if shape else 'derivative=1d0'))
                r = subprocess.run(['gfortran', '-fsyntax-only', str(probe)], cwd=work,
                                   capture_output=True, text=True, timeout=30)
                self.assertEqual(r.returncode == 0, valid, r.stderr)

    alias = '''subroutine sfft(x)
implicit none
integer,intent(out)::x
integer::i,ii
equivalence (i,ii)
i=7
x=ii
ii=11
x=x+i
end subroutine sfft
'''

    def test_integer_alias_is_one_variable_and_stale_reviews_fail(self):
        review = equivalence_review(self.alias)
        result = equivalence_free(self.alias, review)
        self.assertIn('x=i', result)
        self.assertNotIn('equivalence', result)
        self.assertEqual(equivalence_free(result, review), result)
        self.assertEqual(equivalence_free(self.alias.replace('equivalence (i,ii)', 'equivalence(i, ii)'), review), result)
        with self.assertRaisesRegex(ValueError, 'stale'):
            equivalence_free(self.alias.replace('i=7', 'i=8'), review)
        with self.assertRaisesRegex(ValueError, 'Unreviewed'):
            equivalence_review(self.alias.replace('(i,ii)', '(i,j)'))
        with self.assertRaisesRegex(ValueError, 'storage type/shape'):
            equivalence_review(self.alias.replace('integer::i,ii', 'integer::i\nreal::ii'))

    def test_used_partial_views_are_rejected(self):
        source = '''subroutine a()
real::x(4)
common /shared/ x
x=1.
end subroutine a
subroutine b()
real::p,q(3)
common /shared/ p,q
p=q(1)
end subroutine b
'''
        with self.assertRaisesRegex(ValueError, 'overlapping active'):
            state_layout(common_views(source))

    def test_rank_remapping_is_not_silently_assumed(self):
        source = '''subroutine a()
real::x(2,3)
common /shared/ x
x=1.
end subroutine a
subroutine b()
real::x(3,2)
common /shared/ x
x=2.
end subroutine b
'''
        with self.assertRaisesRegex(ValueError, 'overlapping active'):
            state_layout(common_views(source))

    def test_callback_scope_strings_and_format_are_preserved(self):
        source = '''subroutine f(x)
implicit none
interface
real function cb(a)
real,intent(in)::a
end function cb
end interface
real,intent(out)::x
real::a
common /shared/ a
x=cb(a)
print *, 'a' ! a stays in this comment
10 format(2a)
end subroutine f
'''
        result = module_source(source, {}, {})
        self.assertIn('real function cb(a)', result)
        self.assertIn('real,intent(in)::a', result)
        self.assertIn('x=cb(nswc_state_shared_a)', result)
        self.assertIn("'a' ! a stays in this comment", result)
        self.assertIn('10 format(2a)', result)
        with self.assertRaisesRegex(ValueError, 'Reserved'):
            module_source(source.replace('real::a', 'real::a,nswc_state_shared_a'), {}, {})

    @unittest.skipUnless(shutil.which('gfortran'), 'GNU Fortran required')
    def test_shared_aliases_and_lifetime_at_both_optimization_levels(self):
        source = '''subroutine set_values(x)
implicit none
real,intent(in)::x
real::a(2)
logical::ready
common /spdata/ a,ready
a=[x,2*x]
ready=.true.
end subroutine set_values
subroutine get_values(y)
implicit none
real,intent(out)::y
real::b(2)
logical::ok
common /spdata/ b,ok
if(.not.ok) error stop 'lost shared state'
y=sum(b)
end subroutine get_values
'''
        modern = module_source(source, {}, {})
        self.assertNotIn('common /', modern)
        self.assertIn('save, volatile', modern)
        self.assertEqual(module_state(modern), modern)
        driver = '''program probe
{imports}
implicit none
real::y
call set_values(3.)
call get_values(y)
if(y/=9.) error stop 'first state'
call set_values(-2.)
call get_values(y)
if(y/=-6.) error stop 'second state'
print *,y
end program probe
'''
        with tempfile.TemporaryDirectory(prefix='nswc-state-test-') as work:
            compile_dump(modern, work)
            for optimization in ('-O0', '-O2'):
                outputs = []
                for text, imports in ((source, ''), (modern, 'use nswc_mod, only: set_values,get_values')):
                    path = Path(work) / 'input.f90'
                    path.write_text(text + driver.format(imports=imports))
                    r = subprocess.run(['gfortran', optimization, strict_standard(), '-pedantic-errors',
                                        str(path), '-o', 'probe.exe'], cwd=work, capture_output=True, text=True, timeout=60)
                    self.assertEqual(r.returncode, 0, r.stderr)
                    r = subprocess.run([str(Path(work) / 'probe.exe')], capture_output=True, text=True, timeout=10)
                    self.assertEqual(r.returncode, 0, r.stderr)
                    outputs.append(r.stdout)
                self.assertEqual(*outputs)


if __name__ == '__main__':
    unittest.main()
