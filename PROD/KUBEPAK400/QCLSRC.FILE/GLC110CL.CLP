/*********************************************************************/
/*   PROGRAM-------- GLC110CL                                        */
/*   DATE WRITTEN--- 06/28/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- CHART OF ACCOUNTS MASTER LIST                   */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM

             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&TYPE) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&PRTR) TYPE(*CHAR) LEN(10)

             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('GLC110')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('  Chart Of +
                          Accounts Listing  ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(GLC110)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (3 1)) RTNVAR(&TYPE)
             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRTR)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

             IF         COND(&TYPE = '2') THEN(GOTO CMDLBL(TYPE))

             IF         COND(&JOBQ = 'N') THEN(GOTO CMDLBL(NOJ))

             SBMJOB     CMD(CALL PGM(*LIBL/GLC110CLJQ))
                        GOTO END
 NOJ:        CALL       PGM(GLC110CLJQ)
                        GOTO END

 TYPE:       IF         COND(&JOBQ = 'N') THEN(GOTO CMDLBL(NO1))
             SBMJOB     CMD(CALL PGM(*LIBL/GLC120CLJQ))
                        GOTO END
 NO1:        CALL       PGM(GLC120CLJQ)
                        GOTO END
 END:        ENDPGM
