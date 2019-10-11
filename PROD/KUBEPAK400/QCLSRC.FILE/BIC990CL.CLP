/*********************************************************************/
/*   PROGRAM-------- BIC990CL                                        */
/*   DATE WRITTEN--- 01/04/98                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- DISTRIBUTION MONTH END PROCEDURE                */
/*   REVISIONS------                                                 */
/*  3/12/01 EFD ALLOW FOR NO PURGE OF INVOICE PRINT FILES  EFD01     */
/*********************************************************************/
             PGM
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SAVE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PUR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BU) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&PER) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&COMP) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&FILT) TYPE(*CHAR) LEN(9)  /* NEW MTRAN */
             DCL        VAR(&FILS) TYPE(*CHAR) LEN(9)  /* NEW MSALE */
             DCL        VAR(&FILV) TYPE(*CHAR) LEN(9)  /* NEW TINVT */
             DCL        VAR(&FILX) TYPE(*CHAR) LEN(9)  /* NEW TAXDS */
             DCL        VAR(&FILRH) TYPE(*CHAR) LEN(9) /* NEW HORDR */
             DCL        VAR(&FILRI) TYPE(*CHAR) LEN(9) /* NEW IORDR */
             DCL        VAR(&FILWH) TYPE(*CHAR) LEN(9) /* NEW HORDW */
             DCL        VAR(&FILWI) TYPE(*CHAR) LEN(9) /* NEW IORDW */
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(10) /* LIBR NAME */
             DCL        VAR(&RPUR) TYPE(*CHAR) LEN(7) /* HORDR DATE */
             DCL        VAR(&WPUR) TYPE(*CHAR) LEN(7) /* HORDW DATE */

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('BIC990')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('    +
                          Distribution Month End  ')

             CALL       PGM(DEF998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(BIC990)
             RTVDTAARA  DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

 /*   GET STATUS UPDATE INFO   */
             RTVDTAARA  DTAARA(*LDA (1 2)) RTNVAR(&COMP)
             RTVDTAARA  DTAARA(*LDA (3 2)) RTNVAR(&PER)

 /*   CHECK FOR HORDR/W PURGE  */
             RTVDTAARA  DTAARA(*LDA (181 7)) RTNVAR(&WPUR)
             RTVDTAARA  DTAARA(*LDA (188 7)) RTNVAR(&RPUR)

 /*   BUILD LAST MONTH FILES   */
             RTVDTAARA  DTAARA(*LDA (19 9)) RTNVAR(&FILT)
             RTVDTAARA  DTAARA(*LDA (28 9)) RTNVAR(&FILS)
             RTVDTAARA  DTAARA(*LDA (37 9)) RTNVAR(&FILWH)
             RTVDTAARA  DTAARA(*LDA (46 9)) RTNVAR(&FILWI)
             RTVDTAARA  DTAARA(*LDA (55 9)) RTNVAR(&FILV)
             RTVDTAARA  DTAARA(*LDA (64 10)) RTNVAR(&LIBR)
             RTVDTAARA  DTAARA(*LDA (75 9)) RTNVAR(&FILX)
             RTVDTAARA  DTAARA(*LDA (75 9)) RTNVAR(&FILX)
             RTVDTAARA  DTAARA(*LDA (85 9)) RTNVAR(&FILRH)
             RTVDTAARA  DTAARA(*LDA (172 9)) RTNVAR(&FILRI)

 /* CREATE BACKUP LIBRARY */
             CRTLIB     LIB(&LIBR) TEXT('Last Month Data Files')
             MONMSG     MSGID(CPF2111) /* Library Exists */

             CRTPF      FILE(&LIBR/&FILT) SRCMBR(FMTRAN) FLAG(20) +
                          MBR(RMTRAN) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CRTPF      FILE(&LIBR/&FILS) SRCMBR(FMSALE) FLAG(20) +
                          MBR(RMSALE) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CRTPF      FILE(&LIBR/&FILV) SRCMBR(FTINVT) FLAG(20) +
                          MBR(RTINVT) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CRTPF      FILE(&LIBR/&FILX) SRCMBR(FTAXDS) FLAG(20) +
                          MBR(RTAXDS) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

             IF         COND(&WPUR = '0000000') THEN(GOTO CMDLBL(NOW))
             CRTPF      FILE(&LIBR/&FILWH) SRCMBR(FHORDW) FLAG(20) +
                          MBR(RHORDW) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CRTPF      FILE(&LIBR/&FILWI) SRCMBR(FIORDW) FLAG(20) +
                          MBR(RIORDW) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

 NOW:        IF         COND(&RPUR = '0000000') THEN(GOTO CMDLBL(NOR))
             CRTPF      FILE(&LIBR/&FILRH) SRCMBR(FHORDR) FLAG(20) +
                          MBR(RHORDR) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CRTPF      FILE(&LIBR/&FILRI) SRCMBR(FIORDR) FLAG(20) +
                          MBR(RIORDR) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

 /* SAVE LIBRARY FIRST? */
 NOR:        RTVDTAARA  DTAARA(*LDA (84 1)) RTNVAR(&BU)
             IF         COND(&BU = 'N') THEN(GOTO CMDLBL(NOSAV))
             CALL       PGM(TSAVE)

 NOSAV:      QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (122 1)) RTNVAR(&JOBQ)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)

             QSYS/OVRPRTF FILE(BIR990) TOFILE(*LIBL/QSYSPRT) +
                          DEV(&PRT) PAGESIZE(66 120) LPI(6) CPI(15) +
                          ALIGN(*NO) FORMTYPE(&FORM) COPIES(&COPY) +
                          HOLD(&HOLD) SAVE(&SAVE)

             OVRDBF     FILE(FMSALEO) TOFILE(&LIBR/&FILS)
             OVRDBF     FILE(FMTRANO) TOFILE(&LIBR/&FILT)
             OVRDBF     FILE(FMTAXDO) TOFILE(&LIBR/&FILX)
             CALL       PGM(BIR990)
             CALL       PGM(ICR700)

             OVRPRTF    FILE(ICR710) TOFILE(QSYSPRT) PAGESIZE(66 +
                          132) LPI(6) CPI(15) FORMTYPE(*NAR)
             OVRDBF     FILE(FTINVTO) TOFILE(&LIBR/&FILV)
             CALL       PGM(ICR710)

