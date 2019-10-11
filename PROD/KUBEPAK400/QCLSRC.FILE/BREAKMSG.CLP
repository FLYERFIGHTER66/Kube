             PGM        PARM(&MSGID &MSGF)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF)  TYPE(*CHAR) LEN(10)

/*           SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGF) MSGDTA(*NONE) +
                          TOPGMQ(*EXT) MSGTYPE(*INFO)            */
             SNDUSRMSG  MSGID(&MSGID) MSGF(&MSGF) MSGDTA(*NONE) +
                          MSGTYPE(*INFO) TOMSGQ(*EXT)

             ENDPGM
