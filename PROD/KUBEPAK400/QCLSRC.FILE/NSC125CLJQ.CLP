/*********************************************************************/
/*   PROGRAM-------- PSC125CLJQ                                      */
/*   DATE WRITTEN---  3/08/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT SET DOWN LIST  UN-PRINTED   JOBQ          */
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

 NXT:        CALL       PGM(NSR125)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)


             QSYS/OVRPRTF FILE(NSR110) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 96) LPI(6) CPI(12) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)

             CALL       PGM(NSR110)
             GOTO       CMDLBL(NXT)

 END:        ENDPGM
