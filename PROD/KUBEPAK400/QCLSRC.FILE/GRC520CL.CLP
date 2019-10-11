/*********************************************************************/
/*   PROGRAM-------- GRC520CL                                        */
/*   DATE WRITTEN--- 05/23/96                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- LOT TRANSACTION REPORT                          */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOB) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(8)
             CHGDTAARA  DTAARA(*LDA (1 150)) VALUE(' ')
             CALL       PGM(GRC520)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             QSYS/RTVDTAARA DTAARA(*LDA (6 1)) RTNVAR(&JOB)
             IF         COND(&JOB = 'Y') THEN(SBMJOB)
             QSYS/RTVDTAARA DTAARA(*LDA (61 1)) RTNVAR(&PRT)
             QSYS/OVRPRTF FILE(GRS520) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 132) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(*NAR)
             CALL       PGM(GRS520)
 END:        ENDPGM
