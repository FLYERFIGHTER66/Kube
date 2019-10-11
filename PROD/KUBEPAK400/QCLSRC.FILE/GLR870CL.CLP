/*********************************************************************/
/*   PROGRAM-------- GLR870CL                                        */
/*   DATE WRITTEN--- 03/21/97                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- G/L CONSOLIDATION                               */
/*   REVISIONS------ 6/13/00 PUT REPORT ON HOLD                      */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)

             DCL        VAR(&JOBDATE7) TYPE(*CHAR) LEN(7)
             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ISBATCH) TYPE(*LGL) LEN(1)
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(20)
             DCL        VAR(&LINK) TYPE(*CHAR) LEN(85) VALUE('/Kube +
                          Pak/PDF/NIGHTREPORTS/')

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

             RTVJOBA    JOB(&JOBNAME) CYMDDATE(&JOBDATE7) +
                          DATETIME(&TIMESTAMP)

             CHGVAR     VAR(&LINK) VALUE(&LINK *TCAT &JOBDATE7)
             CRTDIR     DIR(&LINK)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&LINK) VALUE(&LINK *TCAT '/' *TCAT 'GLR870' +
                          *TCAT '-' *TCAT &TIMESTAMP *TCAT '.pdf')

             QSYS/OVRPRTF FILE(GLR870) TOFILE(*LIBL/QSYSPRT) +
                          DEVTYPE(*AFPDS) PAGESIZE(66 120) LPI(6) +
                          CPI(15) TOSTMF(&LINK) WSCST(*PDF)

             CALL       PGM(GLR870)
 END:        ENDPGM
