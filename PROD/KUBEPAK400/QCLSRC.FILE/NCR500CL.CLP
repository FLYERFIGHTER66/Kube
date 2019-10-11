             PGM
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(1)

 TOP:        CALL       PGM(NCR500) PARM(&RTN)
             IF         COND(&RTN = ' ') THEN(GOTO CMDLBL(END))

             CALL       PGM(NCR501) PARM(&RTN)
             IF         COND(&RTN = ' ') THEN(GOTO CMDLBL(END))
             GOTO       CMDLBL(TOP)

 END:        CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             ENDPGM
