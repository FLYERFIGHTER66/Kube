     FFCUTLOT   UF   E           K DISK
     FFMINVT    IF   E           K DISK
     C     NXT           TAG
     C                   READ      FCUTLOT                                90
     C   90              GOTO      END
     C     MINKEY        KLIST
     C                   KFLD                    CLITEM
     C                   KFLD                    CLSIZE
     C     MINKEY        CHAIN     FMINVT                             92
     C  N92              MOVEL     IMLOOK        CLLOOK
     C                   Z-ADD     0             CLQTOO
     C                   UPDATE    RCUTLOT
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
