/*********************************************************************/
/*   PROGRAM-------- SAR210CL                                        */
/*   DATE WRITTEN--- 06/14/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- SALES INQUIRY BY ITEM                           */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('SAR210')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('     Sales +
                          Inquiry By Item ')

             CALL       PGM(SAC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(SAR210)
 END:        ENDPGM
