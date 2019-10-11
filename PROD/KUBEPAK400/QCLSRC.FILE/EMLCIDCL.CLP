             PGM

             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)
             DCLF       FILE(EMLCIDFM) RCDFMT(EMLCID01)

 LOOP:       SNDRCVF    RCDFMT(EMLCID01)

             IF         COND(&IN03 = '1') THEN(GOTO CMDLBL(EOJ))

             CHGVAR     VAR(&JOBNAME) VALUE(&SELCUST)
             CHGVAR     VAR(%SST(&JOBNAME 1 4)) VALUE('CUST')

             SBMJOB     CMD(CALL PGM(EMINVCUSJ1) PARM(&SELDATE +
                          &SELCUST)) JOB(&JOBNAME) JOBQ(QBATCH2)

             GOTO       CMDLBL(LOOP)

 EOJ:        ENDPGM
