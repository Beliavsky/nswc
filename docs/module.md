# Module implementation

`nswc_mod.f90` defines module `nswc_mod` and is recommended for new programs.
All 1,062 procedures, including implementation helpers, are public. Other module
entities are private. Prefer the documented entry points and import selected
names to avoid conflicts with local variables or other libraries.

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

`tools/generate_module.py` also regenerates just the module from `nswc.f90`;
`--check` verifies it without writing. Do not maintain independent source copies.

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
Machine constants are unchanged.

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
