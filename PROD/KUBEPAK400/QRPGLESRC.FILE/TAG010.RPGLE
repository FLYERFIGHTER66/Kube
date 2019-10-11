    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      *??:````````````````````````````````````````````````````````````:?
      *??:                     Ready Bay Check Out                    :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  March 2006           ? Kube-Pak Corporation ?    :
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
      *? :  70      ?Push Buttone Default 70 = Yes, N70 = No         ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
     FTAG010FM  CF   E             WORKSTN
     FFTRAY     UF   E           K DISK
     FFCARTTAG  UF   E           K DISK
     FFPARTIAL  UF   E           K DISK

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Monday

      *? Field Definitions
     D   ErrCount      S              2  0 Inz(0)                               ?Error Count
     D   Now           S              6S 0 Inz(0)                               ?Array Counter
     D   Today         S               D                                        ?Today
     D   TodayMDY      S              6S 0 Inz(0)                               ?Today  ( MDY )
     D   TodayYMD7     S              7S 0 Inz(0)                               ?Today  ( CYMD7 )
     D   ThisMonday    S              6S 0 Inz(0)                               ?Monday ( MDY )
     D   ThisMonCYMD   S              7S 0 Inz(0)                               ?Monday ( CYMD )
     D   MenuOptions   S              2S 0 Inz(0)                               ?# of Menu Options
     D   OptsSelected  S              2S 0 Inz(0)                               ?# of Options Used

      *? Indicators
     D theMenuIsFull   S               N   Inz(*off)
     D FoundMenu       S               N   Inz(*off)

      *? Arrays

      *? Data Areas

      *? Data Structures
     D                SDS
     D  ##PGM            *PROC

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
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     TAG01001                                     ?
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?
     C                   Eval      Screen = 01
     C                   Eval      TAG = *Zero
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

      *? P R O C E S S   S C R E E N
     C                   SELECT                                                 ?
    ?C                   When      *In03 = *ON                                  ?
     C                   MOVE      *ON           *INLR                          ?
     C                   LeaveSR                                                ?
    ?C                   Other                                                  ?

    ?C     TAG           Chain     FTRAY
     C                   If        %Found(FTRAY)
     C                   Eval      TRSTAT = 'A'
     C                   Eval      TRREAS = ' '
     C                   Eval      TRUSER = 'TAG010'
     C                   Eval      TRDTLA = $MDYDate($Date(0))
     C                   Eval      TRTIME = $Now()
    ?C                   Update    RTRAY
     C                   EndIf

    ?C     TAG           SetLL     FCARTTAG
    ?C     TAG           ReadE     FCARTTAG
     C                   DoW       not %EOF(FCARTTAG)
     C                   Eval      CTITEM = TRITEM
     C                   If        CTSTAT <> 'D'
     C                   Eval      CTSTAT = 'A'
     C                   EndIf
    ?C                   Update    RCART
    ?C     TAG           ReadE     FCARTTAG
     C                   EndDo

    ?C     TAG           Chain     FPARTIAL
     C                   If        %Found(FPARTIAL)
    ?C                   Delete    RPARTIAL
     C                   EndIf

     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
    ?C                   EndSl

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ClrError - Clear Error MEssage Subfile             :
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

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C                   MOVE      ##PGM         $#PGMQ                         ?PGM MSG QUEUE
     C                   MOVEL     'KPMSGF'      $#MSGF                         ?MSG FILE N/A
     C                   MOVEL     '*LIBL'       $#MSGL                         ?LIBRARY  N/A
     C                   MOVE      '*******'     $#MSID                         ?MESSAGE ID

     C                   Time                    Now                            ?Time Now
     C                   Eval      Today = $Date(0)                             ?Today MDY
     C                   Eval      TodayMDY = $MDYDate(Today)                   ?Today MDY
     C                   Eval      TodayYMD7 = $Date7(Today)                    ?Today CYMD7
     C                   Eval      ThisMonday = $MDYDate($Monday(Today:'SAT'))  ?Monday MDY
     C                   Eval      ThisMonCYMD = $Date7($Monday(Today:'SAT'))   ?Monday CYMD

     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

    ?C                   EndSr                                                  ?
