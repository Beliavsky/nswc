# NSWC manual Markdown: source audit

The original 1993 report (**NSWCDD/TR-92/425**, Alfred H. Morris, Jr.) was
OCR-transcribed into Markdown. This revision cross-checks the *interface information*
against the supplied `nswc_orig.f` fixed-form Fortran source.

## What was checked

- **1,062** procedure declarations extracted from `nswc_orig.f` (including support routines).
- **576** names assigned to documented manual topics, grouped into **255** topics.
- **259** topical sections in the revised manual; four are explanatory chapters without source-level entry points.
- **429** in-text Fortran interface examples normalized to source declarations.
- **51** occurrences of clearly misrecognized procedure names corrected in their associated topics.
- The previously merged **Exponentials** topic was restored as a separate headed section.
- The original alphabetic procedure index was rebuilt from source-matched names, removing references to nonexistent procedures and unsupported OCR artifacts.
- Source line references were generated for each checked interface. For reliable GitHub viewing, links now target free-form partitions of `nswc.f90`. Displayed line numbers refer to that file; the supplied source is preserved unmodified as `nswc_orig.f`.

## Examples of substantive OCR/interface corrections

| Topic | Earlier transcription | Source-based correction |
|---|---|---|
| `topic-028-03` | `CALL ROTA(2r,, 91,9, 22, y2)` | `CALL ROTA(X1, Y1, A, X2, Y2)` |
| `topic-029-01` | `CALL SROTG(AR,BZ,C,: ,` | `CALL SROTG(SA, SB, SC, SS)` |
| `topic-072-01` | `CALL DGRAT(c, 2, P,Q ERR)` | `CALL DGRAT(A, X, ANS, QANS, IERR)` |
| `topic-082-01` | `CALL BESI( 7,0, MO n, Wk)` | `CALL BESI(X, ALPHA, KODE, N, Y, NZ)` |
| `topic-086-01` | `CALL CAI(IND,z, w, w’ JERR)` | `CALL CAI(IND, Z, AI, AIP, IERR)` |
| `topic-096-01` | `CALL RJVAL(a, 6.¢, 7, uw JERR)` | `CALL RJVAL(X, Y, Z, P, RJ, IERR)` |
| `topic-102-01` | `CALL PEQ(z, ee RR)` | `CALL PEQ(Z, W, IERR)` |
| `topic-110-01` | `CALL PLCOPY(A. ka, m, B, kb, n)` | `CALL PLCOPY(A, KA, M, B, KB, N)` |
| `topic-121-01` | `CALL ORTHOX(n, Horn c')` | `CALL ORTHOX(NA, AR, NC, AC)` |
| `topic-129-01` | `CALL CBND(n, A, Z,R,RERR,K JERR)` | `CALL CBND(N, C, W, ABSERR, RELERR, KLUST, KER)` |
| `topic-133-01` | `CALL DROTMG(2,, D2, Bi, B2,Q)` | `CALL DROTMG(DD1, DD2, DX1, DY1, DPARAM)` |
| `topic-138-01` | `CALL CAXPY(n,a,X,kr ¥, ky)` | `CALL CAXPY(N, CA, CX, INCX, CY, INCY)` |
| `topic-163-01` | `CALL NPIVOT(n,m. A, ke, kb, DS TERR)` | `CALL NPIVOT(N, M, A, KA, B, KB, D, IERR)` |
| `topic-168-01` | `CALL SLVMP(MO,n, A, ka, 6, ¥.WK,IWK IND)` | `CALL SLVMP(MO, N, A, KA, B, X, WK, IWK, IERR)` |
| `topic-169-01` | `CALL ARCECO(n, S.MTR,m,IWK,},X,IND)` | `CALL ARCECO(N, ARRAY, MTRSTR, NMBLKS, PIVOT, B, X, IFLAG)` |
| `topic-173-01` | `CALL SMSLV(MO.n,»:, A, B, kb, Dy OND, INERT, IERR,IPVT,WK)` | `CALL SMSLV(MO, N, M, A, B, KB, DET, RCOND, INERT, IERR, IPVT, WK)` |

## Scope and unresolved limitations

