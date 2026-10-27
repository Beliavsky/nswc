"""Consolidate reviewed pi constants in the final named-kind module only.

Match IEEE binary32/binary64 values, then verify all selected spellings with
Fortran compilers. Preserve calculations, coefficient tables and comments.
"""
import argparse
from bisect import bisect_left
import hashlib
import json
from pathlib import Path
import re
import struct
from format_free_form import TOKEN, groups, wrap_line, assignment_equal
from fortran_procedures import procedure_spans
from module_kinds import DEFINITION as KINDS

MANIFEST = Path(__file__).with_name('module-pi-constants.json')
VALUES = {
    'pi': '3.1415926535897932384626433832795028841971693993751',
    'half_pi': '1.5707963267948966192313216916397514420985846996876',
    'quarter_pi': '0.78539816339744830961566084581987572104929234984378',
    'two_pi': '6.2831853071795864769252867665590057683943387987502',
    'three_half_pi': '4.7123889803846898576939650749192543262957540990627',
}
DEFINITIONS = ''.join(f'real(nswc_{kind}), parameter :: nswc_{name}_{kind} = {value}_nswc_{kind}\n'
                      for kind in ('sp','dp') for name,value in VALUES.items())
NAMES = {f'nswc_{name}_{kind}' for name in VALUES for kind in ('sp','dp')}
LITERAL = r'(?:\d+\.\d*|\.\d+)(?:[ed][+-]?\d+)?(?:_nswc_(?:sp|dp))?'
DECL = re.compile(r'real\(nswc_(sp|dp)\),\s*parameter\s*::\s*(\w+)\s*=\s*('+LITERAL+r')$',re.I)
PI_NAMES = {'pi','pihalf','pio2','piov4','pi4','hpi','pih','tpi','twopi','pi2','pidt','pi3'}


def target(literal):
    """Candidate lookup only; the validator checks actual compiler values."""
    if not re.fullmatch(LITERAL,literal,re.I): return None
    literal=literal.lower()
    kind='dp' if 'd' in literal or literal.endswith('_nswc_dp') else 'sp'
    value=float(literal.split('_')[0].replace('d','e'))
    if not 0.7 < value < 6.4: return None
    pack=lambda v: struct.pack('f' if kind=='sp' else 'd',v)
    for name,decimal in VALUES.items():
        if pack(value)==pack(float(decimal)):
            return f'nswc_{name}_{kind}'
    return None


