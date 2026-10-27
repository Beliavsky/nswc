[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-438"></a>
## Discrete Random Number Generation

<small>Original source: [View scanned PDF page 438](../scans/page_0438.png)</small>

<a id="topic-438-01"></a>
### Uniform Random Selection of Values from a Finite Set of Integers

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `URGET` | `SUBROUTINE` | `N, IBEG, IEND, IX, L, IERR` | [`L109160`](../source_parts/nswc_part_11.f90#L3030) |


Given the integers $i_a$ and $i_b$ where $i_a < i_b$. Then the following subroutine is available for selecting integers $i$ where $i_a \leq i \leq i_b$. The selection is performed so that any integer $i$ is equally likely to occur with probability $1/m$ where $m = i_b - i_a + 1$. Any integer $i$ may be selected more than once. When the number of selected values becomes large, the mean and variance of the values approximate the mean and variance of the discrete uniform distribution where

mean = $i_a + (i_b - i_a)/2$

variance = $(m^2 - 1)/12$.

```fortran
CALL URGET(N, IBEG, IEND, IX, L, IERR)
```

The argument n is the number of values to be selected, L is an array of dimension n or larger, and ix and IERR are variables. On input, ix is an integer (called a seed) for initializing the sequence of values. It is assumed that $1 \leq ix < 2^{31} - 1$. When URGET is called, if no input errors are detected then IERR is set to 0 and n values are stored in L. On output, ix is a new seed for selecting more values.

**Error Return.** IERR = 1 if $n \leq 0$, IERR = 2 if $i_a \geq i_b$ or $m \geq 2^{31} - 1$, and IERR = 3 if ix is not a proper seed.

Usage. A given seed always initiates the same sequence of values. Thus, the following two sets of instructions

(1) `IX = 7` followed by `CALL URGET(30,0,1,IX,L,IERR)`.

(2) `IX = 7` followed by `CALL URGET(20,0,1,IX,L,IERR)` and `CALL URGET(10,0,1,IX,L(21),IERR)`.



generate the same 30 values (0 and 1).

**Remarks.**

(1) The n values selected need be distinct only when $m = 2^{31} - 2$ and $n = m$.

(2) It is assumed that the integer arithmetic being used handles all integers i in the interval $|i| \leq 2^{31} - 1$.

**Programming.** Originally formulated by John R. Crigler. Written by A. H. Morris.
