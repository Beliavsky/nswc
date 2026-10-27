"""Regression for reduced test modules with grouped PUBLIC exports."""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from validate_interfaces import restrict_public

class PublicSubsetTests(unittest.TestCase):
    def test_grouped_exports_compile_without_removed_procedures(self):
        source='module subset\nimplicit none\nprivate\n! Keep this comment.\npublic :: keep, removed, other\ncontains\nsubroutine keep()\nend subroutine keep\nend module subset\n'
        result=restrict_public(source,{'KEEP'})
        self.assertIn('public :: keep\n',result)
        self.assertIn('! Keep this comment.',result)
        self.assertNotIn('removed',result)
        if shutil.which('gfortran'):
            with tempfile.TemporaryDirectory() as work:
                path=Path(work)/'subset.f90';path.write_text(result)
                r=subprocess.run(['gfortran','-fsyntax-only',str(path)],cwd=work,capture_output=True,text=True)
                self.assertEqual(r.returncode,0,r.stderr)

    def test_empty_selection_drops_the_declaration(self):
        self.assertEqual(restrict_public('private\npublic :: a,b\ncontains\n',set()),'private\ncontains\n')

if __name__=='__main__':unittest.main()
