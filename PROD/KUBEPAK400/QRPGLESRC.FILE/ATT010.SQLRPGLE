    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Attendance Master Inquiry                          :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  July 2006            ? Kube-Pak Corporation ?    :
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
     FATT010FM  CF   E             WORKSTN
     F                                     SFILE(ATT01001:RRN01)
     F                                     DEVID(WSID)

     FFMATTEND  IF   E           K DISK                                         ?Attendance Master
     FFMEMPLOY  IF   E           K DISK                                         ?Employee Master
     FXATABL    IF   E           K DISK                                         ?Table File

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$Duration
    ?D/COPY QFunctDefn,$PrtUsrLab
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,QCmdExc
    ?D/COPY QFunctDefn,$MONDAY

     D  Attendance     DS
     D   C1_DATE                           Like(ATDATE)                         ?Date Worked
     D   C1_CARD                           Like(ATCARD)                         ?TimeCard#
     D   C1_LAST                           Like(EMLAST)                         ?LAst Name
     D   C1_FIRS                           Like(EMFIRS)                         ?First Name
     D   C1_NAME                     25A                                        ?Employee Name
     D   C1_TYPE                           Like(ATTYPE)                         ?Labor Type
     D   C1_STRT                           Like(ATSTRT)                         ?Start Time
     D   C1_ENDT                           Like(ATENDT)                         ?End Time
     D   C1_MINT                     15S 5                                      ?Minutes Worked
     D   C1_TRAZ                           Like(ATTRAZ)                         ?Trays Produced
     D   C1_TIME                           Like(ATTIME)                         ?Att Timestamp
     D   C1_FILE                           Like(EMFILE)                         ?File Number

      *? Field Definitions
     D   User          S             10A                                        ?Current User ID
     D   Today         S              6S 0                                      ?Todays Date MDY
     D   Now           S                   Like(ATENDT)                         ?Current Time
     D   Program       S             10A                                        ?Program
     D   FileName      S             10A                                        ?File Name for Label

     D   RRN01         S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   StopRRN01     S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   Step01        S              4  0 Inz(0)                               ?SFLRRN 01 Increment
     D   ErrorCount    S              3S 0 Inz(0)                               ?Error Count
     D   ErrorCount01  S              3S 0 Inz(0)                               ?Error Count
     D   RecordCount   S              5S 0 INZ(0)
     D   ChainRRN01    S              4S 0 Inz(*Zero)                           ?Key by RRN

     D   SELWRKDTFM    S                   Like(ATDATE)
     D   SELWRKDTTO    S                   Like(ATDATE)

     D   SAVWrkDtFm    S                   Like(SELWRKDTFM)                     ?From Work Date
     D   SAVWrkDtTo    S                   Like(SELWRKDTTO)                     ?To Work Date
     D   SAVLast       S                   Like(SELLAST)                        ?Last Name
     D   SAVFirst      S                   Like(SELFIRST)                       ?First Name
     D   SAVName       S                   Like(SELNAME)                        ?Employee Name
     D   SAVType       S                   Like(SELTYPE)                        ?Labor Type
     D   SAVGroup      S                   Like(SELGROUP)                       ?Labor Type

     D   SELLast2      S                   Like(SELLAST)                        ?Last Name
     D   SELFirst2     S                   Like(SELFIRST)                       ?First Name
     D   SELName2      S                   Like(SELNAME)                        ?Employee Name

     D   PrtLabel#     S              8S 0                                      ?Card # for Label
     D   PrtQty        S              3S 0                                      ?Qty to Print
     D   JobCode       S                   Like(TBTBCD)                         ?Job Code
     D   Seconds       S             15S 0                                      ?Seconds Worked

      *? Indicators
     D   EndOfFile     S               N
     D   In31          S               N

    ?C                   ExSr      ClrError                                     ?
    ?C                   ExSr      Scrn00                                       ?

     C     *INLR         DOUEQ     *ON                                          ?COMMENT

    ?C                   SELECT                                                 ?
    ?C     Screen        WhenEq    0                                            ?
    ?C                   ExSr      Edit00                                       ?
    ?C     Screen        WhenEq    1                                            ?
    ?C                   ExSr      Edit01                                       ?
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
    ?C                   ExFmt     ATT01000                                     ?
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
    ?C                   Write     ATT01001F                                   ?
     C                   If        ErrorCount01 <> *Zero                        ?Error Count
    ?C                   Write     MSGCTL                                       ?
     C                   EndIf
     C                   If        StartRRN01 = *Zero
     C                   Eval      StartRRN01 = 1
     C                   EndIf
    ?C                   ExFmt     ATT01001C                                    ?
    ?C                   ExSr      ClrError                                     ?
     C                   Eval      ErrorCount01 = *Zero                         ?Error Count
     C                   Eval      *In25 = *Off                                 ?
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

     C                   If        SCRWRKDTFM <> 0
     C                   Eval      SELWRKDTFM = $DateMDY(SCRWRKDTFM)
     C                   EndIf

     C                   If        SCRWRKDTTO <> 0
     C                   Eval      SELWRKDTTO = $DateMDY(SCRWRKDTTO)
     C                   EndIf

     C                   If        SELLAST <> *Blanks
     C                   Eval      SELLAST2 = %Trim(SELLAST) + '%'
     C                   Else
     C                   Eval      SELLAST2 = *Blanks
     C                   EndIf

     C                   If        SELFIRST  <> *Blanks
     C                   Eval      SELFIRST2 = %Trim(SELFIRST) + '%'
     C                   Else
     C                   Eval      SELFIRST2 = *Blanks
     C                   EndIf

     C                   If        SELNAME <> *Blanks
     C                   Eval      SELNAME2 = '%' + %Trim(SELNAME) + '%'
     C                   Else
     C                   Eval      SELNAME2 = *Blanks
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

     C                   Eval      Step01 = 18 * ( 1 )
     C                   Eval      EndOfFile = *Off
     C                   Eval      TotalTrays = *Zero
      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
     C                   Eval      *In81 = *Off
     C                   Eval      StartRRN01 = *Zero
    ?C                   Write     ATT01001C                                    ?

      *? Load the Subfile

     C                   ExSr      OpenData

     C                   Z-add     *Zero         RRN01                          ?

     C                   Eval      StopRRN01 = Step01

      *? Get the Data
     C                   ExSr      ReadData
     C                   DoW       not EndOfFile and RRN01 < StopRRN01
     C                   ExSr      Load01Fld
     C                   ExSr      ReadData
     C                   EndDo                                                  ?

     C                   IF        *In26 = *On and EndOfFile                    ?
    ?C     RRN01         Chain     ATT01001                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    ATT01001                                     ?
     C                   EndIF                                                  ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      More01 - Load Screen 01 w/ More records            :
      *?  :.........................................................:
    ?C     More01        BegSr                                                  ?

     C                   If        not EndOfFile

     C                   Eval      StartRRN01= RRN01 + 1
     C                   Eval      StopRRN01 = RRN01 + Step01

      *? Get Data
     C                   ExSr      ReadData
     C                   DoW       not EndOfFile and RRN01 < StopRRN01
     C                   ExSr      Load01Fld
     C                   ExSr      ReadData
     C                   EndDo                                                  ?

     C                   IF        EndOfFile                                    ?
    ?C     RRN01         Chain     ATT01001                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    ATT01001                                     ?
     C                   EndIF                                                  ?
     C                   EndIf                                                  ?

     C                   If        RRN01 < StartRRN01
     C                   Eval      StartRRN01 = StartRRN01 - Step01
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load01Fld - Load Screen 01 Fields                  :
      *?  :.........................................................:
    ?C     Load01Fld     BegSr                                                  ?

      *? Load screen fields

      *?     Populate subfile fields
     C*                  Put SFL record calulations here

     C                   Eval      *In81 = *Off                                  Position Cursor
      *?     Check to see if this is the starting screen
     C                   If        StartRRN01 = 0
     C                   Eval      *In81 = *On                                   Position Cursor
     C                   Eval      StartRRN01 = RRN01
     C                   EndIf

      *?  :````````````````````````````````````````````````````````````:
      *?  :              Load SFL Fields here ! ! !                    :
      *?  :............................................................:
      *?     Load Job Type
     C                   Eval      JobCode  = 'JC' + ATTYPE
    ?C     JobCode       Chain     XATABL
     C                   If        %Found(XATABL)
     C                   Eval      JobType = TBSHRT
     C                   Else
     C                   Eval      JobType = *Blanks
     C                   EndIf
      *?     Load Time Worked
     C                   Clear                   TimeWorked
     C                   If        ATENDT <> ATSTRT
     C     ATENDT        SubDur    ATSTRT        Seconds:*S
     C                   Eval      *In30 = *Off
     C                   Else
     C                   Time                    Now
     C     Now           SubDur    ATSTRT        Seconds:*S
     C                   Reset                   ATENDT
     C                   Eval      *In30 = *On
     C                   EndIf
     C                   AddDur    Seconds:*S    TimeWorked
      *?     Load Trays per Hour
     C                   If        Seconds > 0
     C                   If        (ATTRAZ*3600)/Seconds < 999
     C                   Eval      TrayPHr = (ATTRAZ*3600)/Seconds
     C                   Else
     C                   Eval      TrayPHr = 999.99
     C                   EndIf
     C                   Else
     C                   Eval      TrayPHr = *Zero
     C                   EndIf

      *? Write Subfile Record
     C                   Add       1             RRN01                          ?
    ?C                   Write     ATT01001                                     ?
     C                   Eval      *In26 = *On                                  ?Have Data Indicator
     C                   Eval      *In81 = *Off                                  Position Cursor

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
      *? Refresh Requested
    ?C                   When         *In05
    ?C                   ExSr      Load00
    ?C                   ExSr      Scrn00
      *? Lookup Labor Type Code Requested
    ?C                   When      SELTYPE = '?'
    ?C                   ExSr      GetTYPE
    ?C                   ExSr      Scrn00
      *? Passed all Edits ==> Screen 01
    ?C                   OTHER                                                  ?
     C                   Eval      SAVFirst   =  SELFirst
     C                   Eval      SAVLast    =  SELLast
     C                   Eval      SAVName    =  SELName
     C                   Eval      SAVWrkDtFm =  SELWrkDtFm
     C                   Eval      SAVWrkDtTo =  SELWrkDtTo
     C                   Eval      SAVType    =  SELType
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      GetTYPE - Get Labor Type Code                      :
      *?  :.........................................................:
    ?C     GetTYPE       BegSr                                                  ?

    ?C                   Call      'XATABLE'
    ?C                   Parm      'JC'          TABID             2
    ?C                   Parm                    #KEYP#            2
    ?C     SELTYPE       Parm                    #EELM#            6

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
      *? Show Now or All
    ?C                   When         *In04
     C                   If        *In31
     C                   Eval      *In31 = *Off
     C                   Eval      In31 = *Off
     C                   Else
     C                   Eval      *In31 = *On
     C                   Eval      In31 = *On
     C                   EndIf
    ?C                   ExSr      CloseData
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? Refresh Requested
    ?C                   When         *In05
    ?C                   ExSr      CloseData
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? Restart Requested
    ?C                   When         *In06
    ?C                   ExSr      Scrn00
      *? Day/Week Function Requested
    ?C                   When         *In08 or *In09 or *In10
    ?C                   ExSr      CloseData
    ?C                   Select
      *?       Show Week
    ?C                   When         *In08
     C                   If        *In32 = *On                                  Change Day/Week Mode
     C                   Eval      *In32 = *Off                                   Day Mode
     C                   Else
     C                   Eval      *In32 = *On                                    Week Mode
     C                   EndIf

     C                   Eval      SCRWRKDTFM = $MDYDate(
     C                             $Monday($DateMDY(SCRWRKDTFM):'MON'))
      *?       Minus Day/Week Requested
    ?C                   When         *In09 and *In32
     C                   Eval      SCRWRKDTFM = $MDYDate($AddDate(
     C                             $Monday($DateMDY(SCRWRKDTFM):'MON'):-7))
    ?C                   When         *In09 and not *In32
     C                   Eval      SCRWRKDTFM = $MDYDate($AddDate(
     C                             $DateMDY(SCRWRKDTFM):-1))
      *?       Plus Day/Week Requested
    ?C                   When         *In10 and *In32
     C                   Eval      SCRWRKDTFM = $MDYDate($AddDate(
     C                             $Monday($DateMDY(SCRWRKDTFM):'MON'):7))
    ?C                   When         *In10 and not *In32
     C                   Eval      SCRWRKDTFM = $MDYDate($AddDate(
     C                             $DateMDY(SCRWRKDTFM):1))
    ?C                   EndSL
      *?       Set End Date
     C                   If        *In32
     C                   Eval      SCRWRKDTTO = $MDYDate($AddDate(
     C                             $Monday($DateMDY(SCRWRKDTFM):'MON'):6))
     C                   Else
     C                   Eval      SCRWRKDTTO = SCRWRKDTFM
     C                   EndIf
    ?C                   ExSr      ScrDates
     C                   Eval      SAVWrkDtFm =  SELWrkDtFm
     C                   Eval      SAVWrkDtTo =  SELWrkDtTo
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? Lookup Labor Type Code Requested
    ?C                   When      SELTYPE = '?'
    ?C                   ExSr      GetTYPE
    ?C                   ExSr      Scrn01
      *? Selection Changed
    ?C                   When      SELFirst   <> SAVFirst     or
    ?C                             SELLast    <> SAVLast      or
    ?C                             SELName    <> SAVName      or
    ?C                             SELWrkDtFm <> SAVWrkDtFm   or
    ?C                             SELWrkDtTo <> SAVWrkDtTo   or
    ?C                             SELType    <> SAVType      or
    ?C                             SelGroup   <> SAVGroup
     C                   Eval      SAVFirst   =  SELFirst
     C                   Eval      SAVLast    =  SELLast
     C                   Eval      SAVName    =  SELName
     C                   Eval      SAVWrkDtFm =  SELWrkDtFm
     C                   Eval      SAVWrkDtTo =  SELWrkDtTo
     C                   Eval      SAVType    =  SELType
     C                   Eval      SAVGroup   =  SELGroup
     C                   ExSr      CloseData
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? If no Functions, Check for Options.
    ?C                   OTHER                                                  ?
    ?C                   ExSr      OptS01
      *? Redisplay
    ?C                   ExSr      Scrn01
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      OptS01 - Option for Screen 01                      :
      *?  :.........................................................:
    ?C     Opts01        BegSr                                                  ?

     C                   Eval      NewJob = *Blanks

     C                   DoW       not %EOF(ATT010FM)
    ?C                   ReadC     ATT01001                                     ?
     C                   If        not %EOF(ATT010FM)
    ?C                   Select                                                 ?
      *? Change Time Record
    ?C                   When      Option = '2'
     C                   Call      'ATT060'
     C                   Parm                    ATTIME
    ?C                   When      Option = '4'
     C                   Call      'ATT061'
     C                   Parm                    ATTIME
    ?C                   When      Option = '5'
     C                   Call      'SOW031F'
     C                   Parm                    ATTYPE
     C                   Parm                    ATDATE
    ?C                   When      Option = '6' and NewJob = *Blanks
     C                   ExSr      GetNewJob
     C                   If        NewJob <> *Blanks
     C                   ExSr      XferJob
     C                   EndIf                                                  ?
    ?C                   When      Option = '6' and NewJob <> *Blanks
     C                   ExSr      XferJob
    ?C                   When      Option = '7'
     C                   Call      '#ATTEND'
     C                   Parm                    EMFILE
     C                   Parm      'O'           OUT               1
     C                   Parm      ' '           TYPE              1
    ?C                   When      Option = '9' and Copies = *Zeros
     C                   ExSr      GetLabels
     C                   If        Copies <> *Zero
     C                   Eval      PrtLabel# = ATCARD
     C                   Eval      PrtQty    = Copies
     C                   CallP     $PrtUsrLab(PrtLabel#:PrtQty)
     C                   EndIf
    ?C                   When      Option = '9' and Copies <> *Zeros
     C                   Eval      PrtLabel# = ATCARD
     C                   Eval      PrtQty    = Copies
     C                   CallP     $PrtUsrLab(PrtLabel#:PrtQty)
    ?C                   EndSl                                                  ?
     C                   Eval      Option = ' '
     C                   Eval      *In28 = *On
    ?C                   Update    ATT01001                                     ?
     C                   Eval      *In28 = *Off
     C                   EndIf                                                  ?
     C                   EndDo                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      GetLabels - Get Quantity of Labels to Print        :
      *?  :.........................................................:
    ?C     GetLabels     BegSr                                                  ?

     C                   Eval      Copies = 75

     C                   DoU       Copies <> *Zero or *In12
    ?C                   ExFmt     ATT01003
     C                   If        *In12
     C                   Eval      Copies = *Zeros
     C                   EndIf
     C                   EndDo

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      XferJob - Transfer Employee to new job.            :
      *?  :.........................................................:
    ?C     XferJob       BegSr                                                  ?

     C                   Call      '#EMPFILE#'
     C                   Parm                    ATCARD
     C                   Parm                    ATFILE
     C                   Parm                    name             25
     C                   Call      '#ATTEND'
     C                   Parm                    ATFILE
     C                   Parm      'I'           NewStat           1
     C                   Parm                    NewJob

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      GetNewJob - Get New Job code for transfer.         :
      *?  :.........................................................:
    ?C     GetNewJob     BegSr                                                  ?

     C                   DoU       NewJob <> *Blank or *In12
    ?C                   ExFmt     ATT01002
     C                   If        NewJob = '?'
     C                   Call      'ATT011CL'
     C                   Parm      ' '           NewJob
     C                   EndIf
     C                   If        *In12
     C                   Eval      NewJob = *Blanks
     C                   EndIf
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
     C                   Parm      'ATT010'      PgmQ             10            ?Pgm Msg Queue
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
    ?c+    select   ATDATE                     as Date_Worked
    ?c+         ,   ATCARD                     as Time_Card_#
    ?c+         ,   Upper(EMLAST)              as Last_Name
    ?c+         ,   Upper(EMFIRS)              as First_Name
    ?c+         ,   Upper(SubStr(Trim(EMLAST)||', '||EMFIRS,1,25))
    ?c+                                          as Employee_Name
    ?c+         ,   ATTYPE                     as Type_of_Work
    ?c+         ,   ATSTRT                     as Start_Time
    ?c+         ,   ATENDT                     as End_Time
    ?c+         ,   INT((ATENDT - ATSTRT)/60)  as Minutes_Worked
    ?c+         ,   ATTRAZ                     as Trays_Produced
    ?c+         ,   ATTIME                     as Att_TimeStamp
    ?c+         ,   EMFILE                     as Emp_FileNumber
    ?c+    from     FMATTEND, FMEMPXREF, FMEMPLOY, XATABL
    ?c+    where    FMATTEND.ATCARD  = FMEMPXREF.TXCARD
    ?c+      and    FMEMPXREF.TXFILE = FMEMPLOY.EMFILE
    ?c+      and    'JC' || FMATTEND.ATTYPE  = XATABL.TBTBCD
    ?c+      and    (ATDATE  >=    :SELWRKDTFM)
    ?c+      and    (ATDATE  <=    :SELWRKDTTO)
    ?c+      and    (ATTYPE   =    :SELTYPE          or :SELTYPE    =  '' )
    ?c+      and    (EMLAST  like  trim(:SELLAST2)   or :SELLAST2   =  '' )
    ?c+      and    (EMFIRS  like  trim(:SELFIRST2)  or :SELFIRST2  =  '' )
    ?c+      and    (Upper(SubStr(Trim(EMLAST)||', '||EMFIRS,1,25))
    ?c+                      like  trim(:SELNAME2)    or :SELNAME2  =  '' )
    ?c+      and    (SubStr(TBSHRT,1,3) like :SELGROUP or :SELGROUP  =  '' )
    ?c+      and    (ATSTRT = ATENDT and :IN31='1' or :IN31='0')
    ?c+    Order By ATDATE
    ?c+         ,   Upper(SubStr(Trim(EMLAST)||', '||EMFIRS,1,25))
    ?c+         ,   ATSTRT
    ?c+
    ?c+    For Read only
    ?c+
    ?c/end-exec

     ?*  Open the SQL recordset
    ?c/exec sql
    ?c+                  Open      C1
    ?c/end-exec

    ?c/exec sql
    ?c+
    ?c+    SELECT   sum(ATTRAZ)
    ?c+    INTO     :TotalTrays
    ?c+    from     FMATTEND, FMEMPXREF, FMEMPLOY, XATABL
    ?c+    where    FMATTEND.ATCARD  = FMEMPXREF.TXCARD
    ?c+      and    FMEMPXREF.TXFILE = FMEMPLOY.EMFILE
    ?c+      and    'JC' || FMATTEND.ATTYPE  = XATABL.TBTBCD
    ?c+      and    (ATDATE  >=    :SELWRKDTFM)
    ?c+      and    (ATDATE  <=    :SELWRKDTTO)
    ?c+      and    (ATTYPE   =    :SELTYPE          or :SELTYPE    =  '' )
    ?c+      and    (EMLAST  like  trim(:SELLAST2)   or :SELLAST2   =  '' )
    ?c+      and    (EMFIRS  like  trim(:SELFIRST2)  or :SELFIRST2  =  '' )
    ?c+      and    (Upper(SubStr(Trim(EMLAST)||', '||EMFIRS,1,25))
    ?c+                      like  trim(:SELNAME2)    or :SELNAME2  =  '' )
    ?c+      and    (SubStr(TBSHRT,1,3) like :SELGROUP or :SELGROUP  =  '' )
    ?c+      and    (ATSTRT = ATENDT and :IN31='1' or :IN31='0')
    ?c+
    ?c/end-exec
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ReadData - Read Data                               :
      *?  :.........................................................:

     C     ReadData      BegSr

     ?*  Read Sow Schedule Records
    ?c/exec sql
    ?c+ Fetch C1 into :Attendance
    ?c/end-exec

     C                   If        SQLSTT = '02000'                             ?Read until EOF
     C                   Eval      EndOfFile = *On
     C                   Else
     C                   Eval      EndOfFile = *Off
     C                   Eval      ATDATE      = C1_DATE
     C                   Eval      ATCARD      = C1_CARD
     C                   Eval      EMLAST      = C1_LAST
     C                   Eval      EMFIRS      = C1_FIRS
     C                   Eval      NAME        = C1_NAME
     C                   Eval      ATTYPE      = C1_TYPE
     C                   Eval      ATSTRT      = C1_STRT
     C                   Eval      ATENDT      = C1_ENDT
     C*                  Eval      MINUTES     = C1_MINT
     C                   Eval      ATTRAZ      = C1_TRAZ
     C                   Eval      ATTIME      = C1_TIME
     C                   Eval      EMFILE      = C1_FILE
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

     C                   Eval      *In83 = *Off
     C                   Eval      *In31 = *Off
     C                   Eval      In31 = *Off
     C                   Eval      SCRWrkDtFm = $MDYDate($Date(0))
     C                   Eval      SCRWrkDtTo = $MDYDate($Date(0))

    ?C                   EndSr                                                  ?
