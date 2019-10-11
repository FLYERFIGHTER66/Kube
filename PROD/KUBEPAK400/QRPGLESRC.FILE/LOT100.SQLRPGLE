PNK |H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
PNK |H DftActGrp(*no)
PNK |H BndDir('*LIBL/KPFUNCTION')
PNK |H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Tool for Allocation of Fixers &  Un-sown           :?
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
     FLOT100FM  CF   E             WORKSTN
     F                                     SFILE(LOT10001:RRN01)
     F                                     DEVID(WSID)

     FFALITEMLOTUF A E           K DISK
     FFDLOTRDCLTUF A E           K DISK
     FFDLOT     UF   E           K DISK

      *? Function Prototypes
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$DftPrt
    ?D/COPY QFunctDefn,$isFile
    ?D/COPY QFunctDefn,$TimeStamp
    ?D/COPY QFunctDefn,$LastPunch
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,QCmdExc

      *? Arrays
PNK |D*  Cmd           S            100A   Dim(0006) CtData                     ?System Commands

      *? Field Definitions
PNK |D  User           S             10A                                        ?Current User ID
PNK |D  RRN01          S              4  0 Inz(0)                               ?SFLRRN Screen 01
PNK |D  RRN02          S              4  0 Inz(0)                               ?SFLRRN Screen 02
PNK |D  ErrorCount     S              3S 0 Inz(0)                               ?Error Count
PNK |D  ErrorCount01   S              3S 0 Inz(0)                               ?Error Count
PNK |D  ErrorCount02   S              3S 0 Inz(0)                               ?Error Count
PNK |D* Command        S            200A   Inz(*Blanks)                         ?System Command
PNK |D  RecordCount    S              9S 0 INZ(0)
PNK |D  Today          S              6S 0                                      ?Todays Date MDY
PNK |D  Now            S              6S 0                                      ?The Time at *Init
PNK |D  ChainRRN01     S              4S 0 Inz(*Zero)                           ?Key by RRN
PNK |D  Printer        S             10A   Inz('*LAST')                         ?Printer
PNK |D  Program        S             10A                                        ?Program
PNK |D  FileName       S             10A                                        ?File Name for Label
PNK |D  Option         S              1A                                        ?Temp Option

PNK |D  SelLRSOWD      S                   Like(LRSOWD)                         ?Select Sow Date
PNK |D  SelLRCRDY      S                   Like(LRCRDY)                         ?Select Ready Date
PNK |D  SqlLRDESC      S             +2    Like(SelLRDESC)                      ?LRDESC with '%'
PNK |D  SqlLRALPH      S             +2    Like(SelLRALPH)                      ?LRALPH with '%'
PNK |D  SqlSEARCH      S             +2    Like(SEARCH)                         ?Search with '%'

PNK |D  SavLRSOWD6     S                   Like(SelLRSOWD6)                     ?Save SelLRSOWD6
PNK |D  SavLRCRDY6     S                   Like(SelLRCRDY6)                     ?Save SelLRCRDY6
PNK |D  SavLRSIZE      S                   Like(LRSIZE)                         ?Save SelLRSIZE
PNK |D  SavLRITEM5     S                   Like(SelLRITEM5)                     ?Save SelLRITEM5
PNK |D  SavLRGLOC      S                   Like(LRGLOC)                         ?Save SelLRGLOC
PNK |D  SavLRCUST      S                   Like(LRCUST)                         ?Save SelLRCUST
PNK |D  SavLRALPH      S                   Like(LRALPH)                         ?Save SelLRALPH
PNK |D  SavLRDESC      S                   Like(LRDESC)                         ?Save SelLRDESC
PNK |D  SavSEARCH      S                   Like(SEARCH)                         ?Save SEARCH

      *? Indicators
PNK |D  Done02         S               N   INZ(*Off)
PNK |D  EndOfFile      S               N   INZ(*Off)
PNK |D  DetailChange   S               N   INZ(*Off)

      *? Data Areas
