"""The reviewed empty-factor correction must be exact and repeatable."""
from pathlib import Path
import sys
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
from free_source_fixes import correct_empty_factor_index


class EmptyFactorIndexTests(unittest.TestCase):
    source = ('subroutine blktr1()\n' + '   call indxb(i,ir,idx,idp)\n'*26
              + 'call indxb(if,k - 1,ip,np)\n'
              + 'end subroutine blktr1\n')

    def test_all_factor_calls_are_guarded_and_repeatable(self):
        fixed = correct_empty_factor_index(self.source)
        self.assertEqual(fixed.count('   if (idp .eq. 0) idx = 1\n'), 26)
        self.assertNotIn('if (np .eq. 0)', fixed)
        self.assertEqual(fixed.replace('   if (idp .eq. 0) idx = 1\n', ''), self.source)
        self.assertEqual(correct_empty_factor_index(fixed), fixed)
        spaced = self.source.replace('indxb(', 'indxb (')
        self.assertEqual(correct_empty_factor_index(spaced).count('if (idp .eq. 0)'), 26)

    def test_partial_and_unexpected_edits_are_rejected(self):
        for source in (self.source.replace('   call indxb(i,ir,idx,idp)\n',
                                          '   call indxb(i,ir,idx,idp)\n   if (idp .eq. 0) idx = 1\n', 1),
                       self.source.replace('   call indxb(i,ir,idx,idp)\n', '', 1),
                       self.source.replace('call indxb(if,k - 1,ip,np)\n',
                                           'call indxb(if,k - 1,ip,np)\nif (np .eq. 0) ip = 1\n'),
                       self.source.replace('call indxb(if,k - 1,ip,np)', 'call indxb(if,k - 1,ip,roots)')):
            with self.assertRaisesRegex(ValueError, 'needs review'):
                correct_empty_factor_index(source)


if __name__ == '__main__':
    unittest.main()
