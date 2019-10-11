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
     FMMR030FM  CF   E             WORKSTN InfDs(MMR030FM_Inf)
     F                                     SFILE(MMR03001:RRN01)
     F                                     DEVID(WSID)

     FFHORDR    IF   E           K Disk

      * Display file data structure
     d MMR030FM_Inf    DS
     d  FunctionKey          369    369
     d  CursorLoc            370    371
     d  DataLen              372    375I 0
     d  SflRrnNbr            376    377I 0
     d  SflCurRrn            378    379I 0
     d  SflMaxRrn            380    381I 0


      *? Function Prototypes
    ?D/COPY QFunctDefn,$Center
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$IsDate#
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,QCmdExc

      *? Field Definitions
     D   User          S             10A                                        ?Current User ID
     D   Today         S               D                                        ?Todays Date MDY
     D   Now           S               T                                        ?The Time at *Init
     D   Program       S             10A                                        ?Program
     D   FileName      S             10A                                        ?File Name for Label

     D   RRN01         S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   LastRRN01     S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   StopRRN01     S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   SavRRN01      S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   Step01        S              4  0 Inz(0)                               ?SFLRRN 01 Increment
     D   ErrorCount    S              3S 0 Inz(0)                               ?Error Count
     D   ErrorCount01  S              3S 0 Inz(0)                               ?Error Count
     D   RecordCount   S              5S 0 INZ(0)
     D   ChainRRN01    S              4S 0 Inz(*Zero)                           ?Key by RRN
     D   WhereAmI      S              4S 0 Inz(*Zero)                           ?Current Screen RRN

     D   SAVSDate      S                   Like(SDate)                          ?Ship Date
     D   SVDESC        S             30A                                        ?Ship Via
     D   SAVSVDESC     S                   Like(SVDESC)                         ?Ship Via
     D   SAVOHDTCN     S                   Like(OHDTCN)                         ?Date Wanted

     D   WeekCount     S              4S 0                                      ?Account for Weeks

     D   Sat           S              6S 0                                      ?Saterday Date MDY
     D   Sun           S              6S 0                                      ?Sunday Date MDY
     D   Mon           S              6S 0                                      ?Monday Date MDY
     D   Tue           S              6S 0                                      ?Tuesday Date MDY
     D   Wed           S              6S 0                                      ?Wednesday Date MDY
     D   Thu           S              6S 0                                      ?Thusday Date MDY
     D   Fri           S              6S 0                                      ?Friday Date MDY
     D   SDate7        S              7S 0                                      ?Monday Shipweek
     D  SDateYMD7      S              7S 0                                      ?Ship Date YMD7
     D  PlugsOnly      S               N                                        ?Only Plug Orders

     D  C1_OrdersDS    DS
     D   C1_OHALPH                         Like(OHALPH)                         ?Cust Alpha
     D   C1_OHSHPC                         Like(OHSHPC)                         ?Ship Via Code
     D   C1_OHDTCN                         Like(OHDTCN)                         ?Date Wanted
     D   C1_OHORD#                         Like(OHORD#)                         ?Order #
     D   C1_SVDESC                         Like(OHNAME)                         ?Ship Via Desc.

      *? Indicators
     D   EndOfFile     S               N
     D   PassedEdit    S               N   Inz(*Off)
     D   Included      S               N

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
    ?C                   Write     MMR03001F                                   ?
     C                   If        ErrorCount01 <> *Zero                        ?Error Count
    ?C                   Write     MSGCTL                                       ?
     C                   EndIf
     C                   If        not *In40 and WhereAmI > 0
     C                   Eval      StartRRN01 = WhereAmI
     C                   EndIf
     C                   If        StartRRN01 = *Zero
     C                   Eval      StartRRN01 = 1
     C                   EndIf
     C                   If        RRN01 = *Zero
     C                   Eval      *In26 = *Off                                 ?
     C                   EndIf
    ?C                   ExFmt     MMR03001C                                    ?
     C                   Eval      WhereAmI = SflCurRRN
    ?C                   ExSr      ClrError                                     ?
     C                   Eval      ErrorCount01 = *Zero                         ?Error Count
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

     C                   Eval      SAVSVDESC    =  *Blanks
     C                   Eval      SAVOHDTCN    =  *Zeros
     C                   Eval      SAVSDate     =  SDate

     C                   Eval      Sat = $MDYDate($AddDate($DateMDY(SDate):-2))
     C                   Eval      Sun = $MDYDate($AddDate($DateMDY(SDate):-1))
     C                   Eval      Mon = SDate
     C                   Eval      Tue = $MDYDate($AddDate($DateMDY(SDate):+1))
     C                   Eval      Wed = $MDYDate($AddDate($DateMDY(SDate):+2))
     C                   Eval      Thu = $MDYDate($AddDate($DateMDY(SDate):+3))
     C                   Eval      Fri = $MDYDate($AddDate($DateMDY(SDate):+4))

     C                   Eval      Step01 = 16 * ( 1 )
     C                   Eval      EndOfFile = *Off
      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
     C                   Eval      StartRRN01 = *Zero
    ?C                   Write     MMR03001C                                    ?

      *? Load the Subfile

    ?C                   ExSr      OpenData

     C                   Z-add     *Zero         RRN01                          ?
     C                   Z-add     1             WhereAmI                       ?

     C                   Eval      StopRRN01 = Step01

    ?C                   ExSr      ReadData
     C                   DoW       not EndOfFile and RRN01 < StopRRN01
    ?C                   ExSr      Load01Fld
    ?C                   ExSr      ReadData
     C                   EndDo                                                  ?

     C                   If        not *In26
     C                   Clear                   MMR03001
     C                   Eval      RRN01 = 1
     C                   Eval      OHNAME='No Data Found'
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
    ?C                   Write     MMR03001                                     ?
     C                   EndIf

     C                   IF        *In26 = *On and EndOfFile                    ?
    ?C     RRN01         Chain     MMR03001                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
    ?C                   Update    MMR03001                                     ?
     C                   EndIF                                                  ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      More01 - Load Screen 01 w/ More records            :
      *?  :.........................................................:
    ?C     More01        BegSr                                                  ?

     C                   If        not EndOfFile

     C                   Eval      StartRRN01= RRN01 + 1
     C                   Eval      StopRRN01 = RRN01 + Step01

