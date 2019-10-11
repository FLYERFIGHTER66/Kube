     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:                     Move  Bay Check Out                    :?
      *??:............................................................:?

     FSAR905FM  CF   E             WORKSTN
     FFMCUST    IF   E           K DISK

      *? Function Prototypes
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$User

     C     *INLR         DOUEQ     *ON                                          ?COMMENT

     C                   SELECT                                                 ?
     C     Screen        WhenEq    1                                            ?
     C                   ExSr      Edit01                                       ?
     C     Screen        WhenEq    2                                            ?
     C                   ExSr      Edit02                                       ?
     C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
    ?C*                  Write     MSGCTL                                       ?
    ?C                   ExFmt     SAR90501                                     ?
     C*                  ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn02 - Display Screen 02                         :
      *?  :.........................................................:
    ?C     Scrn02        BegSr                                                  ?
     C                   Z-Add     02            Screen            3 0          ?Screen  Number
    ?C*                  Write     MSGCTL                                       ?
    ?C                   ExFmt     SAR90502                                     ?
     C*                  ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

    ?C     FMACCT        Chain     FMCUST                             90
     C  N90              Eval      FMNAME = CMNAME                              ?
    ?C     TOACCT        Chain     FMCUST                             91
     C  N91              Eval      TONAME = CMNAME                              ?

      *? P R O C E S S   S C R E E N

    ?C                   Select                                                 ?
    ?C                   When      *In03
     C                   MOVE      *ON           *INLR                          ?

    ?C                   When      fmACCT = *Zero
    ?C                             or *In90
     C                   Eval      *In50 = *On                                  ?
     C                   ExSr      Scrn01                                       ?

    ?C                   When      toACCT = *Zero
    ?C                             or *In91
     C                   Eval      *In51 = *On                                  ?
     C                   ExSr      Scrn01                                       ?

      *? From Account
    ?C                   OTHER                                                  ?
     C                   ExSr      Scrn02                                       ?
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Edit02 - EDIT Screen 02                            :
      *?  :.........................................................:
    ?C     Edit02        BegSr                                                  ?

      *? P R O C E S S   S C R E E N    02

    ?C                   Select                                                 ?
    ?C                   When      *In03
     C                   MOVE      *ON           *INLR                          ?

    ?C                   When      *In06
     C                   Eval      fmACCT = *Zero                               ?
     C                   Eval      toACCT = *Zero                               ?
     C                   ExSr      Scrn01                                       ?

    ?C                   When      *In11                                        ?

     C                   Call      'SAR906'      FMandTO
     C                   Call      'SAR907'      FMandTO

     C                   Eval      fmACCT = *Zero                               ?
     C                   Eval      toACCT = *Zero                               ?
     C                   ExSr      Scrn01                                       ?


      *? From Account
     C                   OTHER                                                  ?
     C                   ExSr      Scrn02                                       ?
     C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      *InzSr - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *InzSr        BegSr                                                  ?

     C     FMandTO       PList
     C                   Parm                    FMACCT
     C                   Parm                    TOACCT

     C                   ExSr      Scrn01                                       ?

    ?C                   EndSr                                                  ?
