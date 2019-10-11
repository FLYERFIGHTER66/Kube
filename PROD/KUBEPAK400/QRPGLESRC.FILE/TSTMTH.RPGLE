     FTSTMTHFM  CF   E             WORKSTN
     C     NXT           TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
     C                   CALL      '@DTBACK'
     C                   PARM                    ##MDY
     C                   PARM                    ##MTHS            3 0
     C                   PARM                    ##NMDY            6 0
     C                   PARM                    ##ERR             1
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
