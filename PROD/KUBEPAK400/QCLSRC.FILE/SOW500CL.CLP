/*********************************************************************/
/*   PROGRAM-------- SOW500CL                                        */
/*   DATE WRITTEN---  2/07/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT LABELS FOR OVERRUN JOBS.                  */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FMMENU)
             DCL        VAR(&FMMENU) TYPE(*LGL)
             DCL        VAR(&SOWL) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&SOWD) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&JOB#) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&@SOWL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&@SOWD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&@JOB#) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FORM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COPY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&HOLD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SAVE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
 RESTART:

             CALL       PGM(SOW001) /* GET SOW LINE AND PARMS */
             RTVDTAARA  DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CHGDTAARA  DTAARA(*LDA (156 156)) VALUE(&FMMENU)
             CALL       PGM(SOW500) /* get labels to print */
             CHGDTAARA  DTAARA(*LDA (156 156)) VALUE('0')
             RTVDTAARA  DTAARA(*LDA (133 1)) RTNVAR(&EOJ)

             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             IF         COND(&EOJ = 'P') THEN(DO)
             RTVDTAARA  DTAARA(*LDA (144 1)) RTNVAR(&@SOWL)
             RTVDTAARA  DTAARA(*LDA (145 7)) RTNVAR(&@SOWD)
             RTVDTAARA  DTAARA(*LDA (152 4)) RTNVAR(&@JOB#)
             CHGVAR     VAR(&SOWL) VALUE(&@SOWL)
             CHGVAR     VAR(&SOWD) VALUE(&@SOWD)
             CHGVAR     VAR(&JOB#) VALUE(&@JOB#)
             OVRDBF     FILE(FTRAY) TOFILE(FTRAYR)
             CALL       PGM(SOW100RCL) PARM(&SOWL &SOWD &JOB#)
             DLTOVR     FILE(FTRAY)
             GOTO       CMDLBL(RESTART)
             ENDDO

 END:        CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             ENDPGM
