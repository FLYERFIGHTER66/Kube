/*********************************************************************/
/*   PROGRAM-------- SOW110CL                                        */
/*   DATE WRITTEN--- 12/03/01                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- SOW LINE LABELS SELECTED                        */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RPRT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             ADDLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF2103)


             CALL       PGM(SOW002) /* Get File Name */

             QSYS/RTVDTAARA DTAARA(*LDA (11 10)) RTNVAR(&FILE)
             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)
             QSYS/RTVDTAARA DTAARA(*LDA (134 10)) RTNVAR(&RPRT)

 NXT:        CLRPFM     FILE(&FILE)
             MONMSG     MSGID(CPF3142) EXEC(CRTPF +
                          FILE(TGMSDATA/&FILE) SRCMBR(FSOWLAB) +
                          TEXT('Label Print temp. file') +
                          OPTION(*NOSRC *NOLIST))

             OVRDBF     FILE(FSOWLAB) TOFILE(&FILE)
         CALL       PGM(SOW110)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (134 10)) RTNVAR(&RPRT)
             IF         COND(&RPRT = 'P4') THEN(GOTO CMDLBL(P4))
             IF         COND(&RPRT = 'L7') THEN(GOTO CMDLBL(L1))
/*           IF         COND(&RPRT = 'L4') THEN(GOTO CMDLBL(L4))         */
             IF         COND(&RPRT = 'L2') THEN(GOTO CMDLBL(P4))

 L1:         TLABARCODE/LBLBATCH   LBLNAM(SOWLBLL1) QTYFLD('      ') +
                          QTYOVR('0001') OUTQ(&RPRT) FORM(SOWLABEL) +
                          MRGFILE(&FILE)
             GOTO       CMDLBL(NXT)

 P4:         TLABARCODE/LBLBATCH   LBLNAM(SOWLBLP4) QTYFLD('      ') +
                          QTYOVR('0001') OUTQ(&RPRT) FORM(SOWLABEL) +
                          MRGFILE(&FILE)
             GOTO       CMDLBL(NXT)
/*  ZEBRA LOGIC - NOT USED 12/19/2006  */
 L4:         TLABARCODE/LBLBATCH   LBLNAM(SOWLBLL4) QTYFLD('      ') +
                          QTYOVR('0001') OUTQ(&RPRT) FORM(SOWLABEL) +
                          MRGFILE(&FILE)
             GOTO       CMDLBL(NXT)

 END:        DLTF       FILE(&FILE)

             RMVLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF2104)

             ENDPGM
