     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)

      *??:````````````````````````````````````````````````````````````:?
      *??:             Convert Stop Seq. to Stop Number               :?
      *??:............................................................:?

     D  Stop#          S              3S 0

    ?c/exec sql
    ?c+
    ?c+    SELECT  count(*)
    ?c+    Into      :Stop#
    ?c+    FROM    ftrschd
    ?c+    WHERE   TRSHDT  = :ShipDate
    ?c+      and   TRTRK#  = :Truck#
    ?c+      and   TRSTOP <= :StopSeq
    ?c+
    ?c/end-exec

     C                   Eval      StopNumber = %Char(Stop#)
     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *InzSr        BegSr                                                  ?

    ?C     *Entry        PList
    ?C                   Parm                    Truck#            4
    ?C                   Parm                    ShipDate          7 0
    ?C                   Parm                    StopSeq           3 0
    ?C                   Parm                    StopNumber        2

    ?C                   EndSr                                                  ?

