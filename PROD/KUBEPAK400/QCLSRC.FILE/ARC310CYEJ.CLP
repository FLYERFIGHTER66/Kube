/*********************************************************************/
/*   PROGRAM-------- ARC310CL                                        */
/*   DATE WRITTEN--- 04/01/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- A/R AGING REPORT - CUSTOMER DETAIL              */
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

             DCL        VAR(&JOBDATE7) TYPE(*CHAR) LEN(7)
             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ISBATCH) TYPE(*LGL) LEN(1)
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(20)
             DCL        VAR(&LINK) TYPE(*CHAR) LEN(90) VALUE('/Kube +
                          Pak/PDF/NIGHTREPORTS/')

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

             IF         COND(&PRT *NE '*PDF') THEN(DO)
             QSYS/OVRPRTF FILE(ARR310) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 121) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)
             ENDDO
             ELSE       CMD(DO)
             RTVJOBA    JOB(&JOBNAME) CYMDDATE(&JOBDATE7) +
                          DATETIME(&TIMESTAMP)

             CHGVAR     VAR(&LINK) VALUE(&LINK *TCAT &JOBDATE7)
             CRTDIR     DIR(&LINK)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&LINK) VALUE(&LINK *TCAT '/' *TCAT 'ARR310YE' +
                          *TCAT '-' *TCAT &TIMESTAMP *TCAT '.pdf')
             OVRPRTF    FILE(ARR310) TOFILE(*LIBL/QSYSPRT) +
                          DEVTYPE(*AFPDS) PAGESIZE(66 121) LPI(6) +
                          CPI(15) ALIGN(*NO) TOSTMF(&LINK) WSCST(*PDF)
             ENDDO


             CALL       PGM(ARR310YE)
 END:        ENDPGM
