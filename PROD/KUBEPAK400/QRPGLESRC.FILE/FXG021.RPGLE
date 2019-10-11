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
      *? :  Scrn03   -?Display Screen 03                             ?:
      *? :  Scrn04   -?Display Screen 04                             ?:
      *? :  Scrn05   -?Display Screen 05                             ?:
      *? :  Load01   -?Load Screen 01                                ?:
      *? :  Load02   -?Load Screen 02                                ?:
      *? :  Edit01   -?EDIT Screen 01                                ?:
      *? :  Edit02   -?EDIT Screen 02                                ?:
      *? :  Edit03   -?EDIT Screen 03                                ?:
      *? :  Edit04   -?EDIT Screen 04                                ?:
      *? :  Edit05   -?EDIT Screen 05                                ?:
      *? :  Edit06   -?EDIT Screen 06                                ?:
      *? :  Edit07   -?EDIT Screen 07                                ?:
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
      *? :  xxxxx  -?mm/dd/yy - xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx?:
      *? :............................................................:
     FFXG021FM  CF   E             WORKSTN

     FFMCARTS   IF   E           K DISK                                         ?Carts Master
     FFCARTDT   UF A E           K DISK                                         ?Cart Details
     FFMATTEND  IF   E           K DISK                                         ?Employee Master

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$TimeStamp
    ?D/COPY QFunctDefn,$AllocCart
    ?D/COPY QFunctDefn,$PrintPick
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
     D   WrkLLOC       S                   Like(CMLLOC)                         ?Last Known Location
     D   Cart#         S                   Like(CMCART)                         ?Last Known Location
    ?D StartTag#       S              8S 0
    ?D EndTag#         S              8S 0

      *? Indicators
     D   DUMMY         S               N   Inz(*Off)                            ?Dummy Routine IND
     D   Duplicates    S               N   Inz(*Off)                            ?Duplicate Tag Flag
     D   BadTag#       S               N   Inz(*Off)                            ?Tray not found
     D   Clear04       S               N   Inz(*Off)                            ?Clear S4 Arrays
     D  UseLockedCart  S               N   Inz(*Off)                            ?Use Locked Carts
     D  BadCartIsOK    S               N   Inz(*Off)                            ?OK to use bad cart

      *? Arrays
     D   RCD           S              3A   Dim(0003) CTDATA                     ?Reason Codes

      *? Data Structures
     D                SDS
     D  ##PGM            *PROC
     D  User                 254    263

     C     *INLR         DOUEQ     *ON                                          ?COMMENT

    ?C                   SELECT                                                 ?
    ?C     Screen        WhenEq    1                                            ?
     C                   ExSr      Edit01                                       ?
    ?C     Screen        WhenEq    2                                            ?
     C                   ExSr      Edit02                                       ?
    ?C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
    ?C                   Write     ASSUME                                       ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FXG02101
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Scrn02 - Display Screen 02                         :
      *?  :.........................................................:
    ?C     Scrn02        BegSr                                                  ?
     C                   Z-Add     02            Screen            3 0          ?Screen  Number
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FXG02102                                     ?
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

     C                   Clear                   FXG02101
     C                   Eval      BadCartIsOK = *Off

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load02 - Load Screen 02                            :
      *?  :.........................................................:
    ?C     Load02        BegSr                                                  ?

      *? Allocate this cart for Fixing Checkin
     C                   Eval      WrkLLOC = 'Fixing Checkin '
     C                   Eval      SCART# = CART#
     C                   Eval      Employee = *Zero
     C                   ExSr      AllocCart

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

     C                   Eval      Cart# = SCart#
    ?C     Cart#         Chain     FMCARTS

    ?C                   SELECT                                                 ?
      *? Check Functions
      *? - Exit
    ?C                   When      *In03 = *ON                                  ?
     C                   MOVE      *ON           *INLR                          ?
      *? - Create New Cart
    ?C                   When      not BadCartIsOK  and
    ?C                             not %Found(FMCARTS) and
    ?C                                 *In01 = *ON
     C                   Eval      BadCartIsOK = *On
     C                   Eval      UseLockedCart = *On
     C                   Eval      $#MSGD = %char(Cart#)                        ?Cart Number
     C                   Eval      $#MSID = 'FXG0002'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Scrn01
      *? - Cart Zero Not Allowed
    ?C                   When      Cart# = *Zero
     C                   Eval      $#MSGD = *Blanks
     C                   Eval      $#MSID = 'FXG0006'                           ?
     C                   ExSr      SndError                                     ?
     C                   Eval      *In51 = *On
     C                   ExSr      Scrn01
     C                   Eval      *In51 = *Off
      *? - Bad Cart Found
    ?C                   When      not BadCartIsOK  and
    ?C                             not %Found(FMCARTS) and
    ?C                             not *In01 = *ON
     C                   Eval      $#MSGD = %char(Cart#)                        ?
     C                   Eval      $#MSID = 'FXG0001'                           ?
     C                   ExSr      SndError                                     ?
     C                   Eval      *In51 = *On
     C                   ExSr      Scrn01
     C                   Eval      *In51 = *Off
      *? - Cart is Locked
    ?C                   When          CMSTAT <> 'A' and
    ?C                             not UseLockedCart and
    ?C                             not *In02
     C                   Eval      $#MSGD = %char(Cart#)
     C                   Eval      %subst($#MSGD:9:15) = CMLLOC                  ?
     C                   Eval      $#MSID = 'FXG0003'                           ?
     C                   ExSr      SndError                                     ?
     C                   Eval      *In52 = *On
     C                   ExSr      Scrn01
     C                   Eval      *In52 = *Off
      *? - Override Cart Lock
    ?C                   When          CMSTAT <> 'A' and
    ?C                             not UseLockedCart and
    ?C                                 *In02
     C                   Eval      UseLockedCart = *On
     C                   Eval      $#MSGD = %char(Cart#)
     C                   Eval      %subst($#MSGD:9:15) = CMLLOC                  ?
     C                   Eval      $#MSID = 'FXG0004'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Scrn01
      *? Edit Fields

      *? If no Actions then Display Screen 04
    ?C                   Other                                                  ?

     C                   ExSr      Load02                                       ?
     C                   ExSr      Scrn02                                       ?
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit02 - EDIT Screen 02                            :
      *?  :.........................................................:
    ?C     Edit02        BegSr                                                  ?

     C                   Call      '#EMPFILE#'
     C                   Parm      Employee      ATCARD
     C                   Parm                    ATFILE
     C                   Parm                    name             25
    ?C     ATTKEY        KList                                                  ?
    ?C                   KFld                    Today                          ?
    ?C                   KFld                    ATFILE                         ?
    ?C     ATTKEY        Chain     FMATTEND

    ?C                   Select                                                 ?
      *? Check Functions
    ?C                   When      *In03 = *ON                                  ?
     C                   Eval      SCart# = *Zero
     C                   Eval      *InLR = *On
    ?C                   When      *In06 = *ON                                  ?
     C                   Eval      $#MSID = 'RBR0005'                           ?
     C                   ExSr      SndError                                     ?
     C                   Eval      WrkLLOC = 'Fixing Cancel  '
     C                   ExSr      ReleaseCart
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
    ?C                   When      *In04 = *ON
    ?C                             or Employee = *Zero
    ?C                                and not *In08                             Vacuuming not Req'd
    ?C                                and not *In09                             Vacuum Label Missng
    ?C                   Call      'ATT020'                                     ?
    ?C                   Parm      'V'           Job               1
    ?C                   Parm                    Card#             9 0
     C                   Z-Add     Card#         Employee
     C                   ExSr      Scrn02                                       ?
    ?C                   When      not %Found(FMATTEND)                         ?
    ?C                                and not *In08                              Vacuuming not Req'd
    ?C                                and not *In09                              Vacuum Label Missng
     C                   Eval      $#MSID = 'FXG0007'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Scrn02                                       ?

    ?C                   Other                                                  ?
     C                   If        *In08 = *ON
     C                   Eval      Employee = 1                                  Vacuuming not Req'd
     C                   EndIf
     C                   If        *In09 = *ON
     C                   Eval      Employee = 5                                  Vacuum Label Missng
     C                   EndIf
     C                   ExSr      Wrt_CARTDT                                   ?
     C                   Eval      *InLR = *On                                  ?
    ?C                   EndSl                                                  ?

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      ClrError - Clear Error MEssage Subfile             :
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

      *?  ...........................................................
      *?  :      AllocCart - Allocate the cart to checkin           :
      *?  :.........................................................:
    ?C     AllocCart     BegSr                                                  ?

     C                   Eval      CMTIME =                                     ?Allocate Cart
     C                             $AllocCart(Cart#:'F':WrkLLOC:##PGM)

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ReleaseCart - Release Cart Checkin Cancelled       :
      *?  :.........................................................:
    ?C     ReleaseCart   BegSr                                                  ?

     C                   Eval      CMTIME =                                     ?Allocate Cart
     C                             $AllocCart(Cart#:'A':WrkLLOC:##PGM)

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Wrt_CARTDT - Write cart Details                    :
      *?  :.........................................................:
    ?C     Wrt_CARTDT    BegSr                                                  ?

     C                   Eval      CDCART = CART#                               ?Cart Number
     C                   Time                    CDDATE                         ?Checkin Date
     C                   Time                    CDSTRT                         ?Start Time
     C                   Time                    CDENDT                         ?End Time
     C                   Eval      CDCARD = Employee                            ?Employee
     C                   Eval      CDTRAZ = 0                                   ?Trays on Cart
     C                   Eval      CDUSED = 0                                   ?Trays used to Fix
     C                   Eval      CDFIXD = 0                                   ?Fixed Trays
     C                   Eval      CDPART = 0                                   ?Partial Trays
     C                   Eval      CDPROG = ##PGM                               ?Last Program
     C                   Eval      CDUSER = $User()                             ?Last User
     C                   Eval      CDTIME = CMTIME                              ?Change Timestamp
    ?C                   Write     RCARTDT

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C     *Entry        PList                                                  ?
    ?C                   Parm                    SCart#
     C                   MOVE      ##PGM         $#PGMQ                         ?PGM MSG QUEUE
     C                   MOVEL     'KPMSGF'      $#MSGF                         ?MSG FILE N/A
     C                   MOVEL     '*LIBL'       $#MSGL                         ?LIBRARY  N/A
     C                   MOVE      '*******'     $#MSID                         ?MESSAGE ID

     C                   Eval      Today = $Date(0)                             ?Today MDY
     C                   Eval      TodayMDY = $MDYDate(Today)                   ?Today MDY
     C                   Eval      TodayYMD7 = $Date7(Today)                    ?Today CYMD7
     C                   Eval      ThisMonday = $MDYDate($Monday(Today:'SAT'))  ?Monday MDY
     C                   Eval      ThisMonCYMD = $Date7($Monday(Today:'SAT'))   ?Monday CYMD

     C                   ExSr      Load01                                       ?
     C                   ExSr      ClrError                                     ?
     C                   ExSr      Scrn01                                       ?

    ?C                   EndSr                                                  ?
