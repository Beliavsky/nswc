# Shared-storage modernization

Both free-form implementations remove all seven EQUIVALENCE statements.
The recommended `nswc_mod.f90` also replaces all 87 COMMON declarations across
14 blocks with 163 private saved module variables. It compiles with GNU Fortran
using `-std=f2023 -pedantic-errors` without warnings.

The external `nswc.f90` keeps its original COMMON blocks so legacy callers and
callbacks that declare those blocks continue to share the same storage. Its
procedure signatures and COMMON layouts are unchanged. The fixed-form reference
and archive are unchanged. Choose the external implementation when an existing
application accesses COMMON directly; the standalone module keeps its state private.

## EQUIVALENCE replacements

- `ASJY`: five coefficient-table overlays become direct DATA initialization of
  `ALFA(26,4)` and `BETA(26,5)`. Column offsets are preserved. GNU and Intel checks
  compare all 234 initialized elements bit for bit.
- `SFFT`: the integer names `I` and `II` refer to one variable. References to
  `II` become `I`, retaining updates through either old name.
- `ADCOMP`: derivative callbacks receive the contiguous sections `FLEFT(2:10)`
  and `FRIGHT(2:10)` directly, replacing two overlapping derivative arrays.
  Cubic and quintic approximation tests exercise these outputs and shared state
  repeatedly with different degree and smoothness settings.

Only the reviewed aliases, their declarations and storage-category flags change
in the external compiler inventory. Other types, bounds, attributes, procedure
signatures and COMMON layouts remain checked against the preceding source.

## Private module state

Each COMMON declaration is reviewed as a sequence of typed storage ranges.
Equivalent names in different procedures bind to the same saved module variable.
This includes `ERROR`/`ELINSY` in `XXLIN`, `EPS`/`MACHEP` in `CBLKT`, and the
different names used by the stiff ODE routines. Matching array views retain their
rank, extents and element order. Unsupported overlapping active views are rejected.
Unused padding views do not become local scratch copies.

`DEBDF1` has several views of 218 real and 33 integer storage slots. Its ordinary
procedures refer to the corresponding scalar and array state variables. `RSCO`
restores every slot from the caller's arrays; `SVCO` saves every slot back.
Two-dimensional coefficient tables use explicit RESHAPE operations with Fortran
element order. Tests alternate two complete state vectors, including signed zero,
and compare all restored real bits and integer values.

The module variables have SAVE lifetime and are private. The `SPDATA`, `DPDATA`
and `CUBATB` variables are also VOLATILE: those routines intentionally force
intermediate floating-point values into memory to measure precision and rounding.
GNU and Intel optimized tests exercise the machine radix and rounding probes.

This conversion preserves shared mutable state. It does not make these routines
reentrant or safe for simultaneous independent problems. A future context-object
API would be a separate interface change.

## Reproduction and verification

`tools/storage_modernization.py` applies the reviewed equivalence changes after
the other free-form modernization passes. Module generation then replaces COMMON
with saved state. The [storage review](../tools/shared-storage.json) records the
equivalence source hashes, each COMMON view, field offsets, types, shapes and
canonical module bindings. Other constant, purity and intrinsic reviews remain
unchanged.

```sh
python tools/regenerate_sources.py
python tools/regenerate_sources.py --check
python tools/validate_storage.py
python tools/validate_module.py
```

The storage validator checks review reproduction, idempotence, external COMMON
layouts, all procedure signatures, module state types/bounds/lifetime and
optimization-sensitive VOLATILE flags. A negative import test confirms that
production module state is private. It checks coefficient bits and runs optimized
state, FFT, derivative, rounding, radix and external COMMON linkage probes.
Use `--ifx PATH --intel-env ENVIRONMENT_BATCH` on Windows to repeat the focused
checks with Intel. GitHub Actions runs the GNU checks.
Optimized probes compile production routine bodies and their dependency closures.
The full numerical and interface checks compile the complete implementations.

The optional `nswc_interfaces` callback contract for `ADAPT`, `ADAPT1`, `ADCOMP`
and `ERRINT` now describes a rank-one derivative array. The library already
passes derivative arrays; the former scalar interface description was incorrect.
Its callback declaration uses `derivative(*)`, so implementations supplied through
this optional contract use an assumed-size derivative array. The implementation
signatures and calling convention are unchanged. A regression accepts this array
contract and rejects a scalar derivative declaration.

`test_storage_state.f90` compares the Singleton FFT against direct Fourier sums
and checks inverse transforms for prime and composite sizes. It also exercises
all packed ODE state slots and rounding storage. The adaptive approximation test
is adapted from the Miller NSWC suite. Both run against the fixed-form reference,
archive, external free-form implementation and standalone module.

The periodic block-solver test also checks its internal real/complex root flag.
For that assertion, the module test runner makes one state variable visible in a
temporary test build and imports it under the old diagnostic name. Production
source and visibility are unchanged; the test retains its original branch and
manufactured-solution checks.
