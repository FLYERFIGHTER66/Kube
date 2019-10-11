     FGETAMTFM  CF   E             WORKSTN
     C     NXT           TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
     C                   CALL      'GETAMONT'
     C                   PARM                    AMOUNT           11 2
     C                   PARM                    CWORD            80
     C                   PARM                    ##ERR             1
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
