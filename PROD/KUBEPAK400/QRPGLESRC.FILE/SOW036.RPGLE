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
      *? :  40      ?Lookup Indicator                                ?:
      *? :  50      ?Error Indicator (All Errors)                    ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
     FSOW036FM  CF   E             WORKSTN
     F                                     SFILE(SOW03601:RRN01)
     F                                     DEVID(WSID)

     FFMINVT    IF   E           K DISK                                         ?Item Master
     FFIORDRS@S IF   E           K DISK                                         ?Orders
     FFSOWSCHS@SIF   E           K DISK                                         ?Sow Jobs
     FFTRAYSS@S IF   E           K DISK                                         ?Recip Trays
     FFTRAYRS@S IF   E           K DISK                                         ?Stand. Trays
     FFTRAYFIXEDIF   E           K DISK                                         ?Fixed Trays
     FFLOSSD    IF   E           K DISK                                         ?Tray Losses
     FFPARTIAL  IF   E           K DISK                                         ?Partial Trays

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
     D  SowDate                            Like(TRSCYM)                         ?Sow_Date
     D  SowDate@                      7A                                        ?Sow_Date
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
     D   ErrorCount    S              3S 0 Inz(0)                               ?Error Count
     D   ErrorCount01  S              3S 0 Inz(0)                               ?Error Count
     D   ErrorCount02  S              3S 0 Inz(0)                               ?Error Count
     D   ErrorCount03  S              3S 0 Inz(0)                               ?Error Count
     D   RecordCount   S              5S 0 INZ(0)
     D   SowDate7      S                   Like(TRSCYM)                         ?Sow Date 7
     D   RdyDate7      S                   Like(TRCRDT)                         ?Ready Date 7
     D   Today         S              6S 0                                      ?Todays Date MDY
     D   Now           S              6S 0                                      ?The Time at *Init
     D   ChainRRN01    S              4S 0 Inz(*Zero)                           ?Key by RRN
     D   ChainRRN02    S              4S 0 Inz(*Zero)                           ?Key by RRN
     D   Printer       S             10A   Inz('*LAST')                         ?Printer
     D   Program       S             10A                                        ?Program
     D   FileName      S             10A                                        ?File Name for Label
     D   SowD          S               D                                        ?Sow Date
     D   SAVITEM       S                   Like(SELITEM)                        ?ITEM
     D   SAVSIZE       S                   Like(SELSIZE)                        ?SIZE
     D   LoopITEM      S                   Like(SELITEM)                        ?ITEM
     D   LoopSIZE      S                   Like(SELSIZE)                        ?SIZE
     D   SAVLOOK       S                   Like(SELLOOK)                        ?LOOK
     D   SAVSOWDATE    S                   Like(SOWDATE)                        ?Sow Date

      *? Indicators
     D   Done01        S               N
     D   Done02        S               N
     D   Done03        S               N
     D   EndOfFile     S               N
     D   OutOfKeys     S               N

      /Free
    ?   /COPY QFunctDefn,LASTUSEDCB
      /End-Free
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
    ?C                   ExFmt     SOW03600                                     ?
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
    ?C                   Write     SOW03601F                                   ?
     C                   If        ErrorCount01 <> *Zero                        ?Error Count
    ?C                   Write     MSGCTL                                       ?
     C                   EndIf
     C                   If        StartRRN01 = *Zero                           ?Error Count
     C                   Eval      StartRRN01 = 1
     C                   EndIf
    ?C                   ExFmt     SOW03601C                                    ?
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
    ?C                   ExFmt     SOW03602                                     ?
    ?C                   ExSr      ClrError                                     ?
     C                   Eval      ErrorCount02 = *Zero                         ?Error Count
    ?C                   EndSr                                                  ?

      *?  ............................................................
      *?  :      LowKeys01 - Find the lowest key value for all Files :
      *?  :..........................................................:
    ?C     LowKeys01     BegSr                                                  ?

    ?C     SowItmSiz     SetGT     FIORDRS@S
    ?C     SowItmSiz     SetGT     FSOWSCHS@S
    ?C     SowItmSiz     SetGT     FTRAYSS@S
    ?C     SowItmSiz     SetGT     FTRAYRS@S

     C                   Reset                   IMLOOKLow
     C                   Reset                   IMITEMLow
     C                   Reset                   IMSIZELow

    ?C     SowItmSiz     KList
    ?C                   KFld                    SowDate
    ?C                   KFld                    IMLOOK
    ?C                   KFld                    IMITEM
    ?C                   KFld                    IMSIZE

    ?C     ItemKey       KList
    ?C                   KFld                    IMITEM
    ?C                   KFld                    IMSIZE

     C                   Eval      OrderKey = *HiVal
    ?C     SowDate       ReadE     FIORDRS@S
     C                   If        OrderKey < LowKey01 and not %EOF(FIORDRS@S)
     C                   Eval      LowKey01 = OrderKey
     C                   EndIf

     C                   Eval      SowJobKey = *HiVal
    ?C     SowDate       ReadE     FSOWSCHS@S
     C                   If        SowJobKey < LowKey01 and not %EOF(FSOWSCHS@S)
     C                   Eval      LowKey01 = SowJobKey
     C                   EndIf

     C                   Eval      TrayKey = *HiVal
    ?C     SowDate       ReadE     FTRAYSS@S
     C                   If        TrayKey < LowKey01 and not %EOF(FTRAYSS@S)
     C                   Eval      LowKey01 = TrayKey
     C                   EndIf

     C                   Eval      TrayKey = *HiVal
    ?C     SowDate       ReadE     FTRAYRS@S
     C                   If        TrayKey < LowKey01 and not %EOF(FTRAYRS@S)
     C                   Eval      LowKey01 = TrayKey
     C                   EndIf

     C                   If        %EOF(FIORDRS@S) and
     C                             %EOF(FSOWSCHS@S) and
     C                             %EOF(FTRAYSS@S) and
     C                             %EOF(FTRAYRS@S)
     C                   Eval      OutOfKeys = *On
     C                   Else
     C                   Eval      IMITEM = IMITEMLow
     C                   Eval      IMSIZE = IMSIZELow

      *?  Check for program looping
     C                   If        IMITEM + IMSIZE = LoopITEM + LoopSIZE
     C                   Move      SowDate       SowDate@          7
     C                   Call      'SOW036F'
     C                   Parm                    SowDate@
     C                   EndIf
     C                   Eval      LoopITEM = IMITEM
     C                   Eval      LoopSIZE = IMSIZE
     C                   EndIf

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load00 - Load Screen 00                            :
      *?  :.........................................................:
    ?C     Load00        BegSr                                                  ?

     C                   Eval      SowDate7 = $Date7($Monday($Date(0):'SAT'))
     C                   Eval      SelSowDate= $MDYDate($Monday($Date(0):'SAT'))
     C                   Eval      *In83 = *Off

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

     C                   Eval      OutOfKeys = *Off
      *? Clear the Subfile
     C                   Eval      Option = *Blanks
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
     C                   Eval      *In81 = *Off
     C                   Eval      StartRRN01 = *Zero
    ?C                   Write     SOW03601C                                    ?

      *? Load the Subfile
     C                   Eval      SowDate  =
     C                             $Date7($Monday($DateMDY(SELSOWDATE):'SAT'))
     C                   Eval      SowD = $Date(SowDate)

     C                   Z-add     *Zero         RRN01                          ?

     C                   Eval      IMLOOK = *Blanks
     C                   Eval      IMITEM = *Blanks
     C                   Eval      IMSIZE = *Blanks

     C                   ExSr      LowKeys01

     C                   DoW       not OutOfKeys and RRN01 < 9999

      *? Load screen fields
    ?C     ItemKey       Chain     FMINVT
     C                   If        (SELSIZE = *Blanks or SELSIZE = IMSIZE) and
     C                             (SELITEM = *Blanks or SELITEM = IMITEM) and
     C                             (SELLOOK = *Blanks or
     C                              %SUBST(IMLOOK:1:%Len(%Trim(SelLOOK)))
     C                              = %Trim(SelLook))
    ?C                   Clear                   SOW03601
     C                   ExSr      GetOrders                                    ?On Orders
     C                   ExSr      GetJobSch                                    ?On Schedule
     C                   ExSr      GetTray                                      ?On Tray File
     C                   ExSr      GetTrayR                                     ?On Tray File "R"

      *?     Determine if record should be included...
     C                   If        ONORDERS <> 0 or
     C                             SOWJOBLB <> 0 or
     C                             SOWJOBSN <> 0 or
     C                             SOWJOBTS <> 0 or
     C                             TRAYSSN  <> 0 or
     C                             TRAYSLB  <> 0

      *?     Populate subfile fields
     C                   Eval      ITEM5 = IMITEM
     C                   Eval      Item  = IMITEM
     C                   Eval      SIZE  = IMSIZE
     C                   Eval      LOOK  = IMLOOK
     C                   Eval      DES1  = IMDES1

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
     C*                            or                               and CK11='Y'
     C*                            or                               and CK12='Y'
     C                   Eval      *In82 = *On
     C                   Else
     C                   Eval      *In82 = *Off
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

    ?C                   Write     SOW03601                                     ?
     C                   Eval      *In26 = *On                                  ?Have Data Indicator
     C                   Eval      *In81 = *Off                                  Position Cursor
     C                   EndIf
     C                   EndIf
     C                   EndIf

     C                   ExSr      LowKeys01

     C                   EndDo                                                  ?

     C                   IF        *In26 = *On                                  ?
    ?C     RRN01         Chain     SOW03601                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    SOW03601                                     ?
     C                   EndIF                                                  ?

     C                   Eval      SAVITEM = SELITEM
     C                   Eval      SAVSIZE = SELSIZE
     C                   Eval      SAVLOOK = SELLOOK
     C                   Eval      SAVSOWDATE = SELSOWDATE

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      GetOrders                                          :
      *?  :.........................................................:
    ?C     GetOrders     BegSr                                                  ?

     C*                  Eval      ONORDERS=$QtyOrder(IMITEM:IMSIZE:SOWD:'SOW') ?On Orders
    ?C     SowItmSiz     SetLL     FIORDRS@S
     C                   If        %EQUAL(FIORDRS@S)
    ?C     SowItmSiz     ReadE     FIORDRS@S
     C                   DoW       not %EOF(FIORDRS@S)
     C                   Eval      ONORDERS = ONORDERS + OIQORD
    ?C     SowItmSiz     ReadE     FIORDRS@S
     C                   EndDo
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      GetJobSch                                          :
      *?  :.........................................................:
    ?C     GetJobSch     BegSr                                                  ?

     C*                  Eval      SOWJOBLB=$QtyJobSch(IMITEM:IMSIZE:SOWD:'LB') ?Labelled
     C*                  Eval      SOWJOBSN=$QtyJobSch(IMITEM:IMSIZE:SOWD:'SN') ?Sown
     C*                  Eval      SOWJOBTS=$QtyJobSch(IMITEM:IMSIZE:SOWD:'TS') ?To Sow
    ?C     SowItmSiz     SetLL     FSOWSCHS@S
     C                   If        %EQUAL(FSOWSCHS@S)
    ?C     SowItmSiz     ReadE     FSOWSCHS@S
     C                   DoW       not %EOF(FSOWSCHS@S)
     C                   Eval      SOWJOBLB = SOWJOBLB + SOSOWL                 ?Labelled
     C                   Eval      SOWJOBSN = SOWJOBSN + SOSOWQ                 ?Sown
     C                   Eval      SOWJOBTS = SOWJOBTS + SOSOWT                 ?To Sow
    ?C     SowItmSiz     ReadE     FSOWSCHS@S
     C                   EndDo
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      GetTray                                            :
      *?  :.........................................................:
    ?C     GetTray       BegSr                                                  ?

     C*                  Eval      TRAYSSN =$QtyFTRAY(IMITEM:IMSIZE:SOWD)       ?Tray Count
    ?C     SowItmSiz     SetLL     FTRAYSS@S
     C                   If        %EQUAL(FTRAYSS@S)
    ?C     SowItmSiz     ReadE     FTRAYSS@S
     C                   DoW       not %EOF(FTRAYSS@S)
     C                   If        TRSTAT <> 'D'
     C                   Eval      TRAYSSN = TRAYSSN + 1                        ?Tray Count
     C                   ExSr      GetFixLoss
     C                   EndIf
    ?C     SowItmSiz     ReadE     FTRAYSS@S
     C                   EndDo
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      GetTrayR                                           :
      *?  :.........................................................:
    ?C     GetTrayR      BegSr                                                  ?

     C*                  Eval      TRAYSLB =$QtyFTRAYR(IMITEM:IMSIZE:SOWD)      ?Tray Count "R"
    ?C     SowItmSiz     SetLL     FTRAYRS@S
     C                   If        %EQUAL(FTRAYRS@S)
    ?C     SowItmSiz     ReadE     FTRAYRS@S
     C                   DoW       not %EOF(FTRAYRS@S)
     C                   If        TRSTAT <> 'D'
     C                   Eval      TRAYSLB = TRAYSLB + 1                        ?Tray Count "R"
     C                   ExSr      GetFixLoss
     C                   EndIf
    ?C     SowItmSiz     ReadE     FTRAYRS@S
     C                   EndDo
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?  .................................................................
      *?  :      GetFixLoss - Get Fixed, Loss, Partial & PartTrays Counts :
      *?  :...............................................................:
    ?C     GetFixLoss    BegSr                                                  ?

      *?   Fixed
    ?C     TRTAG#        SetLL     FTRAYFIXED
     C                   If        %EQUAL(FTRAYFIXED)
    ?C     TRTAG#        Chain     FTRAYFIXED
     C                   Eval      FIXED   = FIXED   + 1                        ?Tray Count Fixed
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

     C                   If        SOWJOBSN >= FIXED
     C                   Eval      AVAILABLE = SOWJOBSN -
     C                             ONORDERS -  LOSSES
     C                   Else
     C                   Eval      AVAILABLE = FIXED    -
     C                             ONORDERS -  LOSSES
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load02 - Load Screen 00                            :
      *?  :.........................................................:
    ?C     Load02        BegSr                                                  ?

     C                   Eval      CK_array = 'YYYYYYNYYY'

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
    ?C                   When      SELSOWDATE = 0
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
    ?C                             SELSOWDATE <> SAVSOWDATE
     C                   Eval      SAVITEM = SELITEM
     C                   Eval      SAVSIZE = SELSIZE
     C                   Eval      SAVLOOK = SELLOOK
     C                   Eval      SAVSOWDATE = SELSOWDATE
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
     C                   Eval      CK_Array = 'YYYYYYYYYY'
    ?C                   ExSr      Scrn02
      *? Select No Errors
    ?C                   When         *In09
     C                   Eval      CK_Array = 'NNNNNNNNNN'
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

    ?C                   ReadC     SOW03601
     C                   DoW       not %EOF(SOW036FM)
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
     C                   Call      'SOW038'
     C                   Parm                    SowDate
     C                   Parm                    ITEM
     C                   Parm                    SIZE
     C                   Eval      Option = *Blanks
     C                   Eval      *In28 = *Off                                 ?Subfile Next Change
      *? Option = '3'  (Tags Inquiry)
    ?C                   When         Option = '3'
     C                   Call      'SOW039'
     C                   Parm                    SowDate
     C                   Parm                    ITEM
     C                   Parm                    SIZE
     C                   Eval      Option = *Blanks
     C                   Eval      *In28 = *Off                                 ?Subfile Next Change
      *? Option = '4'  (Lot Loss Summary)
    ?C                   When         Option = '4'
     C                   Call      'FXG068'
     C                   Parm                    SowDate
     C                   Parm                    ITEM
     C                   Parm                    SIZE
     C                   Eval      Option = *Blanks
     C                   Eval      *In28 = *Off                                 ?Subfile Next Change
      *? Option = '5'  (Fix Job Schedule)
    ?C                   When         Option = '5'
     C                   Eval      SowDate@ = %Char(SowDate)
