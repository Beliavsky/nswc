"""Add reversible FORD prologues, preserving legacy introductory comments."""
import json
from pathlib import Path
import re
from fortran_procedures import procedure_spans
from format_free_form import groups
MANIFEST=Path(__file__).with_name('ford-documentation.json')


HISTORY_BEGIN='! FORD historical instructions begin: nswc_orig.f only; see the active model above.\n'
HISTORY_END='! FORD historical instructions end.\n'


def source_lines(text):
    inside=False
    for number,line in enumerate(text.splitlines(True),1):
        if re.fullmatch(r'!! <!-- nswc-ford:begin [A-Z_0-9]+ -->\n',line):
            if inside:raise ValueError('Nested FORD documentation block')
            inside=True
        elif line=='!! <!-- nswc-ford:end -->\n':
            if not inside:raise ValueError('Unmatched FORD documentation marker')
            inside=False
        elif inside:
            if not line.startswith('!!'):
                raise ValueError('Non-documentation line inside a managed FORD block')
        elif not inside and line not in (HISTORY_BEGIN,HISTORY_END):
            yield number,line
    if inside:raise ValueError('Unterminated FORD documentation block')


def strip(text):
    return ''.join(line for _,line in source_lines(text))


def line_numbers(original,annotated):
    retained=list(source_lines(annotated))
    if ''.join(line for _,line in retained)!=original:
        raise ValueError('Documentation did not preserve original source lines')
    return {i:number for i,(number,_) in enumerate(retained,1)}


def block(name,doc):
    return ('!! <!-- nswc-ford:begin '+name+' -->\n'+
            ''.join('!!'+(' '+line if line else '')+'\n' for line in doc.splitlines())+
            '!! <!-- nswc-ford:end -->\n')


SPECIFICATION = re.compile(
    r'^(?:use|import|implicit|integer|real|double\s+precision|complex|logical|'
    r'character|dimension|intent|external|intrinsic|parameter|save|common|'
    r'equivalence|data|optional|allocatable|pointer|target|value|volatile|'
    r'asynchronous|public|private|procedure)\b', re.I)


def preceding_comments(lines, start):
    """Find a contiguous pre-header comment prologue, bounded by preceding code."""
    first=start
    while first and (not lines[first-1].strip() or lines[first-1].lstrip().startswith('!')):
        first-=1
    return lines[first:start]


def introductory_comments(lines, preceding=()):
    """Read comments in the specification part, never execution-body notes.

    Logical records handle continued declarations and nested callback interfaces.
    Literal fences preserve formula alignment, tables and commented examples.
    """
    records = iter(groups(lines))
    header, _ = next(records)
    first = header[-1].index + 1
    stop = len(lines)
    depth = 0
    for physical, code in records:
        code = code.strip()
        if re.match(r'^(?:abstract\s+)?interface\b', code, re.I):
            depth += 1
        elif re.match(r'^end\s*interface\b', code, re.I):
            depth -= 1
        elif not depth and not SPECIFICATION.match(code):
            stop = physical[0].index
            break
    comments = []
    for line in [*preceding,*lines[first:stop]]:
        match = re.match(r'^\s*!(.*)', line.rstrip('\r\n'))
        if not match:
            continue
        content = match[1]
        if 'beginning of local variable declarations' in content.lower():
            continue
        if not re.search(r'[A-Za-z0-9]', content):
            content = ''
        comments.append(content.rstrip())
    # Collapse separator lines, retaining paragraphs and original indentation.
    result = []
    for line in comments:
        if line or (result and result[-1]):
            result.append(line)
    return '\n'.join(result).strip('\n')


def procedure_documentation(name, lines, review, preceding=()):
    if name in review['procedures']:
        return review['procedures'][name]
    legacy = introductory_comments(lines,preceding)
    description = f'Reference for `{name.lower()}`.'
    if legacy:
        # Longer fences cannot be closed by any legacy example containing ```.
        fence = '`' * max(3, 1 + max((len(m[0]) for m in re.finditer(r'`+', legacy)), default=0))
        return (description + '\n\n### Original procedure notes\n\n'
                'Imported from the introductory source comments. These legacy notes\n'
                'have not been individually reconciled with later source changes.\n\n'
                + fence + 'text\n' + legacy + '\n' + fence)
    return (description + '\n\nNo introductory description is present in the original source.\n'
            'The signature below records the declared arguments and their available intents;\n'
            'consult the source and chapter manual for algorithm details.')


def transform(text):
    review=json.loads(MANIFEST.read_text());original=strip(text)
    lines=original.splitlines(True);edits={}
    for name,start,end in procedure_spans(original):
        records,_=next(groups(lines[start:end]))
        edits[start+records[-1].index+1]=block(name,procedure_documentation(name,lines[start:end],review,preceding_comments(lines,start)))
    for i,line in enumerate(lines):
        if edits and re.fullmatch(r'\s*module\s+nswc_mod\s*\n',line,re.I):
            edits[i+1]=block('NSWC_MOD','''NSWC mathematics library with explicit interfaces.

The public API contains 1,062 procedures grouped by mathematical topic.
Use `use nswc_mod, only: ...` to import the procedures needed by an application.
Machine kinds and shared solver state are private implementation details.

Every procedure has a FORD prologue. Five have reviewed descriptions; the
others preserve available introductory source notes as literal text, or
identify a missing original description. Imported notes may describe legacy
implementation details. The chapter manual provides additional documentation.''')
    result=''.join(edits.get(i,'')+line for i,line in enumerate(lines))+edits.get(len(lines),'')
    result=result.replace(review['ipmpar_legacy'],HISTORY_BEGIN+review['ipmpar_legacy']+HISTORY_END)
    if strip(result)!=original:raise ValueError('FORD annotation changed the underlying source')
    return result
