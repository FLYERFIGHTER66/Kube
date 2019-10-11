     FFSERPRC   UF   E           K DISK
     FFMVEND    IF   E           K DISK
      ** READ
     C     NXT           TAG
     C                   READ      FSERPRC                                90
     C   90              GOTO      END
     C     SPVEND        IFEQ      95
     C                   Z-ADD     390           SPVEND
     C                   END
     C     SPVEND        CHAIN     FMVEND                             55
     C  N55              DO
     C                   MOVEL     VMLOOK        SPVALP
     C                   UPDATE    RSERPRC
     C                   ENDDO
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
