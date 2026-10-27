"""Check the standalone module's signatures, calls and numerical results."""
import argparse
from pathlib import Path
import re
import tempfile

from fortran_procedures import procedure_blocks
from generate_interfaces import compiler_environment
from generate_module import BINDINGS, INTRINSIC_ALIASES, check_binding_review, module_source
import json
from validate_explicit_typing import symbols
from validate_interfaces import (command_run, compare_signatures, module_caller,
                                 PROBE_PREFIX, PROBE_SUFFIX, PROBES)
from validate_sources import check_result, test_programs
from storage_modernization import MANIFEST as STORAGE_REVIEW, normalize_module_records, new_state_intrinsics
from module_pi_constants import MANIFEST as PI_REVIEW
from validate_module_pi import normalize_records as normalize_pi_records

ROOT = Path(__file__).resolve().parents[1]


def state_test_module(text):
    """Expose one diagnostic in a temporary test build; production stays private."""
    return text.replace('\ncontains\n', '\npublic :: nswc_state_cblkt_ncmplx\ncontains\n', 1)


def standalone_caller(text, names):
    text = module_caller(text, names).replace('use nswc_interfaces,', 'use nswc_mod,')
    # The periodic test deliberately checks which root-storage branch ran.
    # Import that diagnostic from the temporary test build instead of COMMON.
    if re.search(r'^\s*common\s*/cblkt/', text, re.M | re.I):
        text = re.sub(r'^\s*common\s*/cblkt/[^\n]*\n', '', text, flags=re.M | re.I)
        old = 'integer :: npp, k, nm, ncmplx, ik'
        if old not in text:
            raise ValueError('Periodic COMMON diagnostic declaration needs review')
        text = text.replace(old, 'integer :: npp, k, nm, ik')
        text = text.replace('   implicit none',
                            '   use nswc_mod, only: ncmplx => nswc_state_cblkt_ncmplx\n   implicit none', 1)
    return text


