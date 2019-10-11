      *
      *
     FKPPODT    UP   E           K DISK
     FFMINVT    IF   E           K DISK
      *
     C     IMKEY         CHAIN     FMINVT                             99
     C     *IN99         IFEQ      *OFF
     C                   MOVEL     IMLOOK        DDLOOK
     C                   UPDATE    DGDTL
     C                   ENDIF
     CSR   *INZSR        BEGSR
      *
      *
      * Define Key Lists ?
      *
      * ?KLIST for ITEM MASTER FILE
      *
     C     IMKEY         KLIST
     C                   KFLD                    DDITEM
     C                   KFLD                    DDSIZE
      *
     CSR                 ENDSR
