"""Reviewed callback contracts for the optional interfaces, not the library ABI.

Contracts follow the callback descriptions and calls in nswc.f90. Explicit
shape is used when the callback receives its dimension; otherwise arrays keep
the historical assumed-size convention. See docs/interfaces.md for exceptions.
"""
import re


CONTRACTS = {}
BINDINGS = {}
EXCEPTIONS = {
    'SRCH:COND': 'ACOND and XCOND have incompatible argument intents.',
    **{p + ':F': 'ACONDF, ACONDG and XCONDY have incompatible argument intents.'
       for p in ('QAGI1', 'QAGIE1', 'QK15I1')},
    **{p + ':JAC': 'The internal ZZZJAC placeholder differs from the user Jacobian convention.'
       for p in ('STFODE', 'LSOD1', 'STOD', 'PJAC')},
    'BLKTR1:PRDCT': 'PROD0 and PRODP have incompatible workspace intents.',
    'BLKTR1:CPRDCT': 'Legacy real/complex workspace association needs a separate review.',
}


def contract(name, header, declarations, bindings, result_type=None):
    """Keep definitions and their complete list of library uses together."""
    name = 'nswc_cb_' + name
    end = 'function' if result_type else 'subroutine'
    CONTRACTS[name] = (f'    {header.replace("@", name)}\n      implicit none\n'
                       + ''.join('      ' + d + '\n' for d in declarations.splitlines())
                       + f'    end {end} {name}\n', result_type)
    for item in bindings.split():
        procedure, argument = item.split(':')
        key = procedure.upper() + ':' + argument.upper()
        if key in BINDINGS or key in EXCEPTIONS:
            raise ValueError('Duplicate callback review: ' + key)
        BINDINGS[key] = name


contract('real', 'real function @(x)', 'real, intent(in) :: x', '''
ZEROIN:F FMIN:F QSUBA:F QUAD:F QAGS:F QAGSE:F QK21F:F QAGI:F QAGIE:F
QK15I:F QXGS:F QXGSE:F QXLQM:F QXRUL:F QXRRD:F
IESLV:RHFCN IEGS:RHFCN NSTERP:RHFCN LEAVE:RHFCN ITERT:RHFCN''', 'REAL')
contract('double', 'double precision function @(x)',
         'double precision, intent(in) :: x', '''
DZERO:F CHEBY:F CHEBY:G CHEBY:PHI CHEBY1:F CHEBY1:G CHEBY1:PHI
DQAGS:F DQAGSE:F DQK21:F DQAGI:F DQAGIE:F DQK15I:F DQXGS:F
DQXGSE:F DQXLQM:F DQXRUL:F DQXRRD:F''', 'DOUBLE PRECISION')
contract('complex', 'complex function @(z)', 'complex, intent(in) :: z', 'CPSC:F', 'COMPLEX')
contract('kernel', 'real function @(x,y)', 'real, intent(in) :: x,y', '''
IESLV:KERNEL IEGS:KERNEL NSTERP:KERNEL LEAVE:KERNEL ITERT:KERNEL SEPDE:G''', 'REAL')
contract('laplace', 'subroutine @(x,y,a,b)',
         'real, intent(in) :: x,y\nreal, intent(out) :: a,b', '''
LAINV:FUN ABCON:FUN SRCH:FUN ABCON1:FUN ACOND:FUN ACONDF:FUN ACONDG:FUN
XCOND:FUN XCONDX:FUN XCONDY:FUN LAINV1:FUN QAGI1:PHI QAGIE1:PHI QK15I1:PHI''')
contract('complex_double', 'subroutine @(x,y,a,b)',
         'double precision, intent(in) :: x,y\ndouble precision, intent(out) :: a,b', 'DCPSC:FUN')
contract('airy', 'subroutine @(x,rx,c,ai,dai)',
         'real, intent(in) :: x,rx,c\nreal, intent(inout) :: ai,dai', 'ASJY:FUNJY')
for label, typ, proc in [('row', 'real', 'LE'), ('double_row', 'double precision', 'DPLE'),
                         ('complex_row', 'complex', 'CLE')]:
    contract(label, 'subroutine @(n,k,c)',
             f'integer, intent(in) :: n,k\n{typ}, intent(out) :: c(n)', proc + ':ROWK')
