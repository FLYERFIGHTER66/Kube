             PGM
             DCL        VAR(&PCCMD) TYPE(*CHAR) LEN(150) +
                          VALUE('Mod10 Check.xls"')
             DCL        VAR(&PRDAPPDIR) TYPE(*CHAR) LEN(150)
             RTVDTAARA  DTAARA(PRDAPPDIR *ALL) RTNVAR(&PRDAPPDIR)
             CHGVAR     VAR(&PCCMD) VALUE('"' *TCAT &PRDAPPDIR *TCAT &PCCMD)

             STRPCO
             MONMSG     MSGID(IWS4010)
             STRPCCMD   PCCMD(&PCCMD) PAUSE(*NO)

             ENDPGM