WHT  C                   Call      'SOW037'                                     |Recalc spec. lot
     C                   Parm                    SowDate@
     C                   Parm                    ITEM
     C                   Parm                    SIZE
     C                   Parm                    BlankJob#
     C                   Eval      Option = *Blanks
     C                   Eval      *In28 = *Off                                 ?Subfile Next Change
      *? Any Other Option is invalid
    ?C                   OTHER                                                  ?
     C                   Eval      MessageID = 'SOW0360'
     C                   Eval      MessageDta = Option
    ?C                   ExSr      SndError
     C                   Eval      ErrorCount01 = ErrorCount01 + 1              ?Error Count
     C                   Eval      *In50 = *On
     C                   Eval      *In28 = *On
    ?C                   ENDSL                                                  ?
    ?C                   Update    SOW03601
    ?C                   ReadC     SOW03601
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
     C                   Parm      'SOW036'      PgmQ             10            ?Pgm Msg Queue
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

    ?C                   ExSr      Load02
     C                   Eval      SowDate7 = $Date7($Monday($Date(0):'SAT'))
TEMP C*                  Eval      SowDate7 = 1060116
     C                   Eval      SelSowDate= $MDYDate($Monday($Date(0):'SAT'))
TEMP C*                  Eval      SelSowDate= 011606
     C                   Eval      *In83 = *Off

    ?C                   EndSr                                                  ?
