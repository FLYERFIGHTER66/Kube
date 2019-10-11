/*********************************************************************/
/*   PROGRAM-------- APR240CL                                        */
/*   DATE WRITTEN--- 06/04/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- VENDOR PAYABLES INQUIRY                         */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&VENDOR)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&VENDOR) TYPE(*CHAR) LEN(6)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('APR240')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('   Vendor +
                          Payables Inquiry')

             CALL       PGM(APC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CHGDTAARA  DTAARA(*LDA (172 6)) VALUE(&VENDOR)
             CHGDTAARA  DTAARA(*LDA (178 1)) VALUE('Y')
             CALL       PGM(APR240)
 END:        ENDPGM
