/*********************************************************************/
/*   PROGRAM-------- CHM050CL                                        */
/*   DATE WRITTEN---  7/18/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- GROWTH RETARDANT CONTROL FILE                   */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATALIB) TYPE(*CHAR) LEN(10)


             ADDLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF2103)



             RTVOBJD    OBJ(DATALIB) OBJTYPE(*FILE) RTNLIB(&DATALIB)

             CHGDTAARA  DTAARA(*LDA) VALUE(' ')

             CLRPFM     FILE(FFCMLAB)
             MONMSG     MSGID(CPF3142) EXEC(CRTPF +
                          FILE(&DATALIB/FFCMLAB) SRCMBR(FFCMLAB))

             CLRPFM     FILE(&DATALIB/FFCMOZS1)

             CALL       PGM(FCR050)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

             TLABARCODE/LBLBATCH LBLNAM(CHEMLBL) QTYFLD('      ') +
                          QTYOVR('0001') OUTQ(&PRT) FORM(SOWLABEL) +
                          MRGFILE(FFCMLAB)

 END:        CLRPFM     FILE(&DATALIB/FFCMOZS)
             CALL FCR052

             CHGDTAARA  DTAARA(*LDA) VALUE(' ')

             RMVLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF2104)

             ENDPGM
