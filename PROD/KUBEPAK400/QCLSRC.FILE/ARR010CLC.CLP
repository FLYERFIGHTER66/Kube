/*********************************************************************/
/*   PROGRAM-------- ARR010CL                                        */
/*   DATE WRITTEN--- 01/19/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- CUSTOMER MASTER MAINTENANCE                     */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CUST#)
             DCL   VAR(&CUST@) TYPE(*CHAR) LEN(6)
             DCL   VAR(&CUST#) TYPE(*DEC) LEN(6 0)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&ALP) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA) VALUE(' ')

             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ARR010')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('     Customer +
                          Master File ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             OVRDBF     FILE(FMCUSTC) TOFILE(FMCUST)
             CHGVAR     VAR(&CUST@) VALUE(&CUST#)
             CHGDTAARA  DTAARA(*LDA (172 6)) VALUE(&CUST@)
             CALL       PGM(ARR010)

             QSYS/RTVDTAARA DTAARA(*LDA (3 1)) RTNVAR(&ALP)
             IF         COND(&ALP = ' ') THEN(GOTO CMDLBL(END))

             CALL       PGM(ARR01A)

END:         ENDPGM
