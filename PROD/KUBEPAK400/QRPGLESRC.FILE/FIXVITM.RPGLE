      *
      *
     FKPVITM    UP   E           K DISK
     FFMINVT    IF   E           K DISK
      *
     C     VMKEY         CHAIN     FMINVT                             99
     C     *IN99         IFEQ      *OFF
     C                   MOVEL     IMLOOK        DILOOK
     C                   UPDATE    DGITEMR
     C                   ENDIF
     CSR   *INZSR        BEGSR
      *
      *
      * Define Key Lists ?
      *
      * ?KLIST for ITEM MASTER FILE
      *
     C     VMKEY         KLIST
     C                   KFLD                    DIPITM
     C                   KFLD                    DISIZE
      *
     CSR                 ENDSR
