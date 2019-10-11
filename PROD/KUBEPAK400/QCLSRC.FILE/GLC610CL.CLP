/*********************************************************************/
/*   PROGRAM-------- GLC610CL                                        */
/*   DATE WRITTEN--- 08/03/99                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- YEAR END PRELIMINARY CLOSE                      */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             QSYS/DCL   VAR(&EOJ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             QSYS/DCL   VAR(&PRTR) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&FORM) TYPE(*CHAR) LEN(10)
             QSYS/DCL   VAR(&HOLD) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&SAVE) TYPE(*CHAR) LEN(4)
             QSYS/DCL   VAR(&COPY) TYPE(*CHAR) LEN(2)
             QSYS/DCL   VAR(&CO) TYPE(*CHAR) LEN(2)

             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(9) /* LIBR NAME */
             DCL        VAR(&LIBC) TYPE(*CHAR) LEN(10) /* CURR LIBR */

             RTVJOBA    CURLIB(&LIBC)

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('GLC610')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE(' Year End +
                          Preliminary Close ')

             CALL       PGM(GLC998)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))
             QSYS/RTVDTAARA DTAARA(*LDA (1 2)) RTNVAR(&CO)

             CALL       PGM(GLC610)
             QSYS/RTVDTAARA DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

 /*   BUILD LAST YEAR FILES   */
             RTVDTAARA  DTAARA(*LDA (88 9)) RTNVAR(&LIBR)

 /*   CREATE BACKUP LIBRARY   */
             CRTLIB     LIB(&LIBR) TEXT('Last Year Data Files')
             MONMSG     MSGID(CPF2111) /* Library Exists */

 /*  G/L BALANCE  */
             CRTPF      FILE(&LIBR/FGLBAL) SRCMBR(FGLBAL) FLAG(20) +
                          MBR(RGLBAL) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

             CPYF       FROMFILE(*LIBL/FGLBAL) TOFILE(&LIBR/FGLBAL) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)

 /*  G/L BALANCE SUMMARY */
             CRTPF      FILE(&LIBR/FGLBALS) SRCMBR(FGLBALS) FLAG(20) +
                          MBR(RGLBALS) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

             CPYF       FROMFILE(*LIBL/FGLBALS) +
                          TOFILE(&LIBR/FGLBALS) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)

 /*  G/L BALANCE TOTAL   */
             CRTPF      FILE(&LIBR/FGLBALT) SRCMBR(FGLBALT) FLAG(20) +
                          MBR(RGLBALT) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

             CPYF       FROMFILE(*LIBL/FGLBALT) +
                          TOFILE(&LIBR/FGLBALT) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)

 /*  G/L BUDGET   */
             CRTPF      FILE(&LIBR/FGLBUD) SRCMBR(*FILE) FLAG(20) +
                          MBR(RGLBUD) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

             CPYF       FROMFILE(*LIBL/FGLBUD) TOFILE(&LIBR/FGLBUD) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)

 /*  G/L ALLOCATIONS     */
             CRTPF      FILE(&LIBR/FGLALO) SRCMBR(FGLALO) FLAG(20) +
                          MBR(RGLALO) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

             CPYF       FROMFILE(*LIBL/FGLALO) TOFILE(&LIBR/FGLALO) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)

 /*  G/L CHART OF ACCOUNTS  */
             CRTPF      FILE(&LIBR/FMGLCH) SRCMBR(FMGLCH) FLAG(20) +
                          MBR(RMGLCH) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

             CPYF       FROMFILE(*LIBL/FMGLCH) TOFILE(&LIBR/FMGLCH) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)

 /*  G/L ACCOUNTING PERIODS  */
             CRTPF      FILE(&LIBR/FMAPER) SRCMBR(FMAPER) FLAG(20) +
                          MBR(RMAPER) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

             CPYF       FROMFILE(*LIBL/FMAPER) TOFILE(&LIBR/FMAPER) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)

 /*  G/L CONTROL FILE        */
             CRTPF      FILE(&LIBR/FGLCTL) SRCMBR(*FILE) FLAG(20) +
                          MBR(RGLCTL) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

             CPYF       FROMFILE(*LIBL/FGLCTL) TOFILE(&LIBR/FGLCTL) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)

 /*  G/L CONSOLIDATION FILE        */
             CRTPF      FILE(&LIBR/FGLDCON) SRCMBR(*FILE) FLAG(20) +
                          MBR(RGLDCON) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

 /*  G/L DETAIL FILE        */
             CRTPF      FILE(&LIBR/FGLDET) SRCMBR(*FILE) FLAG(20) +
                          MBR(RGLDET) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

 /*  G/L REVERSING ENTRIES   */
             CRTPF      FILE(&LIBR/FGLREV) SRCMBR(*FILE) FLAG(20) +
                          MBR(RGLREV) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

             CPYF       FROMFILE(*LIBL/FGLREV) TOFILE(&LIBR/FGLREV) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)

 /*  G/L WORK                */
             CRTPF      FILE(&LIBR/FGLWRK) SRCMBR(*FILE) FLAG(20) +
                          MBR(RGLWRK) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

             CPYF       FROMFILE(*LIBL/FGLWRK) TOFILE(&LIBR/FGLWRK) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)

 /*  G/L ENTRY               */
             CRTPF      FILE(&LIBR/FGLENT) SRCMBR(*FILE) FLAG(20) +
                          MBR(RGLENT) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

             CPYF       FROMFILE(*LIBL/FGLENT) TOFILE(&LIBR/FGLENT) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)

 /*  COPY GLDET AND GLDCON   */
             OVRDBF     FILE(FGLDETO) TOFILE(&LIBR/FGLDET)
             OVRDBF     FILE(FGLDCONO) TOFILE(&LIBR/FGLDCON)

             CALL       PGM(GLR610)

 /*  ROLL BALANCE FILES      */

             CALL       PGM(GLR611)

 /*  CLEAR POST FLAGS IN RECURRING ENTRY FILE  */

             CALL       PGM(GLR612)

 /*  UPDATE GLCTL AND GLCLOS  BASE SYSTEM      */

             CALL       PGM(GLR619)

 /*  UPDATE GLCTL AND GLCLOS  NEWSYSTEM        */

             OVRDBF     FILE(FGLCTL) TOFILE(&LIBR/FGLCTL)
             CALL       PGM(GLR619A)

 /*  REORGANIZE FILES        */

             RGZPFM     FILE(FGLDET)
             RGZPFM     FILE(FGLDCON)

 /*  BUILD INDEXES IN LAST YEAR LIBRARY */

             CHGCURLIB  CURLIB(&LIBR)

             CRTLF      FILE(&LIBR/FGLALOIN) MBR(RGLALO) +
                          OPTION(*NOSRC *NOLIST) LVLCHK(*NO)

             CRTLF      FILE(&LIBR/FGLALOTO) MBR(RGLALO) +
                          OPTION(*NOSRC *NOLIST) LVLCHK(*NO)

             CRTLF      FILE(&LIBR/FMGLCHAL) MBR(RMGLCH) +
                          OPTION(*NOSRC *NOLIST) LVLCHK(*NO)

             CRTLF      FILE(&LIBR/FGLDCOAC) MBR(RGLDCON) +
                          OPTION(*NOSRC *NOLIST) LVLCHK(*NO)

             CRTLF      FILE(&LIBR/FGLDACCT) OPTION(*NOSRC *NOLIST) +
                          LVLCHK(*NO)

             CRTLF      FILE(&LIBR/FGLDVEND) OPTION(*NOSRC *NOLIST) +
                          LVLCHK(*NO)

             CRTLF      FILE(&LIBR/FGLDETAA) MBR(RGLDET) +
                          OPTION(*NOSRC *NOLIST) LVLCHK(*NO)

             CRTLF      FILE(&LIBR/FGLDETAC) MBR(RGLDET) +
                          OPTION(*NOSRC *NOLIST) LVLCHK(*NO)

             CRTLF      FILE(&LIBR/FGLDETDT) MBR(RGLDET) +
                          OPTION(*NOSRC *NOLIST) LVLCHK(*NO)

             CRTLF      FILE(&LIBR/FGLDETJD) MBR(RGLDET) +
                          OPTION(*NOSRC *NOLIST) LVLCHK(*NO)

             CRTLF      FILE(&LIBR/FGLDETJS) MBR(RGLDET) +
                          OPTION(*NOSRC *NOLIST) LVLCHK(*NO)

             CHGCURLIB  CURLIB(&LIBC)

/* LOAD THE LOCAL DATA AREA  FOR STATUS UPDATE */
             CHGDTAARA  DTAARA(*LDA (200 44)) VALUE(' ')
/* PROGRAM NAME  */
             CHGDTAARA  DTAARA(*LDA (201 10)) VALUE('GLC610CL  ')
/* COMPANY NUMBER */
             CHGDTAARA  DTAARA(*LDA (211 2)) VALUE(&CO)
/* ACCOUNTING PERIOD */
             CHGDTAARA  DTAARA(*LDA (213 2)) VALUE('00')
/* DESCRIPTION */
             CHGDTAARA  DTAARA(*LDA (215 30)) VALUE('G/L Soft Close')
             CALL       PGM(STSUPD)

 END:        ENDPGM
