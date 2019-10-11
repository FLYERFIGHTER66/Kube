     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:            Plug Shipping Layout Tool                       :?
      *??:............................................................:?
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? : Created:  2009                 ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  01 - 24 ?Return Screen Functions                         ?:
      *? :  03      ?Exit                                            ?:
      *? :  06      ?Restart                                         ?:
      *? :          ?                                                ?:
      *? :  25      ?SFLDSP, SFLDSPCTL, SFLCLR(N)                    ?:
      *? :  26      ?SFLDSP (Subfile has Data)                       ?:
      *? :  27      ?SFLEND                                          ?:
      *? :  28      ?SFLNXTCHG                                       ?:
      *? :  40      ?Lookup Indicator                                ?:
      *? :  50      ?Error Indicator (All Errors)                    ?:
      *? :  70      ?Push Buttone Default 70 = Yes, N70 = No         ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FPSR300FM  CF   E             WORKSTN
     F                                     SFILE(PSR30002:RRN02)
     F                                     SFILE(PSR30003:RRN03)
     F                                     DEVID(WSID)

     FFHORDRCD  UF   E           K DISK                                         ?Order Header
     FFHORDR    UF A E           K DISK    Rename(RHORDR:HORDR)                 ?Order Header
     FFPPO      UF A E           K DISK                                         ?Order User Info
     FFIORDR    IF   E           K DISK                                         ?Order Detail
     FFMSIZE    IF   E           K DISK                                         ?Size Code Master
     FFPLGSETDS UF   E           K DISK                                         ?P/S Weekly Setup
     FFPLGSETDA UF   E           K DISK    Rename(RPLGSET:APLGSET)              ?P/S Weekly Setup
     FFPLGSETDO UF A E           K DISK    Rename(RPLGSET:DPLGSET)              ?P/S Weekly Setup
     FFPLGSETO# UF A E           K DISK    Rename(RPLGSET:OPLGSET)              ?P/S Weekly Setup
     FFPLGDFT   UF A E           K DISK                                         ?P/S Setup Defaults
     FFPLGDFTSQ IF   E           K DISK    Rename(RPLGDFT:SQ_PLGDFT)            ?P/S Setup Defaults
     FXATABE1   IF   E           K DISK                                         ?Table File
     FFMCUST    IF   E           K DISK                                         ?Customer Master
     FFMSVIA    IF   E           K DISK                                         ?Ship Via Master
     FFTRSCHDCO IF   E           K DISK                                         ?Truck Schedule
     FFPSECT    IF   E           K DISK                                         ?P/S G/H Avail.
     FFPSECTSQ  IF   E           K DISK    Rename(RPSECT:SQ_PSECT)              ?P/S G/H Avail.
     FFMSIZC    IF   E           K DISK                                         ?SIZE CATEGORIES
     FFPLGSCTL  UF A E           K DISK

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$DotW
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$isDate#
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Week#
    ?D/COPY QFunctDefn,$Year
    ?D/COPY QFunctDefn,QCmdExc
    ?D/COPY QFunctDefn,$CrtHSOrd
    ?D/COPY QFunctDefn,$CrtPSOrd

      *? Arrays
     D   Cmd           S            100A   Dim(0002) CtData                     ?System Commands
     D*  Categ         S              4A   Dim(0006) CtData PerRcd(01)          ?Categories

      *? Data Structures
     D                SDS
     D  ##PGM            *PROC
     D  User                 254    263

      *? Data Areas
     D LDA_DS          DS                  DTAARA(*LDA)
     D  UDSEXT              1000   1000
     D  UDSDAT              1001   1004P 0
     D  UDSTRK              1005   1008

      *? Field Definitions
     D   RRN02         S              4  0 Inz(0)                               ?SFLRRN Screen 02
     D   RRN03         S              4  0 Inz(0)                               ?SFLRRN Screen 03
     D   Today         S               D                                        ?Today
     D   SDate         S              6S 0 Inz(0)                               ?Ship Date MDY
     D   SDateYMD7     S              7S 0 Inz(0)                               ?Ship Date YMD7
     D   PDateYMD7     S              7P 0 Inz(0)                               ?Ship Date YMD7 Pack
     D   TruckDate7    S              7S 0 Inz(0)                               ?Ship Date YMD7
     D   ThisMonday    S              6S 0 Inz(0)                               ?Monday ( MDY )
     D   ThisMonCYMD   S              7S 0 Inz(0)                               ?Monday ( CYMD )
     D   AllOrders0    S              6P 0 Inz(0)                               ?0 = All Orders
     D   ErrCount      S              3S 0 Inz(0)                               ?Error Count
     D   Pink          S              1A   Inz('?')                             ?Color Code for?PINK
     D   Command       S            100A   Inz(*Blanks)                         ?System Command
     D   Included      S               N                                        ?Included in Master
     D   First_Load    S               N                                        ?1st Time for Date/M
     D   New_ShipVia   S               N                                        ?New Ship Via Proces
     D   Small_Trays   S                   Like(PGSMFL)                         ?Small Flats
     D   Large_Trays   S                   Like(PGLGFL)                         ?Large Flats
     D   Last_PGSVIA   S                   Like(PGSVIA)                         ?Last Ship VIA
     D   Save_PGSVIA   S                   Like(PGSVIA)                         ?Save Ship VIA
     D   Hold_PGNAME   S                   Like(PGNAME)                         ?Hold Customer Name
     D   New_Seq       S                   Like(PGSEQ1)                         ?Seq# for New Record
     D   Next_Seq      S                   Like(PGSEQ1)                         ?Next Avail. Seq#
     D   Last_Truck    S                   Like(PGSORT)                         ?Last Truck Processe
     D   SkipShelves   S                   Like(PDSKPS)                         ?Shelves to Skip
     D   Next_Cart#    S                   Like(CARTSEQ#)                       ?Next Cart Seq#
     D   Last_Cart#    S                   Like(CARTSEQ#)                       ?Previous Cart Seq#
     D  Last_CARTUSED  S                   Like(CARTUSED)                       ?Last Cart Type
     D  Last_CARTSEQ#  S                   Like(CARTSEQ#)                       ?Last Cart Seq#
     D  Previous_Cart  S                   Like(CARTSEQ#)                       ?Previous Cart Seq#
     D   Next_Shelf    S                   Like(SHLF_END)                       ?Next Shelf Seq#
     D   SHELFCNT#     S              3S 0                                      ?Shelf Count #
     D   SHELFLEFT     S              3S 0                                      ?Shelf Left Count
     D   Next_CartT    S                   Like(CARTUSED)                       ?Type for next cart
     D   SVIA2LOCK     S                   Like(PGSVIA)                         ?SVIA TO LOCK
     D   FORCE_SVIA    S                   Like(FORCE_LOC)                      ?FORCE_SVIA
     D   SFLCSRRRN2    S                   Like(SFLCSRRRN)                      ?Cursor Location
     D   EndCartShf    S             15S11                                      ?Ending Cart-Shelf
     D   SHLF_END#     S              6S 0                                      ?Ending Shelf #
     D   Good_Reads    S              4S 0                                      ?# of Good Reads
     D   X             S              4S 0                                      ?# of Good Reads
     D   LockVal       S              1                                         ?Lock Value
     D  modeSelected   S              1A                                        ?C=Count R=Run
     D  TrayCount      S              5S 0                                      ?Tray Count
     D  HSOrder        S                   Like(PGORD#)                         ?H & S Order Number
     D  RBOrder        S                   Like(PGORD#)                         ?RB Order Number

    ?C     *INLR         DOUEQ     *ON                                          ?COMMENT

    ?C                   SELECT                                                 ?
    ?C     Screen        WhenEq    1                                            ?
    ?C                   ExSr      Edit01                                       ?
    ?C     Screen        WhenEq    2                                            ?
    ?C                   ExSr      Edit02                                       ?
    ?C     Screen        WhenEq    3                                            ?
    ?C                   ExSr      Edit03                                       ?

    ?C                   ENDSL                                                  ?

    ?C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     PSR30001                                     ?
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

      *? Load Screen 1 stuff here
     C                   Eval      SDate = $MDYDate($Monday(Today:'SAT'))       ?Ship Date MDY
     C                   Eval      SDateYMD7 = $Date7($Monday(Today:'SAT'))     ?Ship Date YMD7
     C                   Eval      SGMSTR = *Zeros                              ?Master #

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

      *? Edit Screen 1 here
    ?C                   SELECT                                                 ?
      *? Exit Requested
    ?C                   When      *In03 = *ON                                          ?
     C                   MOVE      *ON           *INLR                          ?
     C                   LeaveSR                                                ?
      *? Refresh Requested
    ?C                   When      *In05 = *ON                                          ?
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *?  F6 Manual Process Requested
    ?C                   When      *In06 = *ON                                          ?
     C                   Call      'LOCCHG'                                     ?
     C                   ExSr      Scrn01                                       ?
      *? When Date is invalid
    ?C                   When      not $isDate#(SDATE:'*MDY')                           ?
     C                   Eval      $#MSID = 'DATE901'
     C                   Eval      $#MSGD = %EditW(SDATE:'      ')
     C                   EXSR      SndError
     C                   ExSr      Scrn01                                       ?
      *? When Date is not a $Monday
    ?C                   When      $DateMDY(SDATE) <>
    ?C                                $Monday($DateMDY(SDATE):'SAT')
     C                   Eval      $#MSID = 'DATE904'
     C                   Eval      $#MSGD = %EditW(SDATE:'  /  /  ')  + %EditW(
     C                             $MDYDate($Monday($DateMDY(SDATE):'SAT'))
     C                             :'  /  /  ')
     C                   EXSR      SndError
     C                   ExSr      Scrn01                                       ?
      *? If no Functions and all Edits passed, load and display next screen.
    ?C                   OTHER                                                  ?
     C                   Eval      SDateYMD7 = $Date7($DateMDY(SDate))
     C                   ExSr      Load02
     C                   ExSr      Scrn02
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?



      *?  ...........................................................
      *?  :      Scrn02 - Display Screen 02                         :
      *?  :.........................................................:
    ?C     Scrn02        BegSr                                                  ?
     C                   Z-Add     02            Screen            3 0          ?Screen  Number
     C                   If        SFLPOSTO1 <= *Zero
     C                   Eval      SFLPOSTO1 = 1
     C                   EndIf
     C                   Eval      *In25 = *On                                  ?
    ?C                   Write     ASSUME
    ?C                   Write     PSR30002F                                   ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     PSR30002C                                    ?
     C                   If        SFLCSRRRN > 0
     C                   Eval      SFLPOSTO1 = SFLCSRRRN
     C                   EndIf
     C                   ExSr      ClrError                                     ?
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load02 - Load Screen 02                            :
      *?  :.........................................................:
    ?C     Load02        BegSr                                                  ?

     C                   Eval      Carts_9  = *Zero
     C                   Eval      Carts_12 = *Zero
      *? Load the Setup File
    ?C                   ExSr      LoadOrd

    ?C                   Clear                   RPSECT                                       ?
    ?C                   Clear                   RPLGDFT                                      ?
    ?C                   Clear                   PSR30002                                     ?
    ?C                   Clear                   DPLGSET                                      ?
     C                   Eval      Last_PGSVIA = *Blanks
     C                   Eval      FITTOP     =   *Blanks
     C                   Eval      PREFCART   =   *Zeros
     C                   Eval      FITSOTHER  =   *Blanks
     C                   Eval      SHELFCNT   =   *Zeros
     C                   Eval      HALF13     =   *Blanks
     C                   Eval      HALF09     =   *Blanks
     C                   Eval      NEW_TRUCK  =   *Blanks
     C                   Eval      Last_TRUCK =   *Blanks
     C                   Eval      NEWCART    =   *Blanks
     C                   Eval      CARTUSED   =   *Zeros
     C                   Eval      CARTSEQ#   =   *Zeros
     C                   Eval      SHLF_END   =   *Zeros
     C                   Eval      Next_Cart# = *Zero
     C                   Eval      Next_Shelf = *Zero

      *? Clear the Subfile
     C                   Eval      RRN02 = *Zero
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
    ?C                   Write     PSR30002C                                    ?

      *? Load the Subfile
    ?C     *LoVal        SetLL     FPLGDFTSQ                                    ?
    ?C                   Read      FPLGDFTSQ                                    ?
    ?C                   DoW       not %EOF(FPLGDFTSQ)                          ?
      *? Write record for New SVIA
     C                   Clear                   RMSVIA
    ?C     PDSVIA        Chain     FMSVIA                                       ?
     C                   Eval      PGSVIA = PDSVIA
     C                   If        PDSVIA = '99'
     C                   Eval      SVDESC = 'Do Not Address'
     C                   EndIf
     C                   Eval      FORCE_LOC = ' '
     C                   Eval      PGNAME = %SUBST( PGSVIA + Pink + SVDESC:1:30)
     C                   Eval      PGLOC  = 'Lock: ' + PGSVIA
     C                   Eval      RRN02 = RRN02 + 1
     C                   Eval      *In60   =  *On                               ?S-Via Break
     C                   MoveA     *In(60)       IN60
    ?C                   Write     PSR30002                                     ?
     C                   Eval      PGLOC  = *Blanks
     C                   Eval      *In60   =  *Off                              ?S-VIA Break
     C                   Eval      New_ShipVia = *On

    ?C     SetupKey      KList
    ?C                   KFld                    SDateYMD7
    ?C                   KFld                    SGMSTR
    ?C                   KFld                    PDSVIA
    ?C     SetupKey      SetLL     FPLGSETDS                                    ?
    ?C     SetupKey      ReadE     FPLGSETDS                                    ?

    ?C                   DoW       not %EOF(FPLGSETDS)                          ?
      *? Check for New Truck
     C                   Eval      New_Truck   = ' '
     C                   Eval      DotW        = ' '
     C                   If        PGSVIA = '01' and
     C                             %SubSt(PGSORT:1:20) <> Last_Truck
     C                   Eval      DotW = %Subst($DotW($Date(
     C                                    %Int(%SubSt(PGSORT:1:1)+
     C                                         %SubSt(PGSORT:3:2)+
     C                                         %SubSt(PGSORT:6:2)+
     C                                         %SubSt(PGSORT:9:2)))):1:3)
     C                   If        %SubSt(PGSORT:18:1) = 'T'                    |Trailer
     C                   Eval      New_Truck   = %SubSt(PGSORT:16:4)
     C                   Else
     C                   If        %SubSt(PGSORT:18:1) = '?'
     C                   Eval      New_Truck   = '????'
     C                   Else
     C                   Eval      New_Truck   = 'T('+ %SubSt(PGSORT:16:1)+')'
     C                   EndIf
     C                   EndIf
     C                   Eval      Last_Truck   = %SubSt(PGSORT:1:20)
     C                   EndIf
      *? Calculate Screen Fields
     C                   Eval      PGSVIA_SV = PGSVIA
      *?      PGLGFL/PGSMFL - Recalc in case order has changed.
     C                   Eval      OHORD#  =  PGORD#
     C                   If        PGORD# < 900000                               Dont recalc special
    ?C                   ExSr      GetSizes                                     ?
     C                   Eval      PGLGFL  =  Large_Trays                       ?LARGE PLUG FLATS
     C                   Eval      PGSMFL  =  Small_Trays                       ?SMALL PLUG FLATS
     C                   EndIf
      *?      FITTOP     - Does an order with Large Flats fit the top of a cart (i.e. <= 5)
     C                   If        PGLGFL > 0
     C                   If        PGLGFL <= 5
     C                   Eval      FITTOP = 'Y'
     C                   Else
     C                   Eval      FITTOP = 'N'
     C                   EndIf
     C                   Else
     C                   Eval      FITTOP = '-'
     C                   EndIf
      *?      PREFCART   - What is the Prefered Cart Type for this order.
      *?      FITSOTHER  - Will this order fit on the other size cart?
     C                   If        PGLGFL > 0
     C                   Eval      PREFCART  = 9
     C                   Eval      FITSOTHER = 'N'
     C                   Else
     C                   Eval      PREFCART  = 12
     C                   Eval      FITSOTHER = 'Y'
     C                   EndIf
      *?      SHELFCNT   - Number of Shelves needed for this Order.
     C                   Eval      SHELFCNT = (PGLGFL+PGSMFL) / 5
     C                   Eval      SHELFCNT# = %IntH(((PGLGFL+PGSMFL) /5)+.4999)
     C*                  If        SHELFCNT <> SHELFCNT#
     C*                  Eval      SHELFCNT# = SHELFCNT# + 1
     C*                  EndIf
      *?      HALF13     - Order will fit on half of a 13 shelf cart
     C                   If        FITTOP = 'Y' or
     C                             PREFCART = 13 and SHELFCNT# <= 6
     C                   Eval      HALF13 = 'Y'
     C                   Else
     C                   Eval      HALF13 = 'N'
     C                   EndIf
      *?      HALF09     - Order will fit on half of a 9 shelf cart
     C                   If        SHELFCNT# <= 4
     C                   Eval      HALF09 = 'Y'
     C                   Else
     C                   Eval      HALF09 = 'N'
     C                   EndIf
      *?      FORCE_LOC  - Place Orders on Carts
     C                   If        PGLOC <> *Blanks
     C                   Eval      Force_Loc =  'Y'
     C                   Else
     C                   If        PGSEQ2 = 9999
     C                   Eval      Force_Loc =  'X'
     C                   Else
     C                   Eval      Force_Loc =  ' '
     C                   EndIf
     C                   EndIf
      *?      CARTS      - Place Orders on Carts
    ?C                   ExSr      CalcCarts                                    ?
      *?      OHLOC      - Current Order Location
     C                   Eval      OHLOC  = *Blanks
    ?C     PGORD#        Chain(N)  FHORDR                                       ?
     C                   If        OHSHPC <> PGSVIA
     C                   Eval      *In62 = *On
     C                   Else
     C                   Eval      *In62 = *Off
     C                   EndIf
      *? Count Carts
     C                   If        CARTSEQ# <> Last_CARTSEQ#
     C                   If        Last_CARTUSED = 9
     C                   Eval      Carts_9  = Carts_9  + CARTSEQ# -Last_CARTSEQ#
     C                   Else
     C                   Eval      Carts_12 = Carts_12 + CARTSEQ# -Last_CARTSEQ#
     C                   EndIf
     C                   Eval      Last_CARTUSED = CARTUSED
     C                   Eval      Last_CARTSEQ# = CARTSEQ#
     C                   EndIf
      *? Write Setup Record
     C                   Eval      RRN02 = RRN02 + 1
     C                   MoveA     *In(60)       IN60
    ?C                   Write     PSR30002                                     ?
     C                   Eval      *In26 = *On                                  ?
      *? Underline previous SFL record if starting a new cart
     C                   IF        NewCart <> ' ' and RRN02 > 1
     C                   Eval      RRN02 = RRN02 - 1
    ?C     RRN02         Chain     PSR30002                                     ?
     C                   MoveA     IN60          *In(60)
     C* wjb 1/04/2011    Eval      *In61 = *On                                  ?UnderLine Ind.
     C                   If        %Scan(Pink:PGNAME:1) = 0
     C                   MoveA     *In(60)       IN60
    ?C                   Update    PSR30002                                     ?
     C                   EndIf
     C                   Eval      RRN02 = RRN02 + 1
    ?C     RRN02         Chain     PSR30002                                     ?
     C                   MoveA     IN60          *In(60)
     C                   Eval      *In61 = *Off                                 ?UnderLine Ind.
     C                   EndIF                                                  ?
    ?C     SetupKey      ReadE     FPLGSETDS                                    ?
     C                   Eval      New_ShipVia = *Off
    ?C                   EndDo                                                  ?
    ?C                   Read      FPLGDFTSQ                                    ?
    ?C                   EndDo                                                  ?

     C                   IF        *In26 = *On                                  ?
    ?C     RRN02         Chain     PSR30002                                     ?
     C                   MoveA     IN60          *In(60)
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   MoveA     *In(60)       IN60
    ?C                   Update    PSR30002                                     ?
     C                   EndIF                                                  ?

    ?C                   ExSr      GetLocations

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit02 - EDIT Screen 02                            :
      *?  :.........................................................:
    ?C     Edit02        BegSr                                                  ?

    ?C                   SELECT                                                 ?
      *?  F1 Bay Map Spreadsheet
    ?C                   When      *In01 = *ON                                          ?
     C                   Call      'BAYMAP'                                     ?
     C                   ExSr      Scrn02                                       ?
      *?  F2 Cover Sheets
    ?C                   When      *In02 = *ON                                          ?
     C                   Z-add     SDateYMD7     PDateYMD7
     C                   Call      'BAY010CL'                                   ?
     C                   Parm                    PDateYMD7
     C                   Parm                    SGMSTR
     C                   Parm      0             AllOrders0                     0 = All Orders
     C                   ExSr      Scrn02                                       ?
      *?  F3 Exit Requested
    ?C                   When      *In03 = *ON                                          ?
     C                   MOVE      *ON           *INLR                          ?
     C                   LeaveSR                                                ?
      *?  F4 Bay Map Requested
    ?C                   When      *In04 = *ON                                          ?
     C                   Call      'PSR305'                                     ?
     C                   ExSr      Load02                                       ?
     C                   ExSr      Scrn02                                       ?
      *?  F5 Refresh Requested
    ?C                   When      *In05 = *ON                                          ?
     C                   ExSr      Load02                                       ?
     C                   ExSr      Scrn02                                       ?
      *?  F6 Manual Process Requested
    ?C                   When      *In06 = *ON                                          ?
     C                   Call      'LOCCHG'                                     ?
     C                   ExSr      Load02                                       ?
     C                   ExSr      Scrn02                                       ?
      *?  F7 Lock All
    ?C                   When      *In07 = *ON                                          ?
     C                   Eval      LockVal = 'Y'
     C                   ExSr      SetLock                                      ?
     C                   ExSr      Scrn02                                       ?
      *?  F8 UnLock All
    ?C                   When      *In08 = *ON                                          ?
     C                   Eval      LockVal = ' '
     C                   ExSr      SetLock                                      ?
     C                   ExSr      Scrn02                                       ?
      *? F13 Change Defaults Requested
    ?C                   When      *In13 = *ON                                          ?
     C                   ExSr      Load03                                       ?
     C                   ExSr      Scrn03                                       ?
      *? F13 Change Defaults Requested
    ?C                   When      *In13 = *ON                                          ?
     C                   ExSr      Load03                                       ?
     C                   ExSr      Scrn03                                       ?
      *? F16 Clear Orders
    ?C                   When      *In16 = *ON                                          ?
     C                   ExSr      ClearOrders
     C                   ExSr      Load02                                       ?
     C                   ExSr      Scrn02                                       ?
      *? F20 Start Over
    ?C                   When      *In20 = *ON                                          ?
     C                   ExSr      ClearSetup
     C                   ExSr      ClearOrders
     C                   ExSr      Load02                                       ?
     C                   ExSr      Scrn02                                       ?
      *? Left Mouse Click Received
      *?      Click on Order Number
    ?C                   When      *In22 = *ON  and CSRFLD = 'PGORD#'                     ?
    ?C     SFLCSRRRN     Chain     PSR30002
     C                   MoveA     IN60          *In(60)
     C     PGORD#        SetLL     FHORDR
     C                   If        %Equal(FHORDR)
    ?C                   Call      'BIR255CLO'
    ?C                   Parm                    PGORD#
     C                   EndIf
     C                   Eval      *In28 = *On                                  ?
    ?C                   Update    PSR30002
     C                   Eval      *In28 = *Off                                 ?
     C                   ExSr      Scrn02                                       ?
      *?      Click on Force Skip
    ?C                   When      *In22 = *ON  and CSRFLD = 'PGSKIP'                     ?
    ?C     SFLCSRRRN     Chain     PSR30002
     C                   MoveA     IN60          *In(60)
     C                   If        PGSKIP = ' '
     C                   Eval      PGSKIP = 'Y'
     C                   Else
     C                   Eval      PGSKIP = ' '
     C                   EndIf
     C                   Eval      *In28 = *On                                  ?
    ?C                   Update    PSR30002
     C                   Eval      *In28 = *Off                                 ?
     C                   ExSr      Scrn02                                       ?
      *?      Click on Force Location
    ?C                   When      *In22 = *ON  and CSRFLD = 'FORCE_LOC'                  ?
    ?C     SFLCSRRRN     Chain     PSR30002
     C                   MoveA     IN60          *In(60)
     C                   If        FORCE_LOC = ' '
     C                   Eval      FORCE_LOC = 'Y'
     C                   Else
     C                   Eval      FORCE_LOC = ' '
     C                   EndIf
     C                   Eval      *In28 = *On                                  ?
    ?C                   Update    PSR30002
     C                   Eval      *In28 = *Off                                 ?
     C   60              ExSr      LockSVia
     C                   ExSr      Scrn02                                       ?
      *? Right Mouse Click Received
    ?C                   When      *In23 = *ON                                          ?
     C                   ExSr      Scrn02                                       ?
      *? F24 Update Order Headers
    ?C                   When      *In24 = *ON                                          ?
     C                   ExSr      PutLocations                                 ?
     C                   ExSr      Load02                                       ?
     C                   ExSr      Scrn02                                       ?
      *? When Date is invalid
    ?C                   When      not $isDate#(SDATE:'*MDY')                           ?
     C                   Eval      $#MSID = 'DATE901'
     C                   Eval      $#MSGD = %EditW(SDATE:'      ')
     C                   EXSR      SndError
     C                   ExSr      Scrn01                                       ?
      *? When Date is not a $Monday
    ?C                   When      $DateMDY(SDATE) <>
    ?C                                $Monday($DateMDY(SDATE):'SAT')
     C                   Eval      $#MSID = 'DATE904'
     C                   Eval      $#MSGD = %EditW(SDATE:'  /  /  ')  + %EditW(
     C                             $MDYDate($Monday($DateMDY(SDATE):'SAT'))
     C                             :'  /  /  ')
     C                   EXSR      SndError
     C                   ExSr      Scrn01                                       ?
      *? When Date is Changed
    ?C                   When      $DateMDY(SDate) <> $Date(SDateYMD7)             ?
     C                   Eval      SDateYMD7 = $Date7($DateMDY(SDate))
     C                   ExSr      Load02                                       ?
     C                   ExSr      Scrn02                                       ?
      *? When Previou Week is Requested
    ?C                   When      *In09 = *ON                                  ?
     C                   Eval      SDate=$MDYDate($AddDate($DateMDY(SDate):-7))
     C                   Eval      SDateYMD7 = $Date7($DateMDY(SDate))
     C                   ExSr      Load02                                       ?
     C                   ExSr      Scrn02                                       ?
      *? When Next Week is Requested
    ?C                   When      *In10 = *ON                                  ?
     C                   Eval      SDate=$MDYDate($AddDate($DateMDY(SDate):+7))
     C                   Eval      SDateYMD7 = $Date7($DateMDY(SDate))
     C                   ExSr      Load02                                       ?
     C                   ExSr      Scrn02                                       ?
      *? If no Functions, Check for Options and Re-display
    ?C                   OTHER                                                  ?
     C                   Eval      *In63 = *Off
    ?C                   ReadC     PSR30002
     C                   MoveA     IN60          *In(60)
     C                   DoW       not %EOF(PSR300FM)
     C                   Eval      *In63 = *On

    ?C     UpdateKey     KList
    ?C                   KFld                    PGWKDT
    ?C                   KFld                    PGMSTR
    ?C                   KFld                    PGSVIA_SV
    ?C                   KFld                    PGORD#
    ?C     UpdateKey     Chain     FPLGSETDO
    ?C     RRN02         Chain     PSR30002
     C                   MoveA     IN60          *In(60)
    ?C     PGSVIA        Setll     FPLGDFT
     C                   If        Not %Equal(FPLGDFT)
     C                   Eval      PGSVIA = PGSVIA_SV
     C                   EndIf
     C                   Eval      PGSVIA_SV = PGSVIA
     C                   If        Force_Loc <> 'Y'
     C                   Eval      PGLOC  = *Blanks
     C                   EndIf
     C                   If        %Found(FPLGSETDO)
    ?C                   Update    DPLGSET
     C                   EndIf
     C                   Eval      *In28 = *Off
     C                   If        NEWCART = 'Y'
     C*  wjb 1/04/2011   Eval      *In61 = *On
     C                   Else
     C                   Eval      *In61 = *Off
     C                   EndIf
     C                   MoveA     *In(60)       IN60
    ?C                   Update    PSR30002
     C                   Eval      *In51 = *Off
     C                   Eval      *In52 = *Off
    ?C                   ReadC     PSR30002
     C                   MoveA     IN60          *In(60)
     C                   EndDo                                                  ?
     C                   If        *In63
     C                   ExSr      Load02
     C                   Eval      *In63 = *Off
     C                   EndIf
     C                   ExSr      Scrn02
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      LockSVia - Lock Entire ShipVia                     :
      *?  :.........................................................:
    ?C     LockSVia      BegSr                                                  ?

     C                   Eval      SVIA2LOCK =  PGSVIA
     C                   Eval      FORCE_SVIA = FORCE_LOC
     C                   Eval      SFLCSRRRN2 = SFLCSRRRN
     C                   DoW       PGSVIA = SVIA2LOCK
     C                   Add       1             SFLCSRRRN2
    ?C     SFLCSRRRN2    Chain     PSR30002
     C                   If        PGSVIA = SVIA2LOCK
     C                   MoveA     IN60          *In(60)
     C                   Eval      FORCE_LOC = FORCE_SVIA
     C                   Eval      *In28 = *On                                  ?
    ?C                   Update    PSR30002
     C                   Eval      *In28 = *Off                                 ?
     C                   EndIf
     C                   EndDo
    ?C     SFLCSRRRN     Chain     PSR30002

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      SetLock - Lock Entire Layout                       :
      *?  :.........................................................:
    ?C     SetLock       BegSr                                                  ?

     C                   Eval      FORCE_SVIA = FORCE_LOC
     C                   Eval      SFLCSRRRN2 = 1
    ?C     SFLCSRRRN2    Chain     PSR30002
     C                   DoW       %Found(PSR300FM)
     C                   MoveA     IN60          *In(60)
     C                   Eval      *In28 = *On                                  ?
     C  N60              Eval      FORCE_LOC = LockVal
    ?C  N60              Update    PSR30002
     C                   Eval      *In28 = *Off                                 ?
     C                   Add       1             SFLCSRRRN2
    ?C     SFLCSRRRN2    Chain     PSR30002
     C                   EndDo

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn03 - Display Screen 03                         :
      *?  :.........................................................:
    ?C     Scrn03        BegSr                                                  ?
     C                   Z-Add     03            Screen            3 0          ?Screen  Number
     C                   Eval      *In25 = *On                                  ?
    ?C                   Write     ASSUME
    ?C                   Write     PSR30003F                                   ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     PSR30003C                                    ?
     C                   ExSr      ClrError                                     ?
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load03 - Load Screen 03                            :
      *?  :.........................................................:
    ?C     Load03        BegSr                                                  ?

      *? Load Screen 3 stuff here - Ship Via Defaults

    ?C                   Clear                   PSR30003                                     ?
    ?C                   Clear                   DPLGSET                                      ?
     C                   Eval      SVDESC     =   *Blanks
     C                   Eval      PDSTUF     =   *Blanks
     C                   Eval      TBSHRT     =   *Blanks
     C                   Eval      PDSKPS     =   *Zeros
     C                   Eval      PDBACK     =   *Blanks
     C                   Eval      PDSECT     =   *Zeros
     C                   Eval      PDNORS     =   *Blanks
     C                   Eval      PDBAY      =   *Zeros
     C                   Eval      PDLORR     =   *Blanks
     C                   Eval      PDPOLE     =   *Zeros

      *? Clear the Subfile
     C                   Eval      RRN03 = *Zero
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
    ?C                   Write     PSR30003C                                    ?

      *? Load the Subfile
    ?C     *LoVal        SetLL     FPLGDFTSQ                                    ?
    ?C                   Read      FPLGDFTSQ                                    ?

    ?C                   DoW       not %EOF(FPLGDFTSQ)                            ?
      *? Calculate Screen Fields
    ?C     PDSVIA        Chain     FMSVIA                                       ?
     C                   If        PDSVIA = '99'
     C                   Eval      SVDESC = 'Do Not Address'
     C                   Eval      SVCODE = '99'
     C                   EndIf
     C                   Eval      Table   = 'ST'
     C                   Eval      TableCd = PDSTUF
    ?C     TableKey      KList
    ?C                   KFld                    Table             2
    ?C                   KFld                    TableCd           6
    ?C     TableKey      Chain     XATABE1                                      ?
      *? Write Setup Record
     C                   Eval      RRN03 = RRN03 + 1
    ?C                   Write     PSR30003                                     ?
     C                   Eval      *In26 = *On                                  ?
    ?C                   Read      FPLGDFTSQ                                    ?
    ?C                   EndDo                                                  ?

     C                   IF        *In26 = *On                                  ?
    ?C     RRN03         Chain     PSR30003                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
    ?C                   Update    PSR30003                                     ?
     C                   EndIF                                                  ?


    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit03 - EDIT Screen 03                            :
      *?  :.........................................................:
    ?C     Edit03        BegSr                                                  ?

      *? Edit Screen 3 here
    ?C                   SELECT                                                 ?
      *? Exit Requested
    ?C                   When      *In03 = *ON                                          ?
     C                   MOVE      *ON           *INLR                          ?
     C                   LeaveSR                                                ?
      *? Cancel Requested
    ?C                   When      *In12 = *ON                                          ?
     C                   ExSr      Load02                                       ?
     C                   ExSr      Scrn02                                       ?
      *? Add Requested
    ?C*                  When      *In06 = *ON                                          ?
     C*                  ExSr      Load04                                       ?
     C*                  ExSr      Scrn04                                       ?
      *? If no Functions and all Edits passed, Update and Go Back to Screen 2.
    ?C                   OTHER                                                  ?
     C                   Eval      *In63 = *Off

    ?C                   ReadC     PSR30003
     C                   DoW       not %EOF(PSR300FM)
    ?C     SVCODE        Chain     FPLGDFT
    ?C     RRN03         Chain     PSR30003
     C                   If        %Trim(PDSTUF) = '?'
     C                   CALL      'XATABLE'
     C                   PARM      'ST'          TABID             2
     C                   PARM      *Blanks       #KEYP#            2
     C                   PARM      *Blanks       #EELM#            6
     C                   Eval      PDSTUF = %Subst(#EELM#:1:%Int(%Trim(#KEYP#)))
     C                   EndIf
    ?C                   Update    RPLGDFT
     C                   Eval      *In28 = *Off
    ?C                   Update    PSR30003
    ?C                   ReadC     PSR30003
     C                   EndDo                                                  ?

     C                   ExSr      Load03
     C                   ExSr      Scrn03
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ClearOrders - Clears Addresses from Orders         :
      *?  :.........................................................:
    ?C     ClearOrders   BegSr                                                  ?

    ?C     SDateYMD7     SetLL     FHORDRCD                                     ?
    ?C     SDateYMD7     ReadE     FHORDRCD                                     ?

    ?C                   DoW       not %EOF(FHORDRCD)                           ?
     C                   Call      'MMR015'
     C                   Parm                    OHORD#
     C                   Parm                    SGMSTR
     C                   Parm                    SDateYMD7
     C                   Parm                    Included

     C                   If        Included and OHSTAT <> 'D'
     C                   Eval      OHLOC = *Blanks
    ?C                   Update    RHORDR
    ?C     OHORD#        Chain     FPPO
     C                   If        %Found(FPPO)
     C                   Eval      POLOWC = *Blanks
     C                   Eval      POLOWF = *Blanks
    ?C                   Update    RPPO
     C                   EndIf
     C                   EndIf
    ?C     SDateYMD7     ReadE     FHORDRCD                                     ?
    ?C                   EndDo

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      ClearSetup  - Deleted Specified Setup              :
      *?  :.........................................................:
    ?C     ClearSetup    BegSr                                                  ?

    ?C     SDateMast     SetLL     FPLGSETDA                                    ?
    ?C     SDateMast     ReadE     FPLGSETDA                                    ?
     C                   DoW       Not %Eof(FPLGSETDA)
    ?C                   Delete    APLGSET
    ?C     SDateMast     ReadE     FPLGSETDA                                    ?
     C                   EndDo

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      LoadOrd - Load Orders                              :
      *?  :.........................................................:
    ?C     LoadOrd       BegSr                                                  ?

      *? Check if this is the first load for this shipdate:Master
    ?C     SDateMast     KList
    ?C                   KFld                    SDateYMD7
    ?C                   KFld                    SGMSTR
    ?C     SDateMast     SetLL     FPLGSETDA                                    ?
     C                   Eval      First_Load = *On
     C                   Eval      New_Seq = 9998
     C                   If        %Equal(FPLGSETDA)
     C                   Eval      First_Load = *Off
     C                   Eval      New_Seq = 9999
     C                   EndIf

      *? Check for Orders on FHORDR that aren't on FPLGSET
    ?C     SDateYMD7     SetLL     FHORDRCD                                     ?
    ?C     SDateYMD7     ReadE(N)  FHORDRCD                                     ?

    ?C                   DoW       not %EOF(FHORDRCD)                           ?
     C                   Call      'MMR015'
     C                   Parm                    OHORD#
     C                   Parm                    SGMSTR
     C                   Parm                    SDateYMD7
     C                   Parm                    Included

     C                   If        Included and OHSTAT <> 'D'
    ?C     OrderKey      KList
    ?C                   KFld                    SDateYMD7
    ?C                   KFld                    SGMSTR
    ?C                   KFld                    OHORD#
    ?C     OrderKey      Chain     FPLGSETO#                                    ?
     C                   If        not %Found(FPLGSETO#)
     C                   Eval      PGWKDT  =  SDateYMD7                         ?WEEK DATE CYMD
     C                   Eval      PGMSTR  =  SGMSTR                            ?MASTER NUMBER
     C                   Eval      PGSVIA  =  OHSHPC                            ?SHIP VIA
     C                   Eval      PGORD#  =  OHORD#                            ?ORDER NUMBER
     C                   Eval      PGSEQ2  =  New_Seq                           ?OVERRIDE SEQUENCE
     C                   Eval      PGSEQ1  =  New_Seq                           ?KEYED SEQUENCE
     C                   EndIf

     C                   Eval      PGNAME  =  OHNAME                            ?CUSTOMER NAME
     C                   Eval      PGSHP2  =  OHSHCT                            ?SHIPPING CITY
     C                   Eval      PGSHST  =  OHSHST                            ?SHIPPING STATE
    ?C                   ExSr      GetSizes                                     ?
     C                   Eval      PGLGFL  =  Large_Trays                       ?LARGE PLUG FLATS
     C                   Eval      PGSMFL  =  Small_Trays                       ?SMALL PLUG FLATS
    ?C                   ExSr      GetSort                                      ?
     C*                  Eval      PGSORT  =  GetSort Subroutine                ?SORT BY

     C                   Eval      CLDTLA  =  $MDYDate(Today)                   ?LAST ACTIVITY DATE
     C                   TIME                    CLTIME                         ?TIME
     C                   Eval      CLUSER  =  $User()                           ?USER
     C                   Eval      CLPGMN  =  'PSR300'                          ?Program Name

     C                   If        %Found(FPLGSETO#)
    ?C                   Update    OPLGSET                                      ?
     C                   Else
    ?C                   Write     OPLGSET                                      ?
     C                   EndIf

     C                   EndIf

     C                   Eval      *In26 = *On                                  ?
    ?C     SDateYMD7     ReadE(N)  FHORDRCD                                     ?
    ?C                   EndDo                                                  ?

     C                   ExSr      GetHSDummies
     C                   ExSr      GetRBDummies
      *? On First Load for a Date;Master Set the Sequence Numbers
    ?C                   ExSr      FirstSort

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      GetHSDummies - Get P/S Dummy Orders for H&S + RB   :
      *?  :.........................................................:
    ?C     GetHSDummies  BegSr                                                  ?
      /Free
               $CrtHSOrd(SDateYMD7);
         CallP $CrtPSOrd(SDateYMD7:SGMSTR);
      /End-Free
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      GetRBDummies - Get P/S Dummy Orders for RB         :
      *?  :.........................................................:
    ?C     GetRBDummies  BegSr                                                  ?

     C                   Call      'GRS630'
     C                   Parm                    SDateYMD7
     C                   Parm                    SGMSTR
     C                   Parm      'C'           modeSelected
     C                   Parm                    TrayCount

      /Free

         Exec SQL
                  SELECT 990000 + (CLYEAR * 100)+ CLWEEK
                  INTO   :RBOrder
                  FROM   fcalen
                  WHERE  CLCYMD = :SDateYMD7 ;

         Chain (RBOrder) FHORDR;
         If not %Found(FHORDR);
           Clear HORDR;
           OHORD# = RBOrder;
           OHLOC  = 'TBD';
           OHCUST = 999996;
           OHNAME = 'Ready Bay Select Order';
           OHDTLA = $MDYdate($Date(0));
           OHTIME = $Now();
           OHUSER = 'PSR300';
           Write HORDR;
         ENDIF;

         Exec SQL Select   sum(LRQTAV)
                  Into    :PGLGFL
                  from     FDLOTRD
                  where    LRCRDY = :SDateYMD7;

         If PGLGFL > 225;
            PGLGFL = 225;
         EndIf;

         Chain (SDateYMD7:SGMSTR:RBOrder) FPLGSETO#;
         If not %Found(FPLGSETO#);
           PGSVIA = '50';                                                      // SHIP VIA
           PGSORT = 'Kube-Pak RB Week: ' + %Char($Week#($Date(SDateYMD7)));    // SORT BY
           PGORD# = RBOrder;                                                   // ORDER NUMBER
           PGNAME = 'Kube-Pak RB Week: ' + %Char($Week#($Date(SDateYMD7)));    // CUSTOMER NAME
           PGLGFL = 225;                                                       // LARGE PLUG FLATS
           CLDTLA = $MDYDate($Date(0));                                        // LAST ACTIVITY DT
           CLTIME = $Now();                                                    // TIME
           CLUSER = $User();                                                   // USER
           CLPGMN = 'PSR300_rb ';                                              // Program Name
           Write  OPLGSET;
          Else;
           Unlock FPLGSETO#;
         EndIf;

      /End-Free
    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      FirstSort - Sort the records if it's the 1st Load  :
      *?  :.........................................................:
    ?C     FirstSort     BegSr                                                  ?

      *? On First Load for a Date;Master Set the Sequence Numbers
     C                   If        First_Load
     C                   Eval      Last_PGSVIA = *Blanks
    ?C     SDateMast     SetLL     FPLGSETDA                                    ?
    ?C     SDateMast     ReadE     FPLGSETDA                                    ?

    ?C                   DoW       not %EOF(FPLGSETDA)                          ?
     C                   If        PGSVIA  =  Last_PGSVIA
     C                   Eval      Next_Seq = Next_Seq + 10                     ?Next SEQUENCE
     C                   Else
     C                   Eval      Next_Seq = 10                                ?Next SEQUENCE
     C                   Eval      Last_PGSVIA = PGSVIA
     C                   EndIf
     C                   If        PGLGFL  =  *Zero and
     C                             PGSMFL  =  *Zero
     C                   Eval      PGSEQ2  =  9999                              ?OVERRIDE TO END
     C                   Eval      FORCE_LOC = 'X'                              ?Mark do not stuff
     C                   Eval      PGSVIA  =  '99'                              ?Mark do not stuff
     C                   Else
     C                   Eval      PGSEQ2  =  Next_Seq                          ?OVERRIDE SEQUENCE
     C                   EndIf
     C                   Eval      PGSEQ1  =  Next_Seq                          ?KEYED SEQUENCE
    ?C                   Update    APLGSET                                      ?
    ?C     SDateMast     ReadE     FPLGSETDA                                    ?
    ?C                   EndDo                                                  ?
     C
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      GetSort  - Populate Alpha Sort Field               :
      *?  :.........................................................:
    ?C     GetSort       BegSr                                                  ?

     C                   If        PGSVIA  = '01'
     C                   Eval      TruckDate7 = $Date7($DateMDY(OHDTCN))
    ?C     TruckKey      KList
    ?C                   KFld                    TruckDate7
    ?C                   KFld                    OHCUST
    ?C                   KFld                    OHORD#
    ?C     TruckKey      Chain     FTRSCHDCO                                    ?
     C                   If        %Found(FTRSCHDCO)
      *  Per Bill we should now sort on TRSTOP instead of TRSTP#
     C                   Eval      PGSORT  =
     C                              %EditW(TRSHDT        :' -  /  /  ')         ?SORT BY
     C                              +  ' Trk:' + TRTRK#                         ?SORT BY
     C*                             +  ' (' + %EditW(TRSTP#:'    ') + ')'       ?SORT BY
     C                              +  ' (' + %EditW(TRSTOP:'    ') + ')'       ?SORT BY
     C                   Else
     C                   Eval      PGSORT  =
     C                              %EditW(TruckDate7       :' -  /  /  ')      ?SORT BY
     C                              +  ' Trk:????'                              ?SORT BY
     C                              +  ' (????)'                                ?SORT BY
     C                   EndIf
     C                   Else
     C                   Eval      PGSORT  =  PGNAME                            ?SORT BY
     C                   EndIf
     C                   If        PGLGFL > 0
     C                   Eval      PGSORT  = %Subst(PGSORT:1:27) + '  9'
     C                   Else
     C                   Eval      PGSORT  = %Subst(PGSORT:1:27) + ' 12'
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      CalcCarts - Put Orders on Carts                    :
      *?  :.........................................................:
    ?C     CalcCarts     BegSr                                                  ?


      *?        Stuff Carts based on Ship Via Defaults
     C                   Eval      PDSTUF = *Blanks
     C                   Eval      SkipShelves = 1
    ?C     PGSVIA        Chain(N)  FPLGDFT
     C                   If        %Found(FPLGDFT)
     C                   Eval      SkipShelves = PDSKPS
     C                   EndIf
    ?C                   Select                                                 ?
    ?C                   When      PDSTUF = '00'                                ?
    ?C                   ExSr      Stuff00
    ?C                   When      PDSTUF = '05'                                ?
    ?C                   ExSr      Stuff05
    ?C                   When      PDSTUF = '10'                                ?
    ?C                   ExSr      Stuff10
    ?C                   When      PDSTUF = '15'                                ?
    ?C                   ExSr      Stuff15
    ?C                   When      PDSTUF = '20'                                ?
    ?C                   ExSr      Stuff20
    ?C                   When      PDSTUF = '50'                                ?
    ?C                   ExSr      Stuff50
    ?C                   Other
    ?C                   ExSr      Stuff15
    ?C                   EndSL

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Stuff00 -  DO NOT STUFF                            :
      *?  :.........................................................:
    ?C     Stuff00       BegSr                                                  ?

      *?      Do Not Stuff These Orders
     C                   Eval      From_Rule = '0'
     C                   Eval      CARTSEQ#  = *Zero
     C                   Eval      SHLF_STR  = *Zero
     C                   Eval      END_CART# = *Zero
     C                   Eval      SHLF_END  = *Zero
     C                   Eval      FORCE_LOC = 'X'
     C                   Eval      PGLOC     = *Blanks
     C                   Eval      NEWCART   = ' '
     C                   Eval      CARTUSED  = PREFCART

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Stuff50 -  Ready Bay                               :
      *?  :.........................................................:
    ?C     Stuff50       BegSr                                                  ?

      *?      Force the Location on all of these to be 888888
     C                   Eval      From_Rule = '0'
     C                   Eval      CARTSEQ#  = *Zero
     C                   Eval      SHLF_STR  = *Zero
     C                   Eval      END_CART# = *Zero
     C                   Eval      SHLF_END  = *Zero
     C                   Eval      FORCE_LOC = 'Y'
     C                   Eval      PGLOC     = '888888'
     C                   Eval      NEWCART   = ' '
     C                   Eval      CARTUSED  = PREFCART

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Stuff99 -  Ready Bay                               :
      *?  :.........................................................:
    ?C     Stuff99       BegSr                                                  ?

      *?      This is for Ready Bay stuff added by Plug Shipping
     C                   Eval      From_Rule = '0'
     C                   Eval      CARTSEQ#  = *Zero
     C                   Eval      SHLF_STR  = *Zero
     C                   Eval      END_CART# = *Zero
     C                   Eval      SHLF_END  = *Zero
     C                   Eval      FORCE_LOC = 'Y'
     C                   Eval      PGLOC     = '888888'
     C                   Eval      NEWCART   = ' '
     C                   Eval      CARTUSED  = PREFCART

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Stuff05 -  SKIP TO A NEW CART FOR EACH ORDER       :
      *?  :.........................................................:
    ?C     Stuff05       BegSr                                                  ?

     C                   Eval      From_Rule = '5'
     C                   Eval      CARTSEQ# = END_CART# + 1
     C                   Eval      SHLF_STR = 1
     C                   Eval      SHLF_END = 0
     C                   Eval      CARTUSED = PREFCART
     C                   Eval      NEWCART  = 'Y'
      *?   Where to End...
    ?C                   Select                                                 ?
      *?        When this order has NO FLATS...
    ?C                   When      SHELFCNT = *Zero
     C                   Eval      To_Rule = 'A'
     C                   Eval      END_CART#  = END_CART#
     C                   Eval      NEXT_CART# = END_CART#
     C                   Eval      SHLF_END   = SHLF_END
      *?        All Other Orders...
    ?C                   OTHER
     C                   Eval      To_Rule = '1'
     C                   Eval      END_CART# = %Int( %Float(CARTSEQ# +
     C                             (SHLF_STR-1+SkipShelves+SHELFCNT#)/CARTUSED))
     C                   Eval      SHLF_END# = ((CARTSEQ#-1) * CARTUSED)
     C                                       + SHLF_STR - 1
     C                                       + SkipShelves
     C                                       + SHELFCNT#
     C                   Eval      SHLF_END =
     C                             SHLF_END# - ((END_CART#-1) * CARTUSED )
     C                   If        SHLF_END = *Zero
     C                   Eval      SHLF_END = CARTUSED
     C                   Eval      END_CART# = END_CART# - 1
     C                   EndIf
     C                   If        SHLF_END = 1 and SkipShelves >= 1
     C                   Eval      SHLF_END = CARTUSED
     C                   Eval      END_CART# = END_CART# - 1
     C                   EndIf
    ?C                   EndSl

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Stuff10 -  PLACE TWO ORDERS TOP AND BOTTOM ON CART :
      *?  :.........................................................:
    ?C     Stuff10       BegSr                                                  ?

     C                   Eval      From_Rule = '0'
     C                   If        SHLF_STR <> 1 or
     C                             CARTUSED - SHLF_END < SHELFCNT#
     C                   Eval      CARTSEQ# = END_CART# + 1
     C                   Eval      SHLF_STR = 1
     C                   Eval      SHLF_END = 0
     C                   Eval      CARTUSED = PREFCART
     C                   Eval      NEWCART  = 'Y'
     C                   Else
     C                   Eval      CARTSEQ# = CARTSEQ#
     C                   Eval      SHLF_STR = CARTUSED - SHELFCNT#
     C                   Eval      SHLF_END = *ZERO
     C                   Eval      CARTUSED = PREFCART
     C                   Eval      NEWCART  = ' '
     C                   EndIf
      *?   Where to End...
    ?C                   Select                                                 ?
      *?        When this order has NO FLATS...
    ?C                   When      SHELFCNT = *Zero
     C                   Eval      To_Rule = 'A'
     C                   Eval      END_CART#  = END_CART#
     C                   Eval      NEXT_CART# = END_CART#
     C                   Eval      SHLF_END   = SHLF_END
      *?        All Other Orders...
    ?C                   OTHER
     C                   Eval      To_Rule = '1'
     C                   Eval      END_CART# = %Int( %Float(CARTSEQ# +
     C                             (SHLF_STR-1+SkipShelves+SHELFCNT#)/CARTUSED))
     C                   Eval      SHLF_END# = ((CARTSEQ#-1) * CARTUSED)
     C                                       + SHLF_STR - 1
     C                                       + SkipShelves
     C                                       + SHELFCNT#
     C                   Eval      SHLF_END =
     C                             SHLF_END# - ((END_CART#-1) * CARTUSED )
     C                   If        SHLF_END = *Zero
     C                   Eval      SHLF_END = CARTUSED
     C                   Eval      END_CART# = END_CART# - 1
     C                   EndIf
     C                   If        SHLF_END = 1 and SkipShelves >= 1
     C                   Eval      SHLF_END = CARTUSED
     C                   Eval      END_CART# = END_CART# - 1
     C                   EndIf
    ?C                   EndSl


    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Stuff15 -  FILL CARTS WITH ORDERS SKIPPING 1 SHELF :
      *?  :.........................................................:
    ?C     Stuff15       BegSr                                                  ?

     C                   Eval      From_Rule = '-'
     C                   Eval      To_Rule = '-'
     C                   Eval      NEWCART  = ' '                               ?Set NewCart Flag
      *?        Start New Cart
     C                   If        PGSKIP <> 'N' and (
     C                             New_ShipVia or
     C                             New_Truck <> ' ' or
     C* Removed WJB 1/3/11         SHLF_END >=  CARTUSED or
     C                             PGSKIP    = 'Y' or
     C                             (CartUsed  <> PrefCart and FitsOther = 'N'))
     C                   Eval      NEWCART  = 'Y'                               ?Set NewCart Flag
     C                   EndIf
      *?   Where to Start...
    ?C                   Select                                                 ?
      *?        Start on a New Cart.
    ?C                   When      NEWCART = 'Y'
     C                   Eval      From_Rule = 'A'
     C                   Eval      CARTSEQ# = END_CART# + 1
     C                   Eval      SHLF_STR = 1
     C                   Eval      SHLF_END = 0
     C                   Eval      CARTUSED = PREFCART
     C                   Eval      NEWCART  = 'Y'
      *?        When this order has NO FLATS...
    ?C                   When      SHELFCNT = *Zero
     C                   Eval      From_Rule = 'Z'
     C                   Eval      CARTSEQ# = END_CART#
     C                   Eval      SHLF_STR = SHLF_END
     C                   Eval      NEWCART  = ' '
     C                   Eval      CARTUSED = PREFCART
      *?        Reposition Based on Last Record if Next Cart is specified.
    ?C                   When      Next_Cart# > CARTSEQ#                        ?
     C                   Eval      From_Rule = 'B'
     C                   Eval      CARTSEQ# = Next_Cart#
     C                   Eval      SHLF_STR = Next_Shelf
     C                   Eval      SHLF_END = 0
     C                   Eval      NEWCART  = 'Y'
     C                   If        Next_CartT <> *Zeros                         ?Check Cart Type
     C                   Eval      CARTUSED = Next_CartT
     C                   EndIf
      *?        Start on a New Cart if Large Order ( >1 cart )
    ?C*                  When      SHELFCNT > PREFCART and PGSKIP <> 'N'
     C*                  Eval      From_Rule = 'C'
     C*                  Eval      CARTSEQ# = END_CART# + 1
     C*                  Eval      SHLF_STR = 1
     C*                  Eval      CARTUSED = PREFCART
     C*                  Eval      NEWCART  = 'Y'
      *?        Start on Same Cart if there is room.
    ?C*                  When      SHLF_END + SkipShelves < CARTUSED            ?
    ?C                   When      SHLF_END               < CARTUSED            ?
     C                   Eval      From_Rule = 'D'
     C                   Eval      CARTSEQ# = END_CART#
     C                   Eval      SHLF_STR = SHLF_END + 1
     C                   Eval      CARTUSED = CARTUSED
     C                   Eval      NEWCART  = ' '
      *?        Start on Next Cart if there is no room on this one.
    ?C                   When      SHLF_END + SkipShelves >= CARTUSED            ?
     C                   Eval      From_Rule = 'E'
     C                   Eval      CARTSEQ# = END_CART# + 1
     C                   Eval      SHLF_STR = 1
     C                   Eval      CARTUSED = PREFCART
     C                   Eval      NEWCART  = 'Y'
    ?C                   EndSl
      *?   Where to End...
    ?C                   Select                                                 ?
      *?        When this order has NO FLATS...
    ?C                   When      SHELFCNT = *Zero
     C                   Eval      To_Rule = 'A'
     C                   Eval      END_CART#  = END_CART#
     C                   Eval      NEXT_CART# = END_CART#
     C                   Eval      SHLF_END   = SHLF_END
      *?        All Other Orders...
    ?C                   OTHER
     C                   Eval      To_Rule = '1'
     C                   Eval      END_CART# = %Int( %Float(CARTSEQ# +
     C                             (SHLF_STR-1+SkipShelves+SHELFCNT#)/CARTUSED))
     C                   Eval      SHLF_END# = ((CARTSEQ#-1) * CARTUSED)
     C                                       + SHLF_STR - 1
     C                                       + SkipShelves
     C                                       + SHELFCNT#
     C                   Eval      SHLF_END =
     C                             SHLF_END# - ((END_CART#-1) * CARTUSED )
     C                   If        SHLF_END = *Zero
     C                   Eval      SHLF_END = CARTUSED
     C                   Eval      END_CART# = END_CART# - 1
     C                   EndIf
     C                   If        SHLF_END = 1 and SkipShelves >= 1
     C                   Eval      SHLF_END = CARTUSED
     C                   Eval      END_CART# = END_CART# - 1
     C                   EndIf
    ?C                   EndSl

     C* 1/04/2011 WJB    If        End_Cart# <> CARTSEQ#
     C* 1/04/2011 WJB    Eval      NEWCART  = 'Y'
     C* 1/04/2011 WJB    EndIf

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Stuff20 -  FILL CARTS WITH ORDERS SKIPPING 1 SHELF :
      *?  :.........................................................:
    ?C     Stuff20       BegSr                                                  ?

     C                   Eval      PREFCART = 9
     C                   Eval      CARTUSED = 9
     C                   Eval      FitsOther = 'Y'
     C                   Eval      From_Rule = '-'
     C                   Eval      To_Rule = '-'
     C                   Eval      NEWCART  = ' '                               ?Set NewCart Flag
      *?        Start New Cart
     C                   If        PGSKIP <> 'N' and (
     C                             New_ShipVia or
     C                             New_Truck <> ' ' or
     C                             PGSKIP    = 'Y' )
     C                   Eval      NEWCART  = 'Y'                               ?Set NewCart Flag
     C                   EndIf
      *?   Where to Start...
    ?C                   Select                                                 ?
      *?        Start on a New Cart.
    ?C                   When      NEWCART = 'Y'
     C                   Eval      From_Rule = 'F'
     C                   Eval      CARTSEQ# = END_CART# + 1
     C                   Eval      SHLF_STR = 1
     C                   Eval      SHLF_END = 0
     C                   Eval      CARTUSED = PREFCART
     C                   Eval      NEWCART  = 'Y'
      *?        When this order has NO FLATS...
    ?C                   When      SHELFCNT = *Zero
     C                   Eval      From_Rule = 'Z'
     C                   Eval      CARTSEQ# = END_CART#
     C                   Eval      SHLF_STR = SHLF_END
     C                   Eval      NEWCART  = ' '
     C                   Eval      CARTUSED = PREFCART
      *?        Reposition Based on Last Record if Next Cart is specified.
    ?C                   When      Next_Cart# > CARTSEQ#                        ?
     C                   Eval      From_Rule = 'G'
     C                   Eval      CARTSEQ# = Next_Cart#
     C                   Eval      SHLF_STR = Next_Shelf
     C                   Eval      SHLF_END = 0
     C                   Eval      NEWCART  = 'Y'
     C                   If        Next_CartT <> *Zeros                         ?Check Cart Type
     C                   Eval      CARTUSED = Next_CartT
     C                   EndIf
      *?        Start on a New Cart if Large Order ( >1 cart )
    ?C*                  When      SHELFCNT > PREFCART and PGSKIP <> 'N'
     C*                  Eval      From_Rule = 'H'
     C*                  Eval      CARTSEQ# = END_CART# + 1
     C*                  Eval      SHLF_STR = 1
     C*                  Eval      CARTUSED = PREFCART
     C*                  Eval      NEWCART  = 'Y'
      *?        Start on Same Cart if there is room.
    ?C                   When      SHLF_END               < CARTUSED            ?
     C                   Eval      From_Rule = 'I'
     C                   Eval      CARTSEQ# = END_CART#
     C                   Eval      SHLF_STR = SHLF_END + 1
     C                   Eval      CARTUSED = CARTUSED
     C                   Eval      NEWCART  = ' '
      *?        Start on Next Cart if there is no room on this one.
    ?C                   When      SHLF_END + SkipShelves >= CARTUSED            ?
     C                   Eval      From_Rule = 'J'
     C                   Eval      CARTSEQ# = END_CART# + 1
     C                   Eval      SHLF_STR = 1
     C                   Eval      CARTUSED = PREFCART
     C                   Eval      NEWCART  = 'Y'
    ?C                   EndSl
      *?   Where to End...
    ?C                   Select                                                 ?
      *?        When this order has NO FLATS...
    ?C                   When      SHELFCNT = *Zero
     C                   Eval      To_Rule = '2'
     C                   Eval      END_CART#  = END_CART#
     C                   Eval      NEXT_CART# = END_CART#
     C                   Eval      SHLF_END   = SHLF_END
      *?        All Other Orders...
    ?C                   OTHER
     C                   Eval      To_Rule = '3'
     C                   Eval      END_CART# = %Int( %Float(CARTSEQ# +
     C                             (SHLF_STR-1+SkipShelves+SHELFCNT#)/CARTUSED))
     C                   Eval      SHLF_END# = ((CARTSEQ#-1) * CARTUSED)
     C                                       + SHLF_STR - 1
     C                                       + SkipShelves
     C                                       + SHELFCNT#
     C                   Eval      SHLF_END =
     C                             SHLF_END# - ((END_CART#-1) * CARTUSED )
     C                   If        SHLF_END = *Zero
     C                   Eval      SHLF_END = CARTUSED
     C                   Eval      END_CART# = END_CART# - 1
     C                   EndIf
     C                   If        SHLF_END = 1 and SkipShelves >= 1
     C                   Eval      SHLF_END = CARTUSED
     C                   Eval      END_CART# = END_CART# - 1
     C                   EndIf
    ?C                   EndSl

     C* 1/04/2011 WJB    If        End_Cart# <> CARTSEQ#
     C* 1/04/2011 WJB    Eval      NEWCART  = 'Y'
     C* 1/04/2011 WJB    EndIf

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      GetLocations - Get Greenhouse Locations            :
      *?  :.........................................................:
    ?C     GetLocations  BegSr                                                  ?

     C                   Clear                   SQ_PSECT
     C                   Eval      POLE_SEQ = *Zero
     C                   Eval      Previous_Cart = *Zero
    ?C     Location      KList                                                  ?
    ?C                   KFld                    GHSECT                         ?Sect
    ?C                   KFld                    GHNORS                         ?N/S
    ?C                   KFld                    GHBAY                          ?Bay
    ?C                   KFld                    GHLORR                         ?L/R
    ?C                   KFld                    POLE_SEQ          2 0          ?Pole / No.
     C                   Eval      RRN02 = 1
    ?C     RRN02         Chain     PSR30002                                     ?
     C                   MoveA     IN60          *In(60)
    ?C                   DoW       %Found(PSR300FM)
    ?C                   Select
      *?  If it's a New Ship Via, get a new starting point. (If Specified)
    ?C                   When      %Scan(Pink:PGNAME:1) > 0 and PDSECT <> 0
     C                   Eval      GHSECT    = PDSECT
     C                   Eval      GHNORS    = PDNORS
     C                   Eval      GHBAY     = PDBAY
     C                   Eval      GHLORR    = PDLORR
     C                   Eval      POLE_SEQ  = PDPOLE
    ?C     Location      Chain     FPSECT
     C                   Eval      POLE_SEQ  = GHPSEQ
    ?C     Location      SetLL     FPSECTSQ
      *?  If it's a Forced Location, don't reposition for this cart
    ?C                   When      FORCE_LOC <> *Blanks
     C                   Eval      Good_Reads = *Zero
     C                   Eval      Previous_Cart = END_CART#
      *?      ....   Logic to Follow ....

      *?  How many good records do we need to read ?
    ?C                   Other
     C                   Eval      Good_Reads = CARTSEQ# - Previous_Cart
     C                   Eval      Previous_Cart = CARTSEQ#

      *?  Get number of Good_Reads needed!
     C                   If        Good_Reads > 0
     C                   Eval      X = *Zero
    ?C                   DoW       X < Good_Reads and Good_Reads > 0            ?
    ?C                   Read      FPSECTSQ
     C                   If        %EOF(FPSECTSQ)
     C                   Clear                   SQ_PSECT
     C                   Leave
     C                   Else
     C                   If        GHUSED = 'Y'
     C                   Eval      X = X + 1
     C                   EndIf
     C                   EndIf
    ?C                   EndDo
     C                   EndIf
     C                   Eval      sHSECT    = GHSECT
     C                   Eval      sHNORS    = GHNORS
     C                   Eval      sHBAY     = GHBAY
     C                   Eval      sHLORR    = GHLORR
     C                   Eval      sHPOLE    = GHPOLE
     C                   Eval      sHPSEQ    = GHPSEQ
     C                   Eval      sHCART    = GHCART

     C                   Move      GHBAY         GHBAY@            2
     C                   Move      GHPOLE        GHPOLE@           2
     C                   Eval      PGLOC =       GHBAY@
     C                                   +       GHLORR
     C                                   +       GHPOLE@
     C                                   +       GHCART

    ?C                   EndSl
     C                   Eval      *In28 = *Off
     C                   If        NEWCART = 'Y'
     C*  wjb 1/04/2011   Eval      *In61 = *On
     C                   Else
     C                   Eval      *In61 = *Off
     C                   EndIf
     C                   If        %Scan(Pink:PGNAME:1) > 0
     C                   Eval      *In60 = *On
     C                   Else
     C                   Eval      *In60 = *Off
     C                   EndIf
     C                   MoveA     *In(60)       IN60
    ?C                   Update    PSR30002
     C                   Eval      RRN02 = RRN02 + 1
    ?C     RRN02         Chain     PSR30002                                     ?
     C                   MoveA     IN60          *In(60)
    ?C                   EndDo                                                  ?
    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      PutLocations - Put Locations on Orders             :
      *?  :.........................................................:
    ?C     PutLocations  BegSr                                                  ?

     C                   Eval      RRN02 = 1
    ?C     RRN02         Chain     PSR30002                                     ?
     C                   MoveA     IN60          *In(60)
    ?C                   DoW       %Found(PSR300FM)
     C* wjb 12/20/2010   If        Force_Loc <> 'X' and PGLOC <> *Blanks
     C                   If        Force_Loc <> 'X' and not *In60
    ?C     PGORD#        Chain     FHORDR
     C                   Eval      OHLOC = PGLOC
     C                   If        %Found(FHORDR)
    ?C                   Update    HORDR
     C                   EndIf
    ?C     PGORD#        Chain     FPPO
     C                   Eval      POLOWC = %Trim(%EditW(SHLF_STR:'  '))
     C                              + '-' + %Trim(%EditW(SHLF_END:'  '))
     C                   If        END_CART# <> CARTSEQ#
     C                   Eval      POLOWC = %Trim(POLOWC) + '+'
     C                   EndIf
     C*                  If        Force_Loc = 'Y'
     C*                  Eval      POLOWC = *Blanks
     C*                  EndIf
     C                   If        CARTUSED <=10
     C                   Eval      POLOWF = 'DS  9'
     C                   Else
     C                   Eval      POLOWF = '12'
     C                   EndIf
     C                   If        %Found(FPPO)
    ?C                   Update    RPPO
     C                   Else
     C                   Eval      POORD# = PGORD#
     C                   Eval      POTAKN = 'PS'
     C                   Eval      POENTR = 'PS'
     C                   Eval      POPICK = 'PS'
     C                   Eval      POPACK = 'PS'
     C                   Eval      POCONF = 'PS'
    ?C                   Write     RPPO
     C                   EndIf
     C                   EndIf
     C                   Eval      RRN02 = RRN02 + 1
    ?C     RRN02         Chain     PSR30002                                     ?
     C                   MoveA     IN60          *In(60)
    ?C                   EndDo                                                  ?

      *?  Update Plugs Control Record
     C                   Z-ADD     0             PSCOMP
    ?C     PSCOMP        Chain     FPLGSCTL                           57
    ?C   57              Do                                                     ?
     C                   CLEAR                   RPLGSCTL
     C                   Eval      PSSTAT = 'A'
     C                   Eval      PSCOMP = *Zero
    ?C                   EndDo                                                  ?
     C     SDateYMD7     IfGT      PSLOCD
     C                   Z-ADD     SDateYMD7     PSLOCD
     C                   Z-ADD     SGMSTR        PSLOCM
     C                   End
     C                   Eval      PSTIME = $Now()
     C                   Eval      PSDTLA = $MDYDate($Date(0))
     C                   Eval      PSUSER = $User()
    ?C   57              Write     RPLGSCTL
    ?C  N57              Update    RPLGSCTL

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      GetSizes - Get Plug Tray Sizes                     :
      *?  :.........................................................:
    ?C     GetSizes      BegSr                                                  ?

     C                   Eval      Small_Trays = *Zero
     C                   Eval      Large_Trays = *Zero

    ?C     OHORD#        SetLL     FIORDR                                       ?
    ?C     OHORD#        ReadE     FIORDR                                       ?
     C                   Clear                   RMSIZC

    ?C                   DoW       not %EOF(FIORDR)                             ?
    ?C     OISIZE        Chain     FMSIZC
     C                   If        OISTAT = 'A' and
     C                             OIRVDT = SDateYMD7 and
     C                             OIITYP = ' ' and
     C                             OIQORD - OIQSHP > 0 and
     C                             SCCATG = 'PLUG'
    ?C     OISIZE        Chain     FMSIZE
    ?C                   Select
    ?C                   When      SZSHLV >= 10
     C                   Eval      Small_Trays = Small_Trays + OIQORD - OIQSHP
    ?C                   When      SZSHLV < 10
     C                   Eval      Large_Trays = Large_Trays + OIQORD - OIQSHP
    ?C                   EndSl                                                  ?
     C                   EndIf
    ?C     OHORD#        ReadE     FIORDR                                       ?
    ?C                   EndDo                                                  ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      ClrError - Clear Error Message Subfile             :
      *?  :.........................................................:
    ?C     ClrError      BegSr                                                  ?

     C                   MOVE      'C'           $#MSFN            1            ?
     C                   ExSr      SRMSGF                                       ?
     C                   Eval      ErrCount = *Zero                             ?
     C                   Eval      *In50 = *Off                                 ?Error Indicator

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      SndError - Send an Error Message to the PGMMSGQ    :
      *?  :.........................................................:
    ?C     SndError      BegSr                                                  ?

     C                   MOVE      'S'           $#MSFN            1            ?
     C                   ExSr      SRMSGF                                       ?
     C                   Eval      ErrCount = ErrCount + 1                      ?
     C                   Eval      *In50 = *On                                  ?Error Indicator

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      * ? :      SRMSGF - Clear or send messages to Pgm msg queue   :
      *?  :.........................................................:
    ?C     SRMSGF        BegSr                                                  ?

      *? Define Parameter List - define variables         ?

     C     PLMSGF        PLIST                                                  ?
     C                   Parm                    $#PGMQ           10            ?Pgm Msg Queue
     C                   Parm                    $#MSGF           10            ?Message File
     C                   Parm                    $#MSGL           10            ?Library
     C                   Parm                    $#MSID            7            ?Message Id
     C                   Parm                    $#MSGD          100            ?Message Data
     C                   Parm                    $#MSKY            4            ?Message Key
     C                   Parm                    $#MSFN            1            ?Send or Clear

      *? Call Msg processing CL                           ?

     C                   CALL      'XAMSFC'      PLMSGF                         ?

    ?C                   EndSr                                                  ?

      *?  ..........................................................
      *?  :   Run system command                                   :
      *?  :........................................................:
     C     $Command      BegSR
      *? Format the command String.  Put vaiable in place in the string.

      *?   |P?=Printer ID?    ?Put the Printer Name in the Override command?
     C*                  Eval      #Printer = PrtToUse
     C*                  DoW       %Scan('|P':Command) <> 0
     C*                  Eval      Command = %REPLACE
     C*                            (%Trim(#Printer) + ')': Command :
     C*                              %SCAN('|P': Command))
     C*                  EndDo

      *?   ~ ?=Blank that needs to be removed??Replace with nothing?
     C                   DoW       %Scan('~':Command) <> 0
     C                   Eval      Command =
     C                               %SubSt(Command:1:%Scan('~':Command)-1)
     C                             + %SubSt(Command:%Scan('~':Command)+1:
     C                               %Len(Command) - %Scan('~':Command))
     C                   EndDo

      *? Execute the Command using QCMDEXC.
     C                   CALLP     QCmdExc(Command:%len(%Trim(Command)))

     C                   EndSR


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C                   MOVE      ##PGM         $#PGMQ                         ?PGM MSG QUEUE
     C                   MOVEL     'KPMSGF'      $#MSGF                         ?MSG FILE N/A
     C                   MOVEL     '*LIBL'       $#MSGL                         ?LIBRARY  N/A
     C                   MOVE      '*******'     $#MSID                         ?MESSAGE ID

     C                   Eval      Today = $Date(0)                             ?Today MDY

     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

    ?C                   EndSr                                                  ?
**
OVRPRTF FILE(PSR300P) PAGESIZE(11 8.5 *UOM) FORMTYPE(*NAR) OVRSCOPE(*JOB) PAGRTT(0) OUTQ(|P
OVRPRTF FILE(PSR300P) PAGESIZE(14 8.5 *UOM) FORMTYPE(*LONG) OVRSCOPE(*JOB) PAGRTT(0) OUTQ(|P
