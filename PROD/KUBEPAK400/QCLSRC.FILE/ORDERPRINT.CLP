             PGM
             DCL        VAR(&PCCMD) TYPE(*CHAR) LEN(150) +
                          VALUE('Order Print\')

             DCL        VAR(&PRDAPPDIR) TYPE(*CHAR) LEN(150)
             DCL        VAR(&ORDERPRINT) TYPE(*CHAR) LEN(50)

             RTVDTAARA  DTAARA(PRDAPPDIR *ALL) RTNVAR(&PRDAPPDIR)
             RTVDTAARA  DTAARA(ORDERPRINT *ALL) RTNVAR(&ORDERPRINT)

             CHGVAR     VAR(&PCCMD) VALUE('"' *TCAT &PRDAPPDIR *TCAT +
                          &PCCMD *TCAT &ORDERPRINT *TCAT '"')

             STRPCO
             MONMSG     MSGID(IWS4010)
             STRPCCMD   PCCMD(&PCCMD) PAUSE(*NO)

             ENDPGM