A subsequent manual prose pass reviewed the spelling-tool findings one Markdown
file at a time and kept the complete manual consistent with the chapter edits.
The singular-value-decomposition description of U was checked against scan 183;
the uniform integer-selection description, error returns, and usage examples
were checked against scan 438 and the URGET source. The
[per-file review record](docs/proofreading-review.csv) identifies the remaining
tool flags. These corrections do not remove the limitations below.

1. **Names, arity, order of dummy arguments, and function/subroutine classification**
   are verified directly against the code. The presentation uses the identifiers from
   the source, which sometimes differ from those printed in the manual. Dummy
   argument names are not part of Fortran's positional calling convention.
2. **Narrative and mathematics are only partially corrected.** The original scanned
   report has difficult OCR (especially multi-line equations, Greek letters,
   superscripts, array subscripts, and mathematical notation). The corrected API
   tables do **not** imply that nearby OCR paragraphs are mathematically reliable.
3. **Types of dummy arguments are not exhaustively annotated.** For exact declarations,
   dimensions, workspace requirements, error codes, algorithm details, and precision
   limits, inspect the source and the corresponding scan. A source signature alone
   cannot validate the explanatory text.
4. **No numerical regression tests** were executed in this documentation review.
5. The source includes routines that the 1993 manual may intentionally omit as
   implementation details. The separate inventory lists these but does not promote
   them to documented public interfaces.
6. The scanned report is an independent authority for what was documented in 1993;
   a source declaration differing from its printed example may reflect legitimate
   changes or alternate dummy names. The readable versions change source layout and procedure endings; no numerical algorithm changes are intended. The supplied source is preserved in `nswc_orig.f`.

## Source readability conversion

The recommended source is now `nswc.f90`. The readable fixed-form alternative
`nswc.f` has named endings for all 1,062 procedures and blank lines between
procedures. `nswc_orig.f` preserves the supplied source unchanged. The conversion
tools and regeneration instructions are described in [README.md](README.md).

A subsequent pass replaced 2,548 straightforward labelled DO/CONTINUE loops
with DO/END DO. Another 1,699 labelled loops were left unchanged because of
shared labels, executable terminators, possible references, or uncertain control
flow. The [conversion record](docs/loop-modernization.csv) reports all candidates
and skipped reasons. Tests reproduce the maintained source from `nswc_orig.f`
by applying the named-ending and loop converters, and verify that a second loop
conversion makes no changes.

Checks compare every fixed-form and free-form statement while preserving quoted
and Hollerith text, verify all 2,214 documentation source links, and confirm that
the free-form partitions reconstruct the complete file. All three versions
compile with GNU Fortran using the documented legacy options, with the same
28 warnings in the local compiler check. Representative numerical checks of
vector operations, a dense linear solve, the gamma function, Chebyshev evaluation, and adaptive
quadrature produce identical results across all three versions. These checks
do not constitute a full numerical validation of the library.

The numerical suite now also includes 22 standalone main programs adapted from
the legacy drivers in `C:/fortran/amiller-nswc`, in addition to the smoke test.
The [test guide](docs/numerical-tests.md) records their coverage and adaptations.
The runner builds each program against each library version separately and
checks expected results, completion, and agreement of the emitted diagnostics.

Ten reviewed explicit typing batches now cover 296 procedures. Types generated by
`ftnchek` were supplemented for omitted function return types and a forwarded
function callback. A compiler symbol comparison verifies preservation of types,
shapes, storage attributes, and argument lists. The
[typing record](docs/explicit-typing.md) describes the batches, scope, and limitations.

## GitHub structure

```
README.md
docs/*.md (28 topic chapters and the documented-routine index)
NSWC_Library_of_Mathematics_Subroutines_complete.md
nswc.f90 (recommended free-form source)
nswc.f (maintained readable fixed-form source)
nswc_orig.f (unchanged supplied source)
NSWC_Source_Audit.md
NSWC_Source_Interfaces.md
source_parts/nswc_part_01.f90 ... (browseable source partitions)
scans/page_0001.png ... scans/page_0463.png
```

The Markdown links the scan images and source declarations through relative paths.
For Markdown-only use, keep those additional files alongside the README, or remove
those links when publishing just the text.

**Rights note:** "Approved for public release; distribution unlimited" is not itself a named open-source license; verify any separate rights or attribution requirements before relicensing or redistributing the Fortran source.
