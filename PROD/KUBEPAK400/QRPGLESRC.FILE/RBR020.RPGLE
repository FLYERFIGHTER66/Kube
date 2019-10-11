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
      *? :  Scrn06   -?Display Screen 06                             ?:
      *? :  Scrn07   -?Display Screen 07                             ?:
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
     FRBR020FM  CF   E             WORKSTN
     F                                     SFILE(RBR02002:RRN02)
     F                                     SFILE(RBR02004:RRN04)
     F                                     DEVID(WSID)
WJB  FFMCUST    UF   E           K DISK                                         ?Customer Master
     FFMCUSTCN  IF   E           K DISK    RENAME(RMCUST:BILLTO)  PREFIX(BT_)   ?Customer Master
     FFMCUSTAL  IF   E           K DISK    RENAME(RMCUST:ALPHA)                 ?Customer Master
     FFTRAY     IF   E           K DISK                                         ?Tray Info
     FFOECTL    IF   E           K DISK                                         ?Control File
     FFMTERM    IF   E           K DISK                                         ?Terms File
     FFHORDR    UF A E           K DISK                                         ?Order Header
     FFOPNORD   UF A E           K DISK                                         ?Order Value
     FFMINVT    IF   E           K DISK                                         ?Item Master
     FFMTAXF    IF   E           K DISK                                         ?Tax File
     FFIORDR    UF A E           K DISK                                         ?Order Detail
     FFIORDRPARTO  A E           K DISK                                         ?Partials Detail
     FFALITEML5 UF A E           K DISK                                         ?Item Allocated
