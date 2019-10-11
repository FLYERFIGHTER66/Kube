     FFGLPRE    UF   E             DISK
      ** READ RECORDS
     C     NXT           TAG
     C                   READ      FGLPRE                                 90
     C   90              GOTO      END
     C     GTSTAT        IFEQ      'D'
     C                   MOVEL     'A'           GTSTAT
     C                   UPDATE    RGLPRE
     C                   END
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
