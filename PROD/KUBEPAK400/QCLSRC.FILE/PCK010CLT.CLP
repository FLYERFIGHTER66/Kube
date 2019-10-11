
             PGM

             DCL        VAR(&ORDER) TYPE(*DEC) LEN(6 0) VALUE(199093)
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(10) VALUE('*ALL')
             DCL        VAR(&LIST) TYPE(*CHAR) LEN(6) VALUE('*ALL')

             OVRPRTF    FILE(PCK010P) TOFILE(*LIBL/PCK010P) +
                          DEVTYPE(*AFPDS) PAGESIZE(11 8.5 *UOM) +
                          LPI(7.5) CPI(12) FRONTMGN(.25 .25) +
                          PAGRTT(0) MULTIUP(1) FRONTOVL(KPLOGO) +
                          SPOOL(*YES) OUTQ(XERPRT01) FORMTYPE(*NAR) +
                          HOLD(*YES)

             CALL       PGM(PCK010) PARM(&ORDER &GROUP &LIST)

             ENDPGM

