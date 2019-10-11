/*********************************************************************/
/*   PROGRAM-------- BIC990CL                                        */
/*   DATE WRITTEN--- 01/04/94                                        */
/*   PROGRAMMER----- G. DE COURSEY                                   */
/*   DESCRIPTION---- DISTRIBUTION MONTH END PROCEDURE                */
/*   REVISIONS------                                                 */
/* 01/01/98 EFD ADD BACKUP FOR PURGED FILES                          */
/*********************************************************************/
             PGM
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOBQ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SAVE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PUR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILT) TYPE(*CHAR) LEN(9)  /* NEW MTRAN */
             DCL        VAR(&FILS) TYPE(*CHAR) LEN(9)  /* NEW MSALE */
             DCL        VAR(&FILH) TYPE(*CHAR) LEN(9)  /* NEW HORDW */
             DCL        VAR(&FILI) TYPE(*CHAR) LEN(9)  /* NEW IORDW */
             DCL        VAR(&FILV) TYPE(*CHAR) LEN(9)  /* NEW TINVT */
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(10) /* LIBR NAME */

             CALL       PGM(BIC990)
             RTVDTAARA  DTAARA(*LDA (18 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

 /*   BUILD LAST MONTH FILES   */
             RTVDTAARA  DTAARA(*LDA (43 9)) RTNVAR(&FILT)
             RTVDTAARA  DTAARA(*LDA (52 9)) RTNVAR(&FILS)
             RTVDTAARA  DTAARA(*LDA (61 9)) RTNVAR(&FILH)
             RTVDTAARA  DTAARA(*LDA (70 9)) RTNVAR(&FILI)
             RTVDTAARA  DTAARA(*LDA (79 9)) RTNVAR(&FILV)
             RTVDTAARA  DTAARA(*LDA (88 10)) RTNVAR(&LIBR)

 /* CREATE BACKUP LIBRARY */
             CRTLIB     LIB(&LIBR) TEXT('Last Month Data Files')
             MONMSG     MSGID(CPF2111) /* Library Exists */

             CRTPF      FILE(&LIBR/&FILT) RCDLEN(256) FLAG(20) +
                          MBR(*FILE) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CRTPF      FILE(&LIBR/&FILS) SRCMBR(FMSALE) FLAG(20) +
                          MBR(RMSALE) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CRTPF      FILE(&LIBR/&FILH) SRCMBR(FHORDW) FLAG(20) +
                          MBR(RHORDW) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CRTPF      FILE(&LIBR/&FILI) SRCMBR(FIORDW) FLAG(20) +
                          MBR(RIORDW) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CRTPF      FILE(&LIBR/&FILV) SRCMBR(FTINVT) FLAG(20) +
                          MBR(RTINVT) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)

 END:        ENDPGM
