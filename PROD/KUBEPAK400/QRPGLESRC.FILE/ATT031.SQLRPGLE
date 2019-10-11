    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H DftActGrp(*No)                                                           ?
    ?H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
    ?H DatFmt(*Usa)                                                             ?
      *??:````````````````````````````````````````````````````````````:?
      *??:               Mass Punch Out Prompt                        :?
      *??:............................................................:?

     FATT031FM  CF   E             WORKSTN

     D  DateWorked     S               D
     D  DateWorked@    S             10A
     D  TimeOut        S               T
     D  JobType        S              1A
     D  Authorized     S               N

    ?D/Copy QFunctDefn,$ERRMSG                                                  ?
    ?D/Copy QFunctDefn,$isDate@                                                 ?

     C     *INLR         DOUEQ     *ON                                          ?Program Loop

    ?C                   Select                                                 ?
    ?C     Screen        WhenEq    1                                            ?
    ?C                   ExSr      Edit01                                       ?
    ?C                   EndSl                                                  ?

    ?C                   EndDo                                                  ?


      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
    ?C                   Write     Assume                                     ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     ATT03101                                     ?
     C                   ExSr      $ClrError                                     ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

      *?     Load Current Date as the DateWorked
     C                   Time                    DateWorked
      *?     Load Current Time as Default Time Out
     C                   Time                    TimeOut

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
    ?C                   When      JobType = '?'
    ?C                   ExSr      GetTYPE
     C                   ExSr      Scrn01
    ?C                   Other                                                  ?
      *? Edit Fields
     C                   Move      DateWorked    DateWorked@
    ?C                   Select                                                 ?
    ?C                   When      not $isDate@(DateWorked@:'*USA')
     C                   ExSr      Scrn01
    ?C                   Other                                                  ?
    ?C                   Call      'ATT030'
    ?C                   Parm                    DateWorked
    ?C                   Parm                    TimeOut
    ?C                   Parm                    JobType
     C                   Eval      *InLR = *On
     C                   Return
    ?C                   EndSl
    ?C                   EndSl

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      GetTYPE - Get Labor Type Code                      :
      *?  :.........................................................:
    ?C     GetTYPE       BegSr                                                  ?

    ?C                   Call      'XATABLE'
    ?C                   Parm      'JC'          TABID             2
    ?C                   Parm                    #KEYP#            2
    ?C     JOBTYPE       Parm                    #EELM#            6

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

    ?C                   Call      'ATT040'                                     ?
    ?C                   Parm                    Authorized
     C                   If        not Authorized
     C                   Eval      *InH1 = *On
     C                   Return
     C                   EndIF

     C                   Eval      $ERR_PROG  = 'ATT031'                        ?Pgm Msg Queue
     C                   Eval      $ERR_MSGF  = 'KPMSGF'                        ?Message File
     C                   Eval      $ERR_LIBR   = '*LIBL'                        ?Library
     C                   ExSr      $ClrError

     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

    ?C                   EndSr                                                  ?
