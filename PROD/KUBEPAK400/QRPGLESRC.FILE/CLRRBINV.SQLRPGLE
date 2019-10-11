     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:               Clear ALL Ready Bay Inventory                :?
      *??:............................................................:?

      *?   Clear Lot Records
    ?c/exec sql
    ?c+
    ?c+    Delete From FDLOTRD Where LRGLOC = 'R'
    ?c+
    ?c/end-exec

      *?   Clear Lot Trays
    ?c/exec sql
    ?c+
    ?c+    Delete From FRBTRAY
    ?c+
    ?c/end-exec

     C                   Eval      *InLR = *On
