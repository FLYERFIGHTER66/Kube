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

     FFTRAYR    UF   E           K DISK
     FFTRAY     UF A E           K DISK
     FFMSIZE    IF   E           K DISK
     FFMEMPLOY  IF   E           K DISK
     FFMINVT    UF   E           K DISK
     FKPITMWHS  UF A E           K DISK
     FFSOWNBY   UF A E           K DISK
     FFMATTEND  UF A E           K DISK
     FKPHIST    O  A E           K DISK
     FFTRAYFIXEDUF A E           K DISK
     FSOW031FM  CF   E             WORKSTN
     F                                     SFILE(SOW03101:RRN01)

      *?  LDA
     D                UDS

      *? Data Areas
     D*FIXCUTTING      DS                  DTAARA(FIXCUTTING)
     D  MarkFixed      S               N   Inz(*Off)                            ?Mark URC Fixed

      *? Fields
     D   RRN01         S              4  0 Inz(0)                               ?SFLRRN Screen 01
    ?D StartTag#       S              8S 0
    ?D EndTag#         S              8S 0
    ?D Tag             S              8S 0
    ?D User            S              8S 0
     D  SED            S              3A   Inz('SED')                           ?Size Code for Seed
     D  Remaining      S              7S 0                                      ?Records Left
     D  Seed_Cell      S                   Like(IM#SED)                         ?SEEDS PER CELL
     D  Cell_Tray      S                   Like(SZCELL)                         ?CELLS PER TRAY
     D  Seeds          S              5S 0                                      ?Seeds Used
     D  Factor         S              7S 6                                      ?Sow Factor
     D  KPWhse         S                   Like(IWWHSE) Inz(1)                  ?Warehouse Number
     D  SownByUser     S              9S 0                                      ?Sown By Key
     D  MinusTray      S              4P 0 Inz(-1)                              ?Minus One Tray
     D  PlusTray       S              4P 0 Inz(+1)                              ?Plus One Tray
     D  AttTimestamp   S                   Like(TFATTT)

      *? Arrays
     D   TagsScan      S              8S 0 Dim(9999) Inz(99999999)              ?Scanned Tags

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
     C                   Write     SOW03101F
     C                   ExFmt     SOW03101C
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

     C                   If        ScanRead < 1000000
     C                   Eval      User = ScanRead
     C                   Else
WHT  C                   If        Tag <> *Zero                                 |Prev not Processed
     C                   Eval      User = *Zero
     C                   ExSr      ProcessTray
     C                   EndIf
     C                   Eval      Tag  = ScanRead
     C                   Eval      User = *Zero
     C                   EndIf

     C                   If        Tag <> *Zero
    ?C     Tag           SetLL     FTRAY                                  31
    ?C     Tag           SetLL     FTRAYR                                 32
     C                   EndIf

    ?C                   Select
    ?C                   When      *In03 or *In07
     C                   Eval      *InLr = *On
    ?C                   When      *In05
     C                   Reset                   TagsScan
     C                   Eval      CartCount = *Zero
     C                   ExSr      Scrn01
    ?C*                  When      *In61 and *In09
    ?C                   When      *In09 and (*In61 OR *In62)
     C                   Call      'SOW035'
WHT  C                   Parm                    OperType                       |Type of Operation
     C                   ExSr      Scrn01
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
     C                   ExSr      AddCartTag
     C                   Eval      Looking4Tag = *Off
     C                   Eval      Looking4Usr = *On
     C                   Eval      MessageID   = 'SOW0303'
     C                   Eval      MessageDta  = %Char(Tag)
      *? The Tray Tag number ( &1 ) has already been scanned.
     C                   ExSr      SndError
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
     C                   ExSr      AddCartTag
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
      *?  :      AddCartTag - Add tray to cart tray counter         :
      *?  :.........................................................:

     C     AddCartTag    BegSR

     C     ScanRead      LookUp    TagsScan                               40    ?
     C                   If        not %Found
     C                   Eval      *In53 = *Off                                 ?Duplicate Ind
     C                   Eval      CARTCOUNT = CARTCOUNT + 1
     C                   Eval      TagsScan(CARTCOUNT) = ScanRead
     C                   Eval      *In54 = *Off                                 ?High Count

     C                   If        CARTCOUNT > 100

     C                   If        CARTCOUNT > 5000
     C                   Eval      CARTCOUNT = *Zero
     C                   Else
     C                   Eval      *In54 = *On                                  ?High Count
     C                   Endif

     C                   Endif

     C                   SortA     TagsScan

     C                   Else
     C                   Eval      *In53 = *On                                  ?Duplicate Ind
     C                   Endif

     C                   EndSr


      *?  ...........................................................
      *?  :      ProcessTray - Process This Tray                    :
      *?  :.........................................................:

     C     ProcessTray   BegSR

    ?C     Tag           Chain     FTRAYR
     C                   If        %found(FTRAYR)
WJB  C                   Eval      TRSTAT = 'A'
WJB  C                   Eval      TRREAS = *Blanks
WJB  C                   If        TRLIN# <> 8
     C                   Eval      TRLIN# = 4
WJB  C                   EndIf
     C                   Eval      TRDTLA = $MDYDate($Date(0))
     C                   Eval      TRUSER = $User()
     C                   Time                    TRTIME
    ?C                   Write     RTRAY
    ?C                   Delete    RTRAYR
     C                   EndIf
     C                   Eval      SownByUser = User
    ?C     Tag           Chain(N)  FTRAY
     C                   If        %Found(FTRAY)
      * ? If already found, subtract from prior user sown by
    ?C     TAG           Chain     FSOWNBY
     C                   If        %Found(FSOWNBY)
     C                   Z-add     SBCARD        EMFILE
     C                   Eval      AttTimeStamp = SBATTT
    ?C                   Call      '#ADDUSRTRY'
    ?C                   Parm                    EMFILE
    ?C                   Parm                    MINUSTRAY
    ?C                   Parm                    OperType
    ?C                   Parm                    AttTimestamp
     C                   EndIf
     C                   Eval      EMFILE = User
     C                   Eval      EMCARD = User
     C                   Call      '#EMPFILE#'
     C                   Parm                    EMCARD
     C                   Parm                    EMFILE
     C                   Parm                    name             25
      * ? Credit Sower for producing flat.
     C                   Time                    AttTimestamp
    ?C                   Call      '#ADDUSRTRY'
    ?C                   Parm                    EMFILE
    ?C                   Parm                    PLUSTRAY
    ?C                   Parm                    OperType
    ?C                   Parm                    AttTimestamp
      * ? Write/Update produced by record.
     C                   Eval      SBTAG# = TAG
     C                   Eval      SBCARD = EMFILE                               Using File# now !!!
     C                   Eval      SBPROG = 'SOW031'
     C                   Eval      SBUSER = $User()
     C                   Eval      SBTIME = $TimeStamp()
     C                   Time                    SBDATE
     C                   Time                    SBSTIM
     C                   Eval      SBSOWT = OperType
     C                   Eval      SBATTT = AttTimestamp
     C                   If        %Found(FSOWNBY)
    ?C                   Update    RSOWNBY
     C                   Else
    ?C                   Write     RSOWNBY
     C                   EndIf
      * ? Add to Lot Inventory
     C                   Call      'ADDLOTINV'
     C                   Parm      TAG           StartTag#
     C                   Parm      TAG           EndTag#
      * ? Populate Last Tag & Last User
     C                   Eval      LastTag  = TAG
     C                   Eval      LastUser = USER
      * ? Update Seed Inventory if the Operation Type is (R)ecip.
     C                   If        OperType = 'R'
     C                   ExSr      UpdateInv
     C                   Else
      * ? if the Operation Type is not (R)ecip. then mark as allready been fixed.
     C     TAG           SetLL     FTRAYFIXED
     C                   If        not %equal(FTRAYFIXED)
     C                   Eval      TFTAG# = TAG
     C                   Eval      TFCART = 99999999
     C                   Eval      TFSTAT = 'A'
     C                   Eval      TFCARD = 2
     C                   Eval      TFTIME = $TimeStamp()
     C                   Eval      TFATTT = AttTimestamp
     C                   If        MarkFixed
    ?C                   Write     RTRAYFIXED
     C                   EndIf
     C                   EndIf
     C                   EndIf
     C                   Add       1             RRN01                          ?
     C                   Eval      EMFILE = User
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
    ?C                   Write     SOW03101                                     ?
     C                   Eval      *In26 = *On
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
     C                   Parm      'SOW031'      PgmQ             10            ?Pgm Msg Queue
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
     C*                  In        FIXCUTTING
    ?C                   When      OperType = 'T'
     C                   Eval      *In63 = *On                                  ?Transplanting
    ?C                   EndSl
     C                   Eval      CARTCOUNT = *Zero                            ?Cart Counter
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
     C*                  ExSr      Load01
     C                   Eval      *IN25 = *Off
     C                   Eval      *IN26 = *Off
     C                   Write     Assume
     C                   Write     SOW03101C
     C*                  ExSr      Scrn01

     C                   EndSR
