/*********************************************************************/
/*   PROGRAM-------- SAR250CL                                        */
/*   DATE WRITTEN--- 11/26/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- SALES INQUIRY BY LIST CODE                      */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('SAR250')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('      Sales By +
                          List Code ')

             CALL       PGM(SAC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(SAR250)
 END:        ENDPGM
