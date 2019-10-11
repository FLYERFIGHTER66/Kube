             PGM
             DCL        VAR(&VENDOR) TYPE(*DEC) LEN(6)

             CALL       PGM(CUR999) PARM(&VENDOR)
             IF         COND(&VENDOR = 0) THEN(DO)
             SNDPGMMSG  MSGID(CUT0001) MSGF(KPMSGF) MSGDTA(*NONE) +
                          TOPGMQ(*EXT)
             GOTO       CMDLBL(END)
             ENDDO

             CALL       PGM(CUR400) PARM(&VENDOR)

 END:
             ENDPGM
