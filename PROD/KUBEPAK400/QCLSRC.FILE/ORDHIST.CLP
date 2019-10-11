             PGM        PARM(&ORD#)
             DCL        VAR(&ORD#) TYPE(*CHAR) LEN(6)

             STRQMQRY   QMQRY(ORDERHIST) SETVAR((ORDNO &ORD#))

             ENDPGM
