/*********************************************************************/
/*   PROGRAM-------- BIC420CL                                        */
/*   DATE WRITTEN--- 09/27/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT ORDER ACKNOWLEDGEMENTS                    */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&RPT) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&SEQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (16 12)) VALUE('000000000000')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('BIC420')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('   Order +
                          Acknowledgements  ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CHGDTAARA  DTAARA(*LDA (180 18)) VALUE('000000000000000000')
 NXT:        CALL       PGM(BIC420)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)
             QSYS/RTVDTAARA DTAARA(*LDA (3 1)) RTNVAR(&SEQ)

 NO_SUBMIT:  GOTO       CMDLBL(NOJ) /* output generated as PDF DO +
                          NOT submit. */

             IF         COND(&JOBQ = 'N') THEN(GOTO CMDLBL(NOJ))
             SBMJOB     CMD(CALL PGM(*LIBL/BIC420CLJQ))
                        GOTO NXT

 NOJ:
             CALL       PGM(BIC420CLJQ)
             GOTO       CMDLBL(NXT)
 END:        ENDPGM
