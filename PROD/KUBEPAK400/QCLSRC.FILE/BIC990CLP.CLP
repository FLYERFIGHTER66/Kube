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
             CRTPF      FILE(QS36F/IORDWWRK) SRCMBR(FIORDW) FLAG(20) +
                          MBR(RIORDW) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CPYF       FROMFILE(QS36F/FIORDW) +
                          TOFILE(QS36F/IORDWWRK) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)
             CLRPFM     FILE(QS36F/FIORDW)
             CPYF       FROMFILE(QS36F/IORDWWRK) +
                          TOFILE(QS36F/FIORDW) MBROPT(*ADD)   +
                          FMTOPT(*MAP *DROP)
             DLTF       FILE(QS36F/IORDWWRK)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(QS36F/HORDWWRK) SRCMBR(FHORDW) FLAG(20) +
                          MBR(RHORDW) OPTION(*NOSRC *NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO)
             MONMSG     MSGID(CPF5813 CPF7302)
             CPYF       FROMFILE(QS36F/FHORDW) +
                          TOFILE(QS36F/HORDWWRK) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)
             CLRPFM     FILE(QS36F/FHORDW)
             CPYF       FROMFILE(QS36F/HORDWWRK) +
                          TOFILE(QS36F/FHORDW) MBROPT(*ADD)   +
                          FMTOPT(*MAP *DROP)
             DLTF       FILE(QS36F/HORDWWRK)
             MONMSG     MSGID(CPF2105)
             RTVDTAARA  DTAARA(*LDA (31 1)) RTNVAR(&PUR)
             IF         COND(&PUR = 'N') THEN(GOTO CMDLBL(END))
             CALL       PGM(PRGMSALECL)
             CALL       PGM(PRGTINVTCL)
             STRS36PRC  PRC(BIP990) CURLIB(GROWERS) /* PURGES MTRAN */
/* SAVE LIBRARY */

 END:        ENDPGM
