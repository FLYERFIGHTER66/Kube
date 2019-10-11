             PGM

/*? BUILD READYOUT FILE ?*/
             CLRPFM     FILE(READYOUT)
             RUNQRY     QRY(READYLST) QRYFILE((*SAME)) RCDSLT(*NO)

/*?  50'S ?*/
             CLRPFM     FILE(HTMLOUT)
             CALL       PGM(WEBBUILD01) PARM('50 ')
             CALL       PGM(WEB_HTML) PARM(HTMLOUT '50d.htm')
/*?  51'S ?*/
             CLRPFM     FILE(HTMLOUT)
             CALL       PGM(WEBBUILD01) PARM('51 ')
             CALL       PGM(WEB_HTML) PARM(HTMLOUT '51d.htm')
/*? 102'S ?*/
             CLRPFM     FILE(HTMLOUT)
             CALL       PGM(WEBBUILD01) PARM('102')
             CALL       PGM(WEB_HTML) PARM(HTMLOUT '102d.htm')
/*? G05'S ?*/
             CLRPFM     FILE(HTMLOUT)
             CALL       PGM(WEBBUILD01) PARM('G05')
             CALL       PGM(WEB_HTML) PARM(HTMLOUT 'G05d.htm')
/*? 105'S ?*/
             CLRPFM     FILE(HTMLOUT)
             CALL       PGM(WEBBUILD01) PARM('105')
             CALL       PGM(WEB_HTML) PARM(HTMLOUT '105d.htm')
/*? 162'S ?*/
             CLRPFM     FILE(HTMLOUT)
             CALL       PGM(WEBBUILD01) PARM('162')
             CALL       PGM(WEB_HTML) PARM(HTMLOUT '162d.htm')
/*? 288'S ?*/
             CLRPFM     FILE(HTMLOUT)
             CALL       PGM(WEBBUILD01) PARM('288')
             CALL       PGM(WEB_HTML) PARM(HTMLOUT '288d.htm')
/*? 512'S ?*/
             CLRPFM     FILE(HTMLOUT)
             CALL       PGM(WEBBUILD01) PARM('512')
             CALL       PGM(WEB_HTML) PARM(HTMLOUT '512d.htm')
/*? ALL   ?*/
             CLRPFM     FILE(HTMLOUT)
             CALL       PGM(WEBBUILD01) PARM('ALL')
             CALL       PGM(WEB_HTML) PARM(HTMLOUT 'ALLd.htm')
/*? AVAIL.XLS ?*/
             CALL       PGM(WEB_CSV) PARM(READYOUT 'PLUG_AV.CSV')
/*? AVAIL2.XLS ?*/
             CALL       PGM(WEBBUILD1X)
             MONMSG     MSGID(CPF0000) EXEC(DMPCLPGM)
             CALL       PGM(WEB_CSV) PARM(READYPLUG 'PLUG_AV2.CSV')
             MONMSG     MSGID(CPF0000) EXEC(DMPCLPGM)

 EOJ:        ENDPGM
