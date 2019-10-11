/*********************************************************************/
/*   PROGRAM-------- SAC410CL                                        */
/*   DATE WRITTEN--- 07/01/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- S/A BY PRODUCT CLASS SUMMARY                    */
/*  11/08/01 EFD MAKE AUTO RUN AT NIGHT                              */
/*********************************************************************/
             PGM

             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&BOT) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')

             CALL       PGM(SAC410A)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)
             QSYS/RTVDTAARA DTAARA(*LDA (5 1)) RTNVAR(&BOT)

             IF         COND(&JOBQ = 'N') THEN(GOTO CMDLBL(NOJ))
             CHGDTAARA  DTAARA(*LDA (5 1)) VALUE('1')
             SBMJOB     CMD(CALL PGM(*LIBL/SAC410CLJQ))
             CHGDTAARA  DTAARA(*LDA (5 1)) VALUE('2')
             SBMJOB     CMD(CALL PGM(*LIBL/SAC410CLJQ))
                        GOTO END

 NOJ:
             CHGDTAARA  DTAARA(*LDA (5 1)) VALUE('1')
             CALL       PGM(*LIBL/SAC410CLJQ)
             CHGDTAARA  DTAARA(*LDA (5 1)) VALUE('2')
             CALL       PGM(*LIBL/SAC410CLJQ)
             GOTO       END

 END:        ENDPGM
