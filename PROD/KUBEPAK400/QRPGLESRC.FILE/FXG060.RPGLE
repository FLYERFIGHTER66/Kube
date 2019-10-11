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
      *? :  Load03   -?Load Screen 03                                ?:
      *? :  Load04   -?Load Screen 04                                ?:
      *? :  Load05   -?Load Screen 05                                ?:
      *? :  Load06   -?Load Screen 06                                ?:
      *? :  Load07   -?Load Screen 07                                ?:
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
WJB   *? :  WJB    -? 5/11/04 - Added Logic to Update FMCUST         ?:
WJB   *? :  WJB    -? 5/14/04 - Added Logic to write correct info    ?:
WJB   *? :          ?           to FALITEM. (Chain to FDLOTRD)       ?:
      *? :............................................................:
     FFXG060FM  CF   E             WORKSTN
     F*                                    SFILE(FXG06002:RRN02)
     F                                     SFILE(FXG06004:RRN04)
     F                                     DEVID(WSID)
     FFLOSSD    UF A E           K DISK                                         ?Loss Details
     FFLOSSLOT  UF A E           K DISK                                         ?Loss Lot Details
     FFTRAY     UF A E           K DISK                                         ?Tray File
     FFMINVT    IF   E           K DISK                                         ?Item Master

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
     D   ShipDate      S              7S 0                                      ?Lot Ship Date
     D   QtyOrdered    S              7S 0                                      ?Quantity Ordered
     D   QtySown       S              7S 0                                      ?Quantity Sown
     D   QtyLost       S              7S 0                                      ?Quantity Lost Fix
     D   TotalLoss     S              7S 0                                      ?Quantity Lost All
     D   Scanned       S              7S 0                                      ?Quantity Scanned
     D   Unfixed       S              7S 0                                      ?Quant Unfixed
     D   Partial       S              7S 0                                      ?Count Partials
     D   PartSum       S              7S 2                                      ?Sum Partials
    ?D StartTag#       S              8S 0
    ?D EndTag#         S              8S 0

      *? Indicators
     D   DUMMY         S               N   Inz(*Off)                            ?Dummy Routine IND
     D   Duplicates    S               N   Inz(*Off)                            ?Duplicate Tag Flag
     D   BadTag#       S               N   Inz(*Off)                            ?Tray not found
     D   Clear04       S               N   Inz(*Off)                            ?Clear S4 Arrays

      *? Arrays
     D   Res           S             15A   Dim(0004) CTDATA                     ?Reasons
     D   RCD           S              3A   Dim(0004) CTDATA                     ?Reason Codes
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
     C*    Screen        WhenEq    1                                            ?
     C*                  ExSr      Edit01                                       ?
     C     Screen        WhenEq    2                                            ?
     C                   ExSr      Edit02                                       ?
     C     Screen        WhenEq    3                                            ?
     C                   ExSr      Edit03                                       ?
     C     Screen        WhenEq    4                                            ?
     C                   ExSr      Edit04                                       ?
     C     Screen        WhenEq    5                                            ?
     C                   ExSr      Edit05                                       ?
     C     Screen        WhenEq    6                                            ?
     C                   ExSr      Edit06                                       ?
     C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      Scrn02 - Display Screen 02                         :
      *?  :.........................................................:
    ?C     Scrn02        BegSr                                                  ?
     C                   Z-Add     02            Screen            3 0          ?Screen  Number
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FXG06002
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Scrn03 - Display Screen 03                         :
      *?  :.........................................................:
    ?C     Scrn03        BegSr                                                  ?
     C                   Z-Add     03            Screen            3 0          ?Screen  Number
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FXG06003
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Scrn04 - Display Screen 04                         :
      *?  :.........................................................:
    ?C     Scrn04        BegSr                                                  ?
     C                   Z-Add     04            Screen            3 0          ?Screen  Number
    ?C                   Write     MSGCTL                                       ?
     C                   Eval      *In25 = *On                                  ?
    ?C                   ExFmt     FXG06004C                                    ?
     C                   Eval      *In25 = *Off                                 ?
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Scrn05 - Display Screen 05                         :
      *?  :.........................................................:
    ?C     Scrn05        BegSr                                                  ?
     C                   Z-Add     05            Screen            3 0          ?Screen  Number
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FXG06005                                     ?
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Scrn06 - Display Screen 06                         :
      *?  :.........................................................:
    ?C     Scrn06        BegSr                                                  ?
     C                   Z-Add     06            Screen            3 0          ?Screen  Number
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FXG06006                                     ?
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load02 - Load Screen 03                            :
      *?  :.........................................................:
    ?C     Load02        BegSr                                                  ?

     C                   Eval      FixDate = $MDYDate($Date(0))

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load03 - Load Screen 03                            :
      *?  :.........................................................:
    ?C     Load03        BegSr                                                  ?

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load04 - Load Screen 04                            :
      *?  :.........................................................:
    ?C     Load04        BegSr                                                  ?

      *? Clear Tag/Tray Arrays
     C                   If        Clear04
     C                   Eval      Clear04 = *Off
     C                   Reset                   Tags
     C                   Reset                   Tray
     C                   EndIF
     C                   Reset                   TagsS4
     C                   Reset                   TrayS4
     C                   Reset                   TrayDS

      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
    ?C                   Write     FXG06004C                                    ?

      *? Load the Subfile
     C                   Eval      *In27 = *Off                                 ?SFLEND Indicator
     C                   Z-add     *Zero         RRN04                          ?
     C                   Eval      ScanTag = *Zeros                             ?
     C                   DoW       RRN04 < 64                                   ?
     C                   Add       1             RRN04                          ?
    ?C                   Write     FXG06004                                     ?
     C                   EndDo                                                  ?

    ?C     RRN04         Chain     FXG06004                                     ?
     C                   Eval      *In26 = *On                                  ?Subfile has Data
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    FXG06004                                     ?
     C                   Eval      *In27 = *Off                                 ?SFLEND Indicator

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load05 - Load Screen 05                            :
      *?  :.........................................................:
    ?C     Load05        BegSr                                                  ?

     C                   Clear                   FXG06005                       ?
     C                   Eval      *In70 = *Off                                 ?Dft to "No"

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load06 - Load Screen 06                            :
      *?  :.........................................................:
    ?C     Load06        BegSr                                                  ?

     C                   SortA     Tags
     C                   Eval      x = 0
     C                   DoW       Tags(x+1) < Nines8
     C                   Eval      x = x + 1
     C                   EndDo
     C                   Eval      SCount = x
     C                   Eval      *In70 = *On                                  ?Dft to "Yes"

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit02 - EDIT Screen 02                            :
      *?  :.........................................................:
    ?C     Edit02        BegSr                                                  ?

     C                   SELECT                                                 ?
      *? Check Functions
     C                   When      *In03 = *ON                                  ?
     C                   MOVE      *ON           *INLR                          ?

     C                   When      FixDate = 0
     C                   Eval      $#MSGD = 'Fixed on'
     C                   Eval      $#MSID = 'DATE902'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Scrn02                                       ?

     C                   When      not $IsDate#(FixDate:'*MDY')
     C                   Eval      $#MSGD = %char(FixDate)                      ?
     C                   Eval      $#MSID = 'DATE901'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Scrn02                                       ?

      *? If no Actions then ReDisplay
     C                   Other                                                  ?

     C                   ExSr      Scrn03                                       ?
     C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit03 - EDIT Screen 03                            :
      *?  :.........................................................:
    ?C     Edit03        BegSr                                                  ?

     C                   SELECT                                                 ?
      *? Check Functions
     C                   When      *In03 = *ON                                  ?
     C                   MOVE      *ON           *INLR                          ?

     C                   When         SREASON = 1
     C                             or SREASON = 2
     C                             or SREASON = 3
     C                             or SREASON = 4
     C                   Eval      REASON = Res(SREASON)                        ?
     C                   Eval      Clear04 = *On                                ?
     C                   ExSr      Load04                                       ?
     C                   ExSr      Scrn04                                       ?

      *? If no Actions then ReDisplay
     C                   Other                                                  ?

     C                   ExSr      Scrn03                                       ?
     C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit04 - EDIT Screen 04                            :
      *?  :.........................................................:
    ?C     Edit04        BegSr                                                  ?

      *? Check that non of the Subfile entries are Dups on Screen
      *?   and that the Tag has an entry on the Tray File
     C                   Reset                   TagsS4
     C                   Reset                   TrayS4

     C                   Eval      Duplicates = *Off                            ?Duplicate Flag
     C                   Eval      BadTag#    = *Off                            ?Tray Not Found
    ?C                   ReadC     FXG06004                                     ?
     C                   DoW       not %EOF(FXG060FM)                           ?
     C                   Eval      *In51 = *Off                                 ?SFL error Ind
     C                   Eval      *In28 = *Off                                 ?SFLNXTCHG
     C                   If        ScanTag <> *Zero
     C                   Eval      *In28 = *On                                  ?SFLNXTCHG
     C     ScanTag       LookUp    TagsS4                                 40    ?
     C                   If        %Found
     C                   Eval      *In51 = *On                                  ?SFL error Ind
     C                   Eval      Duplicates = *On                             ?Duplicate Flag
     C                   Eval      $#MSGD = %char(ScanTag)                      ?
     C                   Eval      $#MSID = 'RBR0009'                           ?
     C                   ExSr      SndError                                     ?
     C                   EndIf                                                  ?
     C     ScanTag       LookUp    Tags                                   40        ?
     C                   If        %Found
     C                   Eval      *In51 = *On                                  ?SFL error Ind
     C                   Eval      Duplicates = *On                             ?Duplicate Flag
     C                   Eval      $#MSGD = %char(ScanTag)                      ?
     C                   Eval      $#MSID = 'RBR0010'                           ?
     C                   ExSr      SndError                                     ?
     C                   EndIf                                                  ?
    ?C     ScanTag       Chain     FTRAY
     C                   If        not %Found(FTRAY)
     C                   Eval      *In51 = *On                                  ?SFL error Ind
     C                   Eval      BadTag#    = *On                             ?Tray not found
     C                   Eval      $#MSGD = %char(ScanTag)                      ?
     C                   Eval      $#MSID = 'RBR0008'                           ?
     C                   ExSr      SndError                                     ?
     C                   EndIf                                                  ?
     C                   EndIf                                                  ?
    ?C                   Update    FXG06004                                     ?
     C                   If        ScanTag <> *Zero
     C                   Eval      TagsS4(RRN04) = ScanTag
     C                   Eval      TrayS4(RRN04) = TrayDS
     C                   EndIf                                                  ?
    ?C                   ReadC     FXG06004                                     ?
     C                   EndDo                                                  ?

      *? Load Subfile records into Array if no Dups and no bad tags
     C                   If            not Duplicates
     C                             and not BadTag#
     C                   SortA     TagsS4
     C                   SortA     TrayS4
     C                   Eval      x = 1
     C                   DoW       Tags(x) < Nines8
     C                   Eval      x = x + 1
     C                   EndDo
     C                   MoveA     TagsS4        Tags(x)
     C                   MoveA     TrayS4        Tray(x)
     C                   SortA     Tags
     C                   SortA     Tray
     C                   EndIf                                                  ?

     C                   Select                                                 ?
      *? Check Functions
     C                   When      *In06 = *ON                                  ?
     C                   Eval      $#MSID = 'RBR0005'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Load03                                       ?
     C                   ExSr      Scrn03                                       ?

     C                   When      *In05 = *ON                                  ?
     C                   ExSr      Load04                                       ?
     C                   ExSr      Scrn04                                       ?

     C                   When      Duplicates or BadTag#
     C                   ExSr      Scrn04                                       ?

     C                   When      BadTag#
     C                   ExSr      Scrn04                                       ?

     C                   Other                                                  ?
     C                   ExSr      Load05                                       ?
     C                   ExSr      Scrn05                                       ?
     C                   EndSl                                                  ?

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit05 - EDIT Screen 05                            :
      *?  :.........................................................:
    ?C     Edit05        BegSr                                                  ?

     C                   SELECT                                                 ?
      *? Check Functions
     C                   When      *In06 = *ON                                  ?
     C                   Eval      $#MSID = 'RBR0005'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Load03                                       ?
     C                   ExSr      Scrn03                                       ?

     C                   When          SMORES <> 1
     C                             and SMORES <> 2
     C                             and SMORES <> 3
     C                   Eval      $#MSID = 'RBR0002'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Scrn05                                       ?

     C                   When         SMORES = 1                                ?1=Yes
     C                             or SMORES = 3                                ?3=Yes
     C                   ExSr      Load04                                       ?
     C                   ExSr      Scrn04                                       ?

     C                   When      SMORES = 2                                   ?2=No
     C                   ExSr      Load06                                       ?
     C                   ExSr      Scrn06                                       ?

     C                   Other                                                  ?
     C                   ExSr      Scrn05                                       ?
     C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit06 - EDIT Screen 06                            :
      *?  :.........................................................:
    ?C     Edit06        BegSr                                                  ?

     C                   SELECT                                                 ?
      *? Check Functions
     C                   When      *In06 = *ON                                  ?
     C                   Eval      $#MSID = 'RBR0005'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Load03                                       ?
     C                   ExSr      Scrn03                                       ?

     C                   When          Complete <> 1                            ?1=Yes
     C                             and Complete <> 2                            ?2=No
     C                             and Complete <> 3                            ?3=Yes
     C                   Eval      $#MSID = 'RBR0002'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Scrn06                                       ?

     C                   When         Complete = 1
     C                             or Complete = 3
     C                   Time                    Now                            ?Time Now
     C                   ExSr      Wrt_FLOSSD                                   ?
     C                   ExSr      Load03                                       ?
     C                   ExSr      Scrn03                                       ?

     C                   When      Complete = 2
     C                   ExSr      Load04                                       ?
     C                   ExSr      Scrn04                                       ?

     C                   Other                                                  ?
     C                   ExSr      Scrn06                                       ?
     C                   ENDSL                                                  ?

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
      *?  :      Wrt_FLOSSD - Write the Loss Detail Record          :
      *?  :.........................................................:
    ?C     Wrt_FLOSSD    BegSr                                                  ?

     C                   Eval      x = 1
     C                   Eval      CountItem   = *Zero
     C                   Dow       Tags(x) <  99999999
     C                             and  x  <= %Elem(Tags)

     C                   Eval      LDCONT = 0
    ?C     Tags(x)       Chain     FTRAY
      *? Only update Loss files if it's an active tag. ?
     C                   If        %Found(FTRAY)
    ?C     Tags(x)       Chain     FLOSSD
    ?C     LotKey        Chain     FLOSSLOT
    ?C     LotKey        KList
    ?C                   KFld                    TRITEM
    ?C                   KFld                    TRSIZE
    ?C                   KFld                    TRCRDT
