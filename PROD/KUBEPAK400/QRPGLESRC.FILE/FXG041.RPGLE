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

     FFTRAY     UF A E           K DISK
     FFTRAYR    UF   E           K DISK
     FFMEMPLOY  IF   E           K DISK
     FFCARTDTTMSIF   E           K DISK
     FFTRAYFIXEDUF A E           K DISK
     FFXG041FM  CF   E             WORKSTN
     F                                     SFILE(FXG04101:RRN01)

      *?  LDA
     D                UDS

      *? Fields
     D  RRN01          S              4  0 Inz(0)                               ?SFLRRN Screen 01
    ?D  StartTag#      S              8S 0
    ?D  EndTag#        S              8S 0
    ?D  Tag            S              8S 0
    ?D  User           S              8S 0
     D  SED            S              3A   Inz('SED')                           ?Size Code for Seed
     D  Remaining      S              7S 0                                      ?Records Left
     D  SownByUser     S              9S 0                                      ?Sown By Key
     D  Cart           S                   Like(CDCART)                         ?Cart Number
     D  CartTime       S               Z                                        ?Cart TimeStamp
     D  MinusTray      S              4P 0 Inz(-1)                              ?Minus One Tray
     D  PlusTray       S              4P 0 Inz(+1)                              ?Plus One Tray
     D  AttTimestamp   S                   Like(TFATTT)                         ?Attend. Timestamp
     D  Back48         S                   Like(TFATTT)                         ?48 Hours Ago
     D  Today          S               D                                        ?Today Date
     D  TodayTime      S                   Like(TFATTT) Inz(*SYS)               ?Today Timestamp
     D  TimeText       S             26A                                        ?Today Timestamp

      *? Indicators
     D  EndOfFile      S               N   INZ(*Off)
     D  Looking4Tag    S               N   INZ(*Off)
     D  Looking4Usr    S               N   INZ(*Off)

      *? Function Prototypes
    ?D/COPY QFunctDefn,$TimeStamp
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date8
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$User

      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

    ?
     C                   ExSr      Load01
     C                   ExSr      Scrn01
     C                   DoW       not *InLr
    ?C                   ExSr      Edit01
     C                   EndDo


      *?  ...........................................................
      *?  :      SCRN01 - Display Screen 01                         :
      *?  :.........................................................:

     C     SCRN01        BegSR

     C                   If        Looking4Tag
     C                   Eval      *In11 = *On                                  ?Looking for Tag #
     C                   Else
     C                   Eval      *In11 = *Off                                 ?Looking for User #
     C                   EndIf

    ?C                   Write     MSGCTL                                       ?
     C                   If        RRN01 <= 0
     C                   Eval      *IN26 = *Off
     C                   Else
     C                   Eval      *IN26 = *On
     C                   EndIf

     C                   Eval      *In25 = *On
     C                   Eval      SFLLine = RRN01
     C                   ExFmt     FXG04101C
    ?C                   ExSr      ClrError
     C                   Eval      *In25 = *Off

     C                   EndSr


      *?  ...........................................................
      *?  :      Load01     - Load Screen 1                         :
      *?  :.........................................................:

     C     Load01        BegSr

      *? Clear the screen if new tray.
     C                   Eval      Looking4Tag = *On
     C                   Eval      Looking4Usr = *Off
     C                   Eval      *In11 = *On                                  ?Looking for Tag #
     C                   Eval      TAG  = 0
     C                   Eval      USER = 0

     C                   EndSr


      *?  ...........................................................
      *?  :      EDIT01 - Edit Screen 01                            :
      *?  :.........................................................:

     C     EDIT01        BegSR

      *?  Determine if scan is a Tray Tag or a user...
     C                   If        ScanRead < 1000000

     C                   Eval      User = ScanRead
     C                   Else

      *?  If two subsequent tags are read write first tag out with no Fixer
      *?     ( If ScanRead is a tag and the Tag field is not zero, two
      *?       Tray Tags were scanned with no user scan in between)
     C                   If        Tag <> *Zero                                 ?Prev not Processed
     C                   Eval      User = *Zero
     C                   ExSr      ProcessTray
     C                   EndIf

      *?       Now set the Tag value to the Tray Tag scanned
     C                   Eval      Tag  = ScanRead
     C                   Eval      User = *Zero

     C                   EndIf

      *?       Check where the Tags reside
     C                   If        Tag <> *Zero
    ?C     Tag           SetLL     FTRAY                                  31
    ?C     Tag           SetLL     FTRAYR                                 32
     C                   EndIf

    ?C                   Select
    ?C                   When      *In03 or *In07
     C                   Eval      *InLr = *On

    ?C                   When      Looking4Tag and
    ?C                             Tag = *Zero
     C                   Eval      MessageID   = 'SOW0301'
      *? Enter the Tray Tag number to be comfirmed.
     C                   ExSr      SndError
     C                   ExSr      Scrn01

    ?C                   When      Looking4Usr and
    ?C                             User = *Zero
     C                   Eval      MessageID   = 'SOW0305'
      *? Enter the User Number for the individual who produced this tray.
     C                   ExSr      SndError
     C                   ExSr      Scrn01

    ?C                   When      %Equal(FTRAY)
    ?C                             and Looking4Tag
     C                   If        %Equal(FTRAYR)
    ?C     Tag           Chain     FTRAYR
    ?C                   Delete    RTRAYR
     C                   EndIf
     C                   Eval      Looking4Tag = *Off
     C                   Eval      Looking4Usr = *On
      *  Check if already scanned on this cart...
    ?C     TagTime       SetLL     FTRAYFIXED
     C                   If        %Equal(FTRAYFIXED)
     C                   Eval      MessageID   = 'FXG0411'
     C                   Eval      MessageDta  = %Char(Tag)
      *? Tag &1 has already been scanned on this cart
     C                   ExSr      SndError
     C                   EndIf
     C                   ExSr      Scrn01

    ?C                   When      not %Equal(FTRAYR)
    ?C                             and Looking4Tag
     C                   Eval      MessageID   = 'SOW0302'
     C                   Eval      MessageDta  = %Char(Tag)
      *? The Tray Tag number ( &1 ) is not valid.  Check the number and try again.
     C                   ExSr      SndError
     C                   ExSr      Scrn01

    ?C                   When      %Equal(FTRAYR) and
    ?C                             not %Equal(FTRAY) and
    ?C                             not Looking4Usr
     C                   Eval      Looking4Tag = *Off
     C                   Eval      Looking4Usr = *On
     C                   Eval      MessageID   = 'SOW0306'
     C                   Eval      MessageDta  = *Blanks
      *? Valid Tag entered.  Scan Sown by Tag.
     C                   ExSr      SndError
     C                   ExSr      Scrn01

    ?C                   Other
     C                   ExSr      ProcessTray
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   EndSl


     C                   EndSr


      *?  ...........................................................
      *?  :      ProcessTray - Process This Tray                    :
      *?  :.........................................................:

     C     ProcessTray   BegSR

     C                   Eval      *In51 = *Off                                  Scan B4 This Cart
     C                   Eval      *In52 = *Off                                  Not Clocked In
     C                   Eval      *In53 = *Off                                  Scan B4 Previous
     C                   Eval      *In54 = *Off                                  Scan B4 w/in 48 hrs

      * ? Double check that tag is on correct Tray File
    ?C     Tag           Chain     FTRAY
    ?C     Tag           Chain     FTRAYR
     C                   Eval      TRSTAT = 'A'
     C                   Eval      TRREAS = *Blanks
     C                   Eval      TRDTLA = $MDYDate($Date(0))
     C                   Eval      TRUSER = $User()
     C                   Time                    TRTIME
    ?C                   Select                                                 ?
    ?C                   When      %found(FTRAYR) and not %found(FTRAY)         ?
    ?C                   Write     RTRAY
    ?C                   Delete    RTRAYR
    ?C                   When      %found(FTRAYR) and %found(FTRAY)
    ?C                   Update    RTRAY
    ?C                   Delete    RTRAYR
    ?C                   When      %found(FTRAY)
    ?C                   Update    RTRAY
    ?C                   EndSl

     C                   Call      'ADDLOTINV'
     C                   Parm                    TAG
     C                   Parm                    TAG

