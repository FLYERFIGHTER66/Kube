/*********************************************************************/
/*   PROGRAM-------- ARC350CL                                        */
/*   DATE WRITTEN--- 06/18/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- A/R DAILY CASH RECEIPTS REGISTER                */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(10) +
                          VALUE('ARR350    ')
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(10) +
                          VALUE('ARR351    ')
             DCL        VAR(&FILE3) TYPE(*CHAR) LEN(10) +
                          VALUE('ARR354    ')
             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNUMB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOBDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&JOBDATE7) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(20)
             DCL        VAR(&FILESTAMP) TYPE(*CHAR) LEN(40)
             DCL        VAR(&LINK) TYPE(*CHAR) LEN(85) VALUE('/Kube +
                          Pak/PDF/NIGHTREPORTS/')
             DCL        VAR(&UNC) TYPE(*CHAR) LEN(99) VALUE('\Kube +
                          Pak\PDF\NIGHTREPORTS\')
             DCL        VAR(&LINK1) TYPE(*CHAR) LEN(80)
             DCL        VAR(&LINK2) TYPE(*CHAR) LEN(80)
             DCL        VAR(&LINK3) TYPE(*CHAR) LEN(80)
             DCL        VAR(&ISBATCH) TYPE(*LGL) LEN(1)

             RTVJOBA    JOB(&JOBNAME) USER(&JOBUSER) NBR(&JOBNUMB) +
                          CYMDDATE(&JOBDATE7) DATETIME(&TIMESTAMP)

             CHGVAR     VAR(&LINK) VALUE(&LINK *TCAT &JOBDATE7)
             CHGVAR     VAR(&UNC) VALUE('Explorer.exe +
                          "\\10.151.151.1' *TCAT &UNC *TCAT +
                          &JOBDATE7 *TCAT '\"')
             CRTDIR     DIR(&LINK)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&LINK) VALUE(&LINK *TCAT '/')
             CHGVAR     VAR(&FILESTAMP) VALUE('-' *TCAT &TIMESTAMP *TCAT '.PDF')
             CHGVAR     VAR(&LINK1) VALUE(&LINK *TCAT &FILE1 *TCAT &FILESTAMP)
             CHGVAR     VAR(&LINK2) VALUE(&LINK *TCAT &FILE2 *TCAT &FILESTAMP)
             CHGVAR     VAR(&LINK3) VALUE(&LINK *TCAT &FILE3 *TCAT &FILESTAMP)

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

/*  FOR NIGHT JOB JUST DO PDF  */
             IF         COND((&JOBNAME *EQ 'NIGHT') *OR (&JOBNAME +
                          *EQ 'SATURDAY') *OR (&JOBNAME *EQ +
                              'DSP014_3') *OR (&JOBNAME *EQ +
                          'POSTING')) THEN(DO)
             QSYS/OVRPRTF FILE(ARR350) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          120) LPI(6) CPI(15) ALIGN(*NO) +
                          TOSTMF(&LINK1) WSCST(*PDF)

             CALL       PGM(ARR350)
             ENDDO
             ELSE       CMD(DO)
/*  FOR EVERYTHING ELSE DO PDF AND PRINT  */
             QSYS/OVRPRTF FILE(ARR350) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(*YES) SAVE(&SAVE)

             CALL       PGM(ARR350)

             CVTSPLFPDF SPLF(&FILE1) JOB(&JOBNUMB/&JOBUSER/&JOBNAME) +
                          SPLNBR(*LAST) TOPDF(&LINK1) +
                          PAPERSIZE(*LETTER) ORIENTAT(*V)
             MONMSG     MSGID(CPF0000) EXEC(DMPCLPGM)

             IF         COND(&HOLD *NE '*YES') THEN(DO)
             RLSSPLF    FILE(&FILE1) JOB(&JOBNUMB/&JOBUSER/&JOBNAME) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
             ENDDO
             ENDDO

/*  FOR ARR351 JUST DO PDF  */
             QSYS/OVRPRTF FILE(&FILE2) TOFILE(*LIBL/QSYSPRT) +
                          DEVTYPE(*AFPDS) PAGESIZE(66 120) LPI(6) +
                          CPI(15) TOSTMF(&LINK2) WSCST(*PDF)

             CALL       PGM(ARR351)

/*  FOR ARR354 JUST DO PDF  */
             OVRPRTF    FILE(&FILE3) TOFILE(*LIBL/QSYSPRT) +
                          DEVTYPE(*AFPDS) PAGESIZE(66 120) LPI(6) +
                          CPI(15) TOSTMF(&LINK3) WSCST(*PDF)

             CALL       PGM(ARR354)

/*  IF IT'S NOT A BATCH JOB, DISPLAY THE FOLDER  */
             CALL       PGM(#ISBATCH) PARM(&ISBATCH)
             IF         COND(&ISBATCH) THEN(GOTO CMDLBL(END))
             STRPCO
             MONMSG     MSGID(IWS4010)
             STRPCCMD   PCCMD(&UNC)

 END:        ENDPGM
