    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         GET SOW DATE FROM REQUESTED DATE                   :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Oct. 2008            ? Kube-Pak Corporation ?    :
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
      *? :  Scrn01   -?Display Screen 01                             ?:
      *? :  Load01   -?Load Screen 01                                ?:
      *? :  Edit01   -?EDIT Screen 01                                ?:
      *? :  $ClrError-?Clear Error MEssage Subfile                   ?:
      *? :  $SndError-?Send an Error Message to the PGMMSGQ          ?:
      *? :  $SRMSGF  -?Clear or send messages to Pgm msg queue       ?:
      *? :  *INZSR   -?Initialization Subroutine                     ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  01 - 24 ?Return Screen Functions                         ?:
      *? :  03      ?Exit                                            ?:
      *? :  06      ?Restart                                         ?:
      *? :          ?                                                ?:
      *? :............................................................:
      *
     FFMINVT    IF   E           K DISK
     FGETGERFM  CF   E             WORKSTN

      *? Copy Books
    ?D/COPY QFunctDefn,$ErrMsg

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Center
    ?D/COPY QFunctDefn,$WeekDay
    ?D/COPY QFunctDefn,$Week#
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$IsDate#
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$Duration
    ?D/COPY QFunctDefn,QCmdExc
      /Free
        dcl-pr INVAVLSTS   extpgm('INVAVLSTS');
          ThisItem Char(12) const;   // Item
          ThisSize Char(3)  const;   // Size
          ThisDate Date     const;   // Ready Date
          ThisType Char(10) const;   // PLUG_CTL_TYPE
          ErrorNumber Zoned(1:0);    // ERROR NUMBER
          ErrorDescription Char(35); // ERROR DESCRIPTION
        end-pr;

        Dcl-Pr GETAVLINV Extpgm('GETAVLINV');           // Rpg Program
          Item      Char(12)    Const;                 // Item
          Size      Char(3)     Const;                 // Size
          ReqDate   Date        Const;                 // ReqShipDate
          ReqQty    Zoned(11:2) Const;                 // Requested Qty
          AvlQty    Zoned(11:2);                       // Available Qty
          IMLOTC    Char(1);                           // Lot Control Flag
          ReqPartial    ind     Const;                 // Allocation Request is for a Partial Tray
        End-Pr;
      /End-Free

     D  SowDates       DS
     D  Sow001
     D  Sow002
     D  Sow003
     D  Sow004
     D  Sow005
     D  Sow006
     D  Sow007
     D  Sow008
     D  Sow009
     D  Sow010
     D   SowDate                      6S 0 DIM(10) Overlay(SowDates)

     D  SWkWeeks       DS
     D  SWk001
     D  SWk002
     D  SWk003
     D  SWk004
     D  SWk005
     D  SWk006
     D  SWk007
     D  SWk008
     D  SWk009
     D  SWk010
     D   SowWk#                       2S 0 DIM(10) Overlay(SWkWeeks)

     D  RdyDates       DS
     D  Rdy001
     D  Rdy002
     D  Rdy003
     D  Rdy004
     D  Rdy005
     D  Rdy006
     D  Rdy007
     D  Rdy008
     D  Rdy009
     D  Rdy010
     D   RdyDate                      6S 0 DIM(10) Overlay(RdyDates)

     D  RWkWeeks       DS
     D  RWk001
     D  RWk002
     D  RWk003
     D  RWk004
     D  RWk005
     D  RWk006
     D  RWk007
     D  RWk008
     D  RWk009
     D  RWk010
     D   RdyWk#                       2S 0 DIM(10) Overlay(RWkWeeks)

     D  Wk2GermDS      DS
     D  Wks001
     D  Wks002
     D  Wks003
     D  Wks004
     D  Wks005
     D  Wks006
     D  Wks007
     D  Wks008
     D  Wks009
     D  Wks010
     D   Wk2Germ                      3S 0 DIM(10) Overlay(Wk2GermDs)

     D  QTYAvlDS       DS
     D  QTY001
     D  QTY002
     D  QTY003
     D  QTY004
     D  QTY005
     D  QTY006
     D  QTY007
     D  QTY008
     D  QTY009
     D  QTY010
     D   QTYAvl                      11S 2 DIM(10) Overlay(QTYAvlDS)

     D  ERRDescDS      DS
     D  ERR001
     D  ERR002
     D  ERR003
     D  ERR004
     D  ERR005
     D  ERR006
     D  ERR007
     D  ERR008
     D  ERR009
     D  ERR010
     D   ERRDesc                     35A   DIM(10) Overlay(ERRDescDs)

      *? Field Definitions
     D   User          S             10A                                        ?Current User ID
     D   Today         S               D                                        ?Todays Date MDY
     D   Now           S               T                                        ?The Time at *Init
     D   Program       S             10A                                        ?Program
     D   Start         S               D                                        ?Starting Date
     D   X             S              2S 0                                      ?Counter
     D   ERR#          S              1S 0                                      ?Error Number
     D   ThisDate      S               D                                        ?Date for IVNAVLSTS

     C     *INLR         DoUEq     *ON                                          ?Do Until Done

    ?C                   SELECT                                                 ?
    ?C     Screen        WhenEq    01                                           ?
    ?C                   ExSr      Edit01                                       ?
    ?C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   If        Screen <> 01
     C                   Z-Add     Screen        PrevScreen        3 0          ?Prev. Screen
     C                   EndIf
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
    ?C                   Write     ASSUME
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     SCRNA                                        ?
    ?C                   ExSr      $ClrError                                    ?
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?
     C                   Clear                   SCRNA
    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Calc01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Calc01        BegSr                                                  ?

     C                   Eval      Start = $AddDate($DateMDY(RDATE):(-4*7))

     C                   Eval      X = 1
     C                   DoW       X <= 10
     C                   Eval      RdyDate(x) = $MDYDate($AddDate(Start:X*7))
     C                   Eval      RdyWk#(x) = $Week#($DateMDY(RdyDate(x)))
     C                   Eval      REQDAT = $Date7($DateMDY(RdyDate(x)))
     C                   CALL      'GETGERM'     GETGERM
     C                   Eval      SowDate(x) = $MDYDate($Date(SOWDAT))
     C                   Eval      SowWk#(x) = $Week#($DateMDY(SowDate(x)))
     C                   Eval      Wk2Germ(x) = $Duration($DateMDY(SowDate(x)):
     C                                          $DateMDY(RdyDate(x)):'D') / 7
      /Free
        InvAvlSts(ITEM:SIZE:$DateMDY(RdyDate(x)):'Kube-Pak':ERR#:ERRDesc(x));
        GETAVLINV(ITEM:SIZE:$DateMDY(RdyDate(x)):99999:QtyAvl(x):IMLOTC:'0');
      /End-Free
     C                   Eval      X = X + 1
     C                   EndDo

     C                   Eval      SDATE = SowDate(4)
     C                   Eval      RDATE = RdyDate(4)

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

    ?C     ITMKEY        CHAIN     FMINVT

    ?C                   Select                                                 ?
    ?C                   When      *In03 or *In07                               ?
     C                   Eval      *InLR = *On

    ?C                   When      %Subst(ITEM:1:1) = '?' or                    ?
    ?C                             %Subst(ITEM:1:1) = '/'                       ?
     C                   Eval      IMLOOK = %Subst(ITEM:2:11)
     C                   MOVE      SIZE          IMSIZE
     C                   CALL      'LKITAL'      LKITAL
     C                   MOVEL     IMITEM        ITEM
     C                   MOVEL     IMSIZE        SIZE
    ?C                   ExSr      Scrn01

    ?C                   When      not %Found(FMINVT)
     C                   Eval      $ERR_MsgID   = 'ITM0001'
     C                   Eval      $ERR_MsgData = ITEM + SIZE
    ?C                   ExSr      $SndError                                    ?
    ?C                   ExSr      Scrn01

    ?C                   When      RDATE = *Zeros                               ?Date is not Valid
     C                   Eval      $ERR_MsgID   = 'DATE902'
     C                   Eval      $ERR_MsgData = 'Requested'
    ?C                   ExSr      $SndError                                    ?
    ?C                   ExSr      Scrn01

    ?C                   When      not $IsDate#(RDATE:'*MDY')                   ?Date is not Valid
     C                   Eval      $ERR_MsgID   = 'DATE901'
     C                   Eval      $ERR_MsgData = %Trim(%Char(RDATE))
    ?C                   ExSr      $SndError                                    ?
    ?C                   ExSr      Scrn01

    ?C                   When      $WeekDay($DateMDY(RDATE):'MON') <> 1         ?Date not a Monday
     C                   Eval      $ERR_MsgID   = 'DATE904'
     C                   Eval      $ERR_MsgData = %EditW(RDATE:'  /  /  ')
     C                   Eval      RDATE  =
     C                             $MDYDate($Monday($DateMDY(RDATE):'SAT'))
     C                   Eval      $ERR_MsgData = %Trim($ERR_MsgData) +
     C                             %EditW(RDATE:'  /  /  ')
    ?C                   ExSr      $SndError                                    ?
    ?C                   ExSr      Scrn01

      *?  After here, all validity checking has to have passed
    ?C                   When      *In08 or *In09                               ?
     C   08              Eval      RDATE  =
     C                             $MDYDate($AddDate($DateMDY(RDATE):-7))
     C   09              Eval      RDATE  =
     C                             $MDYDate($AddDate($DateMDY(RDATE):+7))
    ?C                   ExSr      Calc01
    ?C                   ExSr      Scrn01

    ?C                   When      *In10 or *In11                               ?
     C   10              Eval      RDATE  =
     C                             $MDYDate($AddDate($DateMDY(RDATE):-70))
     C   11              Eval      RDATE  =
     C                             $MDYDate($AddDate($DateMDY(RDATE):+70))
    ?C                   ExSr      Calc01
    ?C                   ExSr      Scrn01

    ?C                   Other

    ?C                   ExSr      Calc01
    ?C                   ExSr      Scrn01

    ?C                   EndSl

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      ERRMSG - Error Message Handling Subroutines        :
      *?  :.........................................................:
    ?D/COPY QFunctDefn,$ErrMsgSr

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C                   Time                    Today
     C                   Time                    Now

     C                   Eval      $ERR_PROG  = 'GETGERMT  '                    ?Pgm Msg Queue
     C                   Eval      $ERR_MSGF  = 'KPMSGF'                        ?Message File
     C                   Eval      $ERR_LIBR  = '*LIBL'                         ?Library

    ?C                   ExSr      $ClrError
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01                                       ?

    ?C     GETGERM       PList
    ?C                   Parm                    IMITEM
    ?C                   Parm                    IMSIZE
    ?C                   Parm                    IMWHSE
    ?C                   Parm                    REQDAT            7 0          CYMD
    ?C                   Parm                    SOWDAT            7 0          CYMD

    ?C     LKITAL        PList
    ?C                   Parm                    IMLOOK
    ?C                   Parm                    IMITEM
    ?C                   Parm                    IMSIZE
    ?C                   Parm                    IMWHSE
    ?C                   Parm                    IMDES1
    ?C                   Parm                    IMDES2
    ?C                   Parm                    IMDES3
    ?C                   Parm                    IMDES4
    ?C                   Parm                    SHPFR             3

    ?C     ITMKEY        KLIST
    ?C                   KFLD                    ITEM
    ?C                   KFLD                    SIZE
    ?C                   KFLD                    IMWHSE

    ?C                   EndSr                                                  ?
