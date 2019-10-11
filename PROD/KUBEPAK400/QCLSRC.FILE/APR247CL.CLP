/*********************************************************************/
/*   PROGRAM-------- APR245CL                                        */
/*   DATE WRITTEN--- 06/04/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- VENDOR PAYMENT HISTORY INQUIRY                  */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('APR245')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('    Vendor +
                          Payment Inquiry ')

             CALL       PGM(APC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(APR245)
 END:        ENDPGM
