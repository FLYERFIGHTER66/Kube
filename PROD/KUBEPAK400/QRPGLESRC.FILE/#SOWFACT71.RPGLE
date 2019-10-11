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

     FFPTABLE   IF   E           K DISK
     FFMINVT    IF   E           K DISK

     D  Item           S                   Like(IMITEM)
     D  Size           S                   Like(IMSIZE)
     D  Table          S                   Like(IMFTAB)
     D  Order          S              7S 1
     D  ToSow          S              7S 1
     D  x              S              2S 0
     D  Fixers         S              7S 1
     D  Test           S              7S 1

     D  UseUnits       S               N   Inz(*off)
     D  UsePercent     S               N   Inz(*off)

     D  BEGQTY_DS      DS
     D  PTBQ01
     D  PTBQ02
     D  PTBQ03
     D  PTBQ04
     D  PTBQ05
     D  PTBQ06
     D  PTBQ07
     D  PTBQ08
     D  PTBQ09
     D  PTBQ10
     D  PTBQ11
     D  PTBQ12
     D  BEGQTY                        7S 0 Dim(12) overlay(BEGQTY_DS)

     D  ENDQTY_DS      DS
     D  PTEQ01
     D  PTEQ02
     D  PTEQ03
     D  PTEQ04
     D  PTEQ05
     D  PTEQ06
     D  PTEQ07
     D  PTEQ08
     D  PTEQ09
     D  PTEQ10
     D  PTEQ11
     D  PTEQ12
     D  ENDQTY                        7S 0 Dim(12) overlay(ENDQTY_DS)

     D  UNITS_DS       DS
     D  PTUN01
     D  PTUN02
     D  PTUN03
     D  PTUN04
     D  PTUN05
     D  PTUN06
     D  PTUN07
     D  PTUN08
     D  PTUN09
     D  PTUN10
     D  PTUN11
     D  PTUN12
     D  UNITS                         5S 0 Dim(12) overlay(UNITS_DS)

     D  PERCENT_DS     DS
     D  PTPE01
     D  PTPE02
     D  PTPE03
     D  PTPE04
     D  PTPE05
     D  PTPE06
     D  PTPE07
     D  PTPE08
     D  PTPE09
     D  PTPE10
     D  PTPE11
     D  PTPE12
     D  PERCENT                       5S 2 Dim(12) overlay(PERCENT_DS)

     C                   ExSR      Range
     C                   ExSR      Type

     C                   If        UseUnits
     C                   Eval      Fixers = Units(x)
     C                   EndIf

     C                   If        UsePercent
     C                   Eval      Fixers = %Int(((Order*Percent(x))/100)+.999)
     C                   EndIf

      *?  Check to see if order quantity yeilds higher # of fixers
     C                   If        x > 1
     C                   If        Fixers < (ENDQTY(x-1)*(Percent(x-1)/100))
     C                   Eval      Fixers=%Int((ENDQTY(x-1)*(Percent(x-1)/100)))
     C                   EndIf
     C                   EndIf

     C                   Eval      ToSow = %Int(Order + Fixers)
     C                   If        %Int(Order + Fixers) <> (Order + Fixers)
     C                   Eval      ToSow = ToSow + 1
     C                   EndIf

     C                   ExSR      ExitSR


      *?  ...........................................................
      *?  :      Range - Find what range the quantity is in         :
      *?  :.........................................................:
    ?C     Range         BegSr                                                  ?

      *? Find which range to use
     C                   Do        12
     C                   Eval      x = x + 1
     C                   If        Order >= BegQty(x) and
     C                             Order <= EndQty(x)
     C                   LeaveSR                                                ?Leave SR when found
     C                   EndIf
     C                   EndDo
      *? If range not found, then return
     C                   ExSr      ExitSr

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Type - Determine if Units or Percent is used.      :
      *?  :.........................................................:
    ?C     Type          BegSr                                                  ?

    ?C                   Select

    ?C                   When      Units(x) <> 0  and Percent(x) <> 0
     ?*    Error
     C                   ExSr      ExitSr

    ?C                   When      Units(x) =  0  and Percent(x) =  0
     ?*    Error
     C                   ExSr      ExitSr

    ?C                   When      Units(x) <> 0
     ?*    Use Units
     C                   Eval      UseUnits = *On

    ?C                   When      Percent(x) <> 0
     ?*    Use Percent
     C                   Eval      UsePercent = *On

    ?C                   EndSl                                                  ?

    ?C                   EndSr                                                  ?


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
    ?C                   Parm                    Table
    ?C                   Parm                    Order
    ?C                   Parm                    ToSow

     C                   Eval      ToSow = Order

    ?C     ItemSize      KList
    ?C                   KFld                    Item
    ?C                   KFld                    Size

     C                   If        Item <> *Blanks
    ?C     ItemSize      Chain     FMINVT
     C                   Else
     C                   Eval      IMFTAB = Table
     C                   EndIf
    ?C     IMFTAB        Chain     FPTABLE

     C                   If        (not %Found(FMINVT) and Item <> *Blanks ) or
     C                             not %Found(FPTABLE)
     C                   ExSr      ExitSr
     C                   EndIf

    ?C                   EndSr                                                  ?
