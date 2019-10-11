             PGM        PARM(&PRINTER)
             DCL        VAR(&PRINTER) TYPE(*CHAR)

             SNDMSG     MSG('Holding the Output Que') TOUSR(*REQUESTER)
             HLDOUTQ    OUTQ(&PRINTER)
             MONMSG     MSGID(CPF3426)

             SNDMSG  MSG('Ending the Writer')      TOUSR(*REQUESTER)
             ENDWTR     WTR(&PRINTER) OPTION(*IMMED)
             MONMSG     MSGID(CPF3313)

             SNDMSG  MSG('Varying Off the configuration Object') TOUSR(*REQUESTER)
             VRYCFG     CFGOBJ(&PRINTER) CFGTYPE(*DEV) STATUS(*OFF)
             MONMSG     MSGID(CPD2640)

             DLYJOB     DLY(2)

             SNDMSG  MSG('Resetting the configuration Object')   TOUSR(*REQUESTER)
             VRYCFG     CFGOBJ(&PRINTER) CFGTYPE(*DEV) STATUS(*ON)

             SNDMSG  MSG('Starting the Printer Writer') TOUSR(*REQUESTER)
             STRPRTWTR  DEV(&PRINTER)

             SNDMSG  MSG('Releasing the Output Que') TOUSR(*REQUESTER)
             RLSOUTQ    OUTQ(&PRINTER)

             SNDMSG  MSG('Working with Output in the Que') TOUSR(*REQUESTER)
             WRKOUTQ    OUTQ(&PRINTER)

