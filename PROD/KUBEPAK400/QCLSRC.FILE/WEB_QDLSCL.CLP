             PGM
             DCLF       FILE(WEB_QDLSFM) RCDFMT($QDLSPATH)
             DCL        VAR(&FULLPATH) TYPE(*CHAR) LEN(40)
             DCL        VAR(&FOLDER) TYPE(*CHAR) LEN(40)

/*? SEND .CSV FILE ?*/
             RTVDTAARA  DTAARA(WEB_QDLS (01 40)) RTNVAR(&FULLPATH)
             RTVDTAARA  DTAARA(WEB_QDLS (41 40)) RTNVAR(&FOLDER)
SCRN01:      SNDRCVF
             IF         COND(&IN12 = '1') THEN(GOTO CMDLBL(EOJ))
             CHGDTAARA  DTAARA(WEB_QDLS (01 40)) VALUE(&FULLPATH)
             CHGDTAARA  DTAARA(WEB_QDLS (41 40)) VALUE(&FOLDER)

 EOJ:        ENDPGM
