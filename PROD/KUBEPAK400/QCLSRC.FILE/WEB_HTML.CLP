             PGM        PARM(&FROMFILE &STREAMFILE)
             DCL        VAR(&FROMFILE  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STREAMFILE) TYPE(*CHAR) LEN(12)
             DCL        VAR(&FULLPATH) TYPE(*CHAR) LEN(40)
             DCL        VAR(&FOLDER) TYPE(*CHAR) LEN(40)

             MONMSG     MSGID(CPF0000)

             RTVDTAARA  DTAARA(WEB_QDLS (01 40)) RTNVAR(&FULLPATH)
             RTVDTAARA  DTAARA(WEB_QDLS (41 40)) RTNVAR(&FOLDER)

             DLTDLO     DLO(&STREAMFILE) FLR(&FOLDER)
             MONMSG     MSGID(CPF8A16 CPA0701)

             DLYJOB     DLY(5)
             CPYTOIMPF  FROMFILE(&FROMFILE) TOSTMF(&FULLPATH *TCAT +
                          &STREAMFILE) MBROPT(*REPLACE) +
                          STMFCODPAG(*STDASCII) RCDDLM(*CRLF) +
                          DTAFMT(*FIXED) STRDLM(*NONE) FLDDLM(',')

 EOJ:        ENDPGM
