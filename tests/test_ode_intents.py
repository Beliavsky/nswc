"""Read-only aliases, reviewed workspaces and callback effects."""
from pathlib import Path
import sys
import unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from additional_intents import analyze
from test_writable_intents import source,record

class OdeIntentTests(unittest.TestCase):
    def test_repeated_readonly_actuals(self):
        data=source('A',['X'],['REAL X','CALL B(X,X)'])+source('B',['Y','Z'],['REAL Y,Z'])
        inv={'A':{'x':record(True)},'B':{'y':record(True),'z':record(True)}}
        self.assertNotIn('B',analyze(data,inv)['procedures'])
        r=analyze(data,inv,{'readonly_duplicates':True})
        self.assertEqual({d:e['intent'] for d,e in r['procedures']['B'].items()},{'Y':'IN','Z':'IN'})

    def test_repeated_readwrite_actuals_still_blocked(self):
        data=source('A',['X'],['REAL X','CALL B(X,X)'])+source('B',['Y','Z'],['REAL Y,Z','Z=Y'])
        inv={'A':{'x':record(True)},'B':{'y':record(True),'z':record(True)}}
        self.assertNotIn('B',analyze(data,inv,{'readonly_duplicates':True})['procedures'])

    def test_callback_writes_propagate_to_caller(self):
        data=source('A',['X','F'],['REAL X','EXTERNAL F','CALL B(X,F)'])+source('B',['Y','F'],['REAL Y','EXTERNAL F','CALL F(Y)'])
        proc={'attributes':'attributes: (PROCEDURE DUMMY)'}
        inv={'A':{'x':record(True),'f':proc},'B':{'y':record(True),'f':proc}}
        r=analyze(data,inv,{'callback_modes':{'B:F':['INOUT']}})
        self.assertEqual(r['procedures']['A']['X']['intent'],'INOUT')
        self.assertEqual(r['procedures']['B']['Y']['intent'],'INOUT')
        self.assertEqual(r['procedures']['B']['Y']['evidence']['direct_writes'][0]['callback_contract'],'B:F')

    def test_callback_inputs_are_readonly(self):
        data=source('B',['Y','F'],['REAL Y','EXTERNAL F','CALL F(Y)'])
        inv={'B':{'y':record(True),'f':{'attributes':'attributes: (PROCEDURE DUMMY)'}}}
        self.assertEqual(analyze(data,inv,{'callback_modes':{'B:F':['IN']}})['procedures']['B']['Y']['intent'],'IN')
        with self.assertRaises(ValueError):analyze(data,inv,{'callback_modes':{'B:F':['IN','OUT']}})

    def test_alias_override_is_explicit_and_recorded(self):
        data=source('A',['X'],['REAL X','CALL B(X,X)'])+source('B',['Y','Z'],['REAL Y,Z','Y=1','Z=2'])
        inv={'A':{'x':record(True)},'B':{'y':record(True),'z':record(True)}}
        r=analyze(data,inv,{'alias_safe':{'B:Y':{'intent':'INOUT','review':'fixture review'}}})
        self.assertIn('alias_review',r['procedures']['B']['Y'])
        self.assertNotIn('Z',r['procedures']['B'])

    def test_function_result_is_not_a_callback(self):
        data=b'      REAL FUNCTION NORM(V)\n      IMPLICIT NONE\n      REAL V\n      NORM=0\n      NORM=MAX(NORM,ABS(V))\n      END FUNCTION NORM\n'
        inv={'NORM':{'v':record(True),'norm':{'attributes':'attributes: (PROCEDURE FUNCTION EXTERNAL-PROC)'},'max':{'attributes':'attributes: (PROCEDURE INTRINSIC-PROC)'},'abs':{'attributes':'attributes: (PROCEDURE INTRINSIC-PROC)'}}}
        r=analyze(data,inv,{'function_results_are_data':True})
        self.assertEqual(r['procedures']['NORM']['V']['intent'],'IN')

    def test_stale_workspace_review_rejected(self):
        from ode_intents import analyze as reviewed
        with self.assertRaises(ValueError):reviewed(b'changed source',{})

if __name__=='__main__':unittest.main()
