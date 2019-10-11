/*********************************************************************/
/*   PROGRAM-------- APC200CL                                        */
/*   DATE WRITTEN--- 08/12/97                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- ENTER VOUCHERS                                  */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')

             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('APC200')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('        Voucher +
                          Entry    ')
             CALL       PGM(APC998)

             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CHGDTAARA  DTAARA(*LDA (134 6)) VALUE('000000')
             CHGDTAARA  DTAARA(*LDA (140 1)) VALUE(' ')

 NXTV:       CALL       PGM(APR200)

             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(APR010)
             GOTO       CMDLBL(NXTV)

 END:        CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             ENDPGM
