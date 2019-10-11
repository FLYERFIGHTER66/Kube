    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H DftActGrp(*No)                                                           ?
    ?H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
    ?H DatFmt(*Usa)                                                             ?
      *??:````````````````````````````````````````````````````````````:?
      *??:        Labor Class Master File - Maintenance               :?
      *??:............................................................:?

     FATT050FM  CF   E             WORKSTN
     FFMEMPCLS  UF A E           K DISK

     D  DateWorked     S               D
     D  DateWorked@    S             10A
     D  TimeOut        S               T
     D  JobType        S              1A
     D  Authorized     S               N
     D  Called         S               N

    ?D/Copy QFunctDefn,$ERRMSG                                                  ?
    ?D/Copy QFunctDefn,$isDate@                                                 ?

     C     *INLR         DOUEQ     *ON                                          ?Program Loop

    ?C                   Select                                                 ?
    ?C     Screen        WhenEq    1                                            ?
    ?C                   ExSr      Edit01                                       ?
    ?C     Screen        WhenEq    2                                            ?
    ?C                   ExSr      Edit02                                       ?
    ?C                   EndSl                                                  ?

    ?C                   EndDo                                                  ?


      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
    ?C                   Write     Assume                                     ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     ATT05001                                     ?
     C                   ExSr      $ClrError                                     ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

      *?     Blank out the Class
     C                   Eval      Class = *Blanks
     C                   Eval      Mode = 'Change'

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

      *? P R O C E S S   S C R E E N
     C                   SELECT                                                 ?
    ?C                   When      *In03 or *In07                               ?
     C                   MOVE      *ON           *INLR                          ?
     C                   LeaveSR                                                ?
    ?C                   When      *In05
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   When      *In06
     C                   Eval      Mode = 'Add'
     C                   ExSr      Load02
     C                   ExSr      Scrn02
    ?C                   Other                                                  ?
      *? Edit Fields
    ?C     CLASS         SetLL     FMEMPCLS
    ?C                   Select                                                 ?
    ?C                   When      Class = *Blanks
     C                   Eval      $Err_MsgId = 'ATT0050'
     C                   ExSr      $SndError
     C                   ExSr      Scrn01
    ?C                   When      Class = '? ' or
    ?C                             Class = ' ?'
     C                   Call      'ATT051'
     C                   Parm                    CLASS
     C                   ExSr      Scrn01
    ?C                   When      not %Equal(FMEMPCLS)
     C                   Eval      $Err_MsgData = Class
     C                   Eval      $Err_MsgId = 'ATT0051'
     C                   ExSr      $SndError
     C                   ExSr      Scrn01
    ?C                   Other                                                  ?
    ?C                   ExSr      Load02
    ?C                   ExSr      Scrn02
    ?C                   EndSl
    ?C                   EndSl

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn02 - Display Screen 02                         :
      *?  :.........................................................:
    ?C     Scrn02        BegSr                                                  ?
     C                   Z-Add     02            Screen            3 0          ?Screen  Number
     C                   If        Mode = 'Add'
     C                   Eval      *In26 = *On
     C                   Else
     C                   Eval      *In26 = *Off
     C                   EndIf
    ?C                   Write     Assume                                     ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     ATT05002                                     ?
     C                   ExSr      $ClrError                                     ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load02 - Load Screen 02                            :
      *?  :.........................................................:
    ?C     Load02        BegSr                                                  ?

     C                   If        Mode = 'Add'
      *?     Clear the scrren
     C                   Eval      LCCLAS = Class
     C                   Eval      LCSHRT = *Blanks
     C                   Eval      LCDESC = *Blanks
     C                   Eval      LCBASE = *Zeros
     C                   Else
    ?C     CLASS         Chain     FMEMPCLS
     C                   EndIf

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Edit02 - EDIT Screen 02                            :
      *?  :.........................................................:
    ?C     Edit02        BegSr                                                  ?

      *? P R O C E S S   S C R E E N
     C                   SELECT                                                 ?
    ?C                   When      *In03 or *In07                               ?
     C                   MOVE      *ON           *INLR                          ?
     C                   Return                                                 ?
    ?C                   When      *In06 and not Called
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   When      *In06 and Called
     C                   MOVE      *ON           *INLR                          ?
     C                   Return                                                 ?
    ?C                   When      *In23
    ?C                   Delete    RMEMPCLS
     C                   Eval      $Err_MsgData = Class
     C                   Eval      $Err_MsgId = 'ATT0054'
     C                   ExSr      $SndError
     C                   If        Called
     C                   MOVE      *ON           *INLR                          ?
     C                   Return                                                 ?
     C                   Else
     C                   ExSr      Scrn01
     C                   EndIf
    ?C                   Other                                                  ?
      *? Edit Fields
    ?C                   Select                                                 ?
    ?C                   When      LCCLAS = *Blanks
     C                   Eval      $Err_MsgId = 'ATT0050'
     C                   ExSr      $SndError
     C                   ExSr      Scrn02
    ?C                   When      LCSHRT = *Blanks or
    ?C                             LCDESC = *Blanks
     C                   Eval      $Err_MsgId = 'ATT0052'
     C                   ExSr      $SndError
     C                   ExSr      Scrn02
    ?C                   When      LCBASE = *Zero
     C                   Eval      $Err_MsgId = 'ATT0053'
     C                   ExSr      $SndError
     C                   ExSr      Scrn02
    ?C                   Other                                                  ?
     C                   If        Mode = 'Add'
    ?C                   Write     RMEMPCLS
     C                   Else
    ?C                   Update    RMEMPCLS
     C                   EndIf
     C                   If        Called
     C                   MOVE      *ON           *INLR                          ?
     C                   Return                                                 ?
     C                   Else
     C                   ExSr      Load01
     C                   ExSr      Scrn01
     C                   EndIf
    ?C                   EndSl
    ?C                   EndSl

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      $ClrError - Clear Error Message Subfile            :
      *?  :      $SndError - Send an Error Message to the PGMMSGQ   :
      * ? :      SRMSGF - Clear or send messages to Pgm msg queue   :
      *?  :.........................................................:
    ?C/Copy QFunctDefn,$ERRMSGSR                                                ?


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C     *Entry        PList                                                  ?
    ?C                   Parm                    CLASS                          ?

    ?C                   Call      'ATT040'                                     ?
    ?C                   Parm                    Authorized
     C                   If        not Authorized
     C                   Eval      *InH1 = *On
     C                   Return
     C                   EndIF

     C                   Eval      $ERR_PROG  = 'ATT050'                        ?Pgm Msg Queue
     C                   Eval      $ERR_MSGF  = 'KPMSGF'                        ?Message File
     C                   Eval      $ERR_LIBR   = '*LIBL'                        ?Library
     C                   ExSr      $ClrError

     C                   If        CLASS = *Blanks
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
     C                   Else
     C                   Eval      Called = *On
     C                   Eval      Mode = 'Change'
     C                   ExSr      Load02                                       ?
     C                   ExSr      Scrn02                                       ?
     C                   EndIf

    ?C                   EndSr                                                  ?
