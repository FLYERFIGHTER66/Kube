/*********************************************************************/
/*   PROGRAM-------- BIC420CLJQ                                      */
/*   DATE WRITTEN--- 09/27/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT ORDER ACKNOWLEDGEMENTS                    */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&SEQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SAVE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&LINK) TYPE(*CHAR) LEN(75) VALUE('/kube +
                          pak/PDF/ACKNOWLEDGEMENTS/ACK_BATCH_')
             DCL        VAR(&TIMESTAMP) TYPE(*CHAR) LEN(20)
             DCL        VAR(&LPLUG) TYPE(*CHAR) LEN(1)

             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&TIMESTAMP)
             CHGVAR     VAR(&LINK) VALUE(&LINK *TCAT &TIMESTAMP +
                          *TCAT '.pdf')

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)
             QSYS/RTVDTAARA DTAARA(*LDA (172 1)) RTNVAR(&LPLUG)
             IF         COND(&PRT *EQ '*PDF') THEN(DO)
             IF         COND(&LPLUG *EQ 'P') THEN(OVRPRTF +
                          FILE(BIR421) TOFILE(*LIBL/QSYSPRT) +
                          DEVTYPE(*AFPDS) PAGESIZE(66 80) LPI(6) +
                          CPI(10) ALIGN(*NO) PAGRTT(0) +
                          FRONTOVL(ACK_PLUG .12 .1) FORMTYPE(&FORM) +
                          COPIES(&COPY) HOLD(&HOLD) SAVE(&SAVE) +
                          TOSTMF(&LINK) WSCST(*PDF))
             IF         COND(&LPLUG *EQ 'F') THEN(OVRPRTF +
                          FILE(BIR421) TOFILE(*LIBL/QSYSPRT) +
                          DEVTYPE(*AFPDS) PAGESIZE(66 80) LPI(6) +
                          CPI(10) ALIGN(*NO) PAGRTT(0) +
                          FRONTOVL(ACK_FIN .12 .1) FORMTYPE(&FORM) +
                          COPIES(&COPY) HOLD(&HOLD) SAVE(&SAVE) +
                          TOSTMF(&LINK) WSCST(*PDF))
             CALL       PGM(BIR421O) PARM(&LPLUG)
             STRPCO
             MONMSG     MSGID(IWS4010)
             STRPCCMD   PCCMD('"//10.151.151.1' *TCAT &LINK *TCAT +
                          '"') PAUSE(*NO)
             ENDDO
             IF         COND(&PRT *NE '*PDF') THEN(DO)
             OVRPRTF    FILE(BIR421) TOFILE(QSYSPRT) DEV(&PRT) +
                          DEVTYPE(*SCS) PAGESIZE(66 80) LPI(6) +
                          CPI(10) ALIGN(*NO) PAGRTT(0) OUTQ(&PRT) +
                          FORMTYPE(&FORM) COPIES(&COPY) HOLD(&HOLD) +
                          SAVE(&SAVE)
             CALL       PGM(BIR421)
             ENDDO

             DLTOVR     FILE(BIR421)

 END:        ENDPGM
