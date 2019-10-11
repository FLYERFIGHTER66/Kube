/*********************************************************************/
/*   PROGRAM-------- ICC325CL                                        */
/*   DATE WRITTEN--- 08/30/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- INVENTORY STOCK STATUS REPORT BY PRODUCT CLASS  */
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
             QSYS/DCL   VAR(&HLLIST) TYPE(*CHAR) LEN(6)
             QSYS/DCL   VAR(&HLDESC) TYPE(*CHAR) LEN(30)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ICC325')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE(' Inventory +
                          Stock Status Report')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(ICC310)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(LKORLS) PARM(&HLLIST &HLDESC)
             CHGDTAARA  DTAARA(*LDA (172 6)) VALUE(&HLLIST)

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

             IF         COND(&JOBQ = 'N') THEN(GOTO CMDLBL(NOJ))
             SBMJOB     CMD(CALL PGM(*LIBL/ICC327CLJQ))
                        GOTO END

 NOJ:        CALL       PGM(ICC327CLJQ)
                        GOTO END
 END:        ENDPGM
