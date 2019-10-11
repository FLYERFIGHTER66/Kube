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
    ?c+    FROM     FIORDRPART
    ?c+    WHERE    OIORD#||OISEQ#||OIITEM||OISIZE not in
    ?c+     (Select OIORD#||OISEQ#||OIITEM||OISIZE from FIORDR)
    ?c+
    ?c/end-exec

     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *InzSr        BegSr                                                  ?

    ?C                   EndSr                                                  ?

