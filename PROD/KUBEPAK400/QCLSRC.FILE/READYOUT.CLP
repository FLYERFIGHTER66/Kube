             PGM
             DCL        VAR(&PCCMD) TYPE(*CHAR) LEN(123) +
                          VALUE('Ready List\Ready List.xls"')
             DCL        VAR(&PRDAPPDIR) TYPE(*CHAR) LEN(150)
             RTVDTAARA  DTAARA(PRDAPPDIR *ALL) RTNVAR(&PRDAPPDIR)
             CHGVAR     VAR(&PCCMD) VALUE('"' *TCAT &PRDAPPDIR *TCAT &PCCMD)

             RUNQRY     QRY(READYLST) QRYFILE((*SAME)) RCDSLT(*NO)

             STRPCO
             MONMSG     MSGID(IWS4010)
             STRPCCMD   PCCMD(&PCCMD) PAUSE(*NO)


             ENDPGM
