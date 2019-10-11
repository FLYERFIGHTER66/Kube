             PGM
             DCL        VAR(&COUNTER) TYPE(*DEC) LEN(2 0) VALUE(0)

 RERUN:      CHGVAR     VAR(&COUNTER) VALUE(&COUNTER + 1)
             IF         COND(&COUNTER > 92) THEN(GOTO CMDLBL(EOJ))
             SBMJOB     CMD(RUNQRY QRY(RBINV) QRYFILE((*SAME))) +
                          JOB(RBINV) JOBD(KUBEPAK400/KUBEPAK) +
                          JOBQ(QBATCH2)
             DLYJOB     DLY(900)
             GOTO       CMDLBL(RERUN)

 EOJ:        ENDPGM
