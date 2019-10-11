             PGM        PARM(&OBJ &RESULT)
             DCL        VAR(&OBJ) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RESULT) TYPE(*LGL) LEN(1)

             ADDLIBLE   LIB(IFSTOOL) POSITION(*LAST)
             MONMSG     MSGID(CPF2103)

             IFSTOOL/CHKIFSOBJ OBJ(&OBJ) RESULT(&RESULT)
             RETURN

 EOJ:        ENDPGM
