/*********************************************************************/
/*   PROGRAM-------- GLC210CL                                        */
/*   DATE WRITTEN--- 05/15/99                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- ENTER RECURRING G/L JOURNAL ENTRIES             */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('GLR210')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('   Recurring +
                          Journal Entry   ')
             CALL       PGM(GLC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             CALL       PGM(GLR210)
 END:        ENDPGM
