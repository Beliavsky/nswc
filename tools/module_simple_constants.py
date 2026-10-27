"""Share scalar zero/one/two constants in the named-kind module only.

Parameters may be shared directly. Variables require a single literal assignment
in the initial straight-line executable prefix, no earlier use, no storage
association and no actual-argument escape to an unknown procedure. Machine
arithmetic probes and nested scopes are deliberately excluded.
"""
import argparse
import hashlib
import json
from decimal import Decimal, InvalidOperation
from pathlib import Path
import re
from bisect import bisect_left
from combine_declarations import split_list
from format_free_form import TOKEN, groups, wrap_line, assignment_equal
from fortran_procedures import procedure_spans
from module_kinds import DEFINITION as KINDS
from ford_documentation import SPECIFICATION

MANIFEST=Path(__file__).with_name('module-simple-constants.json')
VALUES={'zero':0,'one':1,'two':2}
PROBES={'RADIX','MACH','MACH1','MACH2','STORE2','DSTOR2','SPMPAR','DPMPAR'}
PURE_INTRINSICS={'abs','sqrt','max','min','sign','real','aimag','conjg','cmplx',
                 'dble','int','mod','epsilon','tiny','huge'}
DEFINITIONS=''.join(
    f'{typ}(nswc_{kind}), parameter :: nswc_{name}_{suffix}{kind} = '+
    (f'{value}.0_nswc_{kind}' if typ=='real' else
     f'({value}.0_nswc_{kind}, 0.0_nswc_{kind})')+'\n'
    for typ,suffix in [('real',''),('complex','c')]
    for kind in ('sp','dp') for name,value in VALUES.items())
NAMES=set(re.findall(r':: (\w+)',DEFINITIONS))
DECL=re.compile(r'^(real|complex)\(nswc_(sp|dp)\)\s*(,\s*parameter\s*)?::\s*(.*)$',re.I)
NUMBER=re.compile(r'[+]?((?:\d+(?:\.\d*)?|\.\d+)(?:[ed][+-]?\d+)?)(?:_nswc_(sp|dp))?$',re.I)


def literal_value(text):
    match=NUMBER.fullmatch(text.strip())
    if not match:return None
    try:return Decimal(match[1].lower().replace('d','e'))
    except InvalidOperation:return None


def literal_matches(text,typ,value):
    text=text.strip()
    if typ=='real':return literal_value(text)==value
    if not (text.startswith('(') and text.endswith(')')):return False
    pieces=split_list(text[1:-1])
    return len(pieces)==2 and literal_value(pieces[0])==value and literal_value(pieces[1])==0


def variable_reason(unit,name,own,typ,intrinsics):
    """Return an exclusion reason or the safe initialization record index."""
    if name in [m[0].lower() for m in TOKEN.finditer(unit[0][1])]:
        return 'dummy argument or function result'
    executable=False;prefix=True;initial=None
    for records,code in unit[1:]:
        words=[m[0].lower() for m in TOKEN.finditer(code)]
        if records[0].index==own:continue
        used=name in words
        if not executable and SPECIFICATION.match(code.strip()):
            if used:return 'additional specification or storage association'
            continue
        executable=True
        equal=assignment_equal(words)
        plain=equal is not None and re.match(r'^\s*\w+\s*=',code)
        if used:
            init=re.fullmatch(r'\s*'+name+r'\s*=\s*(.*)',code,re.I)
            if init:
                if initial is not None:return 'reassigned variable'
                if not prefix or not literal_matches(init[1],typ,VALUES[name]):
                    return 'initialization is not an unconditional matching literal'
                if len(records)!=1 or records[0].comment or re.match(r'\s*\d',records[0].code):
                    return 'annotated, labelled or continued initialization'
                initial=records[0].index
                continue
            if initial is None:return 'reference before initialization'
            if equal is not None:
                # The assignment target can follow a logical IF condition.
                target=words[equal-1]
                if target==name:return 'conditional or indirect reassignment'
            if words[0] not in ('if','else','elseif','do','end','print','write') and equal is None:
                return 'unsupported use or procedure argument escape'
            if words[0] in ('read','call','do'):return 'possible definition or procedure argument escape'
            stack=[]
            for i,word in enumerate(words):
                if word=='(':
                    previous=words[i-1] if i else ''
                    stack.append(previous if re.fullmatch(r'[a-z_]\w*',previous) else '')
                elif word==')':
                    if stack:stack.pop()
                elif word==name and any(owner and owner not in intrinsics|{'if','elseif','write'} for owner in stack):
                    return 'argument to an unreviewed function or subscript'
        if not plain:prefix=False
    return initial if initial is not None else 'no initialization'


