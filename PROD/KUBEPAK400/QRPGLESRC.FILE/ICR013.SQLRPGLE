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
     FICR013FM  CF   E             WORKSTN InfDs(ICR013FM_Inf)
     F                                     SFILE(ICR01301:RRN01)
     F*                                    SFILE(ICR01302:RRN01)
     F                                     DEVID(WSID)

     FFMINVTVENDUF A E           K Disk
     FFMINVT    IF   E           K Disk    Prefix(ITM_)
     FFMVEND    IF   E           K Disk

      * Display file data structure
     d ICR013FM_Inf    DS
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
    ?D/COPY QFunctDefn,QCmdExc

     D  ItemRecord     DS                  Inz
     D   C1_VISTAT                         Like(VISTAT)                         ?
     D   C1_VIITEM                         Like(VIITEM)                         ?
     D   C1_VIVEND                         Like(VIVEND)                         ?
     D   C1_VIVITM                         Like(VIVITM)                         ?
     D   C1_VIDES1                         Like(VIDES1)                         ?
     D   C1_VIDES2                         Like(VIDES2)                         ?

      *? Field Definitions
     D   User          S             10A                                        ?Current User ID
     D   Today         S               D                                        ?Todays Date MDY
     D   Now           S               T                                        ?The Time at *Init
     D   Program       S             10A                                        ?Program
     D   FileName      S             10A                                        ?File Name for Label

     D   RRN01         S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   LastRRN01     S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   StopRRN01     S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   Step01        S              4  0 Inz(0)                               ?SFLRRN 01 Increment
     D   ErrorCount    S              3S 0 Inz(0)                               ?Error Count
     D   ErrorCount01  S              3S 0 Inz(0)                               ?Error Count
     D   RecordCount   S              5S 0 INZ(0)
     D   ChainRRN01    S              4S 0 Inz(*Zero)                           ?Key by RRN
     D   WhereAmI      S              4S 0 Inz(*Zero)                           ?Current Screen RRN

     D   WeekCount     S              4S 0                                      ?Account for Weeks

      *? Indicators
     D   EndOfFile     S               N
     D   PassedEdit    S               N   Inz(*Off)

    ?C                   ExSr      ClrError                                     ?
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01                                       ?

     C     *INLR         DOUEQ     *ON                                          ?COMMENT

    ?C                   SELECT                                                 ?
    ?C     Screen        WhenEq    01                                           ?
    ?C                   ExSr      Edit01                                       ?
    ?C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?
     C*                  Call      'FIXORLFL'                                   ?

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
    ?C                   Write     ICR01301F                                   ?
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
    ?C   81              ExFmt     ICR01301C                                    ?
    ?C*  82              ExFmt     ICR01302C                                    ?
     C                   Eval      WhereAmI = SflCurRRN
    ?C                   ExSr      ClrError                                     ?
     C                   Eval      ErrorCount01 = *Zero                         ?Error Count
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

     C                   MoveA     '00000000000' *In(50)

     C                   Eval      Step01 = 18 * ( 1 )
     C                   Eval      EndOfFile = *Off
      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
     C                   Eval      StartRRN01 = *Zero
    ?C                   Write     ICR01301C                                    ?
    ?C*                  Write     ICR01302C                                    ?

      *? Load the Subfile

    ?C                   ExSr      OpenData

     C                   Z-add     *Zero         RRN01                          ?
     C                   Z-add     1             WhereAmI                       ?

     C                   Eval      StopRRN01 = Step01

     C                   If        *In93
     C                   Eval      StopRRN01 = 9999
     C                   EndIf

    ?C                   ExSr      ReadData
     C                   DoW       not EndOfFile and RRN01 < StopRRN01
    ?C                   ExSr      Load01Fld
    ?C                   ExSr      ReadData
     C                   EndDo                                                  ?

     C                   If        not *In26
     C                   Clear                   ICR01301
     C*                  Clear                   ICR01302
     C                   Eval      RRN01 = 1
     C                   Eval      VIDES1='No Data Found'
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
    ?C                   Write     ICR01301                                     ?
    ?C*                  Write     ICR01302                                     ?
     C                   EndIf

     C                   IF        *In26 = *On and EndOfFile                    ?
    ?C     RRN01         Chain     ICR01301                                     ?
    ?C*    RRN01         Chain     ICR01302                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
    ?C                   Update    ICR01301                                     ?
    ?C*                  Update    ICR01302                                     ?
     C                   EndIF                                                  ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      More01 - Load Screen 01 w/ More records            :
      *?  :.........................................................:
    ?C     More01        BegSr                                                  ?

     C                   If        not EndOfFile
     C                   MoveA     '00000000000' *In(50)

     C                   Eval      StartRRN01= RRN01 + 1
     C                   Eval      StopRRN01 = RRN01 + Step01

    ?C*                  ExSr      ReadData
     C                   DoW       not EndOfFile and RRN01 < StopRRN01
      *? Load screen fields
    ?C                   ExSr      Load01Fld
    ?C                   ExSr      ReadData

     C                   EndDo                                                  ?

     C                   IF        *In26 = *On and EndOfFile                    ?
    ?C     RRN01         Chain     ICR01301                                     ?
    ?C*    RRN01         Chain     ICR01302                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
    ?C                   Update    ICR01301                                     ?
    ?C*                  Update    ICR01302                                     ?
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
     C                   Eval      StartRRN01 = RRN01
     C                   EndIf

      *?  :````````````````````````````````````````````````````````````:
      *?  :              Load SFL Fields here ! ! !                    :
      *?  :............................................................:
    ?C     VIVEND        Chain     FMVEND                                       ?
     C                   If        not %Found(FMVEND)
     C                   Eval      VMNAME = 'Vendor Not on File'
     C                   EndIf

    ?C                   Write     ICR01301                                     ?
    ?C*                  Write     ICR01302                                     ?
     C                   Eval      *In26 = *On                                  ?Have Data Indicator

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
      *? Item Selected
    ?C                   When         *In01
    ?C     SFLCSRRRN     Chain     ICR01301
    ?C     ItemVend      Chain     FMINVTVEND
     C                   If        %Found(FMINVTVEND)
    ?C                   ExSr      UpdateCUT
     C                   Eval      *InLR = *On
    ?C                   ExSr      CloseData
     C                   LeaveSR
     C                   EndIf
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
      *? Refresh Requested
    ?C                   When         *In05
    ?C                   ExSr      CloseData
     C                   Time                    Now
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? Add Vendor Requested
    ?C                   When         *In06
    ?C                   Call      'ICR014'
    ?C                   Parm                    ITM_IMITEM
    ?C                   ExSr      CloseData
     C                   Time                    Now
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? Delete Requested
    ?C                   When         *In23
    ?C     SFLCSRRRN     Chain     ICR01301
    ?C     ItemVend      Chain     FMINVTVEND
     C                   If        %Found(FMINVTVEND)
    ?C                   Delete    RMINVTVEND
     C                   EndIf
    ?C                   ExSr      CloseData
     C                   Time                    Now
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? If no Functions, Check for Updates.
    ?C                   OTHER                                                  ?
    ?C                   ExSr      Updt01                                       ?
      *? Redisplay
    ?C                   ExSr      Scrn01
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Updt01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Updt01        BegSr                                                  ?

     C                   Eval      LastRRN01 = RRN01

    ?C   81              ReadC     ICR01301
    ?C*  82              ReadC     ICR01302
    ?C                   DoW       not %EOF(ICR013FM)

    ?C  n81RRN01         Chain     ICR01301
    ?C* n82RRN01         Chain     ICR01302
    ?C  n81              Update    ICR01301
    ?C* n82              Update    ICR01302

     C                   MoveA     '00000000000' *In(50)
      *?  <---   Check for Errors here and set on *In50 if Error


     C                   If        not *In50
    ?C     ItemVend      Chain     FMINVTVEND
    ?C     ItemVend      KList
    ?C                   KFld                    VIITEM
    ?C                   KFld                    VIVEND

    ?C   81RRN01         Chain     ICR01301
    ?C*  82RRN01         Chain     ICR01302
      *?  Update Item Master File
    ?C                   Update    RMINVTVEND
      *?  ~~~~~~~~~~~~~~
     C                   Eval      *In28 = *Off
    ?C   81              Update    ICR01301
    ?C*  82              Update    ICR01302
     C                   Else
     C                   Eval      *In50 = *On
     C                   Eval      *In28 = *On
    ?C   81              Update    ICR01301
    ?C*  82              Update    ICR01302
    ?C                   Leave
     C                   EndIf
    ?C   81              ReadC     ICR01301
    ?C*  82              ReadC     ICR01302
    ?C                   EndDo

     C                   Eval      RRN01 = LastRRN01

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
     C                   Parm      'ICR013'      PgmQ             10            ?Pgm Msg Queue
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
    ?c+    SELECT       Count(*)
    ?c+    INTO         :Records
    ?c+    FROM         FMINVTVEND
    ?c+    WHERE        VIITEM =    :ITM_IMITEM
    ?c+
    ?c/end-exec
    ?c/exec Sql

    ?c+    DECLARE  C1 cursor for

    ?c+    SELECT       VISTAT
    ?c+         ,       VIITEM
    ?c+         ,       VIVEND
    ?c+         ,       VIVITM
    ?c+         ,       VIDES1
    ?c+         ,       VIDES2

    ?c+    FROM         FMINVTVEND

    ?c+    WHERE        VIITEM =    :ITM_IMITEM

    ?c+    ORDER BY     VIVEND

    ?c+    For Read only

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
    ?c+ Fetch C1 into :ItemRecord
    ?c/end-exec

     C                   If        SQLSTT = '02000'                             ?Read until EOF
     C                   Eval      EndOfFile = *On
     C                   Else
     C                   Eval      EndOfFile = *Off
     C                   Eval      VISTAT      = C1_VISTAT
     C                   Eval      VIITEM      = C1_VIITEM
     C                   Eval      VIVEND      = C1_VIVEND
     C                   Eval      VIVITM      = C1_VIVITM
     C                   Eval      VIDES1      = C1_VIDES1
     C                   Eval      VIDES2      = C1_VIDES2

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
      *?  :      UpdateCUT - Update Vendor in CUT                   :
      *?  :.........................................................:

     C     UpdateCUT     BegSr
      /Free
         //?Update the Vendor of Record (Not the Supply Vendor)
    ?
    ?    Exec SQL
    ?      Update FCUTLOT  Set CLVEND = :VIVEND Where CLITEM = :VIITEM;
    ?    Exec SQL
    ?      Update FCUTORD  Set COVEND = :VIVEND Where COITEM = :VIITEM;
    ?    Exec SQL
    ?      Update FCUTNEED Set CNVEND = :VIVEND Where CNITEM = :VIITEM;

      /End-Free
     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C     *ENTRY        PList                                                ?
    ?C                   Parm                    ITM_IMITEM                   ?
    ?C                   Parm                    VIVEND
    ?C                   Parm                    VIVITM
    ?C     ITM_IMITEM    Chain     FMINVT
     C                   If        not %Found(FMINVT)
     C                   Eval      ITM_IMDES1 = 'Item not created yet'
     C                   Eval      ITM_IMDES2 = *Blanks
     C                   EndIf

     C                   MoveA     '1000'        *In(81)
     C                   Eval      *In93 = *Off
     C                   Time                    Today
     C                   Time                    Now

    ?C                   EndSr                                                  ?
