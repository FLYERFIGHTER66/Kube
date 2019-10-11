/*   PROGRAM-------- APR01QCL                                        */
/*   DATE WRITTEN---  4/26/99                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- VENDOR MASTER FILE INQUIRY                      */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&LCO) TYPE(*CHAR) LEN(2)
             DCL        VAR(&VEND) TYPE(*DEC) LEN(6 0) VALUE(000000)
/*           DCL        VAR(&COMP) TYPE(*DEC) LEN(2 0) VALUE(00)     */

             CHGDTAARA  DTAARA(*LDA) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('APR010')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('   Vendor +
                          Master Inquiry ')

             CALL       PGM(APC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             QSYS/RTVDTAARA DTAARA(*LDA (1 2)) RTNVAR(&LCO)

             CALL       PGM(APR01Q) PARM(&LCO &VEND)

END:         ENDPGM
