# Optional external procedure interfaces

`nswc_interfaces.f90` describes all 1,062 external procedures in the maintained
`nswc.f90`. It contains interface blocks, without implementations, including the
reviewed PURE and ELEMENTAL attributes. Elemental calls require an explicit
interface even with scalar arguments. Use this module or equivalent local
interface blocks; other historical external calls can retain implicit interfaces.

```fortran
use nswc_interfaces, only: sgefa, sgesl
```

Remove local declarations or interface blocks for the imported procedures to
avoid duplicate declarations. All library interfaces, including helpers, are
public; importing selected names avoids conflicts with local variables or other
libraries. The documented routines remain the preferred entry points.

For the unchanged fixed-form versions, create an interface view without the new
attributes before compiling the module:

```sh
python tools/interface_variants.py nswc_interfaces.f90 --output legacy_interfaces.f90
gfortran -c legacy_interfaces.f90
```

The legacy view defines the same module name, `nswc_interfaces`; compile either
the modern view or the legacy view for the selected library version. The
interface validator selects the appropriate view when testing `nswc.f`.
The archived `nswc_orig.f` predates
the declaration corrections in the [warning review](compiler-warnings.md); its
existing tests continue to use their historical declarations.

## Building

Compile the interface module and library with the same compiler and consistent
default kind settings. Compiler-produced `.mod` files are not distributed; each
user compiles the portable interface source.

GNU Fortran:

```sh
gfortran -c nswc_interfaces.f90
gfortran -c -std=legacy nswc.f90
gfortran myprogram.f90 nswc.o -o myprogram
```

Intel Fortran, from an initialized compiler environment:

```sh
ifx /c nswc_interfaces.f90
ifx /c /warn:nointerfaces nswc.f90
ifx myprogram.f90 nswc.obj /exe:myprogram.exe
```

The library's known real/complex workspace overlap still prevents Intel's
automatic checking of every internal legacy call. `/warn:nointerfaces` is used
for that library compilation. Explicit checks from `USE nswc_interfaces` in
callers remain active, as verified by deliberately invalid test calls.
Only one version of the library should be linked.

## Generation

The interfaces were generated using Intel Fortran 2025.0.4 with
`/syntax-only /gen-interfaces:source /warn:interfaces`. Intel documents that the
emitted source is for reference and may not fully describe its internal
interface, so generation is followed by independent verification.
[Intel generation option](https://www.intel.com/content/www/us/en/docs/fortran-compiler/developer-guide-reference/2026-0/gen-interfaces.html)

After changing the maintained source, first regenerate its free-form version,
then regenerate and verify the interfaces:

```sh
python tools/regenerate_sources.py
python tools/generate_interfaces.py
python tools/validate_interfaces.py
```

The generator expects `ifx` on the command search path. Alternatively, use
`--ifx PATH_TO_IFX`. On Windows, `--intel-env PATH_TO_ENVIRONMENT_BATCH` can
initialize the Intel and Visual Studio environment in a child process. A local
setup batch file is also supported. No system environment settings are changed.

Generation checks the complete free-form library together in a temporary
directory. `COMPB` now supplies separate real and complex work arrays to `PPADD`,
so interface extraction no longer needs to isolate that call. Every procedure
must produce exactly one generated interface.

The assembler removes timestamps and compiler module wrappers, adds
`IMPLICIT NONE` to each interface body, and combines the bodies into one module.
Intel's default kind numbers are replaced with their matching source-level
types: default `INTEGER`, `REAL`, `COMPLEX`, and `LOGICAL`, plus
`DOUBLE PRECISION`. Unexpected kind mappings are rejected. Array conventions,
including explicit bounds and assumed-size arrays, are preserved.

`tools/interface-generation.json` records compiler provenance, kind mappings,
procedure and callback counts, exceptions, and source/module/review hashes.
For a fresh Intel regeneration check:

```sh
python tools/generate_interfaces.py --check
```

Ordinary compilation and GNU validation do not require Intel Fortran.

## Verification

```sh
python tools/validate_interfaces.py
python tools/validate_interfaces.py --ifx PATH_TO_IFX --intel-env PATH_TO_ENVIRONMENT_BATCH
```

The independent GNU check compares 9,289 procedure, argument, and function-result
records against the maintained library: names, argument order, types, array
shapes, intents, and relevant argument attributes. Subroutine callback use
inference is distinguished from the callback's declared interface.
The combined module must also compile as standard Fortran 2008 with GNU Fortran.
Source and module hashes detect stale artifacts.

The validator makes temporary copies of all 49 numerical main programs. It
replaces their library interface blocks and external declarations with selected
module imports, preserving their own callback interfaces and executable tests.
Each original and modified caller is built, run, and checked for identical
diagnostics. This gives 96 runs per library source and compiler. The free-form
and fixed-form sources were both checked with GNU Fortran and Intel Fortran.
To select the fixed-form source, add `--source nswc.f`; the default is `nswc.f90`.

Eleven pairs of valid and invalid calls check integer types, array ranks, output
constants, real precision, missing arguments, and callback function result
types, plus callback arity, parameter types, ranks, intents, and array descriptors.
The valid version must compile and the invalid version must fail.
GNU verification also runs in GitHub Actions.

## Callback contracts

The generator supplements Intel's implicit callback declarations with 22
reviewed abstract interfaces from `tools/callback_interfaces.py`. These describe
116 of the 126 callback arguments, including functions, subroutines, array
dimensions, and intents. The review inventory must account for every callback.
The validator checks the emitted contracts against the review and independently
compares the original declarations after removing these deliberate additions.

For example, a callback passed to `QAGS` can be written as:

```fortran
real function integrand(x)
  implicit none
  real, intent(in) :: x
  integrand = x*x
end function integrand
```

Fortran requires matching callback characteristics when an explicit interface
is visible. This includes intent and array conventions: `X(N)`, `X(*)`, and
`X(:)` are different contracts. Callbacks in callers opting into the module may
need their declarations adjusted. The library sources and historical callers
are unchanged. Give the compiler an explicit interface to the actual callback,
for example by making it an internal or module procedure, for full checking.
The public `nswc_cb_*` abstract interfaces can also be imported to declare
procedure arguments. Inspect their definitions for the required declarations.
MINPACK residual vectors use `INTENT(INOUT)` so a callback can preserve them
when invoked only to report progress.

Ten callback arguments retain implicit interfaces for specific reasons:

| Procedure and callback | Reason |
|---|---|
| `SRCH:COND` | Its actual procedures `ACOND` and `XCOND` have incompatible intents |
| `QAGI1:F`, `QAGIE1:F`, `QK15I1:F` | The actual procedures `ACONDF`, `ACONDG`, and `XCONDY` have incompatible intents |
| `STFODE:JAC`, `LSOD1:JAC`, `STOD:JAC`, `PJAC:JAC` | The internal `ZZZJAC` placeholder differs from the user Jacobian convention |
| `BLKTR1:PRDCT` | `PROD0` and `PRODP` have incompatible workspace intents |
| `BLKTR1:CPRDCT` | The real/complex workspace association needs a separate review |

These exceptions avoid imposing a contract that rejects an existing library
implementation. Callback result types remain checked where declared, but their
parameter lists are unchecked. Resolving the exceptions requires separate
changes to declarations or adapters and further tests.

The numerical suite remains representative rather than a validation of every
library algorithm.
