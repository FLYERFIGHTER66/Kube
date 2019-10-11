     FTSTGETLOTFCF   E             WORKSTN
     FFMINVT    IF   E           K DISK
     C                   EXFMT     TST01
     C                   If        *In03
     C                   Eval      *InLR = *On
     C                   Return
     C                   EndIf
     C     IMITEM        SETLL     FMINVT
     C                   CALL      'GETLOT'
     C                   PARM                    OIORD#            6 0
     C                   PARM                    OISEQ#            3 0
     C                   PARM                    OIDTRQ            6 0
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    QTYORD
     C                   PARM                    QTYAL
     C                   PARM                    FLAG              1
