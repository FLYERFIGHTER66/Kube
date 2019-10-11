     FFSERIES   UF   E           K DISK
      ** READ
     C     NXT           TAG
     C                   READ      FSERIES                                90
     C   90              GOTO      END
     C                   MOVEL     SECODE        TST3              4
     C     SETYPE        IFLE      *BLANKS
     C                   MOVEL     'A    '       SETYPE
     C                   UPDATE    RSERIES
     C                   END
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