def transform(text, report=None, aligned_sources=None):
    if DEFINITIONS in text: return text
    if KINDS not in text: raise ValueError('Named module kinds must be installed first')
    lines=text.splitlines(True)
    logical=list(groups(lines)); starts=[r[0][0].index for r in logical]
    if any(m[0].lower() in NAMES for _,code in logical for m in TOKEN.finditer(code)):
        raise ValueError('Reserved pi constant name already exists')
    removed=set(); replacements={}; declarations=[]; literals=[]; skipped=[]
    for proc,a,b in procedure_spans(text):
        unit=logical[bisect_left(starts,a):bisect_left(starts,b)]
        # Do not guess shadowing/import semantics in nested scopes.
        if any(re.match(r'\s*(?:abstract\s+)?interface\b',c,re.I) for _,c in unit):
            if any((m := DECL.fullmatch(c.strip())) and m[2].lower() in PI_NAMES for _,c in unit):
                skipped.append({'procedure':proc,'reason':'nested scope requires separate review'})
            continue
        nested = next((i for i,(_,c) in enumerate(unit) if c.strip().lower() == 'contains'),len(unit))
        nested_names = {m[0].lower() for _,c in unit[nested:] for m in TOKEN.finditer(c)}
        unit = unit[:nested]
        aliases={}
        for records,code in unit:
            m=DECL.fullmatch(code.strip())
            if not m or m[2].lower() not in PI_NAMES: continue
            if m[2].lower() in nested_names:
                skipped.append({'procedure':proc,'name':m[2],'reason':'nested reference or shadowing requires review'})
                continue
            constant=target(m[3])
            if not constant or not constant.endswith('_'+m[1].lower()):
                skipped.append({'procedure':proc,'name':m[2],'reason':'different value or literal kind'})
                continue
            if len(records)!=1 or records[0].comment or re.match(r'\s*\d',records[0].code):
                skipped.append({'procedure':proc,'name':m[2],'reason':'annotated, labelled or continued declaration'})
                continue
            aliases[m[2].lower()]=constant
            removed.add(records[0].index)
            declarations.append({'procedure':proc,'name':m[2].lower(),'literal':m[3].lower(),'constant':constant})
        for records,code in unit:
            # Only direct executable assignment expressions qualify for embedded
            # literals; DATA, FORMAT and coefficient declarations stay untouched.
            words=[m[0].lower() for m in TOKEN.finditer(code)]
            equal=assignment_equal(words)
            assignment=equal is not None and '[' not in words and not re.search(r'\(\s*/',code)
            complex_literal=bool(re.search(r'\(\s*[+-]?\s*'+LITERAL+r'\s*,\s*[+-]?\s*'+LITERAL+r'\s*\)',code,re.I))
            if re.match(r'\s*(?:real|integer|complex|logical|character|double|data|parameter)\b',code,re.I): assignment=False
            if any(r.continued_string for r in records):
                if any(m[0].lower() in aliases for m in TOKEN.finditer(code)):
                    raise ValueError(proc+': alias use in continued string statement needs review')
                continue
            for r in records:
                if r.index in removed: continue
                edits=[]
                matches=list(TOKEN.finditer(r.code))
                for pos,m in enumerate(matches):
                    # A component or keyword argument with the same spelling
                    # is not a reference to the local parameter.
                    component=pos > 0 and matches[pos-1][0] == '%'
                    keyword=pos+1 < len(matches) and matches[pos+1][0] == '='
                    replacement=None if component or keyword else aliases.get(m[0].lower())
                    if replacement:
                        edits.append((m.start(),m.end(),replacement))
                    elif assignment and not complex_literal and (replacement:=target(m[0])):
                        edits.append((m.start(),m.end(),replacement))
                        literals.append({'procedure':proc,'literal':m[0].lower(),'constant':replacement})
                if edits:
                    revised=r.code
                    for start,end,value in reversed(edits): revised=revised[:start]+value+revised[end:]
                    prefix=re.match(r'\s*',revised)[0]; body=revised[len(prefix):].rstrip()
                    tail=' &' if body.endswith('&') else ''
                    if tail: body=body[:-1].rstrip()
                    replacements[r.index]=wrap_line(prefix,body,tail,(' '+r.comment if r.comment else ''),r.newline,len(prefix)+3)
    result=''.join(replacements.get(i,'' if i in removed else line) for i,line in enumerate(lines))
    if aligned_sources is not None:
        old, new = [], []
        for i,line in enumerate(lines):
            replacement = replacements.get(i, '\n' if i in removed else line)
            old.append(line + '\n' * (replacement.count('\n') - line.count('\n')))
            new.append(replacement)
        aligned_sources.extend([''.join(old).replace(KINDS,KINDS+'\n'*DEFINITIONS.count('\n'),1),
                                ''.join(new).replace(KINDS,KINDS+DEFINITIONS,1)])
    result=result.replace(KINDS,KINDS+DEFINITIONS,1)
    if report is not None:
        report.update(input_sha256=hashlib.sha256(text.encode('ascii')).hexdigest(),
                      output_sha256=hashlib.sha256(result.encode('ascii')).hexdigest(),
                      declarations=declarations,literals=literals,skipped=skipped)
    return result


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('source',type=Path);p.add_argument('--output',type=Path);p.add_argument('--report',type=Path)
    args=p.parse_args()
    for path in (args.output,args.report):
        if path and path.exists(): p.error('Output must be a new file: '+str(path))
    if args.output and args.report and args.output.resolve()==args.report.resolve(): p.error('Outputs must differ')
    review={}; result=transform(args.source.read_text(),review)
    if args.output: args.output.write_text(result,newline='\n')
    if args.report: args.report.write_text(json.dumps(review,indent=2)+'\n',newline='\n')
    print(len(review['declarations']),'declarations;',len(review['literals']),'embedded literals')

if __name__=='__main__': main()
