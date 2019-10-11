/*********************************************************************/
/*   PROGRAM-------- PUC522CLJQ                                      */
/*   DATE WRITTEN---  1/11/02                                        */
/*   PROGRAMMER----- E. DE COURSEY                                   */
/*   DESCRIPTION---- PRINT MASTER S-VIA SCHEDULE       JOBQ          */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT2) TYPE(*CHAR) LEN(10)
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
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(10) /* DATA LIB */

             /* ? WHATEVER LIBRARY THE S-VIA HEADER IS IN IS THE LIBR  */
             RTVOBJD    OBJ(FPUHDRH) OBJTYPE(*FILE) RTNLIB(&LIBR)

             QSYS/RTVDTAARA DTAARA(*LDA (23 10)) RTNVAR(&FILE)
             CHGVAR     VAR(&FILE2) VALUE('TMAN' *CAT %SST(&FILE 5 6))

             CRTPF      FILE(&LIBR/&FILE) SRCMBR(FPUHDRW) +
                          FLAG(20) MBR(RPUHDRW) OPTION(*NOSRC +
                          *NOLIST) SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CRTPF      FILE(&LIBR/&FILE2) SRCMBR(FPUHDRWM) +
                          FLAG(20) MBR(RPUHDRWM) OPTION(*NOSRC +
                          *NOLIST) SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

             CLRPFM     FILE(&FILE)
             OVRDBF     FILE(FPUHDRW) TOFILE(&FILE)
             CALL       PGM(PUR521)
             CPYF       FROMFILE(&FILE) TOFILE(&FILE2) MBROPT(*REPLACE)
             OVRDBF     FILE(FPUHDRWM) TOFILE(&FILE2)

             QSYS/RTVDTAARA DTAARA(*LDA (90 10)) RTNVAR(&PRT2)
             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)
             QSYS/RTVDTAARA DTAARA(*LDA (135 1)) RTNVAR(&TRKMAN)

             IF         COND(&PRT *NE ' ') THEN(GOTO CMDLBL(P7))
             IF         COND(&PRT = 'P9        ') THEN(GOTO CMDLBL(P7))
             IF         COND(&PRT = 'P3        ') THEN(GOTO CMDLBL(P7))
             IF         COND(&PRT = 'P6        ') THEN(GOTO CMDLBL(P7))
             IF         COND(&PRT = 'P7        ') THEN(GOTO CMDLBL(P7))
             IF         COND(&PRT = 'Q7        ') THEN(GOTO CMDLBL(P7))
             IF         COND(&PRT = 'Q5        ') THEN(GOTO CMDLBL(P7))
             IF         COND(&PRT = 'Q4        ') THEN(GOTO CMDLBL(P7))
             IF         COND(&PRT = 'Q3        ') THEN(GOTO CMDLBL(P7))

             QSYS/OVRPRTF FILE(PUR522) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 80) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)
             GOTO       CMDLBL(PRT)

 P7:         QSYS/OVRPRTF FILE(PUR522) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 80) LPI(6) CPI(12) +
                          ALIGN(*NO) FONT(*CPI) FORMTYPE(&FORM) +
                          COPIES(&COPY) HOLD(&HOLD) SAVE(&SAVE)
             GOTO       CMDLBL(PRT)

 PRT:        OVRDBF     FILE(FPUHDRW) TOFILE(&FILE)
             IF         COND(&TRKMAN *EQ 'T') THEN(CALL PGM(PUR522))
             IF         COND(&TRKMAN *EQ 'M') THEN(CALL PGM(PUR527))

/* SEE IF WE NEED TWO RUNS FOR OTHER PRINTER    */
             IF         COND(&PRT2 = '          ') THEN(GOTO +
                          CMDLBL(END))
             IF         COND(&PRT2 *NE '          ') THEN(GOTO +
                          CMDLBL(P72))
             IF         COND(&PRT2 = 'P7        ') THEN(GOTO +
                          CMDLBL(P72))
             IF         COND(&PRT2 = 'Q4        ') THEN(GOTO +
                          CMDLBL(P72))

             QSYS/OVRPRTF FILE(PUR522) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT2) PAGESIZE(66 80) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)
             GOTO       CMDLBL(PRT2)

 P72:        QSYS/OVRPRTF FILE(PUR522) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT2) PAGESIZE(66 80) LPI(6) CPI(12) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)
             GOTO       CMDLBL(PRT2)

 PRT2:       OVRDBF     FILE(FPUHDRW) TOFILE(&FILE)
             IF         COND(&TRKMAN *EQ 'T') THEN(CALL PGM(PUR522))
             IF         COND(&TRKMAN *EQ 'M') THEN(CALL PGM(PUR527))

 END:        DLTF       FILE(&FILE)
             DLTF       FILE(&FILE2)
             ENDPGM
