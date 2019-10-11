             PGM        PARM(&FILE &LIBR)

             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(10)

             DSPRCDLCK  FILE(&LIBR/&FILE) RCDNBR(*ALL) OUTPUT(*)

             ENDPGM
