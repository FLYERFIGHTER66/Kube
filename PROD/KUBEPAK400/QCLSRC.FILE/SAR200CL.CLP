/*********************************************************************/
/*   PROGRAM-------- SAR200CL                                        */
/*   DATE WRITTEN--- 06/14/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- SALES INQUIRY BY CUSTOMER                       */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('SAR200')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('   Sales +
                          Inquiry By Customer ')

             CALL       PGM(SAC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(SAR200) PARM('000000')
 END:        ENDPGM