PNK |D  Read01DS       DS
PNK |D   C1_LRSOWD                         Like(LRSOWD)
PNK |D   C1_LRCRDY                         Like(LRCRDY)
PNK |D   C1_LRSIZE                         Like(LRSIZE)
PNK |D   C1_LRITEM                         Like(LRITEM)
PNK |D   C1_LRALPH                         Like(LRALPH)
PNK |D   C1_LRGLOC                         Like(LRGLOC)
PNK |D   C1_LRCUST                         Like(LRCUST)
PNK |D   C1_LRQTOH                         Like(LRQTOH)
PNK |D   C1_LRQTAL                         Like(LRQTAL)
PNK |D   C1_LRQTAV                         Like(LRQTAV)
PNK |D   C1_LRDESC                         Like(LRDESC)

      /Free
    ?   /COPY QFunctDefn,LASTUSEDCB
      /End-Free
     C     *INLR         DOUEQ     *ON                                          ?COMMENT

    ?C                   SELECT                                                 ?
    ?C     Screen        WhenEq    1                                            ?
     C                   ExSr      Edit01                                       ?
    ?C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
     C                   Eval      *In25 = *On                                  ?
    ?C                   Write     ASSUME
    ?C                   Write     LOT10001F                                   ?
     C                   If        ErrorCount01 <> *Zero                        ?Error Count
    ?C                   Write     MSGCTL                                       ?
     C                   EndIf
    ?C                   ExFmt     LOT10001C                                    ?
     C                   ExSr      ClrError                                     ?
     C                   Eval      ErrorCount01 = *Zero                         ?Error Count
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

      *? Poplate Sav_Fields so that future changes can be detected
     C                   Eval      SavLRSOWD6 = SelLRSOWD6
     C                   Eval      SavLRCRDY6 = SelLRCRDY6
     C                   Eval      SavLRSIZE  = SelLRSIZE
     C                   Eval      SavLRITEM5 = SelLRITEM5
     C                   Eval      SavLRGLOC  = SelLRGLOC
     C                   Eval      SavLRCUST  = SelLRCUST
     C                   Eval      SavLRALPH  = SelLRALPH
     C                   Eval      SavSEARCH  = SEARCH

      *? Format Wildcard Field Criteria
     C                   Eval      SqlLRDESC  = '%' + %Trim(SelLRDESC) + '%'
     C                   Eval      SqlLRALPH  = '%' + %Trim(SelLRALPH) + '%'
     C                   Eval      SqlSEARCH  = '%' + %Trim(SEARCH) + '%'

      *? Format Date7 Criteria
     C                   If        SelLRSOWD6 = *Zero
     C                   Eval      SelLRSOWD  = *Zero
     C                   Else
     C                   Eval      SelLRSOWD  = $Date7($DateMDY(SelLRSOWD6))
     C                   EndIf

     C                   If        SelLRCRDY6 = *Zero
     C                   Eval      SelLRCRDY  = *Zero
     C                   Else
     C                   Eval      SelLRCRDY  = $Date7($DateMDY(SelLRCRDY6))
     C                   EndIf

      *? Clear the Subfile
     C                   Eval      Option = *Blanks
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
    ?C                   Write     LOT10001C                                    ?

      *? Load the Subfile
     C*                  Eval      *In28 = *On                                  ?Write w/ SFLNXTCHG

     C                   Z-add     *Zero         RRN01                          ?
     C                   Z-add     *Zero         RELEASEQTY                     ?
     C                   Z-add     *Zero         UPDATEQTY
     C                   Z-add     *Zero         RecordCount
RED |C                   ExSr      GetData01
    ?C                   ExSr      ReadData01                                   ?
PNK |C                   DoW       not EndOfFile and RRN01 < 9999
      *? Load screen fields
     C                   If        LRSOWD   = *Zero
     C                   Eval      LRSOWD6  = *Zero
     C                   Else
     C                   Eval      LRSOWD6  = $MDYDate($Date(LRSOWD))
     C                   EndIf
     C                   If        LRCRDY   = *Zero
     C                   Eval      LRCRDY6  = *Zero
     C                   Else
     C                   Eval      LRCRDY6  = $MDYDate($Date(LRCRDY))
     C                   EndIf
     C                   Eval      LRITEM5  = LRITEM
     C                   Eval      LRQTOH5  = LRQTOH
     C                   Eval      LRQTAL5  = LRQTAL
     C                   Eval      LRQTAV5  = LRQTAV
     C                   If        (LRCUST>= 999990 and *In85 and LRQTOH> 0) or
     C                             (LRCUST= 0 and not *In85 and LRGLOC= ' ')
WHT  C                   Eval      *In84     = *On                              |Enable Rls Quantity
     C                   Else
