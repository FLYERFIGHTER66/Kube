             PGM        PARM(&ZIP)
             DCL        VAR(&ZIP) TYPE(*CHAR) LEN(5)

             DCL        VAR(&PCCMD) TYPE(*CHAR) LEN(256) +
                          VALUE('EXPLORER.EXE +
                          "http://maps.yahoo.com/#mvt=m&q1=08501')

             IF         COND(&ZIP *EQ ' ') THEN(GOTO CMDLBL(SKIP))

             CHGVAR     VAR(&PCCMD) VALUE(&PCCMD *TCAT '&q2=' *TCAT &ZIP)
 SKIP:       CHGVAR     VAR(&PCCMD) VALUE(&PCCMD *TCAT '"')

             STRPCO
             MONMSG     MSGID(IWS4010)

             STRPCCMD   PCCMD(&PCCMD) PAUSE(*NO)

 EOJ:        ENDPGM
