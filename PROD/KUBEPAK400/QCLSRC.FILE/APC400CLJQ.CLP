/*********************************************************************/
/*   PROGRAM-------- APC400CLJQ                                      */
/*   DATE WRITTEN--- 05/21/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- A/P PAYMENT APPROVAL LIST                       */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&SEQ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FORM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)

             QSYS/RTVDTAARA DTAARA(*LDA (9 1)) RTNVAR(&SEQ)
             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

             OVRPRTF    FILE(APR400) TOFILE(QSYSPRT) DEV(&PRT) +
                          PAGESIZE(66 120) LPI(6) CPI(15) +
                          FORMTYPE(&FORM) COPIES(&COPY) HOLD(&HOLD) +
                          SAVE(&SAVE)

             IF         COND(&SEQ = '1') THEN(DO)
             OVRDBF     FILE(FAPOPN) TOFILE(FAPOPNAL)
             ENDDO

             CALL       PGM(APR400)
                        GOTO END

 END:        ENDPGM
