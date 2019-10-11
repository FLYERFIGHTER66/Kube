/*********************************************************************/
/*   PROGRAM-------- SAR800CL                                        */
/*   DATE WRITTEN--- 08/05/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- S/A YEAR END                                    */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (29 8)) VALUE('SAR800')
             CHGDTAARA  DTAARA(*LDA (37 30)) VALUE('   Sales +
                          Analysis Year End ')

             CALL       PGM(SAC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(SAR800)

 END:        ENDPGM
