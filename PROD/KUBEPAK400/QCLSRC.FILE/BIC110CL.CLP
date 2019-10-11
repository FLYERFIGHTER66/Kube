/*********************************************************************/
/*   PROGRAM-------- BIC110CL                                        */
/*   DATE WRITTEN--- 08/24/95                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- CONTRACT FILE LISTING                           */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOB) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA (1 150)) VALUE(' ')
             CALL       PGM(BIC110)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             QSYS/RTVDTAARA DTAARA(*LDA (6 1)) RTNVAR(&JOB)
             IF         COND(&JOB = 'Y') THEN(SBMJOB)
             QSYS/OVRPRTF FILE(BIR110) TOFILE(*LIBL/QSYSPRT) +
                          PAGESIZE(66 132) LPI(6) CPI(15) +
                          FORMTYPE(*NAR)
             CALL       PGM(BIR110)
 END:        ENDPGM
