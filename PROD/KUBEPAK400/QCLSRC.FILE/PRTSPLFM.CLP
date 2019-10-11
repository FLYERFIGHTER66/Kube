             PGM        PARM(&SPLF &JOB# &NUMB &COPY &PRTR &HOLD &SAVE)

             DCL        VAR(&SPLF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NUMB) TYPE(*CHAR) LEN(06)
             DCL        VAR(&COPY) TYPE(*CHAR) LEN(03)
             DCL        VAR(&PRTR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HOLD) TYPE(*CHAR) LEN(04)
             DCL        VAR(&SAVE) TYPE(*CHAR) LEN(04)

             SNDNETSPLF FILE(&SPLF) TOUSRID((BILLB KUBE400)) +
                          SPLNBR(&NUMB)












             ENDPGM
