    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *??:````````````````````````````````````````````````````````````:?
      *??:     Mark Flat as a good flat & remove from loss files      :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  January 2008         ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :  This program ensures that a flat scanned as "good" in     :
      *? :  fixing is removed from all Loss Files...                  :
      *? :  i.e.  remove from  FLOSSLOT, FLOSSD, FPARTIAL             :
      *? :  This program also initiates the recalculation of LOSSLOT. :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFLOSSD    UF   E           K DISK
     FFPARTIAL  UF   E           K DISK

    ?D  Tag            S              8S 0
    ?D  ReadyDate      S              7S 0                                       Ready Date

    ?C     LDTAG#        SetLL     FLOSSD
    ?C     LDTAG#        ReadE     FLOSSD
     C                   DoW       not %EOF(FLOSSD)
    ?C                   Delete    RLOSSD
    ?C     LDTAG#        ReadE     FLOSSD
     C                   EndDo

    ?C     LDTAG#        SetLL     FPARTIAL
    ?C     LDTAG#        ReadE     FPARTIAL
     C                   DoW       not %EOF(FPARTIAL)
    ?C                   Delete    RPARTIAL
    ?C     LDTAG#        ReadE     FPARTIAL
     C                   EndDo

     C                   If        LDITEM <> *Blanks
    ?C                   Call      'FXG065LOT'                                  ?
    ?C     LDREDY        Parm      LDREDY        ReadyDate
    ?C                   Parm                    LDITEM
    ?C                   Parm                    LDSIZE
     C                   EndIf

    ?C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *InzSr        BegSr                                                  ?

    ?C     *Entry        PList
    ?C     LDTAG#        Parm      LDTAG#        TAG

    ?C                   EndSr                                                  ?

