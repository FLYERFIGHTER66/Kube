             PGM
             DCL        VAR(&LIBNAME) TYPE(*CHAR) LEN(10)
             DCLF       FILE(PRG_RGZFIL)

             RTVOBJD    OBJ(PRG_RGZFIL) OBJTYPE(*FILE) RTNLIB(&LIBNAME)

             DSPFD      FILE(&LIBNAME/*ALL) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) FILEATR(*PF) +
                          OUTFILE(&LIBNAME/PRG_RGZFIL)

 READLOOP:   RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDLOOP))

             IF         COND((&MLFILE *NE 'PRG_RGZFIL') *AND +
                          (&MLNDTR *GT 0)) THEN(DO)
             RGZPFM     FILE(&MLLIB/&MLFILE) MBR(&MLNAME)
             MONMSG     MSGID(CPF0000)
             ENDDO

             GOTO       CMDLBL(READLOOP)
 ENDLOOP:
             ENDPGM
