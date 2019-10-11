
             PGM        PARM(&SELDATE &SELTRUK &PRINTER &SELCOPY)

             DCL        VAR(&SELTRUK) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SELDATE) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&PRINTER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SELCOPY) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&THISORDER) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&ZERO) TYPE(*DEC) LEN(6 0) VALUE(0)
             DCL        VAR(&PRINTER) TYPE(*CHAR) LEN(10)

             IF         COND(&PRINTER *EQ ' ') THEN(CHGVAR +
                          VAR(&PRINTER) VALUE('XERPRT01'))

             OVRPRTF    FILE(PCK900P) TOFILE(*LIBL/PCK900P) +
                          DEVTYPE(*AFPDS) PAGESIZE(11 8.5 *UOM) +
                          LPI(7.5) CPI(12) FRONTMGN(.25 .25) +
                          PAGRTT(0) MULTIUP(1) FRONTOVL(HEADER) +
                          SPOOL(*YES) OUTQ(&PRINTER) FORMTYPE(*NAR) +
                          COPIES(&SELCOPY)

             CALL       PGM(PCK920) PARM(&SELDATE &SELTRUK)

 EOJ:        ENDPGM

