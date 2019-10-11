    ?H/COPY QFunctDefn,@CopyRight
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)

     FFHORDR    IF   E           K DISK
     FFIORDR    UF   E           K DISK

    ?D  P_Order#       S                   Like(OHORD#)
    ?D  P_Over         S                   Like(OIOVER)

    ?C     *Entry        PList
    ?C                   Parm                    P_Order#
    ?C                   Parm                    P_Over

    ?C     P_Order#      Chain     FHORDR
     C                   If        %Found(FHORDR) and OHSTAT = 'A'
    ?C     P_Order#      SetLL     FIORDR
    ?C     P_Order#      ReadE     FIORDR
     C                   DoW       not %EOF(FIORDR)
     C                   If        OIITYP = ' ' and
     C                             OIOVER <> P_Over
     C                   Eval      OIOVER =  P_Over
    ?C                   Update    RIORDR
     C                   EndIf
    ?C     P_Order#      ReadE     FIORDR
     C                   EndDo
     C                   EndIf
     C                   Eval      *InLR = *On
     C                   Return
