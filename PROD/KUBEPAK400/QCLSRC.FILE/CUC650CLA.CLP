/*********************************************************************/
/*   PROGRAM-------- CUC650CLA                                       */
/*   DATE WRITTEN--- 11/15/01                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- 84 TRAY ORDER CHANGE REPORT (AUTO RUN)          */
/*   DESCRIPTION---- 105 TRAY ORDER CHANGE REPORT (AUTO RUN)          */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCLF       FILE(FCUTVEND)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             DCL   VAR(&@LCO   ) TYPE(*CHAR) LEN(2)
             DCL   VAR(&@BEGDAT) TYPE(*CHAR) LEN(6)
             DCL   VAR(&@ENDDAT) TYPE(*CHAR) LEN(6)
             DCL   VAR(&@BEGCYM) TYPE(*CHAR) LEN(7)
             DCL   VAR(&@ENDCYM) TYPE(*CHAR) LEN(7)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')


             CALL       PGM(CUC650A)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)
             QSYS/RTVDTAARA DTAARA(*LDA (001 2)) RTNVAR(&@LCO)
             QSYS/RTVDTAARA DTAARA(*LDA (003 6)) RTNVAR(&@BEGDAT)
             QSYS/RTVDTAARA DTAARA(*LDA (009 6)) RTNVAR(&@ENDDAT)
             QSYS/RTVDTAARA DTAARA(*LDA (015 7)) RTNVAR(&@BEGCYM)
             QSYS/RTVDTAARA DTAARA(*LDA (022 7)) RTNVAR(&@ENDCYM)
             IF         COND(&@LCO *EQ '  ') THEN(CHGVAR VAR(&@LCO) +
                          VALUE('01'))

 LOOP01:     RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDLOOP01))

             CHGDTAARA  DTAARA(*LDA (100 10)) VALUE(&PRT)
             CHGDTAARA  DTAARA(*LDA (110 10)) VALUE(&FORM)
             CHGDTAARA  DTAARA(*LDA (120 2)) VALUE(&COPY)
             CHGDTAARA  DTAARA(*LDA (122 1)) VALUE(&JOBQ)
             CHGDTAARA  DTAARA(*LDA (123 4)) VALUE(&HOLD)
             CHGDTAARA  DTAARA(*LDA (127 4)) VALUE(&SAVE)
             CHGDTAARA  DTAARA(*LDA (001 2)) VALUE(&@LCO)
             CHGDTAARA  DTAARA(*LDA (003 6)) VALUE(&@BEGDAT)
             CHGDTAARA  DTAARA(*LDA (009 6)) VALUE(&@ENDDAT)
             CHGDTAARA  DTAARA(*LDA (015 7)) VALUE(&@BEGCYM)
             CHGDTAARA  DTAARA(*LDA (022 7)) VALUE(&@ENDCYM)

             CALL       PGM(CUC650CLJQ) PARM(&CVVEND)
             GOTO       CMDLBL(LOOP01)
 ENDLOOP01:
                        GOTO END

 END:        CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             ENDPGM
