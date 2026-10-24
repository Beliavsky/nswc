# NSWC manual Markdown: source audit

The original 1993 report (**NSWCDD/TR-92/425**, Alfred H. Morris, Jr.) was
OCR-transcribed into Markdown. This revision cross-checks the *interface information*
against the supplied `nswc.f` fixed-form Fortran source.

## What was checked

- **1,062** procedure declarations extracted from `nswc.f` (including support routines).
- **576** names assigned to documented manual topics, grouped into **255** topics.
- **259** topical sections in the revised manual; four are explanatory chapters without source-level entry points.
- **429** in-text Fortran interface examples normalized to source declarations.
- **51** occurrences of clearly misrecognized procedure names corrected in their associated topics.
- The previously merged **Exponentials** topic was restored as a separate headed section.
- The original alphabetic procedure index was rebuilt from source-matched names, removing references to nonexistent procedures and unsupported OCR artifacts.
- Source line references were generated for each checked interface. For reliable GitHub viewing, links target partitions of `nswc.f` (the original source file is preserved unmodified).

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
   changes or alternate dummy names. No behavior changes were made to `nswc.f`.

## GitHub structure

```
README.md
docs/*.md (28 topic chapters and the documented-routine index)
NSWC_Library_of_Mathematics_Subroutines_complete.md
nswc.f
NSWC_Source_Audit.md
NSWC_Source_Interfaces.md
source_parts/nswc_part_01.f ... (browseable source partitions)
scans/page_0001.png ... scans/page_0463.png
```

The Markdown links the scan images and source declarations through relative paths.
For Markdown-only use, keep those additional files alongside the README, or remove
those links when publishing just the text.

**Rights note:** "Approved for public release; distribution unlimited" is not itself a named open-source license; verify any separate rights or attribution requirements before relicensing or redistributing the Fortran source.
