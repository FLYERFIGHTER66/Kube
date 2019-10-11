
             PGM        PARM(&TRUCK &SELDATE7 &GROUP &PRINTER)

             DCL        VAR(&TRUCK) TYPE(*CHAR) LEN(4) VALUE('C')
             DCL        VAR(&SELDATE7) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRINTER) TYPE(*CHAR) LEN(10)

             IF         COND(&PRINTER *EQ ' ') THEN(CHGVAR +
                          VAR(&PRINTER) VALUE('P6'))

             OVRPRTF    FILE(PCK021P) TOFILE(*LIBL/PCK021P) +
                          DEVTYPE(*AFPDS) PAGESIZE(11 8.5 *UOM) +
                          LPI(7.5) CPI(12) FRONTMGN(.25 .25) +
                          PAGRTT(0) MULTIUP(1) FRONTOVL(KPLOGO) +
                          SPOOL(*YES) OUTQ(&PRINTER) FORMTYPE(*NAR)
             CALL       PGM(PCK021) PARM(&TRUCK &SELDATE7 &GROUP)

             ENDPGM

