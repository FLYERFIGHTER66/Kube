     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:                     Ready Bay Check Out                    :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  April 2004           ? Kube-Pak Corporation ?    :
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
      *? :  Scrn02   -?Display Screen 02                             ?:
      *? :  Load01   -?Load Screen 01                                ?:
      *? :  Load02   -?Load Screen 02                                ?:
      *? :  Edit01   -?EDIT Screen 01                                ?:
      *? :  Edit02   -?EDIT Screen 02                                ?:
      *? :  ClrError -?Clear Error MEssage Subfile                   ?:
      *? :  SndError -?Send an Error Message to the PGMMSGQ          ?:
      *? :  SRMSGF   -?Clear or send messages to Pgm msg queue       ?:
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
      *? :  25      ?SFLDSP, SFLDSPCTL, SFLCLR(N)                    ?:
      *? :  26      ?SFLDSP (Subfile has Data)                       ?:
      *? :  27      ?SFLEND                                          ?:
      *? :  28      ?SFLNXTCHG                                       ?:
      *? :  40      ?Lookup Indicator                                ?:
      *? :  50      ?Error Indicator (All Errors)                    ?:
      *? :  70      ?Push Buttone Default 70 = Yes, N70 = No         ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Edit Log                                                ?:
      *? :                                                           ?:
