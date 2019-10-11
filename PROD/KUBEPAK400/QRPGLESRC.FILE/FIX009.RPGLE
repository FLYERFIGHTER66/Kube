     FFTRAYC    UP   E             DISK
     FFMINVT    IF   E           K DISK

     D  SaveItemSize   S             15A
     D  GoodAlpha      S               N

     C     ItemSize      KList
     C                   KFld                    TRITEM
     C                   KFld                    TRSIZE

     C                   If        TRITEM + TRSIZE <> SaveItemSize
     C                   Eval      SaveItemSize = IMITEM + IMSIZE
     C     ItemSize      Chain     FMINVT
     C                   If        %Found(FMINVT)
     C                   Eval      GoodAlpha = *On
     C                   Else
     C                   Eval      GoodAlpha = *Off
     C                   EndIf
     C                   EndIf

     C                   If        GoodAlpha and TRALPH <> IMLOOK
     C                   Eval      TRALPH = IMLOOK
     C                   Update    RTRAY
     C                   EndIf
