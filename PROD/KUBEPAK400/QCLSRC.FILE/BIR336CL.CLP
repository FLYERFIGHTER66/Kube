/*********************************************************************/
/*   PROGRAM-------- BIR336CL                                        */
/*   DATE WRITTEN--- 08/23/97                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- INVOICE INQUIRY                                 */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&REP) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATETIME) TYPE(*CHAR) LEN(20)
             DCL        VAR(&TOSTMF) TYPE(*CHAR) LEN(130)
             DCL        VAR(&INV@) TYPE(*CHAR) LEN(6)




AGN:  /*     CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')       */

             CALL       PGM(BIR336)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             RTVDTAARA  DTAARA(*LDA (9 6)) RTNVAR(&INV@)
             RTVJOBA    DATETIME(&DATETIME)
             RTVDTAARA  DTAARA(*LDA (3 1)) RTNVAR(&REP)

             IF         COND(&REP = 'Y') THEN(GOTO CMDLBL(REP))
             ELSE       GOTO (CRM)
      /* PRINT INVOICE     */
 REP:        QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)

             CHGVAR     VAR(&TOSTMF) VALUE('/Kube Pak/PDF/INVOICE/INV-' +
                          *TCAT &INV@ *TCAT '-' *TCAT &DATETIME *TCAT +
                          '.pdf')
             OVRPRTF    FILE(BIR330A) TOFILE(*LIBL/QSYSPRT) DEV(&PRT) +
                          DEVTYPE(*AFPDS) PAGESIZE(11 8.5 *UOM) LPI(6) +
                          CPI(12) FRONTMGN(.25 .25) ALIGN(*NO) PAGRTT(0) +
                          FRONTOVL(INVOICE .15) TOSTMF(&TOSTMF) WSCST(*PDF)
             CALL       PGM(BIR331)
             STRPCO
             MONMSG     MSGID(IWS4010)
             STRPCCMD   PCCMD('"//10.151.151.1' *TCAT &TOSTMF *TCAT '"') +
                          PAUSE(*NO)
             GOTO       AGN
      /*  PRINT CREDIT MEMO     */
 CRM:        IF         COND(&REP = 'N') THEN(GOTO CMDLBL(END))
             CHGDTAARA  DTAARA(*LDA (3 1)) VALUE('Y')
             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             CHGVAR     VAR(&TOSTMF) VALUE('/Kube Pak/PDF/CR_MEMO/CRM-' +
                          *TCAT &INV@ *TCAT '-' *TCAT &DATETIME *TCAT +
                          '.pdf')
             OVRPRTF    FILE(BIR465A) TOFILE(*LIBL/QSYSPRT) DEV(&PRT) +
                          DEVTYPE(*AFPDS) PAGESIZE(11 8.5 *UOM) LPI(6) +
                          CPI(12) FRONTMGN(0 0) ALIGN(*NO) PAGRTT(0) +
                          UOM(*INCH) FRONTOVL(CRMEMO 0) TOSTMF(&TOSTMF) +
                          WSCST(*PDF) OPNSCOPE(*JOB)
             CALL       PGM(BIR465)
             GOTO AGN
 END:        ENDPGM
