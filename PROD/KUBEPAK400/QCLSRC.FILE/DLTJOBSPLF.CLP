             PGM        PARM(&FILENAME &JOBNAME &JOBUSER &JOBNUMB)
             DCL        VAR(&FILENAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNUMB) TYPE(*CHAR) LEN(6)

 LOOP:       DLTSPLF    FILE(&FILENAME) JOB(&JOBNUMB/&JOBUSER/&JOBNAME) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(EOJ))
             GOTO       CMDLBL(LOOP)

 EOJ:        ENDPGM
