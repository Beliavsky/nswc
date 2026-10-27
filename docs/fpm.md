# Building and using the fpm package

The repository is an fpm library package named `nswc`. It builds only the
module implementation in `src/nswc_mod.f90`, with all 1,062 public procedures.
The fixed-form sources, external-procedure sources, source partitions, and
maintenance tests are outside fpm's library source directory.

## Build, test, and run examples

Install a Fortran compiler and [fpm](https://fpm.fortran-lang.org/install/index.html),
then run these commands from the repository root:

```sh
fpm build
fpm test
fpm run --example --all
```

The package has 54 numerical test drivers and three examples: `cube_roots`,
`linear_system`, and `integration`. Run a selected target with:

```sh
fpm test test_least_squares
fpm run --example linear_system
```

For optimized builds, add `--profile release`. Select a compiler with
`--compiler gfortran` or `--compiler ifx`; Intel's compiler environment must
already be initialized. The package is tested with fpm 0.12.0 and GNU and Intel
Fortran, in both debug and release profiles. Ordinary builds and tests use the
committed Fortran files; Python is needed only for maintenance checks and
regeneration.

The manifest keeps implicit typing disabled. It allows implicit external
interfaces because some legacy dummy callbacks retain those interfaces, even
though they have explicit `EXTERNAL` declarations. This preserves the existing
callback contracts. GNU's fpm debug profile enables extra warnings and runtime
checks; diagnostics about real comparisons, intrinsic-name overlap, unused
arguments, and array temporaries may appear.

## Use NSWC from another fpm project

Add a Git dependency to the other project's `fpm.toml`:

```toml
[dependencies]
nswc = { git = "https://github.com/Beliavsky/nswc.git", branch = "main" }
```

A `rev` entry can pin a particular commit for reproducible builds. A local
checkout can instead be used with `nswc = { path = "../nswc" }`.
See the [fpm manifest reference](https://fpm.fortran-lang.org/spec/manifest.html)
for dependency and target settings.

Import the required library procedures in the calling code:

```fortran
program demo
   use nswc_mod, only: cbrt
   implicit none
   print *, cbrt([-8.0, 0.0, 27.0])
end program demo
```

The package has no third-party library dependencies. Its module interface is
the same as the root-level `nswc_mod.f90` interface.

## Maintain generated package files

`src/nswc_mod.f90` is an exact generated mirror of the root-level module.
`test/*.f90` are generated module-based versions of the 52 numerical drivers,
the intrinsic-alias driver, and the pure/elemental driver. Their headers identify
the original files under `tests/`; edit those originals when changing tests.
The examples under `example/` are maintained directly.

The periodic solver's package test checks numerical solutions across both
coefficient families and repeated solves. Its private-state branch assertion
remains in the original maintenance test and its temporary diagnostic build;
the package module keeps that state private.

```sh
python tools/generate_fpm.py
python tools/generate_fpm.py --check
python tools/regenerate_sources.py --check
```

Full source regeneration and module-only generation also update the package
mirror and drivers. Their check modes detect stale package files. Only obsolete
drivers bearing the generator's ownership header are removed; additional
handwritten tests are retained.

For independent package verification:

```sh
python tools/validate_fpm.py
python tools/validate_fpm.py --compiler ifx
```

The validator copies only the manifest, module source, drivers, and examples
into a temporary package. It checks all test completion markers in debug and
release builds, runs all examples, and builds a separate downstream application
using a local package dependency. It therefore checks that consumers need no
Python tools or legacy source files. On Windows, `--intel-env PATH_TO_BATCH`
can initialize Intel's environment for the validator. GitHub Actions runs these
checks with GNU and Intel compilers.
