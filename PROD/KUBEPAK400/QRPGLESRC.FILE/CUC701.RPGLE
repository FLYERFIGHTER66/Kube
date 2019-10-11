     FFCUTVEND  IP   E           K DISK
     FFCUTCTL   UF A E           K DISK

     D  CO#            S                   Like(CCCONO) Inz(1)

     C     VendCo#       Chain     FCUTCTL
     C                   Eval      CCNXTO = 1
     C                   Eval      CCTXFR = 'Y'
     C                   Eval      CCLSYR = *Zero
     C                   If        not %Found(FCUTCTL)
     C                   Eval      CCCONO = 1
     C                   Eval      CCVEND = CVVEND
     C                   Write     RCUTCTL
     C                   Else
     C                   Update    RCUTCTL
     C                   EndIf

     C     *INZSR        BEGSR
     C     VendCo#       KList
     C                   KFld                    CO#
     C                   KFld                    CVVEND
     C                   ENDSR
