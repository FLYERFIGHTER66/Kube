             PGM

             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SEAS1) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SEAS2) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SEAS3) TYPE(*CHAR) LEN(2)

             QSYS/RTVOBJD OBJ(WEB020CL) OBJTYPE(*PGM) RTNLIB(&LIBR)

/*? FINISHED ?*/
             RTVDTAARA  DTAARA(WEB020CL (1 2)) RTNVAR(&SEAS1)
             RTVDTAARA  DTAARA(WEB020CL (3 2)) RTNVAR(&SEAS2)
             RTVDTAARA  DTAARA(WEB020CL (5 2)) RTNVAR(&SEAS3)

             CLRPFM     FILE(HTMLOUTF)
             CLRPFM     FILE(FINISHOUT)

             CALL       PGM(WEBBUILD02) PARM('FIN' &SEAS1 &SEAS2 &SEAS3)

/*? SEND TO IFS ?*/
             CALL       PGM(WEB_HTML) PARM('HTMLOUTF' 'FINISHED.HTM')
             CALL       PGM(WEB_CSV) PARM('FINISHOUT' 'FNSH_AV.CSV')

 EOJ:        ENDPGM
