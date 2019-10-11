             PGM        PARM(&CHANGE &PRINTER)

             DCL        VAR(&CHANGE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRINTER) TYPE(*CHAR) LEN(10)

             RUNQRY     QRY(MSTBYCUS) QRYFILE((*SAME)) RCDSLT(&CHANGE)
             RUNQRY     QRY(TRKBYCUS) QRYFILE((*SAME)) RCDSLT(&CHANGE)

             IF         COND(&PRINTER *NE ' ') THEN(OVRPRTF +
                          FILE(QPQUPRFIL) DEV(&PRINTER))
             RUNQRY     QRY(BAL_MS2TR1) QRYFILE((*SAME))
             RUNQRY     QRY(BAL_MS2TR2) QRYFILE((*SAME))

             ENDPGM
