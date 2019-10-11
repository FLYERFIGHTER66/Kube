/*********************************************************************/
/*   PROGRAM-------- BIR340CL                                        */
/*   DATE WRITTEN--- 11/18/99                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- DAILY INVOICE REGISTER     (DOP)                */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10) +
                          VALUE('BIR340    ')
             DCL        VAR(&JOBDATE7) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(20)
             DCL        VAR(&ISBATCH) TYPE(*LGL) LEN(1)
             DCL        VAR(&LINK) TYPE(*CHAR) LEN(80) VALUE('/Kube +
                          Pak/PDF/NIGHTREPORTS/')

             RTVJOBA    CYMDDATE(&JOBDATE7) DATETIME(&TIMESTAMP)

             CHGVAR     VAR(&LINK) VALUE(&LINK *TCAT &JOBDATE7)
             CRTDIR     DIR(&LINK)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&LINK) VALUE(&LINK *TCAT '/' *TCAT &FILE +
                          *TCAT '-' *TCAT &TIMESTAMP *TCAT '.pdf')

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

             CALL       PGM(#ISBATCH) PARM(&ISBATCH)
             IF         COND(&ISBATCH) THEN(GOTO CMDLBL(PDF))

 PRINTIT:    QSYS/OVRPRTF FILE(BIR340) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(15) +
                          OVRFLW(60) ALIGN(*NO) FORMTYPE(*NAR) +
                          HOLD(&HOLD) SAVE(*YES)
             CALL       PGM(BIR340)

 PDF:        OVRPRTF    FILE(&FILE) TOFILE(*LIBL/QSYSPRT) +
                          DEVTYPE(*AFPDS) PAGESIZE(66 120) LPI(6) +
                          CPI(15) OVRFLW(60) ALIGN(*NO) +
                          TOSTMF(&LINK) WSCST(*PDF)

             CALL       PGM(BIR340)
             MONMSG     MSGID(CPF0000) EXEC(DMPCLPGM)

 END:        ENDPGM
