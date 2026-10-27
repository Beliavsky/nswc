"""Add reversible, reviewed FORD prologues to generated free-form sources."""
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


def transform(text):
    review=json.loads(MANIFEST.read_text());original=strip(text)
    lines=original.splitlines(True);edits={}
    for name,start,end in procedure_spans(original):
        if name in review['procedures']:
            records,_=next(groups(lines[start:end]))
            edits[start+records[-1].index+1]=block(name,review['procedures'][name])
    for i,line in enumerate(lines):
        if edits and re.fullmatch(r'\s*module\s+nswc_mod\s*\n',line,re.I):
            edits[i+1]=block('NSWC_MOD','''NSWC mathematics library with explicit interfaces.

The public API contains 1,062 procedures grouped by mathematical topic.
Use `use nswc_mod, only: ...` to import the procedures needed by an application.
Machine kinds and shared solver state are private implementation details.

Detailed FORD prologues are introduced in reviewed batches. The original
algorithm comments and chapter manual provide additional documentation.''')
    result=''.join(edits.get(i,'')+line for i,line in enumerate(lines))+edits.get(len(lines),'')
    result=result.replace(review['ipmpar_legacy'],HISTORY_BEGIN+review['ipmpar_legacy']+HISTORY_END)
    if strip(result)!=original:raise ValueError('FORD annotation changed the underlying source')
    return result
