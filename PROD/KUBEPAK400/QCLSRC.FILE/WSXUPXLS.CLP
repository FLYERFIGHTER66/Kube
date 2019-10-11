             PGM
             DCL        VAR(&PCCMD) TYPE(*CHAR) LEN(150) +
                          VALUE('"\\10.151.151.1\kube +
                          pak\xlsimport\XREF\XREF_UPLOAD.xlsm"')

             STRPCO
             MONMSG     MSGID(IWS4010)
             MONMSG     MSGID(IWS4032) EXEC(GOTO EXIT)
             STRPCCMD   PCCMD(&PCCMD) PAUSE(*NO)
             GOTO       CMDLBL(EOJ)

 EXIT:       SNDPGMMSG  MSG('You cannot run an excel spreadsheet +
                          from this terminal.') TOPGMQ(*EXT)

 EOJ:        ENDPGM
