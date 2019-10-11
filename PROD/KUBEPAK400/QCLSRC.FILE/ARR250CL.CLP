/*********************************************************************/
/*   PROGRAM-------- ARR250CL                                        */
/*   DATE WRITTEN--- 11/07/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- DISPLAY CUSTOMER AGING                          */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ARC250')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('   Display +
                          Customer Aging  ')

             CALL       PGM(ARC998)

             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(ARR250)
 END:        ENDPGM
