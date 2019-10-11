     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)

      *??:````````````````````````````````````````````````````````````:?
      *??:          Purge old records from various file               :?
      *??:............................................................:?

     c
    ?c/exec sql
    ?c+
    ?c+    DELETE
    ?c+    FROM     FHORCWI
    ?c+    WHERE    CHORDY <
    ?c+     ((year(current date)-1902)*10000)+
    ?c+     (month(current date)*100) +
    ?c+     (  day(current date))
    ?c+
    ?c/end-exec

     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *InzSr        BegSr                                                  ?

    ?C                   EndSr                                                  ?