PNK |C                   DoW       not EndOfFile and RRN01 < StopRRN01
      *? Load screen fields
    ?C                   ExSr      Load01Fld
    ?C                   ExSr      ReadData

     C                   EndDo                                                  ?

     C                   IF        *In26 = *On and EndOfFile                    ?
    ?C     RRN01         Chain     MMR03001                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
    ?C                   Update    MMR03001                                     ?
     C                   EndIF                                                  ?
     C                   EndIf                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load01Fld - Load Screen 01 Fields                  :
      *?  :.........................................................:
    ?C     Load01Fld     BegSr                                                  ?

      *? Load screen fields

     C                   Eval      SDateYMD7 = SDate7
    ?C                   Call      'MMR015'
    ?C                   Parm      OHORD#        ORDER             6 0
    ?C                   Parm      1             PMASTER           2 0
    ?C                   Parm                    SDateYMD7         7 0
    ?C                   Parm                    Included
     C                   If        not Included
    ?C                   Call      'MMR015'
    ?C                   Parm      OHORD#        ORDER             6 0
    ?C                   Parm      2             PMASTER           2 0
    ?C                   Parm                    SDateYMD7         7 0
    ?C                   Parm                    Included
     C                   If        not Included
    ?C                   Call      'MMR015'
    ?C                   Parm      OHORD#        ORDER             6 0
    ?C                   Parm      3             PMASTER           2 0
    ?C                   Parm                    SDateYMD7         7 0
    ?C                   Parm                    Included
     C                   If        not Included
      *? Write Subfile Record
     C                   Add       1             RRN01                          ?

      *?     Check to see if this is the starting screen
     C                   If        StartRRN01 = 0
     C                   Eval      StartRRN01 = RRN01
     C                   EndIf

      *?  :````````````````````````````````````````````````````````````:
      *?  :              Load SFL Fields here ! ! !                    :
      *?  :............................................................:

    ?C     OHORD#        Chain(N)  FHORDR
     C                   If        not %Found(FHORDR)
     C                   Clear                   RHORDR
     C                   Eval      OHNAME = 'Order Header Not Found'
     C                   Else
     C                   If        SVDESC <> SavSVDESC or OHDTCN <> SavOHDTCN
     C                   Clear                   RHORDR
     C                   Eval      OHNAME =
     C                             %Trim(SVDESC)+' '+%EditW(OHDTCN:'  /  /  ')
     C                   Eval      *In61 = *On
    ?C                   Write     MMR03001                                     ?
     C                   Eval      *In61 = *Off
    ?C                   Eval      RRN01 = RRN01 + 1                            ?
    ?C                   Eval      SavSVDESC = SVDESC                           ?
    ?C                   Eval      SavOHDTCN = OHDTCN                           ?
    ?C     OHORD#        Chain(N)  FHORDR
     C                   EndIf
     C                   EndIf

    ?C                   Write     MMR03001                                     ?
     C                   Eval      *In26 = *On                                  ?Have Data Indicator
     C                   EndIf
     C                   EndIf
     C                   EndIf
     C

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

      *? Process pre-edit Functions F3, F6, F7 & F9
    ?C                   SELECT                                                 ?
      *? Cancel Requested
    ?C                   When         *In03
    ?C                   ExSr      CloseData
     C                   MOVE      *ON           *INLR                          ?
      *? Toggle PlugsOnly
    ?C                   When         *In04
     C                   If        *In41
     C                   Eval      *In41 = *Off
     C                   Else
     C                   Eval      *In41 = *On
     C                   EndIf
     C                   Eval      PlugsOnly = *In41
    ?C                   ExSr      CloseData
     C                   Time                    Now
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
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
      *? When Previous Week is Requested
    ?C                   When      *In08 = *ON                                  ?
     C                   Eval      SDate=$MDYDate($AddDate($DateMDY(SDate):-7))
     C                   Eval      SDate7    = $Date7($DateMDY(SDate))
    ?C                   ExSr      CloseData
     C                   Time                    Now
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? When Next Week is Requested
    ?C                   When      *In09 = *ON                                  ?
     C                   Eval      SDate=$MDYDate($AddDate($DateMDY(SDate):7))
     C                   Eval      SDate7    = $Date7($DateMDY(SDate))
    ?C                   ExSr      CloseData
     C                   Time                    Now
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? Refresh Requested
    ?C                   When         *In05
    ?C                   ExSr      CloseData
     C                   Time                    Now
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? Selection Changed
    ?C                   When      SDate     <> SAVSDate
     C                   Eval      SDate7 = $Date7($DateMDY(SDate))
     C                   ExSr      CloseData
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? Order Inquiry Requested
    ?C                   When         *In10
     C                   Eval      SavRRN01 = RRN01
    ?C     SFLCSRRRN     Chain     MMR03001
     C                   Call      'BIR255CLO'
     C                   Parm                    OHORD#
    ?C                   Update    MMR03001
     C                   Eval      RRN01 = SavRRN01
    ?C                   ExSr      Scrn01
      *? Order Edit Requested
    ?C                   When         *In11
     C                   Eval      SavRRN01 = RRN01
    ?C     SFLCSRRRN     Chain     MMR03001
     C                   Call      'BIR100CLO'
     C                   Parm                    OHORD#
     C                   Parm      0             SeqZero           3 0
    ?C                   Update    MMR03001
     C                   Eval      RRN01 = SavRRN01
    ?C                   ExSr      Scrn01
      *? If no Functions, Check for Updates.
    ?C                   OTHER                                                  ?
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
     C                   Parm      'MMR030'      PgmQ             10            ?Pgm Msg Queue
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
    ?c+    Select       OHALPH, OHSHPC, OHDTCN, OHORD#, SVDESC
    ?c+    From         FHORDR
    ?c+       ,         FIORDR
    ?c+       ,         FMSVIA
    ?c+    Where        OHORD# = OIORD#
    ?c+      and        OHSHPC = SVCODE
    ?c+      and        OHSTAT = 'A'
    ?c+      and        OISTAT = 'A'
    ?c+      and      ( OIRVDT = :SDate7
    ?c+              or OHDTRY = :SDate7
    ?c+              or OHDTCN = :Sat
    ?c+              or OHDTCN = :Sun
    ?c+              or OHDTCN = :Mon
    ?c+              or OHDTCN = :Tue
    ?c+              or OHDTCN = :Wed
    ?c+              or OHDTCN = :Thu
    ?c+              or OHDTCN = :Fri   )
    ?c+      and     ( :PlugsOnly = '0'
    ?c+              or OHORD# in (Select Distinct PLORD# From PLUG_ORD) )
    ?c+    Group By     OHSHPC
    ?c+           ,     OHDTCN
    ?c+           ,     OHALPH
    ?c+           ,     OHORD#
    ?c+           ,     SVDESC
    ?c+    Order By     OHSHPC
    ?c+           ,     OHDTCN
    ?c+           ,     OHALPH
    ?c+           ,     OHORD#
    ?c+           ,     SVDESC
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
    ?c+ Fetch C1 into :C1_OrdersDS
    ?c/end-exec

     C                   If        SQLSTT = '02000'                             ?Read until EOF
     C                   Eval      EndOfFile = *On
     C                   Else
     C                   Eval      EndOfFile = *Off
     C                   Eval      OHORD#      = C1_OHORD#
     C                   Eval      SVDESC      = C1_SVDESC
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

     C                   Time                    Today
     C                   Time                    Now
     C                   Eval      SDate = $MDYDate($Monday($Date(0):'TUE'))
     C                   Eval      SDate7 = $Date7($DateMDY(SDate))

    ?C                   EndSr                                                  ?
