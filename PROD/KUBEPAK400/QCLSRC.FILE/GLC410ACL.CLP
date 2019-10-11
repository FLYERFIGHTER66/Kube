/*********************************************************************/
/*   PROGRAM-------- GLC410CL                                        */
/*   DATE WRITTEN--- 03/01/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- DAILY GENERAL JOURNAL                           */
/*   REVISIONS------ AUTO RUN BY NIGHT PROCEDURE                     */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&PRTR) TYPE(*CHAR) LEN(10)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')

             CALL       PGM(GLC410A)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRTR)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

             CHGVAR     VAR(&PRTR) VALUE('P9') /* Always send to +
                          Bill from Night */
             QSYS/CHGDTAARA DTAARA(*LDA (100 10)) VALUE(&PRTR)

             IF         COND(&JOBQ = 'N') THEN(GOTO CMDLBL(NOJ))
             SBMJOB     CMD(CALL PGM(*LIBL/GLC410CLJQ))
                        GOTO END

 NOJ:        CALL       PGM(GLC410CLJQ)
 END:        ENDPGM
