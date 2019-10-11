/*********************************************************************/
/*   PROGRAM-------- BIC3355L                                        */
/*   DATE WRITTEN---  6/13/01                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- INVOICE PRINT  PREPOST INVOICES ONLY            */
/*   REVISIONS------                                                 */
/* 5/16/01 EFD ADD AUTO RUN OVER CREDIT LIMIT REPORT                 */
/*********************************************************************/
             PGM

             DCL        VAR(&DATALIB) TYPE(*CHAR) LEN(10)
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
             QSYS/DCL   VAR(&DAT) TYPE(*CHAR) LEN(6)

             DCL        VAR(&DATETIME) TYPE(*CHAR) LEN(20)
             DCL        VAR(&TOSTMF) TYPE(*CHAR) LEN(130)

             RTVOBJD    OBJ(DATALIB) OBJTYPE(*FILE) RTNLIB(&DATALIB)
             RTVOBJD    OBJ(PGMLIB) OBJTYPE(*FILE) RTNLIB(&PGMLIB)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('BIC330')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('        Print +
                          Invoices     ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (62 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(BIC335)
             QSYS/RTVDTAARA DTAARA(*LDA (62 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (41 6)) RTNVAR(&DAT)
             CVTDAT     DATE(&DAT) TOVAR(&JUL) FROMFMT(*MDY) +
                          TOFMT(*JUL) TOSEP(*NONE)
             CHGDTAARA  DTAARA(*LDA (144 6)) VALUE(&JUL)
             QSYS/RTVDTAARA DTAARA(*LDA (4 1)) RTNVAR(&JOB)

 NXTINV:     CALL       PGM(BIR335)

       /* IF NO INVOICES SELECTED GOTO END */
             QSYS/RTVDTAARA DTAARA(*LDA (62 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

 REP:        QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (109 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

/* OLD       QSYS/OVRPRTF FILE(BIR330A) TOFILE(*LIBL/QSYSPRT) +
   PRINTED VERSION        DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(10) +
                          OVRFLW(60) ALIGN(*NO) PRTQLTY(*DRAFT) +
                          FORMTYPE(&FORM) COPIES(&COPY) HOLD(&HOLD) +
                          SAVE(&SAVE) */
             RTVJOBA    DATETIME(&DATETIME)
             CHGVAR     VAR(&TOSTMF) VALUE('/KUBE +
                          PAK/PDF/INVOICE_BATCH/INVOICES-' *TCAT +
                          &DATETIME *TCAT '.pdf')
             OVRPRTF    FILE(BIR330A) TOFILE(QSYSPRT) DEV(&PRT) +
                          DEVTYPE(*AFPDS) PAGESIZE(11 8.5 *UOM) +
                          LPI(6) CPI(12) FRONTMGN(.25 .25) +
                          ALIGN(*NO) PAGRTT(0) FRONTOVL(INVOICE +
                          .15) TOSTMF(&TOSTMF) WSCST(*PDF)
       /* USE TEMP FILES */
             OVRDBF     FILE(FHORDWRS) TOFILE(&DATALIB/FHORDWTMRS)
             OVRDBF     FILE(FIORDW) TOFILE(&DATALIB/FIORDWTM) +
                          MBR(*FIRST)
             CALL       PGM(BIR330)
             STRPCO
             MONMSG     MSGID(IWS4010)
             STRPCCMD   PCCMD('"//10.151.151.1' *TCAT &TOSTMF *TCAT +
                          '"') PAUSE(*NO)

       /* SUBMIT AUTO RUN CREDIT LIMIT REPORT                 */
 ENDOK:      SBMJOB     CMD(CALL PGM(&PGMLIB/ARC370ACL))

 END:        CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             ENDPGM
