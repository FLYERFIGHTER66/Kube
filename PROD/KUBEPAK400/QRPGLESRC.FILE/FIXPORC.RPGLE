      *
      *
     FKPPORC    UP   E           K DISK
     FFMINVT    IF   E           K DISK
      *
     C     IMKEY         CHAIN     FMINVT                             99
     C     *IN99         IFEQ      *OFF
     C                   MOVEL     IMLOOK        DRLOOK
     C                   UPDATE    DGREC
     C                   ENDIF
     CSR   *INZSR        BEGSR
      *
      *
      * Define Key Lists ?
      *
      * ?KLIST for ITEM MASTER FILE
      *
     C     IMKEY         KLIST
     C                   KFLD                    DRITEM
     C                   KFLD                    DRSIZE
      *
     CSR                 ENDSR
