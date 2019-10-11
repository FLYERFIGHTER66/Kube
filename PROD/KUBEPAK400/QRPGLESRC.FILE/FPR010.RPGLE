     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:            Lookup - All Sizes for Given Item               :?
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
      *? :  07      ?Old Exit                                        ?:
      *? :          ?                                                ?:
      *? :  25      ?SFLDSP, SFLDSPCTL, SFLCLR(N)                    ?:
      *? :  26      ?SFLDSP (Subfile has Data)                       ?:
      *? :  27      ?SFLEND                                          ?:
      *? :  28      ?SFLNXTCHG                                       ?:
      *? :  40      ?Lookup Indicator                                ?:
      *? :  50      ?Error Indicator (All Errors)                    ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
     FFPR010FM  CF   E             WORKSTN
     F                                     SFILE(FPR01001:RRN01)
     F                                     DEVID(WSID)

     FFFINSUM   UF A E           K DISK                                         ?Item by Item/Size
     FFFINSCHIDTIF   E           K DISK                                         ?Finished Schedule
     FFMSIZE    IF   E           K DISK                                         ?Size Code Master
     FFMINVT    IF   E           K DISK                                         ?Item Master
     FFCALEN    IF   E           K DISK                                         ?Calendar File

      *? Function Prototypes
    ?D/COPY QFunctDefn,QCmdExc
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Year
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$AddDate

      *? Arrays
     D   Cmd           S            100A   Dim(0002) CtData                     ?System Commands
     D   FSSW          S                   Dim(0053) Like(FSSW01)               ?Squeduled for Week

      *? Data Structures
     D                SDS
     D  ##PGM            *PROC
     D  User                 254    263

     D WeekHDS         DS                  Inz                                   Week Headers
     D  WEEK01
     D  WEEK02
     D  WEEK03
     D  WEEK04
     D  WEEK05
     D  WeekH                              Like(WEEK01) Dim(05) Overlay(WeekHDS)

     D SWeekDS         DS                  Inz                                   Weeks Quantities
     D  QTY001
     D  QTY002
     D  QTY003
     D  QTY004
     D  QTY005
     D  SWeeks                             Like(QTY001) Dim(05) Overlay(SWeekDS)

     D FWeekDS         DS                  Inz                                   File Quantities
     D  FSSW01
     D  FSSW02
     D  FSSW03
     D  FSSW04
     D  FSSW05
     D  FSSW06
     D  FSSW07
     D  FSSW08
     D  FSSW09
     D  FSSW10
     D  FSSW11
     D  FSSW12
     D  FSSW13
     D  FSSW14
     D  FSSW15
     D  FSSW16
     D  FSSW17
     D  FSSW18
     D  FSSW19
     D  FSSW20
     D  FSSW21
     D  FSSW22
     D  FSSW23
     D  FSSW24
     D  FSSW25
     D  FSSW26
     D  FSSW27
     D  FSSW28
     D  FSSW29
     D  FSSW30
     D  FSSW31
     D  FSSW32
     D  FSSW33
     D  FSSW34
     D  FSSW35
     D  FSSW36
     D  FSSW37
     D  FSSW38
     D  FSSW39
     D  FSSW40
     D  FSSW41
     D  FSSW42
     D  FSSW43
     D  FSSW44
     D  FSSW45
     D  FSSW46
     D  FSSW47
     D  FSSW48
     D  FSSW49
     D  FSSW50
     D  FSSW51
     D  FSSW52
     D  FSSW53
     D  FWeeks                             Like(FSSW01) Dim(53) Overlay(FWeekDS)

     D StatusDS        DS
     D  Scheduled                      N
     D  Complete                       N
     D  StatARA                        N   Dim(2) Overlay(StatusDS)

      *? Field Definitions
     D   GotoYear      S              4S 0                                      ?Year
     D   SaveDate      S                   Like(GotoDate  )                     ?Saved Go to Date
     D   SaveItem      S                   Like(GotoItem  )                     ?Saved Go to Item
     D   SaveSize      S                   Like(GotoSize  )                     ?Saved Go to Size
     D   SaveFSSIZE    S                   Like(FSSIZE    )                     ?Saved FSSIZE
     D   GotoDate7     S                   Like(FLSOWD    )                     ?Goto Date CYYMMDD
     D    BegDate7     S                   Like(FLSOWD    )                     ?Beg of Range
     D    EndDate7     S                   Like(FLSOWD    )                     ?End of Range
     D   RRN01         S              4  0 Inz(0)                               ?SFLRRN Screen 02
     D   ErrCount      S              3S 0 Inz(0)                               ?Error Count
     D   Command       S            100A   Inz(*Blanks)                         ?System Command
     D   X             S              2S 0                                      ?Generic Counter
     D   Y             S              2S 0                                      ?Indicator Index

      /Free
    ?   /COPY QFunctDefn,LASTUSEDCB
      /End-Free
     C     *INLR         DOUEQ     *ON                                          ?COMMENT

    ?C                   SELECT                                                 ?
    ?C     Screen        WhenEq    1                                            ?
     C                   ExSr      Edit01                                       ?
    ?C*    Screen        WhenEq    2                                            ?
     C*                  ExSr      Edit02                                       ?
    ?C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
     C                   Eval      *In25 = *On                                  ?
    ?C                   Write     ASSUME
    ?C                   Write     FPR01001F                                   ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     FPR01001C                                    ?
     C                   ExSr      ClrError                                     ?
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

    ?C                   ExSr      CalcDates
    ?C     GotoDate      Chain     FCALEN                                       ?
     C                   Eval      *In63 = *Off                                  < Previous Entries
     C                   Eval      *In64 = *Off                                  < SubsequentEntries

     C                   Eval      SaveFSSIZE =  *Blanks
      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
    ?C                   Write     FPR01001C                                    ?

      *? Load the Subfile
     C                   Eval      *In28 = *On                                  ?Write w/ SFLNXTCHG
    ?C     GoToKEY       SetLL     FFINSUM                                      ?
    ?C                   Read(N)   FFINSUM

     C                   Z-add     *Zero         RRN01                          ?
    ?C                   DoW       not %EOF(FFINSUM  )                          ?

      *? Test Record
     C                   MoveA     FWeeks(CLWEEK)SWeeks(1)
     C                   If        *In40 and
     C                             %XFoot(SWeeks) = *Zero
    ?C                   Read      FFINSUM
     C                   ITER
     C                   EndIf

      *? New Size Code
     C                   If        FSSIZE  <>  SaveFSSIZE
     C                   Eval      SaveFSSIZE = FSSIZE
     C                   Add       1             RRN01                          ?
    ?C     FSSIZE        Chain     FMSIZE
     C                   Eval      DESC = SZDESC
     C                   Eval      *In61 = *On
    ?C                   Write     FPR01001                                     ?
     C                   Eval      *In61 = *Off
     C                   Eval      *In26 = *On                                  ?
     C                   EndIf

      *? Load Items
     C                   Add       1             RRN01                          ?
    ?C     ItemKey       Chain     FMINVT
     C                   Eval      FSITEM5 = %Subst(FSITEM:1:5)
     C                   If        %Found(FMINVT)
     C                   Eval      DESC = IMDES1
     C                   Else
     C                   Eval      DESC = 'Item Not Found on Master.'
     C                   EndIf

      *? Calculate Quantity Location in time relevant to current time window.
     C                   MoveA     FWeeks(CLWEEK)SWeeks(1)
     C                   Eval      X = *Zero
     C                   DoU       X >= 53 or (*In63 and *In64)
     C                   Eval      X = X + 1
     C                   If        X < CLWEEK and FWeeks(X) > *Zero
     C                   Eval      *In63 = *On
     C                   EndIf
     C                   If        X > CLWEEK+4 and FWeeks(X) > *Zero
     C                   Eval      *In64 = *On
     C                   EndIf
     C                   EndDo

      *? Calculate Scheduled and Produced
     C                   MoveA     '0000000000'  *IN(70)
     C                   Eval      BegDate7 = $Date7($DateMDY(GotoDate))
     C                   Eval      EndDate7 =
     C                             $Date7($AddDate($DateMDY(GotoDate):+35))
    ?C     SchdKey1      SetLL     FFINSCHIDT
    ?C     SchdKey2      ReadE     FFINSCHIDT
     C                   DoW       not %EOF(FFINSCHIDT)
     C                   If        FLSOWD < BegDate7 or
     C                             FLSOWD > EndDate7
     C                   Leave
     C                   EndIf
     C                   Eval      Scheduled = *Off
     C                   Eval      Complete  = *Off
    ?C                   Select
    ?C                   When      FLSTAT = 'S'                                  Scheduled
     C                   Eval      Scheduled = *On
    ?C                   When      FLSTAT = 'C'                                  Completed
     C                   Eval      Complete = *On
    ?C                   EndSL
     C                   Eval      X = 0
     C                   DoU       X >= 5
     C                   Eval      X = X + 1
     C                   Eval      Y = 68 + (X * 2)                             Set *IN70-*IN79
     C                   If        FLSOWD =
     C                             $Date7($AddDate($DateMDY(GotoDate):(x-1)*7))
     C                   MoveA     StatAra       *In(Y)
     C                   EndIf
     C                   EndDo
    ?C     SchdKey2      ReadE     FFINSCHIDT
     C                   EndDo

    ?C                   Write     FPR01001                                     ?
     C                   Eval      *In26 = *On                                  ?
     C                   Eval      *In63 = *Off                                  < Previous Entries
     C                   Eval      *In64 = *Off                                  < SubsequentEntries
    ?C                   Read      FFINSUM
     C                   EndDo                                                  ?

      *? Load Empty Lines for on the fly additions
     C                   Clear                   FPR01001
     C                   MoveA     '0000000000'  *IN(70)
     C                   Eval      *In62 = *On
     C                   Do        10
     C                   Add       1             RRN01                          ?
    ?C                   Write     FPR01001                                     ?
     C                   Eval      *In26 = *On                                  ?
     C                   EndDo                                                  ?
     C                   Eval      *In62 = *Off

     C                   IF        *In26 = *On                                  ?
    ?C     RRN01         Chain     FPR01001                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    FPR01001                                     ?
     C                   EndIF                                                  ?

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

    ?C                   SELECT                                                 ?
      *? Cancel Requested
    ?C                   When      *In03 or *In07
     C                   MOVE      *ON           *INLR                          ?
      *? Show / Hide Blank Lines
    ?C                   When      *In06 and *In40                               *In40 = Hide Blanks
     C                   Eval      *IN40 = *Off                                 ?Show Blanks
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   When      *In06 and not *In40                           *In40 = Hide Blanks
     C                   Eval      *IN40 = *On                                  ?Hide Blanks
     C                   ExSr      Load01
     C                   ExSr      Scrn01
      *? Plus or Minus Weeks
    ?C                   When      *In08
     C                   Eval      GotoDate = $MDYDate(                         ?
     C                             $AddDate($dateMDY(GotoDate):-28))             ?
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   When      *In09
     C                   Eval      GotoDate = $MDYDate(                         ?
     C                             $AddDate($DateMDY(GotoDate):+28))             ?
     C                   ExSr      Load01
     C                   ExSr      Scrn01
      *? Select with Mouse Requested
    ?C*                  When      *In10
    ?C*                  If        SFLCSRRRN <> 0
    ?C*    SFLCSRRRN     Chain     FPR01001
     C*                  MOVE      *ON           *INLR                          ?
     C*                  Else
     C*                  Eval      $#MSGD = 'A'
     C*                  Eval      $#MSID = 'MOU0001'
     C*                  EXSR      SndError
     C*                  Eval      *In52 = *On
     C*                  EXSR      Scrn01
     C*                  EndIf
      *? Toggle Edit all Fields indicator (*In30)
    ?C                   When      *In11 and *In30
     C                   Eval      *In30 = *Off
     C                   ExSr      UpdSize
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   When      *In11 and not *In30
     C                   Eval      *In30 = *On
     C                   ExSr      UpdSize
     C                   ExSr      Load01
     C                   ExSr      Scrn01
      *? If no Functions, Check for GoTo, Update FFINSUM   and Redisplay.
    ?C                   OTHER                                                  ?
      *? If enter pressed without GoTo Change then bail out
     C                   ExSr      UpdSize
     C                   If        GotoItem    <> SaveItem   or
     C                             GotoSize    <> SaveSize
     C                   Eval      SaveDate   = GotoDate
     C                   Eval      SaveItem   = GotoItem
     C                   Eval      SaveSize   = GotoSize
     C                   ExSr      Load01
     C                   ExSr      Scrn01
     C                   else
     C                   ExSr      Load01
     C                   ExSr      Scrn01
     C                   EndIf
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      UpdSize  - Update FFINSUM   and Subfile            :
      *?  :.........................................................:
    ?C     UpdSize       BegSr                                                  ?

    ?C                   ReadC     FPR01001
     C                   DoW       not %EOF(FPR010FM)
     C                   Eval      FSITEM = FSITEM5
    ?C     FINKEY        Chain     FFINSUM
    ?C     RRN01         Chain     FPR01001
     C                   MoveA     SWeeks(1)     FWeeks(CLWEEK)
     C                   Eval      FSITEM = FSITEM5
     C                   Eval      FSSOWQ = %XFoot(Fweeks)
     C                   If        %found(FFINSUM  )
    ?C                   Update    RFINSUM
     C                   Else
    ?C     ItemKey       Chain     FMINVT
     C                   If        %Found(FMINVT)
     C                   Eval      DESC   = IMDES1
     C                   Eval      FSLOOK = IMLOOK
     C                   Eval      FSORDQ = IMQTAL
     C                   Eval      FSDTLA = $MDYDate($Date(0))
     C                   Eval      FSTIME = $Now()
     C                   Eval      FSUSER = $User()
     C                   Eval      FSPROG = 'FPR010'
    ?C                   Write     RFINSUM
     C                   Else
     C                   Eval      DESC   = 'Item not Found, not added'
     C                   EndIF
     C                   EndIF
    ?C                   Update    FPR01001
     C                   Eval      *In51 = *Off
     C                   Eval      *In52 = *Off
    ?C                   ReadC     FPR01001
     C                   EndDo                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      CalcDates - Calculate Header Dates                 :
      *?  :.........................................................:
    ?C     CalcDates     BegSr                                                  ?

     C                   Eval      X = 0
     C                   DoU       X >= 5
     C                   Eval      X = X + 1
     C                   Eval      WeekH(x) = %Subst(%EditW($MDYDate
     C                             ($AddDate($DateMDY(GotoDate):(x-1)*7))
     C                             :'  /  /  '):1:5)
     C                   EndDo
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ClrError - Clear Error Message Subfile             :
      *?  :.........................................................:
    ?C     ClrError      BegSr                                                  ?

     C                   MOVE      'C'           $#MSFN            1            ?
     C                   ExSr      SRMSGF                                       ?
     C                   Eval      ErrCount = *Zero                             ?
     C                   Eval      *In50 = *Off                                 ?Error Indicator

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      SndError - Send an Error Message to the PGMMSGQ    :
      *?  :.........................................................:
    ?C     SndError      BegSr                                                  ?

     C                   MOVE      'S'           $#MSFN            1            ?
     C                   ExSr      SRMSGF                                       ?
     C                   Eval      ErrCount = ErrCount + 1                      ?
     C                   Eval      *In50 = *On                                  ?Error Indicator

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      * ? :      SRMSGF - Clear or send messages to Pgm msg queue   :
      *?  :.........................................................:
    ?C     SRMSGF        BegSr                                                  ?

      *? Define Parameter List - define variables         ?

     C     PLMSGF        PLIST                                                  ?
     C                   Parm                    $#PGMQ           10            ?Pgm Msg Queue
     C                   Parm                    $#MSGF           10            ?Message File
     C                   Parm                    $#MSGL           10            ?Library
     C                   Parm                    $#MSID            7            ?Message Id
     C                   Parm                    $#MSGD          100            ?Message Data
     C                   Parm                    $#MSKY            4            ?Message Key
     C                   Parm                    $#MSFN            1            ?Send or Clear

      *? Call Msg processing CL                           ?

     C                   CALL      'XAMSFC'      PLMSGF                         ?

    ?C                   EndSr                                                  ?

      *?  ..........................................................
      *?  :   Run system command                                   :
      *?  :........................................................:
     C     $Command      BegSR
      *? Format the command String.  Put variable in place in the string.

      *?   |P?=Printer ID?    ?Put the Printer Name in the Override command?
     C*                  Eval      #Printer = PrtToUse
     C*                  DoW       %Scan('|P':Command) <> 0
     C*                  Eval      Command = %REPLACE
     C*                            (%Trim(#Printer): Command :
     C*                              %SCAN('|P': Command))
     C*                  EndDo

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
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C                   MOVE      ##PGM         $#PGMQ                         ?PGM MSG QUEUE
     C                   MOVEL     'KPMSGF'      $#MSGF                         ?MSG FILE N/A
     C                   MOVEL     '*LIBL'       $#MSGL                         ?LIBRARY  N/A
     C                   MOVE      '*******'     $#MSID                         ?MESSAGE ID

     C                   Eval      GotoYEAR = $Year($Date(0))
     C                   Eval      GotoDate = $MDYDate($Monday($Date(0):'SAT'))

     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

     C     FINKEY        KList
     C                   KFld                    FSYEAR
     C                   KFld                    FSSIZE
     C                   KFld                    FSITEM

     C     GotoKEY       KList
     C                   KFld                    GotoYear
     C                   KFld                    GotoSize
     C                   KFld                    GotoItem

     C     SchdKEY1      KList
     C                   KFld                    FSITEM
     C                   KFld                    FSSIZE
     C                   KFld                    BegDate7

     C     SchdKEY2      KList
     C                   KFld                    FSITEM
     C                   KFld                    FSSIZE

     C     ItemKey       KList
     C                   KFld                    FSITEM
     C                   KFld                    FSSIZE

    ?C                   EndSr                                                  ?
**
  Put commands here if we need them

