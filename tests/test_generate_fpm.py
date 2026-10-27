"""Package source isolation, public-state adaptation and generated-file ownership."""
from pathlib import Path
import sys
import tempfile
import tomllib
import unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from generate_fpm import outputs,driver,obsolete,MARKER,ROOT
from fortran_procedures import procedure_spans


class FpmGenerationTests(unittest.TestCase):
    def test_committed_package_and_manifest(self):
        expected=outputs()
        self.assertEqual(len(expected),55)
        self.assertEqual(expected[ROOT/'src/nswc_mod.f90'],(ROOT/'nswc_mod.f90').read_text())
        for path,text in expected.items():self.assertEqual(path.read_bytes(),text.encode('ascii'),str(path))
        manifest=tomllib.loads((ROOT/'fpm.toml').read_text())
        self.assertEqual(manifest['library']['source-dir'],'src')
        self.assertFalse(manifest['build']['auto-executables'])
        self.assertFalse(manifest['fortran']['implicit-typing'])
        for path,text in expected.items():
            if path.parent.name=='test':
                self.assertIn('use nswc_mod,',text)
                self.assertNotIn('use nswc_interfaces',text)
                self.assertNotIn('nswc_state_',text)

    def test_periodic_public_checks_and_original_diagnostics(self):
        original=(ROOT/'tests/fortran/test_blktri_periodic.f90').read_text()
        names={n for n,_,_ in procedure_spans((ROOT/'nswc_mod.f90').read_text())}
        public=driver(original,names,periodic=True)
        self.assertNotIn('common /cblkt/',public)
        self.assertNotIn('if (ncmplx /= mode)',public)
        self.assertIn('if (ncmplx /= mode) stop 2',original)
        self.assertIn('maxval(abs(y(:,1:n) - exact(:,1:n))) > 5.0e-4',public)
        self.assertIn('do repetition = 1,2',public)
        with self.assertRaisesRegex(ValueError,'needs a new public-state adaptation'):
            driver(original.replace('stop 2','stop 20'),names,periodic=True)

    def test_only_owned_stale_drivers_are_removed(self):
        with tempfile.TemporaryDirectory() as work:
            root=Path(work);(root/'test').mkdir()
            owned=root/'test/stale.f90';owned.write_text(MARKER+'program p\nend program p\n')
            custom=root/'test/custom.f90';custom.write_text('! A handwritten test: \u03c0\nprogram custom\nend program custom\n',encoding='utf-8')
            self.assertEqual(obsolete(root,{}),[owned])
            self.assertEqual(obsolete(root,{owned:''}),[])

if __name__=='__main__':unittest.main()
