    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H DftActGrp(*No)                                                           ?
    ?H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
    ?H DatFmt(*Usa)                                                             ?
      *??:````````````````````````````````````````````````````````````:?
      *??:               Time Card Change Program                     :?
      *??:............................................................:?

     FATT060FM  CF   E             WORKSTN

     FFMATTENDTTUF   E           K DISK                                         ?Attendance Master
     FFMEMPLOY  IF   E           K DISK                                         ?Employee Master
     FXATABL    IF   E           K DISK                                         ?Table File

     D  TimeStamp      S               Z                                        ?Entry Timestamp
     D   JobCode       S                   Like(TBTBCD)                         ?Job Code
     D  Authorized     S               N                                        ?Authorized to Use

    ?D/Copy QFunctDefn,$ERRMSG                                                  ?
    ?D/Copy QFunctDefn,$Upper                                                   ?

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
    ?C                   ExFmt     ATT06001                                     ?
     C                   ExSr      $ClrError                                     ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

      *?     Load Attendance Record
    ?C     TimeStamp     Chain     FMATTENDTT
     C                   If        not %Found(FMATTENDTT)
     C                   Eval      *InLR = *On
     C                   Return
     C                   EndIF

      *?     Load Employee Master Information
     C                   Clear                   RMEMPLOY
    ?C     ATFILE        Chain     FMEMPLOY
     C                   Eval      Name = $Upper(%Trim(EMLAST) + ', ' +
     C                                           %Trim(EMFIRS))

      *?     Load Job Type
     C                   Eval      JobCode  = 'JC' + ATTYPE
    ?C     JobCode       Chain     XATABL
     C                   If        %Found(XATABL)
     C                   Eval      JobType = TBSHRT
     C                   Else
     C                   Eval      JobType = *Blanks
     C                   EndIf

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
    ?C                   Other                                                  ?
    ?C                   Update    RMATTEND
     C                   MOVE      *ON           *INLR                          ?
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
    ?C                   Parm                    TimeStamp

    ?C                   Call      'ATT040'                                     ?
    ?C                   Parm                    Authorized
     C                   If        not Authorized
     C                   Eval      *InH1 = *On
     C                   Return
     C                   EndIF

     C                   Eval      $ERR_PROG  = 'ATT060'                        ?Pgm Msg Queue
     C                   Eval      $ERR_MSGF  = 'KPMSGF'                        ?Message File
     C                   Eval      $ERR_LIBR   = '*LIBL'                        ?Library
     C                   ExSr      $ClrError

     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

    ?C                   EndSr                                                  ?
