/*********************************************************************/
/*   PROGRAM-------- ARC320CL                                        */
/*   DATE WRITTEN--- 04/01/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- A/R AGING REPORT - CUSTOMER SUMMARY             */
/*   REVISIONS------                                                 */
/*  8/14/01 EFD USE SAME PROMPT FOR DETAIL AND SUMMARY               */
/*********************************************************************/
             PGM
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&DET) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ARC320')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('       Customer +
                          Aging ')

             CALL       PGM(ARC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(ARC320)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

             QSYS/RTVDTAARA DTAARA(*LDA (29 1)) RTNVAR(&DET)
             IF         COND(&DET = 'D') THEN(GOTO CMDLBL(DETL))

         /* SUMMARY REQUESTED  */
 SUMM:       IF         COND(&JOBQ = 'N') THEN(GOTO CMDLBL(NOJ))
             SBMJOB     CMD(CALL PGM(*LIBL/ARC320CLJQ))
                        GOTO END

 NOJ:        CALL       PGM(ARC320CLJQ)
                        GOTO END

         /* DETAIL REQUESTED  */
 DETL:       IF         COND(&JOBQ = 'N') THEN(GOTO CMDLBL(NOJD))
             SBMJOB     CMD(CALL PGM(*LIBL/ARC310CLJQ))
                        GOTO END

 NOJD:       CALL       PGM(ARC310CLJQ)
                        GOTO END

 END:        CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             ENDPGM
