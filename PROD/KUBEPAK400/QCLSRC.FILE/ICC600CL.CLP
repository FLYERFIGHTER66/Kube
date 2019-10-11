/*********************************************************************/
/*   PROGRAM-------- ICC600CL                                        */
/*   DATE WRITTEN--- 09/20/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- INVENTORY COUNT SHEETS                          */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&SEQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ICC600')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('    Inventory +
                          Count Sheets    ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(ICC600)
             RTVDTAARA  DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             IF         COND(&JOBQ = 'N') THEN(GOTO CMDLBL(NOJ))
             SBMJOB     CMD(CALL PGM(*LIBL/ICC600CLJQ))
                        GOTO END

 NOJ:        CALL       PGM(ICC600CLJQ)
                        GOTO END
 END:        ENDPGM
