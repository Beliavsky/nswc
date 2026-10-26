# Unused statement labels

The maintained `nswc.f` removes 993 unreferenced labels and 197 redundant
CONTINUE statements. The same cleanup flows through source generation to
`nswc.f90`, `nswc_mod.f90` and the source partitions. The original `nswc_orig.f`
remains unchanged.

For example, SHELL's unreferenced `10 CONTINUE` disappears. The statement
`40 I = I - 1` becomes `I = I - 1`; the assignment stays in its original place.
Its labels 20, 30 and 31 remain because branches refer to them.

## Conservative reference analysis

`tools/remove_unused_labels.py` understands direct and computed GO TO targets,
arithmetic IF destinations, labelled DO termination, I/O `ERR`/`END`/`EOR` labels,
and alternate-return arguments. Each external procedure has its own label scope.
Strings, Hollerith text, comments and ordinary numbers are excluded from target
analysis. Thus a DATA value of 40 does not retain statement label 40.

FORMAT labels are always preserved, including unused ones. Labels on
specifications and ambiguous initial array assignments are retained. Procedures
with ASSIGN, indirect GO TO, duplicate labels, unresolved targets or uncertain
Hollerith/comment boundaries are skipped
as a whole. All NSWC procedures could be analyzed without such a skip.

Only an unreferenced, single-record CONTINUE with a blank sequence field
is deleted. Inline comments become comment-only records; comment text and order
are preserved. Other statements retain their operations, continuation records
and sequence fields; only columns 1--5 lose the unused label. Unsupported file
layout is rejected rather than guessed. This tool supports fixed-form external
subroutines and functions, not arbitrary programs or module source.

## Use and verification

Preview another fixed-form source without changing it:

```sh
python tools/remove_unused_labels.py input.f
```

Write new output and review files after compiler verification:

```sh
python tools/remove_unused_labels.py input.f --output cleaned.f --report labels.json --compiler gfortran
```

Output/report paths must not already exist. Without `--compiler`, the tool
performs reference analysis without claiming compiler equivalence.

The [review report](../tools/unused-labels.json) records every action, its
procedure, original statement and input line number, along with source hashes.
The input is the maintained fixed-form source after the empty-factor correction,
before this cleanup. The fixed-form reconstruction applies label cleanup after
the control-flow and workspace fixes. Reviewed comment-only corrections follow
it; `tools/source_comment_fixes.py` removes SHELL's empty separator before the
final index update.

```sh
python tools/validate_unused_labels.py
python tools/regenerate_sources.py --check
python tools/validate_sources.py
python tools/validate_module.py
```

The label validator independently reconstructs the input, reproduces the review,
checks idempotence and comment preservation, and compares GNU compiler symbol
records, warnings and assembly. Only source-line numbers in runtime diagnostic
strings may differ. Unit regressions exercise all reference forms, literal and
comment handling, scope, continuations, sequence fields and uncertain transfers.
Execution probes run before and after cleanup at `-O0` and `-O2`.

`tools/refresh_label_review_hashes.py` refreshes only source/output hashes and
computed-transfer line numbers after a verified cleanup. It checks that constant
values, purity selections, calls, intrinsic bindings, helper expressions and
types, and private COMMON-state bindings remain unchanged. It is a maintenance
step, not part of ordinary generation.