WHT  C                   Eval      *In84     = *Off                             |Lock Rls Quantity
     C                   EndIf

      *? Write Subfile Record
     C                   Eval      In84 = *In84
     C                   If        *In86 and *In84 or                            84=Release Enabled
     C                             not *In86                                     86=Eligible
     C                   Add       1             RRN01                          ?
    ?C                   Write     LOT10001                                     ?
     C                   Eval      *In26 = *On                                  ?Have Data Indicator
     C                   EndIf
RED |C                   ExSr      ReadData01                                   ?
PNK |C                   EndDo                                                  ?

     C                   IF        *In26 = *On                                  ?
    ?C     RRN01         Chain     LOT10001                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Eval      *In84 = In84
    ?C                   Update    LOT10001                                     ?
     C                   EndIF                                                  ?

     C                   ExSr      CloseData01

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

      *? Process pre-edit Functions F3, F6, F7 & F9
    ?C                   SELECT                                                 ?
      *? Cancel Requested
    ?C                   When         *In03
    ?C                             or *In06
    ?C                             or *In07
     C                   MOVE      *ON           *INLR                          ?
      *? Mouse Click Selection Criteria to add
    ?C                   When          *In10
    ?C                             and CSRRCD = 'LOT10001'
    ?C     SFLCSRRRN     Chain     LOT10001                                     ?
     C                   SELECT                                                 ?
     C                   When      CSRFLD     = 'LRSOWD6'
     C                   Eval      SelLRSOWD6 =  LRSOWD6
     C                   When      CSRFLD     = 'LRCRDY6'
     C                   Eval      SelLRCRDY6 =  LRCRDY6
     C                   When      CSRFLD     = 'LRSIZE '
     C                   Eval      SelLRSIZE  =  LRSIZE
     C                   When      CSRFLD     = 'LRITEM5'
     C                   Eval      SelLRITEM5 =  LRITEM5
     C                   When      CSRFLD     = 'LRALPH '
     C                   Eval      SelLRALPH  =  LRALPH
     C                   When      CSRFLD     = 'LRDESC '
     C                   Eval      SelLRDESC  =  LRDESC
     C                   When      CSRFLD     = 'LRGLOC '
     C                   Eval      SelLRGLOC  =  LRGLOC
     C                   When      CSRFLD     = 'LRCUST '
     C                   Eval      SelLRCUST  =  LRCUST
     C                   EndSl
     C                   ExSr      Load01
     C                   ExSr      Scrn01
      *? Mouse Click Selection Criteria to remove
    ?C                   When          *In10
    ?C                             and CSRRCD = 'LOT10001C'
     C                   SELECT                                                 ?
     C                   When      CSRFLD     = 'SELLRSOWD6'
     C                   Eval      SelLRSOWD6 =  *Zeros
     C                   When      CSRFLD     = 'SELLRCRDY6'
     C                   Eval      SelLRCRDY6 =  *Zeros
     C                   When      CSRFLD     = 'SELLRSIZE '
     C                   Eval      SelLRSIZE  =  *Blanks
     C                   When      CSRFLD     = 'SELLRITEM5'
     C                   Eval      SelLRITEM5 =  *Blanks
     C                   When      CSRFLD     = 'SELLRALPH '
     C                   Eval      SelLRALPH  =  *Blanks
     C                   When      CSRFLD     = 'SELLRDESC '
     C                   Eval      SelLRDESC  =  *Blanks
     C                   When      CSRFLD     = 'SELLRGLOC '
     C                   Eval      SelLRGLOC  = '*  '
     C                   When      CSRFLD     = 'SELLRCUST '
     C                   Eval      SelLRCUST  =  *Zeros
     C                   EndSl
     C                   ExSr      Load01
     C                   ExSr      Scrn01
      *? Toggle Destination
    ?C                   When          *In11
    ?C                             and *In85
WHT  C                   Eval      *In85 = *Off                                 |Allocate
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   When          *In11
    ?C                             and not *In85
WHT  C                   Eval      *In85 = *On                                  |Release
     C                   ExSr      Load01
     C                   ExSr      Scrn01
      *? Toggle All / Eligible
    ?C                   When          *In08
    ?C                             and *In86
WHT  C                   Eval      *In86 = *Off                                 |Show All
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   When          *In08
    ?C                             and not *In86
