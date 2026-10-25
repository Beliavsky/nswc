# Optional external procedure interfaces

`nswc_interfaces.f90` describes all 1,062 external procedures in the maintained
`nswc.f90` and `nswc.f`. It contains interface blocks, without implementations.
Existing callers can keep their historical external calls. New callers can opt
into compiler argument checking:

```fortran
use nswc_interfaces, only: sgefa, sgesl
```

Remove local declarations or interface blocks for the imported procedures to
avoid duplicate declarations. All library interfaces, including helpers, are
public; importing selected names avoids conflicts with local variables or other
libraries. The documented routines remain the preferred entry points.

The module describes the maintained sources. The archived `nswc_orig.f` predates
the declaration corrections in the [warning review](compiler-warnings.md); its
existing tests continue to use their historical declarations.

## Building

Compile the interface module and library with the same compiler and consistent
default kind settings. Compiler-produced `.mod` files are not distributed; each
user compiles the portable interface source.

GNU Fortran:

```sh
gfortran -c nswc_interfaces.f90
gfortran -c -std=legacy -fallow-argument-mismatch nswc.f90
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

Generation uses two isolated temporary directories. One contains the library
without `COMPB`; the other contains `COMPB` alone. This avoids the known
nonconforming `COMPB`/`PPADD` workspace association stopping interface extraction.
It does not change that call or establish its correctness. Every procedure must
produce exactly one generated interface.

The assembler removes timestamps and compiler module wrappers, adds
`IMPLICIT NONE` to each interface body, and combines the bodies into one module.
Intel's default kind numbers are replaced with their matching source-level
types: default `INTEGER`, `REAL`, `COMPLEX`, and `LOGICAL`, plus
`DOUBLE PRECISION`. Unexpected kind mappings are rejected. Array conventions,
including explicit bounds and assumed-size arrays, are preserved.

`tools/interface-generation.json` records compiler provenance, kind mappings,
procedure count, and source/module hashes. For a fresh Intel regeneration check:

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

The validator makes temporary copies of all 44 numerical main programs. It
replaces their library interface blocks and external declarations with selected
module imports, preserving their own callback interfaces and executable tests.
Each original and modified caller is built, run, and checked for identical
diagnostics. This gives 88 runs per library source and compiler. The free-form
and fixed-form sources were both checked with GNU Fortran and Intel Fortran.
To select the fixed-form source, add `--source nswc.f`; the default is `nswc.f90`.

Six pairs of valid and invalid calls check integer types, array ranks, output
constants, real precision, missing arguments, and callback function result
types. The valid version must compile and the invalid version must fail.
GNU verification also runs in GitHub Actions.

The emitted callback declarations retain implicit callback interfaces: they
identify procedures and function result types but do not fully describe their
parameter lists. Full checking of callback parameters would require additional
reviewed abstract interfaces. The numerical suite remains representative rather
than a validation of every library algorithm.