contract('nonlinear', 'subroutine @(n,x,fvec,iflag)', '''integer, intent(in) :: n
real, intent(in) :: x(n)
real, intent(inout) :: fvec(n)
integer, intent(inout) :: iflag''', 'HBRD:FCN HYBRD:FCN FDJAC1:FCN')
contract('least_squares', 'subroutine @(m,n,x,fvec,iflag)', '''integer, intent(in) :: m,n
real, intent(in) :: x(n)
real, intent(inout) :: fvec(m)
integer, intent(inout) :: iflag''', 'LMDIFF:FCN LMDIF:FCN FDJAC2:FCN')
contract('objective', 'subroutine @(n,x,f)', '''integer, intent(in) :: n
real, intent(in) :: x(n)
real, intent(out) :: f''', 'OPTF:FCN OPTDRV:FCN FXDEC:FCN FSTOFD:FCN FSTOCD:FCN LNSRCH:FCN')
contract('value_derivative', 'double precision function @(x,derivative)',
         'double precision, intent(in) :: x\ndouble precision, intent(out) :: derivative',
         'ADAPT:F ADAPT1:F ADCOMP:F ERRINT:F', 'DOUBLE PRECISION')
# POLYDD, the library-supplied implementation, has no intent on X.
contract('polynomial', 'double precision function @(x)', 'double precision :: x',
         'ERRINT:FIT', 'DOUBLE PRECISION')
contract('triangle', 'real function @(x,y,idata,rdata)', '''real, intent(in) :: x,y,rdata(*)
integer, intent(in) :: idata(*)''', 'CUBTRI:F CUBRUL:F', 'REAL')
contract('ode', 'subroutine @(t,y,yp)', '''real, intent(in) :: t,y(*)
real, intent(out) :: yp(*)''', '''ODE:F DE1:F STEP1:F BRKF45:FCN RKFC:FCN
RKF45:F RKFS:F FEHL:F GERK:F GERKS:F''')
contract('parameter_ode', 'subroutine @(t,y,yp,rpar,ipar)', '''real, intent(in) :: t,y(*)
real, intent(out) :: yp(*)
real, intent(inout) :: rpar(*)
integer, intent(inout) :: ipar(*)''', 'SFODE:F SFODE1:F STFODE:F LSOD1:F HSTART:F STOD:F PJAC:F')
contract('inplace_ode', 'subroutine @(t,y)',
         'real, intent(in) :: t\nreal, intent(inout) :: y(*)', 'RK:F RK8:F')
contract('boundary', 'real function @(edge,x,y)',
         'integer, intent(in) :: edge\nreal, intent(in) :: x,y', 'SEPDE:BVAL', 'REAL')
contract('coefficient', 'subroutine @(x,a,b,c)',
         'real, intent(in) :: x\nreal, intent(out) :: a,b,c', '''
SEPDE:COFX SEPDE:COFY SEPELL:COFX SEPELL:COFY SEPEL1:COFX SEPEL1:COFY
CHKPRM:COFX CHKPRM:COFY CHKSNG:COFX CHKSNG:COFY DEFER:COFX DEFER:COFY''')
contract('spectral', 'real function @(x,iz,c,a,bh)', '''real, intent(in) :: x
integer, intent(in) :: iz
real :: c(*),a(*),bh(*)''', 'BSRH:F', 'REAL')


def abstract_interfaces():
    return '  abstract interface\n' + ''.join(v[0] for v in CONTRACTS.values()) + '  end interface\n'


def enrich(name, body):
    """Replace only individually reviewed EXTERNAL dummy declarations."""
    externals = re.findall(r'^\s*EXTERNAL (\w+)\s*$', body, re.M | re.I)
    imports = set()
    for argument in externals:
        key = name.upper() + ':' + argument.upper()
        if key in EXCEPTIONS:
            continue
        if key not in BINDINGS:
            raise ValueError('Unreviewed callback: ' + key)
        interface = BINDINGS[key]
        imports.add(interface)
        body = re.sub(r'^\s*(?:REAL|DOUBLE PRECISION|COMPLEX|INTEGER|LOGICAL) :: ' + argument + r'\s*\n',
                      '', body, flags=re.M | re.I)
        body = re.sub(r'^(\s*)EXTERNAL ' + argument + r'\s*$',
                      r'\1PROCEDURE(' + interface + ') :: ' + argument, body, flags=re.M | re.I)
    if imports:
        body = body.replace('      IMPLICIT NONE\n',
                            '      IMPORT :: ' + ', '.join(sorted(imports)) + '\n      IMPLICIT NONE\n')
    return body


def strip_contracts(body):
    """Recover implicit callback declarations for baseline ABI comparison."""
    body = re.sub(r'^\s*IMPORT :: .*\n', '', body, flags=re.M)
    def replace(match):
        typ = CONTRACTS[match[1]][1]
        return ('      ' + typ + ' :: ' + match[2] + '\n' if typ else '') + '      EXTERNAL ' + match[2]
    return re.sub(r'^\s*PROCEDURE\((\w+)\) :: (\w+)$', replace, body, flags=re.M)
