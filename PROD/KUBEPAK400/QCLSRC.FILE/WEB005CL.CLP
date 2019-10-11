             PGM

             DCL        VAR(&OPEN) TYPE(*CHAR) LEN(1)

/*? CURRENT READY BAY ?*/
             RTVDTAARA  DTAARA(RB_OPEN (1 1)) RTNVAR(&OPEN)

             IF         COND(&OPEN = '1') THEN(DO)
             CALL       PGM(WEB010CL)
             ENDDO

/*? FUTURE READY BAY ?*/
/*           CALL       PGM(WEB030CL)                    */

/*? FINISHED ?*/
             CALL       PGM(WEB020CL)

/*? SEND TO WEBSITE ?*/
             CALL       PGM(WEB006CL) PARM(&OPEN 'WEBALLFTP' +
                          'WEBALLLOG')

 EOJ:        ENDPGM