def transform(text,report=None,variables=True,aligned_sources=None):
    if DEFINITIONS in text:return text
    if KINDS not in text:raise ValueError('Named module kinds must be installed first')
    lines=text.splitlines(True);logical=list(groups(lines));starts=[r[0][0].index for r in logical]
    if any(m[0].lower() in NAMES for _,c in logical for m in TOKEN.finditer(c)):
        raise ValueError('Reserved simple constant name already exists')
    removed=set();edits={};selected=[];skipped=[]
    library={name.lower() for name,_,_ in procedure_spans(text)}
    for proc,a,b in procedure_spans(text):
        unit=logical[bisect_left(starts,a):bisect_left(starts,b)]
        unsafe=proc in PROBES or any(re.match(r'\s*(?:(?:abstract\s+)?interface|contains|entry|equivalence|common|save|data)\b',c,re.I) for _,c in unit)
        aliases={};decl_edits={}
        # An EXTERNAL or local object can hide an otherwise intrinsic spelling.
        declared={m[0].lower() for _,c in unit[1:] if SPECIFICATION.match(c.strip())
                  for m in TOKEN.finditer(c)}
        intrinsics=PURE_INTRINSICS-library-declared
        for records,code in unit[1:]:
            match=DECL.fullmatch(code.strip())
            if not match:continue
            typ,kind,parameter,tail=match.groups();typ=typ.lower();kind=kind.lower()
            items=split_list(tail)
            for item in items:
                entity=re.fullmatch(r'(zero|one|two)(?:\s*=\s*(.*))?',item,re.I)
                if not entity:continue  # Arrays and attributed declarations stay local.
                name=entity[1].lower();literal=entity[2]
                reason=None;initial=None
                if unsafe:reason='machine probe, nested scope or explicit storage association'
                elif parameter and len(items)!=1:reason='combined parameter declaration requires review'
                elif any(r.comment or r.continued_string for r in records) or re.match(r'\s*\d',records[0].code):reason='annotated or labelled declaration'
                elif parameter:
                    if literal is None or not literal_matches(literal,typ,VALUES[name]):reason='different value or nonliteral parameter'
                elif not variables:reason='variable conversion disabled'
                else:
                    initial=variable_reason(unit,name,records[0].index,typ,intrinsics)
                    if isinstance(initial,str):reason=initial
                    else:literal=next(c.split('=',1)[1].strip() for r,c in unit if r[0].index==initial)
                if reason:
                    skipped.append({'procedure':proc,'name':name,'reason':reason});continue
                constant=f'nswc_{name}_{"c" if typ=="complex" else ""}{kind}'
                aliases[name]=constant
                decl_edits.setdefault(records[0].index,[records,code,items,[]])[3].append(item)
                if initial is not None:removed.add(initial)
                selected.append({'procedure':proc,'name':name,'constant':constant,
                                 'type':f'{typ}(nswc_{kind})','literal':literal,
                                 'origin':'parameter' if parameter else 'variable'})
        for first,(records,code,items,discard) in decl_edits.items():
            kept=[item for item in items if item not in discard]
            removed.update(r.index for r in records)
            if kept:edits[first]=wrap_line('',code.split('::',1)[0].rstrip()+' :: '+', '.join(kept),'','','\n',3)
        for records,code in unit:
            for record in records:
                if record.index in removed:continue
                tokens=list(TOKEN.finditer(record.code));changes=[]
                for i,token in enumerate(tokens):
                    if token[0].lower() not in aliases:continue
                    if i and tokens[i-1][0]=='%':continue
                    if i+1<len(tokens) and tokens[i+1][0]=='=':continue
                    if record.continued_string:raise ValueError(proc+': alias in continued string statement')
                    changes.append((token.start(),token.end(),aliases[token[0].lower()]))
                if changes:
                    code=record.code
                    for first,last,value in reversed(changes):code=code[:first]+value+code[last:]
                    prefix=re.match(r'\s*',code)[0];body=code[len(prefix):].rstrip();tail=' &' if body.endswith('&') else ''
                    if tail:body=body[:-1].rstrip()
                    edits[record.index]=wrap_line(prefix,body,tail,(' '+record.comment if record.comment else ''),record.newline,len(prefix)+3)
    result=''.join(edits.get(i,'' if i in removed else line) for i,line in enumerate(lines))
    if aligned_sources is not None:
        old=[];new=[]
        for i,line in enumerate(lines):
            replacement=edits.get(i,'\n' if i in removed else line)
            old.append(line+'\n'*(replacement.count('\n')-line.count('\n')));new.append(replacement)
        aligned_sources.extend([''.join(old).replace(KINDS,KINDS+'\n'*DEFINITIONS.count('\n'),1),''.join(new).replace(KINDS,KINDS+DEFINITIONS,1)])
    result=result.replace(KINDS,KINDS+DEFINITIONS,1)
    if report is not None:
        report.update(input_sha256=hashlib.sha256(text.encode('ascii')).hexdigest(),
                      output_sha256=hashlib.sha256(result.encode('ascii')).hexdigest(),
                      selected=selected,skipped=skipped)
    return result


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--review',action='store_true',help='Refresh the checked-in selection report')
    args=parser.parse_args()
    from generate_module import module_source
    root=Path(__file__).resolve().parents[1]
    before=module_source((root/'nswc.f90').read_text(),simple_constants=False,documentation=False)
    review={};transform(before,review)
    if args.review:MANIFEST.write_text(json.dumps(review,indent=2)+'\n',newline='\n')
    print(f'{len(review["selected"])} eligible scalar constants; {len(review["skipped"])} exclusions.')

if __name__=='__main__':main()
