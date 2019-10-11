     FFCART     UF   E           K DISK
     C     NXT           TAG
     C                   READ      FCART                                  90
     C   90              GOTO      END
     C                   Z-ADD     0             CTORD#
     C                   Z-ADD     0             CTSEQ#
     C                   MOVE      *BLANKS       CTLOC
     C                   UPDATE    RCART
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
