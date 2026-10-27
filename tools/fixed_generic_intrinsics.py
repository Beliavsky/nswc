"""Replace compiler-reviewed specific intrinsic calls in fixed-form source.

Reuse the generic-intrinsic binding review and compiler equivalence checks.
Preserve fixed columns, comments and strings in executable records. Preview
requires a checked-in review; --review creates a new, compiler-verified one.
"""
import argparse
from bisect import bisect_left
import hashlib
import json
from pathlib import Path
import re
import tempfile

from explicit_typing import units
from fixed_to_free import convert_text
from lowercase_fortran import lowercase
from name_procedure_ends import statements, code_comment, split_line
from combine_declarations import emit, split_list
from generic_intrinsics import (MAPPING, EXPLICIT_BINDINGS, TOKEN, declaration,
                                compile_dump, review as free_review, symbols, verify)

MANIFEST = Path(__file__).with_name('fixed-generic-intrinsics.json')


def digest(data):
    return hashlib.sha256(data).hexdigest()


def transform(data, manifest=None):
    manifest = json.loads(MANIFEST.read_text()) if manifest is None else manifest
    if manifest.get('output_sha256') == digest(data):
        return data
    if manifest.get('input_sha256') != digest(data):
        raise ValueError('Fixed source differs from its intrinsic binding review')
    if manifest['mapping'] != MAPPING:
        raise ValueError('Intrinsic mapping changed since review')
    lines, scopes = units(data)
    logicals = list(statements(lines))
    starts = [s.lines[0] for s in logicals]
    edits = {}
    library = {n.lower() for n in scopes}
    for name, entry in manifest['procedures'].items():
        start, _, stop = scopes[name]
        selected = set(entry['calls'])
        counts = dict.fromkeys(selected, 0)
        declared, vacant = set(), []
        unit = logicals[bisect_left(starts,start):bisect_left(starts,stop)]
        for s in unit:
            code = s.code
            decl = declaration(code)
            intrinsic = re.match(r'^\s*intrinsic\s+(?:::)?\s*(.*)',code,re.I)
            replacement = None
            if decl and selected & {n.lower() for n,_,_ in decl[2]}:
                kept = [n+shape+length for n,shape,length in decl[2] if n.lower() not in selected]
                if '::' not in code:
                    raise ValueError(f'{name}: type declaration needs ::')
                replacement = (code.split('::',1)[0].strip()+' ::',kept)
            elif intrinsic:
                names = split_list(intrinsic[1])
                revised = [MAPPING[n.lower()].upper() if n.lower() in selected else n for n in names]
                declared.update(n.lower() for n in revised)
                if revised != names:
                    replacement = ('INTRINSIC ::',list(dict.fromkeys(revised)))
            if replacement is not None:
                if any(lines[j][:5].strip() or lines[j].rstrip('\r\n')[72:].strip()
                       or code_comment(lines[j][6:72])[1] for j in s.lines):
                    raise ValueError(f'{name}: labelled/annotated declaration needs review')
                _, newline = split_line(lines[s.lines[0]])
                records = emit(*replacement,newline) if replacement[1] else []
                if len(records)>len(s.lines):
                    raise ValueError(f'{name}: declaration needs more fixed records')
                for offset,index in enumerate(s.lines):
                    edits[index] = records[offset] if offset<len(records) else split_line(lines[index])[1]
                    if offset>=len(records):
                        vacant.append(index)
                continue
            if decl or intrinsic or re.match(r'^\s*format\b',code,re.I):
                continue
            fields, quote = [], ''
            for index in s.lines:
                raw, newline = split_line(lines[index])
                field, comment, quote = code_comment(raw[6:72],quote)
                fields.append((index,raw,newline,field,comment,quote))
            if any(f[-1] for f in fields) or re.search(r'\d+H',code,re.I):
                if any(re.search(r'\b'+alias+r'\b',code,re.I) for alias in selected):
                    raise ValueError(f'{name}: continued string or Hollerith requires review')
                continue
            tokens = [(f[0],m) for f in fields for m in TOKEN.finditer(f[3])]
            changes = {}
            for (index,token),(_,following) in zip(tokens,tokens[1:]):
                alias = token[0].lower()
                if alias in selected and following[0] == '(':
                    changes.setdefault(index,[]).append((token.start(),token.end(),MAPPING[alias].upper()))
                    counts[alias] += 1
            for index,raw,newline,field,comment,_ in fields:
                if index not in changes:
                    continue
                revised = field
                for first,last,value in reversed(changes[index]):
                    revised = revised[:first]+value+revised[last:]
                if len(revised)>len(field):
                    raise ValueError('Intrinsic replacement unexpectedly grows a record')
                if comment:
                    revised = revised.ljust(len(field))+comment
                body = raw[:6]+revised
                if len(raw)>72:
                    body = body.ljust(72)+raw[72:]
                edits[index] = body+newline
        if counts != entry['calls']:
            raise ValueError(f'{name}: fixed-form call counts differ from compiler review: {counts} != {entry["calls"]}')
        required = {MAPPING[n] for n in selected & EXPLICIT_BINDINGS} & library
        if required-declared:
            implicit = next((s.lines[-1] for s in unit if re.fullmatch(r'\s*IMPLICIT\s+NONE\s*',s.code,re.I)),None)
            if not vacant and implicit is None:
                raise ValueError(f'{name}: explicit generic binding needs a declaration slot or IMPLICIT NONE')
            index = vacant[0] if vacant else implicit
            _,newline = split_line(lines[index])
            binding = emit('INTRINSIC ::',sorted(n.upper() for n in required-declared),newline)
            if len(binding)!=1:
                raise ValueError(f'{name}: explicit intrinsic binding needs more records')
            edits[index] = binding[0] if vacant else edits.get(index,lines[index])+binding[0]
    return ''.join(edits.get(i,line) for i,line in enumerate(lines)).encode('latin-1')


def review(data, compiler='gfortran'):
    free = lowercase(convert_text(data.decode('ascii')))
    with tempfile.TemporaryDirectory(prefix='nswc-fixed-generics-') as work:
        before = compile_dump(data.decode('ascii'),work,compiler,fixed=True)
        manifest = free_review(free,symbols(before[0],True))
        manifest['input_sha256'] = digest(data)
        output = transform(data,manifest)
        from validate_explicit_typing import non_declaration_content
        if non_declaration_content(data)[1] != non_declaration_content(output)[1]:
            raise ValueError('Fixed generic conversion changed comment text or order')
        verify(before,compile_dump(output.decode('ascii'),work,compiler,fixed=True),manifest)
    manifest['output_sha256'] = digest(output)
    return manifest


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source',type=Path)
    parser.add_argument('--review',type=Path)
    parser.add_argument('--manifest',type=Path,default=MANIFEST)
    parser.add_argument('--output',type=Path)
    parser.add_argument('--compiler',default='gfortran')
    args = parser.parse_args()
    for path in (args.review,args.output):
        if path and path.exists():
            parser.error(f'Output must name a new file: {path}')
    if args.review and args.output and args.review.resolve()==args.output.resolve():
        parser.error('Review and source output must be separate files')
    data = args.source.read_bytes()
    manifest = review(data,args.compiler) if args.review else json.loads(args.manifest.read_text())
    output = transform(data,manifest)
    if args.review:
        with args.review.open('x',newline='\n') as stream:
            stream.write(json.dumps(manifest,indent=2)+'\n')
    if args.output:
        with args.output.open('xb') as stream:
            stream.write(output)
    print(manifest['summary'])
    print('Source already converted.' if output==data else 'Reviewed replacements ready.')

if __name__ == '__main__':
    main()
