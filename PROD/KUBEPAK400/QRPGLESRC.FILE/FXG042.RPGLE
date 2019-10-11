    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *??:````````````````````````````````````````````````````````````:?
      *??:         Fix Confirmation Scanning                          :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Aug. 2006            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program is used at Cart Check-out from Fixing.     ?:
      *? : All good trays are scanned and marked accordingly on      ?:
      *? : the FTRAYFIXED file.                                      ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? : Subroutine ?-Subroutine Description                  ?  ?:
      *? :  *INZSR      -?Initialization Subroutine                  ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? : Function   ?-Function Description                    ?  ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? : *IND  ?-Indicator Usage                              ?  ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFMINVTAL  IF   E           K DISK
     FFSOWSCHR@SIF   E           K DISK
     FFTRAYRR@S IF   E           K DISK
     FFTRAYSR@S UF   E           K DISK
     FFLOSSD    IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFCALENCYW IF   E           K DISK
     FFTRAYFIXEDUF A E           K DISK

     FFXG042FM  CF   E             WORKSTN
     F                                     SFILE(FXG04201:RRN01)
     F                                     SFILE(FXG04202:RRN02)

      *?  LDA
     D                UDS

      *? Data Structures
     D SowWeek         DS                                                       ?Sow Week CCYYWW
     D Century                        2S 0                                      ?Century  CC
     D Year                           2S 0                                      ?Century    YY
     D Week                           2S 0                                      ?Century      WW
     D TRSCYW                              OverLay(SowWeek)                     ?Sow Week CCYYWW

      *? Fields
     D RRN01           S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D RRN02           S              4  0 Inz(0)                               ?SFLRRN Screen 02
     D Today           S               D                                        ?Today Date
     D TodayTimeStamp  S               Z   Inz(*SYS)                            ?Today Timestamp
     D AttTimestamp    S               Z   Inz(*SYS)                            ?Attend Timestamp
     D TodayTime       S               T   Inz(*SYS)                            ?Today Time
     D Tag             S              8S 0                                      ?Tray Tag#
     D SavDate         S                   Like(SelDate)                        ?Save SelDate
     D SavSize         S                   Like(SelSize)                        ?Save SelSize
     D SavLook         S                   Like(SelLook)                        ?Save SelLook

      *? Indicators
     D  PassedEdit01   S               N   INZ(*Off)
     D  IncludeItem    S               N   INZ(*Off)
     D  OnlyShowLeft   S               N   INZ(*Off)
     D  FirstTime      S               N   INZ(*On )

      *? Function Prototypes
    ?D*COPY QFunctDefn,$TimeStamp
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D*COPY QFunctDefn,$Date8
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$IsDate#
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$User

      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

    ?
      /Free
    ?   /COPY QFunctDefn,LASTUSEDCB
      /End-Free
    ?C                   ExSr      Load01
     C                   DoW       not *InLr
    ?C                   ExSr      Edit01
     C                   EndDo


      *?  ...........................................................
      *?  :      SCRN01 - Display Screen 01                         :
      *?  :.........................................................:

     C     SCRN01        BegSR

    ?C                   Write     MSGCTL                                       ?
     C                   If        RRN01 <= 0
     C                   Eval      *IN26 = *Off
     C                   Else
     C                   Eval      *IN26 = *On
     C                   EndIf

     C                   Eval      *In25 = *On
     C                   If        SflCsrRRN1 = 0
     C                   Eval      SFLLine01 = 1
     C                   Else
     C                   Eval      SFLLine01 = SflCsrRRN1
     C                   EndIf
    ?C                   Write     FXG04201F
    ?C                   ExFmt     FXG04201C
    ?C                   ExSr      ClrError
     C                   Eval      *In25 = *Off

     C                   EndSr


      *?  ...........................................................
      *?  :      SCRN02 - Display Screen 02                         :
      *?  :.........................................................:

     C     SCRN02        BegSR

     C                   If        RRN02 <= 0
     C                   Eval      *IN26 = *Off
     C                   Else
     C                   Eval      *IN26 = *On
     C                   EndIf

     C                   Eval      *In25 = *On
     C                   If        SflCsrRRN2 = 0
     C                   Eval      SFLLine02 = 1
     C                   Else
     C                   Eval      SFLLine02 = SflCsrRRN2
     C                   EndIf
    ?C                   ExFmt     FXG04202C
    ?C                   ExSr      ClrError
     C                   Eval      *In25 = *Off

     C                   EndSr


      *?  ...........................................................
      *?  :      Load01     - Load Screen 1                         :
      *?  :.........................................................:

     C     Load01        BegSr

     C                   Time                    TimeNOW           6 0
     C                   Time                    TodayTime
     C                   Time                    TodayTimeStamp
     C                   Eval      *IN25 = *Off
     C                   Eval      *IN26 = *Off
    ?C                   Write     Assume
    ?C                   Write     FXG04201C
     C                   Eval      *IN25 = *On
     C                   Clear                   FXG04201
     C                   Eval      RRN01 = *Zeros                               ?Relative Record
     C                   Eval      SflCsrRRN1 = 1

      *? If all data selections fields are filled and valid, populate subfile
     C                   If        PassedEdit01                                 ?Looking for Tag #

    ?C     SELLOOK       SetLL     FMINVTAL
    ?C                   Read      FMINVTAL
     C                   DoW       not %EOF(FMINVTAL) and SelLook =
     C                             %SubSt(IMLOOK:1:%Len(%Trim(SelLook)))

      *? Check that it's the right size.
     C                   If        IMSIZE = SelSize
     C                   Eval      SelDate7 = $Date7($DateMDY(SelDate))

      *? Check that it was on the Sow Schedule.
    ?C                   ExSr      LoadSchedule
     C                   If        IncludeItem
    ?C                   ExSr      LoadTrays

      *? Write the SUBFILE Record
     C                   If        not OnlyShowLeft or Left > 0
     C                   Eval      RRN01 = RRN01 + 1                            ?Relative Record
    ?C                   Write     FXG04201
     C                   EndIf
    ?C                   Clear                   FXG04201
     C                   Eval      *IN26 = *On                                   SFL Has Data
     C                   EndIf
     C                   EndIf
    ?C                   Read      FMINVTAL
     C                   EndDo
     C                   EndIf

     C                   If        *In26
    ?C     RRN01         Chain     FXG04201
     C                   Eval      *In27 = *On
    ?C                   Update    FXG04201
     C                   Eval      *In27 = *Off
     C                   EndIf

    ?C                   ExSr      ClrError
     C                   Eval      MessageID   = 'FXG0422'
     C                   Eval      MessageDta = %Char(RRN01)
      *? There are &1 items that match your selection criteria.
     C                   ExSr      SndError

     C                   EndSr


      *?  ...........................................................
      *?  :      Load02     - Load Screen 2                         :
      *?  :.........................................................:

     C     Load02        BegSr

     C                   Time                    TimeNOW           6 0
     C                   Time                    TodayTime
     C                   Time                    TodayTimeStamp
     C                   Eval      *IN25 = *Off
     C                   Eval      *IN26 = *Off
    ?C                   Write     Assume
    ?C                   Write     FXG04202C
     C                   Eval      *IN25 = *On
     C                   Clear                   FXG04202
     C                   Eval      RRN02 = *Zeros                               ?Relative Record
     C                   Eval      SflCsrRRN2 = 1

    ?C     RdyItmSiz     SetLL     FSOWSCHR@S
    ?C     RdyItmSiz     ReadE     FSOWSCHR@S
     C                   DoW       not %EOF(FSOWSCHR@S)
      *? Write the SUBFILE Record
     C                   Eval      SOASOW6 = $MDYDate($Date(SOASOW))
     C                   Eval      SOSOWD6 = $MDYDate($Date(SOSOWD))
     C                   Eval      RRN02 = RRN02 + 1                            ?Relative Record
    ?C                   Write     FXG04202
    ?C                   Clear                   FXG04202
     C                   Eval      *IN26 = *On                                   SFL Has Data
    ?C     RdyItmSiz     ReadE     FSOWSCHR@S
     C                   EndDo

     C                   If        *In26
    ?C     RRN02         Chain     FXG04202
     C                   Eval      *In27 = *On
    ?C                   Update    FXG04202
     C                   Eval      *In27 = *Off
     C                   EndIf

     C                   EndSr


      *?  ...........................................................
      *?  :      LoadSchedule - Load FSOWSCH data                   :
      *?  :.........................................................:

     C     LoadSchedule  BegSR

    ?C     RdyItmSiz     KList
    ?C                   KFld                    SelDate7          7 0
    ?C                   KFld                    IMLOOK
    ?C                   KFld                    IMITEM
    ?C                   KFld                    IMSIZE
     C                   Eval      IncludeItem = *Off

      *? Check that it was on the Sow Schedule.
    ?C     RdyItmSiz     SetLL     FSOWSCHR@S
     C                   If        %EQUAL(FSOWSCHR@S)
     C                   Eval      Look  = IMLOOK
     C                   Eval      Item  = IMITEM
     C                   Eval      Des1  = %SubSt(IMDES1:1:%Len(Des1))
     C                   Eval      IncludeItem = *On

      *? Sum up all Sow Schedule records for specified item.
    ?C     RdyItmSiz     ReadE     FSOWSCHR@S
     C                   DoW       not %EOF(FSOWSCHR@S)
     C                   Eval      Jobs  = Jobs + 1
     C                   Eval      Ordr  = Ordr  + SOORDQ
     C                   Eval      ToSow = ToSow + SOSOWT
     C                   Eval      Labl  = Labl  + SOSOWL
     C                   Eval      Sown  = Sown  + SOSOWQ
    ?C     RdyItmSiz     ReadE     FSOWSCHR@S
     C                   EndDo

     C                   EndIf

     C                   EndSr


      *?  ...........................................................
      *?  :      LoadTrays - Load FTRAY and FTRAYR Data             :
      *?  :.........................................................:

     C     LoadTrays     BegSR

      *?  Count FTRAYR Flats
    ?C     RdyItmSiz     SetLL     FTRAYRR@S
    ?C     RdyItmSiz     ReadE     FTRAYRR@S
     C                   DoW       not %EOF(FTRAYRR@S)
     C                   If        TRSTAT <> 'D'
     C                   Eval      Tags = Tags + 1
     C                   EndIf
     C                   If        TRCNTD = 'Y'
     C                   Eval      Post = Post + 1
     C                   EndIf
    ?C     RdyItmSiz     ReadE     FTRAYRR@S
     C                   EndDo

      *?  Count FTRAY  Flats
    ?C     RdyItmSiz     SetLL     FTRAYSR@S
    ?C     RdyItmSiz     ReadE     FTRAYSR@S
     C                   DoW       not %EOF(FTRAYSR@S)
     C                   If        TRSTAT <> 'D'
     C                   Eval      Tags = Tags + 1
     C                   EndIf
     C                   If        TRSTAT <> 'D' and TRSTAT <> ' '
     C                   Eval      Vfyd = Vfyd + 1
    ?C                   ExSr      LoadLeft
     C                   EndIf
     C                   If        TRCNTD = 'Y'
     C                   Eval      Post = Post + 1
     C                   EndIf
    ?C                   ExSr      LoadFixed
    ?C                   ExSr      LoadLosses
    ?C     RdyItmSiz     ReadE     FTRAYSR@S
     C                   EndDo

     C                   EndSr


      *?  ...........................................................
      *?  :      LoadFixed  - Load FIXED Count                      :
      *?  :.........................................................:

     C     LoadFixed     BegSR

    ?C     TRTAG#        SetLL     FTRAYFIXED
     C                   If        %EQUAL(FTRAYFIXED)
     C                   Eval      FXNG = FXNG + 1
     C                   EndIf

     C                   EndSr


      *?  ...........................................................
      *?  :      LoadLeft   - Load Left to Be Fixed Count           :
      *?  :.........................................................:

     C     LoadLeft      BegSR

    ?C     TRTAG#        SetLL     FTRAYFIXED
    ?C     TRTAG#        SetLL     FLOSSD
     C                   If        not %EQUAL(FTRAYFIXED) and
     C                             not %EQUAL(FLOSSD)
     C                   Eval      Left = Left + 1
     C                   EndIf

     C                   EndSr


      *?  ...........................................................
      *?  :      LoadLosses - Load FLOSSD Data                       :
      *?  :.........................................................:

     C     LoadLosses    BegSR

      *?  Count Loss Records
    ?C     TRTAG#        SetLL     FLOSSD
     C                   If        %EQUAL(FLOSSD)
     C                   Eval      Lost = Lost + 1
     C                   EndIf

     C                   EndSr


      *?  ...........................................................
      *?  :      EDIT01 - Edit Screen 01                            :
      *?  :.........................................................:

     C     EDIT01        BegSR

     C                   Eval      PassedEdit01 = *Off
     C                   SetOff                                       50
     C                   SetOff                                       515253

    ?C     SelSize       Chain     FMSIZE

      *?  Verify Screen
    ?C                   Select
      *?  Exit Requested
    ?C                   When      *In03 or *In07
     C                   Eval      *InLr = *On

      *?  First Time
    ?C                   When      FirstTime
     C                   Eval      FirstTime = *Off
     C                   ExSr      Scrn01

      *?  Check Date not Zero
    ?C                   When      SelDate = *Zeros
     C                   Eval      MessageID   = 'DATE902'
     C                   Eval      MessageDta = 'Ready'
      *? You must enter the &1 Date.  Enter the date and retry.
     C                   ExSr      SndError
     C                   Eval      *In51 = *On
     C                   ExSr      Scrn01

      *?  Check Valid Date
    ?C                   When      not $isDate#(SelDate:'*MDY')
     C                   Eval      MessageID   = 'DATE901'
     C                   Eval      MessageDta=%EditW(SelDate:'  /  /  ')
      *? Date of &1 is invalid.  Please re-key and try again.
     C                   ExSr      SndError
     C                   Eval      *In51 = *On
     C                   ExSr      Scrn01

      *?  Check Date is a Monday
    ?C                   When      $Monday($dateMDY(SelDate):'MON') <>
    ?C                                $dateMDY(SelDate)
     C                   Eval      MessageID   = 'DATE904'
     C                   Eval      MessageDta=%EditW(SelDate:'  /  /  ')+
     C                             %EditW($MDYDate($Monday($dateMDY
     C                             (SelDate):'MON')):'  /  /  ')
      *? The date entered &1 is not a Monday. &2 is Monday that week.
     C                   Eval      SelDate=
     C                             $MDYDate($Monday($dateMDY(SelDate):'MON'))
     C                   ExSr      SndError
     C                   Eval      *In51 = *On
     C                   ExSr      Scrn01

      *?  Check Size Entered
    ?C                   When      SelSize = *Blanks
     C                   Eval      MessageID   = 'SIZ0001'
      *? The Size Code cannot be blank.  Select a Size and retry your request.
     C                   ExSr      SndError
     C                   Eval      *In52 = *On
     C                   ExSr      Scrn01

      *?  Check Size is Valid
    ?C                   When      not %Found(FMSIZE) or SZCELL = *Zeros
     C                   Eval      MessageID   = 'SIZ0002'
     C                   Eval      MessageDta= SelSize + 'a Plug Flat.'
      *? Size Code &1 is not valid for this request. +++scdlvl.
     C                   ExSr      SndError
     C                   Eval      *In52 = *On
     C                   ExSr      Scrn01

      *?  Check Alpha search entered
    ?C                   When      SelLook = *Blanks
     C                   Eval      MessageID   = 'FXG0421'
      *? The Alpha Lookup field cannot be blank.  Select a value and retry your request.
     C                   ExSr      SndError
     C                   Eval      *In53 = *On
     C                   ExSr      Scrn01

      *?  IF HERE, ALL EDITS WERE PASSED

      *?  Toggle the OnlyShowLeft Flag
    ?C                   When      *In04
     C                   If        OnlyShowLeft
     C                   Eval      OnlyShowLeft = *Off
     C                   Eval      *In31        = *Off
     C                   Else
     C                   Eval      OnlyShowLeft = *On
     C                   Eval      *In31        = *On
     C                   EndIf
     C                   Eval      PassedEdit01 = *On
     C                   ExSr      Load01
     C                   ExSr      Scrn01

      *?  Refresh the screen
    ?C                   When      *In05
     C                   Eval      PassedEdit01 = *On
     C                   ExSr      Load01
     C                   ExSr      Scrn01

      *?  Minus One Week
    ?C                   When      *In09
     C                   Eval      SelDate =
     C                             $MDYDate($AddDate($DateMDY(SelDate):-7))
     C                   Eval      PassedEdit01 = *On
     C                   ExSr      Load01
     C                   ExSr      Scrn01

      *?  Plus One Week
    ?C                   When      *In10
     C                   Eval      SelDate =
     C                             $MDYDate($AddDate($DateMDY(SelDate): 7))
     C                   Eval      PassedEdit01 = *On
     C                   ExSr      Load01
     C                   ExSr      Scrn01

      *?  Process all records a Fixed
    ?C                   When      *In13
     C                   Eval      PassedEdit01 = *On
     C*                  ExSr      ProcessAll
     C                   ExSr      Load01
     C                   ExSr      Scrn01

      *?  Selection Changed, Load screen
    ?C                   When      SelDate <> SavDate or
    ?C                             SelSize <> SavSize or
    ?C                             SelLook <> SavLook
     C                   Eval      SavDate =  SelDate
     C                   Eval      SavSize =  SelSize
     C                   Eval      SavLook =  SelLook
     C                   Eval      PassedEdit01 = *On
     C                   ExSr      Load01
     C                   ExSr      Scrn01

      *?  Redisplay screen
    ?C                   Other
     C                   Eval      PassedEdit01 = *On
     C                   ExSr      Opts01
     C                   ExSr      Scrn01
    ?C                   EndSl


     C                   EndSr


      *?  ...........................................................
      *?  :      Opts01 - Screen 01 Subfile Option Processing       :
      *?  :.........................................................:

     C     Opts01        BegSR

    ?C                   ReadC     FXG04201
     C                   DoW       not %EOF(FXG042FM)
    ?C                   Select                                                 ?
    ?C                   When      Option = '1'
     C                   ExSr      MarkFixed
    ?C                   When      Option = '2'
     C                   Call      'ICR010ICL'
     C                   Parm                    IMITEM
     C                   Parm                    IMSIZE
     C                   Parm      'I'           DspMode           1
    ?C                   When      Option = '5'
     C                   Move      SelDate       SelDate@          6
     C                   Call      'BIR265ICL'
     C                   Parm                    IMITEM
     C                   Parm                    IMSIZE
     C                   Parm                    SelDate@
     C                   Parm      '1'           Type              1
    ?C                   When      Option = '6' and Jobs = 1
    ?C     CYW           KList
    ?C                   KFld                    Century                         Century
    ?C                   KFld                    Year                            Year
    ?C                   KFld                    Week                            Week
    ?C     CYW           Chain     FCALENCYW
     C                   If        %Found(FCALENCYW)
     C                   Move      TRJOB#        JOB#
     C                   Eval      SelDate@ = %EditW(
     C                                  $MDYDate($Date(CLCYMD)):'      ')
     C                   Call      'SOW300ICL'
     C                   Parm                    SelDate@
     C                   Parm                    JOB#              4
     C                   EndIf
    ?C                   When      Option = '6' and Jobs > 1
     C                   ExSr      Load02
     C                   ExSr      Scrn02
    ?C                   ReadC     FXG04202
     C                   DoW       not %EOF(FXG042FM)
     C                   If        Option02 = '1'
     C                   Move      SOSOWD6       SelDate@
     C                   Move      SOJOB#        JOB#
     C                   Call      'SOW300ICL'
     C                   Parm                    SelDate@
     C                   Parm                    JOB#
     C                   EndIf
    ?C                   ReadC     FXG04202
     C                   EndDo
    ?C                   Other
     C                   If        Option <> *Blanks
     C                   Eval      MessageID   = 'OPT0001'
     C                   Eval      MessageDta = Option
      *? Option &1 is not valid for this selection.
     C                   ExSr      SndError
     C                   EndIf
    ?C                   EndSL
     C                   Eval      Option = *Blanks
     C                   Eval      *In28 = *On
    ?C                   Update    FXG04201
    ?C                   ReadC     FXG04201
     C                   EndDo

     C                   EndSr


      *?  ...........................................................
      *?  :      MarkFixed - Mark the balance of this item fixed.   :
      *?  :.........................................................:

     C     MarkFixed     BegSR

      * ? Read Through all TRAY records for this item and mark them fixed.
    ?C     RdyItmSiz     SetLL     FTRAYSR@S
    ?C     RdyItmSiz     ReadE     FTRAYSR@S
     C                   DoW       not %EOF(FTRAYSR@S)

      * ?   Only mark as Fixed if Tray record is still active.
     C                   If        TRSTAT = 'A'

     C                   Call      '#GOODFLAT'
     C                   Parm      TRTAG#        TAG

     C                   Eval      TRREAS = *Blanks
     C                   Eval      TRDTLA = $MDYDate($Date(0))
     C                   Eval      TRUSER = 'FXG042'
     C                   Eval      TRTIME = TimeNOW

      * ?   Write fixed by record.
    ?C     TRTAG#        SetLL     FTRAYFIXED
     C                   If        not %EQUAL(FTRAYFIXED)
     C                   Eval      TFTAG# = TRTAG#
     C                   Eval      TFCART = 88888888
     C                   Eval      TFSTAT = 'A'
     C                   Eval      TFCARD = 7
     C                   Call      '#ADDUSRTRY'
    ?C                   Parm      7             ATFILE            6 0
    ?C                   Parm      1             TrayCount         4 0
    ?C                   Parm      'F'           JobCode           1
    ?C                   Parm                    AttTimestamp
     C                   Eval      TFTIME = TodayTimeStamp
     C*A                 Eval      TFATTT = TodayTimeStamp
     C                   Eval      TFATTT = AttTimestamp
    ?C                   Write     RTRAYFIXED
     C                   EndIf

    ?C                   Update    RTRAY
     C                   EndIf
    ?C     RdyItmSiz     ReadE     FTRAYSR@S
     C                   EndDo



     C                   EndSr


      *?  ...........................................................
      *?  :      ClrError - Clear Error Message Subfile             :
      *?  :.........................................................:
    ?C     ClrError      BegSr                                                  ?

     C                   MOVE      'C'           SndClr
     C                   ExSr      SRMSGF                                       ?
     C                   Eval      *In50 = *Off                                 ?Error Indicator

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      SndError - Send an Error Message to the PGMMSGQ    :
      *?  :.........................................................:
    ?C     SndError      BegSr                                                  ?

     C                   MOVE      'S'           SndClr
     C                   ExSr      SRMSGF                                       ?
     C                   Eval      *In50 = *On                                  ?Error Indicator

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      * ? :      SRMSGF - Clear or send messages to Pgm msg queue   :
      *?  :.........................................................:
    ?C     SRMSGF        BegSr                                                  ?

      *? Define Parameter List - define variables         ?

     C     MessageParm   PLIST                                                  ?
     C                   Parm      'FXG042'      PgmQ             10            ?Pgm Msg Queue
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

    ?C     *InzSr        BegSR


     C                   EndSR
