/*********************************************************************/
/*   PROGRAM-------- GLC020CL                                        */
/*   DATE WRITTEN--- 08/15/99                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- ENTER G/L RECURRING JOURNAL ENTRIES             */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('GLR020')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('  G/L Recurring +
                          Journal Entry ')
             CALL       PGM(GLC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             CALL       PGM(GLR020)
 END:        ENDPGM
