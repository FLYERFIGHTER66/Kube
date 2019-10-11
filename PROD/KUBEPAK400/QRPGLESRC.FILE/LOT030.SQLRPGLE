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
     FLOT020FM  CF   E             WORKSTN
     F                                     SFILE(LOT02001:RRN01)
     F                                     DEVID(WSID)

     FFMINVT    IF   E           K DISK                                         ?Item Master
     FFSOWSCHR@SIF   E           K DISK                                         ?Sow Jobs
     FFTRAYSR@S IF   E           K DISK                                         ?Recip Trays
     FFTRAYRR@S IF   E           K DISK                                         ?Stand. Trays
     FFTRAYFIXEDIF   E           K DISK                                         ?Fixed Trays
     FFLOSSD    IF   E           K DISK                                         ?Tray Losses
     FFPARTIAL  IF   E           K DISK                                         ?Partial Trays

      *? Function Prototypes
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$Duration
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
     D  TrayKey        DS
     D   TRALPH                                                                 ?Look
     D   TRITEM                                                                 ?ITEM
     D   TRSIZE                                                                 ?SIZE
     D  SowSch_DS      DS
     D   C1_ITEM                     12A                                        ??
     D   C1_SIZE                      3A                                        ??
     D   C1_SOWD                      7S 0                                      ??
     D   C1_RDYD                      7S 0                                      ??
     D   C1_LOOK                     15A                                        ??
     D   C1_CODE                     10A                                        ??
     D   C1_ORDQ                     15S 5                                      ??
     D   C1_SOWT                     15S 5                                      ??
     D   C1_SOWQ                     15S 5                                      ??

      *? Un-Sown Trays Data Structure
     D  FTRAY_DS       DS                  INZ
     D  RdyDate@                      7A                                        ?Rdy_Date
     D  ReadyDate                          Like(TRCRDT)                         ?Ready_Date
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
     D   Today         S              6S 0                                      ?Todays Date MDY
     D   Now           S              6S 0                                      ?The Time at *Init
     D   ChainRRN01    S              4S 0 Inz(*Zero)                           ?Key by RRN
     D   ChainRRN02    S              4S 0 Inz(*Zero)                           ?Key by RRN
     D   Printer       S             10A   Inz('*LAST')                         ?Printer
     D   Program       S             10A                                        ?Program
     D   FileName      S             10A                                        ?File Name for Label
     D   LastFixd      S               D                                        ?Date Last Fixed
     D   LastFixd6     S              6S 0                                      ?Date Last Fixed
     D   SAVITEM       S                   Like(SELITEM)                        ?ITEM
     D   SAVSIZE       S                   Like(SELSIZE)                        ?SIZE
     D   SAVLOOK       S                   Like(SELLOOK)                        ?LOOK
     D   SELLOOK2      S                   Like(SELLOOK)                        ?LOOK
     D   SAVMINGERM    S                   Like(MINGERM)                        ?Min. Germ Rate
     D   SAVSERIES     S                   Like(SELSERIES)                      ?Selected Series
     D   SAVWORD       S                   Like(SELWORD  )                      ?Selected Word
     D   SELSERIES2    S                   Like(SELSERIES)                      ?Selected Series
     D   SELWORD2      S                   Like(SELWORD)                        ?Selected Word
     D   SELRdyDtFm    S              7S 0                                      ?Rdy Date From
     D   SELRdyDtTo    S              7S 0                                      ?Rdy Date To
     D   SELSowDtFm    S              7S 0                                      ?Sow Date From
     D   SELSowDtTo    S              7S 0                                      ?Sow Date To
     D   SAVRdyDtFm    S                   Like(SELRdyDtFm)                     ?Rdy Date From
     D   SAVRdyDtTo    S                   Like(SELRdyDtTo)                     ?Rdy Date To
     D   SAVSowDtFm    S                   Like(SELSowDtFm)                     ?Sow Date From
     D   SAVSowDtTo    S                   Like(SELSowDtTo)                     ?Sow Date To
     D   SOSOWDSav     S                   Like(SOSOWD)                         ?Sow Date Save
     D   TRAYSLB       S              6S 0                                      ?TRAYS COUNT
     D   TRAYSSN       S              6S 0                                      ?TRAYS COUNT
     D   ISCODE        S             10A                                        ?Series Code
     D   PartUsed      S                   Like(PartTrays)                      ?Series Code

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
    ?C                   ExFmt     LOT02000                                     ?
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
    ?C                   Write     LOT02001F                                   ?
     C                   If        ErrorCount01 <> *Zero                        ?Error Count
    ?C                   Write     MSGCTL                                       ?
     C                   EndIf
     C                   If        StartRRN01 = *Zero
     C                   Eval      StartRRN01 = 1
     C                   EndIf
    ?C                   ExFmt     LOT02001C                                    ?
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
    ?C                   ExFmt     LOT02002                                     ?
    ?C                   ExSr      ClrError                                     ?
     C                   Eval      ErrorCount02 = *Zero                         ?Error Count
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load00 - Load Screen 00                            :
      *?  :.........................................................:
    ?C     Load00        BegSr                                                  ?

     C                   Eval      *In83 = *Off

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      ScrDates - Convert Screen Dates                    :
      *?  :.........................................................:
    ?C     ScrDates      BegSr                                                  ?

     C                   If        SCRRDYDTFM <> 0
     C                   Eval      SELRDYDTFM =
     C                             $Date7($Monday($DateMDY(SCRRDYDTFM):'SAT'))
     C                   EndIf

     C                   If        SCRRDYDTTO <> 0
     C                   Eval      SELRDYDTTO =
     C                             $Date7($Monday($DateMDY(SCRRDYDTTO):'SAT'))
     C                   EndIf

     C                   If        SCRSOWDTFM <> 0
     C                   Eval      SELSOWDTFM =
     C                             $Date7($Monday($DateMDY(SCRSOWDTFM):'SAT'))
     C                   EndIf

     C                   If        SCRSOWDTTO <> 0
     C                   Eval      SELSOWDTTO =
     C                             $Date7($Monday($DateMDY(SCRSOWDTTO):'SAT'))
     C                   EndIf

     C                   If        SELLOOK <> *Blanks
     C                   Eval      SELLOOK2 = %Trim(SELLOOK) + '%'
     C                   Else
     C                   Eval      SELLOOK2 = *Blanks
     C                   EndIf

     C                   If        SELSERIES <> *Blanks
     C                   Eval      SELSERIES2 = %Trim(SELSERIES) + '%'
     C                   Else
     C                   Eval      SELSERIES2 = *Blanks
     C                   EndIf
     C                   If        SELWORD   <> *Blanks
     C                   Eval      SELWORD2   = '%' + %Trim(SELWORD  ) + '%'
     C                   Else
     C                   Eval      SELWORD2 = *Blanks
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

     C                   Eval      Step01 = 18 * ( 1 )
     C                   Eval      EndOfFile = *Off
      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
     C                   Eval      *In81 = *Off
     C                   Eval      StartRRN01 = *Zero
    ?C                   Write     LOT02001C                                    ?

      *? Load the Subfile

     C                   ExSr      OpenData

     C                   Z-add     *Zero         RRN01                          ?

     C                   Eval      StopRRN01 = Step01

     C                   If        *In83
     C                   Eval      StopRRN01 = 9999
     C                   EndIf

     C                   ExSr      ReadData
     C                   DoW       not EndOfFile and RRN01 < StopRRN01
      *? Load screen fields
     C                   ExSr      Load01Fld
     C                   ExSr      ReadData

     C                   EndDo                                                  ?

     C                   IF        *In26 = *On and EndOfFile                    ?
    ?C     RRN01         Chain     LOT02001                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    LOT02001                                     ?
     C                   EndIF                                                  ?

     C                   Eval      SAVITEM = SELITEM
     C                   Eval      SAVSIZE = SELSIZE
     C                   Eval      SAVLOOK = SELLOOK
     C                   Eval      SAVRdyDtFm = SELRdyDtFm
     C                   Eval      SAVRdyDtTo = SELRdyDtTo
     C                   Eval      SAVSowDtFm = SELSowDtFm
     C                   Eval      SAVSowDtTo = SELSowDtTo
     C                   Eval      SAVMinGerm = MinGerm
     C                   Eval      SAVSeries  = SELSeries
     C                   Eval      SAVWord    = SELWord

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      More01 - Load Screen 01 w/ More records            :
      *?  :.........................................................:
    ?C     More01        BegSr                                                  ?

     C                   If        not EndOfFile

     C                   Eval      StartRRN01= RRN01 + 1
     C                   Eval      StopRRN01 = RRN01 + Step01

     C                   DoW       not EndOfFile and RRN01 < StopRRN01
      *? Load screen fields
     C                   ExSr      ReadData
     C                   ExSr      Load01Fld

     C                   EndDo                                                  ?

     C                   IF        *In26 = *On and EndOfFile                    ?
    ?C     RRN01         Chain     LOT02001                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    LOT02001                                     ?
     C                   EndIF                                                  ?

     C                   Eval      SAVITEM = SELITEM
     C                   Eval      SAVSIZE = SELSIZE
     C                   Eval      SAVLOOK = SELLOOK
     C                   Eval      SAVRdyDtFm = SELRdyDtFm
     C                   Eval      SAVRdyDtTo = SELRdyDtTo
     C                   Eval      SAVSowDtFm = SELSowDtFm
     C                   Eval      SAVSowDtTo = SELSowDtTo
     C                   Eval      SAVMinGerm = MinGerm
     C                   Eval      SAVSeries  = SELSeries
     C                   Eval      SAVWord    = SELWord

     C                   EndIf                                                  ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load01Fld - Load Screen 01 Fields                  :
      *?  :.........................................................:
    ?C     Load01Fld     BegSr                                                  ?

      *? Load screen fields
    ?C     ItemKey       Chain     FMINVT
    ?C     ItemKey       KList                                                  ?
    ?C                   KFld                    SOITEM
    ?C                   KFld                    SOSIZE

     C                   If        %Found(FMINVT)
    ?C                   Clear                   LOT02001
     C                   ExSr      GetTray                                      ?On Tray File
     C                   ExSr      GetTrayR                                     ?On Tray File "R"

      *?     Populate subfile fields
     C                   Eval      Item4 = IMITEM
     C                   Eval      Item  = IMITEM
     C                   Eval      SIZE  = IMSIZE
     C                   Eval      LOOK  = IMLOOK
     C                   Eval      CODE  = ISCODE
     C                   Eval      DES1  = IMDES1
     C                   Eval      QtyOrdered  = SOORDQ
     C                   Eval      QtyToSow    = SOSOWT
     C                   Eval      QtySown     = SOSOWQ
     C                   Eval      SowDate = $MDYDate($Date(SOSOWD))
     C                   Eval      RdyDate = $MDYDate($Date(SORDYD))
     C                   Eval      GERM=0

     C                   If        QTYSOWN <> 0
     C                   Eval      OVERSOW=(1-((QTYSOWN-OTHERLOSS)/QTYSOWN))*100

     C                   If        FIXED > 0                                    ?FIXED = Scanned In
     C                   Eval      PartUsed = PARTCOUNT - PARTTRAYS
     C                   Eval      GERM=
     C                             ((QTYSOWN-FIXERS-PartUsed)/QTYSOWN)*100
     C                   EndIf

     C                   EndIf

     C                   If        GERM < MINGERM
     C                   Eval      *In51 = *On
     C                   Else
     C                   Eval      *In51 = *Off
     C                   EndIf

     C                   If        LASTFIXD6 <> 10100
     C                   Eval      SOWTOFIX = $Duration($DateMDY(SOWDATE):
     C                                                  $DateMDY(LASTFIXD6):'D')
     C                   Eval      FIXTORDY = $Duration($DateMDY(LASTFIXD6):
     C                                                  $DateMDY(RDYDATE):'D')
     C                   EndIf

      *? Write Subfile Record
     C                   If        1=1                                               Check Series he
     C                   Add       1             RRN01                          ?

      *?     Check to see if this is the starting screen
     C                   If        StartRRN01 = 0
     C                   Eval      *In81 = *On                                   Position Cursor
     C                   Eval      StartRRN01 = RRN01
     C                   EndIf

    ?C                   Write     LOT02001                                     ?
     C                   Eval      *In26 = *On                                  ?Have Data Indicator
     C                   Eval      *In81 = *Off                                  Position Cursor
     C                   EndIf
     C                   Else
     C                   Eval      ItemMast_NG = *On
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      GetTray                                            :
      *?  :.........................................................:
    ?C     GetTray       BegSr                                                  ?

     C                   Eval      LastFixd = $date(20000101)
    ?C     SowItmSiz     SetLL     FTRAYSR@S
    ?C     SowItmSiz     KList                                                  ?
    ?C                   KFld                    SORDYD                         ?
    ?C                   KFld                    SOLOOK                         ?
    ?C                   KFld                    SOITEM                         ?
    ?C                   KFld                    SOSIZE                         ?
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

    ?C                   ExSr      ScrDates

      *? Process pre-edit Functions F3, F6, F7 & F9
    ?C                   SELECT                                                 ?
      *? Cancel Requested
    ?C                   When         *In03
    ?C                             or *In07
     C                   MOVE      *ON           *INLR                          ?
      *? Item Lookup Requested
    ?C                   When         *In04
    ?C                   Call      'LKITAL'
    ?C     SELLOOK       Parm      SELLOOK       IMLOOK
    ?C     SELITEM       Parm                    IMITEM
    ?C     SELSIZE       Parm                    IMSIZE
    ?C                   Parm                    IMWHSE
    ?C                   Parm                    IMDES1
    ?C                   Parm                    IMDES2
    ?C                   Parm                    IMDES3
    ?C                   Parm                    IMDES4
    ?C                   Parm                    SHPFR             3
    ?C                   ExSr      Scrn00
      *? Refresh Requested
    ?C                   When         *In05
    ?C                   ExSr      Load00
    ?C                   ExSr      Scrn00
      *? Lookup Series Code Requested
    ?C                   When         %SubSt(SELSERIES:1:1)='?'
     C                   Eval      SELSERIES2 = %SubSt(SELSERIES:2:9) + ' '
    ?C                   Call      'LKSERI'
     C                   Parm      SELSERIES2    SeriesDesc       30
     C                   Parm                    SELSERIES
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

    ?C                   ExSr      ScrDates

      *? Process pre-edit Functions F3, F6, F7 & F9
    ?C                   SELECT                                                 ?
      *? Cancel Requested
    ?C                   When         *In03
    ?C                             or *In07
     C                   ExSr      CloseData
     C                   MOVE      *ON           *INLR                          ?
      *? RollDown Requested
    ?C                   When         *In40 and not EndOfFile
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
    ?C                   ExSr      CloseData
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? Restart Requested
    ?C                   When         *In06
    ?C                   ExSr      Scrn00
      *? Item Lookup Requested
    ?C                   When         *In04
     C                   If        SELLOOK = *Blanks
     C                   Eval      MessageID = 'ITM0004'
     C                   Eval      MessageDta = *Blanks
    ?C                   ExSr      SndError
    ?C                   ExSr      Scrn01
     C                   Else
    ?C                   Call      'LKITAL'
    ?C     SELLOOK       Parm      SELLOOK       IMLOOK
    ?C     SELITEM       Parm                    IMITEM
    ?C     SELSIZE       Parm                    IMSIZE
    ?C                   Parm                    IMWHSE
    ?C                   Parm                    IMDES1
    ?C                   Parm                    IMDES2
    ?C                   Parm                    IMDES3
    ?C                   Parm                    IMDES4
    ?C                   Parm                    SHPFR             3
    ?C                   ExSr      CloseData
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
     C                   EndIf
      *? Lookup Series Code Requested
    ?C                   When         %SubSt(SELSERIES:1:1)='?'
     C                   Eval      SELSERIES2 = %SubSt(SELSERIES:2:9) + ' '
    ?C                   Call      'LKSERI'
     C                   Parm      SELSERIES2    SeriesDesc       30
     C                   Parm                    SELSERIES
    ?C                   ExSr      Scrn01
      *? Selection Changed
    ?C                   When      SELITEM    <> SAVITEM      or
    ?C                             SELSIZE    <> SAVSIZE      or
    ?C                             SELLOOK    <> SAVLOOK      or
    ?C                             SELRdyDtFm <> SAVRdyDtFm   or
    ?C                             SELRdyDtTo <> SAVRdyDtTo   or
    ?C                             SELSowDtFm <> SAVSowDtFm   or
    ?C                             SELSowDtTo <> SAVSowDtTo   or
    ?C                             MinGerm    <> SAVMinGerm   or
    ?C                             SELSeries  <> SAVSeries    or
    ?C                             SELWord    <> SAVWord
     C                   Eval      SAVITEM    =  SELITEM
     C                   Eval      SAVSIZE    =  SELSIZE
     C                   Eval      SAVLOOK    =  SELLOOK
     C                   Eval      SAVRdyDtFm =  SELRdyDtFm
     C                   Eval      SAVRdyDtTo =  SELRdyDtTo
     C                   Eval      SAVSowDtFm =  SELSowDtFm
     C                   Eval      SAVSowDtTo =  SELSowDtTo
     C                   Eval      SAVMinGerm =  MinGerm
     C                   Eval      SAVSeries  =  SELSeries
     C                   Eval      SAVWord    =  SELWord
     C                   ExSr      CloseData
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? If no Functions, Check for Options.  ( no options this pgm )
    ?C                   OTHER                                                  ?
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
     C                   Parm      'LOT020'      PgmQ             10            ?Pgm Msg Queue
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
      *?  :      OpenData - Open Data Source                        :
      *?  :.........................................................:
    ?C     OpenData      BegSr                                                  ?

    ?c/exec sql
    ?c+
    ?c+    DECLARE  C1 cursor for
    ?c+
    ?c+    select   SOITEM
    ?c+         ,   SOSIZE
    ?c+         ,   SOSOWD
    ?c+         ,   SORDYD
    ?c+         ,   SOLOOK
    ?c+         ,   ISCODE
    ?c+         ,   sum(SOORDQ)
    ?c+         ,   sum(SOSOWT)
    ?c+         ,   sum(SOSOWQ)
    ?c+    from     FSOWSCH, FMINSER, FMINVT
    ?c+    where    (SOITEM  =     ISITEM )
    ?c+      and    (SOITEM  =     IMITEM )
    ?c+      and    (SOSIZE  =     IMSIZE )
    ?c+      and    (SOITEM  =     :SELITEM     or :SELITEM     =  '' )
    ?c+      and    (SOSIZE  =     :SELSIZE     or :SELSIZE     =  '' )
    ?c+      and    (SOSOWD  >=    :SELSOWDTFM  or :SELSOWDTFM  =  0  )
    ?c+      and    (SOSOWD  <=    :SELSOWDTTO  or :SELSOWDTTO  =  0  )
    ?c+      and    (SORDYD  >=    :SELRDYDTFM  or :SELRDYDTFM  =  0  )
    ?c+      and    (SORDYD  <=    :SELRDYDTTO  or :SELRDYDTTO  =  0  )
    ?c+      and    (SOLOOK  like  trim(:SELLOOK2)    or :SELLOOK2    =  '' )
    ?c+      and    (ISCODE  like  trim(:SELSERIES2)  or :SELSERIES2  =  '' )
    ?c+      and    (IMDES1  like  trim(:SELWORD2)    or :SELWORD2    =  '' )
    ?c+    GROUP BY SOLOOK, SOSOWD, SORDYD, SOITEM, SOSIZE, ISCODE
    ?c+    ORDER BY SOLOOK, SOSOWD, SORDYD, SOITEM, SOSIZE, ISCODE
    ?c+
    ?c+    For Read only
    ?c+
    ?c/end-exec

     ?*  Open the SQL recordset
    ?c/exec sql
    ?c+                  Open      C1
    ?c/end-exec

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ReadData - Read Data                               :
      *?  :.........................................................:

     C     ReadData      BegSr

     ?*  Read Sow Schedule Records
    ?c/exec sql
    ?c+ Fetch C1 into :SowSch_DS
    ?c/end-exec

     C                   If        SQLSTT = '02000'                             ?Read until EOF
     C                   Eval      EndOfFile = *On
     C                   Else
     C                   Eval      EndOfFile = *Off
     C                   Eval      SOITEM      = C1_ITEM
     C                   Eval      SOSIZE      = C1_SIZE
     C                   Eval      SOLOOK      = C1_LOOK
     C                   Eval      SOSOWD      = C1_SOWD
     C                   Eval      SORDYD      = C1_RDYD
     C                   Eval      SOORDQ      = C1_ORDQ
     C                   Eval      SOSOWT      = C1_SOWT
     C                   Eval      SOSOWQ      = C1_SOWQ
     C                   Eval      ISCODE      = C1_CODE
     C                   EndIf

     C                   EndSr

      *?  ...........................................................
      *?  :      CloseDate - Close the Data Set                     :
      *?  :.........................................................:

     C     CloseData     BegSr

     ?*  Close the SQL recordset
    ?c/exec sql
    ?c+ Close C1
    ?c/end-exec

     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C                   Time                    Now

     C                   If        $User() = 'BILLB'
     C                   Eval      *In99 = *On
     C                   EndIf

    ?C                   ExSr      Load02
     C                   Eval      *In83 = *Off
     C                   Eval      MINGERM = 80



    ?C                   EndSr                                                  ?
