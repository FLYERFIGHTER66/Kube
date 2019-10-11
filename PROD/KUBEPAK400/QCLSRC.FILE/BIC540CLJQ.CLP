/*********************************************************************/
/*   PROGRAM-------- BIC540CLJQ                                      */
/*   DATE WRITTEN--- 10/03/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- CREDIT MEMO PROOF LIST                          */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&LINK) TYPE(*CHAR) LEN(85) VALUE('/Kube +
                          Pak/PDF/CR_MEMO/ProofList_')
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(20)

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

             IF         COND(&PRT *NE '*PDF') THEN(DO)
             QSYS/OVRPRTF FILE(BIR540) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)
             CALL       PGM(BIR540)
                        GOTO END
             ENDDO
             ELSE       CMD(DO)
             RTVJOBA    DATETIME(&TIMESTAMP)
             CHGVAR     VAR(&LINK) VALUE(&LINK *TCAT &TIMESTAMP +
                          *TCAT '.pdf')
             OVRPRTF    FILE(BIR540) TOFILE(*LIBL/QSYSPRT) +
                          DEVTYPE(*AFPDS) PAGESIZE(66 120) LPI(6) +
                          CPI(15) ALIGN(*NO) TOSTMF(&LINK) WSCST(*PDF)
             CALL       PGM(BIR540)
             CHGVAR     VAR(&LINK) VALUE('"\\10.151.151.1' *TCAT +
                          &LINK *TCAT '"')
             STRPCO
             MONMSG     MSGID(IWS4010)
             STRPCCMD   PCCMD(&LINK)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(END)

             ENDDO


 END:        ENDPGM
