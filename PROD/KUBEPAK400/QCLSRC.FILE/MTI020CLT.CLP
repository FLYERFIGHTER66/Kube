             PGM

             DCLF       FILE(LSOUTPUT)
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEMB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PROD) TYPE(*CHAR) LEN(1) VALUE('N')

             QSYS/RTVOBJD OBJ(MTDROPSHIP) OBJTYPE(*FILE) RTNLIB(&LIBR)
             IF         COND(&LIBR = 'TGMSDATA') THEN(CHGVAR +
                          VAR(&PROD) VALUE('Y'))
             QSYS/RTVOBJD OBJ(MTI020CL) OBJTYPE(*PGM) RTNLIB(&LIBR)

             CLRPFM     FILE(&LIBR/QFTPSRC) MBR(MTI020LOG1)
             OVRDBF     FILE(INPUT) TOFILE(&LIBR/QFTPSRC) +
                          MBR(MTI020FTP1)
             OVRDBF     FILE(OUTPUT) TOFILE(&LIBR/QFTPSRC) +
                          MBR(MTI020LOG1)
             FTP        RMTSYS(SERVERNOTFOUND)


             CLRPFM     FILE(&LIBR/QFTPSRC) MBR(MTI020FTP2)
             CLRPFM     FILE(&LIBR/QFTPSRC) MBR(MTI020LOG2)
             OVRDBF     FILE(INPUT) TOFILE(&LIBR/QFTPSRC) +
                          MBR(MTI020FTP2)
             OVRDBF     FILE(OUTPUT) TOFILE(&LIBR/QFTPSRC) +
                          MBR(MTI020LOG2)
             CALL       PGM(MTI020) PARM(&PROD)
             FTP        RMTSYS(SERVERNOTFOUND)

 LOOP01:     RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDLOOP01))

             MOVDOC     FROMDOC(&LSOUTPUT) +
                          FROMFLR('FTP/VF000477/SEND') +
                          TOFLR('FTP/VF000477/SENT')
             CHGVAR     VAR(&MEMB) VALUE('MT' || %SST(&LSOUTPUT +
                          1 8))
             CPYF       FROMFILE(&LIBR/QFTPSRC) +
                          TOFILE(ARCHIVE/QFTPSRCMT) +
                          FROMMBR(MTI020LOG2) TOMBR(&MEMB) +
                          MBROPT(*ADD) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(LOOP01)
 ENDLOOP01:
             ENDPGM
