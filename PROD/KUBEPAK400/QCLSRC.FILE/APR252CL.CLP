/*********************************************************************/
/*   PROGRAM-------- APR252CL                                        */
/*   DATE WRITTEN--- 06/07/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- VOID A BLANK CHECK                              */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('APR252')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('     Void A +
                          Blank Check     ')

             CALL       PGM(APC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(APR252)
 END:        ENDPGM
