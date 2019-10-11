     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:             Add missing seed items to KPITMWHS             :?
      *??:............................................................:?

      *?   Add Items to Warehouse 1 with Zero Balance
    ?c/exec sql
    ?c+
    ?c+    Insert into KPITMWHS
    ?c+           ( SELECT  IMITEM, IMSIZE, 1, 0
    ?c+             FROM    FMINVT
    ?c+             WHERE   IMSIZE = 'SED'
    ?c+               and   IMITEM not in (select IWPITM from KPITMWHS) )
    ?c+
    ?c/end-exec

     C                   Eval      *InLR = *On
