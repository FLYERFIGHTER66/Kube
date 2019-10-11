/*********************************************************************/
/*   PROGRAM-------- QPK200CL                                        */
/*   DATE WRITTEN--- 12/08/00                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- CUSTOMER OPEN ORDER SPREAD SHEET                */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')

             CALL       PGM(QPC200)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             IF         COND(&JOBQ = 'N') THEN(GOTO CMDLBL(NJQ))

             SBMJOB     CMD(CALL PGM(QPK200CLJQ))
             GOTO       CMDLBL(END)

 NJQ:        CALL PGM(QPK200CLJQ)

 END:        CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             ENDPGM
