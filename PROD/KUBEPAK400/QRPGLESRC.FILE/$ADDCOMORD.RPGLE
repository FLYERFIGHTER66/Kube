     H/COPY QFunctDefn,@CopyRight
     H DftActGrp(*no)
     H DatFmt(*usa)
     H BndDir('*LIBL/KPFUNCTION')

     FFHORDR    IP   E           K DISK
     FFIORDR    IF   E           K DISK

     C                   If        OHSTAT = 'A'
     C     OHORD#        SetLL     FIORDR
     C                   If        %Equal(FIORDR)
     C                   Call      '$COMMENT'
     C                   Parm                    OHORD#
     C                   ENDIF
     C                   ENDIF
