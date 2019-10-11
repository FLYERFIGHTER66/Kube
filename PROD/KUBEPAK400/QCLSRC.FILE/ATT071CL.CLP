             PGM
             DCL        VAR(&SEARCH) TYPE(*CHAR) LEN(15) VALUE(' ')
             DCL        VAR(&CARD#) TYPE(*DEC) LEN(9 0) VALUE(0)
             DCL        VAR(&FILE#) TYPE(*DEC) LEN(6 0) VALUE(0)

             CALL       PGM(ATT071) PARM(&SEARCH &FILE# &CARD#)

             ENDPGM
