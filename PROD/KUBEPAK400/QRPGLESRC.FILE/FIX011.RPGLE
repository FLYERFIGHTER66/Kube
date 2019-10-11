     FFIORDR    UP   E             DISK
     FFMINVT    IF   E           K DISK

     D  SaveItemSize   S             15A
     D  FoundItem      S               N

     C     ItemSize      KList
     C                   KFld                    OIITEM
     C                   KFld                    OISIZE

     C                   If        OIITEM + OISIZE <> SaveItemSize
     C                   Eval      SaveItemSize = OIITEM + OISIZE
     C     ItemSize      Chain     FMINVT
     C                   If        %Found(FMINVT)
     C                   Eval      FoundItem = *On
     C                   Else
     C                   Eval      FoundItem = *Off
     C                   EndIf
     C                   EndIf

     C                   If            FoundItem
     C                             and OIPRCL <> IMPCL1
     C                             and OISTAT = 'A'
     C                             and OIITYP = ' '
     C                   Eval      OIPRCL = IMPCL1
     C                   Update    RIORDR
     C                   EndIf
