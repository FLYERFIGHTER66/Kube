             PGM

             DCL        VAR(&PCCMD) TYPE(*CHAR) LEN(256) +
                          VALUE('EXPLORER.EXE +
                          "http://spiceworks/portal"')

             STRPCO
             MONMSG     MSGID(IWS4010)

             STRPCCMD   PCCMD(&PCCMD) PAUSE(*NO)

 EOJ:        ENDPGM
