             PGM        PARM(&ZIP)
             DCL        VAR(&ZIP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PCCMD) TYPE(*CHAR) LEN(150) +
                          VALUE('"C:\Program Files\Internet +
                          Explorer\IEXPLORE.EXE" +
                          https://weather.com/weather/today/l/')
             IF         COND(&ZIP = ' ') THEN(CHGVAR VAR(&ZIP) +
                          VALUE('08501'))
             CHGVAR     VAR(&PCCMD) VALUE(&PCCMD *TCAT &ZIP)
             STRPCO
             MONMSG     MSGID(IWS4010)

             STRPCCMD   PCCMD(&PCCMD) PAUSE(*NO)

             ENDPGM
