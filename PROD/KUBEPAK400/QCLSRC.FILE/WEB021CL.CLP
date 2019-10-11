             PGM

             DCLF       FILE(WEB021FM)
             DCL        VAR(&SEAS01@) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SEAS02@) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SEAS03@) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SQL1) TYPE(*CHAR) LEN(80)
             DCL        VAR(&SQL2) TYPE(*CHAR) LEN(80)
             DCL        VAR(&SQL3) TYPE(*CHAR) LEN(80)

/*? GET CURRENT VALUES FROM DATA AREA ?*/
             RTVDTAARA  DTAARA(WEB020CL (1 2)) RTNVAR(&SEAS01@)
             RTVDTAARA  DTAARA(WEB020CL (3 2)) RTNVAR(&SEAS02@)
             RTVDTAARA  DTAARA(WEB020CL (5 2)) RTNVAR(&SEAS03@)
             CHGVAR     VAR(&SEAS01) VALUE(&SEAS01@)
             CHGVAR     VAR(&SEAS02) VALUE(&SEAS02@)
             CHGVAR     VAR(&SEAS03) VALUE(&SEAS03@)

SCRN01:      SNDRCVF
             IF         COND(&IN12 = '1') THEN(GOTO CMDLBL(EOJ))

/*? UPDATE VALUES IN THE DATA AREA ?*/
             CHGVAR     VAR(&SEAS01@) VALUE(&SEAS01)
             CHGVAR     VAR(&SEAS02@) VALUE(&SEAS02)
             CHGVAR     VAR(&SEAS03@) VALUE(&SEAS03)
             CHGDTAARA  DTAARA(WEB020CL (1 2)) VALUE(&SEAS01@)
             CHGDTAARA  DTAARA(WEB020CL (3 2)) VALUE(&SEAS02@)
             CHGDTAARA  DTAARA(WEB020CL (5 2)) VALUE(&SEAS03@)
/*? UPDATE VALUES IN CURSEASONS ?*/
             RUNSQL     SQL('DELETE FROM CURSEASONS') COMMIT(*NONE)
SEASON_1:    IF         COND(&SEAS01 *NE 0) THEN(DO)
             CHGVAR     VAR(&SQL1) VALUE('INSERT INTO CURSEASONS +
                          VALUES(' *TCAT &SEAS01@ *TCAT ')')
             RUNSQL     SQL(&SQL1) COMMIT(*NONE)
             ENDDO
SEASON_2:    IF         COND(&SEAS02 *NE 0) THEN(DO)
             CHGVAR     VAR(&SQL2) VALUE('INSERT INTO CURSEASONS +
                          VALUES(' *TCAT &SEAS02@ *TCAT ')')
             RUNSQL     SQL(&SQL2) COMMIT(*NONE)
             ENDDO
SEASON_3:    IF         COND(&SEAS03 *NE 0) THEN(DO)
             CHGVAR     VAR(&SQL3) VALUE('INSERT INTO CURSEASONS +
                          VALUES(' *TCAT &SEAS03@ *TCAT ')')
             RUNSQL     SQL(&SQL3) COMMIT(*NONE)
             ENDDO

 EOJ:        ENDPGM
