      *? Function Prototypes
    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H DftActGrp(*No)
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DatFmt(*usa)

     FFTRSCHD   UF   E           K DISK
     FFHORDR    UF   E           K DISK

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY

      *?PROG DATA STRUCTURE
    ?D SystemDS       SDS
    ?D  PROGID                 1     10                                         ?PROGRAM NAME
    ?D  RLIBR                 81     90                                         ?RUN LIBRARY
    ?D  USERID               254    263                                         ?USER I.D.
    ?D  SLIBR                314    323                                         ?SOURCE LIBRARY
    ?D  LockedBy             124    133

    ?C     TruckKey      SETLL     FTRSCHD
    ?C     TruckKey      ReadE     FTRSCHD

    ?C                   DoW       not %EOF(FTRSCHD)

     C                   If        TRQTY6 = *Zeros                              |qty NOT overridden
      *?  Update Order Header with Truck information.  ( Only if Truck Date > Order Date )
    ?C     TRORD#        Chain     FHORDR
     C                   If        %Found(FHORDR)
     C                             and $Date(TRSHDT) > $DateMDY(OHDTCN)
     C                   Eval      OHDTCN = $MDYDate($Date(TRSHDT))
     C                   Eval      OHROUT = TRTRK#
     C                   Eval      OHSTOP = TRSTP#
    ?C                   Update    RHORDR
     C                   EndIf

      *?  Update Truck Schedule with Order Quantities.
     C                   If        TRORD# <> 0 and $Date(TRSHDT) > $Date(0)
    ?C                   Call      'TRR105'
    ?C                   Parm      TRORD#        Order#            6 0
    ?C                   Parm      TRSHDT        ShipDate          7 0
    ?C                   Parm      0             OrdPLUG           7 1
    ?C                   Parm      0             OrdFLAT           7 1
    ?C                   Parm      0             OrdHBPT           7 1
    ?C                   Parm      0             OrdPOIN           7 1

     C                   If        OrdPLUG > 0
     C                   Z-ADD     OrdPLUG       TRQTY1                         ?Plugs
     C                   EndIf
     C                   If        OrdFLAT > 0
     C                   Z-ADD     OrdFLAT       TRQTY2                         ?Flats
     C                   EndIf
     C                   If        OrdHBPT > 0
     C                   Z-ADD     OrdHBPT       TRQTY4                         ?HB & Pots
     C                   EndIf
     C                   If        OrdPOIN > 0
     C                   Z-ADD     OrdPOIN       TRQTY5                         ?Poinsettias
     C                   EndIf

    ?C                   Update    RTRSCHD

     C                   EndIf

     C                   EndIf                                                  |TRQTY6 = *Zeros

    ?C     TruckKey      ReadE     FTRSCHD
    ?C                   EndDo

     C                   Eval      *InLR = *On

      *?   :'`'`'`'`'`'`'`'`'`'`'`'`'`'`'`'`'`'`'`'`'`'`'`'`'`'`'`'`'`'`'`'`'`':
      *?   :     *INZSR - Initialization Subroutine                            :
      *?   :...................................................................:
    ?C     *InzSr        BegSr

    ?C     *Entry        PList
    ?C                   Parm                    TRTRK#
    ?C                   Parm                    TRSHDT@           7

     C                   Move      TRSHDT@       TRSHDT

    ?C     TruckKey      KList
    ?C                   KFld                    TRTRK#
    ?C                   KFld                    TRSHDT

    ?C                   EndSr
