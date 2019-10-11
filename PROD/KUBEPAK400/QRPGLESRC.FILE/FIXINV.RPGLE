      *
      *
     FFSOWSCHJ  IP   E           K DISK
     FFMINVT    UF   E           K DISK
     FKPITMWHS  UF   E           K DISK
      *
     D                 DS
     D  SOSOWD                 1      7  0
     D  YYMMDD                 2      7  0
     D  YY                     2      3  0
     C     SOSTAT        IFEQ      'C'
     C                   Z-ADD     YYMMDD        SOWDTE            8 0
     C     YY            IFGE      00
     C     YY            IFLT      05
     C                   MOVEL     20            SOWDTE
     C                   ELSE
     C                   MOVEL     19            SOWDTE
     C                   ENDIF
     C                   ENDIF
     C     SOWDTE        IFGE      20031117
     C     SOCELL        MULT      SO#SED        SEEDS            11 1
     C     SEEDS         MULT      SOSOWQ        SEEDS
     C     SEEDS         MULT(H)   .07           ADDON            11 0
     C                   ADD       ADDON         SEEDS
     C     ITMKEY        CHAIN     FMINVT                             99
     C     *IN99         IFEQ      *OFF
     C     IMQTOH        SUB       SEEDS         IMQTOH
     C     IMQTAV        SUB       SEEDS         IMQTAV
     C     IMISSU        ADD       SEEDS         IMISSU
     C     IMQTOH        IFLT      0
     C                   Z-ADD     0             IMQTOH
     C                   ENDIF
     C     IMQTAV        IFLT      0
     C                   Z-ADD     0             IMQTAV
     C                   ENDIF
     C                   UPDATE    RMINVT
     C                   ENDIF
     C     WHSKEY        CHAIN     KPITMWHS                           99
     C     *IN99         IFEQ      *OFF
     C     IWQTOH        SUB       SEEDS         IWQTOH
     C     IWQTOH        IFLT      0
     C                   Z-ADD     0             IWQTOH
     C                   ENDIF
     C                   UPDATE    ITMWHSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     CSR   *INZSR        BEGSR
      *
      * Define Key Lists ?
      *
      *
     C     ITMKEY        KLIST
     C                   KFLD                    SOITEM
     C                   KFLD                    SIZE
     C                   KFLD                    SOWHSE
     C                   MOVE      *BLANKS       SOWHSE            3
     C     WHSKEY        KLIST
     C                   KFLD                    SOITEM
     C                   KFLD                    SIZE
     C                   KFLD                    ITMWHS
     C                   Z-ADD     1             ITMWHS            2 0
     C                   MOVE      'SED'         SIZE              3
     C                   ENDSR
