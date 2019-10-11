             PGM        PARM(&CUST@)
             DCL   VAR(&CUST@) TYPE(*CHAR) LEN(6)
             DCL   VAR(&CUST#) TYPE(*DEC) LEN(6 0)

             CHGVAR     VAR(&CUST#) VALUE(&CUST@)
             CALL       PGM(ARR010CLC) PARM(&CUST#)

END:         ENDPGM
