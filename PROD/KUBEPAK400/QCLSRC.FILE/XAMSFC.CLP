             PGM        PARM(&PGMQ &MSGF &MSGFLIB &MSGID &MSGDTA +
                          &KEYVAR &SNDCLR)
             DCL        VAR(&PGMQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(80)
             DCL        VAR(&KEYVAR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SNDCLR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERRORSW) TYPE(*LGL)
             DCL        VAR(&EMSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&EMSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&EMSGDTA) TYPE(*CHAR) LEN(100)
             DCL        VAR(&EMSGFLIB) TYPE(*CHAR) LEN(10)

             MONMSG     MSGID(CPF0000 CPD0000 CPA0000) EXEC(GOTO +
                          CMDLBL(STDERR1))

             IF         COND(&SNDCLR *EQ 'C') THEN(DO)
             RMVMSG     PGMQ(*SAME (&PGMQ)) CLEAR(*ALL)
             RETURN
             ENDDO

             IF         COND(&SNDCLR *EQ 'S') THEN(DO)
             IF         COND(&MSGID *EQ '*******') THEN(SNDPGMMSG +
                          MSG(&MSGDTA) TOPGMQ(*SAME (&PGMQ)) +
                          KEYVAR(&KEYVAR))
             ELSE       CMD(SNDPGMMSG MSGID(&MSGID) +
                          MSGF(&MSGFLIB/&MSGF) MSGDTA(&MSGDTA) +
                          TOPGMQ(*SAME (&PGMQ)) KEYVAR(&KEYVAR))
             RETURN
             ENDDO

STDERR1:
             IF         COND(&ERRORSW) THEN(SNDPGMMSG MSGID(CPF9999) +
                          MSGF(QCPFMSG) MSGTYPE(*ESCAPE))
             CHGVAR     VAR(&ERRORSW) VALUE('1')
 STDERR2:    RCVMSG     MSGTYPE(*DIAG) MSGDTA(&EMSGDTA) +
                          MSGID(&EMSGID) MSGF(&EMSGF) +
                          MSGFLIB(&EMSGFLIB)

             IF         COND(&EMSGID *EQ '       ') THEN(GOTO +
                          CMDLBL(STDERR3))
             SNDPGMMSG  MSGID(&EMSGID) MSGF(&EMSGFLIB/&EMSGF) +
                          MSGDTA(&EMSGDTA) MSGTYPE(*DIAG)
             GOTO       CMDLBL(STDERR2)
 STDERR3:    RCVMSG     MSGTYPE(*EXCP) MSGDTA(&EMSGDTA) +
                          MSGID(&EMSGID) MSGF(&EMSGF) +
                          MSGFLIB(&EMSGFLIB)
             SNDPGMMSG  MSGID(&EMSGID) MSGF(&EMSGFLIB/&EMSGF) +
                          MSGDTA(&EMSGDTA) MSGTYPE(*ESCAPE)
             ENDPGM
