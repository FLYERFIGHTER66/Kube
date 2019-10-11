/*********************************************************************/
/*   PROGRAM-------- GLC520CL                                        */
/*   DATE WRITTEN--- 03/19/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- INCOME STATEMENT                                */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRTR) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&OPT) TYPE(*CHAR) LEN(1)
             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('GLC520')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('    G/L Income +
                          Statement ')
             CALL       PGM(GLC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(GLC520)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (25 1)) RTNVAR(&OPT)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             IF         COND(&OPT *GT '5') THEN(GOTO CMDLBL(SPREAD))


             IF         COND(&JOBQ = 'N') THEN(GOTO CMDLBL(NOJ))
             SBMJOB     CMD(CALL PGM(*LIBL/GLR520CL))
                        GOTO END

 NOJ:        CALL       PGM(GLR520CL)
                        GOTO END

 SPREAD:     IF         COND(&JOBQ = 'N') THEN(GOTO CMDLBL(NOJS))
             SBMJOB     CMD(CALL PGM(*LIBL/GLR522CL))
                        GOTO END

 NOJS:       CALL       PGM(GLR522CL)
                        GOTO END
 END:        CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             ENDPGM
