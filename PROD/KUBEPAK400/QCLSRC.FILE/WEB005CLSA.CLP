             PGM

             SBMJOB     CMD(CALL PGM(WEB010CLSA)) JOB(WEB_RB_CUR) +
                          JOBD(KUBEPAK) JOBQ(QBATCH2) MSGQ(WEBSITE)
/*                        JOBD(KUBE_NOLOG) JOBQ(QBATCH2) MSGQ(WEBSITE)       */

             SBMJOB     CMD(CALL PGM(WEB020CLSA)) JOB(WEB_FINISH) +
                          JOBD(KUBEPAK) JOBQ(QBATCH2) MSGQ(WEBSITE)
/*                        JOBD(KUBE_NOLOG) JOBQ(QBATCH2) MSGQ(WEBSITE)       */

             SBMJOB     CMD(CALL PGM(WEB030CLSA)) JOB(WEB_RB_FUT) +
                          JOBD(KUBEPAK) JOBQ(QBATCH2) MSGQ(WEBSITE)
/*                        JOBD(KUBE_NOLOG) JOBQ(QBATCH2) MSGQ(WEBSITE)       */

             MONMSG     MSGID(CPF0000)
             SBMJOB     CMD(CALL PGM(AV_SENDALL)) JOB(AV_SENDALL) +
                          JOBD(KUBEPAK) JOBQ(QBATCH2) MSGQ(WEBSITE)
/*                        JOBD(KUBE_NOLOG) JOBQ(QBATCH2) MSGQ(WEBSITE)       */

 EOJ:        ENDPGM
