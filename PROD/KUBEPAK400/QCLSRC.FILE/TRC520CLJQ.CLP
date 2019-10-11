/*********************************************************************/
/*   PROGRAM-------- TRC520CLJQ                                      */
/*   DATE WRITTEN---  1/11/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT MASTER TRUCK SCHEDULE       JOBQ          */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT3) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT4) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT5) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT_COUNT) TYPE(*DEC) LEN(1 0)
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&TRKMAN) TYPE(*CHAR) LEN(1) /* Truck +
                          Schedule or Trailer Manifest */
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(10)

             QSYS/RTVDTAARA DTAARA(*LDA (23 10)) RTNVAR(&FILE)
             CHGVAR     VAR(&FILE2) VALUE('TMAN' *CAT %SST(&FILE 5 6))

             RTVOBJD    OBJ(FTRHDRW) OBJTYPE(*FILE) RTNLIB(&LIBR)

             CRTPF      FILE(&LIBR/&FILE) SRCMBR(FTRHDRW) +
                          FLAG(20) MBR(RTRHDRW) OPTION(*NOSRC +
                          *NOLIST) SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CRTPF      FILE(&LIBR/&FILE2) SRCMBR(FTRHDRWM) +
                          FLAG(20) MBR(RTRHDRWM) OPTION(*NOSRC +
                          *NOLIST) SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

             CLRPFM     FILE(&FILE)
             OVRDBF     FILE(FTRHDRW) TOFILE(&FILE)
             CALL       PGM(TRR521)
             CPYF       FROMFILE(&FILE) TOFILE(&FILE2) MBROPT(*REPLACE)
             OVRDBF     FILE(FTRHDRWM) TOFILE(&FILE2)

             QSYS/RTVDTAARA DTAARA(*LDA (140 10)) RTNVAR(&PRT1)
             QSYS/RTVDTAARA DTAARA(*LDA (150 10)) RTNVAR(&PRT2)
             QSYS/RTVDTAARA DTAARA(*LDA (160 10)) RTNVAR(&PRT3)
             QSYS/RTVDTAARA DTAARA(*LDA (170 10)) RTNVAR(&PRT4)
             QSYS/RTVDTAARA DTAARA(*LDA (180 10)) RTNVAR(&PRT5)

             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)
             QSYS/RTVDTAARA DTAARA(*LDA (135 1)) RTNVAR(&TRKMAN)

 NEXT_PRT:   CHGVAR     VAR(&PRT_COUNT) VALUE(&PRT_COUNT + 1)
             IF         COND(&PRT_COUNT > 5) THEN(GOTO CMDLBL(END))

             IF         COND(&PRT_COUNT = 1) THEN(CHGVAR VAR(&PRT) VALUE(&PRT1))
             IF         COND(&PRT_COUNT = 2) THEN(CHGVAR VAR(&PRT) VALUE(&PRT2))
             IF         COND(&PRT_COUNT = 3) THEN(CHGVAR VAR(&PRT) VALUE(&PRT3))
             IF         COND(&PRT_COUNT = 4) THEN(CHGVAR VAR(&PRT) VALUE(&PRT4))
             IF         COND(&PRT_COUNT = 5) THEN(CHGVAR VAR(&PRT) VALUE(&PRT5))
             IF         COND(&PRT *EQ ' ')   THEN(GOTO CMDLBL(NEXT_PRT))

             QSYS/OVRPRTF FILE(TRR520) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 80) LPI(6) CPI(12) +
                          ALIGN(*NO) FONT(*CPI) FORMTYPE(&FORM) +
                          COPIES(&COPY) HOLD(&HOLD) SAVE(&SAVE)
             MONMSG     MSGID(CPF0001) EXEC(GOTO CMDLBL(NEXT_PRT))

 PRT:        OVRDBF     FILE(FTRHDRW) TOFILE(&FILE)
             IF         COND(&TRKMAN *EQ 'T') THEN(CALL PGM(TRR520))
             IF         COND(&TRKMAN *EQ 'M') THEN(CALL PGM(TRR525))

             GOTO       CMDLBL(NEXT_PRT)

 END:        DLTF       FILE(&FILE)
             DLTF       FILE(&FILE2)
             ENDPGM
