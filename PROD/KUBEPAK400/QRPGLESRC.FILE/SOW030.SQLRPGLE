    ?H/COPY QFunctDefn,@CopyRight
     H DftActGrp(*no)
     H DatFmt(*usa)
     H BndDir('*LIBL/KPFUNCTION')
      *??:````````````````````````````````````````````````````````````:?
      *??:         Sow Confirmation Scanning                          :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Sep. 2004            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program allows item sow on the recip machines to   ?:
      *? : be scanned as having been sow.  Formerly, recip type trays?:
      *? : where marked as sown as soon as they were prefilled.      ?:
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
      *? :````````````````````````````````````````````````````````````:
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? : Date    By: Description                              ?  ?:
      *? :  01/05/06?WJB Added call to ADDLOTONV                     ?:
      *? :  __/__/__?xxx _________________________________________   ?:
      *? :............................................................:

     FFTRAYR    UF   E           K DISK
     FFTRAY     UF A E           K DISK
     FFSOWNBY   UF A E           K DISK
     FFMSIZE    IF   E           K DISK
     FFMINVT    UF   E           K DISK
     FKPITMWHS  UF A E           K DISK
     FKPHIST    O  A E           K DISK
     FSOW030FM  CF   E             WORKSTN

      *?  LDA
     D                UDS

      *? Fields
     D  SED            S              3A   Inz('SED')                           ?Size Code for Seed
     D  Remaining      S              7S 0                                      ?Records Left
     D  Seed_Cell      S                   Like(IM#SED)                         ?SEEDS PER CELL
     D  Cell_Tray      S                   Like(SZCELL)                         ?CELLS PER TRAY
     D  Seeds          S              5S 0                                      ?Seeds Used
     D  Factor         S              7S 6                                      ?Sow Factor
     D  KPWhse         S                   Like(IWWHSE) Inz(1)                  ?Warehouse Number
WJB ?D  StartTag#      S              8S 0
WJB ?D  EndTag#        S              8S 0
     D  SownByUser     S              9S 0                                      ?Sown By Key
     D  MinusTray      S              4P 0 Inz(-1)                              ?Minus One Tray
     D  PlusTray       S              4P 0 Inz(+1)                              ?Plus One Tray
     D  AttTimestamp   S                   Like(SBATTT)

      *? Indicators
     D  EndOfFile      S               N   INZ(*Off)
    ?D  ClockedIn      S               N

      *? Function Prototypes
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date8
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$isHere
    ?D/COPY QFunctDefn,$TimeStamp

      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

    ?
     C                   ExSr      LoadScreen
     C                   DoW       not *InLr
    ?C                   ExSr      Edit01
     C                   EndDo


      *?  ...........................................................
      *?  :      SCRN01 - Display Screen 01                         :
      *?  :.........................................................:

     C     SCRN01        BegSR

    ?C                   Write     MSGCTL                                       ?
     C                   ExFmt     SOW03001
    ?C                   ExSr      ClrError

     C                   EndSr


      *?  ...........................................................
      *?  :      Load01     - Load Screen 1                         :
      *?  :.........................................................:

     C     LoadScreen    BegSr

      *? No loading required for Screen 01

     C                   EndSr


      *?  ...........................................................
      *?  :      EDIT01 - Edit Screen 01                            :
      *?  :.........................................................:

     C     EDIT01        BegSR

     C                   If        Tag < 999999 and Tag > 0
     C                   Eval      TimeCard = Tag
     C                   Call      '#EMPFILE#'
     C                   Parm                    TimeCard
     C                   Parm                    File#             6 0
     C                   Parm                    name             25
     C                   Eval      ClockedIn = $isHere(TimeCard:'R')
     C                   If        not ClockedIn
     C                   ExSr      ClockSR
     C                   EndIf
     C                   Eval      Tag = *Zeros
     C                   ExSr      Scrn01
     C                   Else
     C                   If        Tag > 999999
    ?C     Tag           SetLL     FTRAY                                  31
    ?C     Tag           SetLL     FTRAYR                                 32
     C                   EndIf

    ?C                   Select
    ?C                   When      *In03 or *In07
     C                   Eval      *InLr = *On

    ?C                   When      *In05
    ?C                   ExSr      Count
     C                   Eval      MessageID   = 'SOW0304'
     C                   Eval      MessageDta  = %Char(Remaining)
     C                   ExSr      SndError
     C                   ExSr      Scrn01

    ?C                   When      *In09
     C                   Call      'SOW035'
     C                   Parm                    OperType                       |Type of Operation
    ?C                   ExSr      Count
     C                   Eval      MessageID   = 'SOW0304'
     C                   Eval      MessageDta  = %Char(Remaining)
     C                   ExSr      SndError
     C                   ExSr      Scrn01

    ?C                   When      Tag = *Zero
     C                   Eval      MessageID   = 'SOW0301'
      *  Enter the Tray Tag number to be comfirmed.
     C                   ExSr      SndError
     C                   ExSr      Scrn01

    ?C                   When      %Equal(FTRAY)
     C                   If        %Equal(FTRAYR)
    ?C     Tag           Chain     FTRAYR
    ?C                   Delete    RTRAYR
     C                   EndIf
     C                   Eval      MessageID   = 'SOW0303'
     C                   Eval      MessageDta  = %Char(Tag)
      *  The Tray Tag number ( &1 ) has already been scanned.
     C                   ExSr      SndError
     C                   ExSr      Scrn01

    ?C                   When      not %Equal(FTRAYR)
     C                   Eval      MessageID   = 'SOW0302'
     C                   Eval      MessageDta  = %Char(Tag)
      *  The Tray Tag number ( &1 ) is not valid.  Check the number and try again.
     C                   ExSr      SndError
     C                   ExSr      Scrn01

    ?C                   Other
    ?C     Tag           Chain     FTRAYR
     C                   Eval      TRSTAT = 'A'
     C                   Eval      TRREAS = *Blank
     C                   Eval      TRLIN# = 3
     C                   Eval      TRDTLA = $MDYDate($Date(0))
     C                   Eval      TRUSER = $User()
     C                   Time                    TRTIME
    ?C                   Write     RTRAY
    ?C                   Delete    RTRAYR
      * ? Update Seed Inventory if the Operation Type is (R)ecip.
     C                   If        OperType = 'R'
     C                   ExSr      UpdateInv
     C                   ExSr      AddUserTray
     C                   EndIf
     C                   Eval      LastTag = Tag
     C                   Eval      Tag = *Zero
     C                   ExSr      Scrn01
    ?C                   EndSl
     C                   EndIf


     C                   EndSr


      *?  ...........................................................
      *?  :      UpdateInv - Update Inventory                       :
      *?  :.........................................................:

     C     UpdateInv     BegSR

      * ? Chain to Size Master to get Tray Size Information
    ?C     TRSIZE        CHAIN     FMSIZE
     C                   If        %Found(FMSIZE)
     C                   Z-ADD     SZCELL        Cell_Tray                      ?CELLS PER TRAY
     C                   ENDIF
      * ? Chain to Item Master to Get Seeds per Cell
    ?C     ItemKey       CHAIN     FMINVT
     C                   If        %Found(FMINVT)
     C                   Z-ADD     IM#SED        Seed_Cell                      ?SEEDS PER CELL
     C                   ENDIF
      * ? Chain to Seed Item to Get Sow Factor
    ?C     SeedKey       CHAIN     FMINVT
     C                   If        %Found(FMINVT)
      * ? Calculate Number of Seeds Used
     C                   Eval      Factor = ( 1 + (IMMULT/100))
     C                   Eval      Seeds = Factor * Cell_Tray * Seed_Cell
      * ? Update Seed Inventory on Inventory Master
     C                   Eval      IMQTOH = IMQTOH - Seeds
     C                   Eval      IMISSU = IMISSU + Seeds
    ?C                   Update    RMINVT
     C                   ENDIF
      * ? Update Seed Inventory on P.O. Inventory Master
    ?C     WhseKey       CHAIN     KPITMWHS                           98
     C                   If        %Found(KPITMWHS)
     C                   SUB       SEEDS         IWQTOH
    ?C                   UPDATE    ITMWHSR
     C                   ELSE
     C                   Eval      IWPITM = TRITEM
     C                   Eval      IWSIZE = 'SED'
     C                   Eval      IWWHSE = 1
     C                   Eval      IWQTOH = -Seeds
    ?C                   WRITE     ITMWHSR
     C                   ENDIF

      * ? Write P.O. System Transaction History Record
     C                   Eval      DHPITM = TRITEM                              ?D/G ITEM NUMBER
     C                   Eval      DHTQTY = Seeds                               ?Opening Bal
    ?C                   WRITE     DGHISTR
      * ? Add to Lot Inventory
     C                   Call      'ADDLOTINV'
     C                   Parm      TAG           StartTag#
     C                   Parm      TAG           EndTag#
      * ? Confirm Good Flat
     C                   Call      '#GOODFLAT'
     C                   Parm      TAG           StartTag#

     C                   EndSr


      *?  ...........................................................
      *?  :      AddUserTray - ADD TO USERS TRAY COUNT              :
      *?  :.........................................................:

     C     AddUserTray   BegSR

      *? Write the SownBy record.
    ?C     TAG           Chain     FSOWNBY
      * ? If already sown, take credit away from prior sower.
     C                   If        %Found(FSOWNBY)
    ?C                   Call      '#ADDUSRTRY'
    ?C                   Parm      SBCARD        EMFILE            9 0
    ?C                   Parm                    MINUSTRAY
    ?C                   Parm      'R'           OperType          1
    ?C                   Parm      SBATTT        AttTimestamp
     C                   EndIf
      * ? Credit Sower for producing flat.
     C                   Eval      EMFILE = TimeCard
     C                   Call      '#EMPFILE#'
     C                   Parm                    TimeCard
     C     EMFILE        Parm                    File#
     C                   Parm                    name             25
     C                   Time                    AttTimestamp
    ?C                   Call      '#ADDUSRTRY'
    ?C                   Parm      EMFILE        File#
    ?C                   Parm                    PLUSTRAY
    ?C                   Parm      'R'           OperType
    ?C                   Parm                    AttTimestamp
      * ? Write/Update produced by record.
     C                   Eval      SBTAG# = TAG
     C                   Eval      SBCARD = EMFILE                               Using File# now !!!
     C                   Eval      SBPROG = 'SOW030'
     C                   Eval      SBUSER = $User()
     C                   Eval      SBTIME = $TimeStamp()
     C                   Time                    SBDATE
     C                   Time                    SBSTIM
     C                   Eval      SBSOWT = 'R'
     C                   Eval      SBATTT = AttTimestamp
     C                   If        %Found(FSOWNBY)
    ?C                   Update    RSOWNBY
     C                   Else
    ?C                   Write     RSOWNBY
     C                   EndIf

     C                   EndSr


      *?  ...........................................................
      *?  :      Count  - Count un-confirmed Trays                  :
      *?  :.........................................................:

     C     Count         BegSR

    ?c/exec sql
    ?c+
    ?c+  DELETE FROM FTRAYR A
    ?c+  WHERE A.TRTAG# in (Select B.TRTAG# from FTRAY B)
    ?c+
    ?c/end-exec

    ?C                   Select
    ?C                   When      OperType = 'R'                               ?Recip Sowing
    ?c/exec sql
    ?c+
    ?c+  SELECT   count(*)
    ?c+  INTO     :Remaining
    ?c+  FROM     FTRAYR, FMINVT
    ?c+  WHERE    TRITEM = IMITEM
    ?c+    and    TRSIZE = IMSIZE
    ?c+    and    IMTPSW not in ('R','P')
    ?c+
    ?c/end-exec

    ?C                   When      OperType = 'C'                               ?Rooted Cuttings
    ?c/exec sql
    ?c+
    ?c+  SELECT   count(*)
    ?c+  INTO     :Remaining
    ?c+  FROM     FTRAYR, FMINVT
    ?c+  WHERE    TRITEM = IMITEM
    ?c+    and    TRSIZE = IMSIZE
    ?c+    and    IMTPSW = 'R'
    ?c+
    ?c/end-exec

    ?C                   When      OperType = 'T'                               ?Transplant
    ?c/exec sql
    ?c+
    ?c+  SELECT   count(*)
    ?c+  INTO     :Remaining
    ?c+  FROM     FTRAYR, FMINVT
    ?c+  WHERE    TRITEM = IMITEM
    ?c+    and    TRSIZE = IMSIZE
    ?c+    and    IMTPSW = 'P'
    ?c+
    ?c/end-exec

    ?C                   EndSl

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
     C                   Parm      'SOW030'      PgmQ             10            ?Pgm Msg Queue
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
      *?  :      CLOCKSR - Clockin Subroutine                       :
      *?  :.........................................................:
     C     CLOCKSR       BEGSR
     C                   If        TimeCard = *Zero
     C                   Eval      *In57 = *Off
     C                   Else
     C                   Eval      *In57 = *On
     C                   EndIf

     C                   Eval      ClockedIn = $isHere(TimeCard:'R')

     C                   DoW       not ClockedIn and not *In03

     C                   Write     SOW03001
     C                   EXFMT     CLOCKIN
     C                   Call      '#EMPFILE#'
     C                   Parm                    TimeCard
     C                   Parm                    File#             6 0
     C                   Parm                    name             25

     C                   Select

     C                   When      *In03
     C                   Eval      *InLR = *On

     C                   When      TimeCard = 0
     C*                  Do Nothing

     C                   When      not ClockedIn and not *In57
     C                   Eval      *In57 = *On

     C                   When      *In01
     C                   If        File# <> 0
     C                   Call      '#ATTEND'
     C                   Parm                    File#
     C                   Parm      'I'           NewStat           1
     C                   Parm      'R'           NewType           1
     C                   EndIf

     C                   EndSL

     C                   Eval      ClockedIn = $isHere(TimeCard:'R')

     C                   EndDo

     C   LR              Return

     C                   ENDSR

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *InzSr        BegSR

     C     *Entry        PList
     C                   Parm                    OperType          1            |Type of Operation

     C     ItemKey       KList
     C                   KFld                    TRITEM
     C                   KFld                    TRSIZE

     C     SeedKey       KList
     C                   KFld                    TRITEM
     C                   KFld                    SED

     C     WhseKey       KList
     C                   KFld                    TRITEM
     C                   KFld                    SED
     C                   KFld                    KPWHSE

    ?C                   Select
    ?C                   When      OperType = 'R'
     C                   Eval      *In61 = *On                                  ?Recip. Sowing
    ?C                   When      OperType = 'C'
     C                   Eval      *In62 = *On                                  ?Rooted Cuttings
    ?C                   When      OperType = 'T'
     C                   Eval      *In63 = *On                                  ?Transplanting
    ?C                   EndSl
      *? Initialize History File information
     C                   Eval      DHPSIZ = 'SED'                               ?SIZE
     C                   Eval      DHCYMD = $DATE8($DATE(0))                    ?DATE AS CCYYMMDD
     C                   Eval      DHTRAN = 'I'                                 ?TRANS TYPE
     C                   Eval      DHTYPE = 'Issue (Sown Recip.)'               ?TYPE OF TRANSACTION
     C                   Eval      DHFWHS = '01'                                ?DFT RECV WAREHOUSE
     C                   Eval      DHTWHS = 0                                   ?DFT RECV WAREHOUSE
     C                   Eval      DHPPRC = 0                                   ?LAST PRICE
     C                   Eval      DHPOYR = 0                                   ?JOBBER PO YEAR
     C                   Eval      DHDGPO = 0                                   ?JOBBER PO NUMBER
     C                   Eval      DHCLOK = 0                                   ?Employee Number
     C                   Eval      DHUSER = $USER()                             ?USER

    ?C                   ExSr      ClrError
    ?C                   ExSr      Count
     C                   Eval      MessageID   = 'SOW0304'
     C                   Eval      MessageDta  = %Char(Remaining)
     C                   ExSr      SndError
     C                   Write     SOW03001
     C                   Eval      TimeCard = *Zeros
     C                   EXSR      CLOCKSR
     C                   ExSr      Scrn01

     C                   EndSR
