"""Remove provably redundant generated scalar copies in fixed-form source.

Only single copies from explicitly declared scalar INTENT(IN) dummies qualify.
Uses must be adjacent sign tests, or a restricted terminal IF/ELSE IF tree.
Comments, strings, expressions and uncertain control flow are never rewritten.
"""
import argparse
from bisect import bisect_left
import hashlib
import json
from pathlib import Path
import re
from explicit_typing import units
from name_procedure_ends import statements, code_comment, split_line

MANIFEST = Path(__file__).with_name('redundant-copies.json')
TYPE = r'(INTEGER|REAL|DOUBLE\s+PRECISION)'


class UnsafeCopy(ValueError):
    """A candidate falls outside the supported transformation."""


def transform(data, report=None):
    lines, scopes = units(data)
    ss = list(statements(lines))
    starts = [s.lines[0] for s in ss]
    edits, removed, converted, skipped = {}, set(), [], []
    for name, (start, _, stop) in scopes.items():
        u = ss[bisect_left(starts, start):bisect_left(starts, stop)]
        codes = [s.code.strip().upper() for s in u]
        temps = sorted(set(re.findall(r'\bNSWC_AI_\w+\b', ' '.join(codes))))
        for temp in temps:
            try:
                uses = [i for i,c in enumerate(codes) if re.search(r'\b'+temp+r'\b', c)]
                if len(uses) != 4:
                    raise UnsafeCopy('not one declaration, one copy and two tests')
                d,a,p,q = uses
                decl = re.fullmatch(TYPE+r'\s*::\s*'+temp, codes[d])
                copy = re.fullmatch(temp+r'\s*=\s*([A-Z]\w*)', codes[a])
                if not decl or not copy:
                    raise UnsafeCopy('not a standalone scalar declaration and simple copy')
                arg = copy[1]
                kind = re.sub(r'\s+', '', decl[1])
                argdecl = [c for c in codes if re.fullmatch(TYPE+r'\s*,\s*INTENT\s*\(IN\)\s*::\s*[A-Z][A-Z0-9_, ]*', c)
                           and arg in c.split('::')[1].replace(' ','').split(',')]
                if len(argdecl) != 1 or re.sub(r'\s+', '', argdecl[0].split(',')[0]) != kind:
                    raise UnsafeCopy('source is not a matching scalar INTENT(IN) argument')
                header = re.search(r'\b(?:FUNCTION|SUBROUTINE)\s+\w+\s*\(([^)]*)\)',codes[0])
                if not header or arg not in header[1].replace(' ','').split(','):
                    raise UnsafeCopy('source is not a dummy argument')
                if any(re.match(r'(ENTRY|COMMON|EQUIVALENCE|SAVE|VOLATILE|ASYNCHRONOUS|POINTER|TARGET)\b',c) for c in codes):
                    raise UnsafeCopy('alternate entry or storage association')
                if p != a+1:
                    raise UnsafeCopy('copy does not immediately dominate first use')
                adjacent = q == p+1 and all(re.fullmatch(r'IF\s*\('+temp+r'\s*\.(?:LT|EQ)\.\s*0\)\s*GO\s*TO\s*\d+',codes[i]) for i in (p,q))
                structured = (re.fullmatch(r'IF\s*\('+temp+r'\s*\.LT\.\s*0\)\s*THEN',codes[p])
                              and re.fullmatch(r'ELSE\s+IF\s*\('+temp+r'\s*\.EQ\.\s*0\)\s*THEN',codes[q]))
                if not adjacent:
                    if not structured:
                        raise UnsafeCopy('unsupported test layout')
                    # The only intervening statements are assignments whose calls
                    # are known nonmodifying intrinsics. No transfer can bypass copy.
                    for c in codes[p+1:q]:
                        m = re.fullmatch(r'([A-Z]\w*)\s*=\s*(.+)',c)
                        if not m or m[1] in (arg,temp):
                            raise UnsafeCopy('intervening definition or control flow')
                        if set(re.findall(r'([A-Z]\w*)\s*\(',m[2])) - {'LOG','EXP','ABS','SQRT'}:
                            raise UnsafeCopy('uncertain intervening function call')
                    for intrinsic in ('LOG','EXP','ABS','SQRT'):
                        if any(re.search(r'\b'+intrinsic+r'\b',c) for c in codes[1:a]):
                            raise UnsafeCopy('possible intrinsic shadowing')
                touched = [d,a,*range(p,q+1)]
                if any(len(u[i].lines)!=1 or lines[u[i].lines[0]][:5].strip() for i in touched):
                    raise UnsafeCopy('labelled or continued copy/test region')
                for i in (d,a):
                    line=lines[u[i].lines[0]]
                    body,_=split_line(line)
                    if code_comment(body[6:72])[1] or body[72:].strip():
                        raise UnsafeCopy('annotated declaration or copy')
                for i in (p,q):
                    n=u[i].lines[0]; body,nl=split_line(lines[n]); code,comment,quote=code_comment(body[6:72])
                    new=re.sub(r'\b'+temp+r'\b',arg,code,flags=re.I)
                    if len(new)>len(code):
                        raise UnsafeCopy('replacement grows fixed record')
                    edits[n]=body[:6]+new+(' '*(len(code)-len(new)) if comment or body[72:] else '')+comment+body[72:]+nl
                removed.update(u[i].lines[0] for i in (d,a))
                converted.append(dict(procedure=name,temporary=temp,argument=arg))
            except UnsafeCopy as error:
                skipped.append(dict(procedure=name,temporary=temp,reason=str(error)))
    result=''.join(edits.get(i,'' if i in removed else line) for i,line in enumerate(lines)).encode('latin-1')
    if report is not None:
        report.update(input_sha256=hashlib.sha256(data).hexdigest(),output_sha256=hashlib.sha256(result).hexdigest(),converted=converted,skipped=skipped)
    return result


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('source',type=Path); p.add_argument('--output',type=Path); p.add_argument('--report',type=Path)
    args=p.parse_args()
    if args.output and args.report and args.output.resolve()==args.report.resolve():
        p.error('Output and report must differ')
    for path in (args.output,args.report):
        if path and path.exists(): p.error('Output must be a new file: '+str(path))
    report={}; result=transform(args.source.read_bytes(),report)
    if args.output: args.output.write_bytes(result)
    if args.report: args.report.write_text(json.dumps(report,indent=2)+'\n',newline='\n')
    print(json.dumps(report['converted'],indent=2)); print('Skipped:',len(report['skipped']))

if __name__=='__main__': main()
