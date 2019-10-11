    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Attendance Master Inquiry                          :?
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
     FLKVENDFM1 CF   E             WORKSTN
     F                                     SFILE(LKVEND01:RRN01)
     F                                     DEVID(WSID)
     FFMVEND    IF   E           K DISK


      *? Function Prototypes
    ?D/COPY QFunctDefn,QCmdExc

     D  VendorDS       DS
     D   C1_VMVEND                         Like(VMVEND)                         ?Vendor #
     D   C1_VMNAME                         Like(VMNAME)                         ?Vendor Name
     D   C1_VMADD2                         Like(VMADD2)                         ?Address
     D   C1_VMADD3                         Like(VMADD3)                         ?Address2
     D   C1_VMCITY                         Like(VMCITY)                         ?City
     D   C1_VMSTST                         Like(VMSTST)                         ?State
     D   C1_VMZIPD                         Like(VMZIPD)                         ?Zip Code
     D   C1_VMPHON                         Like(VMPHON)                         ?Phone
     D   C1_VMFAX                          Like(VMFAX )                         ?Fax
     D   C1_VMGLAC                         Like(VMGLAC)                         ?G/L Account
     D   C1_VMLOOK                         Like(VMLOOK)                         ?Alpha Search

      *? Field Definitions
     D   User          S             10A                                        ?Current User ID
     D   Today         S              6S 0                                      ?Todays Date MDY
     D   Program       S             10A                                        ?Program
     D   FileName      S             10A                                        ?File Name for Label

     D   RRN01         S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   StopRRN01     S              4  0 Inz(0)                               ?SFLRRN Screen 01
     D   Step01        S              4  0 Inz(0)                               ?SFLRRN 01 Increment
     D   ErrorCount    S              3S 0 Inz(0)                               ?Error Count
     D   ErrorCount01  S              3S 0 Inz(0)                               ?Error Count
     D   RecordCount   S              5S 0 INZ(0)
     D   ChainRRN01    S              4S 0 Inz(*Zero)                           ?Key by RRN

     D   SAVSearch     S                   Like(Search)                         ?Search Criteria
     D   SQLSearch     S             17                                         ?Search Criteria

     D   X             S              2S 0                                      ?Array Index

      *? Arrays
     D   FND           S              2S 0 Dim(14) Inz(*Zeros)

      *? Indicators
     D   EndOfFile     S               N
     D   In31          S               N

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
    ?C                   ExFmt     LKVEND00                                     ?
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
    ?C                   Write     LKVEND01F                                   ?

     C                   If        ErrorCount01 <> *Zero                        ?Error Count
    ?C                   Write     MSGCTL                                       ?
     C                   EndIf

     C                   If        StartRRN01 = *Zero
     C                   Eval      StartRRN01 = 1
     C                   EndIf

    ?C                   ExFmt     LKVEND01C                                    ?

    ?C                   ExSr      ClrError                                     ?
     C                   Eval      ErrorCount01 = *Zero                         ?Error Count
     C                   Eval      *In25 = *Off                                 ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load00 - Load Screen 00                            :
      *?  :.........................................................:
    ?C     Load00        BegSr                                                  ?

     C                   Eval      *In83 = *Off

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

     C                   Eval      SQLSearch  =  '%' + %Trim(Search) + '%'
     C                   Eval      Step01 = 18 * ( 1 )
     C                   Eval      EndOfFile = *Off
      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
     C                   Eval      *In81 = *Off
     C                   Eval      StartRRN01 = *Zero
    ?C                   Write     LKVEND01C                                    ?

      *? Load the Subfile

     C                   ExSr      OpenData

     C                   Z-add     *Zero         RRN01                          ?

     C                   Eval      StopRRN01 = Step01

      *? Get the Data
     C                   ExSr      ReadData
     C                   DoW       not EndOfFile and RRN01 < StopRRN01
     C                   ExSr      Load01Fld
     C                   ExSr      ReadData
     C                   EndDo                                                  ?

     C                   IF        *In26 = *On and EndOfFile                    ?
    ?C     RRN01         Chain     LKVEND01                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    LKVEND01                                     ?
     C                   EndIF                                                  ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      More01 - Load Screen 01 w/ More records            :
      *?  :.........................................................:
    ?C     More01        BegSr                                                  ?

     C                   If        not EndOfFile

     C                   Eval      SQLSearch  =  '%' + %Trim(Search) + '%'
     C                   Eval      StartRRN01= RRN01 + 1
     C                   Eval      StopRRN01 = RRN01 + Step01

      *? Get Data
     C                   ExSr      ReadData
     C                   DoW       not EndOfFile and RRN01 < StopRRN01
     C                   ExSr      Load01Fld
     C                   ExSr      ReadData
     C                   EndDo                                                  ?

     C                   IF        EndOfFile                                    ?
    ?C     RRN01         Chain     LKVEND01                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    LKVEND01                                     ?
     C                   EndIF                                                  ?
     C                   EndIf                                                  ?

     C                   If        RRN01 < StartRRN01
     C                   Eval      StartRRN01 = StartRRN01 - Step01
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load01Fld - Load Screen 01 Fields                  :
      *?  :.........................................................:
    ?C     Load01Fld     BegSr                                                  ?

      *? Load screen fields

      *?     Populate subfile fields
     C*                  Put SFL record calulations here
     C                   Eval      FND(01) = %Scan(%Trim(Search):%Char(VMVEND))
     C                   Eval      FND(02) = %Scan(%Trim(Search):VMNAME)
     C                   Eval      FND(03) = %Scan(%Trim(Search):VMADD2)
     C                   Eval      FND(04) = %Scan(%Trim(Search):VMADD3)
     C                   Eval      FND(05) = %Scan(%Trim(Search):VMCITY)
     C                   Eval      FND(06) = %Scan(%Trim(Search):VMSTST)
     C                   Eval      FND(07) = %Scan(%Trim(Search):VMZIPD)
     C                   Eval      FND(08) = %Scan(%Trim(Search):%Char(VMPHON))
     C                   Eval      FND(09) = %Scan(%Trim(Search):%Char(VMFAX ))
     C                   Eval      FND(10) = %Scan(%Trim(Search):%Char(VMGLAC))
     C                   Eval      FND(11) = %Scan(%Trim(Search):VMLOOK)
     C                   Eval      FND(12) = %Scan(%Trim(Search):VMVCON)

     C                   Eval      X = 1
     C                   DoW       X < 14
     C                   Eval      *IN(60+X) = *Off
     C                   If        FND(X) > 0
     C                   Eval      *IN(60+X) = *On
     C                   EndIf
     C                   Eval      X = X + 1
     C                   EndDo

     C                   Eval      *In81 = *Off                                  Position Cursor
      *?     Check to see if this is the starting screen
     C                   If        StartRRN01 = 0
     C                   Eval      *In81 = *On                                   Position Cursor
     C                   Eval      StartRRN01 = RRN01
     C                   EndIf

      *?  :````````````````````````````````````````````````````````````:
      *?  :              Load SFL Fields here ! ! !                    :
      *?  :............................................................:

      *? Write Subfile Record
     C                   Add       1             RRN01                          ?
    ?C                   Write     LKVEND01                                     ?
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
     C                   Eval      SAVSearch  =  Search
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
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? Restart Requested
    ?C                   When         *In06
    ?C                   ExSr      Scrn00
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? Selection Changed
    ?C                   When      SavSearch  <> Search
     C                   Eval      SAVSearch  =  Search
     C                   ExSr      CloseData
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01
      *? If no Functions, Check for Options.
    ?C                   OTHER                                                  ?
    ?C                   ExSr      OptS01
    ?C                   ExSr      Load01
      *? Redisplay
    ?C                   ExSr      Scrn01
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      OptS01 - Option for Screen 01                      :
      *?  :.........................................................:
    ?C     Opts01        BegSr                                                  ?

     C                   DoW       not %EOF(LKVENDFM1)
    ?C                   ReadC     LKVEND01                                     ?
     C                   If        not %EOF(LKVENDFM1)
    ?C                   Select                                                 ?
      *? Process Options
    ?C                   When      Option = '1'
     C                   Move      VMVEND        Account
     C                   ExSr      CloseData
     C                   Eval      *InLR = *On
     C                   Return
    ?C                   When      Option = '2'
     C                   Move      VMVEND        Account
     C                   Call      'APR010CCL'
     C                   Parm      'C'           Type              1
     C                   Parm                    Account
    ?C                   When      Option = '5'
     C                   Move      VMVEND        Account
     C                   Call      'APR010CCL'
     C                   Parm      'I'           Type              1
     C                   Parm                    Account
    ?C                   When      Option = '6'
     C                   Move      VMVEND        Account
     C                   Call      'APR240CCL'
     C                   PARM                    Account
    ?C                   EndSl                                                  ?
     C                   Eval      Option = ' '
     C                   Eval      *In28 = *On
    ?C                   Update    LKVEND01                                     ?
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
     C                   Parm      'LKVEND'      PgmQ             10            ?Pgm Msg Queue
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
    ?c+    select   VMVEND
    ?c+         ,   VMNAME
    ?c+         ,   VMADD2
    ?c+         ,   VMADD3
    ?c+         ,   VMCITY
    ?c+         ,   VMSTST
    ?c+         ,   VMZIPD
    ?c+         ,   VMPHON
    ?c+         ,   VMFAX
    ?c+         ,   VMGLAC
    ?c+         ,   VMLOOK
    ?c+    from     FMVEND
    ?c+    where    VMVEND like trim(:SQLSearch)
    ?c+       or    VMNAME like trim(:SQLSearch)
    ?c+       or    VMADD2 like trim(:SQLSearch)
    ?c+       or    VMADD3 like trim(:SQLSearch)
    ?c+       or    VMCITY like trim(:SQLSearch)
    ?c+       or    VMSTST like trim(:SQLSearch)
    ?c+       or    VMZIPD like trim(:SQLSearch)
    ?c+       or    VMPHON like trim(:SQLSearch)
    ?c+       or    VMFAX  like trim(:SQLSearch)
    ?c+       or    VMGLAC like trim(:SQLSearch)
    ?c+       or    VMLOOK like trim(:SQLSearch)
    ?c+    Order By VMLOOK
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
    ?c+ Fetch C1 into :VendorDS
    ?c/end-exec

     C                   If        SQLSTT = '02000'                             ?Read until EOF
     C                   Eval      EndOfFile = *On
     C                   Else
     C                   Eval      EndOfFile = *Off
     C                   Eval      VMVEND      = C1_VMVEND
     C                   Eval      VMNAME      = C1_VMNAME
     C                   Eval      VMADD2      = C1_VMADD2
     C                   Eval      VMADD3      = C1_VMADD3
     C                   Eval      VMCITY      = C1_VMCITY
     C                   Eval      VMSTST      = C1_VMSTST
     C                   Eval      VMZIPD      = C1_VMZIPD
     C                   Eval      VMPHON      = C1_VMPHON
     C                   Eval      VMFAX       = C1_VMFAX
     C                   Eval      VMGLAC      = C1_VMGLAC
     C                   Eval      VMLOOK      = C1_VMLOOK
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

    ?C     *Entry        PList
    ?C                   Parm                    Search                         ?
    ?C                   Parm                    Account           6            ?

     C                   Eval      *In83 = *Off
     C                   Eval      *In31 = *Off
     C                   Eval      In31 = *Off
     C                   Eval      C1_VMVEND = *Zeros
    ?C     C1_VMVEND     Chain     FMVEND

     C                   Eval      SAVSearch = Search
    ?C                   ExSr      ClrError                                     ?
     C                   If        Search = *Blanks
    ?C                   ExSr      Scrn00                                       ?
     C                   Else
    ?C                   ExSr      Load01                                       ?
    ?C                   ExSr      Scrn01                                       ?
     C                   EndIf

    ?C                   EndSr                                                  ?
