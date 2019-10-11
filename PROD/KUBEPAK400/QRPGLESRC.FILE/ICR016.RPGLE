    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:                                                            :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  May. 2011            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :                                                           ?:
      *? :............................................................:

     FFLKITM    UP   E           K Disk
     FFMINVT    IF   E           K Disk

      *? Update Price
    ?C     ItemKey       KList
    ?C                   KFld                    LKITEM
    ?C                   KFld                    LKSIZE
    ?C     ItemKey       Chain     FMINVT
     C                   If        LKUPRI <> IMSEL1
     C                   Eval      LKUPRI  = IMSEL1
    ?C                   Update    RLKITM
     C                   EndIf


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C                   EndSr                                                  ?
