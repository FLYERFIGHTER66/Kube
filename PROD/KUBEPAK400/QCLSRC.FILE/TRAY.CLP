             PGM
             DCL        VAR(&PCCMD) TYPE(*CHAR) LEN(150) +
                          VALUE('"P:\Tray Tags\Tray Tag Information +
                          Worksheet.xls"')

             STRPCO
             MONMSG     MSGID(IWS4010)
             STRPCCMD   PCCMD(&PCCMD) PAUSE(*NO)

             ENDPGM
