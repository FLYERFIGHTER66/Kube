/*********************************************************************/
/*   PROGRAM-------- BIC392CL                                        */
/*   DATE WRITTEN--- 02/17/97                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- SUMMARY ORDERS BY SHIP TO                       */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             CALL       PGM(BIC392)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             QSYS/RTVDTAARA DTAARA(*LDA (6 10)) RTNVAR(&PRT)
             QSYS/OVRPRTF FILE(BIR392) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 132) LPI(6) CPI(15) +
                          FORMTYPE(*NAR)
             CALL       PGM(BIR392)
 END:        ENDPGM
