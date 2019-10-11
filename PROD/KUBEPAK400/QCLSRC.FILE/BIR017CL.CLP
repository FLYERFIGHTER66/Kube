/*********************************************************************/
/*   PROGRAM-------- BIR017CL                                        */
/*   DATE WRITTEN--- 06/22/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- FREIGHT CODE MAINTENANCE                        */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&LST) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA) VALUE(' ')

             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('BIR017')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('   Freight Code +
                          Maintenance ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

NXT:         CALL       PGM(BIR017)

             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (3 1)) RTNVAR(&LST)
             IF         COND(&LST = ' ') THEN(GOTO CMDLBL(END))

             CALL       PGM(BIC117CL)

             GOTO       CMDLBL(NXT)
END:         ENDPGM
