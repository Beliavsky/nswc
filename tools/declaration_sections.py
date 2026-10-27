"""Group fixed-form arguments/results before locals and mark their boundary.

Use through order_declarations.py --mark-locals. Preserve historical ordering
behavior separately. Unsupported annotated or initialized declarations are
reported without editing the procedure; never move a dependency after its use.
"""
import hashlib
import heapq
import re
from bisect import bisect_left
from pathlib import Path
from combine_declarations import TYPE, type_declaration, split_list, entity, emit
from explicit_typing import units
from name_procedure_ends import statements, code_comment, ConversionError
from remove_unused_labels import SPEC
from modernize_do import masked

MARKER = 'C     beginning of local variable declarations'
MANIFEST = Path(__file__).with_name('declaration-sections.json')


def transform(data, report=None):
    original_lines,original_scopes=units(data)
    lines=original_lines
    # Rebuild the generated marker, allowing repeated application.
    lines=[line for line in lines if line.strip().lower()!=MARKER.lower()]
    clean=''.join(lines).encode('latin-1')
    lines,scopes=units(clean)
    ss=list(statements(lines)); starts=[s.lines[0] for s in ss]
    edits={};removed=set();marked=[];reordered=[];mixed=[];prerequisites=[];skipped=[];no_locals=[]
    for proc,(start,_,stop) in scopes.items():
        unit=ss[bisect_left(starts,start):bisect_left(starts,stop)]
        try:
            header=unit[0].code
            m=re.search(r'\b(?:FUNCTION|SUBROUTINE)\s+\w+\s*\(([^)]*)\)',header,re.I)
            interface={s.strip().upper() for s in m[1].split(',') if s.strip()} if m else set()
            if re.search(r'\bFUNCTION\b',header,re.I):
                result=re.search(r'\bRESULT\s*\(\s*(\w+)\s*\)',header,re.I)
                interface.add(result[1].upper() if result else proc)
            if any(re.match(r'^\s*ENTRY\b',s.code,re.I) for s in unit[1:]):
                raise ConversionError('alternate ENTRY requires review')
            nodes=[];decls=[];procedures=set();type_owners={};parameters={}
            for s in unit[1:]:
                c=s.code.strip();compact=re.sub(r'\s+','',c).upper()
                if re.match(r'^ENTRY\b',c,re.I): raise ConversionError('alternate ENTRY requires review')
                # All supported specification statements precede the first action.
                if not SPEC.match(compact): break
                match=re.match(r'^(EXTERNAL|INTRINSIC|DIMENSION)\s+(?:::)?\s*(.*)$',c,re.I)
                parameter=re.fullmatch(r'PARAMETER\s*\((.*)\)',c,re.I)
                typed_parameter=bool(re.match(r'^(?:INTEGER|REAL|DOUBLE\s+PRECISION|COMPLEX|LOGICAL|CHARACTER)\b.*?,\s*PARAMETER\b',c,re.I))
                if not match and not parameter and not TYPE.match(c): continue
                if any(lines[i][:5].strip() or lines[i].rstrip('\r\n')[72:].strip() or code_comment(lines[i][6:72])[1] for i in s.lines):
                    raise ConversionError('labelled, annotated or sequence-field declaration requires review')
                if typed_parameter:
                    prefix,tail=c.split('::',1);prefix=prefix.rstrip()+' ::'
                    items=[]
                    for item in split_list(tail):
                        binding=re.fullmatch(r'\s*([A-Z]\w*)\s*=\s*(.+)',item,re.I)
                        if not binding: raise ConversionError('unsupported typed parameter')
                        items.append((binding[1],item,binding[2]))
                    kind='parameter_type'
                elif parameter:
                    prefix='PARAMETER';kind='parameter';items=[]
                    for item in split_list(parameter[1]):
                        binding=re.fullmatch(r'\s*([A-Z]\w*)\s*=\s*(.+)',item,re.I)
                        if not binding: raise ConversionError('unsupported parameter binding')
                        items.append((binding[1],item,binding[2]))
                elif match:
                    kind=match[1].lower();prefix=match[1].upper()
                    items=[]
                    for item in split_list(match[2]):
                        name,shape,length=entity(item)
                        if kind!='dimension' and (shape or length): raise ConversionError('unsupported procedure attribute')
                        items.append((name,item,shape+length))
                        if kind in ('external','intrinsic'): procedures.add(name.upper())
                else:
                    decl=type_declaration(c)
                    if not decl: continue
                    typ,attrs,entities=decl
                    prefix=typ+(', '+', '.join(attrs) if attrs else '')+' ::'
                    selectors=re.sub(r'^[A-Z ]+','',typ)+' '+' '.join(a for a in attrs if re.match(r'\s*(KIND|LEN|DIMENSION)\b',a,re.I))
                    items=[(n,n+shape+length,selectors+' '+shape+length) for n,shape,length in entities]
                    kind='type'
                    if any(a.upper() in ('EXTERNAL','INTRINSIC') for a in attrs): procedures.update(n.upper() for n,_,_ in entities)
                if len({n.upper() in interface for n,_,_ in items})>1: mixed.append(proc)
                group=len(decls)
                decls.append(s)
                for name,text,expr in items:
                    n=name.upper();idx=len(nodes)
                    node=dict(name=n,text=text,prefix=prefix,kind=kind,group=group,interface=n in interface,
                              refs={w.upper() for w in re.findall(r'[A-Z]\w*',expr,re.I)},deps=set())
                    nodes.append(node)
                    if kind in ('type','parameter_type'):
                        if n in type_owners: raise ConversionError('duplicate type declaration for '+n)
                        type_owners[n]=idx
                    if kind in ('parameter','parameter_type'): parameters[n]=idx
            if not nodes:
                no_locals.append(proc);continue
            for i,node in enumerate(nodes):
                for name in node['refs']:
                    provider=parameters.get(name,type_owners.get(name))
                    if provider is not None and provider!=i: node['deps'].add(provider)
                if node['kind'] in ('external','dimension','parameter') and node['name'] in type_owners:
                    node['deps'].add(type_owners[node['name']])
            required=set()
            def require(i):
                if i in required:return
                required.add(i)
                for dependency in nodes[i]['deps']: require(dependency)
            for i,node in enumerate(nodes):
                if node['interface']: require(i)
            pending={i:set(n['deps']) for i,n in enumerate(nodes)};ready=[];order=[]
            def enqueue(i): heapq.heappush(ready,(0 if nodes[i]['interface'] else 1 if i in required else 2,i))
            for i,deps in pending.items():
                if not deps:enqueue(i)
            while ready:
                _,i=heapq.heappop(ready);order.append(i)
                for j,deps in pending.items():
                    if i in deps:
                        deps.remove(i)
                        if not deps:enqueue(j)
            if len(order)!=len(nodes): raise ConversionError('cyclic declaration dependency')
            arrays={n['name'] for n in nodes if n['kind']=='dimension' or n['kind']=='type' and (n['text'].upper().startswith(n['name']+'(') or 'DIMENSION' in n['prefix'].upper())}
            characters={n['name'] for n in nodes if n['prefix'].upper().startswith('CHARACTER')}
            storage_names={w.upper() for s in unit if re.match(r'^\s*(COMMON|EQUIVALENCE)\b',s.code,re.I) for w in re.findall(r'[A-Z]\w*',s.code,re.I)}
            calls={m[1].upper() for s in unit if not SPEC.match(re.sub(r'\s+','',s.code).upper()) for m in re.finditer(r'\b([A-Z]\w*)\s*\(',masked(s.code),re.I)}
            procedures.update(calls-arrays-characters-storage_names)
            local_names={n['name'] for n in nodes if n['kind'] in ('type','parameter_type') and not n['interface'] and n['name'] not in procedures}
            ordinary=[i for i in order if i not in required]
            boundary=ordinary[0] if ordinary and any(nodes[i]['name'] in local_names for i in ordinary) else None
            before_names=sorted({nodes[i]['name'] for i in required if not nodes[i]['interface']})
            if before_names: prerequisites.append(dict(procedure=proc,names=before_names,reason='required by argument or result declarations'))
            if boundary is None: no_locals.append(proc)
            else: marked.append(proc)
            newline='\r\n' if lines[start].endswith('\r\n') else '\n'
            chunks=[];p=0
            while p<len(order):
                i=order[p];node=nodes[i]
                if i==boundary:chunks.append(MARKER+newline)
                entries=[node['text']];p+=1
                while p<len(order) and order[p]!=boundary and nodes[order[p]]['group']==node['group'] and nodes[order[p]]['interface']==node['interface'] and ((order[p] in required)==(i in required)):
                    entries.append(nodes[order[p]]['text']);p+=1
                if node['kind']=='parameter':chunks.extend(emit('PARAMETER (',[', '.join(entries)+')'],newline))
                else:chunks.extend(emit(node['prefix'],entries,newline))
            replacement=''.join(chunks)
            old_declarations=''.join(lines[i] for s in decls for i in s.lines)
            if replacement.replace(MARKER+newline,'')!=old_declarations: reordered.append(proc)
            # Keep all original comments in their original order. Only the
            # declaration records move; no executable statement is touched.
            first=decls[0].lines[0]
            edits[first]=replacement
            removed.update(i for s in decls for i in s.lines)
        except ConversionError as error:
            old_start,_,old_stop=original_scopes[proc]
            edits[start]=''.join(original_lines[old_start:old_stop])
            removed.update(range(start,stop))
            skipped.append(dict(procedure=proc,reason=str(error)))
    result=''.join(edits.get(i,'')+('' if i in removed else line) for i,line in enumerate(lines)).encode('latin-1')
    if report is not None:
        report.update(input_sha256=hashlib.sha256(data).hexdigest(),output_sha256=hashlib.sha256(result).hexdigest(),
                      marked=marked,reordered=reordered,mixed_declarations=sorted(set(mixed)),prerequisite_locals=prerequisites,
                      without_marker=no_locals,skipped=skipped)
    return result


def remove_empty_free_markers(text):
    """Drop markers when later module conversions removed every local type."""
    from fortran_procedures import procedure_spans
    from format_free_form import groups
    lines=text.splitlines(True)
    removed=set()
    for _,start,end in procedure_spans(text):
        unit=lines[start:end]
        markers=[i for i,line in enumerate(unit) if re.fullmatch(r'\s*!\s*beginning of local variable declarations\s*',line,re.I)]
        if not markers: continue
        depth=0;local_type=False
        for records,code in groups(unit):
            if re.match(r'^\s*(?:abstract\s+)?interface\b',code,re.I):depth+=1;continue
            if re.match(r'^\s*end\s*interface\b',code,re.I):depth-=1;continue
            if depth:continue
            if code.strip().lower()=='contains':break
            if records[0].index>markers[0] and re.match(r'^\s*(integer|real|double\s+(?:precision|complex)|complex|logical|character)\b',code,re.I):local_type=True
        if not local_type: removed.update(start+i for i in markers)
    return ''.join(line for i,line in enumerate(lines) if i not in removed)
