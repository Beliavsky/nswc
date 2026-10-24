[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-015"></a>
## Introduction

<small>Original source: [View scanned PDF page 15](../scans/page_0015.png) and
[page 16](../scans/page_0016.png)</small>

Development of the NSWC library began in 1976 with the objective of providing
general-purpose Fortran subroutines for numerical mathematics. Although the
original target was the CDC 6000-7000 family, transportability was a major design
goal. The report describes the library's seventh edition (1993).

The 1993 library contains **more than 1,060 subroutines**, of which **576** are
covered in this report for general use; the others are primarily support routines.
Approximately 40 percent were developed at NSWCDD, with the remainder contributed
by governmental, academic, and other research institutions. The library contains
single- and double-precision implementations. The design target was 6-14
significant digits in single precision and 12-30 in double precision, depending
on the arithmetic available.

The library's stated criteria for accepting software were reliability,
transportability, efficiency, and ease of use. Algorithms and implementations
were reviewed and tested for numerical accuracy, robustness, and computational
efficiency. Routines could be modified or dropped as algorithms improved.

Portability required compliance with **ANSI Fortran 77**. Machine-dependent
constants and precision-dependent algorithms were unavoidable, but other
machine-dependent constructs were not permitted. `ENTRY` statements and global
variables were excluded. `EQUIVALENCE` and `COMMON` were permitted only with
strong reservations; values defined by `DATA` were not to be reassigned.

To give calling programs control over errors, the library avoided input/output
statements. A function reported errors by returning a special value, while a
subroutine was expected to report status through explicit arguments. Functions
were not supposed to modify their arguments. The published precision estimates
refer to the CDC 6000-7000 series' historical arithmetic and do not include
inherent errors of the mathematical functions being evaluated.

The report states that proprietary or otherwise restricted implementations were
not accepted, and that source code was made available to the scientific community.
This is a statement about the library's **historical distribution policy**, not
a determination of the modern copyright or software-license status of each routine.

