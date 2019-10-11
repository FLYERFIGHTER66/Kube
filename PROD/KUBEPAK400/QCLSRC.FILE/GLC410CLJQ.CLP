/*********************************************************************/
/*   PROGRAM-------- GLC410CLJQ                                      */
/*   DATE WRITTEN--- 03/01/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- DAILY GENERAL JOURNAL                           */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&PRTR) TYPE(*CHAR) LEN(10)

             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10) +
                          VALUE('GLR410    ')
             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNUMB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOBDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOBDATE7) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(20)
             DCL        VAR(&LINK) TYPE(*CHAR) LEN(80) VALUE('/Kube +
                          Pak/PDF/NIGHTREPORTS/')

             RTVJOBA    JOB(&JOBNAME) USER(&JOBUSER) NBR(&JOBNUMB) +
                          CYMDDATE(&JOBDATE7) DATETIME(&TIMESTAMP)

             CHGVAR     VAR(&LINK) VALUE(&LINK *TCAT &JOBDATE7)
             CRTDIR     DIR(&LINK)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&LINK) VALUE(&LINK *TCAT '/' *TCAT &FILE +
                          *TCAT '-' *TCAT &TIMESTAMP *TCAT '.pdf')

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRTR)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

             QSYS/OVRPRTF FILE(&FILE) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRTR) PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(*YES) SAVE(&SAVE)

             CALL       PGM(GLR410)

             CVTSPLFPDF SPLF(GLR410) JOB(&JOBNUMB/&JOBUSER/&JOBNAME) +
                          SPLNBR(*LAST) TOPDF(&LINK) +
                          PAPERSIZE(*LETTER) ORIENTAT(*V)
             MONMSG     MSGID(CPF0000) EXEC(DMPCLPGM)

             IF         COND(&HOLD *NE '*YES') THEN(DO)
             RLSSPLF    FILE(&FILE) JOB(&JOBNUMB/&JOBUSER/&JOBNAME) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
             ENDDO

 END:        ENDPGM
