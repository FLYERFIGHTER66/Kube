    ?H/COPY QFunctDefn,@CopyRight
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
     FFPTABLE   IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FTEST_SF   O  A E           K DISK    USROPN

     D  Item           S                   Like(IMITEM)
     D  Size           S                   Like(IMSIZE)
     D  Table          S                   Like(IMFTAB)
     D  Order          S              7S 0
     D  ToSow          S              7S 0
     D  x              S              3S 0
     D  y              S              3S 0
     D  Fixers         S              7S 0
     D  Test           S              7S 0

    ?D/COPY QFunctDefn,QCMDEXC

    ?C                   Read      FPTABLE
     C                   DoW       not %EOF(FPTABLE)
     C                   Eval      x = *Zero
     C                   Eval      Table = PTABID

     C                   DoU       X > 250
     C                   Eval      x = x + 1
     C                   Eval      Order = x
    ?C                   Call      '#SOWFACTOR'
    ?C                   Parm                    Item
    ?C                   Parm                    Size
    ?C                   Parm                    Table
    ?C                   Parm                    Order
    ?C                   Parm                    ToSow
     C                   Eval      FIXERS = ToSow - Order
     C                   Eval      Rate = FIXERS / ORDER
    ?C                   Write     TESTSFR
     C                   EndDo

    ?C                   Read      FPTABLE
     C                   EndDo
      *? If range not found, then return
     C                   ExSr      ExitSr

      *?  ...........................................................
      *?  :      ExitSR - Exit Subroutine                           :
      *?  :.........................................................:
    ?C     ExitSR        BegSr                                                  ?

     C                   CLOSE     TEST_SF
     C                   Eval      *InLR = *On
     C                   Return

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      InzSR - Initialization Subroutine                  :
      *?  :.........................................................:
    ?C     *InzSR        BegSr                                                  ?

     C                   Eval      Item = *Blanks
     C                   Eval      Size = *Blanks

    ?C     ItemSize      KList
    ?C                   KFld                    Item
    ?C                   KFld                    Size

    ?C     ItemSize      Chain     FMINVT

     C                   If        not %Found(FMINVT) or not %Found(FPTABLE)
     C*                  ExSr      ExitSr
     C                   EndIf

     C                   CallP     QCmdExc('CLRPFM FILE(*LIBL/TEST_SF) -
     C                             MBR(TEST_SF)': 42)
     C                   Open      TEST_SF

    ?C                   EndSr                                                  ?
