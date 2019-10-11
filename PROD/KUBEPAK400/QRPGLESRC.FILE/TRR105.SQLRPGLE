PNK |H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
PNK |H DftActGrp(*No)
PNK |H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
PNK |H DatFmt(*Usa)

      *??:````````````````````````````````````````````````````````````:?
      *??:            Get Product Category Quantity Shipping          :?
      *??:............................................................:?

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$MDYDate

      *? Field Definitions
    ?D  Monday         S              7S 0

    ?c/exec sql
    ?c+
    ?c+    SELECT      sum(FIORDR.OIQORD)
    ?c+    INTO        :OrdPLUG
    ?c+    FROM        FIORDR
    ?c+            ,   FMSIZC
    ?c+    WHERE       FIORDR.OISIZE=FMSIZC.SCSIZE
    ?c+      and       FIORDR.OIORD#=:Order#
    ?c+      and       FMSIZC.SCCATG='PLUG'
    ?c+      and       ( FIORDR.OIRVDT=:ShipDate  or FIORDR.OIRVDT=:Monday )
    ?c+      and       FIORDR.OISTAT='A'
    ?c+    GROUP BY    FIORDR.OIORD#, FMSIZC.SCCATG
    ?c+    ORDER BY    FIORDR.OIORD#, FMSIZC.SCCATG
    ?c+
    ?c/end-exec

    ?c/exec sql
    ?c+
    ?c+    SELECT      sum(FIORDR.OIQORD)
    ?c+    INTO        :OrdFLAT
    ?c+    FROM        FIORDR
    ?c+            ,   FMSIZC
    ?c+    WHERE       FIORDR.OISIZE=FMSIZC.SCSIZE
    ?c+      and       FIORDR.OIORD#=:Order#
    ?c+      and       FMSIZC.SCCATG='FLAT'
    ?c+      and       FIORDR.OIRVDT=:ShipDate
    ?c+      and       FIORDR.OISTAT='A'
    ?c+    GROUP BY    FIORDR.OIORD#, FMSIZC.SCCATG
    ?c+    ORDER BY    FIORDR.OIORD#, FMSIZC.SCCATG
    ?c+
    ?c/end-exec

    ?c/exec sql
    ?c+
    ?c+    SELECT      sum(FIORDR.OIQORD)
    ?c+    INTO        :OrdHBPT
    ?c+    FROM        FIORDR
    ?c+            ,   FMSIZC
    ?c+    WHERE       FIORDR.OISIZE=FMSIZC.SCSIZE
    ?c+      and       FIORDR.OIORD#=:Order#
    ?c+      and       FMSIZC.SCCATG='HBPT'
    ?c+      and       FIORDR.OIRVDT=:ShipDate
    ?c+      and       FIORDR.OISTAT='A'
    ?c+    GROUP BY    FIORDR.OIORD#, FMSIZC.SCCATG
    ?c+    ORDER BY    FIORDR.OIORD#, FMSIZC.SCCATG
    ?c+
    ?c/end-exec

    ?c/exec sql
    ?c+
    ?c+    SELECT      sum(FIORDR.OIQORD)
    ?c+    INTO        :OrdPOIN
    ?c+    FROM        FIORDR
    ?c+            ,   FMSIZC
    ?c+    WHERE       FIORDR.OISIZE=FMSIZC.SCSIZE
    ?c+      and       FIORDR.OIORD#=:Order#
    ?c+      and       FMSIZC.SCCATG='POIN'
    ?c+      and       FIORDR.OIRVDT=:ShipDate
    ?c+      and       FIORDR.OISTAT='A'
    ?c+    GROUP BY    FIORDR.OIORD#, FMSIZC.SCCATG
    ?c+    ORDER BY    FIORDR.OIORD#, FMSIZC.SCCATG
    ?c+
    ?c/end-exec

     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *InzSr        BegSr                                                  ?

    ?C     *Entry        PList
    ?C                   Parm                    Order#            6 0
    ?C                   Parm                    ShipDate          7 0
    ?C                   Parm                    OrdPLUG           7 1
    ?C                   Parm                    OrdFLAT           7 1
    ?C                   Parm                    OrdHBPT           7 1
    ?C                   Parm                    OrdPOIN           7 1

     C                   Eval      Monday=$Date7($Monday($Date(ShipDate):'SAT'))

    ?C                   EndSr                                                  ?

