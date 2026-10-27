"""Reproduce the generic-intrinsic review and compare compiled code and types."""
from ford_documentation import strip as strip_ford
import json
from pathlib import Path
import tempfile

from data_constants import transform as apply_constants
from fixed_to_free import convert_text
from format_free_form import format_source
from free_source_fixes import transform as apply_free_fixes
from generic_intrinsics import MANIFEST, compile_dump, review, symbols, transform, verify
from lowercase_fortran import lowercase
from portable_intrinsics import transform as portable_intrinsics
from procedure_purity import transform as apply_purity
from sentence_case_comments import sentence_case
from simplify_free_style import transform as simplify_style
from coalesce_local_declarations import transform as coalesce_locals
from remove_final_returns import transform_free as remove_final_returns
from modernize_obsolescent import transform as modernize_obsolescent
from storage_modernization import equivalence_free

ROOT = Path(__file__).resolve().parents[1]


def baseline_source():
    baseline = format_source(lowercase(convert_text((ROOT / 'nswc.f').read_text(encoding='ascii'))))
    baseline = simplify_style(apply_free_fixes(apply_purity(portable_intrinsics(apply_constants(sentence_case(baseline).text)))))
    return baseline


def main():
    baseline = baseline_source()
    manifest = json.loads(MANIFEST.read_text())
    converted = transform(baseline, manifest)
    if equivalence_free(modernize_obsolescent(remove_final_returns(coalesce_locals(converted)))) != strip_ford((ROOT / 'nswc.f90').read_text(encoding='ascii')):
        raise ValueError('Generic intrinsic regeneration differs from maintained source')
    with tempfile.TemporaryDirectory(prefix='nswc-generic-validation-') as work:
        before = compile_dump(baseline, work)
        if review(baseline, symbols(before[0], True)) != manifest:
            raise ValueError('Generic intrinsic binding review does not reproduce')
        verify(before, compile_dump(converted, work), manifest)
    print(json.dumps(manifest['summary']))
    print('Assembly agrees except diagnostic source lines; compiler records and executable trees agree.')


if __name__ == '__main__':
    main()
