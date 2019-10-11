
             PGM        PARM(&THISORDER &PRINTER &COPIES &SAVE)

             DCL        VAR(&THISORDER) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&ZERO) TYPE(*DEC) LEN(6 0) VALUE(0)
             DCL        VAR(&PRINTER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COPIES) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SAVE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OVRSAVE) TYPE(*CHAR) LEN(10) VALUE('*NO')

             IF         COND(&SAVE = 'Y') THEN(CHGVAR +
                          VAR(&OVRSAVE) VALUE('*YES'))


             IF         COND(&PRINTER *EQ ' ') THEN(CHGVAR +
                          VAR(&PRINTER) VALUE('XERPRT01'))

             OVRPRTF    FILE(PCK900P) TOFILE(*LIBL/PCK900P) +
                          DEVTYPE(*AFPDS) PAGESIZE(11 8.5 *UOM) +
                          LPI(7.5) CPI(12) FRONTMGN(.25 .25) +
                          PAGRTT(0) MULTIUP(1) FRONTOVL(HEADER) +
                          SPOOL(*YES) OUTQ(&PRINTER) FORMTYPE(*NAR) +
                          COPIES(&COPIES) SAVE(&OVRSAVE)

             CALL       PGM(PCK900) PARM(&ZERO &THISORDER '0')

 EOJ:        ENDPGM

