# Module implementation

`nswc_mod.f90` defines module `nswc_mod` and is recommended for new programs.
All 1,062 procedures, including implementation helpers, are public. Other module
entities are private. Prefer the documented entry points and import selected
names to avoid conflicts with local variables or other libraries.

Public declarations are consolidated into lines of at most 100 characters,
grouped under comments naming the 26 manual chapters. An additional group lists
procedures and implementation helpers without an indexed manual entry. Names
retain their source order within each group. The module generator reads these
categories from the existing source interface inventory and chapter headings.

```fortran
program roots
   use nswc_mod, only: dcbrt
   implicit none
   print *, dcbrt([-8.0d0, 0.0d0, 27.0d0])
end program roots
```

For GNU Fortran:

```sh
gfortran -c -std=f2018 nswc_mod.f90
gfortran roots.f90 nswc_mod.o -o roots
```

Compile the module first and keep its generated `.mod` file available while
compiling callers. Compile library and callers with the same compiler and
compatible options. The module object links independently: no external NSWC
object or separate interface module is needed.

`nswc.f90` remains available for existing external callers. Its optional
`nswc_interfaces` module describes those external procedures. Module procedures
have different linker names, so `nswc_mod.o` cannot replace `nswc.o` in a program
that still uses external declarations. Change those callers to `use nswc_mod`.
Choose one implementation per executable.

The module uses private named kinds defined once:

```fortran
integer, parameter :: nswc_sp = kind(0.0), nswc_dp = kind(0.0d0)
```

Default real and complex declarations use `real(nswc_sp)` and
`complex(nswc_sp)`; double precision declarations use `real(nswc_dp)`.
Function results and callback interfaces use the same kinds. The prefixed
names avoid existing local variables named `sp` and `dp`. These definitions
retain the compiler's default and double precision choices, including its
precision options. Literal constants and intrinsic conversion calls retain
their original kinds. The external `nswc.f90`, fixed-form sources and optional
external interface module retain their existing declarations.

The module uses private saved variables instead of COMMON blocks. Programs or
callbacks that access legacy COMMON directly should use the external
implementation. Packed `RSCO`/`SVCO` state layouts are preserved. This change
keeps shared state and does not support simultaneous independent problems; see the
[storage review](shared-storage.md).

## Generation

Both implementations come from the same maintained inputs:

```sh
python tools/regenerate_sources.py
python tools/regenerate_sources.py --check
```

`tools/generate_module.py` also regenerates the module from `nswc.f90` and
updates its exact fpm mirror and module-based drivers; `--check` verifies those
files without writing. See the [fpm guide](fpm.md). Do not maintain independent
source copies.

The checked-in `tools/module-bindings.json` records the compiler-resolved
intrinsics that share names with library routines. The generator adds explicit
INTRINSIC declarations at 17 such sites, preserving calls to compiler intrinsics
such as ERF and GAMMA when library procedures become visible through the module.
Both free-form versions normalize two GNU-specific DGAMMA intrinsic references
to standard generic GAMMA with double-precision arguments, so Intel also accepts
the new pure callers. The exported library DGAMMA implementation is unchanged.
The archived fixed-form source resolves those names to the library routine with
Intel; the free-form versions use its double-precision GAMMA intrinsic instead.
Numerical comparisons cover both compilers.
After code changes, refresh that review from the regenerated external source:

```sh
python tools/generate_module.py --review-intrinsics
python tools/regenerate_sources.py
```

This review uses GNU Fortran; ordinary regeneration needs only Python. Validation
checks its code hash and independently compares compiler intrinsic bindings.

The generator replaces library procedure type/EXTERNAL declarations and local
library interface blocks with host association. It preserves declarations of
dummy callbacks and local data, even when their names match library procedures.
The reviewed call graph distinguishes function references from array references.
Dummy subroutines that were identified only by CALL statements receive explicit
EXTERNAL declarations, needed by Intel when exposing their enclosing module
procedure interfaces. These declarations retain implicit callback interfaces.
The storage pass also replaces COMMON references and explicitly packs/unpacks
ODE state. Argument order, types, shapes, intents and pure/elemental attributes
are preserved.
The final `tools/module_kinds.py` pass adds named kinds after the storage pass;
callback interface bodies receive IMPORT statements where needed. Intermediate
generation used by historical storage/declaration checks can disable this pass
with `named_kinds=False`.
Machine constants are unchanged. A final pass shares eligible scalar zero,
one, and two constants as described below.

Dummy callback interfaces retain the historical contracts in the implementation.
The compiler checks ordinary module calls; it cannot fully check a callback whose
dummy procedure has an implicit interface. The optional external interface module
has additional reviewed callback contracts described in the [interface guide](interfaces.md).
This module conversion does not impose those additional requirements internally.

