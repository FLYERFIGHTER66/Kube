     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)

      *??:````````````````````````````````````````````````````````````:?
      *??:          Purge old records from FINMAN & FINMAND           :?
      *??:............................................................:?

    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$AddDate

     D  Back455        S               D

    ?c/exec sql
    ?c+
    ?c+    INSERT
    ?c+    INTO      FTRYFIXHST
    ?c+    (SELECT   *
    ?c+     FROM     FTRAYFIXED
    ?c+     WHERE    Date(TFTIME) < :Back455 )
    ?c+
    ?c/end-exec

    ?c/exec sql
    ?c+
    ?c+    DELETE
    ?c+    FROM      FTRAYFIXED
    ?c+    WHERE     Date(TFTIME) < :Back455
    ?c+
    ?c/end-exec

     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *InzSr        BegSr                                                  ?

     C                   Eval      Back455 = $AddDate($Date(0):-455)

    ?C                   EndSr                                                  ?

