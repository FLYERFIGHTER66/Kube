             PGM
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

             CHGMSGQ    MSGQ(*USRPRF) DLVRY(*BREAK)
             RTVJOBA    USER(&USER)

             IF         COND(&USER = 'BILLB') THEN(DO)
             DSPMSG     MSGQ(QSYSOPR)
             CHGMSGQ    MSGQ(QSYSOPR) DLVRY(*BREAK)
             WRKACTJOB
             ENDDO

             ENDPGM
