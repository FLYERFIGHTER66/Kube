/*********************************************************************/
/*   PROGRAM-------- APR254CL                                        */
/*   DATE WRITTEN--- 06/07/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- VOID A PROCESSED CHECK                          */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('APR254')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('   Void A +
                          Processed Check   ')

             CALL       PGM(APC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(APR254)
 END:        ENDPGM
