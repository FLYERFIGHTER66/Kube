             PGM

             /*  In order for this program to be used as the system startup  +
                 program, it should be compiled into library QSYS.   */

             DCL        VAR(&STRWTRS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CTLSBSD) TYPE(*CHAR) LEN(20)
             DCL        VAR(&CPYR) TYPE(*CHAR) LEN(90) VALUE('5722-SS1 (C) +
                          COPYRIGHT IBM CORP 1980, 2000. LICENSED MATERIAL +
                          - PROGRAM PROPERTY OF IBM')

             QSYS/STRSBS SBSD(QSERVER)
             MONMSG     MSGID(CPF0000)

             QSYS/STRSBS SBSD(QUSRWRK)
             MONMSG     MSGID(CPF0000)

             QSYS/RLSJOBQ JOBQ(QGPL/QS36MRT)
             MONMSG     MSGID(CPF0000)

             QSYS/RLSJOBQ JOBQ(QGPL/QS36EVOKE)
             MONMSG     MSGID(CPF0000)

             QSYS/STRCLNUP
             MONMSG     MSGID(CPF0000)

             QSYS/RTVSYSVAL SYSVAL(QCTLSBSD) RTNVAR(&CTLSBSD)
             IF         COND((&CTLSBSD *NE 'QCTL      QSYS      ') *AND +
                          (&CTLSBSD *NE 'QBASE     QGPL      ') *AND +
                          (&CTLSBSD *NE 'QBASE     QSYS      ')) THEN(GOTO +
                          CMDLBL(DONE))

             QSYS/STRSBS SBSD(QINTER)
             MONMSG     MSGID(CPF0000)

             QSYS/STRSBS SBSD(QBATCH)
             MONMSG     MSGID(CPF0000)

             QSYS/STRSBS SBSD(QCMN)
             MONMSG     MSGID(CPF0000)

             QSYS/STRSBS SBSD(QSNADS)
             MONMSG     MSGID(CPF1010)

             QSYS/STRTCP
             MONMSG     MSGID(CPF0000)

 DONE:
             QSYS/STRSBS SBSD(QSPL)
             MONMSG     MSGID(CPF0000)

             QSYS/RTVSYSVAL SYSVAL(QSTRPRTWTR) RTNVAR(&STRWTRS)
             IF         COND(&STRWTRS = '0') THEN(GOTO CMDLBL(NOWTRS))
 WTRS:
             CALL       PGM(QSYS/QWCSWTRS)
             MONMSG     MSGID(CPF0000)
 NOWTRS:
             CHGCMDDFT  CMD(CRTSQLRPGI) NEWDFT('COMMIT(*NONE) +
                          DBGVIEW(*SOURCE)')
             MONMSG     MSGID(CPF6216 CPF6260 CPF6261)

             RETURN
             CHGVAR     VAR(&CPYR) VALUE(&CPYR)
             ENDPGM
