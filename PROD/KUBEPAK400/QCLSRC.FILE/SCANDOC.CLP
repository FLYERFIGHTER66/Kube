             PGM
             DCL        VAR(&PCCMD) TYPE(*CHAR) LEN(70) +
                          VALUE('"C:\Program Files\Common +
                          Files\Microsoft +
                          Shared\MODI\11.0\MSPSCAN.EXE"')

             STRPCO
             MONMSG     MSGID(IWS4010)

             STRPCCMD   PCCMD(&PCCMD) PAUSE(*NO)

             ENDPGM
