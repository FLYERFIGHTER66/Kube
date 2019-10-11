    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Employee Master Inquiry                            :?
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
     FATT071FM  CF   E             WORKSTN
     F                                     SFILE(ATT07101:RRN01)
     F                                     DEVID(WSID)

     FFMEMPLOY  IF   E           K DISK                                         ?Employee Master

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$Duration
    ?D/COPY QFunctDefn,QCmdExc
    ?D/COPY QFunctDefn,$MONDAY

     D  Employees      DS
     D   C1_FILE                           Like(emFILE)                         ?File #
     D   C1_CARD                           Like(emCARD)                         ?TimeCard#
     D   C1_TITL                           Like(emTITL)                         ?Title
     D   C1_HIRE                           Like(emHIRE)                         ?Hire Date
     D   C1_RHIR                           Like(emRHIR)                         ?Re-Hire Date
     D   C1_CLAS                           Like(emCLAS)                         ?Labor Class
     D   C1_LAST                           Like(emLAST)                         ?Last Name
     D   C1_FIRS                           Like(emFIRS)                         ?First Name
     D   C1_NAME                     25A                                        ?Formated Name

      *? Field Definitions
     D   User          S             10A                                        ?Current User ID
     D   Today         S              6S 0                                      ?Todays Date MDY
     D   Now           S              6S 0                                      ?The Time at *Init
     D   Program       S             10A                                        ?Program
     D   FileName      S             10A                                        ?File Name for Label

     D   RRN01         S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   StopRRN01     S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   Step01        S              4  0 Inz(0)                               ?SFLRRN 01 Increment
     D   ErrorCount    S              3S 0 Inz(0)                               ?Error Count
     D   ErrorCount01  S              3S 0 Inz(0)                               ?Error Count
     D   RecordCount   S              5S 0 INZ(0)
     D   ChainRRN01    S              4S 0 Inz(*Zero)                           ?Key by RRN

     D   SAVLast       S                   Like(SELLAST)                        ?Last Name
     D   SAVFirst      S                   Like(SELFIRST)                       ?First Name
     D   SAVName       S                   Like(SELNAME)                        ?Employee Name

     D   SELLast2      S                   Like(SELLAST)                        ?Last Name
     D   SELFirst2     S                   Like(SELFIRST)                       ?First Name
     D   SELName2      S                   Like(SELNAME)                        ?Employee Name

      *? Indicators
     D   EndOfFile     S               N
     D   Called        S               N

    ?C                   ExSr      ClrError                                     ?
     C                   If        SELNAME <> *Blanks
     C                   Eval      Called = *On
     C                   Eval      *In60  = *On
    ?C                   ExSr      Load01                                       ?
    ?C                   ExSr      Scrn01                                       ?
     C                   Else
    ?C                   ExSr      Scrn00                                       ?
     C                   EndIf

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
    ?C                   ExFmt     ATT07100                                     ?
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
    ?C                   Write     ATT07101F                                   ?
     C                   If        ErrorCount01 <> *Zero                        ?Error Count
    ?C                   Write     MSGCTL                                       ?
     C                   EndIf
     C                   If        StartRRN01 = *Zero
     C                   Eval      StartRRN01 = 1
     C                   EndIf
    ?C                   ExFmt     ATT07101C                                    ?
    ?C                   ExSr      ClrError                                     ?
     C                   Eval      ErrorCount01 = *Zero                         ?Error Count
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load00 - Load Screen 00                            :
      *?  :.........................................................:
    ?C     Load00        BegSr                                                  ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

     C                   Eval      Option = *Blanks
     C                   Eval      EndOfFile = *Off
      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
     C                   Eval      *In81 = *Off
     C                   Eval      StartRRN01 = *Zero
    ?C                   Write     ATT07101C                                    ?

      *? Load the Subfile

     C                   ExSr      OpenData

     C                   Z-add     *Zero         RRN01                          ?

     C                   Eval      StopRRN01 = 9999

     C                   ExSr      ReadData
     C                   DoW       not EndOfFile and RRN01 < StopRRN01
      *? Load screen fields
     C                   ExSr      Load01Fld
     C                   ExSr      ReadData

     C                   EndDo                                                  ?

     C                   IF        *In26 = *On and EndOfFile                    ?
    ?C     RRN01         Chain     ATT07101                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    ATT07101                                     ?
     C                   EndIF                                                  ?

     C                   Eval      SAVFirst   =  SELFirst
     C                   Eval      SAVLast    =  SELLast
     C                   Eval      SAVName    =  SELName

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load01Fld - Load Screen 01 Fields                  :
      *?  :.........................................................:
    ?C     Load01Fld     BegSr                                                  ?

      *? Load screen fields

      *?     Populate subfile fields
     C*                  Put SFL record calulations here

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
      /Free
        Exec SQL //  Get Rate for Labor Class
          Select LCBASE into :LCBASE from FMEMPCLS where LCCLAS = :EMCLAS;
      /End-Free
    ?C                   Write     ATT07101                                     ?
     C                   Eval      *In26 = *On                                  ?Have Data Indicator
     C                   Eval      *In81 = *Off                                  Position Cursor

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Edit00 - EDIT Screen 00                            :
      *?  :.........................................................:
    ?C     Edit00        BegSr                                                  ?

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
      *? Passed all Edits ==> Screen 01
    ?C                   OTHER                                                  ?
     C                   Eval      SAVFirst   =  SELFirst
     C                   Eval      SAVLast    =  SELLast
     C                   Eval      SAVName    =  SELName
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

      *? Process pre-edit Functions F3, F6, F7 & F9
    ?C                   SELECT                                                 ?
      *? Cancel Requested
    ?C                   When         *In03
    ?C                             or *In07
     C                   ExSr      CloseData
     C                   MOVE      *ON           *INLR                          ?
      *? Change Sort
    ?C                   When         *In10
    ?C                   If        *In30
     C                   Eval      *In30 = *Off
    ?C                   Else
     C                   Eval      *In30 = *On
    ?C                   EndIf
    ?C                   ExSr      CloseData
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? Refresh Requested
    ?C                   When         *In05
    ?C                   ExSr      CloseData
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? Restart Requested
    ?C                   When         *In06 and Called
     C                   ExSr      CloseData
     C                   MOVE      *ON           *INLR                          ?
      *? Restart Requested
    ?C                   When         *In06 and not Called
    ?C                   ExSr      Scrn00
      *? Selection Changed
    ?C                   When      SELFirst   <> SAVFirst     or
    ?C                             SELLast    <> SAVLast      or
    ?C                             SELName    <> SAVName
     C                   Eval      SAVFirst   =  SELFirst
     C                   Eval      SAVLast    =  SELLast
     C                   Eval      SAVName    =  SELName
     C                   ExSr      CloseData
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? If no Functions, Check for Options.
    ?C                   OTHER                                                  ?
    ?C                   ExSr      OptS01
      *? Redisplay
    ?C                   ExSr      CloseData
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      OptS01 - Option for Screen 01                      :
      *?  :.........................................................:
    ?C     Opts01        BegSr                                                  ?

     C                   DoW       not %EOF(ATT071FM)
    ?C                   ReadC     ATT07101                                     ?
     C                   If        not %EOF(ATT071FM)
    ?C                   Select                                                 ?
      *? Change Time Record
    ?C                   When      Option = '1' and Called
     C                   ExSr      CloseData
     C                   MOVE      *ON           *INLR                          ?
     C                   Return
    ?C                   When      Option = '2' and not Called
     C                   Call      'ATT070'
     C                   Parm                    EMFILE
     C                   Parm                    EMCARD
    ?C                   When      Option = '4'
     C                   Call      'ATT070'
    ?C                   EndSl                                                  ?
     C                   Eval      Option = ' '
     C                   Eval      *In28 = *On
    ?C                   Update    ATT07101                                     ?
     C                   Eval      *In28 = *Off
     C                   EndIf                                                  ?
     C                   EndDo                                                  ?

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
     C                   Parm      'ATT071'      PgmQ             10            ?Pgm Msg Queue
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

     C                   Eval      SelLAST2  = %Trim(SelLAST)  + '%'
     C                   Eval      SelFIRST2 = %Trim(SelFIRST) + '%'
     C                   Eval      SelNAME2  = '%' + %Trim(SelNAME)  + '%'

     C                   If        *In30

    ?c/exec sql
    ?c+
    ?c+    DECLARE  C1 cursor for
    ?c+
    ?c+    Select   EMFILE                     as FileNumber
    ?c+         ,   EMCARD                     as TimeCard
    ?c+         ,   EMTITL                     as Title
    ?c+         ,   EMHIRE                     as HireDate
    ?c+         ,   EMRHIR                     as ReHireDate
    ?c+         ,   EMCLAS                     as LaborClass
    ?c+         ,   Upper(EMLAST)              as Last_Name
    ?c+         ,   Upper(EMFIRS)              as First_Name
    ?c+         ,   Upper(SubStr(Trim(EMLAST)||', '||EMFIRS,1,25))
    ?c+                                          as Employee_Name
    ?c+    from     FMEMPLOY
    ?c+    where
    ?c+             (EMLAST  like  trim(:SELLAST2)   or :SELLAST2   =  '' )
    ?c+      and    (EMFIRS  like  trim(:SELFIRST2)  or :SELFIRST2  =  '' )
    ?c+      and    (Upper(SubStr(Trim(EMLAST)||', '||EMFIRS,1,25))
    ?c+                      like  trim(:SELNAME2)    or :SELNAME2  =  '' )
    ?c+    Order By
    ?c+             EMLAST
    ?c+           , EMFIRS
    ?c+
    ?c+    For Read only
    ?c+
    ?c/end-exec
     ?*  Open the SQL recordset
    ?c/exec sql
    ?c+                  Open      C1
    ?c/end-exec

    ?C                   Else

    ?c/exec sql
    ?c+
    ?c+    DECLARE  C2 cursor for
    ?c+
    ?c+    Select   EMFILE                     as FileNumber
    ?c+         ,   EMCARD                     as TimeCard
    ?c+         ,   EMTITL                     as Title
    ?c+         ,   EMHIRE                     as HireDate
    ?c+         ,   EMRHIR                     as ReHireDate
    ?c+         ,   EMCLAS                     as LaborClass
    ?c+         ,   Upper(EMLAST)              as Last_Name
    ?c+         ,   Upper(EMFIRS)              as First_Name
    ?c+         ,   Upper(SubStr(Trim(EMLAST)||', '||EMFIRS,1,25))
    ?c+                                          as Employee_Name
    ?c+    from     FMEMPLOY
    ?c+    where
    ?c+             (EMLAST  like  trim(:SELLAST2)   or :SELLAST2   =  '' )
    ?c+      and    (EMFIRS  like  trim(:SELFIRST2)  or :SELFIRST2  =  '' )
    ?c+      and    (Upper(SubStr(Trim(EMLAST)||', '||EMFIRS,1,25))
    ?c+                      like  trim(:SELNAME2)    or :SELNAME2  =  '' )
    ?c+    Order By
    ?c+             EMCLAS
    ?c+           , EMLAST
    ?c+           , EMFIRS
    ?c+
    ?c+    For Read only
    ?c+
    ?c/end-exec
     ?*  Open the SQL recordset
    ?c/exec sql
    ?c+                  Open      C2
    ?c/end-exec

    ?c                   EndIf


    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ReadData - Read Data                               :
      *?  :.........................................................:

     C     ReadData      BegSr

     ?*  Read Sow Schedule Records
     C                   If        *In30
    ?c/exec sql
    ?c+ Fetch C1 into :Employees
    ?c/end-exec
     C                   Else
    ?c/exec sql
    ?c+ Fetch C2 into :Employees
    ?c/end-exec
     C                   EndIf

     C                   If        SQLSTT = '02000'                             ?Read until EOF
     C                   Eval      EndOfFile = *On
     C                   Else
     C                   Eval      EndOfFile = *Off
     C                   Eval      emFILE      = C1_FILE
     C                   Eval      emCARD      = C1_CARD
     C                   Eval      emTITL      = C1_TITL
     C                   Eval      emHIRE      = C1_HIRE
     C                   Eval      emRHIR      = C1_RHIR
     C                   Eval      emCLAS      = C1_CLAS
     C                   Eval      emLAST      = C1_LAST
     C                   Eval      emFIRS      = C1_FIRS
     C                   Eval      NAME        = C1_NAME
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
    ?c/exec sql
    ?c+ Close C2
    ?c/end-exec

     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C     *ENTRY        PList
    ?C                   Parm                    SELNAME
    ?C                   Parm                    EMFILE
    ?C                   Parm                    EMCARD

     C                   Time                    Now

     C                   Eval      *In30 = *On

    ?C                   EndSr                                                  ?