## Verification

```sh
python tools/validate_module.py
```

GNU compiler records check all procedure/argument/result characteristics, local
data declarations, and intrinsic bindings against `nswc.f90`. The reviewed
COMMON bindings are checked against module variable types, bounds, SAVE lifetime
and rounding fences before normalization. Each of the 52 numerical mains runs once
with external calls and once using the module, and the outputs must agree.
An additional paired main checks DRCOMP against LOG_GAMMA references and DGINV
against analytic distributions, exercising the two normalized intrinsic calls
with double-precision accuracy tolerances.
The module callers link only the module object, catching accidentally retained
external NSWC references. Tests also exercise pure callers, elemental array
operations and broadcasting, and reject invalid data argument calls.

Use `--ifx PATH_TO_IFX` and, on Windows, `--intel-env PATH_TO_ENVIRONMENT_BATCH`
to repeat numerical and call checks with Intel Fortran. GNU verification runs in
GitHub Actions. Numerical coverage is representative rather than exhaustive.

## Shared pi constants

The generated module defines ten private parameters for pi, pi/2, pi/4,
2*pi, and 3*pi/2, separately for `nswc_sp` and `nswc_dp`. Names include
`nswc_pi_sp`, `nswc_half_pi_dp`, and `nswc_three_half_pi_sp`.
Each definition uses a decimal literal of the appropriate kind, avoiding
additional rounding from expressions built from an already rounded pi.

`tools/module_pi_constants.py` runs after named-kind conversion. Its reviewed
pass replaces 52 local parameter declarations and 18 embedded literals in
assignment expressions. Runtime calculations, coefficient tables, comments,
strings, and complex literal pairs stay as written. Nested scopes are accepted only when they contain no references to, or
declarations shadowing, the parameters being removed. The fixed and external
free-form implementations retain their existing definitions.

`tools/module-pi-constants.json` records every selected declaration and literal.
`tools/validate_module_pi.py` reproduces the module and review, checks exact
constant bit patterns, and compares GNU assembly and compiler symbols before
and after consolidation with source locations aligned. GNU and Intel checks
use their normal binary32 default-real and binary64 double-precision settings;
precision-promotion compiler options require separate numerical validation.
The parameters remain private and do not change the public interfaces.

```sh
python tools/validate_module_pi.py
```

Add `--ifx PATH_TO_IFX` and optionally `--intel-env PATH_TO_ENVIRONMENT_BATCH`
to repeat the constant-value checks with Intel Fortran. The ordinary module
validation suite checks external and module numerical results with both
compilers when Intel is supplied.

## Shared zero, one, and two

The module defines private real and complex parameters for zero, one, and two
in each named kind. Examples are `nswc_zero_sp`, `nswc_one_dp`, and
`nswc_one_csp` (single-precision complex). Ordinary numeric literals stay as
written; the external and fixed-form implementations retain local definitions.

`tools/module_simple_constants.py` consolidates 67 local parameters and eight
variables initialized once to a literal constant. The variables are in `cnspiv`,
`splsq`, `stlsq`, and `blsq`. A variable qualifies only when its initialization
is in the initial straight-line executable prefix, precedes every reference,
and is its only assignment. Storage association, nested scopes, attributed
declarations, and possible modification through an unknown procedure prevent
conversion. Intrinsic calls are accepted only for a small list of read-only
intrinsics whose names are not shadowed by local declarations or module routines.

Machine-arithmetic probes, including `radix`, `mach1`, `mach2`, `spmpar`, and
`dpmpar`, retain their variables to preserve their rounding experiments. The
array named `two` in `step1` is unrelated to the scalar constant and stays local.

`tools/module-simple-constants.json` records selected declarations, original
types and literal values, and exclusion reasons. The validator reproduces the
review and generated module, checks idempotence, and compares constant bit
patterns. Parameter-only consolidation must also preserve GNU assembly with
source locations aligned. An optimized comparison checks all 69 affected
procedures and their transitive library dependencies; GNU `-O2` assembly is
unchanged for all 75 replacements. The module validator checks compiler symbol inventories after restoring
only the reviewed local names, verifies signatures and intrinsic bindings, and
runs the external/module numerical comparisons.

```sh
python tools/validate_module_simple_constants.py
python tools/validate_module.py
```

Both validators accept `--ifx PATH_TO_IFX` and, on Windows,
`--intel-env PATH_TO_ENVIRONMENT_BATCH` for Intel checks.
After reviewing intentional source changes, refresh the selection report with
`python tools/module_simple_constants.py --review`, then regenerate the module.
