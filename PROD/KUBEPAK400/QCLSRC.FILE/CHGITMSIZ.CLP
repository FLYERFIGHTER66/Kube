             PGM
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(10)
             DCLF       FILE(CHGITMSIZF)

             RTVOBJD    OBJ(CHGITMSIZF) OBJTYPE(*FILE) RTNLIB(&LIBR)

 NEXTRECD:   RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(EOF))

             STRQMQRY   QMQRY(CHGITMSIZQ) SETVAR((LIBR &LIBR) (FILE +
                          &CFFILE) (ITEM &CFITEM) (SIZE &CFSIZE))
             GOTO       CMDLBL(NEXTRECD)
 EOF:

             ENDPGM