WHT  C                   Eval      *In86 = *On                                  |Eligible Only
     C                   ExSr      Load01
     C                   ExSr      Scrn01
      *? Refresh/Reselect Requested
    ?C                   When            *In05
    ?C                                or SelLRSOWD6 <> SavLRSOWD6
    ?C                                or SelLRCRDY6 <> SavLRCRDY6
    ?C                                or SelLRSIZE  <> SavLRSIZE
    ?C                                or SelLRITEM5 <> SavLRITEM5
    ?C                                or SelLRGLOC  <> SavLRGLOC
    ?C                                or SelLRCUST  <> SavLRCUST
    ?C                                or SelLRDESC  <> SavLRDESC
    ?C                                or SelLRALPH  <> SavLRALPH
    ?C                                or SEARCH     <> SavSEARCH
     C                   ExSr      Load01
     C                   ExSr      Scrn01
      *? If no Functions, Check for Options.
    ?C                   OTHER                                                  ?
     C                   ExSr      Opts01                                       ?Screen 01 Options
      *? If Update Requested then Update file else redisplay
     C                   If        *In01 = *On  and
     C                             ErrorCount01 = *Zero
     C                   ExSr      UpdateFiles01
     C                   ExSr      Load01
     C                   ExSr      Scrn01
     C                   Else
     C                   If        DetailChange
     C                   ExSr      Load01
     C                   Eval      DetailChange = *Off
     C                   EndIf
     C                   ExSr      Scrn01
     C                   EndIf
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Opts01 - Process Screen 01 Options                 :
      *?  :.........................................................:
    ?C     Opts01        BegSr                                                  ?

    ?C                   ReadC     LOT10001
     C                   DoW       not %EOF(LOT100FM)
     C                   Eval      *In50 = *Off                                 ?Error Indicator
     C                   Eval      *In28 = *Off                                 ?Subfile Next Change
     C                   Eval      *In84 = In84                                 ?Release Qty

    ?C                   Select                                                 ?
    ?C                   When      *In85                                        ?Release to Avail.
      *?  Release to Available
     C                   If        (RELEASEQTY>0 and RELEASEQTY<=LRQTOH5) or
     C                             (RELEASEQTY<0 and -RELEASEQTY<=UPDATEQTY)
     C                   Eval      UPDATEQTY = UPDATEQTY + RELEASEQTY
     C                   Eval      LRQTOH5 = LRQTOH5 - RELEASEQTY
     C                   Eval      LRQTAL5 = LRQTAL5 - RELEASEQTY
     C                   Eval      RELEASEQTY = 0
     C                   Else
     C                   If        RELEASEQTY <> 0
     C                   Eval      MessageID = 'LOT1001'
     C                   Eval      MessageDta = Option
     C                   ExSr      SndError
     C                   Eval      ErrorCount01 = ErrorCount01 + 1              ?Error Count
     C                   Eval      *In50 = *On
     C                   EndIf
     C                   EndIf
    ?C                   When      not *In85                                    ?Alloc. to Fixers
      *?  Allocate to Fixers
     C                   If        (RELEASEQTY>0 and RELEASEQTY<=LRQTAV5) or
     C                             (RELEASEQTY<0 and -RELEASEQTY<=UPDATEQTY)
     C                   Eval      UPDATEQTY = UPDATEQTY + RELEASEQTY
     C                   Eval      LRQTAV5 = LRQTAV5 - RELEASEQTY
     C                   Eval      LRQTOH5 = LRQTOH5 - RELEASEQTY
     C                   Eval      RELEASEQTY = 0
     C                   Else
     C                   If        RELEASEQTY <> 0
     C                   Eval      MessageID = 'LOT1002'
     C                   Eval      MessageDta = Option
     C                   ExSr      SndError
     C                   Eval      ErrorCount01 = ErrorCount01 + 1              ?Error Count
     C                   Eval      *In50 = *On
     C                   EndIf
     C                   EndIf
    ?C                   EndSl
     C                   Eval      *In28 = *On                                  ?Subfile Next Change
     C                   Eval      *In84 = In84                                 ?Release Qty
    ?C                   Update    LOT10001
    ?C                   ReadC     LOT10001
     C                   EndDo

    ?C                   EndSr                                                  ?




      *?  ...........................................................
      *?  :      ClrError - Clear Error Message Subfile             :
      *?  :.........................................................:
    ?C     ClrError      BegSr                                                  ?

     C                   MOVE      'C'           SndClr
     C                   ExSr      SRMSGF                                       ?
     C                   Eval      ErrorCount = *Zero                           ?Error Count
     C                   Eval      *In50 = *Off                                 ?Error Indicator

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      SndError - Send an Error Message to the PGMMSGQ    :
      *?  :.........................................................:
    ?C     SndError      BegSr                                                  ?

     C                   MOVE      'S'           SndClr
     C                   ExSr      SRMSGF                                       ?
     C                   Eval      ErrorCount = ErrorCount + 1                  ?Error Count
     C                   Eval      *In50 = *On                                  ?Error Indicator

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      * ? :      SRMSGF - Clear or send messages to Pgm msg queue   :
      *?  :.........................................................:
    ?C     SRMSGF        BegSr                                                  ?

      *? Define Parameter List - define variables         ?

     C     MessageParm   PLIST                                                  ?
     C                   Parm      'LOT100'      PgmQ             10            ?Pgm Msg Queue
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
      *?  :      GetData01 - Run SQL to select Data for Screen 01   :
      *?  :.........................................................:

     C     GetData01     BegSr

      *? Get FDLOTRD Data matching request
    ?c/exec sql
    ?c+
    ?c+  DECLARE   C1 cursor for
    ?c+
    ?c+    SELECT        LRSOWD
    ?c+         ,        LRCRDY
    ?c+         ,        LRSIZE
    ?c+         ,        LRITEM
    ?c+         ,        LRALPH
    ?c+         ,        LRGLOC
    ?c+         ,        LRCUST
    ?c+         ,        LRQTOH
    ?c+         ,        LRQTAL
    ?c+         ,        LRQTAV
    ?c+         ,        LRDESC
    ?c+
    ?c+    FROM          FDLOTRD
    ?c+
    ?c+    WHERE       ( LRSOWD   =       :SelLRSOWD  or :SelLRSOWD  = 0    )
    ?c+      and       ( LRCRDY   =       :SelLRCRDY  or :SelLRCRDY  = 0    )
    ?c+      and       ( LRSIZE   =       :SelLRSIZE  or :SelLRSIZE  = ' '  )
    ?c+      and       ( LRITEM   =       :SelLRITEM5 or :SelLRITEM5 = ' '  )
    ?c+      and       ( LRALPH like Trim(:SqlLRALPH) or :SelLRALPH  = ' '  )
    ?c+      and       ( LRDESC like Trim(:SqlLRDESC) or :SelLRDESC  = ' '  )
    ?c+      and       ( LRGLOC   =       :SelLRGLOC  or :SelLRGLOC  = '*'  )
    ?c+      and       ( LRCUST   =       :SelLRCUST  or :SelLRCUST  = 0    )
    ?c+      and       ( LRALPH like Trim(:SqlSearch) or
    ?c+                  LRDESC like Trim(:SqlSearch) or
    ?c+                                                  :SqlSearch  = ' '  )
    ?c+
    ?c+    ORDER BY      LRALPH, LRSIZE, LRITEM
    ?c+
    ?c+  For Read only
    ?c+
    ?c/end-exec

     ?*  Open the SQL recordset
    ?c/exec sql
    ?c+                  Open      C1
    ?c/end-exec

     C                   EndSr

      *?  ...........................................................
      *?  :      CloseData01 - Close the Screen 01 Data Set         :
      *?  :.........................................................:

     C     CloseData01   BegSr

     ?*  Close the SQL recordset
    ?c/exec sql
    ?c+                  Close     C1
    ?c/end-exec

     C                   EndSr

      *?  ...........................................................
      *?  :      ReadData01 - Read Data for Screen 01               :
      *?  :.........................................................:

     C     ReadData01    BegSr

     ?*  Read Sow Schedule Records for Selected Week
    ?c/exec sql
    ?c+ Fetch C1 into :Read01DS
    ?c/end-exec

     C                   If        SQLSTT = '02000'                             ?Read until EOF
     C                   Eval      EndOfFile = *On
     C                   Else
     C                   Eval      EndOfFile = *Off
     C                   Eval      RecordCount = RecordCount + 1                ?Record Count
     C                   EVAL      LRSOWD   = C1_LRSOWD
     C                   EVAL      LRCRDY   = C1_LRCRDY
     C                   EVAL      LRSIZE   = C1_LRSIZE
     C                   EVAL      LRITEM   = C1_LRITEM
     C                   EVAL      LRALPH   = C1_LRALPH
     C                   EVAL      LRGLOC   = C1_LRGLOC
     C                   EVAL      LRCUST   = C1_LRCUST
     C                   EVAL      LRQTOH   = C1_LRQTOH
     C                   EVAL      LRQTAL   = C1_LRQTAL
     C                   EVAL      LRQTAV   = C1_LRQTAV
     C                   EVAL      LRDESC   = C1_LRDESC
     C                   EndIf

     C                   EndSr


      *?  ...........................................................
      *?  :      UpdateFiles01 - Screen 01 File Updates             :
      *?  :.........................................................:
    ?C     UpdateFiles01 BegSr                                                  ?

     C                   Eval      ChainRRN01 = 1
    ?C     ChainRRN01    Chain     LOT10001
     C                   DoW       %Found(LOT100FM)

