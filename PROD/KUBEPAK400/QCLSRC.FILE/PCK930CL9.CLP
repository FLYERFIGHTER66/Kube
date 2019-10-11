
             PGM        PARM(&SELFORD &SELTORD &PRINTER &SELCOPY)

             DCL        VAR(&SELFORD) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&SELTORD) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&PRINTER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SELCOPY) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&PRINTER) TYPE(*CHAR) LEN(10)

             IF         COND(&PRINTER *EQ ' ') THEN(CHGVAR +
                          VAR(&PRINTER) VALUE('XERPRT01'))

             OVRPRTF    FILE(PCK900P) TOFILE(*LIBL/PCK900P) +
                          DEVTYPE(*AFPDS) PAGESIZE(11 8.5 *UOM) +
                          LPI(7.5) CPI(12) FRONTMGN(.25 .25) +
                          PAGRTT(0) MULTIUP(1) FRONTOVL(HEADER) +
                          SPOOL(*YES) OUTQ(&PRINTER) FORMTYPE(*NAR) +
                          COPIES(&SELCOPY)

             CALL       PGM(PCK930) PARM(&SELFORD &SELTORD)

 EOJ:        ENDPGM