WJB   *? :  WJB    -? 5/11/04 - Added Logic to Update FMCUST         ?:
WJB   *? :  WJB    -? 5/14/04 - Added Logic to write correct info    ?:
WJB   *? :          ?           to FALITEM. (Chain to FDLOTRD)       ?:
      *? :............................................................:
     FFXG062FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFLOSSD    UF A E           K DISK                                         ?Loss Details
     FFPARTIAL  UF A E           K DISK                                         ?Partials (by Tag)
     FFPARTLOT  IF   E           K DISK    RENAME(RPARTIAL:RPARTLOT)            ?Partials (by Lot)
     F                                     Prefix(PL_)                          ?.
     FFLOSSLOT  UF A E           K DISK                                         ?Loss Lot Details
     FFTRAY     UF A E           K DISK                                         ?Tray File
     FFMINVT    IF   E           K DISK                                         ?Item Master
     FFMSIZD    IF   E           K DISK                                         ?Size Code Add Desc.
     FFMEMPLOY  IF   E           K DISK                                         ?Employee Master
     FFCARTDTTMSIF   E           K DISK                                         ?Cart Detail File
     FFTRAYFIXEDUF A E           K DISK                                         ?Fixed Trays

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$IsDate#
    ?D/COPY QFunctDefn,$GetOrder#
    ?D/COPY QFunctDefn,$UnitPrice
    ?D/COPY QFunctDefn,$PrintPick
    ?D/COPY QFunctDefn,$TimeStamp
    ?D/COPY QFunctDefn,$Allocate
    ?D/COPY QFunctDefn,$DftPrt
    ?D/COPY QFunctDefn,$User

      *? Field Definitions
     D   RRN02         S              4  0 Inz(0)                               ?SFLRRN Screen 02
     D   RRN04         S              4  0 Inz(0)                               ?SFLRRN Screen 04
     D   ErrCount      S              2  0 Inz(0)                               ?Error Count
     D   Nines8        S              8S 0 Inz(99999999)                        ?8S 0 all 9's
     D   Nines15       S             15A   Inz('999999999999999')               ?15A  all 9's
     D   x             S              4S 0 Inz(0)                               ?Array Counter
     D   CountItem     S              4S 0 Inz(0)                               ?Tray Count for Item
     D   Now           S              6S 0 Inz(0)                               ?Array Counter
     D   Today         S               D                                        ?Today
     D   TodayMDY      S              6S 0 Inz(0)                               ?Today  ( MDY )
     D   TodayYMD7     S              7S 0 Inz(0)                               ?Today  ( CYMD7 )
     D   ThisMonday    S              6S 0 Inz(0)                               ?Monday ( MDY )
     D   ThisMonCYMD   S              7S 0 Inz(0)                               ?Monday ( CYMD )
     D   Tax1          S              5S 2 Inz(0)                               ?Tax:State Tax
     D   Tax2          S              5S 2 Inz(0)                               ?Tax:County Tax
     D   Tax3          S              5S 2 Inz(0)                               ?Tax:Local Tax
     D   TotalTax01    S              7S 2 Inz(0)                               ?Sum:State Tax
     D   TotalTax02    S              7S 2 Inz(0)                               ?Sum:County Tax
     D   TotalTax03    S              7S 2 Inz(0)                               ?Sum:Local Tax
     D   TotalOrder    S              9S 2 Inz(0)                               ?Total Order Value
     D   CurrentItem   S             15A                                        ?Item being processe
     D   OrderSeq#     S              3S 0                                      ?Order Detail Seq. #
     D   Printer       S             10                                         ?Printer to Use
     D   FixDate       S              7S 0
     D   ShipDate      S              7S 0                                      ?Lot Ship Date
     D   QtyOrdered    S              7S 0                                      ?Quantity Ordered
     D   QtySown       S              7S 0                                      ?Quantity Sown
     D   QtyLost       S              7S 0                                      ?Quantity Lost
     D   TotalLoss     S              7S 0                                      ?Quant Lost Total
     D   Scanned       S              7S 0                                      ?Quant Scanned
     D   Unfixed       S              7S 0                                      ?Quant Unfixed
     D   Partial       S              7S 0                                      ?Count Partials
     D   PartSum       S              7S 2                                      ?Sum Partials
     D   SREASON       S              1S 0
     D   PERCENTFULL   S                   Like(LDPCTF)
    ?D StartTag#       S              8S 0
    ?D EndTag#         S              8S 0
     D  Card#          S                   Like(EMCARD)
     D   File#         S                   Like(EMFILE)
     D  PlusTray       S              4P 0 Inz(+1)                              ?Plus One Tray
     D  AttTimestamp   S                   Like(TFATTT)
     D  LDCODE1        S                   Like(LDCODE)

      *? Indicators
     D   DUMMY         S               N   Inz(*Off)                            ?Dummy Routine IND
     D   Duplicates    S               N   Inz(*Off)                            ?Duplicate Tag Flag
     D   BadTag#       S               N   Inz(*Off)                            ?Tray not found
     D   Clear04       S               N   Inz(*Off)                            ?Clear S4 Arrays
     D   MultPartials  S               N   Inz(*Off)                            ?Multiple Partials

      *? Arrays
     D   Res           S             15A   Dim(0004) CTDATA                     ?Reasons
     D   RCD           S              3A   Dim(0004) CTDATA                     ?Reason Codes
     D   SIZ           S              3A   Dim(0007) CTDATA                     ?Tray Sizes
     D   RWZ           S              2S 0 Dim(0007) ALT(SIZ)                   ?Number of Rows
     D   TagsS4        S              8S 0 Dim(0064) Inz(99999999)              ?Scanned Tags Scrn04
     D   TrayS4        S             15A   Dim(0064) Inz('999999999999999')     ?Tag Tray Info S04
     D   Tags          S              8S 0 Dim(3000) Inz(99999999)              ?Verified Tags
     D   Tray          S             15A   Dim(3000) Inz('999999999999999')     ?Tag Tray Info

      *? Data Structures
     D                SDS
     D  ##PGM            *PROC
     D  User                 254    263

     D TrayDS          DS
     D  TRITEM                             INZ('999999999999')                  ?Tray Item Number
     D  TRSIZE                             INZ('999')                           ?Tray Size

     C     *INLR         DOUEQ     *ON                                          ?COMMENT

     C                   SELECT                                                 ?
     C     Screen        WhenEq    1                                            ?
    ?C                   ExSr      Edit01                                       ?
     C     Screen        WhenEq    2                                            ?
    ?C                   ExSr      Edit02                                       ?
     C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
    ?C                   Write     FXG06201
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FXG06201
    ?C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Scrn02 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn02        BegSr                                                  ?
     C                   Z-Add     02            Screen            3 0          ?Screen  Number
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FXG06202
    ?C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

     C                   Eval      Tag#     = *Zero
     C                   Eval      LastTag# = *Zero
     C                   Eval      SREASON = 1

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load02 - Load Screen 02                            :
      *?  :.........................................................:
    ?C     Load02        BegSr                                                  ?

     C                   Eval      Tag#     = *Zero
     C                   Eval      RowsLeft = *Zero
     C                   Eval      SREASON = 2

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

    ?C     Tag#          Chain     FTRAY

    ?C                   SELECT                                                 ?
      *? Check Functions
    ?C                   When      *In03 = *ON                                  ?
     C                   MOVE      *ON           *INLR                          ?

    ?C                   When      *In11 = *ON or                               ?
    ?C                             Tag# = LastTag#                              ?
    ?C                   ExSr      Load02
    ?C                   ExSr      Scrn02

    ?C                   When      Tag# = *Zero                                 ?
     C                   Eval      $#MSGD = *Blanks
     C                   Eval      $#MSID = 'TAG0100'                           ?
    ?C                   ExSr      SndError                                     ?
    ?C                   ExSr      Scrn01

    ?C                   When      not %Found(FTRAY)                            ?
     C                   Eval      $#MSGD = %char(Tag#)                         ?
     C                   Eval      $#MSID = 'TAG0102'                           ?
    ?C                   ExSr      SndError                                     ?
    ?C                   ExSr      Scrn01

      *? If passed edit write Loss Detail record
     C                   Other                                                  ?

    ?C                   ExSr      Wrt_TRAYFIXED                                ?
    ?C                   ExSr      Wrt_FLOSSD                                   ?
     C                   Eval      Tag# = *Zero                                 ?
    ?C                   ExSr      Scrn01                                       ?
     C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit02 - EDIT Screen 02                            :
      *?  :.........................................................:
    ?C     Edit02        BegSr                                                  ?

     C                   MoveA     '0000000000'  *In(50)                        ?Clr Err Indicators

    ?C     Tag#          Chain     FTRAY
     C                   If        %found(FTRAY)
     C                   Eval      X = 1
     C                   Eval      *In51 = *On                                  ?Got a good Tag
     C     TRSIZE        Chain     FMSIZD
     C                   If        %Found(FMSIZD)
     C                   Eval      RowsTotal = SZROWS                           ?Number of Rows
     C                   Else
     C                   Eval      RowsTotal = *Zero                            ?Number of Rows
     C                   EndIf
     C                   EndIf

     C                   Eval      Card# = Employee
     C                   Call      '#EMPFILE#'
     C                   Parm                    Card#
     C                   Parm                    File#
     C                   Parm                    name25           25
    ?C     File#         Chain     FMEMPLOY
     C                   If        %found(FMEMPLOY)
     C                   Eval      *In52 = *On                                  ?Got a Good Employee
     C                   Eval      Name =                                       ?Populate Emp. Name
     C                             %Subst((%Trim(EMLAST)+', '+EMFIRS):1:20)
     C                   Else
     C                   Eval      *In52 = *Off                                 ?Not a Good Employee
     C                   Eval      Name = *Blanks                               ?Inz Emp. Name
     C                   EndIf

    ?C                   SELECT                                                 ?
      *? Check Functions
    ?C                   When      *In03 = *ON                                  ?
     C                   MOVE      *ON           *INLR                          ?

    ?C                   When      *In11 = *ON                                  ?
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01

    ?C                   When      Tag# = LastTag#                              ?
     C                   MOVE      *ON           *INLR                          ?

    ?C                   When      Tag# = *Zero                                 ?
     C                   Eval      $#MSGD = *Blanks
     C                   Eval      $#MSID = 'TAG0100'                           ?
    ?C                   ExSr      SndError                                     ?
     C                   Eval      *In51 = *Off                                 ?Pos.to Tag
    ?C                   ExSr      Scrn02

    ?C                   When      not %Found(FTRAY)                            ?
     C                   Eval      $#MSGD = %char(Tag#)                         ?
     C                   Eval      $#MSID = 'TAG0102'                           ?
    ?C                   ExSr      SndError                                     ?
     C                   Eval      *In51 = *Off                                 ?Pos.to Tag
    ?C                   ExSr      Scrn02

    ?C                   When      Employee = *Zero                                 ?
     C                   Eval      $#MSGD = *Blanks
     C                   Eval      $#MSID = 'FXG0604'                           ?
    ?C                   ExSr      SndError                                     ?
     C                   Eval      *In52 = *Off                                 ?Pos.to Employee
    ?C                   ExSr      Scrn02

    ?C                   When      not %Found(FMEMPLOY)
     C                   Eval      $#MSGD = %char(Employee)                     ?
     C                   Eval      $#MSID = 'EMP0101'                           ?
    ?C                   ExSr      SndError                                     ?
    ?C                   ExSr      Scrn02

    ?C                   When      RowsLeft = *Zero                                 ?
     C                   Eval      $#MSGD = *Blanks
     C                   Eval      $#MSID = 'FXG0601'                           ?
    ?C                   ExSr      SndError                                     ?
    ?C                   ExSr      Scrn02

    ?C                   When      RowsLeft > RowsTotal                             ?
     C                   Eval      $#MSGD = %EditW(RowsLeft:'0 ') +
     C                                      %EditW(RowsTotal:'0 ')
     C                   Eval      $#MSID = 'FXG0602'                           ?
    ?C                   ExSr      SndError                                     ?
     C                   Eval      *In52 = *On                                  ?Pos.to RowsLeft
    ?C                   ExSr      Scrn02

    ?C                   When      RowsLeft = RowsTotal                             ?
     C                   Eval      $#MSGD = %EditW(RowsLeft:'0 ') +
     C                                      %EditW(RowsTotal:'0 ')
     C                   Eval      $#MSID = 'FXG0603'                           ?
    ?C                   ExSr      SndError                                     ?
     C                   Eval      *In52 = *On                                  ?Pos.to RowsLeft
    ?C                   ExSr      Scrn02

      *? If no Actions or errors then Update Losses, Initialize, & Redisplay
    ?C                   Other                                                  ?

     C                   ExSr      ChkMultPart
     C                   If        MultPartials
     C                   ExFmt     FXG06203
     C                   Endif
     C                   If        *In13 or not MultPartials
     C                   Eval      PercentFull = ( RowsLeft / RowsTotal ) * 100
    ?C                   ExSr      Wrt_TRAYFIXED                                ?
    ?C                   ExSr      Wrt_PARTIAL                                  ?
    ?C                   ExSr      Wrt_FLOSSD                                   ?
     C                   EndIf
     C                   Eval      TAG#      = *Zero
     C                   Eval      RowsLeft  = *Zero
     C                   Eval      RowsTotal = *Zero
     C                   Eval      Employee  = *Zero
     C                   Eval      Name      = *Blanks
     C                   Eval      *In51     = *Off
     C                   Eval      *In52     = *Off
    ?C                   ExSr      Scrn02                                       ?
    ?C                   EndSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ClrError - Clear Error MEssage Subfile             :
      *?  :.........................................................:
    ?C     ClrError      BegSr                                                  ?

     C                   MOVE      'C'           $#MSFN            1            ?
    ?C                   ExSr      SRMSGF                                       ?
     C                   Eval      ErrCount = *Zero                             ?
     C                   Eval      *In50 = *Off                                 ?Error Indicator

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      SndError - Send an Error Message to the PGMMSGQ    :
      *?  :.........................................................:
    ?C     SndError      BegSr                                                  ?

     C                   MOVE      'S'           $#MSFN            1            ?
    ?C                   ExSr      SRMSGF                                       ?
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

      *?  ...........................................................
      *?  :      Wrt_FLOSSD - Write the Loss Detail Record          :
      *?  :.........................................................:
    ?C     Wrt_FLOSSD    BegSr                                                  ?

     C                   Eval      LastTag# = Tag#
      *? Only update Loss files if not Deleted tag. ?
    ?C     Tag#          Chain     FLOSSD
     C                   Eval      LDCODE1 = LDCODE
    ?C     LotKey        Chain     FLOSSLOT
    ?C     LotKey        KList
    ?C                   KFld                    TRITEM
    ?C                   KFld                    TRSIZE
    ?C                   KFld                    TRCRDT
    ?C     ItemKey       Chain     FMINVT
    ?C     ItemKey       KList
    ?C                   KFld                    TRITEM
    ?C                   KFld                    TRSIZE
     C*                  If        not %Found(FLOSSD)                           ?
     C*                            or  %Found(FLOSSD)                           ?
