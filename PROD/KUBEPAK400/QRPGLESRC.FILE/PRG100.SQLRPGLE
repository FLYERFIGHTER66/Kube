     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)

      *??:````````````````````````````````````````````````````````````:?
      *??:          Purge old records from FPUTORD                    :?
      *??:............................................................:?

     c
    ?c/exec sql
    ?c+
    ?c+    DELETE
    ?c+    FROM     FPUTORD
    ?c+    WHERE    Date(Substr(PDSHPD,4,2)||'/'||
    ?c+                  Substr(PDSHPD,6,2)||'/'||
    ?c+                  Char(1900+Left(PDSHPD,3)))
    ?c+             <=   Date(Now()-5 day)
    ?c+
    ?c+
    ?c+
    ?c/end-exec

     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *InzSr        BegSr                                                  ?

    ?C                   EndSr                                                  ?

