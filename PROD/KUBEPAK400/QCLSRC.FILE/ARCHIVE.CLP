             PGM        PARM(&LIBR &FILE &NAME &TYPE &MBRD)

             DCLF       FILE(ARCHIVEMBR)
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(10) /* LIBRARY      */
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10) /* FILE NAME    */
             DCL        VAR(&NAME) TYPE(*CHAR) LEN(10) /* MEMBER NAME  */
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(10) /* MEMBER TYPE  */
             DCL        VAR(&MBRD) TYPE(*CHAR) LEN(50) /* MEMBER DESC  */
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(06)
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(06)
             DCL        VAR(&JOB ) TYPE(*CHAR) LEN(10)

             DCL        VAR(&MAX_NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NEW_NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SEQ) TYPE(*DEC) LEN(9 0)
             DCL        VAR(&SEQ@) TYPE(*CHAR) LEN(9)

             DCL        VAR(&DESC) TYPE(*CHAR) LEN(50) +
                          VALUE('L:__________ F:__________ +
                          T:__________      mmddyy')

             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&DATE)
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)
             RTVJOBA    JOB(&JOB)

             IF         COND(&LIBR *EQ '*DFT') THEN(CHGVAR +
                          VAR(&LIBR) VALUE('KUBEPAK400'))

             CHKOBJ     OBJ(&LIBR/&FILE) OBJTYPE(*FILE) MBR(&NAME)
             MONMSG     MSGID(CPF9815) EXEC(GOTO CMDLBL(SKIP_ARCH))

             CHGVAR     VAR(%SST(&DESC 03 10)) VALUE(&LIBR)
             CHGVAR     VAR(%SST(&DESC 16 10)) VALUE(&FILE)
             CHGVAR     VAR(%SST(&DESC 29 10)) VALUE(&TYPE)
             CHGVAR     VAR(%SST(&DESC 39 06)) VALUE(%SST(&DATE 5 2) +
                          *CAT %SST(&DATE 1 2) *CAT %SST(&DATE 3 2))
             CHGVAR     VAR(%SST(&DESC 45 06)) VALUE(&TIME)

     /*? ARCHIVE EXISTING PRODUCTION SOURCE  */
             DSPFD      FILE(ARCHIVE/ARCHIVE) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/ARCHIVEMBR)
             OVRDBF     FILE(ARCHIVEMBR) TOFILE(QTEMP/ARCHIVEMBR)

 RCVF01:     RCVF
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDLOOP1))

             IF         COND(&MLNAME *GT &MAX_NAME) THEN(CHGVAR +
                          VAR(&MAX_NAME) VALUE(&MLNAME))
             GOTO       CMDLBL(RCVF01)

 ENDLOOP1:
             CHGVAR     VAR(&SEQ@) VALUE(%SST(&MAX_NAME 2 9))
             CHGVAR     VAR(&SEQ) VALUE(&SEQ@)
             CHGVAR     VAR(&SEQ) VALUE(&SEQ + 1)
             CHGVAR     VAR(&SEQ@) VALUE(&SEQ)
             CHGVAR     VAR(&NEW_NAME) VALUE(Z *CAT &SEQ@)

             ADDPFM     FILE(ARCHIVE/ARCHIVE) MBR(&NEW_NAME) +
                          TEXT(&DESC) SRCTYPE(&NAME)
             CPYF       FROMFILE(&LIBR/&FILE) +
                          TOFILE(ARCHIVE/ARCHIVE) FROMMBR(&NAME) +
                          TOMBR(&NEW_NAME) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             DLTOVR     FILE(ARCHIVEMBR)
 SKIP_ARCH:
             ENDPGM
