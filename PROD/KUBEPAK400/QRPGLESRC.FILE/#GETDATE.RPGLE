     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:        Printer Selection and Default Maintenance           :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  May 2004             ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :  This program is used to select which printer to use for  ?:
      *? :  the current program and also as Maintenance for the      ?:
      *? :  Default Printer File (DFTPRTPF)                          ?:
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
      *? :  51      ?Error: *USR Printer not Valid                   ?:
      *? :  52      ?Error: *PGM Printer not Valid                   ?:
      *? :  70      ?Push Buttone Default 70 = Yes, N70 = No         ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
     F#GETDATEFMCF   E             WORKSTN
      *? Program Status Data Structure
     D                SDS                                                       ?OverRide to Printer
     D   ##PGM           *PROC                                                  ?Progride to Printer

      *? Field Definitions
     D   #User         S             10A
     D   #Pgm          S             10A
     D   #WorkFmDate   S               D
     D   #WorkToDate   S               D

      *? Function Prototype(s)
    ?D/Copy QFunctDefn,$isDate#
    ?D/Copy QFunctDefn,$WeekDay
    ?D/Copy QFunctDefn,$DateMDY
    ?D/Copy QFunctDefn,$MDYDate
    ?D/Copy QFunctDefn,$AddDate
    ?D/Copy QFunctDefn,$Monday
    ?D/Copy QFunctDefn,$Date
    ?D/Copy QFunctDefn,$Center
    ?D/Copy QFunctDefn,$User
    ?D/Copy QFunctDefn,$ERRMSG

     C     *INLR         DOUEQ     *ON                                          ?COMMENT

     C                   SELECT                                                 ?
     C     Screen        WhenEq    1                                            ?
     C                   ExSr      Edit01                                       ?
     C     Screen        WhenEq    2                                            ?
     C                   ExSr      Edit02                                       ?
     C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

     C                   Return

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     #GETDATE01                                     ?
     C                   ExSr      $ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

      *? Load the Screen Values

     C                   Eval      Text01 = $Center(%trim(#Text01):40)
     C                   Eval      Text02 = $Center(%trim(#Text02):40)
     C                   Eval      Text03 = $Center(%trim(#Text03):40)
     C                   Eval      Text04 = $Center(%trim(#Text04):40)
     C                   Eval      Text05 = $Center(%trim(#Text05):40)

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

    ?C                   SELECT                                                 ?
      *? View Selection Criteria
    ?C                   When      *In11 = *ON                                          ?
     C                   ExSr      Load02
     C                   ExSr      Scrn02
      *? Check for Cancel Request
    ?C                   When      *In12 = *On                                          ?
     C                   Eval      SelDate = *Zero
     C                   Eval      *InLR = *On
      *? If no Functions, Check for "Printer to Use" for validity
    ?C                   OTHER                                                  ?
    ?C                   Select                                                 ?
      *?     Check valid Date.
    ?C                   When      not $isDate#(SelDate:'*MDY')
     C                   Eval      $ERR_MsgID = 'DATE901'
     C                   Eval      $ERR_MsgData = %char(SelDate)
     C                   ExSr      $SndError
     C                   ExSr      Scrn01
      *?     Check within Date Range
    ?C                   When      $DateMDY(SelDate) < #WorkFmDate or
    ?C                             $DateMDY(SelDate) > #WorkToDate
     C                   Eval      $ERR_MsgID = 'DATE905'
     C                   Eval      $ERR_MsgData = %editc(#FromDate:'Y')+
     C                                             %editc(#ToDate:'Y')
     C                   ExSr      $SndError
     C                   ExSr      Scrn01
      *?     Check valid day
    ?C                   When      *in(70+$Weekday($DateMDY(SelDate):'SAT'))='0'
     C                   Eval      $ERR_MsgID = 'DATE906'
     C                   ExSr      $SndError
     C                   ExSr      Scrn01
      *?     Check Prior Required
    ?C                   When      #ReqPrior = '1' and
    ?C                             $DateMDY(SelDate) > $Date(0)
     C                   Eval      $ERR_MsgID = 'DATE907'
     C                   ExSr      $SndError
     C                   ExSr      Scrn01
      *?     Check Future Required
    ?C                   When      #ReqFuture = '1' and
    ?C                             $DateMDY(SelDate) < $Date(0)
     C                   Eval      $ERR_MsgID = 'DATE908'
     C                   ExSr      $SndError
     C                   ExSr      Scrn01
      *?     Check Today Allowed
    ?C                   When      #TodayOK <> '1' and
    ?C                             $DateMDY(SelDate) = $Date(0)
     C                   Eval      $ERR_MsgID = 'DATE909'
     C                   ExSr      $SndError
     C                   ExSr      Scrn01
    ?C                   OTHER
      *?     Passed all edits
     C                   Eval      *InLR = *On
    ?C                   ENDSL                                                  ?

    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn02 - Display Screen 02                         :
      *?  :.........................................................:
    ?C     Scrn02        BegSr                                                  ?
     C                   Z-Add     02            Screen            3 0          ?Screen  Number
    ?C*                  Write     MSGCTL                                       ?
    ?C                   ExFmt     #GETDATE02                                    ?
     C                   ExSr      $ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load02 - Load Screen 02                            :
      *?  :.........................................................:
    ?C     Load02        BegSr                                                  ?

     C                   Eval      FromDate = #FromDate
     C                   Eval      ToDate   = #ToDate
    ?C                   Select                                                 ?
    ?C                   When      #ReqPrior = '1' and #TodayOK = '1'           ?
     C                   Eval      Prior   = 'YES - Today or before.   '
     C                   Eval      Future  = 'NO  - Not Allowed.       '
     C                   Eval      TodayOK = 'YES - Today is Allowed.  '
    ?C                   When      #ReqPrior = '1' and #TodayOK = '0'           ?
     C                   Eval      Prior   = 'YES - Before Today.      '
     C                   Eval      Future  = 'NO  - Not Allowed.       '
     C                   Eval      TodayOK = 'NO  - Not Allowed.       '
    ?C                   When      #ReqFuture = '1' and #TodayOK = '1'           ?
     C                   Eval      Future  = 'YES - Today and after.   '
     C                   Eval      Prior   = 'NO  - Not Allowed.       '
     C                   Eval      TodayOK = 'YES - Today is Allowed.  '
    ?C                   When      #ReqFuture = '1' and #TodayOK = '0'           ?
     C                   Eval      Future  = 'YES - After Today.       '
     C                   Eval      Prior   = 'NO  - Not Allowed.       '
     C                   Eval      TodayOK = 'NO  - Not Allowed.       '
    ?C                   When      #ReqPrior  = '0' and #ReqFuture =  '0'           ?
    ?C                                              and #TodayOK   =  '1'
     C                   Eval      Future  = 'Future Allowed.          '
     C                   Eval      Prior   = 'Prior Allowed.           '
     C                   Eval      TodayOK = 'Today Allowed.           '
    ?C                   When      #ReqPrior  = '0' and #ReqFuture =  '0'           ?
    ?C                                              and #TodayOK   =  '0'
     C                   Eval      Future  = 'Future Allowed.          '
     C                   Eval      Prior   = 'Prior Allowed.           '
     C                   Eval      TodayOK = 'Today is not allowed.    '
    ?C                   Other                                                  ?
     C                   Eval      Future  = 'CRITERIA ERROR           '
     C                   Eval      Prior   = 'CRITERIA ERROR           '
     C                   Eval      TodayOK = 'CRITERIA ERROR           '
    ?C                   EndSl                                                  ?

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit02 - EDIT Screen 02                            :
      *?  :.........................................................:
    ?C     Edit02        BegSr                                                  ?
     C                   ExSr      Scrn01
    ?C                   EndSr                                                  ?

    ?C/Copy QFunctDefn,$ERRMSGSR

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C     *Entry        PList
     C     SelDate       Parm      SelDate       #Date             6 0
     C                   Parm                    #FromDate         6 0
     C                   Parm                    #ToDate           6 0
     C                   Parm                    #DaysOK           7            SSMTWTF
     C                   Parm                    #ReqPrior         1
     C                   Parm                    #ReqFuture        1
     C                   Parm                    #TodayOK          1
     C                   Parm                    #Text01          40
     C                   Parm                    #Text02          40
     C                   Parm                    #Text03          40
     C                   Parm                    #Text04          40
     C                   Parm                    #Text05          40

     C                   MoveA     #DaysOK       *IN(71)

     C                   If        $isDate#(#FromDate:'*MDY')
     C                   Eval      #WorkFmDate = $DateMDY(#FromDate)
     C                   Else
     C                   Eval      #WorkFmDate = $AddDate($Date(0):-36525)
     C                   EndIf

     C                   If        $isDate#(#ToDate:'*MDY')
     C                   Eval      #WorkToDate = $DateMDY(#ToDate)
     C                   Else
     C                   Eval      #WorkToDate = $AddDate($Date(0):36525)
     C                   EndIf

     C                   Eval      $ERR_PROG = ##PGM                            ?PGM MSG QUEUE
     C                   Eval      $ERR_MSGF = 'KPMSGF'                         ?MSG FILE
     C                   Eval      $ERR_LIBR = '*LIBL'                          ?LIBRARY
     C                   Eval      $ERR_MsgID = '*******'                       ?MESSAGE ID
     C                   ExSr      $ClrError

     C                   ExSr      Load01
     C                   ExSr      Scrn01

    ?C                   EndSr                                                  ?
