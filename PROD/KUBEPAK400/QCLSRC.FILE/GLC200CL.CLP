/*********************************************************************/
/*   PROGRAM-------- GLC200CL                                        */
/*   DATE WRITTEN--- 05/10/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- ENTER G/L JOURNAL ENTRIES                       */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('GLR200')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('      G/L +
                          Journal Entry     ')
             CALL       PGM(GLC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             CALL       PGM(GLR200)
 END:        ENDPGM
