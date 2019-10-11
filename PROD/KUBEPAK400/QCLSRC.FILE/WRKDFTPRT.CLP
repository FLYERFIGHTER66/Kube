             PGM
             DCL        VAR(&PCCMD) TYPE(*CHAR) LEN(41) +
                          VALUE('"P:\Production Apps\Default +
                          Printers.mdb"')

             STRPCO
             MONMSG     MSGID(IWS4010)

             STRPCCMD   PCCMD(&PCCMD) PAUSE(*NO)

             ENDPGM
