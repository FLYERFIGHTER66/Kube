     FFPTORDC   UF   E           K DISK
     C     NXT           TAG
     C                   READ      FPTORDC                                90
     C   90              GOTO      END
     C     PTSHPD        IFLT      1020407
     C                   DELETE    RPTORDC
     C                   END
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
