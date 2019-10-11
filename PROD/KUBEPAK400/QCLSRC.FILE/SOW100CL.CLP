/*********************************************************************/
/*   PROGRAM-------- SOW010CL                                        */
/*   DATE WRITTEN--- 11/30/01                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- SOW LINE OPERATIONS                             */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SOWL &SOWD &JOB#)
             DCL        VAR(&SOWL) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&SOWD) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&JOB#) TYPE(*DEC) LEN(4 0)
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

             CALL       PGM(SOW100) PARM(&SOWL &SOWD &JOB#)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             IF         COND(&PRT = 'P4') THEN(GOTO CMDLBL(P4))
             IF         COND(&PRT = 'L4') THEN(GOTO CMDLBL(L4))
             IF         COND(&PRT = 'L7') THEN(GOTO CMDLBL(L1))

 L1:         TLABARCODE/LBLBATCH   LBLNAM(SOWLBLL1) QTYFLD('      ') +
                          QTYOVR('0001') OUTQ(&PRT) FORM(SOWLABEL) +
                          MRGFILE(&FILE)
             GOTO       CMDLBL(END)

 P4:         TLABARCODE/LBLBATCH   LBLNAM(SOWLBLP4) QTYFLD('      ') +
                          QTYOVR('0001') OUTQ(&PRT) FORM(SOWLABEL) +
                          MRGFILE(&FILE)
             GOTO       CMDLBL(END)
 L4:         TLABARCODE/LBLBATCH   LBLNAM(SOWLBLL4) QTYFLD('      ') +
                          QTYOVR('0001') OUTQ(&PRT) FORM(SOWLABEL) +
                          MRGFILE(&FILE)
             GOTO       CMDLBL(END)

 END:
             RMVLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF2104)

             ENDPGM

