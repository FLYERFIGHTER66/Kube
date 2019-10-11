             PGM        PARM(&ENDTIME &MINUTES@)

             DCL        VAR(&ENDTIME)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&MINUTES@) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MINUTES)  TYPE(*DEC)  LEN(2 0)
             DCL        VAR(&SECONDS)  TYPE(*DEC)  LEN(4 0)
             DCL        VAR(&JOB)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)      TYPE(*CHAR) LEN(6)
             DCL        VAR(&LIBR)     TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
             SBMJOB     CMD(ENDJOB JOB(&NBR/&USER/&JOB)) +
                          JOB(CANCELWEB) JOBD(*LIBL/KUBE_NOLOG) +
                          JOBQ(QBATCH2) HOLD(*NO) SCDTIME(&ENDTIME) +
                          MSGQ(WEBSITE)

             CHGVAR     VAR(&MINUTES) VALUE(&MINUTES@)
             CHGVAR     VAR(&SECONDS) VALUE((&MINUTES) * 60)

 START:
/*? RUN PLUGS UPDATE ?*/
             SBMJOB     CMD(CALL PGM(WEB005CLSA)) JOB(WEBBUILD2) +
                          JOBD(*LIBL/KUBE_NOLOG) JOBQ(QBATCH2) +
                          MSGQ(*NONE)
             IF         COND(&MINUTES *EQ 0) THEN(GOTO CMDLBL(EOJ))
             DLYJOB     DLY(&SECONDS)
             GOTO       CMDLBL(START)

 EOJ:        ENDPGM
