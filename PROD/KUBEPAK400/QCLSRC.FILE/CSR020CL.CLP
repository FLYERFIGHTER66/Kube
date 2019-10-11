/*********************************************************************/
/*   PROGRAM-------- CSR020CL                                        */
/*   DATE WRITTEN--- 12/29/00                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- ASSIGN CUSTOMER OPTIONS                         */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CUST)
             QSYS/DCL   VAR(&CUST) TYPE(*CHAR) LEN(6)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (1 6)) VALUE('000000')

             CHGVAR     VAR(&CUST) VALUE('000000')

             CALL       PGM(CSR020) PARM(&CUST)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
 END:        ENDPGM
