/*********************************************************************/
/*   PROGRAM-------- GLC365CL                                        */
/*   DATE WRITTEN--- 05/25/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- REVERSING JOURNAL ENTRY POST                    */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('GLC365')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE(' Reversing +
                          Journal Entry Post ')

             CALL       PGM(GLC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(GLR365)
 END:        ENDPGM
