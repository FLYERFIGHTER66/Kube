             PGM        PARM(&ADDRESS1 &TOWN &STATE)
             DCL        VAR(&TOWN) TYPE(*CHAR) LEN(18)
             DCL        VAR(&STATE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ADDRESS1) TYPE(*CHAR) LEN(30)

             DCL        VAR(&PCCMD) TYPE(*CHAR) LEN(123) +
                          VALUE('EXPLORER.EXE +
                          "http://zip4.usps.com/zip4/welcome.jsp?')

             IF         COND(&ADDRESS1 *EQ ' ') THEN(DO)
             ZIP        TOWN(&TOWN) STATE(&STATE)
             GOTO       CMDLBL(EOJ)
             ENDDO

        CHGVAR     VAR(&PCCMD) VALUE(&PCCMD *TCAT 'state=' *CAT &STATE)
        CHGVAR     VAR(&PCCMD) VALUE(&PCCMD *TCAT '&city=' *CAT &TOWN)
        CHGVAR     VAR(&PCCMD) VALUE(&PCCMD *TCAT '&address2=' *CAT &ADDRESS1)
        CHGVAR     VAR(&PCCMD) VALUE(&PCCMD *TCAT '"')

             STRPCO
             MONMSG     MSGID(IWS4010)

             STRPCCMD   PCCMD(&PCCMD) PAUSE(*NO)

 EOJ:        ENDPGM
