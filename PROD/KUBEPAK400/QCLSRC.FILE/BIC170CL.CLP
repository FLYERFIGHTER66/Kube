/*********************************************************************/
/*   PROGRAM-------- BIC170CL                                        */
/*   DATE WRITTEN--- 08/21/95                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- ORDER PRICE LIST                                */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOB) TYPE(*CHAR) LEN(1)
             OVRDBF     FILE(FMORLC) TOFILE(FMORLS)
             CALL       PGM(BIC170)
             QSYS/RTVDTAARA DTAARA(*LDA (6 1)) RTNVAR(&JOB)
             IF         COND(&JOB = 'Y') THEN(SBMJOB)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             QSYS/OVRPRTF FILE(BIR170) TOFILE(*LIBL/QSYSPRT) +
                          PAGESIZE(66 80) LPI(6) CPI(10) ALIGN(*NO) +
                          FORMTYPE(*NAR)
             CALL       PGM(BIR170)
 END:        ENDPGM
