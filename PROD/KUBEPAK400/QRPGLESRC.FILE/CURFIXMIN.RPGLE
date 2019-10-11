      *--------------------------------------------------------------
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- FXMINVT
      *SYSTEM-------------- INVENTORY
      *APPLICATION--------- FIX MINVT - CHANGE FOR EACH FIX
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMINVTVL  IP   E           K DISK
     FFMINVT    UF   E           K DISK
     F                                     RENAME(RMINVT:MASTR)
     FFCUTSEQ   O  A E           K DISK
      *
     C                   MOVEL     IMITEM        ITEM             12
     C                   MOVEL     IMSIZE        SIZE              3
     C     IMKEY         CHAIN     FMINVT                             99
     C     *IN99         IFEQ      *OFF
     C                   MOVEL     VITM          SVVITM           30
     C                   MOVEL     VITM          IMVITM
     C                   Z-ADD     VITM          CSSEQ#
     C                   UPDATE    MASTR
     C                   UNLOCK    FMINVT
     C                   MOVE      'CUT'         SIZE
     C     IMKEY         CHAIN     FMINVT                             98
     C     *IN98         IFEQ      *OFF
     C                   MOVEL     SVVITM        IMVITM
     C                   MOVEL     IMDES1        CSNAME
     C                   MOVEL     IMLOOK        CSLOOK
WJB  C                   MOVEL     IMVEND        CSVEND
     C                   UPDATE    MASTR
     C                   UNLOCK    FMINVT
     C                   WRITE     RCUTSEQ
     C                   ENDIF
     C                   ENDIF
     C                   ADD       2             VITM
      ********************************************************************
     CSR   *INZSR        BEGSR
      *****
      * Define Key Lists ?
      * ?Item Master File Key                                      ? *
     C     IMKEY         KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C                   KFLD                    LOC
     C                   MOVE      *BLANKS       LOC               3
     C                   Z-ADD     101           VITM              4 0
     CSR                 ENDSR
