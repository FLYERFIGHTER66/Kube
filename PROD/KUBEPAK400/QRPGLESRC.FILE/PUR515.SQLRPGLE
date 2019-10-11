    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Fin. Inventory Master Inquiry                      :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Oct. 2008            ? Kube-Pak Corporation ?    :
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
     FPUR515FM  CF   E             WORKSTN
     F                                     SFILE(PUR51501:RRN01)
     F                                     DEVID(WSID)

     FFPUSCHD   IF   E             Disk
     FFMCUST    IF   E             Disk
     FFCALEN    IF   E             Disk

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Center
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$IsDate#
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,QCmdExc

     D  Schedule       DS                  Inz
     D   C1_CMCUST                         Like(CMCUST)                         ?
     D   C1_CMNAME                         Like(CMNAME)                         ?
     D   C1_CMADD2                         Like(CMADD2)                         ?
     D   C1_CMCITY                         Like(CMCITY)                         ?
     D   C1_CMSTST                         Like(CMSTST)                         ?
     D   C1_CMZIP                          Like(CMZIP )                         ?
     D   C1_CMPHON                         Like(CMPHON)                         ?
     D   C1_TRSHDT                         Like(TRSHDT)                         ?
     D   C1_TRROUT                         Like(TRROUT)                         ?
     D   C1_TRTRK#                         Like(TRTRK#)                         ?
     D   C1_TRSTOP                         Like(TRSTOP)                         ?
     D   C1_TRQTY4                         Like(TRQTY4)                         ?
     D   C1_TRQTY5                         Like(TRQTY5)                         ?
     D   C1_TRQTY3                         Like(TRQTY3)                         ?
     D   C1_TRQTY6                         Like(TRQTY6)                         ?
     D   C1_TRQTY1                         Like(TRQTY1)                         ?
     D   C1_TRQTY2                         Like(TRQTY2)                         ?

      *? Field Definitions
     D   User          S             10A                                        ?Current User ID
     D   Today         S               D                                        ?Todays Date MDY
     D   Now           S               T                                        ?The Time at *Init
     D   Program       S             10A                                        ?Program
     D   FileName      S             10A                                        ?File Name for Label

     D   RRN01         S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   StopRRN01     S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   Step01        S              4  0 Inz(0)                               ?SFLRRN 01 Increment
     D   ErrorCount    S              3S 0 Inz(0)                               ?Error Count
     D   ErrorCount01  S              3S 0 Inz(0)                               ?Error Count
     D   RecordCount   S              5S 0 INZ(0)
     D   ChainRRN01    S              4S 0 Inz(*Zero)                           ?Key by RRN

     D   Look4@        S                   Like(Look4)                          ?What to Look For

     D   SAVLook4      S                   Like(Look4)                          ?What to Look For
     D   SAVShipWeek6  S                   Like(ShipWeek6)                      ?Ship Week Monday

     D   ShipWeek      S               D                                        ?Ship Week Monday
     D   ShipWeek6     S                   Like(CLDATE)                         ?Ship Week Monday
     D   ShipWeek7     S                   Like(CLCYMD)                         ?Ship Week Monday
     D   WeekNumber    S                   Like(CLCYMD)                         ?Ship Week Number

      *? Indicators
     D   EndOfFile     S               N

    ?C                   ExSr      ClrError                                     ?
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01                                       ?

     C     *INLR         DOUEQ     *ON                                          ?COMMENT

    ?C                   SELECT                                                 ?
    ?C     Screen        WhenEq    01                                           ?
    ?C                   ExSr      Edit01                                       ?
    ?C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

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
    ?C                   Write     PUR51501F                                   ?
     C                   If        ErrorCount01 <> *Zero                        ?Error Count
    ?C                   Write     MSGCTL                                       ?
     C                   EndIf
     C                   If        StartRRN01 = *Zero
     C                   Eval      StartRRN01 = 1
     C                   EndIf
     C                   If        RRN01 = *Zero
     C                   Eval      *In26 = *Off                                 ?
     C                   EndIf
    ?C                   ExFmt     PUR51501C                                    ?
    ?C                   ExSr      ClrError                                     ?
     C                   Eval      ErrorCount01 = *Zero                         ?Error Count
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

     C                   Eval      SAVLook4     =  Look4
     C                   Eval      SAVShipWeek6 =  ShipWeek6
     C                   Eval      Step01 = 16 * ( 1 )
     C                   Eval      EndOfFile = *Off
      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
     C                   Eval      *In81 = *Off
     C                   Eval      StartRRN01 = *Zero
    ?C                   Write     PUR51501C                                    ?

      *? Load the Subfile

    ?C                   ExSr      OpenData

     C                   Z-add     *Zero         RRN01                          ?

     C                   Eval      StopRRN01 = Step01

     C                   If        *In83
     C                   Eval      StopRRN01 = 9999
     C                   EndIf

    ?C                   ExSr      ReadData
     C                   DoW       not EndOfFile and RRN01 < StopRRN01
    ?C                   ExSr      Load01Fld
    ?C                   ExSr      ReadData
     C                   EndDo                                                  ?

     C                   If        not *In26
     C                   Clear                   PUR51501
     C                   Eval      RRN01 = 1
     C                   Eval      CMNAME='No Data Found'
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
    ?C                   Write     PUR51501                                     ?
     C                   EndIf

     C                   IF        *In26 = *On and EndOfFile                    ?
    ?C     RRN01         Chain     PUR51501                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
    ?C                   Update    PUR51501                                     ?
     C                   EndIF                                                  ?
     C                   Clear                   PUR51501                                     ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      More01 - Load Screen 01 w/ More records            :
      *?  :.........................................................:
    ?C     More01        BegSr                                                  ?

     C                   If        not EndOfFile

     C                   Eval      StartRRN01= RRN01 + 1
     C                   Eval      StopRRN01 = RRN01 + Step01

    ?C                   ExSr      ReadData
     C                   DoW       not EndOfFile and RRN01 < StopRRN01
      *? Load screen fields
    ?C                   ExSr      Load01Fld
    ?C                   ExSr      ReadData

     C                   EndDo                                                  ?

     C                   IF        *In26 = *On and EndOfFile                    ?
    ?C     RRN01         Chain     PUR51501                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
    ?C                   Update    PUR51501                                     ?
     C                   EndIF                                                  ?
     C                   EndIf                                                  ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load01Fld - Load Screen 01 Fields                  :
      *?  :.........................................................:
    ?C     Load01Fld     BegSr                                                  ?

      *? Load screen fields

      *? Write Subfile Record
     C                   Add       1             RRN01                          ?

      *?     Check to see if this is the starting screen
     C                   If        StartRRN01 = 0
     C                   Eval      *In81 = *On                                   Position Cursor
     C                   Eval      StartRRN01 = RRN01
     C                   EndIf

      *?  :````````````````````````````````````````````````````````````:
      *?  :              Load SFL Fields here ! ! !                    :
      *?  :............................................................:
    ?C                   Write     PUR51501                                     ?
     C                   Eval      *In26 = *On                                  ?Have Data Indicator
     C                   Eval      *In81 = *Off                                  Position Cursor

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

     C                   If        Look4   <> *Blanks
     C                   Eval      Look4@   = '%' + %Trim(Look4) + '%'
     C                   Else
     C                   Eval      Look4@   = *Blanks
     C                   EndIf

      *? Process pre-edit Functions F3, F6, F7 & F9
    ?C                   SELECT                                                 ?
      *? Cancel Requested
    ?C                   When         *In03
    ?C                   ExSr      CloseData
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
     C                   Time                    Now
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? Plus or Minus a Week
    ?C                   When         *In08 or *In09
     C   08              Eval      ShipWeek  = $AddDate(ShipWeek:-7)
     C   09              Eval      ShipWeek  = $AddDate(ShipWeek:+7)
     C                   Eval      ShipWeek7 = $Date7(ShipWeek)
     C                   Eval      ShipWeek6 = $MDYDate(ShipWeek)
    ?C                   ExSr      CloseData
     C                   Time                    Now
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? Invalid Ship Week Selected
    ?C                   When      not $IsDate#(ShipWeek6:'*MDY') or
    ?C                             not $IsDate#(ShipWeek6:'*MDY')
     C                   Eval      ShipWeek6 = SAVShipWeek6
     C                   Eval      ShipWeek  = $Date(ShipWeek6)
     C                   Eval      ShipWeek7 = $Date7(ShipWeek)
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? Selection Changed
    ?C                   When      Look4     <> SAVLook4 or
    ?C                             ShipWeek6 <> SAVShipWeek6
     C                   Eval      ShipWeek  = $Date(ShipWeek6)
     C                   Eval      ShipWeek7 = $Date7(ShipWeek)
     C                   ExSr      CloseData
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? If no Functions, Check for Options.
    ?C                   OTHER                                                  ?
    ?C*                  No Options Available
      *? Redisplay
    ?C                   ExSr      Scrn01
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ExitSR - Exit Subroutine                           :
      *?  :.........................................................:
    ?C     ExitSR        BegSr                                                  ?

     C                   ExSr      CloseData
     C                   Eval      *InLR = *On
     C                   Return

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
     C                   Parm      'PUR515'      PgmQ             10            ?Pgm Msg Queue
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
    ?c+    SELECT        ( CLYEAR * 100 ) + CLWEEK
    ?c+    INTO          :WeekNumber
    ?c+    FROM          FCALEN
    ?c+    WHERE         CLCYMD = :ShipWeek7
    ?c+
    ?c/end-exec

    ?c/exec sql
    ?c+
    ?c+    DECLARE  C1 cursor for
    ?c+
    ?c+    SELECT        FMCUST.CMCUST
    ?c+         ,        FMCUST.CMNAME
    ?c+         ,        FMCUST.CMADD2
    ?c+         ,        FMCUST.CMCITY
    ?c+         ,        FMCUST.CMSTST
    ?c+         ,        FMCUST.CMZIP
    ?c+         ,        FMCUST.CMPHON
    ?c+         ,       FPUSCHD.TRSHDT
    ?c+         ,       FPUSCHD.TRROUT
    ?c+         ,       FPUSCHD.TRTRK#
    ?c+         ,       FPUSCHD.TRSTOP
    ?c+         ,       FPUSCHD.TRQTY4
    ?c+         ,       FPUSCHD.TRQTY5
    ?c+         ,       FPUSCHD.TRQTY3
    ?c+         ,       FPUSCHD.TRQTY6
    ?c+         ,       FPUSCHD.TRQTY1
    ?c+         ,       FPUSCHD.TRQTY2
    ?c+    FROM         FPUSCHD
    ?c+         ,       FCALEN
    ?c+         ,       FMCUST
    ?c+    WHERE        FPUSCHD.TRSHDT = FCALEN.CLCYMD
    ?c+      and        FPUSCHD.TRCUST = FMCUST.CMCUST
    ?c+      and        FCALEN.CLWEEK  = 41
    ?c+      and        ( FCALEN.CLYEAR * 100 ) + FCALEN.CLWEEK = :WeekNumber
    ?c+      and     (( FMCUST.CMNAME like Trim(:LOOK4@)
    ?c+              or FMCUST.CMADD2 like Trim(:LOOK4@)
    ?c+              or FMCUST.CMCITY like Trim(:LOOK4@)
    ?c+              or FMCUST.CMCUST like Trim(:LOOK4@)
    ?c+              or 'CITY '  || FMCUST.CMCITY  like Trim(:LOOK4@)
    ?c+              or 'ROUTE ' || FPUSCHD.TRROUT like Trim(:LOOK4@)
    ?c+              or 'CUST '  || FMCUST.CMCUST  like Trim(:LOOK4@)
    ?c+              )  or :Look4@ = ' ' )
    ?c+    ORDER BY     FMCUST.CMLOOK
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
    ?c+ Fetch C1 into :Schedule
    ?c/end-exec

     C                   If        SQLSTT = '02000'                             ?Read until EOF
     C                   Eval      EndOfFile = *On
     C                   Else
     C                   Eval      EndOfFile = *Off
     C                   Eval      CMCUST      = C1_CMCUST
     C                   Eval      CMNAME      = C1_CMNAME
     C                   Eval      CMADD2      = C1_CMADD2
     C                   Eval      CMCITY      = C1_CMCITY
     C                   Eval      CMSTST      = C1_CMSTST
     C                   Eval      CMZIP       = C1_CMZIP
     C                   Eval      CMPHON      = C1_CMPHON
     C                   Eval      TRSHDT      = C1_TRSHDT
     C                   Eval      TRROUT      = C1_TRROUT
     C                   Eval      TRTRK#      = C1_TRTRK#
     C                   Eval      TRSTOP      = C1_TRSTOP
     C                   Eval      TRQTY4      = C1_TRQTY4
     C                   Eval      TRQTY5      = C1_TRQTY5
     C                   Eval      TRQTY3      = C1_TRQTY3
     C                   Eval      TRQTY6      = C1_TRQTY6
     C                   Eval      TRQTY1      = C1_TRQTY1
     C                   Eval      TRQTY2      = C1_TRQTY2
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

    ?C*    *Entry        PList                                                  ?
    ?C*                  Parm                    Look4                          ?

     C                   If        Look4   <> *Blanks
     C                   Eval      Look4@   = '%' + %Trim(Look4) + '%'
     C                   Else
     C                   Eval      Look4@   = *Blanks
     C                   EndIf

     C                   Eval      ShipWeek  = $Monday($Date(0):'SAT')
     C                   Eval      ShipWeek7 = $Date7(ShipWeek)
     C                   Eval      ShipWeek6 = $MDYDate(ShipWeek)

     C                   Eval      *In83 = *Off
     C                   Time                    Today
     C                   Time                    Now

    ?C                   EndSr                                                  ?
