/*********************************************************************/
/*   PROGRAM-------- SAR220CL                                        */
/*   DATE WRITTEN--- 06/14/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- SALES INQUIRY BY SALESPERSON                    */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('SAR220')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE(' Sales Inquiry +
                          By Salesperson')

             CALL       PGM(SAC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(SAR220)
 END:        ENDPGM
