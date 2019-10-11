             PGM
             QSYS/DCL   VAR(&DATE) TYPE(*DEC) LEN(6 0) VALUE(0)
             QSYS/DCL   VAR(&ITEM) TYPE(*CHAR) LEN(12) VALUE(' ')
             QSYS/DCL   VAR(&SIZE) TYPE(*CHAR) LEN(03) VALUE(' ')

             CALL       PGM(GRS231) PARM(&DATE &ITEM &SIZE)

             ENDPGM
