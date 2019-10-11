/*********************************************************************/
/*   PROGRAM-------- BIC310CLJQ                                      */
/*   DATE WRITTEN--- 10/14/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- PICK SLIP PRINTT                                */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT1) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&PRT2) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT1)
             QSYS/RTVDTAARA DTAARA(*LDA (134 10)) RTNVAR(&PRT2)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)
             IF         COND(&PRT1 *LE '          ') THEN(DO)
             RTVSYSVAL  SYSVAL(QPRTDEV) RTNVAR(&PRT2)
             ENDDO

             QSYS/OVRPRTF FILE(BIR310) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT1) PAGESIZE(66 120) LPI(6) CPI(10) +
                          OVRFLW(53) ALIGN(*NO) FORMTYPE(&FORM) +
                          COPIES(&COPY) HOLD(&HOLD) SAVE(&SAVE)

             CALL       PGM(BIR310)

 /* CHECK IF TWO COPIES WANTED  */
             IF         COND(&PRT2 *GT '          ') THEN(DO)
             QSYS/OVRPRTF FILE(BIR310) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT2) PAGESIZE(66 120) LPI(6) CPI(10) +
                          OVRFLW(53) ALIGN(*NO) FORMTYPE(&FORM) +
                          COPIES(&COPY) HOLD(&HOLD) SAVE(&SAVE)
             CALL       PGM(BIR310)
             ENDDO

 END:        ENDPGM
