[Home](../README.md) · [Routine index](routine-index.md)

<a id="category-438"></a>
## Discrete Random Number Generation

<small>Original source: [View scanned PDF page 438](../scans/page_0438.png)</small>

<a id="topic-438-01"></a>
### Uniform Random Selection of Values from a Finite Set of Integers

**Source-verified Fortran interfaces**

| Routine | Kind | Dummy arguments in source order | Source declaration |
|---|---|---|---|
| `URGET` | `SUBROUTINE` | `N, IBEG, IEND, IX, L, IERR` | [`L112682`](../source_parts/nswc_part_11.f#L6671) |


Given the integers tg and 3, wh2ret, < 1,. Then the following subroutine is available for selecting integers t where 1, <1 <1,. The selection is performed so that any integer 1 is equally likely to occur w’ ‘i probability 1/m where m = 1, —1, + i. Any integer ¢ mav be selected more than onc When the number of selected values become large, then th. mean and variance of the values approximate the mean and variance of the discrete uniform distribution where

mean = tg + (ts - 14)/2

variance = (m? ~ 1)/12.

```fortran
CALL URGET(N, IBEG, IEND, IX, L, IERR)
```

The argument n is the number of values to be selected, J is an array of dimension n or larger, and tz and [ERR are variables. On input, tz is an integer (called a seed) for initializing the sequence of values. It is assumed that 1 < iz < 23} - 1, When URGET is called, if no input errors are detected then IERR is set to 0 and n values are stored in L. On output, tz is a new seed for selecting more values.

**Error Return.** IERR = Lifn <0, JERR = 2 iff, > 5 or m > 234 — 1, and IERR = 8 if tz is not a proper seed.

Usage. A given seed always initiates the same sequence of values. Thus, the following two sets of instructions

(1) 1X27 CALL URGET(30,0,1,1X,L, ERR)

(2) IX 7 CALL URGET(20,0 1,1X,L,fe RR) CALL URGE T(10,0,1,EX,E(21) HERR)

,

generale the same 380 values (OQ and t).

**Remarks.**

(1) ‘The n values selected need be distinct only when mo 2°! 2 und nom.

(2) [tis assumed that the integer arithmetic being used handles all integers rin the intervat [a[ + nn i

**Programming.** Originally formulated by Joho Ro Criplers Wretten by A TE Meorcts

NWAY)

