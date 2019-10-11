     H BndDir('*LIBL/KPFUNCTION')
     H DftActGrp(*No)

      *??:````````````````````````````````````````````````````````````:?
      *??:                  Time Clock Function                       :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  July 2006            ? Kube-Pak Corporation ?    :
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
      *? :  Edit01   -?EDIT Screen 01                                ?:
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
      *? :  12      ?Cancel                                          ?:
      *? :  50      ?Error Indicator (All Errors)                    ?:
      *? :  51      ?Error Indicator (Bad Printer 1)                 ?:
      *? :  52      ?Error Indicator (Bad Printer 2)                 ?:
      *? :  53      ?Error Indicator (Bad "SAVE1")                   ?:
      *? :  54      ?Error Indicator (Bad "SAVE2")                   ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     F#TimeClockCF   E             WORKSTN
     FFMEMPLOY  IF   E           K DISK
     F*FMEMPXREF IF   E           K DISK
     FXATABL    IF   E           K DISK

     D  NewStat        S                   Like(EMSTTS)
     D  NewType        S                   Like(EMTYPE)
     D  JobCode        S                   Like(TBTBCD)
     D  Blank          S                   Like(EMSTAT) Inz(*Blanks)
     D  LabelUser      S              8S 0
     D  LabelCnt       S              3S 0 Inz(75)

      *? Function Prototypes
    ?D/COPY QFunctDefn,$PrtUsrLab
    ?D/COPY QFunctDefn,$ChgPrt

    ?C                   ExSr      Load01
    ?C                   ExSr      Scrn01

     C     *INLR         DOUEQ     *ON                                          ?COMMENT

    ?C                   SELECT                                                 ?
    ?C     Screen        WhenEq    1                                            ?
    ?C                   ExSr      Edit01                                       ?
    ?C     Screen        WhenEq    2                                            ?
    ?C                   ExSr      Edit02                                       ?
    ?C                   ENDSL                                                  ?

     C                   EndDo                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
    ?C                   ExFmt     Clock01
     C                   MoveA     '00000'       *In(50)
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn02 - Display Screen 02                         :
      *?  :.........................................................:
    ?C     Scrn02        BegSr                                                  ?
     C                   Z-Add     02            Screen            3 0          ?Screen  Number
    ?C                   ExFmt     Clock02
     C                   MoveA     '00000'       *In(50)
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load01 - Load Screen 01 Fields                     :
      *?  :.........................................................:
    ?C     Load01        BegSr

     C                   Eval      Employee# = 0

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Load02 - Load Screen 02 Fields                     :
      *?  :.........................................................:
    ?C     Load02        BegSr

     C                   Eval      JobCode  = 'JC' + EMTYPE
RED |C     JobCode       Chain     XATABL
     C                   If        %Found(XATABL)
     C                   Eval      NewType = %Subst(TBTBCD:3:1)
     C                   Eval      Job  = TBSHRT
     C                   Else
     C                   Eval      NewType = *Blanks
     C                   Eval      Job  = *Blanks
     C                   EndIf

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit01 - Edit Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

    ?C                   Select                                                 ?
    ?C                   When      *In12  or *In03 or *In07                     ?
     C                   Eval      *InLR = *On
     C                   Return
    ?C                   When      *In04                                        ?
     C                   Call      'ATT020CL'
     C                   Parm                    BLANK
     C                   ExSr      Scrn01
    ?C                   Other
     C*                  Z-add     Employee#     EMFILE
     C                   Z-add     Employee#     EMCARD
     C*                  Z-add     Employee#     TXFILE
     C                   Call      '#EMPFILE#'
     C                   Parm                    EMCARD
     C                   Parm                    EMFILE
     C                   Parm                    name
RED |C*    EMCARD        Chain     FMEMPXREF
RED |C     EMFILE        Chain     FMEMPLOY
     C                   If        %Found(FMEMPLOY)
     C                   Eval      Name = %Trim(EMFIRS) + ' ' + %Trim(EMLAST)
     C                   If        EMSTTS <> 'I'
     C                   Eval      *In61 = *Off
     C                   Else
     C                   Eval      *In61 = *On
     C                   EndIf
     C                   ExSr      Load02
     C                   ExSr      Scrn02
     C                   Else
     C                   ExSr      Scrn01
     C                   EndIf
    ?C                   EndSl

    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      Edit02 - Edit Screen 01                            :
      *?  :.........................................................:
    ?C     Edit02        BegSr                                                  ?

    ?C                   Select                                                 ?
    ?C                   When      *In03                                        ?
     C                   Eval      *InLR = *On
     C                   Return
    ?C                   When      *In12                                        ?
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   When      *In08 or Job = *Blanks
     C                   Call      'XATABLE'
     C                   Parm      'JC'          TABID             2
     C                   Parm                    #KEYP#            2
     C     EMTYPE        Parm                    #EELM#            6
     C                   ExSr      Load02
     C                   ExSr      Scrn02
    ?C                   When      *In06
     C                   Eval      LabelUser = Employee#
     C                   CallP     $PrtUsrLab(LabelUser:LabelCnt)
     C                   ExSr      Scrn02
    ?C                   When      *In11 and *In61                              ?
     C                   Eval      *In61 = *Off
     C                   ExSr      Scrn02
    ?C                   When      *In11 and not *In61                              ?
     C                   Eval      *In61 = *On
     C                   ExSr      Scrn02
    ?C                   Other
     C                   If        *In61
     C                   Eval      NewStat = 'O'
     C                   Else
     C                   Eval      NewStat = 'I'
     C                   EndIf
    ?C                   Call      '#ATTEND'
    ?C                   Parm                    EMFILE
    ?C                   Parm                    NewStat
    ?C                   Parm                    NewType
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   EndSl


    ?C                   EndSr                                                  ?

