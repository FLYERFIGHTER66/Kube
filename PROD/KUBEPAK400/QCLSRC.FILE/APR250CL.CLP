/*********************************************************************/
/*   PROGRAM-------- APR250CL                                        */
/*   DATE WRITTEN--- 06/25/97                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- CHECK RECONCILIATION                            */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('APR250')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('     Reconcile +
                          A/P Checks  ')
 AGN:        CALL       PGM(APC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             CALL       PGM(APR250)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'A') THEN(GOTO CMDLBL(AGN))
 END:        ENDPGM