WJB  C*                            and LDCODE = 'P'
WJB  C*                            and LDCODE1 = 'P'
WJB  C*                            and LDCODE1 <> LDCODE
     C                   Eval      LastTag# = Tag#
     C                   Eval      LDTAG# = TRTAG#
     C                   Eval      LDCODE = %SUBST(RCD(SREASON):1:1)
     C                   Eval      LDITEM = TRITEM
     C                   Eval      LDSIZE = TRSIZE
     C                   Eval      LDLOSD = $Date7($DateMDY(FixDate))
     C                   Eval      LDSOWD = TRSCYM
     C                   Eval      LDREDY = TRCRDT
     C                   Eval      LDPRDC = TRPRDC
     C                   Eval      LDDTLA = $MDYDate($Date(0))
     C                   Eval      LDTIME = $Now()
     C                   Eval      LDUSER = $User()

      *?   Delete Partial record if it exists. ?
     C                   If        LDCODE <> 'P'
    ?C     Tag#          Chain     FPARTIAL
     C                   If        %Found(FPARTIAL)                             ?
    ?C                   Delete    RPARTIAL
     C                   EndIf
     C                   EndIf

     C                   If        not %Found(FLOSSD)                           ?
    ?C                   Write     RLOSSD
     C                   Else
    ?C                   Update    RLOSSD
     C                   EndIf


     C                   Eval      TRSTAT = %SUBST(RCD(SREASON):1:1)
     C                   If        RCD(SREASON) = 'DMP'
     C                   Eval      TRSTAT = 'M'
     C                   EndIf
     C                   Eval      TRREAS = RCD(SREASON)
     C                   Eval      TRDTLA = $MDYDate($Date(0))
     C                   Eval      TRTIME = $Now()
     C                   Eval      TRUSER = $User()
    ?C                   Update    RTRAY

     C                   Eval      StartTag# = Tag#
     C                   Eval      EndTag# = Tag#
     C                   Call      'RMVLOTINV'                                  ?Remove from Lot Inv
     C                   Parm                    StartTag#
     C                   Parm                    EndTag#

     C                   Eval      LDLOSD = $Date7($DateMDY(FixDate))
     C                   Eval      LDDES1 = IMDES1
     C                   Eval      LDLOOK = IMLOOK
     C                   Eval      LDCONT = LDCONT + 1
    ?C                   Call      'FXG061'                                     ?
    ?C                   Parm                    LDITEM
    ?C                   Parm                    LDSIZE
    ?C                   Parm      LDREDY        ShipDate
    ?C                   Parm      'F'           LDCODE
    ?C     LDQORD        Parm      0             QtyOrdered
    ?C     LDQSOW        Parm      0             QtySown
    ?C     LDCONT        Parm      0             QtyLost
    ?C     LDTLOS        Parm      0             TotalLoss
    ?C     LDSCAN        Parm      0             Scanned
    ?C     LDNOTC        Parm      0             Unfixed
    ?C     LDPART        Parm      0             Partial
    ?C     LDPRTT        Parm      0             PartSum

     C                   If        not %Found(FLOSSLOT)
    ?C                   Write     RLOSSLOT
     C                   Else
    ?C                   Update    RLOSSLOT
     C                   EndIf

     C*                  EndIf


    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Wrt_PARTIAL -  Write the Partial Detail Record     :
      *?  :.........................................................:
    ?C     Wrt_PARTIAL   BegSr                                                  ?

      *? Only update Loss files if not Deleted tag. ?
    ?C     Tag#          Chain     FPARTIAL
     C                   Eval      LastTag# = Tag#
     C                   Eval      LDTAG# = TRTAG#
     C                   Eval      LDCODE = %SUBST(RCD(SREASON):1:1)
     C                   Eval      LDITEM = TRITEM
     C                   Eval      LDSIZE = TRSIZE
     C                   Eval      LDLOSD = $Date7($DateMDY(FixDate))
     C                   Eval      LDSOWD = TRSCYM
     C                   Eval      LDREDY = TRCRDT
     C                   Eval      LDPRDC = TRPRDC
     C                   Eval      LDPCTF = PercentFull
     C                   Eval      LDDTLA = $MDYDate($Date(0))
     C                   Eval      LDTIME = $Now()
     C                   Eval      LDUSER = $User()

     C                   If        not %Found(FPARTIAL)                         ?
    ?C                   Write     RPARTIAL
     C                   Else
    ?C                   Update    RPARTIAL
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      ChkMultPart - Check for Multiple Partials          :
      *?  :.........................................................:
    ?C     ChkMultPart   BegSr                                                  ?

     C                   Eval      MultPartials = *Off
     C                   Z-Add     *Zero         CountParts        2 0
     C                   Z-Add     *Zero         SumParts          4 2
      *? If there is a tag on the partials file other than this one, there are multiples.
    ?C     LotKey        SetLL     FPARTLOT
    ?C     LotKey        ReadE     FPARTLOT
     C                   DoW       not %EOF(FPARTLOT)
     C                   If        PL_LDTAG# <> Tag#
     C                   Add       1             CountParts
     C                   Eval      SumParts = SumParts + (LDPCTF / 100)
     C                   Eval      MultPartials = *On
     C                   EndIf
    ?C     LotKey        ReadE     FPARTLOT
     C                   EndDo


    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Wrt_TRAYFIXED -  Write the FTRAYFIXED Record       :
      *?  :.........................................................:
    ?C     Wrt_TRAYFIXED BegSr                                                  ?

      *? Only update Loss files if not Deleted tag. ?
    ?C     TrayTime      Chain     FTRAYFIXED
    ?C     TrayTime      KList                                                  ?
    ?C                   KFld                    Tag#
    ?C                   KFld                    CDTIME
     C                   Eval      TFTAG# = Tag#
     C                   Eval      TFCART = CDCART
     C                   Eval      TFSTAT = %SUBST(RCD(SREASON):1:1)
     C                   Eval      TFCARD = Employee
     C                   Eval      TFTIME = CDTIME

     C                   Eval      EMFILE = Employee
    ?C                   Call      '#EMPFILE#'
    ?C                   Parm                    TFCARD
    ?C                   Parm                    File#             6 0
    ?C                   Parm                    name25           25
     C                   Eval      AttTimeStamp = $TimeStamp()
    ?C                   Call      '#ADDUSRTRY'
    ?C                   Parm                    File#
    ?C                   Parm                    PLUSTRAY
    ?C                   Parm      'F'           Job               1
    ?C                   Parm                    AttTimestamp

     C                   Eval      TFTIME = CDTIME
     C                   Eval      TFATTT = AttTimestamp

     C                   If        not %Found(FTRAYFIXED)                       ?
    ?C                   Write     RTRAYFIXED
     C                   Else
    ?C                   Update    RTRAYFIXED
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C     *Entry        PList                                                  ?
    ?C                   Parm                    CDTIME

    ?C     CDTIME        Chain     FCARTDTTMS

     C                   MOVE      ##PGM         $#PGMQ                         ?PGM MSG QUEUE
     C                   MOVEL     'KPMSGF'      $#MSGF                         ?MSG FILE N/A
     C                   MOVEL     '*LIBL'       $#MSGL                         ?LIBRARY  N/A
     C                   MOVE      '*******'     $#MSID                         ?MESSAGE ID

     C                   Time                    Now                            ?Time Now
     C                   Eval      Today = $Date(0)                             ?Today MDY
     C                   Eval      TodayMDY = $MDYDate(Today)                   ?Today MDY
     C                   Eval      TodayYMD7 = $Date7(Today)                    ?Today CYMD7
     C                   Eval      ThisMonday = $MDYDate($Monday(Today:'SAT'))  ?Monday MDY
     C                   Eval      ThisMonCYMD = $Date7($Monday(Today:'SAT'))   ?Monday CYMD
     C                   Eval      FixDate = TodayMDY                           ?Today MDY

    ?C                   ExSr      Load01                                       ?
    ?C                   ExSr      Scrn01                                       ?

    ?C                   EndSr                                                  ?
**  +....|....+<<<<< RES 15A Dim(4)
 Fixing Losses
 Partial Trays
  Trays Dumped
Trays Destroyed
**  +....|....+<<<<< RCD 1A Dim(4)
FIX  Fixing Losses
PRT  Partial Trays
DMP  Trays Dumped
BAD  Trays Destroyed
**  +....|....+<<<<< SIZ 3A Dim(5) |RWZ 2S0 Dim(5)
10234  102 Tray  3 x 17 x 2 Rows
10515  105 Tray  7 x 15 Rows
16218  162 Tray  9 x 18 Rows
28824  288 Tray 12 x 24 Rows
48 15  48  Tray 3.5x 15 Rows
50 10  50  Tray  5 x 10 Rows
51232  512 Tray 16 x 36 Rows
