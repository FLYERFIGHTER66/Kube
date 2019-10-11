             PGM        PARM(&ORD@)

             DCL   VAR(&ORD@) TYPE(*CHAR) LEN(6)
             DCL   VAR(&ORD#) TYPE(*DEC) LEN(6 0)
             CHGVAR     VAR(&ORD#) VALUE(&ORD@)
             CALL       PGM(CANORD) PARM(&ORD#)

             ENDPGM
