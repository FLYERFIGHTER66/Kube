/*********************************************************************/
/*   PROGRAM-------- BIR245CL                                        */
/*   DATE WRITTEN--- 09/08/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- OPEN ORDERS BY CUSTOMER                         */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CUST#)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CUST#) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&CUST@) TYPE(*CHAR) LEN(6)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('BIR245')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('    Customer +
                          Order Inquiry ')

             CHGVAR     VAR(&CUST@) VALUE(&CUST#)
             CHGDTAARA  DTAARA(*LDA (200 6)) VALUE(&CUST@)

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)

             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(BIR245)
 END:        ENDPGM
