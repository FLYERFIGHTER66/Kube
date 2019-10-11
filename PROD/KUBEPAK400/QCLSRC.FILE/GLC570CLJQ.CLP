/*********************************************************************/
/*   PROGRAM-------- GLC570CLJQ                                      */
/*   DATE WRITTEN--- 02/25/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- TRIAL BALANCE BY ACCOUNT                        */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRTR) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)

             DCL        VAR(&JOBDATE7) TYPE(*CHAR) LEN(7)
             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ISBATCH) TYPE(*LGL) LEN(1)
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(20)
             DCL        VAR(&LINK) TYPE(*CHAR) LEN(85) VALUE('/Kube +
                          Pak/PDF/NIGHTREPORTS/')
             DCL        VAR(&UNC) TYPE(*CHAR) LEN(85) +
                          VALUE('"\\10.151.151.1\Kube +
                          Pak\PDF\NIGHTREPORTS\')


             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRTR)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)

             IF         COND(&PRTR *NE '*PDF') THEN(QSYS/OVRPRTF +
                          FILE(GLR570) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRTR) PAGESIZE(66 120) LPI(6) +
                          CPI(15) ALIGN(*NO) FORMTYPE(&FORM) +
                          COPIES(&COPY) HOLD(&HOLD) SAVE(&SAVE))

             IF         COND(&JOBNAME = 'NIGHT' *OR &JOBNAME = +
                          'SATURDAY' *OR &PRTR = '*PDF') THEN(DO)

             RTVJOBA    JOB(&JOBNAME) CYMDDATE(&JOBDATE7) +
                          DATETIME(&TIMESTAMP)

             CHGVAR     VAR(&LINK) VALUE(&LINK *TCAT &JOBDATE7)
             CHGVAR     VAR(&UNC) VALUE(&UNC *TCAT &JOBDATE7)
             CRTDIR     DIR(&LINK)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&LINK) VALUE(&LINK *TCAT '/' *TCAT 'GLR570' +
                          *TCAT '-' *TCAT &TIMESTAMP *TCAT '.pdf')
             CHGVAR     VAR(&UNC) VALUE(&UNC *TCAT '\' *TCAT +
                          'GLR570' *TCAT '-' *TCAT &TIMESTAMP *TCAT +
                          '.pdf"')
             OVRPRTF    FILE(GLR570) TOFILE(*LIBL/QSYSPRT) +
                          DEVTYPE(*AFPDS) PAGESIZE(66 120) LPI(6) +
                          CPI(15) ALIGN(*NO) TOSTMF(&LINK) WSCST(*PDF)
             CALL       PGM(GLR570)

/*  IF IT'S NOT A BATCH JOB, DISPLAY THE FOLDER  */
             CALL       PGM(#ISBATCH) PARM(&ISBATCH)
             IF         COND(&ISBATCH) THEN(GOTO CMDLBL(END))

             STRPCO
             MONMSG     MSGID(IWS4010)
             STRPCCMD   PCCMD(&UNC) PAUSE(*NO)
             MONMSG     MSGID(CPF0000)

             GOTO       CMDLBL(END)
             ENDDO

             CALL       PGM(GLR570)
 END:        ENDPGM
