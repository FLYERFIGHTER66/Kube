     FFCUTORD   UF   E           K DISK
     C     NXT           TAG
     C                   READ      FCUTORD                                90
     C   90              GOTO      END
     C     COORD#        IFEQ      150
     C     COTRAN        ANDEQ     'N'
     C                   DELETE    RCUTORD
     C                   END
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
