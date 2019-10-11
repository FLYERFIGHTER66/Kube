             PGM
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(20)
             DCL        VAR(&FAILED) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&FAILED@) TYPE(*CHAR) LEN(1)

             DLTOBJ     OBJ(QGPL/#QBATCH_X) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF2105)

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIMESTAMP)

 LOOP01:     SBMJOB     CMD(CRTDTAARA DTAARA(QGPL/#QBATCH_X) +
                          TYPE(*CHAR) LEN(20) VALUE(&TIMESTAMP)) +
                          JOB(#QBATCH_X) JOBD(KUBEPAK400/KUBEPAK) +
                          JOBQ(QBATCH) USER(NIGHT) LOG(0 99 *NOLIST)
             CHGVAR     VAR(&FAILED) VALUE(0)
             DLYJOB     DLY(60)
             GOTO       CMDLBL(TEST01)
 LOOP02:     DLYJOB     DLY(600)
 TEST01:     DLTOBJ     OBJ(QGPL/#QBATCH_X) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF2105) EXEC(DO)
             CHGVAR     VAR(&FAILED)  VALUE(&FAILED + 1)
             CHGVAR     VAR(&FAILED@) VALUE(&FAILED)
             SNDDST     TYPE(*LMSG) TOINTNET(('webmaster@kubepak.com') +
                          ('bcc@kubepak.net' *BCC)) DSTD('Kube-Pak iSeries +
                          Error Notification') MSG('An error was detected +
                          by the Kube-Pak iSeries while testing the QBATCH +
                          job que.') LONGMSG('An error was detected by the +
                          Kube-Pak iSeries while testing the QBATCH job +
                          que.  This was test failure ' *CAT &FAILED@ *CAT +
                          ' of 3. If additional tests remain, they will be +
                          rerun in 10 minutes.')
             IF         COND(&FAILED >= 3) THEN(DO)
             SNDDST     TYPE(*LMSG) +
                          TOINTNET(('helpdesk@kubepak.net') +
                          ('webmaster@kubepak.com' *BCC) +
                          ('bcc@kubepak.net' *BCC)) DSTD('[Ticket +
                          #1519] IBM i Error Notification') MSG('An +
                          error was detected by the Kube-Pak IBM i +
                          while testing the QBATCH job que.  We +
                          have tested multiple times and are now +
                          quitting.') LONGMSG('An error was +
                          detected by the Kube-Pak iSeries while +
                          testing the QBATCH job que.  This test +
                          failed multiple times, so a trouble +
                          ticket is being created for this issue.')
             GOTO       CMDLBL(EOJ)
             ENDDO
             GOTO       CMDLBL(LOOP02)
             ENDDO
             GOTO CMDLBL(LOOP01)

 EOJ:        ENDPGM
