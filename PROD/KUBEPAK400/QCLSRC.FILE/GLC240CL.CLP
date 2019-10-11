/*********************************************************************/
/*   PROGRAM-------- GLC240CL                                        */
/*   DATE WRITTEN--- 09/12/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- ENTER INTERACTIVE BUDGETS                       */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('GLR240')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('   Interactive +
                          Budget Entry ')

             CALL       PGM(GLC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(GLR240)
 END:        ENDPGM
