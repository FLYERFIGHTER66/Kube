     FPC_FMINVT IP   E             DISK    Prefix(PC_) Rename(RMINVT:PC_INVT)
     FFMINVT    UF   E           K DISK

     C     ItemKey       KList
     C                   KFld                    PC_IMITEM
     C                   KFld                    PC_IMSIZE

     C     ItemKey       Chain     FMINVT
     C                   If        %Found(FMINVT)

     C                   Eval      IMBD1    = PC_IMBD1
     C                   Eval      IMED1    = PC_IMED1
     C                   Eval      IMWG1    = PC_IMWG1
     C                   Eval      IMBD2    = PC_IMBD2
     C                   Eval      IMED2    = PC_IMED2
     C                   Eval      IMWG2    = PC_IMWG2
     C                   Eval      IMED3    = PC_IMED3
     C                   Eval      IMBD3    = PC_IMBD3
     C                   Eval      IMWG3    = PC_IMWG3
     C                   Eval      IMBD4    = PC_IMBD4
     C                   Eval      IMED4    = PC_IMED4
     C                   Eval      IMWG4    = PC_IMWG4
     C                   Eval      IMSOWC   = PC_IMSOWC
     C                   Eval      IMTRYC   = PC_IMTRYC
     C                   Eval      IMLOC    = PC_IMLOC
     C                   Eval      IM#SED   = PC_IM#SED
     C                   Eval      IMTPSW   = PC_IMTPSW

     C                   Update    RMINVT
     C                   EndIf