/* PURGE INVOICE FILE  */
             IF         COND(&WPUR = '0000000') THEN(GOTO +
                          CMDLBL(NOINV)) /* EFD01 */

             OVRDBF     FILE(FHORDWO) TOFILE(&LIBR/&FILWH)
             OVRDBF     FILE(FIORDWO) TOFILE(&LIBR/&FILWI)
             CALL       PGM(PRGORDRW)


/* PURGE INVOICE FILE  */
 NOINV:      IF         COND(&RPUR = '0000000') THEN(GOTO +
                          CMDLBL(NOORD)) /* EFD01 */

             OVRDBF     FILE(FHORDRO) TOFILE(&LIBR/&FILRH)
             OVRDBF     FILE(FIORDRO) TOFILE(&LIBR/&FILRI)
             CALL       PGM(PRGORDRR)

 NOORD:      RTVDTAARA  DTAARA(*LDA (31 1)) RTNVAR(&PUR)
             IF         COND(&PUR = 'N') THEN(GOTO CMDLBL(END))
             RGZPFM     FILE(FMSALE)
             MONMSG     MSGID(CPF2981) /* File Empty */
             RGZPFM     FILE(FMTRAN)
             MONMSG     MSGID(CPF2981) /* File Empty */
             RGZPFM     FILE(FTINVT)
             MONMSG     MSGID(CPF2981) /* File Empty */
             RGZPFM     FILE(FTAXDS)
             MONMSG     MSGID(CPF2981) /* File Empty */
             RGZPFM     FILE(FHORDW)
             MONMSG     MSGID(CPF2981) /* File Empty */
             RGZPFM     FILE(FIORDW)
             MONMSG     MSGID(CPF2981) /* File Empty */
             RGZPFM     FILE(FIOWAST)
             MONMSG     MSGID(CPF2981) /* File Empty */
             RGZPFM     FILE(FHORDR)
             MONMSG     MSGID(CPF2981) /* File Empty */
             RGZPFM     FILE(FIORDR)
             MONMSG     MSGID(CPF2981) /* File Empty */
             RGZPFM     FILE(FIORAST)
             MONMSG     MSGID(CPF2981) /* File Empty */
/* SAVE LIBRARY */
/*           SAVLIB     LIB(&LIBR) DEV(TC)*/
/*           MONMSG     MSGID(CPA4036)    */

/* LOAD THE LOCAL DATA AREA  FOR STATUS UPDATE */
             CHGDTAARA  DTAARA(*LDA (200 44)) VALUE(' ')
/* PROGRAM NAME  */
             CHGDTAARA  DTAARA(*LDA (201 10)) VALUE('BIC990CL  ')
/* COMPANY NUMBER */
             CHGDTAARA  DTAARA(*LDA (211 2)) VALUE(&COMP)
/* ACCOUNTING PERIOD */
             CHGDTAARA  DTAARA(*LDA (213 2)) VALUE(&PER)
/* DESCRIPTION */
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('Distribution +
                          Month End')
             CALL       PGM(STSUPD)

 END:        ENDPGM
