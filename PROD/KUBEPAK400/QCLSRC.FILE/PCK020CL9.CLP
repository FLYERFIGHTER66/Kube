
             PGM        PARM(&SELDATE &SELTRUK &GROUP &LIST &PRINTER &SELCOPY)

             DCL        VAR(&SELTRUK) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SELDATE) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&PRINTER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SELCOPY) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIST) TYPE(*CHAR) LEN(6)

             IF         COND(&PRINTER = ' ') THEN(CHGVAR +
                          VAR(&PRINTER) VALUE('XERPRT01'))

             OVRPRTF    FILE(PCK010P) TOFILE(*LIBL/PCK010P) +
                          DEVTYPE(*AFPDS) PAGESIZE(11 8.5 *UOM) +
                          LPI(7.5) CPI(12) FRONTMGN(.25 .25) +
                          PAGRTT(0) MULTIUP(1) FRONTOVL(KPLOGO) +
                          SPOOL(*YES) OUTQ(&PRINTER) FORMTYPE(*NAR) +
                          COPIES(&SELCOPY)


             CALL       PGM(PCK020) PARM(&SELTRUK &SELDATE &GROUP &LIST)

             DLTOVR     FILE(*ALL)

             ENDPGM

