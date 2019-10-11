     FFPUTORD   UF   E           K DISK
     C     NXT           TAG
     C                   READ      FPUTORD                                90
     C   90              GOTO      END
     C     PDITEM        IFEQ      '2238'
     C     PDSIZE        ANDEQ     '512'
     C                   Z-ADD     0             PDQSCH
     C                   UPDATE    RPUTORD
     C                   END
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