WJB ?C* 1/17/08          KFld                    LDCODE
    ?C     ItemKey       Chain     FMINVT
    ?C     ItemKey       KList
    ?C                   KFld                    TRITEM
    ?C                   KFld                    TRSIZE
     C                   If        not %Found(FLOSSD)                           ?FLOSSD = write only
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
    ?C                   Write     RLOSSD
     C                   Eval      TRSTAT = %SUBST(RCD(SREASON):1:1)
     C                   If        RCD(SREASON) = 'DMP'
     C                   Eval      TRSTAT = 'M'
     C                   EndIf
     C                   Eval      TRREAS = RCD(SREASON)
     C                   Eval      TRDTLA = $MDYDate($Date(0))
     C                   Eval      TRTIME = $Now()
     C                   Eval      TRUSER = $User()
    ?C                   Update    RTRAY
     C                   Eval      LDLOSD = $Date7($DateMDY(FixDate))
     C                   Eval      LDDES1 = IMDES1
     C                   Eval      LDLOOK = IMLOOK
     C                   Eval      LDCONT = LDCONT + 1
    ?C                   Call      'FXG061'                                     ?
    ?C                   Parm                    LDITEM
    ?C                   Parm                    LDSIZE
    ?C                   Parm      LDREDY        ShipDate
    ?C                   Parm      'F'           Reason
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

     C                   Eval      StartTag# = Tags(x)
     C                   Eval      EndTag#   = Tags(x)
WHT  C                   Call      'RMVLOTINV'                                  |Remove from Lot Inv
     C                   Parm                    StartTag#
     C                   Parm                    EndTag#

     C                   EndIf
     C                   EndIf

     C                   Eval      x = x + 1
     C                   EndDo
    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

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

     C                   ExSr      Load02                                       ?
     C                   ExSr      Scrn02                                       ?

    ?C                   EndSr                                                  ?
**  +....|....+<<<<< RES 15A Dim(4)
 Fixing Losses
Partial Fixers
  Trays Dumped
Trays Destroyed
**  +....|....+<<<<< RCD 1A Dim(4)
FIX  Fixing Losses
PRT  Partial Fixer
DMP  Trays Dumped
BAD  Trays Destroyed
