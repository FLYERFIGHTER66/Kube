/*********************************************************************/
/*   PROGRAM-------- BIR050CL                                        */
/*   DATE WRITTEN--- 06/21/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- G/L DEFAULTS MASTER                             */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&LST) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')

 NXT:        CALL       PGM(BIR050)

             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (3 1)) RTNVAR(&LST)
             IF         COND(&LST = ' ') THEN(GOTO CMDLBL(END))

             CALL       PGM(BIC150CL)

             GOTO       CMDLBL(NXT)
END:         ENDPGM
