             PGM
             DCLF       FILE(KPZEROFM)

             SNDRCVF    RCDFMT(KPZERO01)
             IF         COND(&IN03 = '1') THEN(GOTO CMDLBL(EOJ))

             CALL PGM(KPZEROR)
             CALL PGM(KPZERORR)

 EOJ:        ENDPGM
