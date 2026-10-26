# Pure and elemental contracts

`nswc.f90` has 505 PURE external procedures and 175 PURE ELEMENTAL external
procedures, plus 24 pure internal helpers from the
[statement-function conversion](obsolescent-features.md). The fixed-form
sources retain their existing declarations. Numerical algorithms, argument order,
argument types, bounds, intents, and external linker names remain unchanged.

The [review manifest](../tools/procedure-purity.json) lists all procedures and
attributes. Elemental examples include IPMPAR, GAMMA, DGAMMA, CBRT, DCBRT, ESUM,
DESUM, SROTG, and DROTG. The read-only [DATA conversion](data-constants.md)
removed a purity blocker from coefficient tables and machine constants, expanding
the annotated set from 346 to 680 procedures.

## Calling the procedures

New programs can import procedures directly from the standalone
[module implementation](module.md), using `use nswc_mod, only: ...`.
The following instructions apply to external calls into `nswc.f90`.

Elemental procedures require an explicit interface, even for scalar calls.
Use `nswc_interfaces` or an equivalent local interface block. Pure callers also
need interfaces that expose the purity of the procedures they call.
[Intel interface requirements](https://www.intel.com/content/www/us/en/docs/fortran-compiler/developer-guide-reference/2026-0/procedures-that-require-explicit-interfaces.html)

For example, compile the module and library, then import selected names:

```fortran
program roots
   use nswc_interfaces, only: dcbrt
   implicit none
   print *, dcbrt([-8.0d0, 0.0d0, 27.0d0])
end program roots
```

The implementations remain external, and `nswc.f90` contains the local interfaces
needed by its internal calls. The library itself still compiles as a single file.
The interface module is needed by callers using its contracts, including array
calls and calls from PURE procedures.

For `nswc.f`, generate and compile the legacy interface view described in the
[interface guide](interfaces.md), or use historical caller declarations. That
view omits PURE and ELEMENTAL because the fixed-form definitions do not have
those attributes. The archived `nswc_orig.f` should retain its historical caller
declarations; it predates the separate declaration corrections in the maintained
source.

## Analysis and review

The analysis uses [Fortran-Tools/xpure.py](https://github.com/Beliavsky/Fortran-Tools/blob/main/xpure.py).
The repository adapter recognizes DOUBLE PRECISION declarations and splits
declaration entities at top-level commas, so array bounds cannot be mistaken for
declared variables. It uses strict unknown-call handling and follows the call
graph to a fixed point. Compiler symbols independently check intents and ranks.
Procedures used as actual procedure arguments are excluded from elemental
selection. Array arguments require PURE rather than ELEMENTAL; QUADPL is one
such case rejected by the compiler-rank filter.

The [review manifest](../tools/procedure-purity.json) contains code hashes,
interfaces, call references, candidate rejections, and elemental downgrades.
Many remaining procedures have DATA or SAVE state, I/O, incomplete intent
contracts, calls to impure procedures, or callbacks whose existing interfaces do not promise
purity. Those contracts are preserved. Marking a procedure PURE does not require
its algorithm to be rewritten, and the separate DATA conversion replaces only reviewed read-only tables and constants.
Callback requirements are preserved.

To repeat the analysis with an installed Fortran-Tools checkout, create a new
review file and inspect it before replacing the checked-in manifest:

```sh
python tools/analyze_procedure_purity.py --tool-dir PATH_TO_FORTRAN_TOOLS --output new-review.json
```

The analyzer adds candidate contracts, compiles the transformed source, rejects
or downgrades invalid candidates, and propagates rejected purity to callers.
Regeneration applies the reviewed manifest using Python's standard library;
it does not require the external analyzer. A changed code hash requires a new
review, while comment-only edits do not invalidate the code hashes.

```sh
python tools/regenerate_sources.py
python tools/generate_interfaces.py
python tools/validate_procedure_purity.py
python tools/validate_interfaces.py
```

The purity validator compiles both the unannotated and annotated code, compares
data records, argument lists, result types and executable compiler trees, and
checks each PURE/ELEMENTAL attribute against the review. Its numerical tests
exercise array functions, scalar broadcasting, elemental subroutines and a PURE
caller of SCOPY. A negative test rejects the impure polynomial helper POLYDD in
a PURE caller. `--ifx` and `--intel-env` can additionally run these checks with
Intel Fortran using the same options as the interface validator.
