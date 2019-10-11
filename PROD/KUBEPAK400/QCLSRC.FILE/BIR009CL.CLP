/*********************************************************************/
/*   PROGRAM-------- BIR009CL                                        */
/*   DATE WRITTEN--- 06/13/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- DEPARTMENT MASTER MAINTENANCE                   */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&LST) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')

NXT:         CALL       PGM(BIR009)

             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (1 1)) RTNVAR(&LST)
             IF         COND(&LST = ' ') THEN(GOTO CMDLBL(END))

             CALL       PGM(BIC129CL)

             GOTO       CMDLBL(NXT)
END:         ENDPGM
