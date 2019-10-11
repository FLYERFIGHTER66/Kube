             PGM        PARM(&FROMFILE &STREAMFILE)
             DCL        VAR(&FROMFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STREAMFILE) TYPE(*CHAR) LEN(12)
             DCL        VAR(&FULLPATH) TYPE(*CHAR) LEN(40)
             DCL        VAR(&FOLDER) TYPE(*CHAR) LEN(40)
             DCL        VAR(&TESTPATH) TYPE(*CHAR) LEN(40)

/*? SEND .CSV FILE ?*/
             RTVDTAARA  DTAARA(WEB_QDLS (01 40)) RTNVAR(&FULLPATH)
             RTVDTAARA  DTAARA(WEB_QDLS (41 40)) RTNVAR(&FOLDER)
             CHGVAR     VAR(&TESTPATH) VALUE(&FULLPATH *TCAT 'TEST/')

             DLTDLO     DLO(&STREAMFILE) FLR(&FOLDER)
             MONMSG     MSGID(CPF8A16 CPA0701)

             DLYJOB     DLY(10)
             CPYTOIMPF  FROMFILE(*LIBL/&FROMFILE) TOSTMF(&FULLPATH +
                          *TCAT &STREAMFILE) MBROPT(*REPLACE) +
                          STMFCODPAG(*STDASCII) RCDDLM(*CRLF) +
                          DTAFMT(*DLM) STRDLM('"') FLDDLM(',')

 REMOVETEST: GOTO       CMDLBL(EOJ)
 TEST:       DB2XTOOLS/DB2CSV FILENAME(&FROMFILE) +
                          TOFILENAME(&STREAMFILE) +
                          IFSPATH(&TESTPATH) FLDDLM(',') +
                          DECPNT(*PERIOD) STRDLM('"') SHOW(*NO)
             MONMSG     MSGID(CPF0000)

 EOJ:        ENDPGM
