/*********************************************************************/
/*   PROGRAM-------- ARC510CL                                        */
/*   DATE WRITTEN--- 07/30/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- STATEMENT PRINT                                 */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&EMAIL)
             DCL        VAR(&EMAIL)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&FORM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&COPY)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&HOLD)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&SAVE)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&JOBQ)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&BASEDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&FRCUST)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&TOCUST)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&INCLZERO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&INCLCRED) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(5) VALUE('EMAIL')
             DCL        VAR(&LINK) TYPE(*CHAR) LEN(60)              +
                        VALUE('/Kube Pak/PDF/EMAIL/STATEMENTS/Statement.pdf')

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (122  1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (120  2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (123  4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127  4)) RTNVAR(&SAVE)

             RTVDTAARA  DTAARA(*LDA (03 6)) RTNVAR(&BASEDATE)
             RTVDTAARA  DTAARA(*LDA (09 6)) RTNVAR(&FRCUST)
             RTVDTAARA  DTAARA(*LDA (15 6)) RTNVAR(&TOCUST)
             RTVDTAARA  DTAARA(*LDA (21 1)) RTNVAR(&INCLZERO)
             RTVDTAARA  DTAARA(*LDA (22 1)) RTNVAR(&INCLCRED)

             CHGVAR     VAR(&TYPE) VALUE('PRINT')
             OVRPRTF    FILE(STATEMENTP) DEV(&PRT) DEVTYPE(*AFPDS) +
                          PAGESIZE(66 96) LPI(6) CPI(12) ALIGN(*NO) +
                          PAGRTT(0) REDUCE(*NONE) +
                          FRONTOVL(STATEMNT) FORMTYPE(&FORM) +
                          COPIES(&COPY) HOLD(&HOLD) SAVE(&SAVE) +
                          USRDTA(U.S.P.S.)
             CALL       PGM(STATEMENTS) PARM(&BASEDATE &FRCUST +
                          &TOCUST &INCLCRED &INCLZERO &EMAIL &TYPE)

             IF         COND(&EMAIL = 'Y') THEN(DO)
             CHGVAR     VAR(&TYPE) VALUE('FAX  ')
             OVRPRTF    FILE(STATEMENTP) DEV(&PRT) DEVTYPE(*AFPDS) +
                          PAGESIZE(66 96) LPI(6) CPI(12) ALIGN(*NO) +
                          PAGRTT(0) REDUCE(*NONE) +
                          FRONTOVL(STATEMNT) FORMTYPE(&FORM) +
                          COPIES(&COPY) HOLD(&HOLD) SAVE(&SAVE) +
                          USRDTA('Via FAX')
             CALL       PGM(STATEMENTS) PARM(&BASEDATE &FRCUST +
                          &TOCUST &INCLCRED &INCLZERO &EMAIL &TYPE)

             CHGVAR     VAR(&TYPE) VALUE('EMAIL')
             OVRPRTF    FILE(STATEMENTP) DEV(&PRT) DEVTYPE(*AFPDS) +
                          PAGESIZE(66 96) LPI(6) CPI(12) ALIGN(*NO) +
                          PAGRTT(0) REDUCE(*NONE) +
                          FRONTOVL(STATEMNT) FORMTYPE(&FORM) +
                          COPIES(&COPY) HOLD(&HOLD) SAVE(&SAVE) +
                          USRDTA('Via EMAIL') TOSTMF(&LINK) WSCST(*PDF)
             RMVLNK     OBJLNK(&LINK)
             MONMSG     MSGID(CPFA0A9)
             CALL       PGM(STATEMENTS) PARM(&BASEDATE &FRCUST +
                          &TOCUST &INCLCRED &INCLZERO &EMAIL &TYPE)
             ENDDO


             CLRPFM     FILE(FARTOT)

 END:        ENDPGM
