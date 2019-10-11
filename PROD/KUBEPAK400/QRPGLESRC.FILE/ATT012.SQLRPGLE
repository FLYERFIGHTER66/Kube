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
     FATT012FM  CF   E             WORKSTN

     FFMATTENDEMIF   E           K DISK                                         ?Attendance Master
     FFMEMPLOY  IF   E           K DISK                                         ?Employee Master
     FXATABL    IF   E           K DISK                                         ?Table File

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$Center
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$Duration
    ?D/COPY QFunctDefn,QCmdExc
    ?D/COPY QFunctDefn,$MONDAY

     D   ErrorCount    S              3S 0                                      ?Error Count
     D   ErrorCount01  S              3S 0                                      ?Error Count
     D   JobCode       S                   Like(TBTBCD)                         ?Job Code
     D   EmployeeSV    S                   Like(EMPLOYEE)                       ?Employee #
     D   Today         S                   Like(ATDATE)                         ?Date

      *? Indicators

    ?C                   ExSr      ClrError                                     ?
    ?C                   ExSr      Scrn01                                       ?

     C     *INLR         DOUEQ     *ON                                          ?COMMENT

    ?C                   SELECT                                                 ?
    ?C     Screen        WhenEq    01                                           ?
    ?C                   ExSr      Edit01                                       ?
    ?C     Screen        WhenEq    02                                           ?
    ?C                   ExSr      Edit02                                       ?
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
    ?C                   Write     MSGCTL
    ?C                   ExFmt     ATT01201                                     ?
    ?C                   ExSr      ClrError                                     ?
     C                   Eval      ErrorCount01 = *Zero                         ?Error Count
    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Scrn02 - Display Screen 02                         :
      *?  :.........................................................:
    ?C     Scrn02        BegSr                                                  ?
     C                   If        Screen <> 02
     C                   Z-Add     Screen        PrevScreen        3 0          ?Prev. Screen
     C                   EndIf
     C                   Z-Add     02            Screen            3 0          ?Screen  Number
    ?C                   Write     MSGCTL
    ?C                   ExFmt     ATT01202                                     ?
    ?C                   ExSr      ClrError                                     ?
     C                   Eval      ErrorCount01 = *Zero                         ?Error Count
    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

     C                   Eval      Employee = *Zero

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load02 - Load Screen 02                            :
      *?  :.........................................................:
    ?C     Load02        BegSr                                                  ?

     C                   Eval      EmployeeSV = Employee

     C                   Eval      Name = $Center(
     C                              %Subst(%Trim(EMLAST)+', '+EMFIRS:1:25):25)
     C                   If        EMSTTS <> 'I'
     C                   Eval      INOROUT = 'OUT'
     C                   Else
     C                   Eval      INOROUT = 'IN'
     C                   EndIf
     C                   Eval      JobCode  = 'JC' + EMTYPE
    ?C     JobCode       Chain     XATABL
     C                   If        %Found(XATABL)
     C                   Eval      JobType = $Center(TBSHRT:15)
     C                   Else
     C                   Eval      JobType = *Blanks
     C                   EndIf
    ?C     ClockKey      SetGT     FMATTENDEM
    ?C     ClockKey      ReadPE    FMATTENDEM
    ?C     ClockKey      KList                                                  ?
    ?C                   KFld                    EMFILE
     C                   If        not %EOF(FMATTENDEM)
     C                   Eval      LASTPUNCH = ATENDT
     C                   EndIf

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

     C                   Eval      EMCARD = Employee
     C                   Call      '#EMPFILE#'
     C                   Parm                    EMCARD
     C                   Parm                    EMFILE
     C                   Parm                    name
    ?C*    TXCARD        Chain     FMEMPXREF
    ?C     EMFILE        Chain     FMEMPLOY

      *? Process pre-edit Functions F3, F6, F7 & F9
    ?C                   SELECT                                                 ?
      *? Cancel Requested
    ?C                   When         *In03
    ?C                             or *In07
     C                   MOVE      *ON           *INLR                          ?
      *? Check Valid Card Number
    ?C                   When      not %Found(FMEMPLOY)
     C                   Eval      MessageDta = %Char(EMPLOYEE)
     C                   Eval      MessageID = 'EMP0001'
    ?C                   ExSr      SndError
    ?C                   ExSr      Scrn01
      *? Passed all Edits ==> Screen 02
    ?C                   OTHER                                                  ?
    ?C                   ExSr      Load02
    ?C                   ExSr      Scrn02
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Edit02 - EDIT Screen 02                            :
      *?  :.........................................................:
    ?C     Edit02        BegSr                                                  ?

      *? Process pre-edit Functions F3, F6, F7 & F9
    ?C                   SELECT                                                 ?
      *? Cancel Requested
    ?C                   When         *In03
    ?C                             or *In07
     C                   MOVE      *ON           *INLR                          ?
      *? When New Employee
    ?C                   When      Employee <> EmployeeSV
     C                   Eval      Screen = 01
    ?C                   ExSr      Edit01
      *? Passed all Edits ==> Screen 01
    ?C                   OTHER                                                  ?
    ?C                   ExSr      Scrn01
    ?C                   ENDSL                                                  ?

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
     C                   Parm      'ATT012'      PgmQ             10            ?Pgm Msg Queue
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
    ?C     *INZSR        BegSr                                                  ?

     C                   Time                    Today

    ?C                   EndSr                                                  ?
