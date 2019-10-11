             PGM        PARM(&ZIP5)

             DCL        VAR(&ZIP5)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&MILES) TYPE(*DEC)  LEN(5 1) VALUE(0)

             CALL       PGM(GETMILES) PARM(&ZIP5 &MILES 'Y')

             ENDPGM
