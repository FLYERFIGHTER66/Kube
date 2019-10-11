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
             QSYS/DCL   VAR(&LIBR) TYPE(*CHAR) LEN(10)

             ADDLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF2103)


             RTVOBJD    OBJ(FCHMDFT) OBJTYPE(*FILE) RTNLIB(&LIBR)

             CHGDTAARA  DTAARA(*LDA) VALUE(' ')

             CLRPFM     FILE(FCHMLAB)
             MONMSG     MSGID(CPF3142) EXEC(CRTPF +
                          FILE(&LIBR/FCHMLAB) SRCMBR(FCHMLAB))

             CLRPFM     FILE(&LIBR/FCHMOZS1)

             CALL       PGM(CHR050)
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
                          MRGFILE(FCHMLAB)

 END:        CLRPFM     FILE(&LIBR/FCHMOZS)
             CALL CHR052

             CHGDTAARA  DTAARA(*LDA) VALUE(' ')

             RMVLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF2104)

             ENDPGM
