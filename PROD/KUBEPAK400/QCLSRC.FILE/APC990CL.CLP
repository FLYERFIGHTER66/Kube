/*********************************************************************/
/*   PROGRAM-------- APC990CL                                        */
/*   DATE WRITTEN--- 04/20/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- A/P MONTHLY CLOSE                               */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&BU) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PUR) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&APD) TYPE(*CHAR) LEN(8)
             QSYS/DCL   VAR(&PRT) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&COMP) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&PERD) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&FILD) TYPE(*CHAR) LEN(9)  /* NEW APDET */
             DCL        VAR(&FILM) TYPE(*CHAR) LEN(9)  /* NEW APMTH */
             DCL        VAR(&FILO) TYPE(*CHAR) LEN(9)  /* NEW APOPN */
             DCL        VAR(&FILT) TYPE(*CHAR) LEN(9)  /* NEW APDTP */
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(10) /* LIBR NAME */

             CHGDTAARA  DTAARA(*LDA (1 256)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('APC990')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE('     A/P Month +
                          End Close  ')

             CALL       PGM(APC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             CALL       PGM(APC990)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             QSYS/RTVDTAARA DTAARA(*LDA (1 2)) RTNVAR(&COMP)
             QSYS/RTVDTAARA DTAARA(*LDA (3 2)) RTNVAR(&PERD)
             QSYS/RTVDTAARA DTAARA(*LDA (100 10)) RTNVAR(&PRT)
             QSYS/RTVDTAARA DTAARA(*LDA (120 2)) RTNVAR(&COPY)
             QSYS/RTVDTAARA DTAARA(*LDA (110 10)) RTNVAR(&FORM)
             QSYS/RTVDTAARA DTAARA(*LDA (127 4)) RTNVAR(&SAVE)
             QSYS/RTVDTAARA DTAARA(*LDA (123 4)) RTNVAR(&HOLD)

 /*   BUILD LAST MONTH FILES   */
             RTVDTAARA  DTAARA(*LDA (43 9)) RTNVAR(&FILD)
             RTVDTAARA  DTAARA(*LDA (52 9)) RTNVAR(&FILM)
             RTVDTAARA  DTAARA(*LDA (61 9)) RTNVAR(&FILO)
             RTVDTAARA  DTAARA(*LDA (70 9)) RTNVAR(&FILT)
             RTVDTAARA  DTAARA(*LDA (88 10)) RTNVAR(&LIBR)

 /* CREATE BACKUP LIBRARY */
             CRTLIB     LIB(&LIBR) TEXT('Last Month Data Files')
             MONMSG     MSGID(CPF2111) /* Library Exists */

             CRTPF      FILE(&LIBR/&FILD) SRCMBR(FAPDET) FLAG(20) +
                          MBR(RAPDET) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

             CRTPF      FILE(&LIBR/&FILM) SRCMBR(FAPMTH) FLAG(20) +
                          MBR(RAPMTH) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

             CRTPF      FILE(&LIBR/&FILO) SRCMBR(FAPOPN) FLAG(20) +
                          MBR(RAPOPN) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

             CRTPF      FILE(&LIBR/&FILT) SRCMBR(FAPDTP) FLAG(20) +
                          MBR(RAPDTP) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

             OVRDBF     FILE(FAPDETO) TOFILE(&LIBR/&FILD)
             OVRDBF     FILE(FAPMTHO) TOFILE(&LIBR/&FILM)
             OVRDBF     FILE(FAPOPNO) TOFILE(&LIBR/&FILO)
             OVRDBF     FILE(FAPDTPO) TOFILE(&LIBR/&FILT)

             CALL       PGM(APR990)

             QSYS/RTVDTAARA DTAARA(*LDA (24 1)) RTNVAR(&PUR)
             IF         COND(&PUR = 'N') THEN(GOTO CMDLBL(OPEN))

 /* PURGE APMTH                                                      */
             CRTPF      FILE(TGMSDATA/APMTHWRK) SRCMBR(FAPMTH) +
                          FLAG(20) MBR(RAPMTH) OPTION(*NOSRC +
                          *NOLIST) SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CPYF       FROMFILE(TGMSDATA/FAPMTH) +
                          TOFILE(TGMSDATA/APMTHWRK) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)
             CLRPFM     FILE(TGMSDATA/FAPMTH)
             CPYF       FROMFILE(TGMSDATA/APMTHWRK) +
                          TOFILE(TGMSDATA/FAPMTH) MBROPT(*ADD) +
                          INCCHAR(AMSTAT 1 *NE 'X') FMTOPT(*MAP *DROP)
             DLTF       FILE(TGMSDATA/APMTHWRK)
             MONMSG     MSGID(CPF2105)
 /* PURGE APDET                                                      */
             CRTPF      FILE(TGMSDATA/APDETWRK) SRCMBR(FAPDET) FLAG(20) +
                          MBR(RAPDET) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CPYF       FROMFILE(TGMSDATA/FAPDET) +
                          TOFILE(TGMSDATA/APDETWRK) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)
             CLRPFM     FILE(TGMSDATA/FAPDET)
             CPYF       FROMFILE(TGMSDATA/APDETWRK) +
                          TOFILE(TGMSDATA/FAPDET) MBROPT(*ADD) +
                          INCCHAR(ADSTAT 1 *NE 'X') FMTOPT(*MAP *DROP)
             DLTF       FILE(TGMSDATA/APDETWRK)
             MONMSG     MSGID(CPF2105)
 /* PURGE APOPN                                                      */
             CRTPF      FILE(TGMSDATA/APOPNWRK) SRCMBR(FAPOPN) FLAG(20) +
                          MBR(RAPOPN) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CPYF       FROMFILE(TGMSDATA/FAPOPN) +
                          TOFILE(TGMSDATA/APOPNWRK) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)
             CLRPFM     FILE(TGMSDATA/FAPOPN)
             CPYF       FROMFILE(TGMSDATA/APOPNWRK) +
                          TOFILE(TGMSDATA/FAPOPN) MBROPT(*ADD) +
                          INCCHAR(APSTAT 1 *NE 'X') FMTOPT(*MAP *DROP)
             DLTF       FILE(TGMSDATA/APOPNWRK)
             MONMSG     MSGID(CPF2105)
 /* PURGE APDTP                                                      */
             CRTPF      FILE(TGMSDATA/APDTPWRK) SRCMBR(FAPDTP) +
                          FLAG(20) MBR(RAPDTP) OPTION(*NOSRC +
                          *NOLIST) SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CPYF       FROMFILE(TGMSDATA/FAPDTP) +
                          TOFILE(TGMSDATA/APDTPWRK) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)
             CLRPFM     FILE(TGMSDATA/FAPDTP)
             CPYF       FROMFILE(TGMSDATA/APDTPWRK) +
                          TOFILE(TGMSDATA/FAPDTP) MBROPT(*ADD) +
                          INCCHAR(ATSTAT 1 *NE 'X') FMTOPT(*MAP *DROP)
             DLTF       FILE(TGMSDATA/APDTPWRK)
             MONMSG     MSGID(CPF2105)

/* LOAD THE LOCAL DATA AREA  FOR STATUS UPDATE */
 OPEN:       CHGDTAARA  DTAARA(*LDA (200 44)) VALUE(' ')
/* PROGRAM NAME  */
             CHGDTAARA  DTAARA(*LDA (201 10)) VALUE('APR990CL  ')
/* COMPANY NUMBER */
             CHGDTAARA  DTAARA(*LDA (211 2)) VALUE(&COMP)
/* ACCOUNTING PERIOD */
             CHGDTAARA  DTAARA(*LDA (213 2)) VALUE(&PERD)
/* DESCRIPTION */
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('A/P Month End +
                          Close')
             CALL       PGM(STSUPD)

 END:        ENDPGM
