/*********************************************************************/
/*   PROGRAM-------- APR280CL                                        */
/*   DATE WRITTEN--- 06/03/98                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- CHANGE DUE DATES                                */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('APR275')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('       Change +
                          Due Dates ')

             CALL       PGM(APC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(APR275)
 END:        ENDPGM
