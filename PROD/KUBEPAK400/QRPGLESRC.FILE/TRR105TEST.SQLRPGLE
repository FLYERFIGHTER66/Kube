PNK |H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
PNK |H DftActGrp(*No)
PNK |H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
PNK |H DatFmt(*Usa)

      *??:````````````````````````````````````````````````````````````:?
      *??:            Test Program TRR105                             :?
      *??:............................................................:?

    ?C     TRR105PL      PList
    ?C                   Parm      211514        Order#            6 0
    ?C                   Parm      1160614       ShipDate          7 0
    ?C                   Parm                    OrdPLUG           7 1
    ?C                   Parm                    OrdFLAT           7 1
    ?C                   Parm                    OrdHBPT           7 1
    ?C                   Parm                    OrdPOIN           7 1

     C                   Call      'TRR105'      TRR105PL

     C                   Eval      *InLR = *On

