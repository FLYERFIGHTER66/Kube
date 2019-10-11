/*********************************************************************/
/*   PROGRAM-------- GLC260CL                                        */
/*   DATE WRITTEN--- 03/03/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- ENTER G/L BALANCES - START UP                   */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('GLR260')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('       G/L Start +
                          Up          ')

             CALL       PGM(GLC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(GLR260)
 END:        ENDPGM
