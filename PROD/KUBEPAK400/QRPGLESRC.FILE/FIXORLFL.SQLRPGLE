    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')
    ?H DftActGrp(*No)
    ?H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:                                                            :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Jun. 2009            ? Kube-Pak Corporation ?    :
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
      *?  :      UpdateItem - Set Order List Flag on FMINVT         :
      *?  :.........................................................:
    ?C     UpdateItems   BegSr                                                  ?

     ?*  Update records that should be marked Order List
    ?c/exec sql
    ?c+
    ?c+    UPDATE   FMINVT
    ?c+    SET      IMORDD  = 'Y'
    ?c+    WHERE    IMORDD <> 'Y'
    ?c+      and    IMITEM||IMSIZE in
    ?c+                (SELECT OLITEM||OLSIZE FROM fmorls)
    ?c+
    ?c/end-exec

     ?*  Update records that should not be marked Order List
    ?c/exec sql
    ?c+
    ?c+    UPDATE   FMINVT
    ?c+    SET      IMORDD  = ' '
    ?c+    WHERE    IMORDD <> ' '
    ?c+      and    IMITEM||IMSIZE not in
    ?c+                (SELECT OLITEM||OLSIZE FROM fmorls)
    ?c+
    ?c/end-exec


    ?C                   EndSr                                                  ?


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C                   EndSr                                                  ?
