
             PGM        PARM(&ORDER &PRINTER &COPIES &SAVE)

             DCL        VAR(&ORDER) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&PRINTER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(10) VALUE('*ALL')
             DCL        VAR(&LIST) TYPE(*CHAR) LEN(6) VALUE('*ALL')
             DCL        VAR(&COPIES) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SAVE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OVRSAVE) TYPE(*CHAR) LEN(10) VALUE('*NO')

             IF         COND(&SAVE = 'Y') THEN(CHGVAR +
                          VAR(&OVRSAVE) VALUE('*YES'))

             IF         COND(&GROUP = ' ') THEN(CHGVAR +
                          VAR(&GROUP) VALUE('*ALL'))

             IF         COND(&PRINTER = ' ') THEN(CHGVAR +
                          VAR(&PRINTER) VALUE('XERPRT01'))

             OVRPRTF    FILE(PCK010P) TOFILE(*LIBL/PCK010P) +
                          DEVTYPE(*AFPDS) PAGESIZE(11 8.5 *UOM) +
                          LPI(7.5) CPI(12) FRONTMGN(.25 .25) +
                          PAGRTT(0) MULTIUP(1) FRONTOVL(KPLOGO) +
                          SPOOL(*YES) OUTQ(&PRINTER) FORMTYPE(*NAR) +
                          COPIES(&COPIES) SAVE(&OVRSAVE)

             CALL       PGM(PCK010) PARM(&ORDER &GROUP &LIST)

             ENDPGM

