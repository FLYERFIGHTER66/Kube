             PGM        PARM(&SHCYM &MASTER &INC_RB &PRINTER)
             DCL        VAR(&SHCYM) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&MASTER) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&INC_RB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRINTER) TYPE(*CHAR) LEN(10)

             OVRPRTF    FILE(QPRINT98) TOFILE(*LIBL/QSYSPRT) ALIGN(*NO) +
                          PAGRTT(0) OUTQ(&PRINTER) FORMTYPE(*NAR) COPIES(1)

             CALL       PGM(PSR200) PARM(&SHCYM &MASTER &INC_RB)

 END:        ENDPGM
