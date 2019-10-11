             PGM

             DCL        VAR(&FROMLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('TGMSDATA  ')
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('TESTDATA  ')
             DCL        VAR(&NBRCURRCD) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCLF       FILE(PS2013FILE)

 LOOP1:      RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END_LOOP1))

             RTVMBRD    FILE(&FROMLIB/&PROJFILE) NBRCURRCD(&NBRCURRCD)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(LOOP1))
             IF         COND(&NBRCURRCD *EQ 0) THEN(GOTO CMDLBL(LOOP1))

             SBMJOB     CMD(CPYF FROMFILE(&FROMLIB/&PROJFILE) +
                          TOFILE(&TOLIB/&PROJFILE) FROMMBR(*ALL) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*MAP *DROP)) +
                          JOB(&PROJFILE) JOBQ(*LIBL/QBATCH2)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(LOOP1)
 END_LOOP1:
             ENDPGM
