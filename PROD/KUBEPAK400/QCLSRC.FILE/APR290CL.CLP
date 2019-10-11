/*********************************************************************/
/*   PROGRAM-------- APR290CL                                        */
/*   DATE WRITTEN--- 06/04/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- SUMMARY COMPANY BALANCE                         */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('APR290')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('    Summary +
                          Company Balance ')

             CALL       PGM(APC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(APR290)
 END:        ENDPGM
