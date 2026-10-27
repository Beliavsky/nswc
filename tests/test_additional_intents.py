"""Argument-level COMMON handling and conservative call effects."""
from pathlib import Path
import sys
import unittest
sys.path.insert(0, str(Path(__file__).resolve().parents[1]/'tools'))
from additional_intents import analyze, transform
from test_writable_intents import record, source

class AdditionalIntentsTests(unittest.TestCase):
    def analyze(self, data, inventory):
        return analyze(data, inventory)

    def test_common_does_not_exclude_independent_arguments(self):
        data=source('S',['X','Y'],['REAL X,Y,Z','COMMON /C/ Z','Y=X+Z'])
        r=analyze(data,{'S':{'x':record(True),'y':record(True),'z':record()}})
        self.assertEqual({d:e['intent'] for d,e in r['procedures']['S'].items()}, {'X':'IN','Y':'INOUT'})
        output=transform(data,r)
        self.assertIn(b'INTENT(IN)',output)
        self.assertIn(b'INTENT(INOUT)',output)

    def test_callback_only_blocks_affected_input(self):
        data=source('S',['X','N','F'],['REAL X,N','EXTERNAL F','CALL F(X)'])
        r=analyze(data,{'S':{'x':record(True),'n':record(True),'f':{'attributes':'attributes: (PROCEDURE DUMMY)'}}})
        self.assertEqual(set(r['procedures']['S']), {'N'})
        self.assertIn('callback',r['remaining']['S:X'])

    def test_nondefinable_actual_does_not_make_written_argument_input(self):
        data=source('SET',['X'],['REAL X','X=0'])+source('USE',['Y'],['REAL Y','CALL SET(1.0)'])
        r=analyze(data,{'SET':{'x':record(True)},'USE':{'y':record(True)}})
        self.assertNotIn('SET',r['procedures'])

    def test_forwarded_aliases_block_new_contracts(self):
        data=source('A',['X'],['REAL X','CALL B(X,X)'])
        data+=source('B',['Y','Z'],['REAL Y,Z','CALL C(Y)','Z=1'])
        data+=source('C',['T'],['REAL T','T=2'])
        r=analyze(data,{'A':{'x':record(True)},'B':{'y':record(True),'z':record(True)},'C':{'t':record(True)}})
        self.assertNotIn('C',r['procedures'])
        self.assertIn('Forwarded',r['remaining']['C:T'])

    def test_equivalence_remains_excluded(self):
        data=source('S',['X'],['REAL X,Y,Z','EQUIVALENCE(Y,Z)','X=Y'])
        r=analyze(data,{'S':{'x':record(True),'y':record(),'z':record()}})
        self.assertEqual(r['procedures'],{})

    def test_known_calls_prove_inputs_and_propagate_writes(self):
        data=source('A',['X','Y'],['REAL X,Y','CALL B(X,Y)'])+source('B',['U','V'],['REAL U,V','V=U'])
        r=analyze(data,{'A':{'x':record(True),'y':record(True)},'B':{'u':record(True),'v':record(True)}})
        self.assertEqual(r['procedures']['A']['X']['intent'],'IN')
        self.assertEqual(r['procedures']['A']['Y']['intent'],'INOUT')
        self.assertEqual(r['procedures']['A']['X']['dependencies'],['B:U'])

    def test_existing_intent_is_preserved(self):
        data=source('S',['X'],['REAL, INTENT(IN) :: X'])
        rec=record(True);rec['attributes']='attributes: (VARIABLE DUMMY(IN))'
        self.assertEqual(analyze(data,{'S':{'x':rec}})['procedures'],{})

    def test_common_actual_blocks_callee_contract(self):
        data=source('A',[],['REAL Z','COMMON /C/ Z','CALL B(Z)'])+source('B',['X'],['REAL X','X=1'])
        rec=record();rec['attributes']='attributes: (VARIABLE IN-COMMON)'
        r=analyze(data,{'A':{'z':rec},'B':{'x':record(True)}})
        self.assertNotIn('B',r['procedures'])
        self.assertIn('storage-associated',r['remaining']['B:X'])

    def test_intrinsic_subroutine_is_not_assumed_readonly(self):
        data=source('S',['X'],['REAL X','CALL RANDOM_NUMBER(X)'])
        rec={'attributes':'attributes: (PROCEDURE INTRINSIC-PROC)'}
        r=analyze(data,{'S':{'x':record(True),'random_number':rec}})
        self.assertEqual(r['procedures'],{})

    def test_recursive_input_dependency_is_unproved(self):
        data=source('A',['X'],['REAL X','CALL B(X)'])+source('B',['Y'],['REAL Y','CALL A(Y)'])
        self.assertEqual(analyze(data,{'A':{'x':record(True)},'B':{'y':record(True)}})['procedures'],{})

    def test_library_callback_interface_is_preserved(self):
        data=source('A',[],['EXTERNAL B,RUN','CALL RUN(B)'])+source('B',['X'],['REAL X'])
        proc={'attributes':'attributes: (PROCEDURE EXTERNAL-PROC)'}
        r=analyze(data,{'A':{'b':proc,'run':proc},'B':{'x':record(True)}})
        self.assertEqual(r['procedures'],{})
        self.assertIn('callback',r['remaining']['B:X'])

    def test_keyword_association_is_left_for_review(self):
        data=source('A',['X'],['REAL X','CALL B(Y=X)'])+source('B',['Y'],['REAL Y'])
        r=analyze(data,{'A':{'x':record(True)},'B':{'y':record(True)}})
        self.assertEqual(r['procedures'],{})
        self.assertIn('association',r['remaining']['B:Y'])

if __name__=='__main__':unittest.main()