WJB  C                   Call      '#GOODFLAT'
WJB  C                   Parm                    TAG

      * ? Write fixed by record.
    ?C     TagTime       Chain     FTRAYFIXED
    ?C     TagTime       KList
    ?C                   KFld                    TAG
    ?C                   KFld                    CartTime
     C                   Eval      TFTAG# = TAG
     C                   Eval      TFCART = CART
     C                   Eval      TFSTAT = 'A'
     C                   Eval      TFCARD = USER
     C                   Eval      TFTIME = CartTime
     C                   Eval      EMCARD = User
     C                   Call      '#EMPFILE#'
     C                   Parm                    EMCARD
     C                   Parm                    EMFILE
     C                   Parm                    name             25
     C                   Time                    Back48
wjb  C                   SubDur    2:*D          Back48
      * ?     If Tray scanned on this cart deduct 1 tray from previous fixer
wjb  C                   If        %Found(FTRAYFIXED)
     C                   Eval      *In51 = *On
    ?C                   Call      '#ADDUSRTRY'
    ?C                   Parm                    EMFILE
    ?C                   Parm                    MINUSTRAY
    ?C                   Parm      'F'           OperType          1
    ?C                   Parm      TFATTT        AttTimestamp
      * ?     Add 1 tray to fixer attendance record for updated fixed record.
     C                   Time                    TFATTT
    ?C                   Call      '#ADDUSRTRY'
    ?C                   Parm                    EMFILE
    ?C                   Parm                    PLUSTRAY
    ?C                   Parm      'F'           OperType
    ?C     TFATTT        Parm      TFATTT        AttTimestamp
     C                   If        TFATTT < TodayTime
     C                   Eval      *In52 = *On
     C                   EndIf
     C                   Eval      TFCARD = USER
      * ?     Update fixed record
    ?C                   Update    RTRAYFIXED
     C                   Else
      * ?     Check if same tray has been fixed recently...
     C                   Clear                   TFATTT
    ?C     Tag           SetGt     FTRAYFIXED
    ?C     Tag           ReadPE    FTRAYFIXED
     C                   If        not %EOF(FTRAYFIXED)
      * ?     If Tray was ever fixed before, set *IN53 to change color
     C                   Eval      *In53 = *On
     C                   EndIf
      *
     C                   Call      '#EMPFILE#'
     C                   Parm                    EMCARD
     C                   Parm                    EMFILE
     C                   Parm                    name             25
      * ?     If Tray scanned w/in 48 hours deduct do not reprocess.
     C                   If        TFATTT > Back48
     C                   Eval      *In54 = *On
     C                   Else
      *
     C                   Eval      TFTAG# = TAG
     C                   Eval      TFCART = CART
     C                   Eval      TFSTAT = 'A'
     C                   Eval      TFCARD = USER
     C                   Eval      TFTIME = CartTime
     C                   Eval      EMCARD = User
      * ?     Add 1 tray to fixer attendance record for updated fixed record.
     C                   Time                    TFATTT
    ?C                   Call      '#ADDUSRTRY'
    ?C                   Parm                    EMFILE
    ?C                   Parm                    PLUSTRAY
    ?C                   Parm      'F'           OperType
    ?C     TFATTT        Parm      TFATTT        AttTimestamp
     C                   If        TFATTT < TodayTime
     C                   Eval      *In52 = *On
     C                   EndIf
     C                   Eval      TFCARD = USER
      * ?     Write fixed record
     C                   If        not *In54
    ?C                   Write     RTRAYFIXED
     C                   EndIf
     C                   EndIf
     C                   EndIf

      * ? Populate Last Tag & Last User
     C                   Eval      LastTag  = TAG
     C                   Eval      LastUser = USER

      * ? Add Tray / User to subfile
     C                   Add       1             RRN01                          ?
     C                   Eval      EMCARD = User
     C                   Call      '#EMPFILE#'
     C                   Parm                    EMCARD
     C                   Parm                    EMFILE
     C                   Parm                    name             25
    ?C     EMFILE        Chain     FMEMPLOY
     C                   If        %Found(FMEMPLOY)
     C                   Eval      LASTUSERNM =
     C                             %Trim(EMLAST) + ', ' + %Trim(EMFIRS)
     C                   Else
     C                   Eval      LASTUSERNM = 'Not Found '
     C                   EndIf
    ?C                   Write     FXG04101                                     ?
     C                   Eval      *In26 = *On

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
     C                   Parm      'FXG041'      PgmQ             10            ?Pgm Msg Queue
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

    ?C     *Entry        PList
    ?C                   Parm                    CartTime                       ?Cart Timestamp

     C                   Move      TodayTime     TimeText
     C                   Eval      TimeText = %SubSt(TimeText:1:11) +
     C                              '00.00.00.000000'
     C                   Move      TimeText      TodayTime

    ?C     CartTime      Chain     FCARTDTTMS
     C                   Eval      CART = CDCART

    ?C                   ExSr      ClrError
     C                   Eval      MessageID   = 'SOW0304'
     C                   Eval      MessageDta  = %Char(Remaining)
    ?C                   ExSr      SndError
     C                   Eval      *IN25 = *Off
     C                   Eval      *IN26 = *Off
    ?C                   Write     Assume
    ?C                   Write     FXG04101C

     C                   EndSR
