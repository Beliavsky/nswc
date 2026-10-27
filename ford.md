project: NSWC Mathematics Library
summary: Procedure reference for the modern NSWC module.
project_github: https://github.com/Beliavsky/nswc
src_dir: reports/ford-input
output_dir: reports/ford-site
preprocess: false
docmark_alt: @
graph: false
search: true
warn: false
display: public
source: true

The NSWC mathematics library provides 1,062 public procedures.

This reference documents `nswc_mod.f90`. The external-procedure versions have
matching procedure names and arguments; the module supplies explicit interfaces.

Detailed FORD comments are being introduced in reviewed batches. The first batch
covers machine constants, a scalar function, sorting, and an ODE integration step.

- [Chapter manual](https://github.com/Beliavsky/nswc/blob/main/NSWC_Library_of_Mathematics_Subroutines_complete.md)
- [Source and interfaces](https://github.com/Beliavsky/nswc/blob/main/NSWC_Source_Interfaces.md)

Run `python tools/build_ford.py` from the repository root to regenerate this site.
