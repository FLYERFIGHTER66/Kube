/*********************************************************************/
/*   PROGRAM-------- BIC330CL                                        */
/*   DATE WRITTEN--- 08/29/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- INVOICE PRINT                                   */
/*   REVISIONS------                                                 */
/* 2/09/01 EFD CLEAR BIR235 WORK FILES                               */
/* 5/16/01 EFD ADD AUTO RUN OVER CREDIT LIMIT REPORT                 */
/*********************************************************************/
             PGM

             DCL        VAR(&PGMLIB) TYPE(*CHAR) LEN(10)

             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOB) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&REP) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&JUL) TYPE(*CHAR) LEN(5)
             QSYS/DCL   VAR(&DAT) TYPE(*CHAR) LEN(6)

             RTVOBJD    OBJ(PGMLIB) OBJTYPE(*FILE) RTNLIB(&PGMLIB)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('BIC330')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('        Print +
                          Invoices     ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (62 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(BIC330)
             QSYS/RTVDTAARA DTAARA(*LDA (62 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (3 1)) RTNVAR(&REP)
             IF         COND(&REP = 'Y') THEN(GOTO CMDLBL(REP))
             QSYS/RTVDTAARA DTAARA(*LDA (41 6)) RTNVAR(&DAT)
             CVTDAT     DATE(&DAT) TOVAR(&JUL) FROMFMT(*MDY) +
                          TOFMT(*JUL) TOSEP(*NONE)
             CHGDTAARA  DTAARA(*LDA (144 6)) VALUE(&JUL)
             QSYS/RTVDTAARA DTAARA(*LDA (4 1)) RTNVAR(&JOB)
             IF         COND(&JOB = 'Y') THEN(SBMJOB)
             CALL       PGM(BIR440)

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/OVRPRTF FILE(ARR371) TOFILE(*LIBL/QSYSPRT) DEV(P9) +
                          PAGESIZE(88 120) LPI(8) CPI(15) +
                          ALIGN(*NO) PRTQLTY(*DRAFT) FORMTYPE(*NAR) +
                          HOLD(*NO)
             CALL       PGM(ARR371)

 /* SUBMIT AUTO RUN CREDIT LIMIT REPORT                 */
             SBMJOB     CMD(CALL PGM(&PGMLIB/ARC370ACL))

             QSYS/RTVDTAARA DTAARA(*LDA (62 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
 REP:        QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (109 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)
             QSYS/OVRPRTF FILE(BIR330A) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(10) +
                          OVRFLW(60) ALIGN(*NO) PRTQLTY(*NLQ) +
                          FORMTYPE(&FORM) COPIES(&COPY) HOLD(&HOLD) +
                          SAVE(&SAVE)
             CALL       PGM(BIR330)

 /* CLEAR BIR235 WORK FILES                             */
             CLRPFM     FILE(FHORDWTM)
             CLRPFM     FILE(FIORDWTM)

 END:        CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             ENDPGM
