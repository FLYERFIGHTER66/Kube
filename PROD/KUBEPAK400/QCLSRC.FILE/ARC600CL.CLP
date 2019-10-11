/*********************************************************************/
/*   PROGRAM-------- ARC600CL                                        */
/*   DATE WRITTEN--- 07/28/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- START UP INVOICE ENTRY                          */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (29 8)) VALUE('ARC600')
             CHGDTAARA  DTAARA(*LDA (37 30)) VALUE('      A/R Start +
                          Up Entry   ')

             CALL       PGM(ARC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(ARR600)
 END:        ENDPGM
