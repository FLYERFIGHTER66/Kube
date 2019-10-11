    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:                                                            :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Jun. 2010            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :                                                           ?:
      *? :............................................................:

      *? Run SQL
    ?C                   ExSr      UpdateItems                                  ?
     C                   Eval      *InLR = *On


      *?  ...........................................................
      *?  :      UpdateItem - Set Lot Control Flag on FMINVT        :
      *?  :.........................................................:
    ?C     UpdateItems   BegSr                                                  ?

     ?*  Update records that should be marked Order List
    ?c/exec sql
    ?c+
    ?c+    UPDATE   FMINVT
    ?c+    SET      IMLOTC  = 'Y'
    ?c+    WHERE    IMSIZE in
    ?c+              (SELECT SCSIZE FROM FMSIZC WHERE SCCATG = 'PLUG')
    ?c+      and    IMLOTC  <>'Y'
    ?c+
    ?c/end-exec

     ?*  Update records that should not be marked Order List
    ?c/exec sql
    ?c+
    ?c+    UPDATE   FMINVT
    ?c+    SET      IMLOTC  = 'N'
    ?c+    WHERE    IMSIZE not in
    ?c+              (SELECT SCSIZE FROM FMSIZC WHERE SCCATG = 'PLUG')
    ?c+      and    IMLOTC  <>'N'
    ?c+
    ?c/end-exec


    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C                   EndSr                                                  ?
