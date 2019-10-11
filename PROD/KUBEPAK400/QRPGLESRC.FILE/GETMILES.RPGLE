    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         GET SOW DATE FROM REQUESTED DATE                   :?
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
      *? :  $ClrError-?Clear Error MEssage Subfile                   ?:
      *? :  $SndError-?Send an Error Message to the PGMMSGQ          ?:
      *? :  $SRMSGF  -?Clear or send messages to Pgm msg queue       ?:
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
      *? :............................................................:
      *
     FFMZIPSZC  UF A E           K DISK
     FGETMILESFMCF   E             WORKSTN

      *? Copy Books
    ?D/COPY QFunctDefn,$ErrMsg

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Center
    ?D/COPY QFunctDefn,$WeekDay
    ?D/COPY QFunctDefn,$Week#
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$IsDate#
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$Duration
    ?D/COPY QFunctDefn,QCmdExc

      *? Field Definitions
     D   User          S             10A                                        ?Current User ID
     D   Today         S               D                                        ?Todays Date MDY
     D   Now           S               T                                        ?The Time at *Init
     D   Program       S             10A                                        ?Program
     D   Start         S               D                                        ?Starting Date
     D   X             S              2S 0                                      ?Counter

    ?C     ZMZIP         Chain     FMZIPSZC
     C                   If        %Found(FMZIPSZC) and
     C                             ZMMILE <> *Zero and
     C                             Force <> 'Y'
     C                   Eval      *InLR = *On
     C                   Return
     C                   Else

    ?C                   ExSr      $ClrError
    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01                                       ?

     C     *INLR         DoUEq     *ON                                          ?Do Until Done

    ?C                   SELECT                                                 ?
    ?C     Screen        WhenEq    01                                           ?
    ?C                   ExSr      Edit01                                       ?
    ?C                   ENDSL                                                  ?

     C                   EndDo                                                  ?

     C                   EndIf

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   If        Screen <> 01
     C                   Z-Add     Screen        PrevScreen        3 0          ?Prev. Screen
     C                   EndIf
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
    ?C*                  Write     ASSUME
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     SCRNA                                        ?
    ?C                   ExSr      $ClrError                                    ?
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

    ?C                   Select                                                 ?
    ?C                   When      *In03
     C                   Eval      *InLR = *On

    ?C                   When      CheckMiles = 1
     C                   Eval      ZIP@ = %subst(%EditW(ZMZIP+0:'0     '):2:5)
     C                   Call      'GOOGLE_ZIP'
     C                   Parm                    ZIP@              5
    ?C                   ExSr      Scrn01

    ?C                   When      ZMMILE <> *Zero
     C                   If        %Found(FMZIPSZC)
    ?C                   Update    RMZIPS
     C                   Else
    ?C                   Write     RMZIPS
     C                   EndIf
     C                   Eval      *InLR = *On

    ?C                   Other

    ?C                   ExSr      Scrn01

    ?C                   EndSl

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      ERRMSG - Error Message Handling Subroutines        :
      *?  :.........................................................:
    ?D/COPY QFunctDefn,$ErrMsgSr

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C     *ENTRY        PList                                                  ?
    ?C                   Parm                    ZMZIP@            5
    ?C                   Parm                    ZMMILE
    ?C                   Parm                    Force             1

     C                   Eval      ZMZIP  = %Int(%Trim(ZMZIP@))
     C                   Eval      ZMZIP@ = %subst(%EditW(ZMZIP+0:'0     '):2:5)
     C                   Eval      ZMMILE = *Zeros

     C                   Time                    Today
     C                   Time                    Now

     C                   Eval      $ERR_PROG  = 'GETMILES  '                    ?Pgm Msg Queue
     C                   Eval      $ERR_MSGF  = 'KPMSGF'                        ?Message File
     C                   Eval      $ERR_LIBR  = '*LIBL'                         ?Library

    ?C                   EndSr                                                  ?
