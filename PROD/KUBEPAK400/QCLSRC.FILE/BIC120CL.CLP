/*********************************************************************/
/*   PROGRAM-------- BIC120CL                                        */
/*   DATE WRITTEN--- 07/27/95                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- COMPANY CONTROL FILES LISTINGS                  */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOB) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA (1 150)) VALUE(' ')
             CALL       PGM(BIC120)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             QSYS/RTVDTAARA DTAARA(*LDA (6 1)) RTNVAR(&JOB)
             IF         COND(&JOB = 'Y') THEN(SBMJOB)
             STRS36PRC  PRC(BIP120) CURLIB(GROWERS)
 END:        ENDPGM
