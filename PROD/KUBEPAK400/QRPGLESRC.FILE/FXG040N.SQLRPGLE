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
      *? :  Load01   -?Load Screen 01                                ?:
      *? :  Load02   -?Load Screen 02                                ?:
      *? :  Load03   -?Load Screen 03                                ?:
      *? :  Edit01   -?EDIT Screen 01                                ?:
      *? :  Edit02   -?EDIT Screen 02                                ?:
      *? :  Edit03   -?EDIT Screen 03                                ?:
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
     FFXG040NFM CF   E             WORKSTN
WJB  FFMCARTS   IF   E           K DISK                                         ?Carts Master
WJB  FFCARTDT   IF   E           K DISK                                         ?Cart Details
WJB  FFTRAY     UF   E           K DISK                                         ?Tray File
WJB  FFLOSSD    IF   E           K DISK                                         ?Loss Details

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
     D   x             S              4S 0 Inz(0)                               ?Array Counter
     D   Now           S               T                                        ?Time Now
     D   WrkLLOC       S                   Like(CMLLOC)                         ?Last Known Location
     D   Cart#         S                   Like(CMCART)                         ?Last Known Location
     D   AttTimestamp  S                   Like(CMTIME)

      *? Indicators
     D  UseLockedCart  S               N   Inz(*Off)                            ?Use Locked Carts
     D  BadCartIsOK    S               N   Inz(*Off)                            ?OK to use bad cart

      *? Arrays
     D   Res           S             15A   Dim(0003) CTDATA                     ?Reasons
     D   RCD           S              3A   Dim(0003) CTDATA                     ?Reason Codes

      *? Data Structures
     D                SDS
     D  ##PGM            *PROC
     D  User                 254    263

     C     *INLR         DOUEQ     *ON                                          ?COMMENT

    ?C                   SELECT                                                 ?
    ?C     Screen        WhenEq    01                                           ?
     C                   ExSr      Edit01                                       ?
    ?C     Screen        WhenEq    02                                           ?
     C                   ExSr      Edit02                                       ?
    ?C     Screen        WhenEq    03                                           ?
     C                   ExSr      Edit03                                      ?
    ?C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
    ?C                   Call      'FXG021'                                     ?Cart Checkin
    ?C                   Parm                    SCart#                         ?Cart Checkin
    ?C*                  Write     ASSUME                                       ?
    ?C*                  Write     MSGCTL                                       ?
    ?C*                  ExFmt     FXG04001
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Scrn02 - Display Screen 02                         :
      *?  :.........................................................:
    ?C     Scrn02        BegSr                                                  ?
     C                   Z-Add     02            Screen            3 0          ?Screen  Number
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FXG04002                                     ?
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Scrn03 - Display Screen 03                         :
      *?  :.........................................................:
    ?C     Scrn03        BegSr                                                  ?
     C                   Z-Add     03            Screen            3 0          ?Screen  Number
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FXG04003                                     ?
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

     C                   Eval      SCART# = *Zero
     C                   Eval      BadCartIsOK = *Off

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load02 - Load Screen 02                            :
      *?  :.........................................................:
    ?C     Load02        BegSr                                                  ?

    ?C                   Call      'FXG041'                                     ?Fixed Flats+Fixedby
    ?C                   Parm                    CMTIME                         ?  Cart Time
    ?C                   Call      'FXG062'                                     ?Fixers/Partials
    ?C                   Parm                    CMTIME                         ?  Cart Time
     C                   ExSr      Upd_FCARTDT                                  ?
     C                   Eval      *In70 = *Off                                 ?Dft to "No"

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load03 - Load Screen 03                            :
      *?  :.........................................................:
    ?C     Load03        BegSr                                                  ?

    ?C     Cart#         SetGT     FCARTDT
    ?C     Cart#         ReadPE    FCARTDT
     C                   If        not %EOF(FCARTDT)
     C                   Eval      SORIG = CDTRAZ
     C                   Eval      SUSED = CDUSED
     C                   Eval      SFIXD = CDFIXD
     C                   Eval      SPART = CDPART
     C                   Eval      SOTHR = *Zero
     C                   Else
     C                   Eval      SORIG = *Zero
     C                   Eval      SUSED = *Zero
     C                   Eval      SFIXD = *Zero
     C                   Eval      SPART = *Zero
     C                   Eval      SOTHR = *Zero
     C                   EndIf

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

     C                   Eval      Cart# = SCart#
    ?C     Cart#         Chain     FMCARTS
    ?C     Cart#         SetGT     FCARTDT
    ?C     Cart#         ReadPE    FCARTDT

    ?C                   SELECT                                                 ?
      *? Check Functions
      *? - Exit
    ?C                   When      *In03 = *ON                                  ?
    ?C                             or SCart# = *Zero                            ?
     C                   MOVE      *ON           *INLR                          ?
      *? - Bad Cart Found
    ?C                   When      not %Found(FMCARTS) or
    ?C                                 %EOF(FCARTDT)
     C                   Eval      $#MSGD = %char(Cart#)                        ?Cart Number
     C                   Eval      $#MSID = 'FXG0001'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Scrn01
      *? - Cart is not allocated to fixing
    ?C                   When          CMSTAT <> 'F'
     C                   Eval      $#MSGD = %char(Cart#)
     C                   Eval      %subst($#MSGD:9:15) =  'Fixing Process'        ?
     C                   Eval      %subst($#MSGD:24:15) = 'Cart Check-out'        ?
     C                   Eval      $#MSID = 'FXG0005'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Scrn01
      *? Edit Fields

      *? If no Actions or Errors then Display Screen 02
    ?C                   Other                                                  ?

     C                   ExSr      Load02                                       ?
     C                   ExSr      Scrn02                                       ?
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit02 - EDIT Screen 02                            :
      *?  :.........................................................:
    ?C     Edit02        BegSr                                                  ?

    ?C                   SELECT                                                 ?
      *? Check Functions
    ?C                   When      *In06 = *ON                                  ?
     C                   Eval      $#MSID = 'RBR0005'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

    ?C                   When          SMORES <> 1
     C                             and SMORES <> 2
     C                             and SMORES <> 3
     C                   Eval      $#MSID = 'RBR0002'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Scrn02                                       ?

    ?C                   When         SMORES = 1                                ?1=Yes
    ?C                             or SMORES = 3                                ?1=Yes
     C                   ExSr      Load02                                       ?
     C                   ExSr      Scrn02                                       ?

    ?C                   When      SMORES = 2                                   ?2=No
     C                   ExSr      Load03                                       ?
     C                   ExSr      Scrn03                                       ?

    ?C                   Other                                                  ?
     C                   ExSr      Scrn02                                       ?
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit03 - EDIT Screen 03                            :
      *?  :.........................................................:
    ?C     Edit03        BegSr                                                  ?

    ?C                   SELECT                                                 ?
      *? Check Functions
    ?C                   When      *In06 = *ON                                  ?
     C                   Eval      $#MSID = 'RBR0005'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

    ?C                   When          Complete <> 1                            ?1=Yes
     C                             and Complete <> 2                            ?2=No
     C                             and Complete <> 3                            ?3=Yes
     C                   Eval      $#MSID = 'RBR0002'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Scrn03                                       ?

    ?C                   When         Complete = 1
    ?C                             or Complete = 3
     C                   Eval      WrkLLOC = 'Fixing Complete'
    ?C                   Call      '#EMPFILE#'
    ?C                   Parm                    CDCARD
    ?C                   Parm                    File#
    ?C                   Parm                    name             25
     C                   Eval      AttTimestamp = $TimeStamp()
    ?C                   Call      '#ADDUSRTRY'
    ?C                   Parm                    File#             6 0
    ?C                   Parm                    SORIG
    ?C                   Parm      'V'           Job               1
    ?C                   Parm                    AttTimestamp
     C                   ExSr      Upd_FCARTDT2                                 ?
     C                   ExSr      ReleaseCart
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

    ?C                   When      Complete = 2
WJB  C*                  Call      'FXG062'
WJB  C*                  Parm                    CMTIME                         ?  Cart Time
     C                   ExSr      Load02                                       ?
     C                   ExSr      Scrn02                                       ?

    ?C                   Other                                                  ?
     C                   ExSr      Scrn03                                       ?
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      ClrError - Clear Error Message Subfile             :
      *?  :.........................................................:
    ?C     ClrError      BegSr                                                  ?

     C                   MOVE      'C'           $#MSFN            1            ?
     C                   ExSr      SRMSGF                                       ?
     C                   Eval      *In50 = *Off                                 ?Error Indicator

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      SndError - Send an Error Message to the PGMMSGQ    :
      *?  :.........................................................:
    ?C     SndError      BegSr                                                  ?

     C                   MOVE      'S'           $#MSFN            1            ?
     C                   ExSr      SRMSGF                                       ?
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
      *?  :      ReleaseCart - Release Cart Checkin Cancelled       :
      *?  :.........................................................:
    ?C     ReleaseCart   BegSr                                                  ?

     C                   Eval      CMTIME =                                     ?Allocate Cart
     C                             $AllocCart(Cart#:'A':WrkLLOC:##PGM)

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Upd_FCARTDT - Update the Cart Detail File          :
      *?  :.........................................................:
    ?C     Upd_FCARTDT   BegSr                                                  ?

     C                   Time                    Now

    ?c/exec sql
    ?c+
    ?c+    Update   FCARTDT A
    ?c+    Set       CDTRAZ = (Select count(*) from FTRAYFIXED B
    ?c+                        where B.TFCART = A.CDCART
    ?c+                          and B.TFTIME = A.CDTIME )
    ?c+      ,       CDUSED = (Select count(*) from FTRAYFIXED B
    ?c+                        where B.TFCART = A.CDCART
    ?c+                          and B.TFSTAT = 'F'
    ?c+                          and B.TFTIME = A.CDTIME )
    ?c+      ,       CDFIXD = (Select count(*) from FTRAYFIXED B
    ?c+                        where B.TFCART = A.CDCART
    ?c+                          and B.TFSTAT = 'A'
    ?c+                          and B.TFTIME = A.CDTIME )
    ?c+      ,       CDPART = (Select count(*) from FTRAYFIXED B
    ?c+                        where B.TFCART = A.CDCART
    ?c+                          and B.TFSTAT = 'P'
    ?c+                          and B.TFTIME = A.CDTIME )
    ?c+      ,       CDENDT = :Now
    ?c+    where     CDCART = :Cart#
    ?c+      and     CDTIME = :CDTIME
    ?c+
    ?c/end-exec

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Upd_FCARTDT2 - Update the Cart Detail File         :
      *?  :.........................................................:
    ?C     Upd_FCARTDT2  BegSr                                                  ?

     C                   Time                    Now

    ?c/exec sql
    ?c+
    ?c+    Update   FCARTDT A
    ?c+    Set       CDENDT = :Now
    ?c+      ,       CDATTT = :AttTimestamp
    ?c+    where     CDCART = :Cart#
    ?c+      and     CDTIME = :CDTIME
    ?c+
    ?c/end-exec

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C                   MOVE      ##PGM         $#PGMQ                         ?PGM MSG QUEUE
     C                   MOVEL     'KPMSGF'      $#MSGF                         ?MSG FILE N/A
     C                   MOVEL     '*LIBL'       $#MSGL                         ?LIBRARY  N/A
     C                   MOVE      '*******'     $#MSID                         ?MESSAGE ID

     C                   ExSr      Load01                                       ?
     C                   ExSr      ClrError                                     ?
     C                   ExSr      Scrn01                                       ?

    ?C                   EndSr                                                  ?
**  +....|....+<<<<< RES 15A Dim(3)
 Fixing Losses
  Trays Dumped
Trays Destroyed
**  +....|....+<<<<< RCD 1A Dim(3)
FIX  Fixing Losses
DMP  Trays Dumped
BAD  Trays Destroyed