def verify(compiler, folder, intel=False, env=None):
    suffix = '.obj' if intel else '.o'
    libraries = []
    inventories = []
    intrinsic_bindings = []
    for stem in ('nswc', 'nswc_mod'):
        obj = folder / (stem + suffix)
        source = ROOT / (stem + '.f90')
        if stem == 'nswc_mod':
            temporary_source = folder / 'nswc_test_module.f90'
            temporary_source.write_text(state_test_module(source.read_text()), newline='\n')
            source = temporary_source
        if intel:
            flags = ['/nologo', '/Od', '/fp:strict',
                     '/warn:interfaces' if stem == 'nswc_mod' else '/warn:nointerfaces']
            command = [compiler, *flags, '/c', str(source), '/object:' + str(obj)]
        else:
            flags = ['-std=legacy', '-fno-allow-argument-mismatch']
            command = [compiler, *flags, '-fdump-fortran-original', '-c', str(source), '-o', str(obj)]
        result = command_run(command, folder, env, timeout=300, expect_success=False)
        if result.returncode:
            raise RuntimeError(f'{stem}: compiler rejected library\n{result.stderr[:10000]}')
        libraries.append(obj)
        if not intel:
            normalized = result.stdout
            complete = symbols(normalized, include_intrinsics=True, include_internal=True)
            intrinsic_bindings.append({(scope, n) for scope, records in complete.items() if scope != 'NSWC_MOD'
                                       for n, record in records.items() if 'INTRINSIC-PROC' in record.get('attributes', '')})
            inventory = symbols(normalized)
            if stem == 'nswc_mod':
                storage = json.loads(STORAGE_REVIEW.read_text())['module_state']
                inventory = normalize_pi_records(inventories[0], inventory, json.loads(PI_REVIEW.read_text()))
                inventory = normalize_module_records(inventories[0], inventory, storage)
            inventories.append(inventory)
    if not intel:
        overrides = json.loads(BINDINGS.read_text())['intrinsic_overrides']
        intrinsic_bindings[0] = {(scope, INTRINSIC_ALIASES.get(n.upper(), n).lower()
                                  if n in overrides.get(scope, []) else n)
                                 for scope, n in intrinsic_bindings[0]}
        added = new_state_intrinsics(storage)
        if not added <= intrinsic_bindings[1]:
            raise ValueError('Packed module state is missing reviewed reshape intrinsics')
        intrinsic_bindings[1] -= added
        if intrinsic_bindings[0] != intrinsic_bindings[1]:
            raise ValueError('Module conversion changed intrinsic bindings: ' +
                             str(intrinsic_bindings[0] ^ intrinsic_bindings[1]))
        try:
            count = compare_signatures(*inventories)
        except ValueError as error:
            raise ValueError(str(error)[:5000]) from None
        data = [{n: {v: r for v, r in scope.items() if r and 'PROCEDURE' not in r.get('attributes', '')}
                 for n, scope in inventory.items()} for inventory in inventories]
        if data[0] != data[1]:
            changed = [n for n in data[0] if data[0][n] != data[1].get(n)]
            name = changed[0]
            differences = {v: (data[0][name].get(v), data[1][name].get(v))
                           for v in data[0][name].keys() | data[1][name].keys()
                           if data[0][name].get(v) != data[1][name].get(v)}
            raise ValueError('Module conversion changed data records in ' + ', '.join(changed[:15]) +
                             '\n' + str(differences)[:2000])
        print(f'Confirmed {count} module procedure/argument/result records.', flush=True)
    names = set(procedure_blocks((ROOT / 'nswc.f90').read_text()))
    label = 'Intel' if intel else 'GNU'
    passed = 0
    for path in [*test_programs(), ROOT / 'tests/module/test_intrinsic_aliases.f90']:
        baseline = {}
        for module, library in zip((False, True), libraries):
            caller = path
            if module:
                caller = folder / path.name
                caller.write_text(standalone_caller(path.read_text(), names), newline='\n')
            exe = folder / (path.stem + ('_module' if module else '_external') + '.exe')
            command = ([compiler, *flags, '/fpe:0', str(caller), str(library), '/exe:' + str(exe)] if intel else
                       [compiler, *flags, '-ffpe-trap=invalid,zero,overflow', str(caller), str(library), '-o', str(exe)])
            command_run(command, folder, env, timeout=60)
            result = command_run([str(exe)], folder, env, timeout=30)
            check_result(result, path.stem, baseline)
            baseline[path.stem] = result.stdout
            passed += 1
        print(f'PASS: {label} / {path.stem}: external and module results agree.', flush=True)
    probe = folder / 'probe.f90'
    exe = folder / 'pure.exe'
    probe.write_text((ROOT / 'tests/purity/test_pure_elemental.f90').read_text().replace('nswc_interfaces', 'nswc_mod'), newline='\n')
    command = ([compiler, *flags, '/fpe:0', str(probe), str(libraries[1]), '/exe:' + str(exe)] if intel else
               [compiler, '-std=f2008', '-pedantic-errors', '-ffpe-trap=invalid,zero,overflow', str(probe), str(libraries[1]), '-o', str(exe)])
    command_run(command, folder, env)
    result = command_run([str(exe)], folder, env)
    if 'test_pure_elemental: PASS' not in result.stdout:
        raise ValueError(result.stdout + result.stderr)
    data_probes = [p for p in PROBES if not p[0].startswith('callback')]
    for name, good, bad in data_probes:
        for valid, call in ((True, good), (False, bad)):
            probe.write_text((PROBE_PREFIX + call + '\n' + PROBE_SUFFIX).replace('use nswc_interfaces,', 'use nswc_mod,'), newline='\n')
            command = ([compiler, *flags, '/c', str(probe), '/object:probe.obj'] if intel else
                       [compiler, '-std=f2008', '-pedantic-errors', '-c', str(probe), '-o', 'probe.o'])
            result = command_run(command, folder, env, expect_success=False)
            if (result.returncode == 0) != valid:
                raise RuntimeError(f'{label}: unexpected {name} probe (valid={valid}):\n{result.stdout}\n{result.stderr}')
    print(f'{label}: {passed} numerical runs agree; pure/elemental calls and {len(data_probes)} invalid-call probes passed.', flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--gfortran', default='gfortran')
    parser.add_argument('--ifx')
    parser.add_argument('--intel-env', type=Path)
    args = parser.parse_args()
    source = (ROOT / 'nswc.f90').read_text(encoding='ascii')
    check_binding_review(source)
    if (ROOT / 'nswc_mod.f90').read_text(encoding='ascii') != module_source(source):
        raise ValueError('Generated module is stale')
    with tempfile.TemporaryDirectory(prefix='nswc-module-check-') as work:
        folder = Path(work)
        gnu = folder / 'gnu'
        gnu.mkdir()
        verify(args.gfortran, gnu)
        if args.ifx:
            intel = folder / 'intel'
            intel.mkdir()
            verify(args.ifx, intel, True, compiler_environment(args.intel_env))


if __name__ == '__main__':
    main()
