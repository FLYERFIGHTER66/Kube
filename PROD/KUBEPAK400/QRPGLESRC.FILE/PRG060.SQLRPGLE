     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)

      *??:````````````````````````````````````````````````````````````:?
      *??:          Purge old records from FINMAN & FINMAND           :?
      *??:............................................................:?

    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$AddDate

     D  Today          S               D
     D  Back550        S              7S 0

    ?c/exec sql
    ?c+
    ?c+    DELETE
    ?c+    FROM      FINMAN
    ?c+    WHERE     INMAN# < :Back550
    ?c+
    ?c/end-exec

    ?c/exec sql
    ?c+
    ?c+    DELETE
    ?c+    FROM      FINMAND
    ?c+    WHERE     IDMAN# < :Back550
    ?c+
    ?c/end-exec

     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *InzSr        BegSr                                                  ?

     C                   Time                    Today
     C                   Eval      Back550 = $Date7($AddDate(Today:-550))

    ?C                   EndSr                                                  ?

