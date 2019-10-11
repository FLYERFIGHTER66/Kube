    ?H/COPY QFunctDefn,@CopyRight
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)

      *??:````````````````````````````````````````````````````````````:?
      *??:                  Calculate Sow Factor                      :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  July, 2006           ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? :  xxxxxxxxx-?xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  xx - xx ?xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFMINVT    IF   E           K DISK

     D  Item           S                   Like(IMITEM)
     D  Size           S                   Like(IMSIZE)
     D  Seed           S                   Like(IMSIZE) Inz('SED')
     D  OverSow        S                   Like(IMMULT) Inz(*Zero)
     D  SeedCalled     S              7S 0
     D  SeedNeeded     S              7S 0

     C                   Eval      SeedNeeded = SeedCalled * (1+(OverSow/100))
     C                   ExSr      ExitSR


      *?  ...........................................................
      *?  :      ExitSR - Exit Subroutine                           :
      *?  :.........................................................:
    ?C     ExitSR        BegSr                                                  ?

     C                   Eval      *InLR = *On
     C                   Return

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      InzSR - Initialization Subroutine                  :
      *?  :.........................................................:
    ?C     *InzSR        BegSr                                                  ?

    ?C     *Entry        PList
    ?C                   Parm                    Item
    ?C                   Parm                    Size
    ?C                   Parm                    SeedCalled
    ?C                   Parm                    SeedNeeded

     C                   Eval      SeedNeeded = SeedCalled

    ?C     ItemSeed      KList
    ?C                   KFld                    Item
    ?C                   KFld                    Seed
    ?C     ItemSeed      Chain     FMINVT
     C                   Eval      OverSow = IMMULT

    ?C     ItemSize      KList
    ?C                   KFld                    Item
    ?C                   KFld                    Size
    ?C     ItemSize      Chain     FMINVT
     C                   If        IMMULT <> 0
     C                   Eval      OverSow = IMMULT
     C                   EndIf

     C                   If        not %Found(FMINVT)
     C                   ExSr      ExitSr
     C                   EndIf

    ?C                   EndSr                                                  ?
