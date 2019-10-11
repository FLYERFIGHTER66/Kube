/*********************************************************************/
/*   PROGRAM-------- ARC380CL                                        */
/*   DATE WRITTEN--- 09/02/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- CUSTOMER LABELS                                 */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ARC380')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('        +
                          Customer Labels     ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(ARC380)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             IF         COND(&JOBQ = 'N') THEN(GOTO CMDLBL(NOJ))
             SBMJOB     CMD(CALL PGM(*LIBL/ARC380CLJQ))
                        GOTO END

 NOJ:        CALL       PGM(ARC380CLJQ)

 END:        ENDPGM