WHT  C                   If        *In85 = *On                                  |Release
      *?   Release Inventory to the *Zero Record on FDLOTRD, Update FDLOT & FALITEM.
    ?C                   ExSr      Rls2Avail
     C                   Else
      *?   Allocate Inventory back to the 999999 Record on FDLOTRD, Update FDLOT & FALITEM.
    ?C                   ExSr      Aloc2Fix
     C                   EndIf

     C                   Eval      ChainRRN01 =  ChainRRN01 + 1
     C     ChainRRN01    Chain     LOT10001
     C                   EndDo

     C                   EndSr


      *?  ...........................................................
      *?  :      Rls2Avail - Release to Avaiable                    :
      *?  :.........................................................:
    ?C     Rls2Avail     BegSr                                                  ?

      *?   Release Inventory to the *Zero Record on FDLOTRD, Update FDLOT & FALITEM.
      *?     FALITEM
     C                   Eval      AIORD# = LRCUST
     C                   Eval      AIOSEQ = *Zero
     C                   Eval      AIGLOC = *Blanks
    ?C     KeyALITEM     Chain     FALITEMLOT
     C                   If        %Found(FALITEMLOT)
     C                   Eval      AIQTOA = AIQTOA - UPDATEQTY
    ?C                   Update    RALITEM
     C                   EndIf
      *?     FDLOTRD 999990+ record
    ?C     KeyLotRD      Chain     FDLOTRDCLT
     C                   If        %Found(FDLOTRDCLT)
     C                   Eval      LRQTOH = LRQTOH - UPDATEQTY
     C                   Eval      LRQTAL = LRQTAL - UPDATEQTY
    ?C                   Update    RDLOTRD
     C                   EndIf
      *?     FDLOTRD *Zero record
     C                   Eval      LRCUST = *Zero
    ?C     KeyLotRD      Chain     FDLOTRDCLT
     C                   If        %Found(FDLOTRDCLT)
     C                   Eval      LRQTOH = LRQTOH + UPDATEQTY
     C                   Eval      LRQTAV = LRQTAV + UPDATEQTY
    ?C                   Update    RDLOTRD
     C                   Else
     C                   Eval      LRQTOH = UPDATEQTY
     C                   Eval      LRQTAV = UPDATEQTY
     C                   Eval      LRQTAL = *Zero
    ?C                   Write     RDLOTRD
     C                   EndIf
      *?     FDLOT
    ?C     KeyLot        Chain     FDLOT
     C                   If        %Found(FDLOT)
     C                   Eval      LDQTAL = LDQTAL - UPDATEQTY
     C                   Eval      LDQTAV = LDQTAV + UPDATEQTY
    ?C                   Update    RDLOT
     C                   EndIf

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Aloc2Fix  - Allocate to Fixing                     :
      *?  :.........................................................:
    ?C     Aloc2Fix      BegSr                                                  ?

      *?   Allocate Inventory back to the 999999 Record on FDLOTRD, Update FDLOT & FALITEM.
      *?     FDLOTRD *Zero record
    ?C     KeyLotRD      Chain     FDLOTRDCLT
     C                   If        %Found(FDLOTRDCLT)
     C                   Eval      LRQTOH = LRQTOH - UPDATEQTY
     C                   Eval      LRQTAV = LRQTAV - UPDATEQTY
    ?C                   Update    RDLOTRD
     C                   EndIf
      *?     FDLOT
    ?C     KeyLot        Chain     FDLOT
     C                   If        %Found(FDLOT)
     C                   Eval      LDQTAL = LDQTAL + UPDATEQTY
     C                   Eval      LDQTAV = LDQTAV - UPDATEQTY
    ?C                   Update    RDLOT
     C                   EndIf
      *?     FDLOTRD 999990+ record
     C                   Eval      LRCUST = 999999
    ?C     KeyLotRD      Chain     FDLOTRDCLT
     C                   If        %Found(FDLOTRDCLT)
     C                   Eval      LRQTOH = LRQTOH + UPDATEQTY
     C                   Eval      LRQTAL = LRQTAL + UPDATEQTY
    ?C                   Update    RDLOTRD
     C                   Else
     C                   Eval      LRQTOH = UPDATEQTY
     C                   Eval      LRQTAL = UPDATEQTY
     C                   Eval      LRQTAV = *Zero
    ?C                   Write     RDLOTRD
     C                   EndIf
      *?     FALITEM 999990+ record UPD/WRT
     C                   Eval      AIORD# = LRCUST
     C                   Eval      AIOSEQ = *Zero
     C                   Eval      AIGLOC = *Blanks
    ?C     KeyALITEM     Chain     FALITEMLOT
     C                   If        %Found(FALITEMLOT)
     C                   Eval      AIQTOA = AIQTOA + UPDATEQTY
    ?C                   Update    RALITEM
     C                   Else
     C                   Eval      AIORD# = 999999
     C                   Eval      AIOSEQ = *Zero
     C                   Eval      AISHPD = LRCRDY
     C                   Eval      AISTAT = LRSTAT
     C                   Eval      AIITEM = LRITEM
     C                   Eval      AISIZE = LRSIZE
     C                   Eval      AIWHSE = LRWHSE
     C                   Eval      AISOWD = LRSOWD
     C                   Eval      AIGLOC = LRGLOC
     C                   Eval      AIPHYT = LRPHYT
     C                   Eval      AICRDY = LRCRDY
     C                   Eval      AICUST = LRCUST
     C                   Eval      AICOMP = LRCOMP
     C                   Eval      AIQTOA = UPDATEQTY
     C                   Eval      AIDTLA = Today
     C                   Eval      AITIME = $now()
     C                   Eval      AIUSER = $User()
     C                   Eval      AIPRCL = LRPRCL
    ?C                   Write     RALITEM
     C                   EndIf

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C     *Entry        PList
     C                   Parm                    OperType          1

    ?C     KeyALITEM     KList                                                  ?
    ?C                   KFld                    LRITEM
    ?C                   KFld                    LRSIZE
    ?C                   KFld                    LRWHSE
    ?C                   KFld                    LRSOWD
    ?C                   KFld                    LRCRDY
    ?C                   KFld                    LRCUST
    ?C                   KFld                    AIORD#
    ?C                   KFld                    AIOSEQ
    ?C                   KFld                    AIGLOC
    ?C     KeyLotRD      KList                                                  ?
    ?C                   KFld                    LRITEM
    ?C                   KFld                    LRSIZE
    ?C                   KFld                    LRWHSE
    ?C                   KFld                    LRSOWD
    ?C                   KFld                    LRCRDY
    ?C                   KFld                    LRCUST
    ?C                   KFld                    LRGLOC
    ?C     KeyLot        KList                                                  ?
    ?C                   KFld                    LRITEM
    ?C                   KFld                    LRSIZE
    ?C                   KFld                    LRWHSE
    ?C                   KFld                    LRSOWD
    ?C                   KFld                    LRGLOC
    ?C                   KFld                    LRCRDY

     C     #ChgPrt       PList
     C                   Parm                    User
     C                   Parm                    Program
     C                   Parm      '*LAST'       Printer

     C                   Eval      User  = $User()
     C                   Eval      Program = 'LOT100'
     C                   Eval      Today = $MDYDate($Date(0))

     C                   Time                    Now
     C                   Eval      *In85 = *On
     C                   Eval      *In86 = *On
     C                   Eval      SelLRGLOC = '*  '
     C                   Eval      SavLRGLOC = '*  '

     C                   ExSr      Load01                                       ?
     C                   ExSr      ClrError                                     ?
     C                   ExSr      Scrn01                                       ?

      *?  Dummy reads for variable definitions
     C                   Eval      *In99 = *Off
    ?C   99*LoVal        SetLL     FDLOTRDCLT
    ?C   99              Read      FDLOTRDCLT

    ?C                   EndSr                                                  ?
