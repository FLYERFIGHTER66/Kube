             PGM

/*? FUTURE ?*/
             CLRPFM     FILE(READYFW)
             CLRPFM     FILE(READYFWDSC)

             CALL       PGM(WEB031)
             CALL       PGM(WEBBUILD03) /* Builds website HTML. */

             RGZPFM     FILE(READYFW) KEYFILE(READYFWDES READYFWDES)
             MONMSG     MSGID(CPF0000)

             CPYF       FROMFILE(READYFW) TOFILE(READYFWDSC) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)

/*? SEND TO IFS ?*/
             CALL       PGM(WEB_HTML) PARM('HTMLOUTN' 'FUTURE.HTM')
             CALL       PGM(WEB_HTML) PARM('HTMLOUTNP' 'FUTUREP.HTM')
             CALL       PGM(WEB_HTML) PARM('HTMLOUTNH' 'FUTUREHD.HTM')
             CALL       PGM(WEB_CSV) PARM('READYFWDSC' 'FUTURE.CSV  ')

 EOJ:        ENDPGM
