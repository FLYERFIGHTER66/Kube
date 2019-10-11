    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *?                                                              ?
      *??|                                                            |?
      *??|     Add Lot Inventory for Entire Day (ADDLOTINVD)          |?
      *?|                                                            |?

      *? :````````````````````````````````````````````````````````````:
      *? : Created:  October, 2005        ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :  Program Description?                                    ?:
      *? : This program add an entire weeks worth of sowing to        :
      *? : inventory.  It basically passes each tag number to the    ?:
      *? : ADDLOTINV program.                                        ?:
      *? :                                                           ?:
      *? : NOTE:  This is an infrequently used program ! ! !         ?:
      *? :        Do Not mistake it for obsolete.                    ?:
      *? :............................................................:
      *?                                                              ?
      *? |?  Subroutine Usage                                        ?|
      *? |                                                           ?|
      *? | *InzSr     ?- Must I explain this ?!?!?                   ?|
      *?|                                                            |?
      *?                                                              ?
      *? |?  Function Usage                                          ?|
      *? |                                                           ?|
      *? | $MDYDate   ?- Return MDY Date from Date Field             ?|
      *? | $Date      ?- Return Date field from Number               ?|
      *? | $User      ?- Return Current User I.D.                    ?|
      *? | $Now       ?- Return Current Time as Number               ?|
      *?|                                                            |?
      *?                                                              ?
      *? |?  Indicator Usage                                         ?|
      *? |                                                           ?|
      *? |  LR      ?Does this really need a description ?           ?|
      *?|                                                            |?
      *?                                                              ?
      *? |?  Edit Log                                                ?|
      *? |                                                           ?|
      *? |WJB10/27/05?-Initial Programming                        ?|
      *? |   mm/dd/yy?-                                           ?|
      *?|                                                            |?

     FADDLOTINFMCF   E             WORKSTN

      *? Field Definitions
     D  Screen         S              3S 0                                      ?Screen Number
     D  EndOfFile      S               N                                        ?End Of File Ind.
     D  Tray_to_Post   S              9S 0                                      ?Tray to Post
     D  SowDate7       S              7S 0                                      ?Sow Date CYYMMDD
     D  TraysAdded     S              6S 0                                      ?Trays Added to Lot

      *? Indicators
     D*?  *None

      *? Copy Books
    ?D/COPY QFunctDefn,$ErrMsg

      *? Function Prototypes
    ?D/COPY QFunctDefn,$isLotItem
    ?D/COPY QFunctDefn,$Duration
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$WeekDay
    ?D/COPY QFunctDefn,$isDate#
    ?D/COPY QFunctDefn,$isItem
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$User

      /Free
    ?   /COPY QFunctDefn,LASTUSEDCB
      /End-Free
      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

     C                   DoW       *InLR <> *On
    ?C                   Select
    ?C     Screen        WhenEq    01
     C                   ExSr      Edit01
    ?C     Screen        WhenEq    02
     C                   ExSr      Edit02
    ?C                   Other
     C                   Eval      *InLR = *On
    ?C                   EndSL
     C                   EndDo

      *?  ...........................................................
      *?  :      Scrn01   - Display Screen 01                       :
      *?  :.........................................................:

     C     Scrn01        BegSr

     C                   Z-Add     01            Screen                         ?Screen  Number

    ?C                   Write     Assume                                       ?Clear Err Messages
    ?C   50              Write     MSGCTL                                       ?Error Messages
    ?C                   ExFmt     ADDLOT01                                     ?Screen 1
     C                   ExSr      $ClrError

     C                   EndSr

      *?  ...........................................................
      *?  :      Edit01   - Edit Screen 01                          :
      *?  :.........................................................:

     C     Edit01        BegSr

      *?  Edit the Screen
    ?C                   Select
    ?C                   When      *In03                                        ?Exit
     C                   ExSr      ExitSR
    ?C                   When      *In11                                        ?Toggle to SCRN02
     C                   ExSr      Scrn02
    ?C                   When      SowDate = *Zeros                             ?No Date Entered
     C                   Eval      $ERR_MsgID = 'DATE902'
     C                   Eval      $ERR_MsgData = 'Sow'
     C                   ExSr      $SndError
     C                   ExSr      Scrn01
    ?C                   When      not $isDate#(SowDate:'*MDY')                 ?Bad Date entered
     C                   Eval      $ERR_MsgID = 'DATE901'
     C                   Eval      $ERR_MsgData = %Char(SowDate)
     C                   ExSr      $SndError
     C                   ExSr      Scrn01
    ?C                   When      $WeekDay($DateMDY(SowDate):'MON') <> 1       ?Date not a Monday
     C                   Eval      $ERR_MsgID = 'DATE904'
     C                   Eval      $ERR_MsgData = %EditW(SowDate:'  /  /  ')
     C                   Eval      SowDate=
     C                             $MDYDate($Monday($DateMDY(SowDate):'MON'))
     C                   Eval      $ERR_MsgData = %Trim($ERR_MsgData) +
     C                             %EditW(SowDate:'  /  /  ')
     C                   ExSr      $SndError
     C                   ExSr      Scrn01
    ?C                   Other
      *?  Passed Edit ==>  Process Lot
     C                   ExSr      PostLot
     C                   ExSr      Scrn01
    ?C                   EndSL

     C                   EndSr

      *?  ...........................................................
      *?  :      Scrn02   - Display Screen 02                       :
      *?  :.........................................................:

     C     Scrn02        BegSr

     C                   Z-Add     02            Screen                         ?Screen  Number

    ?C                   Write     Assume                                       ?Clear Err Messages
    ?C   50              Write     MSGCTL                                       ?Error Messages
    ?C                   ExFmt     ADDLOT02                                     ?Screen 1
     C                   ExSr      $ClrError

     C                   EndSr

      *?  ...........................................................
      *?  :      Edit02   - Edit Screen 02                          :
      *?  :.........................................................:

     C     Edit02        BegSr

      *?  Edit the Screen
    ?C                   Select
    ?C                   When      *In03                                        ?Exit
     C                   ExSr      ExitSR
    ?C                   When      *In11                                        ?Toggle to SCRN01
     C                   ExSr      Scrn01
    ?C                   When      SowDate = *Zeros                             ?No Date Entered
     C                   Eval      $ERR_MsgID = 'DATE902'
     C                   Eval      $ERR_MsgData = 'Sow'
     C                   ExSr      $SndError
     C                   ExSr      Scrn02
    ?C                   When      not $isDate#(SowDate:'*MDY')                 ?Bad Date entered
     C                   Eval      $ERR_MsgID = 'DATE901'
     C                   Eval      $ERR_MsgData = %Char(SowDate)
     C                   ExSr      $SndError
     C                   ExSr      Scrn02
    ?C                   When      $WeekDay($DateMDY(SowDate):'MON') <> 1       ?Date not a Monday
     C                   Eval      $ERR_MsgID = 'DATE904'
     C                   Eval      $ERR_MsgData = %EditW(SowDate:'  /  /  ')
     C                   Eval      SowDate=
     C                             $MDYDate($Monday($DateMDY(SowDate):'MON'))
     C                   Eval      $ERR_MsgData = %Trim($ERR_MsgData) +
     C                             %EditW(SowDate:'  /  /  ')
     C                   ExSr      $SndError
     C                   ExSr      Scrn02
    ?C                   When      not $isItem(Item5:Size)                      ?Bad Item entered
     C                   Eval      $ERR_MsgID = 'ITM0001'
     C                   Eval      $ERR_MsgData = %Trim(Item5) + '/' + Size
     C                   ExSr      $SndError
     C                   ExSr      Scrn02
    ?C                   When      not $isLotItem(Item5:Size)                   ?Bad Item entered
     C                   Eval      $ERR_MsgID = 'ITM0002'
     C                   Eval      $ERR_MsgData = %Trim(Item5) + '/' + Size
     C                   ExSr      $SndError
     C                   ExSr      Scrn02
    ?C                   Other
      *?  Passed Edit ==>  Process Lot
     C                   ExSr      PostLot
     C                   ExSr      Scrn02
    ?C                   EndSL

     C                   EndSr

      *?  ...........................................................
      *?  :      PostLot - Post Selected Trays to Lot Inventory     :
      *?  :.........................................................:

     C     PostLot       BegSr

     C                   eVal      SowDate7 = $Date7($DateMDY(SowDate))

    ?C                   Call      'ADDLOTINVP'
    ?C                   Parm                    SowDate7
    ?C                   Parm                    Item5
    ?C                   Parm                    Size
    ?C                   Parm                    Screen
    ?C                   Parm                    TraysAdded

     C                   Eval      $ERR_MsgID = 'LOT0001'
     C                   Eval      $ERR_MsgData = %Char(TraysAdded)
     C                   ExSr      $SndError

     C                   EndSr

      *?  ...........................................................
      *?  :      ERRMSG - Error Message Handling Subroutines        :
      *?  :.........................................................:
    ?D/COPY QFunctDefn,$ErrMsgSr

      *?  ...........................................................
      *?  :      ExitSR - Exit Subroutine                           :
      *?  :.........................................................:

     C     ExitSR        BegSr

     C                   Eval      *InLr = *On
     C                   Return

     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

     C                   Eval      $ERR_PROG  = 'ADDLOTINVW'                    ?Pgm Msg Queue
     C                   Eval      $ERR_MSGF  = 'KPMSGF'                        ?Message File
     C                   Eval      $ERR_LIBR   = '*LIBL'                        ?Library
     C                   Eval      SowDate = $MDYDate($Monday($Date(0):'SAT'))
     C                   ExSr      $ClrError
     C                   ExSr      Scrn01

     C                   EndSR
