/*********************************************************************/
/*   PROGRAM-------- SOW300CL                                        */
/*   DATE WRITTEN---  2/07/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- CANCEL/RE-ACTIVATE SOW LINE JOBS.               */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&SOWL) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&SOWD) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&JOB#) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (1 600)) VALUE(' ')

             CALL       PGM(SOW300)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

 END:        CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             ENDPGM
