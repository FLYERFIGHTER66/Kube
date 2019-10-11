/*********************************************************************/
/*   PROGRAM-------- BIC455CL                                        */
/*   DATE WRITTEN--- 08/29/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- CREDIT MEMO PRINT                               */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOB) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&REP) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&DATETIME) TYPE(*CHAR) LEN(20)
             DCL        VAR(&TOSTMF) TYPE(*CHAR) LEN(130)
             DCL        VAR(&INV@) TYPE(*CHAR) LEN(6)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('BIC455')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('     Print +
                          Credit Memos    ')
             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&DATETIME)

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(BIC455)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (3 1)) RTNVAR(&REP)
             IF         COND(&REP = 'Y') THEN(GOTO CMDLBL(REP))

             CALL       PGM(BIR455)
 REP:        QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (109 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

/*           QSYS/OVRPRTF FILE(BIR465A) TOFILE(*LIBL/QSYSPRT) DEV(&PRT) +
                          PAGESIZE(66 120) LPI(6) CPI(10) OVRFLW(60) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)   */

             CHGVAR     VAR(&TOSTMF) VALUE('/Kube +
                          Pak/PDF/CR_MEMO/CRM' *TCAT '-' *TCAT +
                          &DATETIME *TCAT '.pdf')
             OVRPRTF    FILE(BIR465A) TOFILE(*LIBL/QSYSPRT) DEV(&PRT) +
                          DEVTYPE(*AFPDS) PAGESIZE(11 8.5 *UOM) LPI(6) +
                          CPI(12) FRONTMGN(0 0) ALIGN(*NO) PAGRTT(0) +
                          UOM(*INCH) FRONTOVL(CRMEMO 0) TOSTMF(&TOSTMF) +
                          WSCST(*PDF) OPNSCOPE(*JOB)
             CALL       PGM(BIR465)
             STRPCO
             MONMSG     MSGID(IWS4010)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))
             STRPCCMD   PCCMD('"//10.151.151.1' *TCAT &TOSTMF *TCAT '"') +
                          PAUSE(*NO)
 END:        ENDPGM
