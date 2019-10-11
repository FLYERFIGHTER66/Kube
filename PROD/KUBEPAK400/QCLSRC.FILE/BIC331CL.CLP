/*********************************************************************/
/*   PROGRAM-------- BIC330CL                                        */
/*   DATE WRITTEN--- 08/29/96                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- INVOICE PRINT  - DILLON                         */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOB) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&REP) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             CALL       PGM(BIC330)
             QSYS/RTVDTAARA DTAARA(*LDA (62 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             QSYS/RTVDTAARA DTAARA(*LDA (4 1)) RTNVAR(&JOB)
             IF         COND(&JOB = 'Y') THEN(SBMJOB)

             QSYS/RTVDTAARA DTAARA(*LDA (31 10)) RTNVAR(&PRT)
             QSYS/OVRPRTF FILE(ARR371) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(88 120) LPI(8) CPI(15) +
                          ALIGN(*NO) FORMTYPE(*NAR)
             CALL       PGM(ARR371)

             QSYS/RTVDTAARA DTAARA(*LDA (62 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (31 10)) RTNVAR(&PRT)
             QSYS/OVRPRTF FILE(BIR330A) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(*INV)
             CALL       PGM(BIR330)
 END:        ENDPGM
