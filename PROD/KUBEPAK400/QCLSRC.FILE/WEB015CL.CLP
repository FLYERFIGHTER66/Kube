             PGM        PARM(&STATUS)

             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&INPUT) TYPE(*CHAR) LEN(10) +
                          VALUE('WEB010FTP')

             CHGDTAARA  DTAARA(RB_OPEN (1 1)) VALUE(&STATUS)
             IF         COND(&STATUS = '0') THEN(CHGVAR VAR(&INPUT) +
                          VALUE('WEB010FTPC'))
             CALL       PGM(WEB006CL) PARM(&STATUS 'WEB010FTP' +
                          'WEB010LOG')

 EOJ:        ENDPGM
