/*********************************************************************/
/*   PROGRAM-------- BIR235ICL                                       */
/*   DATE WRITTEN--- 06/07/2004                                      */
/*   PROGRAMMER----- WILLIAM J. BEHR                                 */
/*   DESCRIPTION---- SHIPMENT CONFIRMATION FROM ORDER ENTRY          */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ORD)

             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CAN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&IMED) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ORD) TYPE(*CHAR) LEN(6)

             DCL        VAR(&LBINV) TYPE(*CHAR) LEN(6)
             DCL        VAR(&LEINV) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DATETIME) TYPE(*CHAR) LEN(20)
             DCL        VAR(&TOSTMF) TYPE(*CHAR) LEN(130)

             CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (50 6)) VALUE(&ORD)
             CHGDTAARA  DTAARA(*LDA (64 1)) VALUE(&IMED)
             CHGDTAARA  DTAARA(*LDA (65 1)) VALUE('Y')

             CALL       PGM(BIR235)
             RTVDTAARA  DTAARA(*LDA (62 1)) RTNVAR(&CAN)

             IF         COND(&CAN = 'X' *OR &CAN = 'O') THEN(GOTO CMDLBL(END))

             IF         COND(&CAN = 'I') THEN(DO)
             RTVDTAARA  DTAARA(*LDA (31 10)) RTNVAR(&PRT)
/*  PRINTER  QSYS/OVRPRTF FILE(BIR330A) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(10) +
                          ALIGN(*NO) PRTQLTY(*DRAFT) FORMTYPE(*INV)   */
             RTVDTAARA  DTAARA(*LDA (10 06)) RTNVAR(&LBINV)
             RTVDTAARA  DTAARA(*LDA (16 06)) RTNVAR(&LEINV)
             RTVJOBA    DATETIME(&DATETIME)
             IF         COND(&LBINV *EQ ' ') THEN(CHGVAR VAR(&LBINV) +
                          VALUE('000000'))
             IF         COND(&LEINV *EQ ' ') THEN(CHGVAR VAR(&LEINV) +
                          VALUE('000000'))
             IF         COND((&LBINV *GE '000000') *AND (&LBINV *EQ +
                          &LEINV)) THEN(DO)
             CHGVAR     VAR(&TOSTMF) VALUE('/KUBE +
                          PAK/PDF/INVOICE/INV-' *TCAT &LBINV *TCAT +
                          '-' *TCAT &DATETIME *TCAT '.pdf')
             ENDDO
             ELSE       CMD(DO)
             CHGVAR     VAR(&TOSTMF) VALUE('/KUBE +
                          PAK/PDF/INVOICE_BATCH/INVOICES-' *TCAT +
                          &DATETIME *TCAT '.pdf')
             ENDDO
             OVRPRTF    FILE(BIR330A) TOFILE(QSYSPRT) DEV(&PRT) +
                          DEVTYPE(*AFPDS) PAGESIZE(11 8.5 *UOM) +
                          LPI(6) CPI(12) FRONTMGN(.25 .25) +
                          ALIGN(*NO) PAGRTT(0) FRONTOVL(INVOICE +
                          .15) TOSTMF(&TOSTMF) WSCST(*PDF)
             OVRDBF     FILE(FHORDWRS) TOFILE(FHORDWTMRS)
             OVRDBF     FILE(FIORDW) TOFILE(FIORDWTM) +
                          MBR(*FIRST)
             CALL       PGM(BIR330)
             STRPCO
             MONMSG     MSGID(IWS4010)
             STRPCCMD   PCCMD('"//10.151.151.1' *TCAT &TOSTMF *TCAT +
                          '"') PAUSE(*NO)
/*           GOTO       CMDLBL(END)                               */
             ENDDO

             RTVDTAARA  DTAARA(*LDA (64 1)) RTNVAR(&IMED)

             IF         COND(&IMED = 'Y') THEN(DO)
             RTVDTAARA  DTAARA(*LDA (50 6)) RTNVAR(&ORD)
             RTVDTAARA  DTAARA(*LDA (31 10)) RTNVAR(&PRT)
             CALL       PGM(BIR440)
             CALL       PGM(BIR330CL)
             ENDDO

 END:
             RTVDTAARA  DTAARA(*LDA (62 1)) RTNVAR(&CAN)
             CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (62 1)) VALUE(&CAN)
             ENDPGM
