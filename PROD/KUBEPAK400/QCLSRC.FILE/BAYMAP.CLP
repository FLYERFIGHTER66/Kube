             PGM
             DCL        VAR(&PCCMD) TYPE(*CHAR) LEN(150) +
                          VALUE('Plug Stuffing\BayMap.xlsm"')

             DCL        VAR(&PRDAPPDIR) TYPE(*CHAR) LEN(150)
             RTVDTAARA  DTAARA(PRDAPPDIR *ALL) RTNVAR(&PRDAPPDIR)
             CHGVAR     VAR(&PCCMD) VALUE('"' *TCAT &PRDAPPDIR *TCAT &PCCMD)

             STRPCO
             MONMSG     MSGID(IWS4010)
             MONMSG     MSGID(IWS4032) EXEC(GOTO EXIT)
             STRPCCMD   PCCMD(&PCCMD) PAUSE(*NO)
             GOTO       CMDLBL(EOJ)

 EXIT:       SNDPGMMSG  MSG('You cannot run an excel spreadsheet +
                          from this terminal.') TOPGMQ(*EXT)

 EOJ:        ENDPGM
