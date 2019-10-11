/*********************************************************************/
/*   PROGRAM-------- ARC200CL                                        */
/*   DATE WRITTEN--- 03/21/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- SUMMARY INVOICE ENTRY                           */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (29 8)) VALUE('ARC200')
             CHGDTAARA  DTAARA(*LDA (37 30)) VALUE('      Summary +
                          A/R Entry   ')
             CALL       PGM(ARC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             CALL       PGM(ARR200)
 END:        ENDPGM
