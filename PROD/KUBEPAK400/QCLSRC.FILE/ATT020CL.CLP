             PGM        PARM(&JOBTYPE)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CARD#) TYPE(*DEC) LEN(8)

             IF         COND(&JOBTYPE = ' ') THEN(CALL PGM(ATT011CL) +
                          PARM(&JOBTYPE))
             CALL       PGM(ATT020) PARM(&JOBTYPE &CARD#)

             ENDPGM
