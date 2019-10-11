
             PGM        PARM(&SELDATE7 &MASTER &PRINTER)

             DCL        VAR(&SELDATE7) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&MASTER)  TYPE(*DEC) LEN(2 0)
             DCL        VAR(&PRINTER) TYPE(*CHAR) LEN(10)

             IF         COND(&PRINTER = ' ') THEN(CHGVAR +
                          VAR(&PRINTER) VALUE('XERPRT01'))

             OVRPRTF    FILE(PCK010P) TOFILE(*LIBL/PCK010P) +
                          DEVTYPE(*AFPDS) PAGESIZE(11 8.5 *UOM) +
                          LPI(7.5) CPI(12) FRONTMGN(.25 .25) +
                          PAGRTT(0) MULTIUP(1) FRONTOVL(KPLOGO) +
                          SPOOL(*YES) OUTQ(&PRINTER) FORMTYPE(*NAR) +
                          SCHEDULE(*FILEEND)
             OVRPRTF    FILE(PCK021P) TOFILE(*LIBL/PCK021P) +
                          DEVTYPE(*AFPDS) PAGESIZE(11 8.5 *UOM) +
                          LPI(7.5) CPI(12) FRONTMGN(.25 .25) +
                          PAGRTT(0) MULTIUP(1) FRONTOVL(KPLOGO) +
                          SPOOL(*YES) OUTQ(&PRINTER) FORMTYPE(*NAR) +
                          SCHEDULE(*FILEEND)
             CALL       PGM(PCK030) PARM(&SELDATE7 &MASTER)

             ENDPGM

