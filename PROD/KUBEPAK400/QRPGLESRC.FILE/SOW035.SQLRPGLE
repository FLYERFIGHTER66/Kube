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
     FSow035FM  CF   E             WORKSTN
     F                                     SFILE(SOW03501:RRN01)
     F                                     SFILE(SOW03502:RRN02)
     F                                     DEVID(WSID)

     FFMINVT    IF   E           K DISK                                         ?Item Master
     FFOINVT    IF   E           K DISK                                         ?Item Overrides
     FFMSIZE    IF   E           K DISK                                         ?Size Master
     FFTRAYR    IF   E           K DISK                                         ?Tray Master
     FFSOWNBY   UF A E           K DISK                                         ?Sown By
     FLabelFile O    E           K DISK    USROPN                               ?Label File

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
    ?D/COPY QFunctDefn,QCmdExc

      *? Arrays
     D   Cmd           S            100A   Dim(0006) CtData                     ?System Commands

      *? Un-Sown Trays Data Structure
     D  UnSown_DS      DS                  INZ
     D  SowDate                            Like(TRSCYM)                         ?Sow_Date
     D  ReadyDate                          Like(TRCRDT)                         ?Ready_Date
     D  Size                               Like(TRSIZE)                         ?Size
     D  Item                               Like(TRITEM)                         ?Item
     D  Alpha                              Like(TRALPH)                         ?Alpha
     D  Desc01                             Like(IMDES1)                         ?Description
     D  Factor                        5S 3                                      ?Factor
     D  Seed_Cell                          Like(IM#SED)                         ?Seed_Cell
     D  Cell_Tray                          Like(SZCELL)                         ?Cell_Tray
     D  Tray_Count                    4S 0                                      ?Tray_Count
     D  Seed_Need                     7S 0                                      ?Seed_Need
     D  On_Hand                            Like(IMQTOH)                         ?On_Hand
     D  Available                          Like(IMQTAV)                         ?Available
     D  Sow_Method                         Like(IMTPSW)                         ?Sow Method

      *? Un-Sown Trays Data Structure
     D  Tray_DS        DS                  INZ
     D  Tray_Number                        Like(TRTAG#)                         ?Tray Number
     D  Tray_Status                        Like(TRSTAT)                         ?Ready_Date
     D  Tray_Item#                         Like(TRITEM)                         ?Item Number
     D  Tray_Size#                         Like(TRSIZE)                         ?Item Size
     D  Tray_Ready                         Like(TRCRDT)                         ?Ready Date

      *? Field Definitions
     D   User          S             10A                                        ?Current User ID
     D   RRN01         S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   RRN02         S              4  0 Inz(0)                               ?SFLRRN Screen 02
     D   ErrorCount    S              3S 0 Inz(0)                               ?Error Count
     D   ErrorCount01  S              3S 0 Inz(0)                               ?Error Count
     D   ErrorCount02  S              3S 0 Inz(0)                               ?Error Count
     D   Command       S            200A   Inz(*Blanks)                         ?System Command
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
WJB ?D   StartTag#     S              8S 0
WJB ?D   EndTag#       S              8S 0
WJB ?D   AttTimestamp  S                   Like(SBATTT)
     D   SownByUser    S              9S 0                                      ?Sown By Key
     D   MinusTray     S              4P 0 Inz(-1)                              ?Minus One Tray
     D   PlusTray      S              4P 0 Inz(+1)                              ?Plus One Tray
     D   Ready065      S              7S 0                                      ?Ready Date Parm
     D   File#         S              6S 0                                      ?Employee File#

      *? Indicators
     D  Done02         S               N   INZ(*Off)
     D  EndOfFile      S               N   INZ(*Off)
     D  DetailChange   S               N   INZ(*Off)

      /Free
    ?   //COPY QFunctDefn,LASTUSEDCB
      /End-Free
     C     *INLR         DOUEQ     *ON                                          ?COMMENT

    ?C                   SELECT                                                 ?
    ?C     Screen        WhenEq    1                                            ?
     C                   ExSr      Edit01                                       ?
    ?C                   ENDSL                                                  ?

     C                   If        %Open(LabelFile)
     C                   Close     LabelFile
     C                   EndIF

     C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
     C                   Eval      *In25 = *On                                  ?
    ?C                   Write     ASSUME
    ?C                   Write     Sow03501F                                   ?
     C                   If        ErrorCount01 <> *Zero                        ?Error Count
    ?C                   Write     MSGCTL                                       ?
     C                   EndIf
    ?C                   ExFmt     Sow03501C                                    ?
     C                   ExSr      ClrError                                     ?
     C                   Eval      ErrorCount01 = *Zero                         ?Error Count
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn02 - Display Screen 02                         :
      *?  :.........................................................:
    ?C     Scrn02        BegSr                                                  ?
     C                   Z-Add     02            Screen            3 0          ?Screen  Number
     C                   Eval      *In35 = *On                                  ?
    ?C                   Write     ASSUME
    ?C                   Write     Sow03502F                                   ?
     C                   If        ErrorCount02 <> *Zero                        ?Error Count
    ?C                   Write     MSGCTL                                       ?
     C                   EndIf
    ?C                   ExFmt     Sow03502C                                    ?
     C                   ExSr      ClrError                                     ?
     C                   Eval      ErrorCount02 = *Zero                         ?Error Count
     C                   Eval      *In35 = *Off                                 ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

      *? Clear the Subfile
     C                   Eval      Option = *Blanks
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
    ?C                   Write     Sow03501C                                    ?

      *? Load the Subfile
     C                   Eval      *In28 = *On                                  ?Write w/ SFLNXTCHG

     C                   Z-add     *Zero         RRN01                          ?
     C                   ExSr      GetData01
    ?C                   ExSr      ReadData01                                   ?
     C                   DoW       not EndOfFile
     C                   Add       1             RRN01                          ?
      *? Load screen fields
     C                   Eval      RdyDate6 = $MDYDate($Date(READYDATE))
     C                   Eval      SowDate6 = $MDYDate($Date(SOWDATE))
     C                   Eval      Item5 = Item
     C                   Eval      S_OnHand = On_Hand
     C                   Eval      Balance  = On_Hand - SEED_NEED
      *? Write Subfile Record
    ?C                   Write     Sow03501                                     ?
     C                   Eval      *In26 = *On                                  ?Have Data Indicator
     C                   ExSr      ReadData01                                   ?
     C                   EndDo                                                  ?

     C                   IF        *In26 = *On                                  ?
    ?C     RRN01         Chain     Sow03501                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    Sow03501                                     ?
     C                   EndIF                                                  ?

     C                   ExSr      CloseData01

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load02 - Load Screen 02                            :
      *?  :.........................................................:
    ?C     Load02        BegSr                                                  ?

      *? Clear the Subfile
     C                   Eval      Option = *Blanks
     C                   Eval      *In35 = *Off                                 ?
     C                   Eval      *In36 = *Off                                 ?
     C                   Eval      *In37 = *Off                                 ?
    ?C                   Write     Sow03502C                                    ?

      *? Load the Subfile
     C                   Eval      *In38 = *On                                  ?Write w/ SFLNXTCHG
     C                   Eval      SowDate7 = $Date7($DateMDY(SowDate6))
     C                   Eval      RdyDate7 = $Date7($DateMDY(RdyDate6))

     C                   Z-add     *Zero         RRN02                          ?
     C                   ExSr      GetData02
    ?C                   ExSr      ReadData02                                   ?
     C                   DoW       not EndOfFile
     C                   Add       1             RRN02                          ?
      *? Load screen fields
     C                   Eval      Tray# = Tray_Number
WJB  C                   Eval      Item# = Tray_Item#
WJB  C                   Eval      Size# = Tray_Size#
WJB  C                   Eval      Ready = Tray_Ready
      *? Set color for Deleted records
     C                   If        Tray_Status = 'D'
     C                   Eval      *In84 = *On
     C                   Eval       In84 = *On
     C                   Eval      *In83 = *Off
     C                   Eval       In83 = *Off
     C                   Else
     C                   Eval      *In84 = *Off
     C                   Eval       In84 = *Off
     C                   Eval      *In83 = *Off
     C                   Eval       In83 = *Off
     C                   EndIf
      *? Write Subfile Record
    ?C                   Write     Sow03502                                     ?
     C                   Eval      *In36 = *On                                  ?Have Data Indicator
     C                   ExSr      ReadData02                                   ?
     C                   EndDo                                                  ?

     C                   IF        *In36 = *On                                  ?
    ?C     RRN02         Chain     Sow03502                                     ?
     C                   Eval      *In37 = *On                                  ?SFLEND Indicator
     C                   Update    Sow03502                                     ?
     C                   EndIF                                                  ?

     C                   ExSr      CloseData02

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
      *? Print Requested
    ?C                   When         *In09
     C                   Call      'SOW035R'
     C                   Parm                    OperType
     C                   ExSr      Scrn01
      *? Refresh Requested
    ?C                   When         *In05
     C                   ExSr      Load01
     C                   ExSr      Scrn01
      *? Change Printer
    ?C                   When      *In10 = *ON                                          ?
     C                   Call      '#CHGPRT'     #ChgPrt
     C                   If        Printer <> '*LAST'
     C                   Eval      PrtToUse = Printer
     C                   Eval      Command = CMD(1)
     C                   ExSr      $Command
     C                   EndIf
     C                   ExSr      Scrn01
      *? If no Functions, Check for Options.
    ?C                   OTHER                                                  ?
     C                   ExSr      Opts01                                       ?Screen 01 Options
      *? If Update Requested then Update file else redisplay
     C                   If        *In01 = *On  and
     C                             ErrorCount01 = *Zero
     C                   ExSr      UpdateFiles01
     C                   Eval      *InLr = *On
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
      *?  :      Edit02 - EDIT Screen 02                            :
      *?  :.........................................................:
    ?C     Edit02        BegSr                                                  ?

      *? Process pre-edit Functions F6
     C                   Eval      Done02 = *Off
    ?C                   SELECT                                                 ?
      *? Cancel Requested
    ?C                   When         *In06
     C                   Eval      Done02 = *On
      *? Refresh Requested
    ?C                   When         *In05
     C                   ExSr      Load02
     C                   ExSr      Scrn02
      *? If no Functions, Check for Options.
    ?C                   OTHER                                                  ?
     C                   ExSr      Opts02                                       ?Screen 02 Options
      *? If Update Requested then Update file else redisplay
     C                   If        *In01 = *On  and
     C                             ErrorCount02 = *Zero
     C                   ExSr      UpdateFiles02
     C                   ExSr      Load02                                       ?Load 02
     C                   EndIf
     C                   ExSr      Scrn02                                       ?Screen 02
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Opts01 - Process Screen 01 Options                 :
      *?  :.........................................................:
    ?C     Opts01        BegSr                                                  ?

    ?C                   ReadC     SOW03501
     C                   DoW       not %EOF(SOW035FM)
     C                   Eval      *In50 = *Off                                 ?Error Indicator
     C                   Eval      *In28 = *Off                                 ?Subfile Next Change
     C                   If        IN81 = *On
     C                   Eval      *In81 = *On
     C                   EndIf
     C                   If        IN82 = *On
     C                   Eval      *In82 = *On
     C                   EndIf
    ?C                   SELECT                                                 ?
      *? Option = '4'  (Deleted... not Sown)
    ?C                   When         Option = '4'
     C                   Eval      *In81 = *Off                                 ?Sown Indicator
     C                   Eval      *In82 = *On                                  ?Deleted Indicator
     C                   Eval      *In28 = *On                                  ?Subfile Next Change
     C                   Eval      Option = *Blanks                             ?Reset Option Field
      *? Option = '5'  (Display Details)
    ?C                   When         Option = '5'
     C                   Eval      DetailChange = *On
     C                   Eval      *In81 = *On                                  ?Sown Indicator
     C                   Eval      *In82 = *On                                  ?Deleted Indicator
     C                   Eval      *In28 = *On                                  ?Subfile Next Change
     C                   Eval      Option = *Blanks                             ?Reset Option Field
     C                   ExSr      Load02                                       ?Load Screen 02
     C                   ExSr      Scrn02                                       ?Display Screen 02
     C                   DoU       Done02
     C                   ExSr      Edit02                                       ?Edit Screen 02
     C                   EndDo
     C     ChainRRN01    Chain     SOW03501
      *? Option = '6'  (Label Print)
    ?C                   When         Option = '6'
     C                   ExSr      FormatLabels
     C                   If        %Open(LabelFile)
     C                   Close     LabelFile
     C                   EndIf
     C                   Eval      Command = %trim(CMD(3)) + ' ' + %trim(CMD(4))
     C                   ExSr      $Command
     C                   Eval      Command = CMD(6)
      * ?CLRPFM FILE(|F~~~~~~~~) MBR(LABELFILE)  ?
     C                   ExSr      $Command
     C                   Eval      *In28 = *On                                  ?Subfile Next Change
      *? Option = '9'  (Reset to Unsown)
    ?C                   When         Option = '9'
     C                   Eval      *In81 = *Off                                 ?Sown Indicator
     C                   Eval      *In82 = *Off                                 ?Deleted Indicator
     C                   Eval      *In28 = *On                                  ?Subfile Next Change
     C                   Eval      Option = *Blanks                             ?Reset Option Field
      *? Option = ' '  (Do not send error on Blanks)
    ?C                   When         Option = ' '
     C                   Eval      *In28 = *On                                  ?Subfile Next Change
      *? Any Other Option is invalid
    ?C                   OTHER                                                  ?
     C                   Eval      MessageID = 'SOW0350'
     C                   Eval      MessageDta = Option
     C                   ExSr      SndError
     C                   Eval      ErrorCount01 = ErrorCount01 + 1              ?Error Count
     C                   Eval      *In50 = *On
     C                   Eval      *In28 = *On
    ?C                   ENDSL                                                  ?
     C   81              Eval      In81 = *On                                   ?Sown Indicator
     C  N81              Eval      In81 = *Off                                  ?Sown Indicator
     C   82              Eval      In82 = *On                                   ?Deleted Indicator
     C  N82              Eval      In82 = *Off                                  ?Deleted Indicator
    ?C                   Update    SOW03501
     C                   Eval      *In28 = *Off                                 ?Subfile Next Change
     C                   Eval      *In81 = *Off                                 ?Sown Indicator
     C                   Eval      *In82 = *Off                                 ?Deleted Indicator
     C                   Eval      In81 = *Off                                  ?Sown Indicator
     C                   Eval      In82 = *Off                                  ?Deleted Indicator
    ?C                   ReadC     SOW03501
     C                   EndDo

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Opts02 - Process Screen 02 Options                 :
      *?  :.........................................................:
    ?C     Opts02        BegSr                                                  ?

    ?C                   ReadC     SOW03502
     C                   DoW       not %EOF(SOW035FM)
     C                   Eval      *In50 = *Off                                 ?Error Indicator
     C                   Eval      *In38 = *Off                                 ?Subfile Next Change
     C                   If        IN83 = *On
     C                   Eval      *In83 = *On
     C                   EndIf
     C                   If        IN84 = *On
     C                   Eval      *In84 = *On
     C                   EndIf
    ?C                   SELECT                                                 ?
      *? Option = '1'  (Sown not Scanned)
    ?C                   When         Option = '1'
     C                   Eval      *In83 = *On                                  ?Sown Indicator
     C                   Eval      *In84 = *Off                                 ?Deleted Indicator
     C                   Eval      *In38 = *On                                  ?Subfile Next Change
     C                   Eval      Option = *Blanks                             ?Reset Option Field
      *? Option = '4'  (Deleted... not Sown)
    ?C                   When         Option = '4'
     C                   Eval      *In83 = *Off                                 ?Sown Indicator
     C                   Eval      *In84 = *On                                  ?Deleted Indicator
     C                   Eval      *In38 = *On                                  ?Subfile Next Change
     C                   Eval      Option = *Blanks                             ?Reset Option Field
      *? Option = '6'  (Label Print)
    ?C                   When         Option = '6'
     C                   ExSr      FormatLabel
     C                   If        %Open(LabelFile)
     C                   Close     LabelFile
     C                   EndIf
     C                   Eval      Command = %trim(CMD(3)) + ' ' + %trim(CMD(4))
     C                   ExSr      $Command
     C                   Eval      Command = CMD(6)
      * ?CLRPFM FILE(|F~~~~~~~~) MBR(LABELFILE)  ?
     C                   ExSr      $Command
     C                   Eval      *In28 = *On                                  ?Subfile Next Change
      *? Option = '9'  (Reset to Unsown)
    ?C                   When         Option = '9'
     C                   Eval      *In83 = *Off                                 ?Sown Indicator
     C                   Eval      *In84 = *Off                                 ?Deleted Indicator
     C                   Eval      *In38 = *On                                  ?Subfile Next Change
     C                   Eval      Option = *Blanks                             ?Reset Option Field
      *? Option = ' '  (Do not send error on Blanks)
    ?C                   When         Option = ' '
     C                   Eval      *In38 = *On                                  ?Subfile Next Change
      *? Any Other Option is invalid
    ?C                   OTHER                                                  ?
     C                   Eval      MessageID = 'SOW0350'
     C                   Eval      MessageDta = Option
     C                   ExSr      SndError
     C                   Eval      ErrorCount02 = ErrorCount02 + 1              ?Error Count
     C                   Eval      *In50 = *On
     C                   Eval      *In38 = *On
    ?C                   ENDSL                                                  ?
     C   83              Eval      In83 = *On                                   ?Sown Indicator
     C  N83              Eval      In83 = *Off                                  ?Sown Indicator
     C   84              Eval      In84 = *On                                   ?Deleted Indicator
     C  N84              Eval      In84 = *Off                                  ?Deleted Indicator
    ?C                   Update    SOW03502
     C                   Eval      *In38 = *Off                                 ?Subfile Next Change
     C                   Eval      *In83 = *Off                                 ?Sown Indicator
     C                   Eval      *In84 = *Off                                 ?Deleted Indicator
     C                   Eval      In83 = *Off                                  ?Sown Indicator
     C                   Eval      In84 = *Off                                  ?Deleted Indicator
    ?C                   ReadC     SOW03502
     C                   EndDo

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      FormatLabel - Write Work File for Label Print      :
      *?  :.........................................................:
    ?C     FormatLabel   BegSr                                                  ?

     C                   If        not %Open(LabelFile)
     C                   Eval      Command = CMD(2)
      * ?OVRDBF FILE(LABELFILE) TOFILE(*LIBL/|F~~~~~~~~)                            ?
     C                   ExSr      $Command
     C                   If        not $isFile(FileName)
     C                   Eval      Command = CMD(5)
      * ?CRTDUPOBJ OBJ(LABELFILE) FROMLIB(*LIBL) OBJTYPE(*FILE) NEWOBJ(|F~~~~~~~~)  ?
     C                   ExSr      $Command
     C                   EndIF
     C                   Open      LabelFile
     C                   EndIF

     C                   Eval      SLITEM = Item5                               ?ITEM #
     C                   Eval      SLSIZE = Size                                ?SIZE
     C                   Eval      SLSOW  = %Int(%Subst(%Char(SOWDATE6):1:4))   ?SOW DATE MMDD
     C                   Eval      SLRDY  = %Int(%Subst(%Char(RDYDATE6):1:4))   ?READY DATE MMDD
     C                   Eval      SLTAG# = TRAY#                               ?TAG NUMBER
     C                   Eval      SLDESC = DESC01                              ?DESCRIPTION

    ?C     ItemSize      KList
    ?C                   KFld                    Item
    ?C                   KFld                    Size

    ?C     ItemSize      CHAIN     FOINVT
     C                   If        %Found(FOINVT)
     C                   MOVE      OVSALE        SALE3             3
     C                   Else
    ?C     Size          CHAIN     FMSIZE
     C                   If        %Found(FMSIZE)
     C                   MOVE      SZSALE        SALE3
     C                   Else
     C                   MOVE      Size          SALE3
     C                   EndIf
     C                   EndIf

     C                   MOVEL     SALE3         SLSIZE

    ?C                   Write     RSOWLAB

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      FormatLabels - Write Multiple Records to Work File :
      *?  :.........................................................:
    ?C     FormatLabels  BegSr                                                  ?

     C                   ExSr      Load02
     C                   Eval      ChainRRN02 = 1
    ?C     ChainRRN02    Chain     SOW03502
     C                   DoW       %Found(SOW035FM)
     C                   ExSr      FormatLabel
     C                   Eval      ChainRRN02 = ChainRRN02 + 1
    ?C     ChainRRN02    Chain     SOW03502
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
     C                   Parm      'SOW035'      PgmQ             10            ?Pgm Msg Queue
     C                   Parm      'KPMSGF'      MsgFile          10            ?Message File
     C                   Parm      '*LIBL'       MsgfLib          10            ?Library
     C                   Parm                    MessageID         7            ?Message Id
     C                   Parm                    MessageDta      100            ?Message Data
     C                   Parm                    MsgKey            4            ?Message Key
     C                   Parm                    SndClr            1            ?Send or Clear

      *? Call Msg processing CL                           ?

     C                   CALL      'XAMSFC'      MessageParm                    ?

    ?C                   EndSr                                                  ?

      *?  ..........................................................
      *?  :   Run system command                                   :
      *?  :........................................................:
     C     $Command      BegSR
      *? Format the command String.  Put variable in place in the string.

      *?   |P?=Printer ID?    ?Put the Printer Name in the Override command?
     C                   Eval      Printer = PrtToUse
     C                   DoW       %Scan('|P':Command) <> 0
     C                   Eval      Command = %REPLACE
     C                             (%Trim(Printer): Command :
     C                               %SCAN('|P': Command))
     C                   EndDo

      *?   |F?=File Name?     ?Put the File Name in the Command?
     C                   DoW       %Scan('|F':Command) <> 0
     C                   Eval      Command = %REPLACE
     C                             (%Trim(FileName): Command :
     C                               %SCAN('|F': Command))
     C                   EndDo

      *?   ~ ?=Blank that needs to be removed??Replace with nothing?
     C                   DoW       %Scan('~':Command) <> 0
     C                   Eval      Command =
     C                               %SubSt(Command:1:%Scan('~':Command)-1)
     C                             + %SubSt(Command:%Scan('~':Command)+1:
     C                               %Len(Command) - %Scan('~':Command))
     C                   EndDo

      *? Execute the Command using QCMDEXC.
     C                   CALLP     QCmdExc(Command:%len(%Trim(Command)))

     C                   EndSR


      *?  ...........................................................
      *?  :      GetData01 - Run SQL to select Data for Screen 01   :
      *?  :.........................................................:

     C     GetData01     BegSr

      *? Select Un-confirmed trays from FTRAYR

    ?C                   Select                                                 ?
    ?C                   When      OperType = 'R'                               ?Recip. Sowing
    ?c/exec sql
    ?c+
    ?c+  DECLARE   C1 cursor for
    ?c+
    ?c+    SELECT      Tray.TRSCYM                       as Sow_Date
    ?c+         ,      Tray.TRCRDT                       as Ready_Date
    ?c+         ,      Tray.TRSIZE                       as Size
    ?c+         ,      Tray.TRITEM                       as Item
    ?c+         ,      Tray.TRALPH                       as Alpha
    ?c+         ,      Item.IMDES1                       as Description
    ?c+         ,      DEC(AVG(1+(Seed.IMMULT/100)),5,3) as Factor
    ?c+         ,      INT(AVG(Item.IM#SED))             as Seed_Cell
    ?c+         ,      INT(AVG(Size.SZCELL))             as Cell_Tray
    ?c+         ,      Count(*)                          as Tray_Count
    ?c+         ,      INT(Sum(Round(
    ?c+                    (1+(Float(Seed.IMMULT)/100))
    ?c+                      * Float(Item.IM#SED)
    ?c+                      * Float(Size.SZCELL),0)))   as Seed_Need
    ?c+         ,      Seed.IMQTOH                       as On_Hand
    ?c+         ,      Seed.IMQTAV                       as Available
    ?c+         ,      Item.IMTPSW                       as Sow_Method
    ?c+
    ?c+    FROM        FTRAYR as Tray
    ?c+         ,      FMSIZE as Size
    ?c+         ,      FMINVT as Item
    ?c+         ,      FMINVT as Seed
    ?c+
    ?c+    WHERE       Tray.TRSIZE = Size.SZCODE
    ?c+      and       Tray.TRITEM = Item.IMITEM
    ?c+      and       Tray.TRSIZE = Item.IMSIZE
    ?c+      and       Tray.TRITEM = Seed.IMITEM
    ?c+      and       Seed.IMSIZE = 'SED'
    ?c+      and       Item.IMTPSW not in ('R', 'P', 'G')
    ?c+      and       Tray.TRSTAT <> 'D'
    ?c+
    ?c+    GROUP BY    Tray.TRSCYM
    ?c+           ,    Tray.TRSIZE
    ?c+           ,    Tray.TRALPH
    ?c+           ,    Item.IMDES1
    ?c+           ,    Tray.TRITEM
    ?c+           ,    Tray.TRCRDT
    ?c+           ,    Seed.IMQTOH
    ?c+           ,    Seed.IMQTAV
    ?c+           ,    Item.IMTPSW
    ?c+
    ?c+    ORDER BY    Tray.TRSCYM
    ?c+           ,    Tray.TRSIZE
    ?c+           ,    Tray.TRALPH
    ?c+           ,    Item.IMDES1
    ?c+           ,    Tray.TRITEM
    ?c+           ,    Tray.TRCRDT
    ?c+           ,    Seed.IMQTOH
    ?c+           ,    Seed.IMQTAV
    ?c+
    ?c+  For Read only
    ?c+
    ?c/end-exec

    ?c/exec sql
    ?c+
    ?c+    SELECT      Count(*)
    ?c+    INTO        :Unsown
    ?c+
    ?c+    FROM        FTRAYR as Tray
    ?c+         ,      FMSIZE as Size
    ?c+         ,      FMINVT as Item
    ?c+         ,      FMINVT as Seed
    ?c+
    ?c+    WHERE       Tray.TRSIZE = Size.SZCODE
    ?c+      and       Tray.TRITEM = Item.IMITEM
    ?c+      and       Tray.TRSIZE = Item.IMSIZE
    ?c+      and       Tray.TRITEM = Seed.IMITEM
    ?c+      and       Seed.IMSIZE = 'SED'
    ?c+      and       Item.IMTPSW not in ('R', 'P', 'G')
    ?c+      and       Tray.TRSTAT <> 'D'
    ?c+
    ?c/end-exec

     ?*  Open the SQL recordset
    ?c/exec sql
    ?c+                  Open      C1
    ?c/end-exec

    ?C                   Other                                                  ?all other Sowing

    ?c/exec sql
    ?c+
    ?c+  DECLARE   C2 cursor for
    ?c+
    ?c+    SELECT      Tray.TRSCYM                       as Sow_Date
    ?c+         ,      Tray.TRCRDT                       as Ready_Date
    ?c+         ,      Tray.TRSIZE                       as Size
    ?c+         ,      Tray.TRITEM                       as Item
    ?c+         ,      Tray.TRALPH                       as Alpha
    ?c+         ,      Item.IMDES1                       as Description
    ?c+         ,      0                                 as Factor
    ?c+         ,      INT(AVG(Item.IM#SED))             as Seed_Cell
    ?c+         ,      0                                 as Cell_Tray
    ?c+         ,      Count(*)                          as Tray_Count
    ?c+         ,      0                                 as Seed_Need
    ?c+         ,      0                                 as On_Hand
    ?c+         ,      0                                 as Available
    ?c+         ,      Item.IMTPSW                       as Sow_Method
    ?c+
    ?c+    FROM        FTRAYR as Tray
    ?c+         ,      FMSIZE as Size
    ?c+         ,      FMINVT as Item
    ?c+
    ?c+    WHERE       Tray.TRSIZE = Size.SZCODE
    ?c+      and       Tray.TRITEM = Item.IMITEM
    ?c+      and       Tray.TRSIZE = Item.IMSIZE
    ?c+      and       Tray.TRSTAT <> 'D'
    ?c+      and   (   Item.IMTPSW = Case :OperType When 'C' then 'R'
    ?c+                                             When 'T' then 'P' end
    ?c+       or       Item.IMTPSW = Case :OperType When 'C' then 'G' end  )
    ?c+
    ?c+    GROUP BY    Tray.TRSCYM
    ?c+           ,    Tray.TRSIZE
    ?c+           ,    Tray.TRALPH
    ?c+           ,    Item.IMDES1
    ?c+           ,    Tray.TRITEM
    ?c+           ,    Tray.TRCRDT
    ?c+           ,    Item.IMTPSW
    ?c+
    ?c+    ORDER BY    Tray.TRSCYM
    ?c+           ,    Tray.TRSIZE
    ?c+           ,    Tray.TRALPH
    ?c+           ,    Item.IMDES1
    ?c+           ,    Tray.TRITEM
    ?c+           ,    Tray.TRCRDT
    ?c+
    ?c+  For Read only
    ?c+
    ?c/end-exec

    ?c/exec sql
    ?c+
    ?c+    SELECT      Count(*)
    ?c+    INTO        :Unsown
    ?c+
    ?c+    FROM        FTRAYR as Tray
    ?c+         ,      FMSIZE as Size
    ?c+         ,      FMINVT as Item
    ?c+
    ?c+    WHERE       Tray.TRSIZE = Size.SZCODE
    ?c+      and       Tray.TRITEM = Item.IMITEM
    ?c+      and       Tray.TRSIZE = Item.IMSIZE
    ?c+      and       Tray.TRSTAT <> 'D'
    ?c+      and   (   Item.IMTPSW = Case :OperType When 'C' then 'R'
    ?c+                                             When 'T' then 'P' end
    ?c+       or       Item.IMTPSW = Case :OperType When 'C' then 'G' end  )
    ?c+
    ?c/end-exec

     ?*  Open the SQL recordset
    ?c/exec sql
    ?c+                  Open      C2
    ?c/end-exec
    ?C                   EndSl                                                  ?

     C                   EndSr

      *?  ...........................................................
      *?  :      GetData02 - Run SQL to select Data for Screen 02   :
      *?  :.........................................................:

     C     GetData02     BegSr

      *? Select requested week data from the Sow Schedule File
    ?c/exec sql
    ?c+
    ?c+  DECLARE   C3 cursor for
    ?c+
    ?c+    SELECT      Tray.TRTAG#                       as Tray_Number
    ?c+         ,      Tray.TRSTAT                       as Tray_Status
    ?c+         ,      Tray.TRITEM                       as Tray_Item#
    ?c+         ,      Tray.TRSIZE                       as Tray_Size#
    ?c+         ,      Tray.TRCRDT                       as Tray_Ready
    ?c+
    ?c+    FROM        FTRAYR as Tray
    ?c+
    ?c+    WHERE       Tray.TRITEM = :Item5
    ?c+      and       Tray.TRSIZE = :Size
    ?c+      and       Tray.TRSCYM = :SowDate7
    ?c+      and       Tray.TRCRDT = :RdyDate7
    ?c+      and       Tray.TRALPH = :Alpha
    ?c+
    ?c+    ORDER BY    Tray.TRTAG#
    ?c+
    ?c+  For Read only
    ?c+
    ?c/end-exec

     ?*  Open the SQL recordset
    ?c/exec sql
    ?c+                  Open      C3
    ?c/end-exec

     C                   EndSr

      *?  ...........................................................
      *?  :      CloseData01 - Close the Screen 01 Data Set         :
      *?  :.........................................................:

     C     CloseData01   BegSr

     ?*  Close the SQL recordset
    ?C                   Select                                                 ?
    ?C                   When      OperType = 'R'                               ?Recip. Sowing
    ?c/exec sql
    ?c+                  Close     C1
    ?c/end-exec
    ?C                   Other                                                  ?Other Sowing
    ?c/exec sql
    ?c+                  Close     C2
    ?c/end-exec
    ?C                   EndSl

     C                   EndSr

      *?  ...........................................................
      *?  :      CloseData02 - Close the Screen 02 Data Set         :
      *?  :.........................................................:

     C     CloseData02   BegSr

     ?*  Close the SQL recordset
    ?c/exec sql
    ?c+                  Close     C3
    ?c/end-exec

     C                   EndSr

      *?  ...........................................................
      *?  :      ReadData01 - Read Data for Screen 01               :
      *?  :.........................................................:

     C     ReadData01    BegSr

     ?*  Read Sow Schedule Records for Selected Week
    ?C                   Select                                                 ?
    ?C                   When      OperType = 'R'                               ?Recip. Sowing
    ?c/exec sql
    ?c+ Fetch C1 into :UnSown_DS
    ?c/end-exec
    ?C                   Other                                                  ?Other Sowing
    ?c/exec sql
    ?c+ Fetch C2 into :UnSown_DS
    ?c/end-exec
    ?C                   EndSl

     C                   If        SQLSTT = '02000'                             ?Read until EOF
     C                   Eval      EndOfFile = *On
     C                   Else
     C                   Eval      EndOfFile = *Off
     C                   Eval      RecordCount = RecordCount + 1                ?Record Count
     C                   EndIf

     C                   EndSr


      *?  ...........................................................
      *?  :      ReadData02 - Read Data for Screen 02               :
      *?  :.........................................................:

     C     ReadData02    BegSr

     ?*  Read Sow Schedule Records for Selected Week
    ?c/exec sql
    ?c* Fetch C3 into :Tray#
    ?c+ Fetch C3 into :Tray_DS
    ?c/end-exec

     C                   If        SQLSTT = '02000'                             ?Read until EOF
     C                   Eval      EndOfFile = *On
     C                   Else
     C                   Eval      EndOfFile = *Off
     C                   Eval      RecordCount = RecordCount + 1                ?Record Count
     C                   EndIf

     C                   EndSr


      *?  ...........................................................
      *?  :      UpdateFiles01 - Screen 01 File Updates             :
      *?  :.........................................................:
    ?C     UpdateFiles01 BegSr                                                  ?

     C                   Eval      ChainRRN01 = 1
    ?C     ChainRRN01    Chain     SOW03501
     C                   DoW       %Found(SOW035FM)

     C                   If        IN81 = *On or IN82 = *On
     C                   Eval      SowDate7 = $Date7($DateMDY(SowDate6))
     C                   Eval      RdyDate7 = $Date7($DateMDY(RdyDate6))

    ?C                   SELECT                                                 ?
      *? Delete Requested
    ?C                   When         IN82 = *On
    ?c/exec sql
    ?c+
    ?c+    UPDATE     FTRAYR
    ?c+     SET       TRLIN# = 7
    ?c+         ,     TRSTAT = 'D'
    ?c*         ,     TRSCYM = 0
    ?c+         ,     TRREAS = 'SLC'
    ?c+         ,     TRDTLA = :Today
    ?c+         ,     TRTIME = :Now
    ?c+         ,     TRUSER = :User
    ?c+    WHERE      TRITEM= :Item5
    ?c+      and      TRSIZE= :Size
    ?c+      and      TRSCYM= :SowDate7
    ?c+      and      TRCRDT= :RdyDate7
    ?c+      and      TRALPH= :Alpha
    ?c+
    ?c/end-exec
    ?C                   EndSL
     C                   EndIf
     C                   Eval      ChainRRN01 =  ChainRRN01 + 1
     C     ChainRRN01    Chain     SOW03501
     C                   EndDo

    ?c/exec sql
    ?c+
    ?c+    INSERT INTO FTRAY
    ?c+    SELECT     *
    ?c+    FROM       FTRAYR
    ?c+    WHERE      TRDTLA = :Today
    ?c+      and      TRTIME = :Now
    ?c+      and      TRUSER = :User
    ?c+
    ?c/end-exec
    ?c/exec sql
    ?c+
    ?c+    DELETE FROM FTRAYR
    ?c+    WHERE      TRDTLA = :Today
    ?c+      and      TRTIME = :Now
    ?c+      and      TRUSER = :User
    ?c+
    ?c/end-exec
     C                   EndSr


      *?  ...........................................................
      *?  :      UpdateFiles02 - Screen 02 File Updates             :
      *?  :.........................................................:
    ?C     UpdateFiles02 BegSr                                                  ?

     C                   Eval      ChainRRN02 = 1
    ?C     ChainRRN02    Chain     SOW03502
     C                   DoW       %Found(SOW035FM)

     C                   If        IN83 = *On or IN84 = *On

    ?C                   SELECT                                                 ?
      *? Mark as Sown Requested
    ?C                   When         IN83 = *On
    ?c/exec sql
    ?c+
    ?c+    UPDATE     FTRAYR
    ?c+     SET       TRLIN# = 7
    ?c+         ,     TRSTAT = 'A'
    ?c+         ,     TRREAS = '   '
    ?c+         ,     TRDTLA = :Today
    ?c+         ,     TRTIME = :Now
    ?c+         ,     TRUSER = :User
    ?c+    WHERE      TRTAG#= :Tray#
    ?c+
    ?c/end-exec
      *? Delete Requested
    ?C                   When         IN84 = *On
    ?c/exec sql
    ?c+
    ?c+    UPDATE     FTRAYR
    ?c+     SET       TRLIN# = 7
    ?c+         ,     TRSTAT = 'D'
    ?c*         ,     TRSCYM = 0
    ?c+         ,     TRREAS = 'SLC'
    ?c+         ,     TRDTLA = :Today
    ?c+         ,     TRTIME = :Now
    ?c+         ,     TRUSER = :User
    ?c+    WHERE      TRTAG#= :Tray#
    ?c+
    ?c/end-exec
    ?C                   EndSL
    ?c/exec sql
    ?c+
    ?c+    INSERT INTO FTRAY
    ?c+    SELECT     *
    ?c+    FROM       FTRAYR
    ?c+    WHERE      TRDTLA = :Today
    ?c+      and      TRTIME = :Now
    ?c+      and      TRUSER = :User
    ?c+
    ?c/end-exec
    ?c/exec sql
    ?c+
    ?c+    DELETE FROM FTRAYR
    ?c+    WHERE      TRDTLA = :Today
    ?c+      and      TRTIME = :Now
    ?c+      and      TRUSER = :User
    ?c+
    ?c/end-exec
    ?C                   If           IN83 = *On
      *     ? Add to Lot Inventory
     C                   Call      'ADDLOTINV'
     C                   Parm      Tray#         StartTag#
     C                   Parm      Tray#         EndTag#
      *     ? Confirm Good Flat
     C                   Call      '#GOODFLAT'
     C                   Parm      Tray#         StartTag#
      *? Write the SownBy record.
     C                   Eval      SBTAG# = Tray#
    ?C     SBTAG#        Chain     FSOWNBY
      * ? If already sown, take credit away from prior sower.
     C                   If        %Found(FSOWNBY)
    ?C                   Call      '#ADDUSRTRY'
    ?C                   Parm      SBCARD        File#
    ?C                   Parm                    MINUSTRAY
    ?C                   Parm      'R'           OperType          1
    ?C                   Parm      SBATTT        AttTimestamp
     C                   EndIf
      * ? Credit Sower for producing flat.
     C                   Eval      File#  = 4                                    MISSING R/C LABEL
     C                   Call      '#EMPFILE#'
     C                   Parm      4             TimeCard          9 0
     C                   Parm      4             File#
     C                   Parm                    name             25
     C                   Eval      AttTimestamp = $LastPunch(4)
    ?C                   Call      '#ADDUSRTRY'
    ?C                   Parm                    File#
    ?C                   Parm                    PLUSTRAY
    ?C                   Parm      'R'           OperType
    ?C                   Parm                    AttTimestamp
      * ? Write/Update produced by record.
     C                   Eval      SBTAG# = Tray#
     C                   Eval      SBCARD = 4
     C                   Eval      SBPROG = 'SOW035'
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
     C
      *     ? Update Lot Loss file for entire lot
    ?C                   Call      'FXG065LOT'                                  ?
    ?C                   Parm      READY         READY065
    ?C                   Parm                    ITEM#
    ?C                   Parm                    SIZE#
    ?C                   EndIf
     C                   EndIf
     C                   Eval      ChainRRN02 =  ChainRRN02 + 1
     C     ChainRRN02    Chain     SOW03502
     C                   EndDo

     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C     *Entry        PList
     C                   Parm                    OperType          1

    ?C                   Select
    ?C                   When      OperType = 'R'
     C                   Eval      *In61 = *On                                  ?Recip. Sowing
    ?C                   When      OperType = 'C'
     C                   Eval      *In62 = *On                                  ?Rooted Cuttings
    ?C                   When      OperType = 'T'
     C                   Eval      *In63 = *On                                  ?Transplanting
    ?C                   EndSl

     C     #ChgPrt       PList
     C                   Parm                    User
     C                   Parm                    Program
     C                   Parm      '*LAST'       Printer

     C                   Eval      User  = $User()
     C                   Eval      Program = 'SOW035'
     C                   Eval      Today = $MDYDate($Date(0))
     C                   Eval      PrtToUse = $DftPrt(User:Program:'*USER')     ?Printer to Use
     C                   Eval      Command = CMD(1)
     C                   ExSr      $Command

     C                   Time                    Now
     C                   Eval      FileName = ('FLAB' + %Char(Now))

     C                   ExSr      Load01                                       ?
     C                   ExSr      ClrError                                     ?
     C                   ExSr      Scrn01                                       ?

      *?  Dummy reads for variable definitions
     C                   Eval      *In99 = *Off
     C   99              Read      FMINVT
     C   99              Read      FMSIZE
     C   99              Read      FTRAYR

    ?C                   EndSr                                                  ?
**
OVRPRTF FILE(SOW035P) OUTQ(|P~~~~~~~~) CPI(12) FORMTYPE(*NAR) OVRSCOPE(*JOB)
OVRDBF FILE(LABELFILE) TOFILE(*LIBL/|F~~~~~~~~)
LBLBATCH LBLNAM(SOWLBLP4) QTYOVR('0001') OUTQ(|P~~~~~~~~) FORM(SOWLABEL)
         MRGFILE(|F~~~~~~~~) MRGMBR(LABELFILE)
CRTDUPOBJ OBJ(LABELFILE) FROMLIB(*LIBL) OBJTYPE(*FILE) NEWOBJ(|F~~~~~~~~)
CLRPFM FILE(|F~~~~~~~~) MBR(LABELFILE)
