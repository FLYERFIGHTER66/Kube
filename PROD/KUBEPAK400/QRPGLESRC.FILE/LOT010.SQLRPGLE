     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Recip Sow line operation Display Un-sown           :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  June 2004            ? Kube-Pak Corporation ?    :
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
      *? :  40      ?RollDn Indicator                                ?:
      *? :  50      ?Error Indicator (All Errors)                    ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
     FLOT010FM  CF   E             WORKSTN
     F                                     SFILE(LOT01001:RRN01)
     F                                     DEVID(WSID)

     FFMINVT    IF   E           K DISK                                         ?Item Master
     FFIORDRR@S IF   E           K DISK                                         ?Orders
     FFSOWSCHR@SIF   E           K DISK                                         ?Sow Jobs
     FFTRAYSR@S IF   E           K DISK                                         ?Recip Trays
     FFTRAYRR@S IF   E           K DISK                                         ?Stand. Trays
     FFTRAYFIXEDIF   E           K DISK                                         ?Fixed Trays
     FFLOSSD    IF   E           K DISK                                         ?Tray Losses
     FFPARTIAL  IF   E           K DISK                                         ?Partial Trays
     FFDLOTALOC IF   E           K DISK                                         ?Lot Master
     FFDLOTRDCLTIF   E           K DISK                                         ?Lot Ready Date
     FFALITEMLOTIF   E           K DISK                                         ?Allocation Order

      *? Function Prototypes
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$DftPrt
    ?D/COPY QFunctDefn,$isFile
    ?D/COPY QFunctDefn,QCmdExc
    ?D/COPY QFunctDefn,$MONDAY

      *? Arrays
     D  CK_Array       DS
     D   CK01                                                                   ?Check Cond. 01
     D   CK02                                                                   ?Check Cond. 02
     D   CK03                                                                   ?Check Cond. 03
     D   CK04                                                                   ?Check Cond. 04
     D   CK05                                                                   ?Check Cond. 05
     D   CK06                                                                   ?Check Cond. 06
     D   CK07                                                                   ?Check Cond. 07
     D   CK08                                                                   ?Check Cond. 08
     D   CK09                                                                   ?Check Cond. 09
     D   CK10                                                                   ?Check Cond. 10
     D   CK11                                                                   ?Check Cond. 11
     D   CK12                                                                   ?Check Cond. 12
     D   CK13                                                                   ?Check Cond. 13
     D   OMITUNFIX                                                              ?Omit UnFixed ?
     D  LowKey01       DS
     D   IMLOOKLow                         Like(IMLOOK) Inz(*Hival)             ?Look
     D   IMITEMLow                         Like(IMITEM) Inz(*Hival)             ?ITEM
     D   IMSIZELow                         Like(IMSIZE) Inz(*Hival)             ?SIZE
     D  OrderKey       DS
     D   OIITMA                                                                 ?Look
     D   OIITEM                                                                 ?ITEM
     D   OISIZE                                                                 ?SIZE
     D  SowJobKey      DS
     D   SOLOOK                                                                 ?Look
     D   SOITEM                                                                 ?ITEM
     D   SOSIZE                                                                 ?SIZE
     D  TrayKey        DS
     D   TRALPH                                                                 ?Look
     D   TRITEM                                                                 ?ITEM
     D   TRSIZE                                                                 ?SIZE

      *? Un-Sown Trays Data Structure
     D  FTRAY_DS       DS                  INZ
     D  RdyDate                            Like(TRSCYM)                         ?Rdy_Date
     D  RdyDate@                      7A                                        ?Rdy_Date
     D  ReadyDate                          Like(TRCRDT)                         ?Ready_Date
     D  Size                               Like(TRSIZE)                         ?Size
     D  Item                               Like(TRITEM)                         ?Item
     D  Alpha                              Like(TRALPH)                         ?Alpha
     D  Desc01                             Like(IMDES1)                         ?Description
     D  Factor                        5S 3                                      ?Factor
     D  Seed_Cell                          Like(IM#SED)                         ?Seed_Cell
     D  Tray_Count                    4S 0                                      ?Tray_Count
     D  Seed_Need                     7S 0                                      ?Seed_Need
     D  On_Hand                            Like(IMQTOH)                         ?On_Hand
     D  Sow_Method                         Like(IMTPSW)                         ?Sow Method
     D  BlankJob#                     4A   Inz(*Blanks)                         ?Blank Job #

      *? Field Definitions
     D   User          S             10A                                        ?Current User ID
     D   RRN01         S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   RRN02         S              4  0 Inz(0)                               ?SFLRRN Screen 02
     D   RRN03         S              4  0 Inz(0)                               ?SFLRRN Screen 03
     D   StopRRN01     S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   Step01        S              4  0 Inz(0)                               ?SFLRRN 01 Increment
     D   ErrorCount    S              3S 0 Inz(0)                               ?Error Count
     D   ErrorCount01  S              3S 0 Inz(0)                               ?Error Count
     D   ErrorCount02  S              3S 0 Inz(0)                               ?Error Count
     D   ErrorCount03  S              3S 0 Inz(0)                               ?Error Count
     D   RecordCount   S              5S 0 INZ(0)
     D   RdyDate7      S                   Like(TRCRDT)                         ?Ready Date 7
     D   Today         S              6S 0                                      ?Todays Date MDY
     D   Now           S              6S 0                                      ?The Time at *Init
     D   ChainRRN01    S              4S 0 Inz(*Zero)                           ?Key by RRN
     D   ChainRRN02    S              4S 0 Inz(*Zero)                           ?Key by RRN
     D   Printer       S             10A   Inz('*LAST')                         ?Printer
     D   Program       S             10A                                        ?Program
     D   FileName      S             10A                                        ?File Name for Label
     D   SowD          S               D                                        ?Sow Date
     D   LastFixd      S               D                                        ?Date Last Fixed
     D   LastFixd6     S              6S 0                                      ?Date Last Fixed
     D   SAVITEM       S                   Like(SELITEM)                        ?ITEM
     D   SAVSIZE       S                   Like(SELSIZE)                        ?SIZE
     D   SAVLOOK       S                   Like(SELLOOK)                        ?LOOK
     D   SAVRdyDate    S                   Like(RdyDate)                        ?Rdy Date
     D   SOSOWDSav     S                   Like(SOSOWD)                         ?Sow Date Save
    ?D DftWHSE         S                   Like(LDWHSE) Inz(*Blanks)
    ?D   loopCounter   S             11S 0 Inz(*Zero)

      *? Indicators
     D   Done01        S               N
     D   Done02        S               N
     D   Done03        S               N
     D   EndOfFile     S               N
     D   OutOfKeys     S               N
     D   MultiSow      S               N
     D   ItemMast_NG   S               N


    ?C                   ExSr      ClrError                                     ?
    ?C                   ExSr      Scrn00                                       ?

     C     *INLR         DOUEQ     *ON                                          ?COMMENT

    ?C                   SELECT                                                 ?
    ?C     Screen        WhenEq    0                                            ?
    ?C                   ExSr      Edit00                                       ?
    ?C     Screen        WhenEq    1                                            ?
    ?C                   ExSr      Edit01                                       ?
    ?C     Screen        WhenEq    2                                            ?
    ?C                   ExSr      Edit02                                       ?
    ?C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      Scrn00 - Display Screen 00                         :
      *?  :.........................................................:
    ?C     Scrn00        BegSr                                                  ?
     C                   If        Screen <> 00
     C                   Z-Add     Screen        PrevScreen        3 0          ?Prev. Screen
     C                   EndIf
     C                   Z-Add     00            Screen            3 0          ?Screen  Number
    ?C                   ExFmt     LOT01000                                     ?
    ?C                   ExSr      ClrError                                     ?
     C                   Eval      ErrorCount01 = *Zero                         ?Error Count
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   If        Screen <> 01
     C                   Z-Add     Screen        PrevScreen        3 0          ?Prev. Screen
     C                   EndIf
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
     C                   Eval      *In25 = *On                                  ?
    ?C                   Write     ASSUME
    ?C                   Write     LOT01001F                                   ?
     C                   If        ErrorCount01 <> *Zero                        ?Error Count
    ?C                   Write     MSGCTL                                       ?
     C                   EndIf
     C                   If        StartRRN01 = *Zero
     C                   Eval      StartRRN01 = 1
     C                   EndIf
    ?C                   ExFmt     LOT01001C                                    ?
    ?C                   ExSr      ClrError                                     ?
     C                   Eval      ErrorCount01 = *Zero                         ?Error Count
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn02 - Display Screen 02                         :
      *?  :.........................................................:
    ?C     Scrn02        BegSr                                                  ?
     C                   If        Screen <> 02
     C                   Z-Add     Screen        PrevScreen        3 0          ?Prev. Screen
     C                   EndIf
     C                   Z-Add     02            Screen            3 0          ?Screen  Number
    ?C                   ExFmt     LOT01002                                     ?
    ?C                   ExSr      ClrError                                     ?
     C                   Eval      ErrorCount02 = *Zero                         ?Error Count
    ?C                   EndSr                                                  ?

      *?  ............................................................
      *?  :      LowKeys01 - Find the lowest key value for all Files :
      *?  :..........................................................:
    ?C     LowKeys01     BegSr                                                  ?

     C                   If        ItemMast_NG
     C                   Eval      IMLOOK = IMLOOKLow
     C                   Eval      ItemMast_NG = *Off
     C                   EndIf

    ?C     SowItmSiz     SetGT     FIORDRR@S
    ?C     SowItmSiz     SetGT     FSOWSCHR@S
    ?C     SowItmSiz     SetGT     FTRAYSR@S
    ?C     SowItmSiz     SetGT     FTRAYRR@S

     C                   Reset                   IMLOOKLow
     C                   Reset                   IMITEMLow
     C                   Reset                   IMSIZELow

    ?C     SowItmSiz     KList
    ?C                   KFld                    RdyDate
    ?C                   KFld                    IMLOOK
    ?C                   KFld                    IMITEM
    ?C                   KFld                    IMSIZE

    ?C     ItemKey       KList
    ?C                   KFld                    IMITEM
    ?C                   KFld                    IMSIZE

     C                   Eval      OrderKey = *HiVal
    ?C     RdyDate       ReadE     FIORDRR@S
     C                   If        OrderKey < LowKey01 and not %EOF(FIORDRR@S)
     C                   Eval      LowKey01 = OrderKey
     C                   EndIf

     C                   Eval      SowJobKey = *HiVal
    ?C     RdyDate       ReadE     FSOWSCHR@S
     C                   If        SowJobKey < LowKey01 and not %EOF(FSOWSCHR@S)
     C                   Eval      LowKey01 = SowJobKey
     C                   EndIf

     C                   Eval      TrayKey = *HiVal
    ?C     RdyDate       ReadE     FTRAYSR@S
     C                   If        TrayKey < LowKey01 and not %EOF(FTRAYSR@S)
     C                   Eval      LowKey01 = TrayKey
     C                   EndIf

     C                   Eval      TrayKey = *HiVal
    ?C     RdyDate       ReadE     FTRAYRR@S
     C                   If        TrayKey < LowKey01 and not %EOF(FTRAYRR@S)
     C                   Eval      LowKey01 = TrayKey
     C                   EndIf

     C                   If        %EOF(FIORDRR@S) and
     C                             %EOF(FSOWSCHR@S) and
     C                             %EOF(FTRAYSR@S) and
     C                             %EOF(FTRAYRR@S)
     C                             or
     C                             SELLOOK <> *Blanks and
     C                             %Trim(SELLOOK)
     C                             < %Subst(IMLOOKLow:1:%Len(%Trim(SELLOOK)))
     C                   Eval      OutOfKeys = *On
     C                   Else
     C                   Eval      IMITEM = IMITEMLow
     C                   Eval      IMSIZE = IMSIZELow
     C                   EndIf

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load00 - Load Screen 00                            :
      *?  :.........................................................:
    ?C     Load00        BegSr                                                  ?

     C                   Eval      RdyDate7 = $Date7($Monday($Date(0):'SAT'))
     C                   Eval      SelRdyDate= $MDYDate($Monday($Date(0):'SAT'))
     C                   Eval      *In83 = *Off

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

     C                   Eval      Step01 = 18 * ( 1 )
     C                   Eval      OutOfKeys = *Off
      *? Clear the Subfile
     C                   Eval      Option = *Blanks
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
     C                   Eval      *In81 = *Off
     C                   Eval      StartRRN01 = *Zero
    ?C                   Write     LOT01001C                                    ?

      *? Load the Subfile
     C                   Eval      RdyDate  =
     C                             $Date7($Monday($DateMDY(SELRdyDate):'SAT'))
     C                   Eval      SowD = $Date(RdyDate)

     C                   Z-add     *Zero         RRN01                          ?

     C                   Eval      IMLOOK = SELLOOK
     C                   Eval      IMITEM = *Blanks
     C                   Eval      IMSIZE = *Blanks

     C                   ExSr      LowKeys01

     C                   Eval      StopRRN01 = Step01

     C                   If        *In83
     C                   Eval      StopRRN01 = 9999
     C                   EndIf

     C                   DoW       not OutOfKeys and RRN01 < StopRRN01
      *? Load screen fields
     C                   ExSr      Load01Fld

     C                   EndDo                                                  ?

     C                   IF        *In26 = *On and OutOfKeys                    ?
    ?C     RRN01         Chain     LOT01001                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    LOT01001                                     ?
     C                   EndIF                                                  ?

     C                   Eval      SAVITEM = SELITEM
     C                   Eval      SAVSIZE = SELSIZE
     C                   Eval      SAVLOOK = SELLOOK
     C                   Eval      SAVRdyDate = SELRdyDate

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      More01 - Load Screen 01 w/ More records            :
      *?  :.........................................................:
    ?C     More01        BegSr                                                  ?

     C                   If        not OutOfKeys

     C                   Eval      StartRRN01= RRN01 + 1
     C                   Eval      StopRRN01 = RRN01 + Step01

     C                   DoW       not OutOfKeys and RRN01 < StopRRN01
      *? Load screen fields
     C                   ExSr      Load01Fld

     C                   EndDo                                                  ?

     C                   IF        *In26 = *On and OutOfKeys                    ?
    ?C     RRN01         Chain     LOT01001                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    LOT01001                                     ?
     C                   EndIF                                                  ?

     C                   Eval      SAVITEM = SELITEM
     C                   Eval      SAVSIZE = SELSIZE
     C                   Eval      SAVLOOK = SELLOOK
     C                   Eval      SAVRdyDate = SELRdyDate

     C                   EndIf                                                  ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load01Fld - Load Screen 01 Fields                  :
      *?  :.........................................................:
    ?C     Load01Fld     BegSr                                                  ?

      *? Load screen fields
     C*                  Eval      loopCounter = *Zero
    ?C     ItemKey       Chain     FMINVT
     C                   If        %Found(FMINVT)                          and
     C                             (SELSIZE = *Blanks or SELSIZE = IMSIZE) and
     C                             (SELITEM = *Blanks or SELITEM = IMITEM) and
     C                             (SELLOOK = *Blanks or
     C                              %SUBST(IMLOOK:1:%Len(%Trim(SelLOOK)))
     C                              = %Trim(SelLook))
    ?C                   Clear                   LOT01001
     C                   ExSr      GetOrders                                    ?On Orders
     C                   ExSr      GetJobSch                                    ?On Schedule
     C                   ExSr      GetTray                                      ?On Tray File
     C                   ExSr      GetTrayR                                     ?On Tray File "R"

     C*                  Eval      loopCounter += 1
     C*                  If        loopCounter > 1000
     C*                  Eval      *InH1 = *On
     C*                  EndIf
      *?     Determine if record should be included...
     C                   If        ONORDERS <> 0 or
     C                             SOWJOBLB <> 0 or
     C                             SOWJOBSN <> 0 or
     C                             SOWJOBTS <> 0 or
     C                             TRAYSSN  <> 0 or
     C                             TRAYSLB  <> 0

      *?     Populate subfile fields
     C                   Eval      Item5 = IMITEM
     C                   Eval      Item  = IMITEM
     C                   Eval      SIZE  = IMSIZE
     C                   Eval      LOOK  = IMLOOK
     C                   Eval      DES1  = IMDES1
     C  N52              Eval      SowDate = $MDYDate($Date(SOSOWD))
     C   52              Eval      SowDate = 999999
     C                   ExSr      GetFDLOT                                     ?On FDLOT
     C                   If        SLDFIXD = 'Y' or OmitUnFix = 'N'
     C                   ExSr      GetFDLOTRD                                   ?On FDLOTRD
     C                   ExSr      GetFALITEM                                   ?On FALITEM

      *?     Check record for Error Conditions
     C                   If           SOWJOBTS < ONORDERS           and CK01='Y'
     C                             or SOWJOBLB > SOWJOBTS           and CK02='Y'
     C                             or SOWJOBSN > SOWJOBTS           and CK03='Y'
     C                             or SOWJOBSN > SOWJOBLB           and CK04='Y'
     C                             or TRAYSSN+TRAYSLB > SOWJOBSN    and CK05='Y'
     C                             or LOSSES   > SOWJOBSN           and CK06='Y'
     C                             or PARTCOUNT > 1                 and CK07='Y'
     C                             or AVAILABLE < 0                 and CK08='Y'
     C                             or SOWJOBSN < FIXED              and CK09='Y'
     C                             or PARTTRAYS >= 1                and CK10='Y'
     C                             or (ONHAND <> SLDQTOH or
     C                                ONHAND <> SLRQTOH or
     C                                SLRQTOH<> SLDQTOH)            and CK11='Y'
     C                             or (ONORDERS <> SLDQTAL  or
     C                                SLRQTAL + SLRQTAL9 <> ONORDERS or
     C                                SLRQTAL + SLRQTAL9 <>SLDQTAL) and CK12='Y'
     C                             or (SLRQTAV + SLRQTAV9 <> AVAILABLE or
     C                                 SLDQTAV<> AVAILABLE)         and CK13='Y'
     C*                            or                               and CK14='Y'
     C*                            or                               and CK15='Y'
     C                   Eval      *In82 = *On
     C                   Else
     C                   Eval      *In82 = *Off
     C                   EndIf
      *?     Check record for Color Representation
      *             ?This record is perfect?
     C                   If        not *In82                                 and
     C                             AVAILABLE = SLRQTAV + SLRQTAV9            and
     C                             SLDQTAL   = SLRQTAL + SLRQTAL9            and
     C                             LOSSES = SLDQFIX                          and
     C                             ONORDERS = SLDQTAL - SLRQTAL9             and
     C                             ONORDERS = SLRQTAL - SLRQTAL9             and
     C                             ONHAND = SLDQTOH                          and
     C                             ONHAND = SLRQTOH                          and
     C                             SLRQTOH = SLDQTOH                         and
     C                             SLRQTAV + SLRQTAV9 = AVAILABLE            and
     C                             SLDQTAV = AVAILABLE                       and
     C                             ONORDERS = SLDQTAL                        and
     C                             SLRQTAL + SLRQTAL9 = ONORDERS             and
     C                             SLRQTAL + SLRQTAL9 = SLDQTAL
     C                   Eval      *In60 = *On
     C                   Else
     C                   Eval      *In60 = *Off
     C                   EndIf
      *?     Check record for other errors
     C                   If        ONHAND <> SLDQTOH or
     C                             ONHAND <> SLRQTOH or
     C                             SLRQTOH<> SLDQTOH
     C                   Eval      *In51 = *On
     C                   Else
     C                   Eval      *In51 = *Off
     C                   EndIf

     C                   If        SLRQTAV + SLRQTAV9 <> AVAILABLE or
     C                             SLDQTAV<> AVAILABLE
     C                   Eval      *In52 = *On
     C                   Else
     C                   Eval      *In52 = *Off
     C                   EndIf

     C                   If        ONORDERS <> SLDQTAL  or
     C                             SLRQTAL + SLRQTAL9 <> ONORDERS or
     C                             SLRQTAL + SLRQTAL9 <> SLDQTAL
     C                   Eval      *In53 = *On
     C                   Else
     C                   Eval      *In53 = *Off
     C                   EndIf
      *? Write Subfile Record
     C                   If        (*In83 and *In82) or not *In83               ?Show Errors Only 83
     C                   Add       1             RRN01                          ?

      *?     Check to see if this is the starting screen
     C                   If        StartRRN01 = 0 and
     C                             %SUBST(IMLOOK:1:%Len(%Trim(StartWith)))
     C                             = %Trim(StartWith)
     C                   Eval      *In81 = *On                                   Position Cursor
     C                   Eval      StartRRN01 = RRN01
     C                   EndIf

    ?C                   Write     LOT01001                                     ?
     C                   Eval      *In26 = *On                                  ?Have Data Indicator
     C                   Eval      *In81 = *Off                                  Position Cursor
     C                   EndIf
     C                   EndIf
     C                   EndIf
     C                   Else
     C                   Eval      ItemMast_NG = *On
     C                   EndIf

     C                   ExSr      LowKeys01

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      GetOrders                                          :
      *?  :.........................................................:
    ?C     GetOrders     BegSr                                                  ?

     C*                  Eval      ONORDERS=$QtyOrder(IMITEM:IMSIZE:SOWD:'SOW') ?On Orders
    ?C     SowItmSiz     SetLL     FIORDRR@S
     C                   If        %EQUAL(FIORDRR@S)
    ?C     SowItmSiz     ReadE     FIORDRR@S
     C                   DoW       not %EOF(FIORDRR@S)
WJB  C*                  If        OILOTC <> 'Y' or
WJB  C*                            (OILOTC = 'Y' and OILOT# = 'CustomOrdr')
     C                   Eval      ONORDERS = ONORDERS + (OIQORD-OIQSHP)
WJB  C*                  EndIf
    ?C     SowItmSiz     ReadE     FIORDRR@S
     C                   EndDo
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      GetJobSch                                          :
      *?  :.........................................................:
    ?C     GetJobSch     BegSr                                                  ?

     C                   Eval      MultiSow = *Off                              ?Multiple Sow Dates
    ?C     SowItmSiz     SetLL     FSOWSCHR@S
     C                   If        %EQUAL(FSOWSCHR@S)
    ?C     SowItmSiz     ReadE     FSOWSCHR@S
     C                   Eval      SOSOWDSav = SOSOWD                           ?Sow Date
     C                   DoW       not %EOF(FSOWSCHR@S)
     C                   Eval      SOWJOBLB = SOWJOBLB + SOSOWL                 ?Labelled
     C                   Eval      SOWJOBSN = SOWJOBSN + SOSOWQ                 ?Sown
     C                   Eval      SOWJOBTS = SOWJOBTS + SOSOWT                 ?To Sow

     C                   If        SOSOWD <> SOSOWDSav
     C                   Eval      MultiSow = *On
     C                   EndIf

    ?C     SowItmSiz     ReadE     FSOWSCHR@S
     C                   EndDo
     C                   EndIf

     C                   If        MultiSow
     C                   Eval      *In52 = *On
     C                   Else
     C                   Eval      *In52 = *Off
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      GetTray                                            :
      *?  :.........................................................:
    ?C     GetTray       BegSr                                                  ?

     C                   Eval      LastFixd = $date(20000101)
     C*                  Eval      TRAYSSN =$QtyFTRAY(IMITEM:IMSIZE:SOWD)       ?Tray Count
    ?C     SowItmSiz     SetLL     FTRAYSR@S
     C                   If        %EQUAL(FTRAYSR@S)
    ?C     SowItmSiz     ReadE     FTRAYSR@S
     C                   DoW       not %EOF(FTRAYSR@S)
     C                   If        TRSTAT <> 'D'
     C                   Eval      TRAYSSN = TRAYSSN + 1                        ?Tray Count
     C                   ExSr      GetFixLoss
     C                   EndIf
    ?C     SowItmSiz     ReadE     FTRAYSR@S
     C                   EndDo
     C                   EndIf
     C                   Eval      LastFixd6 = $MDYDate(LastFixd)

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      GetTrayR                                           :
      *?  :.........................................................:
    ?C     GetTrayR      BegSr                                                  ?

     C*                  Eval      TRAYSLB =$QtyFTRAYR(IMITEM:IMSIZE:SOWD)      ?Tray Count "R"
    ?C     SowItmSiz     SetLL     FTRAYRR@S
     C                   If        %EQUAL(FTRAYRR@S)
    ?C     SowItmSiz     ReadE     FTRAYRR@S
     C                   DoW       not %EOF(FTRAYRR@S)
     C                   If        TRSTAT <> 'D'
     C                   Eval      TRAYSLB = TRAYSLB + 1                        ?Tray Count "R"
     C                   ExSr      GetFixLoss
     C                   EndIf
    ?C     SowItmSiz     ReadE     FTRAYRR@S
     C                   EndDo
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?  .................................................................
      *?  :      GetFDLOT   - Get LDLOT records                           :
      *?  :...............................................................:
    ?C     GetFDLOT      BegSr                                                  ?

    ?C     LOTKey        Chain     FDLOTALOC                                    ?
     C                   If        %found(FDLOTALOC)
     C                   Eval      sLDQTOH = LDQTOH
     C                   Eval      sLDFIXD = LDFIXD
     C                   Eval      sLDQTAL = LDQTAL
     C                   Eval      sLDQTAV = LDQTAV
     C                   Eval      sLDQFIX = LDQFIX
     C                   Eval      sLDQDMP = LDQDMP
     C                   Else
     C                   Eval      sLDQTOH = *Zero
     C                   Eval      sLDFIXD = *Blanks
     C                   Eval      sLDQTAL = *Zero
     C                   Eval      sLDQTAV = *Zero
     C                   Eval      sLDQFIX = *Zero
     C                   Eval      sLDQDMP = *Zero
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?  .................................................................
      *?  :      GetFDLOTRD - Get LDLOTRD records                         :
      *?  :...............................................................:
    ?C     GetFDLOTRD    BegSr                                                  ?

    ?C     LOTKey        SetLL     FDLOTRDCLT                                   ?
     C                   Eval      sLRQTOH  = *Zero
     C                   Eval      sLRQTAL  = *Zero
     C                   Eval      sLRQTAV  = *Zero
    ?C     LOTKey        ReadE     FDLOTRDCLT                                   ?
     C                   DoW       not %EOF(FDLOTRDCLT)
     C                   Eval      sLRQTOH = sLRQTOH + LRQTOH
WJB  C*                  If        LRCUST < 999999 and
WJB  C                   If        LRCUST < 999990 and
     C                             LRCUST > *Zero
     C                   Eval      sLRQTAL  = sLRQTAL  + LRQTAL
     C                   Eval      sLRQTAV  = sLRQTAV  + LRQTAV
     C                   Else
     C                   Eval      sLRQTAL9 = sLRQTAL9 + LRQTAL
     C                   Eval      sLRQTAV9 = sLRQTAV9 + LRQTAV
     C                   EndIf
    ?C     LOTKey        ReadE     FDLOTRDCLT                                   ?
     C                   EndDo

    ?C                   EndSr                                                  ?


      *?  .................................................................
      *?  :      GetFALITEM - Get FALITEM records                         :
      *?  :...............................................................:
    ?C     GetFALITEM    BegSr                                                  ?

    ?C     LOTKey        SetLL     FALITEMLOT                                   ?
     C                   Eval      sAIQTOA  = *Zero
     C                   Eval      sAIQTOA9 = *Zero
    ?C     LOTKey        ReadE     FALITEMLOT                                   ?
     C                   DoW       not %EOF(FALITEMLOT)
WJB  C*                  If        AICUST < 999999 and
WJB  C                   If        AICUST < 999990 and
WJB  C*                            AIORD# < 999999
WJB  C                             AIORD# < 999990
     C                   Eval      sAIQTOA  = sAIQTOA  + AIQTOA
     C                   Else
     C                   Eval      sAIQTOA9 = sAIQTOA9 + AIQTOA
     C                   EndIf
    ?C     LOTKey        ReadE     FALITEMLOT                                   ?
     C                   EndDo

    ?C                   EndSr                                                  ?


      *?  .................................................................
      *?  :      GetFixLoss - Get Fixed, Loss, Partial & PartTrays Counts :
      *?  :...............................................................:
    ?C     GetFixLoss    BegSr                                                  ?

      *?   Fixed
    ?C     TRTAG#        SetLL     FTRAYFIXED
     C                   If        %EQUAL(FTRAYFIXED)
    ?C     TRTAG#        ReadE     FTRAYFIXED
    ?C                   DoW       not %EOF(FTRAYFIXED)                         ?
    ?C     TRTAG#        ReadE     FTRAYFIXED
    ?C                   EndDo
     C                   Eval      FIXED   = FIXED   + 1                        ?Tray Count Fixed
     C                   If        LastFixd < %Date(TFTIME)
     C                   Eval      LastFixd = %Date(TFTIME)
     C                   EndIf
     C                   EndIf

      *?   Loss
    ?C     TRTAG#        SetLL     FLOSSD
     C                   If        %EQUAL(FLOSSD)
    ?C     TRTAG#        Chain     FLOSSD
     C                   Eval      LOSSES  = LOSSES  + 1                        ?Tray Count Losses
    ?C                   Select
      *?      Fixers
    ?C                   When      LDCODE = 'F'
     C                   Eval      FIXERS  = FIXERS  + 1                        ?Tray Count Fixers
      *?      Partials
    ?C                   When      LDCODE = 'P'
     C                   Eval      PARTCOUNT = PARTCOUNT + 1                    ?Tray Count Partl
    ?C     TRTAG#        Chain     FPARTIAL
     C                   If        %Found(FPARTIAL)
     C*                  Eval      PARTCOUNT = PARTCOUNT + 1                    ?Tray Count Partl
     C                   Eval      PARTTRAYS = PARTTRAYS + (LDPCTF/100)         ?Tray Count PartTray
     C                   EndIf
      *?      All Other Loss Codes
    ?C                   Other
     C                   Eval      OTHERLOSS = OTHERLOSS + 1                    ?Tray Count Other
    ?C                   EndSl

     C                   EndIf

     C                   If        SOWJOBSN >  FIXED
     C                             and  FIXED = *Zero
     C                   Eval      AVAILABLE = SOWJOBSN -
     C                             ONORDERS -  LOSSES
     C                   Eval      AVAILABLE2= SOWJOBSN -
     C                             ONORDERS -  LOSSES
     C                   Eval      ONHAND = SOWJOBSN - LOSSES
     C                   Else
     C                   Eval      AVAILABLE = FIXED    -
     C                             ONORDERS -  LOSSES
     C                   Eval      AVAILABLE2= FIXED    -
     C                             ONORDERS -  LOSSES
     C                   Eval      ONHAND = FIXED - LOSSES
     C                   EndIf


    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load02 - Load Screen 00                            :
      *?  :.........................................................:
    ?C     Load02        BegSr                                                  ?

     C                   Eval      CK_array = 'YYYYYYNYYYYYYN'

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit00 - EDIT Screen 00                            :
      *?  :.........................................................:
    ?C     Edit00        BegSr                                                  ?

      *? Process pre-edit Functions F3, F6, F7 & F9
    ?C                   SELECT                                                 ?
      *? Cancel Requested
    ?C                   When         *In03
    ?C                             or *In07
     C                   MOVE      *ON           *INLR                          ?
      *? Refresh Requested
    ?C                   When         *In05
    ?C                   ExSr      Load00
    ?C                   ExSr      Scrn00
      *? Toggle Errors Only
    ?C                   When         *In06
     C                   If        *In83
     C                   Eval      *In83 = *Off
     C                   Else
     C                   Eval      *In83 = *On
     C                   EndIf
    ?C                   ExSr      Scrn00
      *? Error Conditions
    ?C                   When         *In09
    ?C                   ExSr      Scrn02
      *? Verify Sow Date.
    ?C                   When      SELRdyDate = 0
    ?C                   ExSr      Scrn00
      *? Passed all Edits ==> Screen 01
    ?C                   OTHER                                                  ?
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

      *? Process pre-edit Functions F3, F6, F7 & F9
    ?C                   SELECT                                                 ?
      *? Cancel Requested
    ?C                   When         *In03
    ?C                             or *In07
     C                   MOVE      *ON           *INLR                          ?
      *? RollDown Requested
    ?C                   When         *In40 and not OutOfKeys
    ?C                   ExSr      More01
    ?C                   ExSr      Scrn01
      *? RollDown Requested past end
    ?C                   When         *In40
     C                   Eval      ErrorCount01 = ErrorCount01 + 1              ?Error Count
     C                   Eval      MessageID = 'SFL0102'
     C                   Eval      MessageDta = *Blanks
    ?C                   ExSr      SndError
    ?C                   ExSr      Scrn01
      *? Refresh Requested
    ?C                   When         *In05
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? Toggle Errors Only
    ?C                   When         *In06
     C                   If        *In83
     C                   Eval      *In83 = *Off
     C                   Else
     C                   Eval      *In83 = *On
     C                   EndIf
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? Change Error Conditions
    ?C                   When         *In09
    ?C                   ExSr      Scrn02
      *? Selection Changed
    ?C                   When      SELITEM <> SAVITEM or
    ?C                             SELSIZE <> SAVSIZE or
    ?C                             SELLOOK <> SAVLOOK or
    ?C                             SELRdyDate <> SAVRdyDate
     C                   Eval      SAVITEM = SELITEM
     C                   Eval      SAVSIZE = SELSIZE
     C                   Eval      SAVLOOK = SELLOOK
     C                   Eval      SAVRdyDate = SELRdyDate
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? If no Functions, Check for Options.
    ?C                   OTHER                                                  ?
    ?C                   ExSr      Opts01                                       ?Screen 01 Options
      *? Redisplay
    ?C                   ExSr      Scrn01
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Edit02 - EDIT Screen 02                            :
      *?  :.........................................................:
    ?C     Edit02        BegSr                                                  ?

      *? Process pre-edit Functions F3, F6, F7 & F9
    ?C                   SELECT                                                 ?
      *? Cancel Requested
    ?C                   When         *In03
    ?C                             or *In07
     C                   MOVE      *ON           *INLR                          ?
      *? Select All Errors
    ?C                   When         *In08
     C                   Eval      CK_Array = 'YYYYYYYYYYYYY'
    ?C                   ExSr      Scrn02
      *? Select No Errors
    ?C                   When         *In09
     C                   Eval      CK_Array = 'NNNNNNNNNNNNN'
    ?C                   ExSr      Scrn02
      *? Select Default Errors
    ?C                   When         *In10
    ?C                   ExSr      Load02
    ?C                   ExSr      Scrn02
      *? Passed all Edits ==> Screen 01
    ?C                   OTHER                                                  ?
    ?C                   Select                                                 ?
    ?C                   When      PrevScreen = 0                               ?
     C                   ExSr      Scrn00
    ?C                   When      PrevScreen = 1                               ?
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   ENDSL                                                  ?
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Opts01 - Process Screen 01 Options                 :
      *?  :.........................................................:
    ?C     Opts01        BegSr                                                  ?

    ?C                   ReadC     LOT01001
     C                   DoW       not %EOF(LOT010FM)
     C                   Eval      *In50 = *Off                                 ?Error Indicator
     C                   Eval      *In28 = *Off                                 ?Subfile Next Change
    ?C                   SELECT                                                 ?
      *? Option = ' '  (Do Nothing)
    ?C                   When         Option = ' '
     C                   Eval      *In28 = *Off                                 ?Subfile Next Change
      *? Option = '1'  (Item Inquiry by Item)
    ?C                   When         Option = '1'
     C                   Call      'BIR265'
     C                   Parm                    ITEM
     C                   Parm                    SIZE
     C                   Eval      Option = *Blanks
     C                   Eval      *In28 = *Off                                 ?Subfile Next Change
      *? Option = '2'  (Sow Jobs Inquiry)
    ?C                   When         Option = '2'
     C                   Call      'LOT010'
     C                   Parm                    RdyDate
     C                   Parm                    ITEM
     C                   Parm                    SIZE
     C                   Eval      Option = *Blanks
     C                   Eval      *In28 = *Off                                 ?Subfile Next Change
      *? Option = '3'  (Tags Inquiry)
    ?C                   When         Option = '3'
     C                   Call      'SOW039'
     C                   Parm                    RdyDate
     C                   Parm                    ITEM
     C                   Parm                    SIZE
     C                   Eval      Option = *Blanks
     C                   Eval      *In28 = *Off                                 ?Subfile Next Change
      *? Option = '4'  (Lot Loss Summary)
    ?C                   When         Option = '4'
     C                   Call      'FXG068'
     C                   Parm                    RdyDate
     C                   Parm                    ITEM
     C                   Parm                    SIZE
     C                   Eval      Option = *Blanks
     C                   Eval      *In28 = *Off                                 ?Subfile Next Change
      *? Option = '5'  (Fix Job Schedule)
    ?C                   When         Option = '5'
     C                   Eval      RdyDate@ = %Char(RdyDate)
     C                   Call      'SOW037'                                     ?Recalc spec. lot
     C                   Parm                    RdyDate@
     C                   Parm                    ITEM
     C                   Parm                    SIZE
     C                   Parm                    BlankJob#
     C                   Call      'FXG065LOT'                                  ?Recalc Lot Loss
     C                   Parm                    RdyDate@
     C                   Parm                    ITEM
     C                   Parm                    SIZE
     C                   Eval      Option = *Blanks
     C                   Eval      *In28 = *Off                                 ?Subfile Next Change
      *? Any Other Option is invalid
    ?C                   OTHER                                                  ?
     C                   Eval      MessageID = 'LOT0100'
     C                   Eval      MessageDta = Option
    ?C                   ExSr      SndError
     C                   Eval      ErrorCount01 = ErrorCount01 + 1              ?Error Count
     C                   Eval      *In50 = *On
     C                   Eval      *In28 = *On
    ?C                   ENDSL                                                  ?
    ?C                   Update    LOT01001
    ?C                   ReadC     LOT01001
     C                   EndDo

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      ClrError - Clear Error Message Subfile             :
      *?  :.........................................................:
    ?C     ClrError      BegSr                                                  ?

     C                   MOVE      'C'           SndClr
    ?C                   ExSr      SRMSGF                                       ?
     C                   Eval      ErrorCount = *Zero                           ?Error Count
     C                   Eval      *In50 = *Off                                 ?Error Indicator

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      SndError - Send an Error Message to the PGMMSGQ    :
      *?  :.........................................................:
    ?C     SndError      BegSr                                                  ?

     C                   MOVE      'S'           SndClr
    ?C                   ExSr      SRMSGF                                       ?
     C                   Eval      ErrorCount = ErrorCount + 1                  ?Error Count
     C                   Eval      *In50 = *On                                  ?Error Indicator

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      * ? :      SRMSGF - Clear or send messages to Pgm msg queue   :
      *?  :.........................................................:
    ?C     SRMSGF        BegSr                                                  ?

      *? Define Parameter List - define variables         ?

     C     MessageParm   PLIST                                                  ?
     C                   Parm      'LOT010'      PgmQ             10            ?Pgm Msg Queue
     C                   Parm      'KPMSGF'      MsgFile          10            ?Message File
     C                   Parm      '*LIBL'       MsgfLib          10            ?Library
     C                   Parm                    MessageID         7            ?Message Id
     C                   Parm                    MessageDta      100            ?Message Data
     C                   Parm                    MsgKey            4            ?Message Key
     C                   Parm                    SndClr            1            ?Send or Clear

      *? Call Msg processing CL                           ?

     C                   CALL      'XAMSFC'      MessageParm                    ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C                   Time                    Now

     C                   If        $User() = 'BILLB'
     C                   Eval      *In99 = *On
     C                   EndIf

    ?C                   ExSr      Load02
     C                   Eval      RdyDate7 = $Date7($Monday($Date(0):'SAT'))
TEMP C*                  Eval      RdyDate7 = 1060116
     C                   Eval      SelRdyDate= $MDYDate($Monday($Date(0):'SAT'))
TEMP C*                  Eval      SelRdyDate= 011606
     C                   Eval      *In83 = *Off

    ?C     LotKey        KList
    ?C                   KFld                    ITEM                           ?Item
    ?C                   KFld                    SIZE                           ?Size
    ?C                   KFld                    DftWHSE                        ?Default Location
    ?C                   KFld                    SOSOWD                         ?Sow Date
    ?C                   KFld                    RdyDate                        ?Ready Date

    ?C*    LotRdKey      KList
    ?C*                  KFld                    ITEM                           ?Item
    ?C*                  KFld                    SIZE                           ?Size
    ?C*                  KFld                    DftWHSE                        ?Default Location
    ?C*                  KFld                    SOSOWD                         ?Sow Date
    ?C*                  KFld                    RdyDate                        ?Ready Date
    ?C*                  KFld                    ZeroCUST                       ?Customer Zero

    ?C                   EndSr                                                  ?
