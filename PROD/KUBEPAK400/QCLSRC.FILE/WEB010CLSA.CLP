             PGM

             DCL        VAR(&OPEN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&INPUT)  TYPE(*CHAR) LEN(10) VALUE('WEB010FTP')
             DCL        VAR(&OUTPUT) TYPE(*CHAR) LEN(10) VALUE('WEB010LOG')

/*? READY BAY OPEN ?  ?*/
             RTVDTAARA  DTAARA(RB_OPEN (1 1)) RTNVAR(&OPEN)
             IF         COND(&OPEN *NE '1') THEN(GOTO CMDLBL(SENDCLOSED))

/*? RUN WEB BUILD FOR PLUGS ?*/
             CALL       PGM(WEB010CL)

             GOTO       CMDLBL(SEND)
 SENDCLOSED: CHGVAR     VAR(&INPUT) VALUE('WEB010FTPC')
 SEND:       CALL       PGM(WEB006CL) PARM(&OPEN &INPUT &OUTPUT)

 EOJ:        ENDPGM
