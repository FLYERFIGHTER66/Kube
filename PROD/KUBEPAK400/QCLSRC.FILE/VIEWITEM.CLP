             PGM        PARM(&ITEM &SIZE)
             DCL        VAR(&ITEM) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SIZE) TYPE(*CHAR) LEN(3)
             DCL        VAR(&JPG) TYPE(*CHAR) LEN(5) VALUE('.jpg')
             DCL        VAR(&PCCMD) TYPE(*CHAR) LEN(150) +
                          VALUE('"\\10.151.151.1\kube pak\PICTURES\"')


             STRPCO
             MONMSG     MSGID(IWS4010)

             CHGVAR     VAR(&PCCMD) VALUE(&PCCMD *TCAT &ITEM)
             IF         COND(&SIZE *NE ' ') THEN(CHGVAR VAR(&PCCMD) +
                          VALUE(&PCCMD *TCAT '-' *TCAT &SIZE))
             CHGVAR     VAR(&PCCMD) VALUE(&PCCMD *TCAT &JPG)

             STRPCCMD   PCCMD(&PCCMD) PAUSE(*NO)

             ENDPGM
