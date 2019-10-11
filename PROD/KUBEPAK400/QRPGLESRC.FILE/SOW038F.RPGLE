     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Recip Sow line operation Display Un-sown           :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Feb 2008             ? Kube-Pak Corporation ?    :
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
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
     FFMINVT    IF   E           K DISK                                         ?Item Master
     FFIORDRR@S UF   E           K DISK                                         ?Orders
     FFSOWSCHR@SUF   E           K DISK                                         ?Sow Jobs
     FFTRAYSR@S UF   E           K DISK                                         ?Recip Trays
     FFTRAYRR@S UF   E           K DISK                                         ?Stand. Trays

     D  ITEM           S             12A
     D  SIZE           S             03A
     D  LOOK           S             15A

    ?C     ItemKey       KList
    ?C                   KFld                    ITEM
    ?C                   KFld                    SIZE

    ?C     RdyDate7      SetLL     FIORDRR@S
    ?C     RdyDate7      ReadE     FIORDRR@S
     C                   DoW       not %EOF(FIORDRR@S)
     C                   If        OIITEM + OISIZE <> IMITEM + IMSIZE
     C                   Eval      ITEM = OIITEM
     C                   EVAL      SIZE = OISIZE
    ?C     ItemKey       Chain     FMINVT
     C                   If        %FOUND(FMINVT)
     C                   Eval      LOOK = IMLOOK
     C                   Else
     C                   Eval      LOOK = OIITMA
     C                   EndIf
     C                   EndIf
     C                   If        OIITMA <> LOOK
     C                   Eval      OIITMA = LOOK
    ?C                   Update    RIORDR
     C                   EndIf
    ?C     RdyDate7      ReadE     FIORDRR@S
     C                   EndDo

    ?C     RdyDate7      SetLL     FSOWSCHR@S
    ?C     RdyDate7      ReadE     FSOWSCHR@S
     C                   DoW       not %EOF(FSOWSCHR@S)
     C                   If        SOITEM + SOSIZE <> IMITEM + IMSIZE
     C                   Eval      ITEM = SOITEM
     C                   EVAL      SIZE = SOSIZE
    ?C     ItemKey       Chain     FMINVT
     C                   If        %FOUND(FMINVT)
     C                   Eval      LOOK = IMLOOK
     C                   Else
     C                   Eval      LOOK = SOLOOK
     C                   EndIf
     C                   EndIf
     C                   If        SOLOOK <> LOOK
     C                   Eval      SOLOOK = LOOK
    ?C                   Update    RSOWSCH
     C                   EndIf
    ?C     RdyDate7      ReadE     FSOWSCHR@S
     C                   EndDo

    ?C     RdyDate7      SetLL     FTRAYSR@S
    ?C     RdyDate7      ReadE     FTRAYSR@S
     C                   DoW       not %EOF(FTRAYSR@S)
     C                   If        TRITEM + TRSIZE <> IMITEM + IMSIZE
     C                   Eval      ITEM = TRITEM
     C                   EVAL      SIZE = TRSIZE
    ?C     ItemKey       Chain     FMINVT
     C                   If        %FOUND(FMINVT)
     C                   Eval      LOOK = IMLOOK
     C                   Else
     C                   Eval      LOOK = TRALPH
     C                   EndIf
     C                   EndIf
     C                   If        TRALPH <> LOOK
     C                   Eval      TRALPH = LOOK
    ?C                   Update    RTRAY
     C                   EndIf
    ?C     RdyDate7      ReadE     FTRAYSR@S
     C                   EndDo

    ?C     RdyDate7      SetLL     FTRAYRR@S
    ?C     RdyDate7      ReadE     FTRAYRR@S
     C                   DoW       not %EOF(FTRAYRR@S)
     C                   If        TRITEM + TRSIZE <> IMITEM + IMSIZE
     C                   Eval      ITEM = TRITEM
     C                   EVAL      SIZE = TRSIZE
    ?C     ItemKey       Chain     FMINVT
     C                   If        %FOUND(FMINVT)
     C                   Eval      LOOK = IMLOOK
     C                   Else
     C                   Eval      LOOK = TRALPH
     C                   EndIf
     C                   EndIf
     C                   If        TRALPH <> LOOK
     C                   Eval      TRALPH = LOOK
    ?C                   Update    RTRAYR
     C                   EndIf
    ?C     RdyDate7      ReadE     FTRAYRR@S
     C                   EndDo

     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C     *Entry        PList
    ?C                   Parm                    RdyDate@          7
     C                   Move      RdyDate@      RdyDate7          7 0

    ?C                   EndSr                                                  ?
