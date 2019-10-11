/*********************************************************************/
/*   PROGRAM-------- PSC120CLJQ                                      */
/*   DATE WRITTEN---  2/14/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT UNPRINTED ITEMS             JOBQ          */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

             QSYS/OVRPRTF FILE(NSR120) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 85) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)

             CALL       PGM(NSR120)

 END:        ENDPGM
