             PGM

             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)

             QSYS/RTVOBJD OBJ(LOT100CL) OBJTYPE(*PGM) RTNLIB(&LIB)
             ADDLIBLE   LIB(&LIB)
             MONMSG     MSGID(CPF2103)

             ADDLIBLE   TESTDATA
             MONMSG     MSGID(CPF2103)

             IF         COND(%SST(&LIB 1 4) = 'KUBE') THEN(DO)
             ADDLIBLE   TGMSDATA
             MONMSG     MSGID(CPF2103)
             ENDDO

             CALL       PGM(LOT100)

             ENDPGM
