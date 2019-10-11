    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H DftActGrp(*no)
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DatFmt(*usa)
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
      *? :  $ClrError-?Clear Error MEssage Subfile                   ?:
      *? :  $SndError-?Send an Error Message to the PGMMSGQ          ?:
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
      *? :  40      ?Lookup Indicator                                ?:
      *? :  50      ?Error Indicator (All Errors)                    ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
     FTRR505FM  CF   E             WORKSTN
     FFHORDR    UF   E           K DISK                                         ?Order Header
     FFTRSCHDS  IF   E           K DISK                                         ?Truck Schedule

      *? Copy Books
    ?D/COPY QFunctDefn,$ErrMsg

      *? Function Prototypes
    ?D/COPY QFunctDefn,QCmdExc
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$isDate#
    ?D/COPY QFunctDefn,$Weekday

      *? Arrays
     D   Cmd           S            100A   Dim(0002) CtData                     ?System Commands

      *? Data Structures
     D                SDS
     D  ##PGM            *PROC
     D  User                 254    263

      *? Field Definitions
     D  MON7           S                   Like( TRSHDT   )                     ?Go to Date 7
     D  SAT7           S                   Like( TRSHDT   )                     ?Saturday
     D  FRI7           S                   Like( TRSHDT   )                     ?Friday
     D  SaveDate       S                   Like(MON       )                     ?Saved Go to Date
     D  X              S              1S 0                                      ?Generic Counter

     D  ErrCount       S              3S 0 Inz(0)                               ?Error Count
     D  Command        S            100A   Inz(*Blanks)                         ?System Command
     D  ShpWeek        S               D

      *?  ...........................................................
      *?  :      M A I N   C A L C S                                :
      *?  :.........................................................:

     C     *INLR         DOUEQ     *ON                                          ?COMMENT

    ?C                   SELECT                                                 ?
    ?C     Screen        WhenEq    1                                            ?
    ?C                   ExSr      Edit01                                       ?
    ?C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
     C                   Eval      *In25 = *On                                  ?
    ?C                   Write     ASSUME
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     TRR50501                                     ?
    ?C                   ExSr      $ClrError                                     ?
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

    ?C                   SELECT                                                 ?
      *? Cancel Requested
    ?C                   When      *In03
     C                   MOVE      *ON           *INLR                          ?
      *? Check Zero Date
    ?C                   When      MON  = *Zeros                                ?No Date Entered
     C                   Eval      $ERR_MsgID = 'DATE902'
     C                   Eval      $ERR_MsgData = 'Ship Week Monday'
    ?C                   ExSr      $SndError
    ?C                   ExSr      Scrn01
      *? Check Is Date
    ?C                   When      not $isDate#(MON   :'*MDY')
     C                   Eval      $ERR_MsgID = 'DATE901'
     C                   Eval      $ERR_MsgData = %Char(MON   )
    ?C                   ExSr      $SndError
    ?C                   ExSr      Scrn01
      *? Check Monday
    ?C                   When      $WeekDay($DateMDY(MON):'MON') <> 1
     C                   Eval      $ERR_MsgID = 'DATE904'
     C                   Eval      $ERR_MsgData = %EditW(MON:'  /  /  ')
     C                   Eval      MON    =
     C                             $MDYDate($Monday($DateMDY(MON):'MON'))
     C                   Eval      $ERR_MsgData = %Trim($ERR_MsgData) +
     C                             %EditW(MON:'  /  /  ')
    ?C                   ExSr      $SndError
    ?C                   ExSr      Scrn01
      *? Minus a Week
    ?C                   When      WeekMinus <> 0 or *In08
     C                   Eval      MON      =
     C                             $MDYDate($AddDate($DateMDY(MON):-7))
    ?C                   ExSr      Scrn01
      *? Plus a Week
    ?C                   When      WeekPlus  <> 0 or *In09
     C                   Eval      MON      =
     C                             $MDYDate($AddDate($DateMDY(MON):+7))
    ?C                   ExSr      Scrn01

      *? If no Functions, Check for GoTo, Update FTRHDRH1 and Redisplay.
    ?C                   OTHER                                                  ?
      *? If enter pressed without GoTo Change then bail out
    ?C                   ExSr      UpdHeaders
    ?C                   ExSr      Scrn01

    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      UpdHeaders - Update order headers from Trucks      :
      *?  :.........................................................:
    ?C     UpdHeaders    BegSr                                                  ?

     C                   Eval      SAT7 = $Date7($addDate($DateMDY(MON):-2))
     C                   Eval      FRI7 = $Date7($addDate($DateMDY(MON):+4))

    ?C     SAT7          SetLL     FTRSCHDS
    ?C                   Read      FTRSCHDS
    ?C                   DoW       not %EOF(FTRSCHDS) and TRSHDT <= FRI7        ?
    ?C     TRORD#        CHAIN     FHORDR
     C                   If        %Found(FHORDR)
     C                   Eval      OHDTCN = $MDYDate($Date(TRSHDT))
     C                   Eval      OHROUT = TRTRK#
     C                   Eval      OHSTOP = TRSTP#
    ?C                   Update    RHORDR
     C                   EndIf
    ?C                   Read      FTRSCHDS
    ?C                   EndDo                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ERRMSG - Error Message Handling Subroutines        :
      *?  :.........................................................:
    ?D/COPY QFunctDefn,$ErrMsgSr

      *?  ..........................................................
      *?  :   Run system command                                   :
      *?  :........................................................:
    ?C     $Command      BegSR
      *? Format the command String.  Put variable in place in the string.

      *?   ~ ?=Blank that needs to be removed??Replace with nothing?
     C                   DoW       %Scan('~':Command) <> 0
     C                   Eval      Command =
     C                               %SubSt(Command:1:%Scan('~':Command)-1)
     C                             + %SubSt(Command:%Scan('~':Command)+1:
     C                               %Len(Command) - %Scan('~':Command))
     C                   EndDo

      *? Execute the Command using QCMDEXC.
     C                   CALLP     QCmdExc(Command:%len(%Trim(Command)))

    ?C                   EndSR

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C                   Eval      MON  = $MDYDate($Monday($Date(0):'SAT'))
     C                   Eval      MON7 = $Date7($DateMDY(MON))

     C                   Eval      $ERR_PROG     = ##PGM
     C                   Eval      $ERR_MSGF     = 'KPMSGF'
     C                   Eval      $ERR_LIBR     = '*LIBL'
     C                   Eval      $ERR_MsgID    = '*******'
     C                   Eval      $ERR_MsgData  = *Blanks
    ?C                   ExSr      $ClrError                                    ?

    ?C                   ExSr      Load01                                       ?
    ?C                   ExSr      Scrn01                                       ?

    ?C                   EndSr                                                  ?
**
  Put commands here if we need them

