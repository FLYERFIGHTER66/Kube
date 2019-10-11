             PGM        PARM(&TOMSGQ &MSG)
             DCL        VAR(&MSG)      TYPE(*CHAR) LEN(480)
             DCL        VAR(&TOMSGQ)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATETIME) TYPE(*CHAR) LEN(20)

             MONMSG     MSGID(CPF0000)

             RTVJOBA    JOB(&JOB) USER(&USER) DATETIME(&DATETIME)

             SNDBRKMSG  MSG('Timestamp: ' *CAT &DATETIME *CAT ' +
                          User: ' *CAT &USER *CAT ' Job:' *CAT &JOB +
                          *CAT ' Sends Message:' *CAT &MSG) +
                          TOMSGQ(&TOMSGQ)

             ENDPGM
