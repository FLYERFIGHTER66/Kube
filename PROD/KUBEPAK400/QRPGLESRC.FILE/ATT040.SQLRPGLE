     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:                  Fix Late Charges                          :?
      *??:............................................................:?

     FATT040FM  CF   E             WORKSTN
     FFMEMPXREF IF   E           K DISK
     FFMEMPSUP  IF   E           K DISK

     D  Authorized     S               N
     D  Card9          S              9S 0
     D  User           S             10A

    ?D/Copy QFunctDefn,$User                                                    ?

     C                   Eval      USER = $User()
     C                   If        User = 'BILL      ' or
     C                             User = 'JOHNS     ' or
     C                             User = 'ROB       ' or
     C                             User = 'BILLB     ' or
     C                             User = 'DONNAP    ' or
     C                             User = 'DARREN    ' or
     C                             User = 'RAUNEL    ' or
     C                             User = 'MIKE      ' or
     C                             User = 'JEFF      ' or
     C                             User = 'SEAN      ' or
     C                             User = 'RENE      '
     C                   Eval      Authorized = *On

     C                   Else

     C                   ExFmt     ATT04001
     C                   Eval      Card9 = CARD
     C     Card9         Chain     FMEMPXREF
     C     TXFILE        Chain     FMEMPSUP
     C                   If        %Found(FMEMPSUP)
     C                   Eval      Authorized = *On
     C                   Else
     C                   Eval      Authorized = *Off
     C                   EndIf

     C                   EndIf

     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C     *Entry        PList                                                  ?
    ?C                   Parm                    Authorized

    ?C                   EndSr                                                  ?
