
             PGM        PARM(&ORDER &GROUP &LIST &PRINTER)

             DCL        VAR(&ORDER) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&PRINTER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIST) TYPE(*CHAR) LEN(6)

             IF         COND(&GROUP = ' ') THEN(CHGVAR +
                          VAR(&GROUP) VALUE('*ALL'))

             IF         COND(&LIST = ' ') THEN(CHGVAR +
                          VAR(&LIST) VALUE('*ALL'))

             IF         COND(&PRINTER = ' ') THEN(CHGVAR +
                          VAR(&PRINTER) VALUE('XERPRT01'))

             OVRPRTF    FILE(PCK010P) TOFILE(*LIBL/PCK010P) +
                          DEVTYPE(*AFPDS) PAGESIZE(11 8.5 *UOM) +
                          LPI(7.5) CPI(12) FRONTMGN(.25 .25) +
                          PAGRTT(0) MULTIUP(1) FRONTOVL(KPLOGO) +
                          SPOOL(*YES) OUTQ(&PRINTER) FORMTYPE(*NAR)

             CALL       PGM(PCK010) PARM(&ORDER &GROUP &LIST)

             ENDPGM

