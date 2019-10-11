             PGM
             DCL        VAR(&CARD#) TYPE(*DEC) LEN(9 0) VALUE(0)
             DCL        VAR(&FILE#) TYPE(*DEC) LEN(6 0) VALUE(0)

             CALL       PGM(ATT070) PARM(&FILE# &CARD#)

             ENDPGM
