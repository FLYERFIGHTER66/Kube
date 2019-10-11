             PGM
             DCL        VAR(&COUNTER) TYPE(*DEC) LEN(2 0) VALUE(0)

 RERUN:      CHGVAR     VAR(&COUNTER) VALUE(&COUNTER + 1)
             IF         COND(&COUNTER > 17) THEN(GOTO CMDLBL(EOJ))
             SBMJOB     CMD(RUNQRY QRY(UNALOCPLHR) QRYFILE((*SAME))) +
                          JOB(UNALOCPLHR) JOBD(KUBEPAK400/KUBEPAK) +
                          JOBQ(QBATCH2)
             SBMJOB     CMD(RUNQRY QRY(UNALOCPLIT) QRYFILE((*SAME))) +
                          JOB(UNALOCPLIT) JOBD(KUBEPAK400/KUBEPAK) +
                          JOBQ(QBATCH2)
             SBMJOB     CMD(RUNQRY QRY(UNALOCPLIX) QRYFILE((*SAME))) +
                          JOB(UNALOCPLIT) JOBD(KUBEPAK400/KUBEPAK) +
                          JOBQ(QBATCH2)
             DLYJOB     DLY(3600)
             GOTO       CMDLBL(RERUN)

 EOJ:        ENDPGM
