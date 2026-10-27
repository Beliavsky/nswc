# Generated API reference with FORD

The FORD site documents all 1,062 public procedures in `nswc_mod.f90`.
Individually reviewed descriptions cover `ipmpar`, `spmpar`, `cbrt`, `shell`,
and `stod`. Other pages import available introductory comments, preserving
formulas, tables, and examples as literal text. Procedures without introductory
comments explicitly identify the missing description. Imported notes are legacy
documentation and have not been individually reconciled with source changes.

## Build and browse

From the repository root:

```sh
python -m pip install -r requirements-docs.txt
python tools/build_ford.py
python tools/build_ford.py --check
```

Open `reports/ford-site/index.html` in a browser. The generated files can also
be served with `python -m http.server --directory reports/ford-site`.

The build stages only `nswc_mod.f90`. This avoids duplicate procedure pages
from the external source, fixed source, interface module, tests, and source
partitions. The build uses relative project paths and validates that its
output stays under this repository's `reports` directory. It refuses to
replace a nonempty output directory without its ownership marker.

`ford.md` controls the front page and FORD settings. The tested FORD version
is pinned in `requirements-docs.txt`. The alternate documentation marker is set to `@` because legacy `!*` separator
comments must remain ordinary comments. Graph generation is disabled, so the
build does not require a Graphviz executable. GitHub Actions builds the site
and uploads the `nswc-ford` artifact; publication to GitHub Pages is a separate
step.

## Maintain the comments

Edit or add reviewed Markdown prologues in `tools/ford-documentation.json`, then
run `python tools/regenerate_sources.py`. Keep prologues in ASCII to match
the existing Fortran source checks. The generator inserts `!!` comments
immediately after each complete procedure header in both free-form sources.
It also adds a module overview. It preserves the existing declarations,
algorithm comments, and executable statements. `nswc.f` and `nswc_orig.f`
are preserved as the fixed-form inputs.

The reviewed descriptions use argument/result tables, restrictions, a fenced block for
machine-model formulas, and FORD links such as `[[ipmpar]]`. The old `ipmpar`
instructions about selecting DATA tables are explicitly marked as historical
instructions for `nswc_orig.f`; the active implementation uses the `imach`
named constant.

For other procedures, `tools/ford_documentation.py` collects contiguous comments
before the procedure header and comments within its specification part. It handles
continued declarations and callback interfaces, and stops at the first executable
statement. Local-declaration markers and decorative separators are omitted.
Implementation-body comments remain ordinary comments. The imported notes are
copied into managed prologues; their original locations are preserved so stripping
the documentation restores the exact numerical source. A reviewed entry overrides
this automatic import. Adding comments to the fixed source therefore flows into
the generated reference through the existing regeneration pipeline.

The managed comment markers make the documentation pass reversible and
idempotent. Existing source-reproduction checks remove only those managed
additions before comparing their historical baseline. The comment-case report
maps its original findings to the new source line numbers. Raw source hashes
used by the explicit-interface and shared-constant reviews are refreshed.

The build checks the exact set of procedure pages, the module and front page,
every procedure description and imported note, argument/result tables, literal
formulas, and resolved procedure links. Build metadata records counts of reviewed
and imported prologues and lists procedures lacking original descriptions.
This checks that the prologues appear as API documentation,
rather than merely as text in the source-code panel.

FORD distinguishes documentation comments from ordinary implementation comments;
see its [documentation conventions](https://forddocs.readthedocs.io/en/stable/user_guide/writing_documentation.html)
and [project settings](https://forddocs.readthedocs.io/en/stable/user_guide/project_file_options.html).
