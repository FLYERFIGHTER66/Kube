      *
     FFMINVT    IF   E           K DISK
     FFPTABLE   IF   E           K DISK
      *
     D  WksCount       S              1S 0
      *
    ?C     ItemKey       CHAIN     FMINVT                             10
     C   10              Eval      *InLR = *On
     C   10              Return
      *? If item is transplanted then make the GERM = 100%
     C     IMTPSW        IFEQ      'P'
     C     IMFRSZ        ANDGT     *BLANKS
     C                   Eval      GERM = 1
     C                   Else
    ?C                   ExSr      GetFactor
     C                   END
     C                   Eval      *InLR = *On
     C                   Return

      *?  ...........................................................
      *?  :      GetFactor - Get Germ rate from Factor Table        :
      *?  :.........................................................:
     C     GetFactor     BegSr
     C                   Eval      GERM = 1
    ?C     IMFTAB        CHAIN     FPTABLE
     C                   If        %Found(FPTABLE) and PTSTAT <> 'D'
     C                   Eval      GERM = 1 - (%Int(%Trim(
     C                             %Subst(PTDESC:%Scan('%':PTDESC)-3:3)))/100)
     C                   EndIf
     C                   EndSr
      *?  ...........................................................
      *?  :      GetFactor - Get Germ rate from Factor Table        :
      *?  :.........................................................:
     C     *INZSR        BegSr
    ?C     *Entry        PList                                                   Parameters
    ?C                   Parm                    Item             12            ?Item
    ?C                   Parm                    Size              3            ?Size
    ?C                   Parm                    Germ              5 4          ?Germ Rate
    ?C     ItemKey       KList
    ?C                   KFld                    Item
    ?C                   KFld                    Size
     C                   EndSr
