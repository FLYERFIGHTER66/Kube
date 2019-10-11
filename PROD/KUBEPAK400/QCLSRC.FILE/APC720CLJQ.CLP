/*********************************************************************/
/*   PROGRAM-------- APC720CLJQ                                      */
/*   DATE WRITTEN--- 05/12/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT 1099                                      */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

             QSYS/OVRPRTF FILE(MSC) TOFILE(*LIBL/QSYSPRT) DEV(&PRT) +
                          PAGESIZE(22 120) LPI(6) CPI(10) +
                          ALIGN(*YES) FORMTYPE(&FORM) HOLD(&HOLD) +
                          SAVE(&SAVE)

             QSYS/OVRPRTF FILE(INT) TOFILE(*LIBL/QSYSPRT) DEV(&PRT) +
                          PAGESIZE(22 120) LPI(6) CPI(10) +
                          ALIGN(*YES) FORMTYPE(&FORM) HOLD(&HOLD) +
                          SAVE(&SAVE)

             CALL       PGM(APR720)
END:         ENDPGM
