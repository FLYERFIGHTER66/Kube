     FPC_FMINVT IP   E             DISK    Prefix(PC_) Rename(RMINVT:PC_INVT)
     FFMINVT1012IF   E           K DISK    Rename(RMINVT:SAVEINVT)
     FFMINVT    UF   E           K DISK

     C     ItemKey       KList
     C                   KFld                    PC_IMITEM
     C                   KFld                    PC_IMSIZE

     C     ItemKey       Chain     FMINVT
     C     ItemKey       Chain     FMINVT1012
     C                   If        %Found(FMINVT)
     C                   Update    RMINVT
     C                   EndIf
