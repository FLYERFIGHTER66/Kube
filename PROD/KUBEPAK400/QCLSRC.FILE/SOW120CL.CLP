/*********************************************************************/
/*   PROGRAM-------- SOW120CL                                        */
/*   DATE WRITTEN--- 12/07/01                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- SOW LINE OPERATIONS REPRINT AFTER CANCEL        */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&BEG &END)
             DCL        VAR(&BEG) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&END) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             ADDLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF2103)


             QSYS/RTVDTAARA DTAARA(*LDA (11 10)) RTNVAR(&FILE)
             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

             CLRPFM     FILE(&FILE)
             MONMSG     MSGID(CPF3142) EXEC(CRTPF +
                          FILE(TGMSDATA/&FILE) SRCMBR(FSOWLAB))

             OVRDBF     FILE(FSOWLAB) TOFILE(&FILE)

             CALL       PGM(SOW120) PARM(&BEG &END)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             TLABARCODE/LBLBATCH   LBLNAM(SOWLBLL1) QTYFLD('      ') +
                          QTYOVR('0001') OUTQ(&PRT) FORM(SOWLABEL) +
                          MRGFILE(&FILE)

             RMVLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF2104)

 END:        ENDPGM
