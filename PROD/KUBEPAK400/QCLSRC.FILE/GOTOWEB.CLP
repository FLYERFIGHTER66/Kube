             PGM        PARM(&WEB)
             DCL        VAR(&B1) TYPE(*CHAR) LEN(14) VALUE('explorer.exe "')

             DCL        VAR(&WEB) TYPE(*CHAR) LEN(109)

             STRPCO
             MONMSG     MSGID(IWS4010)

             STRPCCMD   PCCMD(&B1 *CAT &WEB)

             ENDPGM
