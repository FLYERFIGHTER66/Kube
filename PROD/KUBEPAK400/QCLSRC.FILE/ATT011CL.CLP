             PGM        PARM(&JOBTYPE)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)

             IF         COND(&JOBTYPE = ' ') THEN(CALL PGM(XATABLE) +
                          PARM('JC' '  ' &JOBTYPE))

             ENDPGM
