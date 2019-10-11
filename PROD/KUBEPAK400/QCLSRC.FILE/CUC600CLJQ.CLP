/*********************************************************************/
/*   PROGRAM-------- CUC600CLJQ                                      */
/*   DATE WRITTEN--- 11/07/01                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- 84 TRAY UNAVAILABLE REPORT  JOBQ PORTION        */
/*   DESCRIPTION---- 105 TRAY UNAVAILABLE REPORT  JOBQ PORTION        */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&VENDOR)
             DCL        VAR(&VENDOR) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&VENDOR@) TYPE(*CHAR) LEN(6)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&SEQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)

             QSYS/RTVDTAARA DTAARA(*LDA (1 1)) RTNVAR(&SEQ)
             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)


/* RUN CUTTING REQUIREMENTS TO GET ALL INFO */
             CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             CHGJOB     SWS(1XXXXXXX)
             CHGVAR     VAR(&VENDOR@) VALUE(&VENDOR)
             CHGDTAARA  DTAARA(*LDA (1 6)) VALUE(&VENDOR@)
             CALL       PGM(CUR100CL)
             CHGJOB     SWS(0XXXXXXX)

             CHGDTAARA  DTAARA(*LDA (1 1)) VALUE(&SEQ)
             CHGDTAARA  DTAARA(*LDA (100 10)) VALUE(&PRT)
             CHGDTAARA  DTAARA(*LDA (110 10)) VALUE(&FORM)
             CHGDTAARA  DTAARA(*LDA (120 2)) VALUE(&COPY)
             CHGDTAARA  DTAARA(*LDA (122 1)) VALUE(&JOBQ)
             CHGDTAARA  DTAARA(*LDA (123 4)) VALUE(&HOLD)
             CHGDTAARA  DTAARA(*LDA (127 4)) VALUE(&SAVE)

/*           IF         COND(&SEQ = 'A') THEN(RUNQRY QRY(CUR600QRYA) +       +
                          QRYFILE((*SAME)))                                  +
                                                                             +
             IF         COND(&SEQ = 'N') THEN(RUNQRY QRY(CUR600QRY) +        +
                          QRYFILE((*SAME)))                                */

             CALL       PGM(CUR600QY) PARM(&VENDOR)

             OVRPRTF    FILE(CUR600) TOFILE(QSYSPRT) DEV(&PRT) +
                          PAGESIZE(66 120) LPI(6) CPI(10) +
                          OVRFLW(60) ALIGN(*NO) FORMTYPE(&FORM) +
                          COPIES(&COPY) HOLD(&HOLD) SAVE(&SAVE)

             IF         COND(&SEQ = 'A') THEN(OVRDBF FILE(FCUT600) +
                          TOFILE(FCUT600A))

             IF         COND(&SEQ = 'N') THEN(OVRDBF FILE(FCUT600) +
                          TOFILE(FCUT600N))

             CALL       PGM(CUR600) PARM(&VENDOR)

 END:        CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             ENDPGM
