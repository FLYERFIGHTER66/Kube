/*********************************************************************/
/*   PROGRAM-------- BIR252CL                                        */
/*   DATE WRITTEN--- 09/08/98                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- UNCONFIRMED ORDERS INQUIRY                      */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('BIR252')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('  Unconfirmed +
                          Orders Inquiry ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(BIR252)
 END:        ENDPGM
