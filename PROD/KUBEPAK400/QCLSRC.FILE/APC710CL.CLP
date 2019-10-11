/*********************************************************************/
/*   PROGRAM NAME...  APC710                                         */
/*   DATE...........  02/05/99                                       */
/*   PROGRAMMER.....  GD                                             */
/*   DESCRIPTION....  A/P FISCAL YEAR END CLOSING ROUTINE            */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SAVE) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('APC710')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('     A/P Fiscal +
                          Year End')

             CALL       PGM(APC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(APC710)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             RTVDTAARA  DTAARA(*LDA (3 1)) RTNVAR(&SAVE) /* SAVE Y/N */
             IF         COND((&SAVE) = 'N') THEN(GOTO CMDLBL(NOSAVE))
             CALL       PGM(APSAVE)

 NOSAVE:     CALL       PGM(APR710)
 END:        ENDPGM