WJB  FFDLOTRD_ARUF   E           K DISK    Rename(RDLOTRD:RDLOTRD_AR)           ?Lot Inventory AR
WJB  FFDLOTRD_NRUF   E           K DISK    Rename(RDLOTRD:RDLOTRD_NR)           ?Lot Inventory NR
WJB  FFDLOTRD_X UF A E           K DISK    Rename(RDLOTRD:RDLOTRD_X )           ?Lot Inventory X
     FFPPO      UF A E           K DISK                                         ?Order User Info

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$GetOrder#
    ?D/COPY QFunctDefn,$UnitPrice
    ?D/COPY QFunctDefn,$PrintPick
    ?D/COPY QFunctDefn,$Allocate
    ?D/COPY QFunctDefn,$DftPrt
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$_LOT
    ?D/COPY QFunctDefn,$_IC

      *? Field Definitions
     D   RRN02         S              4  0 Inz(0)                               ?SFLRRN Screen 02
     D   RRN04         S              4  0 Inz(0)                               ?SFLRRN Screen 04
     D   ErrCount      S              2  0 Inz(0)                               ?Error Count
     D   Nines8        S              8S 0 Inz(99999999)                        ?8S 0 all 9's
     D   Nines15       S             15A   Inz('999999999999999')               ?15A  all 9's
     D   Nines30       S             30A                                        ?30A  all 9's
     D                                     Inz('999999999999999999999999999999')
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
     D   CurrentLot    S             30A                                        ?Lot being processed
     D   OrderSeq#     S              3S 0                                      ?Order Detail Seq. #
     D   Printer       S             10                                         ?Printer to Use
     D   Cust997       S                   Like(LRCUST) Inz(999997)             ?Partials Customer #
     D   Loop          S              7S 0
     D   LotPartPct    S              4S 2
     D   PartText      S                   Like(OIDES1)
     D   $SowD         S              7P 0
     D   $Ready        S              7P 0
     D   SaleableTot   S              3S 0
     D   SaleableQty   S              3S 0
     D   Discount      S              4S 1

      *? Indicators
     D   DUMMY         S               N   Inz(*Off)                            ?Dummy Routine IND
     D   Duplicates    S               N   Inz(*Off)                            ?Duplicate Tag Flag
     D   BadTag#       S               N   Inz(*Off)                            ?Tray not found
     D   Clear04       S               N   Inz(*Off)                            ?Clear S4 Arrays

      *? Arrays
     D   TagsS4        S              8S 0 Dim(0064) Inz(99999999)              ?Scanned Tags Scrn04
     D   TrayS4        S             15A   Dim(0064) Inz('999999999999999')     ?Tag Tray Info S04
     D   TrayS4Lot     S             30A   Dim(0064)                            ?Tag Tray Info S04
     D                                     Inz('999999999999999999999999999999')
     D   Tags          S              8S 0 Dim(3000) Inz(99999999)              ?Verified Tags
     D   Tray          S             15A   Dim(3000) Inz('999999999999999')     ?Tag Tray Info
     D   TrayLot       S             30A   Dim(3000)                            ?Tag Tray Info
     D                                     Inz('999999999999999999999999999999')
      *? Data Structures
     D                SDS
     D  ##PGM            *PROC
     D  User                 254    263

     D*TrayDS          DS
     D* TRITEM                             INZ('999999999999')                  ?Tray Item Number
     D* TRSIZE                             INZ('999')                           ?Tray Size

     D TrayDSLot       DS
     D  TRITEM                             INZ('999999999999')                  ?Tray Item Number
     D  TRSIZE                             INZ('999')                           ?Tray Size
     D  TRSCYM                             INZ( 9999999 )                       ?Tray Sow Date
     D  TRCRDT                             INZ( 9999999 )                       ?Tray Ready Date
     D  TRSTAT                             INZ('9')                             ?Tray Status

     C     *INLR         DOUEQ     *ON                                          ?COMMENT

     C                   SELECT                                                 ?
     C     Screen        WhenEq    1                                            ?
     C                   ExSr      Edit01                                       ?
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
     C     Screen        WhenEq    7                                            ?
     C                   ExSr      Edit07                                       ?
     C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     RBR02001                                     ?
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Scrn02 - Display Screen 02                         :
      *?  :.........................................................:
    ?C     Scrn02        BegSr                                                  ?
     C                   Z-Add     02            Screen            3 0          ?Screen  Number
     C                   Eval      *In25 = *On                                  ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     RBR02002C                                    ?
     C                   ExSr      ClrError                                     ?
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Scrn03 - Display Screen 03                         :
      *?  :.........................................................:
    ?C     Scrn03        BegSr                                                  ?
     C                   Z-Add     03            Screen            3 0          ?Screen  Number
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     RBR02003
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Scrn04 - Display Screen 04                         :
      *?  :.........................................................:
    ?C     Scrn04        BegSr                                                  ?
     C                   Z-Add     04            Screen            3 0          ?Screen  Number
    ?C                   Write     MSGCTL                                       ?
     C                   Eval      *In25 = *On                                  ?
    ?C                   ExFmt     RBR02004C                                    ?
     C                   Eval      *In25 = *Off                                 ?
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Scrn05 - Display Screen 05                         :
      *?  :.........................................................:
    ?C     Scrn05        BegSr                                                  ?
     C                   Z-Add     05            Screen            3 0          ?Screen  Number
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     RBR02005                                     ?
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Scrn06 - Display Screen 06                         :
      *?  :.........................................................:
    ?C     Scrn06        BegSr                                                  ?
     C                   Z-Add     06            Screen            3 0          ?Screen  Number
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     RBR02006                                     ?
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Scrn07 - Display Screen 07      NOT USED           :
      *?  :.........................................................:
    ?C     Scrn07        BegSr                                                  ?
     C                   Z-Add     07            Screen            3 0          ?Screen  Number
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     RBR02007                                     ?
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?
     C                   Clear                   RBR02001                       ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load02 - Load Screen 02                            :
      *?  :.........................................................:
    ?C     Load02        BegSr                                                  ?

      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
    ?C                   Write     RBR02002C                                    ?

      *? Load the Subfile
     C     SMLOOK        SetLL     FMCUSTAL                                     ?
    ?C                   Read      FMCUSTAL                                     ?

     C                   Z-add     *Zero         RRN02                          ?
     C                   DoW       %Subst(CMLOOK:1:%Len(%Trim(SMLOOK)))=SMLOOK  ?
     C                             and not %EOF(FMCUSTAL)                       ?
     C                   Add       1             RRN02                          ?
    ?C                   Write     RBR02002                                     ?
     C                   Eval      *In26 = *On                                  ?
    ?C                   Read      FMCUSTAL                                     ?
     C                   EndDo                                                  ?

     C                   IF        *In26 = *On                                  ?
    ?C     RRN02         Chain     RBR02002                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    RBR02002                                     ?
     C                   EndIF                                                  ?

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load03 - Load Screen 03                            :
      *?  :.........................................................:
    ?C     Load03        BegSr                                                  ?
    ?C     SMCUST        Chain(N)  FMCUST                                       ?
     C                   Eval      SBNAME = CMNAME                              ?
     C                   Eval      SBADD1 = CMADD2                              ?
     C                   Eval      SBADD2 = CMADD3                              ?
     C                   Eval      SBCITY = CMCITY                              ?
     C                   Eval      SBSTAT = CMSTST                              ?
     C                   Eval      *In70 = *On                                  ?Dft to "Yes"
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
     C                   Reset                   TrayS4Lot
     C*                  Reset                   TrayDS
     C                   Reset                   TrayDSLot

      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
    ?C                   Write     RBR02004C                                    ?

      *? Load the Subfile
     C                   Eval      *In27 = *Off                                 ?SFLEND Indicator
     C                   Z-add     *Zero         RRN04                          ?
     C                   Eval      ScanTag = *Zeros                             ?
     C                   DoW       RRN04 < 64                                   ?
     C                   Add       1             RRN04                          ?
    ?C                   Write     RBR02004                                     ?
     C                   EndDo                                                  ?

    ?C     RRN04         Chain     RBR02004                                     ?
     C                   Eval      *In26 = *On                                  ?Subfile has Data
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    RBR02004                                     ?
     C                   Eval      *In27 = *Off                                 ?SFLEND Indicator

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load05 - Load Screen 05                            :
      *?  :.........................................................:
    ?C     Load05        BegSr                                                  ?

     C                   Clear                   RBR02005                       ?
     C                   Eval      *In70 = *Off                                 ?Dft to "No"

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load06 - Load Screen 06                            :
      *?  :.........................................................:
    ?C     Load06        BegSr                                                  ?

     C                   Clear                   RBR02006                       ?

     C                   SortA     Tags
     C                   Eval      x = 0
     C                   DoW       Tags(x+1) < Nines8
     C                   Eval      x = x + 1
     C                   EndDo
     C                   Eval      SCount = x
     C                   Eval      *In70 = *On                                  ?Dft to "Yes"

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load07 - Load Screen 07         NOT USED           :
      *?  :.........................................................:
    ?C     Load07        BegSr                                                  ?
     C                   Clear                   RBR02007                       ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

     C     SMCUST        IfNe      *Zeros                                       ?
     C     SMCUST        SetLL     FMCUST                                       ?
     C                   EndIF                                                  ?

     C     SMLOOK        IfNe      *Zeros                                       ?
     C     SMLOOK        SetLL     FMCUSTAL                                     ?
    ?C                   Read      FMCUSTAL                                     ?
     C                   EndIF                                                  ?

      *? P R O C E S S   S C R E E N
     C                   SELECT                                                 ?
     C                   When      *In03 = *ON                                  ?
     C                   MOVE      *ON           *INLR                          ?

     C                   When      *In06 = *ON                                  ?
     C                   Eval      $#MSID = 'RBR0005'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

      *? Cust # and Alpha Search cannot both be Blank
     C                   When           SMCUST  =  *Zeros                       ?
     C                             and  SMLOOK  =  *Blanks                      ?
     C                   Eval      $#MSID = 'RBR0001'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Scrn01                                       ?

      *? Cust # if Entered must be Valid
     C                   When      not %Equal(FMCUST)                           ?
     C                             and SMCUST <> *Zeros                         ?
     C                   Eval      $#MSID = 'RBR0003'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Scrn01                                       ?

      *? Alpha if Entered must have at least one match
     C                   When      %Subst(CMLOOK:1:%Len(%Trim(SMLOOK)))<>SMLOOK ?
     C                             and SMLOOK <> *Blanks                        ?
     C                   Eval      $#MSID = 'RBR0004'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Scrn01                                       ?

     C                   When           SMCUST =  *Zero                         ?
     C                             and  SMLOOK <> *Zero                         ?
     C                   ExSr      Load02                                       ?
     C                   ExSr      Scrn02                                       ?

     C                   When      SMCUST <> *Zero                              ?
     C                   ExSr      Load03                                       ?
     C                   ExSr      Scrn03                                       ?

     C                   OTHER                                                  ?
     C                   ExSr      Load03                                       ?
     C                   ExSr      Scrn03                                       ?
     C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit02 - EDIT Screen 02                            :
      *?  :.........................................................:
    ?C     Edit02        BegSr                                                  ?

     C                   SELECT                                                 ?
      *? Check Functions
     C     *IN03         WhenEq    *ON                                          ?
     C                   MOVE      *ON           *INLR                          ?
     C                   LeaveSR                                                ?
     C     *IN06         WhenEq    *ON                                          ?
     C                   Eval      $#MSID = 'RBR0005'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? When a Subfile record is returned
     C                   When      SFLCSRRRN <> *Zero                           ?
    ?C     SFLCSRRRN     Chain     RBR02002                                     ?
     C                   Eval      SMCUST = CMCUST                              ?
     C                   ExSr      Load03                                       ?
     C                   ExSr      Scrn03                                       ?
      *? If no Functions then ReDisplay
     C                   OTHER                                                  ?
     C                   ExSr      Scrn02                                       ?
     C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit03 - EDIT Screen 03                            :
      *?  :.........................................................:
    ?C     Edit03        BegSr                                                  ?

     C                   SELECT                                                 ?
      *? Check Functions
     C                   When      *In06 = *ON                                  ?
     C                   Eval      $#MSID = 'RBR0005'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

     C                   When          SCUSOK <> 1
     C                             and SCUSOK <> 2
     C                             and SCUSOK <> 3
     C                   Eval      $#MSID = 'RBR0002'                           ?
     C                   EXSR      SndError                                     ?
     C                   EXSR      Scrn03                                       ?

     C                   When         SCUSOK = 2
     C                   ExSr      Scrn01                                       ?

     C                   When         SCUSOK = 1 or SCUSOK = 3
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
     C                   Reset                   TrayS4Lot

     C                   Eval      Duplicates = *Off                            ?Duplicate Flag
     C                   Eval      BadTag#    = *Off                            ?Tray Not Found
    ?C                   ReadC     RBR02004                                     ?
     C                   DoW       not %EOF(RBR020FM)                           ?
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
    ?C                   Update    RBR02004                                     ?
     C                   If        ScanTag <> *Zero
     C                   Eval      TagsS4(RRN04) = ScanTag
     C*                  Eval      TrayS4(RRN04) = TrayDS
     C                   Eval      TrayS4Lot(RRN04) = TrayDSLot
     C                   EndIf                                                  ?
    ?C                   ReadC     RBR02004                                     ?
     C                   EndDo                                                  ?

      *? Load Subfile records into Array if no Dups and no bad tags
     C                   If            not Duplicates
     C                             and not BadTag#
     C                   SortA     TagsS4
     C                   SortA     TrayS4
     C                   SortA     TrayS4Lot
     C                   Eval      x = 1
     C                   DoW       Tags(x) < Nines8
     C                   Eval      x = x + 1
     C                   EndDo
     C                   MoveA     TagsS4        Tags(x)
     C*                  MoveA     TrayS4        Tray(x)
     C                   MoveA     TrayS4Lot     TrayLot(x)
     C                   SortA     Tags
     C                   SortA     Tray
     C                   EndIf                                                  ?

     C                   Select                                                 ?
      *? Check Functions
     C                   When      *In06 = *ON                                  ?
     C                   Eval      $#MSID = 'RBR0005'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

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
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

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
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

     C                   When          Complete <> 1                            ?1=Yes
     C                             and Complete <> 2                            ?2=No
     C                             and Complete <> 3                            ?3=Yes
     C                   Eval      $#MSID = 'RBR0002'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Scrn06                                       ?

     C                   When         Complete = 1
     C                             or Complete = 3
     C                   Reset                   TotalTax01                     ?ST Total Tax
     C                   Reset                   TotalTax02                     ?CO Total Tax
     C                   Reset                   TotalTax03                     ?MU Total Tax
     C                   Reset                   TotalOrder                     ?Total Order Value
     C                   Time                    Now                            ?Time Now
     C                   ExSr      Wrt_HORDR                                    ?
     C                   Eval      $#MSID = 'RBR0007'                           ?
     C                   Eval      $#MSGD = %Char(OHORD#)                       ?
     C                   ExSr      SndError                                     ?
     C                   If        Printer = *Blanks
     C                   Eval      Printer = 'P6'
     C                   EndIf
     C                   CallP     $PrintPick(OHORD#:Printer:'001':'*NO')
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

     C                   When      Complete = 2
     C                   ExSr      Load04                                       ?
     C                   ExSr      Scrn04                                       ?

     C                   Other                                                  ?
     C                   ExSr      Scrn06                                       ?
     C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit07 - EDIT Screen 07  NOT USED                  :
      *?  :.........................................................:
    ?C     Edit07        BegSr                                                  ?

     C                   SELECT                                                 ?
      *? Check Functions
     C                   When      *In06 = *ON                                  ?
     C                   Eval      $#MSID = 'RBR0005'                           ?
     C                   ExSr      SndError                                     ?
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
     C                   Other                                                  ?
     C                   ExSr      Scrn07                                       ?
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
      *?  :      Wrt_HORDR - Write the Order Header                 :
      *?  :.........................................................:
    ?C     Wrt_HORDR     BegSr                                                  ?

     C                   Clear                   RHORDR
     C                   Clear                   BillTo
    ?C     CMBLCU        Chain     FMCUSTCN                                     ?Get billto info
     C                   Clear                   RMTERM
    ?C     BT_CMTMCD     Chain     FMTERM                                       ?Get Terms
     C                   Clear                   ROECTL
    ?C     BT_CMCOMP     Chain     FOECTL                                       ?Control File

     C                   Eval      OHSTAT='A'                                   ?STATUS
     C                   Eval      OHORD#=$GetOrder#(00)                        ?ORDER NUMBER
     C                   Eval      OHCOMP=01                                    ?COMPANY #
     C                   Eval      OHCUST=SMCUST                                ?CUSTOMER #
     C                   Eval      OHNAME=CMNAME                                ?SHIP TO NAME
     C                   Eval      OHSHP2=CMADD2                                ?ADDRESS LINE #1
     C                   Eval      OHSHP3=CMADD3                                ?ADDRESS LINE #2
     C                   Eval      OHSHP4=CMADD4                                ?ADDRESS LINE #3
     C                   Eval      OHSHCT=CMCITY                                ?CITY
     C                   Eval      OHSHST=CMSTST                                ?STATE
     C                   Eval      OHSHZP=CMZIP                                 ?ZIP CODE
     C                   Eval      OHPONO=*Blank                                ?P.O. NUMBER
     C                   Eval      OHDTOR=ThisMonday                            ?ORDER DATE
     C                   Eval      OHDTRQ=ThisMonday                            ?REQ SHIP DATE
     C                   Eval      OHDTRY=ThisMonCYMD                           ?REQ. DATE CYMD
     C                   Eval      OHDTCN=TodayMDY                              ?CANCEL DATE
     C                   Eval      OHSHIN='   Rcv''d in good'                   ?SHIPPING INSTRUCTIO
     C                   Eval      OHSPIN='Condition By:__________________'     ?SPECIAL INSTRUCTION
     C                   Eval      OHTERM=TCDESC                                ?TERMS
     C                   Eval      OHTRAT=*Zero                                 ?CASH DISC PERCENT
     C                   Eval      OHTDAY=*Zero                                 ?CASH DISCOUNT DAYS
     C                   Eval      OHTXST=CMTXST                                ?TAX EXEMPT
     C                   Eval      OHTXJU=CMTXJU                                ?JURISDICTION
     C* calc'd below     Eval      OHAMT1=TotalTax01                            ?TAX AMT 1
     C* calc'd below     Eval      OHAMT2=TotalTax02                            ?TAX AMT 2
     C* calc'd below     Eval      OHAMT3=TotalTax03                            ?TAX AMT 3
     C                   Eval      OHTYPE=CMCTYP                                ?CUSTOMER TYPE
     C                   Eval      OHSHPC='02'                                  ?SHIP VIA CODE
     C                   Eval      OHSTA ='N'                                   ?SUB TO AVAIL
     C                   Eval      OHACK ='N'                                   ?ORD. ACK. PRINTED
     C                   Eval      OHSLD1=BT_CMNAME                             ?BILL TO
     C                   Eval      OHSLD2=BT_CMADD2                             ?ADDRESS LINE #1
     C                   Eval      OHSLD3=BT_CMADD3                             ?ADDRESS LINE #2
     C                   Eval      OHSLD4=BT_CMADD4                             ?ADDRESS LINE #3
     C                   Eval      OHSLCT=BT_CMCITY                             ?CITY
     C                   Eval      OHSLST=BT_CMSTST                             ?STATE
     C                   Eval      OHSLZP=BT_CMZIP                              ?ZIP CODE
     C                   Eval      OHSLM1='01'                                  ?SALESPERSON 1
     C                   Eval      OHSCM1=*Zero                                 ?COMM % 1
     C                   Eval      OHSLM2=*Blanks                               ?SALESPERSON 2
     C                   Eval      OHSCM2=*Zero                                 ?COMM % 2
     C                   Eval      OHFRT$=*Zero                                 ?FREIGHT AMT
     C                   Eval      OHMER$=*Zero                                 ?MERCHANDISE AMT
     C                   Eval      OHDIS$=*Zero                                 ?DISCOUNT AMT
     C                   Eval      OHMIS$=*Zero                                 ?MISC. CHARGE AMT
     C                   Eval      OHTAX$=*Zero                                 ?TAX AMOUNT
     C                   Eval      OHFET$=*Zero                                 ?FET AMOUNT
     C                   Eval      OHIOCD='N'                                   ?INVOICE ONLY
     C                   Eval      OHBOCD=CMBOOK                                ?CUST B/O ALLOWED
     C                   Eval      OHCOFL='N'                                   ?CLOSED ORDER FLAG
     C                   Eval      OHHOLD='N'                                   ?HOLD ORDER FLAG
     C                   Eval      OHTDAT=TodayMDY                              ?DATE OF TRANS
     C                   Eval      OHPLPT=*Blank                                ?PICK LIST PRINTED P
     C                   Eval      OHIVCD='N'                                   ?INVOICED CODE
     C                   Eval      OHDTLA=TodayMDY                              ?LAST ACTIVITY DATE
     C                   Eval      OHTIME=Now                                   ?TIME
     C                   Eval      OHUSER=User                                  ?USER
     C                   Eval      OHORDY=ThisMonCYMD                           ?ORDER DATE CYMD
     C                   Eval      OHPPCD='P'                                   ?PREPAID/COLLECT
     C                   Eval      OHPRCD=CMPRCD                                ?PRICE CODE
     C                   Eval      OHTRDC=CMTRDC                                ?TRADE DISC. %
     C                   Eval      OHTMCD=CMTMCD                                ?TERMS CODE
     C                   Eval      OHTDAS=TCTDAS                                ?TERMS DAYS
     C                   Eval      OHINV#=*Zero                                 ?INVOICE NUMBER
     C                   Eval      OHINDT=*Zero                                 ?INVOICE DATE CYMD
     C                   Eval      OHUPSZ=CMUPSZ                                ?FREIGHT ZONE
     C                   Eval      OHFRTX='N'                                   ?TAX FREIGHT
     C                   Eval      OHSPTX='N'                                   ?TAX SPECIAL CHRGS
     C                   Eval      OHTXID=CMTXID                                ?TAX ID #
     C                   Eval      OHROUT=*Blank                                ?ROUTE #
     C                   Eval      OHSTOP=*Zero                                 ?STOP
     C                   Eval      OHARCU=CMARCU                                ?AR CUST #
     C                   Eval      OHSACU=CMSACU                                ?SA CUST #
     C                   Eval      OHBLCU=CMBLCU                                ?BILLING CUST #
     C                   Eval      OHTBLK=*Zero                                 ?TOTAL BULK PIECES
     C                   Eval      OHTBRK=*Zero                                 ?TOTAL BROKEN PIECES
     C                   Eval      OHDTAC=*Zero                                 ?SHIP DATE
     C                   Eval      OHALPH=CMLOOK                                ?CUSTOMER ALPHA
FIX  C                   Eval      OHSHFR=CMTERR                                ?SHIP FROM
FIX  C                   Eval      OHSHFR=*Blanks                               ?SHIP FROM
     C                   Eval      OHPLST='000001'                              ?FREIGHT CODE
FIX  C                   Eval      OHIMED='N'                                   ?IMMED PRINT
FIX  C                   Eval      OHIMED=*Blanks                               ?IMMED PRINT
     C                   Eval      OHCASH=*Zero                                 ?CASH APPLICATION
     C                   Eval      OHORDT=ThisMonday                            ?ORIGINAL REQ DATE
     C                   Eval      OHOLST=CMORLS                                ?ORDER PRICE LIST
FIX  C                   Eval      OHLOC ='R'                                   ?ORDER LOCATION
FIX  C                   Eval      OHLOC =*Blanks                               ?ORDER LOCATION
     C                   Eval      OHOORD=*Zeros                                ?ORIGINAL ORDER #
     C                   Eval      OHDISC=*Zero                                 ?C&C OR SALE DISC. %
     C                   Eval      OHPHYT=CMPHYT                                ?PHYTO CODE
     C                   Eval      OHOPLP=*Blank                                ?ORDER PROOF PRINTED
     C                   Eval      OHPOS =*Blank                                ?INVOICE TYPE
     C                   Eval      OHSALE=*Blank                                ?SALE TYPE
     C                   Eval      OHQTPR='N'                                   ?QUOTE PRINTED
     C                   Eval      OHQUOT=*Blank                                ?QUOTE Y OR BLANK
     C                   Eval      OHLOTC='Y'                                   ?LOT CONTROL ORDER?
     C                   Eval      OHIMFG='N'                                   ?IMMED INVOICE PRINT

     C     OHORD#        Chain     FHORDR
     C                   If        %found(FHORDR)
     C                   Eval      *InH1 = *On
     C                   Else
     C                   ExSr      Wrt_IORDR                                    ?
     C                   Eval      OHAMT1=TotalTax01                            ?TAX AMT 1
     C                   Eval      OHAMT2=TotalTax01                            ?TAX AMT 2
     C                   Eval      OHAMT3=TotalTax01                            ?TAX AMT 3
      *?  Update Order User File Information
     C                   Eval      POORD# = OHORD#                              ?ORDER NUMBER
     C                   Eval      POTAKN = User                                ?ORDER TAKEN BY
     C                   Eval      POENTR = User                                ?ORDER ENTERED BY
     C                   Eval      POPICK = User                                ?PICKED BY
     C                   Eval      POPACK = User                                ?PACKED BY
     C                   Write     RPPO

     C                   Write     RHORDR
     C                   ExSr      Wrt_OPNORD                                   ?Write Order Value

WJB ?C     CMCUST        Chain     FMCUST                                       ?Chain for Update
WJB  C                   Eval      CMOCUR = CMOCUR + 1                          ?QTY ORDERS CURRENT
WJB  C                   Eval      CMOYTD = CMOYTD + 1                          ?QTY ORDERS YTD
WJB  C                   Eval      CMDTLO = TodayMDY                            ?DATE LAST ORDER
WJB  C                   Eval      CMVOPO = CMVOPO + TotalOrder                 ?VALUE OF OPEN ORDER
WJB ?C                   Update    RMCUST                                       ?Update Cust Master

     C                   EndIf

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Wrt_IORDR - Write Order Detail Record              :
      *?  :.........................................................:
    ?C     Wrt_IORDR     BegSr                                                  ?

     C                   SortA     Tray
     C                   Eval      x = 1
     C                   Eval      OrderSeq# = 10
     C                   Eval      CountItem   = *Zero
     C*                  Dow       Tray(x) <  Nines15
     C                   Dow       TrayLot(x) <  Nines30
     C*                            and  x  <= %Elem(Tray)
     C                             and  x  <= %Elem(TrayLot)
     C                   Eval      OrderSeq# = OrderSeq# + 2
     C*                  Eval      CurrentItem = Tray(x)
     C                   Eval      CurrentLot  = TrayLot(x)
     C                   Eval      CountItem   = *Zero
     C*                  Dow       CurrentItem = Tray(x)
     C                   Dow       CurrentLot  = TrayLot(x)
     C                   Eval      CountItem = CountItem + 1
     C                   Eval      x = x + 1
     C                   EndDo

     C*                  If        X > 1 and CurrentItem <> *Blanks
     C                   If        X > 1 and CurrentLot  <> *Blanks
     C                   Clear                   RIORDR
     C*                  Eval      TrayDS = Tray(x-1)
     C                   Eval      TrayDSLot = TrayLot(x-1)
     C     ItemKey       KList
     C                   KFld                    TRITEM
     C                   KFld                    TRSIZE
    ?C     ItemKey       Chain     FMINVT                                       ?Item Master

      *?  Tax calculations
     C                   Clear                   RMTAXF
     C                   Eval      OITXCD = 'N'                                 ?TAX ITEM CODE 1
     C                   Eval      OITXST = 'N'                                 ?TAX ITEM CODE 2
     C                   Eval      OITXCT = 'N'                                 ?TAX ITEM CODE 3
     C                   Eval      OITXLC = 'N'                                 ?TAX ITEM CODE 4
     C                   If        CMTXST = 'N'                                 ?Tax Exempt ?
    ?C     CMTXJU        Chain     FMTAXF                                       ?Item Master File
     C                   If        %found(FMTAXF)
     C                   Eval      OIAMT1=TXPCT1                                ?TAX AMT RATE 1
     C                   Eval      OIAMT2=TXPCT2                                ?TAX AMT RATE 2
     C                   Eval      OIAMT3=TXPCT3                                ?TAX AMT RATE 3
     C                   If           OIAMT1<>*Zero
     C                             or OIAMT2<>*Zero
     C                             or OIAMT3<>*Zero
     C                   Eval      OITXCD='Y'                                   ?TAX ITEM CODE 1
     C                   EndIf
     C                   If        OIAMT1<>*Zero
     C                   Eval      OITXST='Y'                                   ?TAX ITEM CODE 2
     C                   EndIf
     C                   If        OIAMT2<>*Zero
     C                   Eval      OITXCT='Y'                                   ?TAX ITEM CODE 3
     C                   EndIf
     C                   If        OIAMT3<>*Zero
     C                   Eval      OITXLC='Y'                                   ?TAX ITEM CODE 4
     C                   EndIf
     C                   EndIf
     C                   EndIf

     C                   Eval      OISTAT='A'                                   ?STATUS
     C                   Eval      OIORD#=OHORD#                                ?ORDER NUMBER
     C                   Eval      OISEQ#=OrderSeq#                             ?SEQ NUMBER
     C                   Eval      OIITEM=IMITEM                                ?ITEM NUMBER
     C                   Eval      OISIZE=IMSIZE                                ?SIZE
     C                   Eval      OIDES1=IMDES1                                ?DESCRIPTION 1
     C                   Eval      OIDES2=IMDES2                                ?COMMENT
     C                   Eval      OICOMP=IMCOMP                                ?COMPANY #
     C                   Eval      OIWHSE=IMWHSE                                ?LOCATION
     C                   Eval      OIBIN#=IMBIN#                                ?BIN #
     C                   Eval      OIUUOM=IMPUOM                                ?UNIT OF MEASURE
     C                   Eval      OIMULT=IMMULT                                ?MULT 1
     C                   Eval      OIUWGT=IMUWGT                                ?UNIT WGT
     C                   Eval      OIUCST=IMUCST                                ?UNIT COST
     C                   Eval      OIUPRI=$UnitPrice(IMITEM:IMSIZE:CMCUST)      ?UNIT PRICE
FIX  C                   Eval      OIOVER=%CHAR(CMPRCD)                         ?OVERRIDE CODE
FIX  C                   Eval      OIOVER='N'                                   ?OVERRIDE CODE
     C                   If        TRSTAT = 'P'
     C                   Eval      $SowD  = TRSCYM
     C                   Eval      $Ready = TRCRDT
     C                   Eval      LotPartPct =
     C                             $LotPartPct(TRITEM:TRSIZE:$SowD:$Ready)
     C                   If        LotPartPct = *Zero
     C                   Eval      LotPartPct = 1
     C                   EndIf
     C                   Eval      OIUPRI = OIUPRI * LotPartPct
     C                   Eval      PartText = 'Adj: (xxx of xxx) Disc: xx.x%'
     C                   Eval      SaleableTot =
     C                              $Saleable(TRSIZE)
     C                   Eval      SaleableQty =
     C                              $Saleable(TRSIZE)*(LotPartPct)
     C                   Eval      Discount    =
     C                              100 - (LotPartPct*100)
     C                   Eval      %Subst(PartText:07:3) =
     C                              %EditW(SaleableQty:'  0')
     C                   Eval      %Subst(PartText:14:3) =
     C                              %EditW(SaleableTot:'  0')
     C                   Eval      %Subst(PartText:24:5) =
     C                              %EditW(Discount:'   .0')
     C                   Eval      OIOVER = 'Y'
     C                   Eval      OIPCTF = LotPartPct
     C                   Write     RIORDRPART
     C                   EndIf
     C                   Eval      OIQDDC=IMDIS1                                ?QTY DISCOUNT
     C                   Eval      OIEXT$=CountItem*OIUPRI                      ?EXT AMOUNT
     C                   Eval      OIQORD=CountItem                             ?QTY ORDERED
     C                   Eval      OIQSHP=*Zero                                 ?QTY SHIPPED
     C                   Eval      OIQBOO=*Zero                                 ?QTY BACKORDERED
     C                   Eval      OISHPC='02'                                  ?SHIP VIA CODE
     C*  see above       Eval      OIAMT1=TXPCT1                                ?TAX AMT RATE 1
     C*  see above       Eval      OIAMT2=TXPCT2                                ?TAX AMT RATE 2
     C*  see above       Eval      OIAMT3=TXPCT3                                ?TAX AMT RATE 3
     C                   Eval      OIDISC=*Zero                                 ?DISCOUNT AMT
FIX  C                   Eval      OISHCD=*Blanks                               ?SHIP RELEASE CODE
FIX  C                   Eval      OISHCD='N'                                   ?SHIP RELEASE CODE
     C                   Eval      OIBOCD=IMBOOK                                ?ITEM B/O ALLOWED
     C                   Eval      OISLM1=OHSLM1                                ?SALESPERSON 1
     C                   Eval      OICOM1=OICOM1                                ?COMMISSION 1
     C                   Eval      OISLM2=OISLM2                                ?SALESPERSON 2
     C                   Eval      OICOM2=OICOM2                                ?COMMISSION 2
     C                   Eval      OICUST=SMCUST                                ?CUSTOMER #
     C                   Eval      OIDTRQ=ThisMonday                            ?REQ SHIP DATE
     C                   Eval      OIDTLA=TodayMDY                              ?LAST ACTIVITY DATE
     C                   Eval      OITIME=Now                                   ?TIME
     C                   Eval      OIUSER=User                                  ?USER
     C                   Eval      OITRDC=BT_CMTRDC                             ?TRADE DISC %
FIX  C                   Eval      OICTCD=CMCTCD                                ?CONTRACT PRICE CODE
FIX  C                   Eval      OICTCD='N'                                   ?CONTRACT PRICE CODE
     C                   Eval      OICOFL='N'                                   ?CLOSED ORDER FLAG
     C                   Eval      OIITYP=*Blanks                               ?ITEM TYPE
     C                   Eval      OIQINV=*Zero                                 ?INVOICE QTY SHIPPED
     C                   Eval      OIPLPT='N'                                   ?PICK LIST PRINTED
     C*  see above       Eval      OITXCD=IMTXBL                                ?TAX ITEM CODE 1
     C*  see above       Eval      OITXST=IMTCD1                                ?TAX ITEM CODE 2
     C*  see above       Eval      OITXCT=IMTCD2                                ?TAX ITEM CODE 3
     C*  see above       Eval      OITXLC=IMTCD3                                ?TAX ITEM CODE 4
     C                   Eval      OIROUT=*Blanks                               ?ROUTE NUMBER
     C                   Eval      OISTOP=*Zero                                 ?STOP
     C                   Eval      OICWT =*Zero                                 ?CATCH WEIGHT
     C                   Eval      OILBS#=*Zero                                 ?POUNDS
     C                   Eval      OIWGSH=*Zero                                 ?WEIGHT SHIPPED
     C                   Eval      OIRSCD=*Blanks                               ?REASON
     C                   Eval      OISEQP=*Zero                                 ?PRIMARY SEQ #
     C                   Eval      OIPRAL=*Blanks                               ?PROMO ALLOW
     C                   Eval      OIBPUM=IMBPUM                                ?BASE PRICE UNIT OF
     C                   Eval      OISUOM=IMBPUM                                ?SHIP UOM
     C                   Eval      OIBLUM=IMBPUM                                ?BILL UOM
     C                   Eval      OIMUL2=*Zero                                 ?MULT 2
     C                   Eval      OILOTC='Y'                                   ?LOT CONTROL
     C                   Eval      OIOPFL=*Blanks                               ?OPEN ORDER POST FLA
     C                   Eval      OIBOLN=*Blanks                               ?LINE ITEM PUT ON BO
     C                   Eval      OIBORQ=ThisMonday                            ?ORIG B/O REQ SHIP D
FIX  C                   Eval      OIPRBO='N'                                   ?PREVIOUS BACKORDER
FIX  C                   Eval      OIPRBO=' '                                   ?PREVIOUS BACKORDER
     C                   Eval      OISTA ='N'                                   ?SUBJ TO AVAIL FLAG
     C                   Eval      OIINV#=*Zero                                 ?INVOICE NUMBER
     C                   Eval      OISHFR=CMSHFR                                ?SHIP FROM
     C                   Eval      OITAGS=*Zero                                 ?# TAGS
     C                   Eval      OIPPDC='N'                                   ?PROMPT PAY DSC Y/N
     C                   Eval      OIPHYT=CMPHYT                                ?PHYTO CODE
     C                   Eval      OISCHM='N'                                   ?SCHED. TO MOVE FLAG
     C                   Eval      OISCHS='N'                                   ?SCHED. TO SOW FLAG
     C                   Eval      OIQTAL=*Zero                                 ?QTY ALLOCATED
     C                   Eval      OIGLNO=*Zero                                 ?G/L # SPEC CHARGES
     C                   Eval      OIITMA=IMLOOK                                ?ITEM ALPHA SEARCH
     C                   Eval      OISEDP=*Blanks                               ?SEED ORDERED Y/N
     C                   Eval      OIRVCD=*Zero                                 ?EXPIRE DATE - CYMD
     C                   Eval      OIQTE =*Blanks                               ?QUOTE LINE ITEM
     C                   Eval      OIORDT=ThisMonday                            ?HOLD ORIG REQ SHIP
     C                   Eval      OIRVDT=TodayYMD7                             ?REQ SHIP DATE CYMD
     C                   Eval      OILOT#=*Blanks                               ?LOT NUMBER
     C                   Eval      OIFRQD='N'                                   ?FORCE QTY DISC Y/N
     C                   Eval      OISPFL=*Blanks                               ?SUMMARY PICKSLIP FL
     C                   Eval      OIALPH=CMLOOK                                ?CUST ALPHA SEARCH
     C                   Eval      OIPRCL=IMPCL1                                ?PROD CLASS 1
     C                   Eval      OINPSL=*Blanks                               ?NO PICKSLIP FUTURE
     C                   Eval      OIRQTY=*Zero                                 ?PRE RELEASE QTY
     C                   Eval      OIPOST=*Blanks                               ?POST FLAG
     C                   Eval      OISOW =*Zero                                 ?SOW DATE CYMD
     C                   Eval      OICCDC=*Zero                                 ?C&C OR SALE DISC. %
     C                   Eval      OILIST=*Blanks                               ?LIST CODE
     C                   Eval      OIROY =IMROYL                                ?ROYALTY EACH

     C                   Eval      Tax1  = OIAMT1 * OIUPRI                      ?ST Tax on Item
     C                   Eval      Tax2  = OIAMT2 * OIUPRI                      ?CO Tax on Item
     C                   Eval      Tax3  = OIAMT3 * OIUPRI                      ?MU Tax on Item

     C                   Eval      TotalTax01 = TotalTax01 + Tax1               ?ST Total Tax
     C                   Eval      TotalTax02 = TotalTax02 + Tax2               ?CO Total Tax
     C                   Eval      TotalTax03 = TotalTax03 + Tax3               ?MU Total Tax
     C                   Eval      TotalOrder = TotalOrder + OIEXT$             ?Total Order Value

     C     DetailKey     KList
     C                   KFld                    OIORD#
     C                   KFld                    OISEQ#
     C     DetailKey     Chain     FIORDR
     C                   If        %found(FIORDR)
     C                   Eval      *InH2 = *On
     C                   Else
     C*                  CallP     $Allocate(OIITEM:OISIZE:OIQORD:'O')          ?Allocate Inventory
     C                   Write     RIORDR
     C                   ExSr      Wrt_ALITEM
     C                   If        TRSTAT = 'P'
     C                   ExSr      Wrt_Partial
     C                   EndIf
     C                   If        OIROY > 0
     C                   Z-ADD     OIQORD        QTYOR
     C                   Z-ADD     OIQSHP        QTYSHP
     C                   Call      'GETROY'
     C                   PARM                    OICOMP
     C                   PARM                    OIORD#
     C                   PARM                    OISEQ#
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    QTYOR            11 1
     C                   PARM                    QTYSHP           11 1
     C                   PARM      *Blanks       DESCR            60
     C                   PARM                    ORUPRI            9 4
     C                   PARM                    OREXT$            9 2
     C                   Z-Add     ORUPRI        OIROY
     C                   EndIf
     C                   EndIf

     C                   EndIf                                                  ?At least 1 (x)
     C                   EndDo
    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Wrt_Partial - Write Partial Comment Record         :
      *?  :.........................................................:
    ?C     Wrt_Partial   BegSr                                                  ?

     C                   Eval      OISEQ# += 1
     C                   Eval      OIITYP = 'C'
     C                   Eval      OIQORD = *Zero
     C                   Eval      OIQSHP = *Zero
     C                   Eval      OIUPRI = *Zero
     C                   Eval      OIEXT$ = *Zero
     C                   Eval      OIDES1 = PartText
     C                   Write     RIORDR

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Wrt_ALITEM - Write Item Allocation Record          :
      *?  :.........................................................:
    ?C     Wrt_ALITEM    BegSr                                                  ?

      /Free
         For Loop = 1 to CountItem;
           If TRSTAT <> 'P';
             Chain (TRITEM:TRSIZE:TRCRDT:TRSCYM) FDLOTRD_AR;
            Else;
             Chain (TRITEM:TRSIZE:TRCRDT:TRSCYM:999997) FDLOTRD_AR;
           EndIf;

           If %Found(FDLOTRD_AR);
             LRQTAL += 1;
             LRQTAV -= 1;
             Update RDLOTRD_AR;
            Else;

             If TRSTAT <> 'P';
               Chain (TRITEM:TRSIZE:TRCRDT:TRSCYM) FDLOTRD_NR;
              Else;
               Chain (TRITEM:TRSIZE:TRCRDT:TRSCYM:999997) FDLOTRD_NR;
             EndIf;
             If %Found(FDLOTRD_AR);
               LRQTAL += 1;
               LRQTAV -= 1;
               LRDTLA  = $MDYDate($Date(0));
               LRTIME  = $Now();
               LRUSER  = 'RBR020_NR';
               Update RDLOTRD_AR;
              Else;
               If TRSTAT <> 'P';
                 Chain (TRITEM:TRSIZE:TRCRDT:TRSCYM) FDLOTRD_X;
                Else;
                 Chain (TRITEM:TRSIZE:TRCRDT:TRSCYM:999997) FDLOTRD_X;
               EndIf;
               If %Found(FDLOTRD_X);
                 LRQTAL += 1;
                 LRQTAV -= 1;
                 LRDTLA  = $MDYDate($Date(0));
                 LRTIME  = $Now();
                 LRUSER  = 'RBR020_AR';
                 Update RDLOTRD_X;
                Else;
                 LRSTAT = 'A';
                 LRITEM = TRITEM;
                 LRSIZE = TRSIZE;
                 LRWHSE = *Blanks;
                 LRSOWD = TRSCYM;
                 LRGLOC = 'X';
                 LRPHYT = *Blanks;
                 LRCRDY = TRCRDT;
                 LRCPHY = *Blanks;
                 LRCLOC = *Blanks;
                 LRCODE = *Blanks;
                 If TRSTAT = 'P';
                   LRCUST = 999997;
                  Else;
                   LRCUST = 000000;
                 EndIf;
                 LRAREA = *Blanks;
                 LRCOMP = 1;
                 LRQTOH = *Zero;
                 LRDTLA = $MDYDate($Date(0));
                 LRTIME = $Now();
                 LRUSER = 'RBR020_AR';
                 LRALPH = *Blanks;
                 LRPRCL = TRALPH;
                 LRQTAL = +1;
                 LRDESC = TRALPH;
                 LRQTCM = *Zero;
                 LRQTSL = *Zero;
                 LRQADJ = *Zero;
                 LRQTAV = -1;
                 Write RDLOTRD_X;
               EndIf;
             EndIf;
           EndIf;

           Clear RALITEM;

           AIORD# = OHORD#;
           AIOSEQ = OrderSeq#;
           AIITEM = IMITEM;
           AISIZE = IMSIZE;
           AISOWD = LRSOWD;
           AICRDY = LRCRDY;
           AICUST = LRCUST;
           AIGLOC = LRGLOC;

           Chain
            (AIORD#:AIOSEQ:AIITEM:AISIZE:AISOWD:AICRDY:AICUST:AIGLOC)
             FALITEML5;

           AIPHYT  = LRPHYT;
           AIWHSE  = LRWHSE;
           AISHPD  = ThisMonCYMD;
           AISTAT  = 'A';
           AICOMP  = 1;
           AIQTOA += 1;
           AIDTLA  = TodayMDY;
           AITIME  = Now;
           AIUSER  = User;
           AIPRCL  = IMPCL1;

           If %Found(FALITEML5);
             Update RALITEM;
            Else;
             Write RALITEM;
           Endif;
         EndFor;
      /End-Free
    ?C                   EndSr


      *?  ...........................................................
      *?  :      Wrt_OPNORD - Write Open Order Value Record         :
      *?  :.........................................................:
    ?C     Wrt_OPNORD    BegSr                                                  ?

     C                   Eval      OOORD# = OHORD#                              ?ORDER NUMBER
     C                   Eval      OOCOMP = 1                                   ?COMPANY #
     C                   Eval      OOCUST = SMCUST                              ?CUSTOMER #
     C                   Eval      OODTRY = ThisMonCYMD                         ?REQ. DATE CYMD
     C                   Eval      OOORDY = TodayYMD7                           ?ORDER DATE CYMD
     C                   Eval      OOARCU = CMARCU                              ?AR CUST #
     C                   Eval      OOSACU = CMSACU                              ?SA CUST #
     C                   Eval      OOBLCU = CMBLCU                              ?BILLING CUST #
     C                   Eval      OOSHFR = CMTERR                              ?SHIP FROM
     C                   Eval      OOEXT$ = TotalOrder                          ?ORDER VALUE

    ?C                   Write     ROPNORD

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
     C                   Eval      ThisMonday = $MDYDate($Monday(Today:'FRI'))  ?Monday MDY
     C                   Eval      ThisMonCYMD = $Date7($Monday(Today:'FRI'))   ?Monday CYMD
     C                   Eval      Printer = $DftPrt('*NONE':'RBR010':'*PGM')

     C                   If        Dummy
     C     OHORD#        Chain     FHORDR
     C     Dummy_Key     KList
     C                   KFLD                    OIORD#
     C                   KFLD                    OISEQ#
     C     Dummy_Key     Chain     FIORDR
     C                   EndIf

     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

    ?C                   EndSr                                                  ?
