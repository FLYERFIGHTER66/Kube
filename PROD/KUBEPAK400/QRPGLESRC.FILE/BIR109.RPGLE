    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *??:````````````````````````````````````````````````````````````:?
      *??:     Unlock Special Pricing on an Order                     :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  May. 2012            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program Unlocks Special Pricing on an Order        ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? : Subroutine ?-Subroutine Description                  ?  ?:
      *? :  *INZSR      -?Initialization Subroutine                  ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? : Function   ?-Function Description                    ?  ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? : *IND  ?-Indicator Usage                              ?  ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? : Date    Int  Change Description                         ?:
      *? : 05/11/12 _____?Program Creation                           ?:
      *? :............................................................:

     FBIR109FM  CF   E             WORKSTN
     FFHORDR    IF   E           K DISK

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Now

      *? Copy Book Features
    ?D/COPY QFunctDefn,$ErrMsg

      *? Program Data Structure
     D                SDS
     D   PgmID           *PROC

      *? Data Structures

      *? Field Definitions

      *? Arrays

      *?  ...........................................................
      *?  :      M A I N   C A L C S                                :
      *?  :.........................................................:

     C                   ExSr      Load01
     C                   ExSr      Scrn01

     C                   DoW       *InLR <> *On
    ?C                   Select
    ?C     Screen        WhenEq    01
     C                   ExSr      Edit01
    ?C                   Other
     C                   Eval      *InLR = *On
    ?C                   EndSL
     C                   EndDo

      *?  ...........................................................
      *?  :      Load01   - Load Screen 01                          :
      *?  :.........................................................:

     C     Load01        BegSr

     C                   Eval      Order# = *Zero

     C                   EndSr


      *?  ...........................................................
      *?  :      Scrn01   - Display Screen 01                       :
      *?  :.........................................................:

     C     Scrn01        BegSr

     C                   Z-Add     01            Screen            3 0          ?Screen  Number

    ?C*                  Write     Assume                                       ?Clear Err Messages
    ?C*                  Write     MSGCTL                                       ?Error Messages
    ?C                   ExFmt     BIR10901                                     ?Screen
     C*                  ExSr      $ClrError

     C                   EndSr


      *?  ...........................................................
      *?  :      Edit01   - Edit Screen 01                          :
      *?  :.........................................................:

     C     Edit01        BegSr

      *?  Pre Subfile Edit Functions (Does not redisplay Screen)
    ?C                   Select
    ?C                   When      *In03
     C                   ExSr      ExitSR
    ?C                   Other
     C                   Move      OHPRCD        OHPRCD@
    ?C     Order#        Chain     FHORDR
     C                   If        %Found(FHORDR)
     C                   Call      '#SETSPCPRC'
     C                   Parm                    OHORD#
     C                   Parm                    OHPRCD@           1
     C                   EndIf
     C                   ExSr      Scrn01
    ?C                   EndSL

     C                   EndSr


    ? /Eject
    ?C*COPY QFunctDefn,$CommandSR
    ?D/COPY QFunctDefn,$ErrMsgSr


      *?  ...........................................................
      *?  :      ExitSR   - Exit Subroutine                         :
      *?  :.........................................................:

     C     ExitSr        BegSr

     C                   Eval      *InLR = *On
     C                   Return

     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

     C                   Eval      $ERR_PROG  = 'BIR109'                        ?Pgm Msg Queue
     C                   Eval      $ERR_MSGF  = 'KPMSGF'                        ?Message File
     C                   Eval      $ERR_LIBR   = '*LIBL'                        ?Library

     C                   EndSR
