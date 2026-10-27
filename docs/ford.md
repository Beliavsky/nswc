# Generated API reference with FORD

The FORD site indexes all 1,062 public procedures in `nswc_mod.f90`. Its first
reviewed documentation batch covers `ipmpar`, `spmpar`, `cbrt`, `shell`, and
`stod`, plus the module overview. The remaining procedures currently have
signature and source pages; their ordinary algorithm comments and the chapter
manual remain available for further documentation batches.

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

Edit the reviewed Markdown prologues in `tools/ford-documentation.json`, then
run `python tools/regenerate_sources.py`. Keep prologues in ASCII to match
the existing Fortran source checks. The generator inserts `!!` comments
immediately after each complete procedure header in both free-form sources.
It also adds a module overview. It preserves the existing declarations,
algorithm comments, and executable statements. `nswc.f` and `nswc_orig.f`
are preserved as the fixed-form inputs.

The first batch uses argument/result tables, restrictions, a fenced block for
machine-model formulas, and FORD links such as `[[ipmpar]]`. The old `ipmpar`
instructions about selecting DATA tables are explicitly marked as historical
instructions for `nswc_orig.f`; the active implementation uses the `imach`
named constant.

The managed comment markers make the documentation pass reversible and
idempotent. Existing source-reproduction checks remove only those managed
additions before comparing their historical baseline. The comment-case report
maps its original findings to the new source line numbers. Raw source hashes
used by the explicit-interface and shared-constant reviews are refreshed.

The build checks the exact set of procedure pages, the module and front page,
pilot descriptions, argument/result tables, literal formulas, and resolved
procedure links. This checks that the prologues appear as API documentation,
rather than merely as text in the source-code panel.

FORD distinguishes documentation comments from ordinary implementation comments;
see its [documentation conventions](https://forddocs.readthedocs.io/en/stable/user_guide/writing_documentation.html)
and [project settings](https://forddocs.readthedocs.io/en/stable/user_guide/project_file_options.html).
