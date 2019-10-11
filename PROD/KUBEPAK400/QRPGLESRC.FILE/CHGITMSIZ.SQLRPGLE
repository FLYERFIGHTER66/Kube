     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:       Change a size code on a non-lot item                 :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  May 2006             ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? :  *INZSR   -?Initialization Subroutine                     ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:


      *? FIORDR
      *? FIX FIORDR
    ?c/exec sql
    ?c+
    ?c+  UPDATE FIORDR AS A
    ?c+  SET   OIITMA =
    ?c+  ( SELECT B.IMLOOK FROM FMINVT AS B WHERE B.IMITEM = A.OIITEM
    ?c+                                       AND B.IMSIZE = A.OISIZE )
    ?c+  WHERE OIITMA <>
    ?c+  ( SELECT C.IMLOOK FROM FMINVT AS C WHERE C.IMITEM = A.OIITEM
    ?c+                                       AND C.IMSIZE = A.OISIZE )
    ?c+
    ?c/end-exec

      *? FIX FSOWSCH
    ?c/exec sql
    ?c+
    ?c+  UPDATE FSOWSCH AS A
    ?c+  SET   SOLOOK =
    ?c+  ( SELECT B.IMLOOK FROM FMINVT AS B WHERE B.IMITEM = A.SOITEM
    ?c+                                       AND B.IMSIZE = A.SOSIZE )
    ?c+  WHERE SOLOOK <>
    ?c+  ( SELECT C.IMLOOK FROM FMINVT AS C WHERE C.IMITEM = A.SOITEM
    ?c+                                       AND C.IMSIZE = A.SOSIZE )
    ?c+
    ?c/end-exec

      *? FIX FTRAY
    ?c/exec sql
    ?c+
    ?c+  UPDATE FTRAY   AS A
    ?c+  SET   TRALPH =
    ?c+  ( SELECT B.IMLOOK FROM FMINVT AS B WHERE B.IMITEM = A.TRITEM
    ?c+                                       AND B.IMSIZE = A.TRSIZE )
    ?c+  WHERE TRTAG# > 1200000
    ?c+    AND TRALPH <>
    ?c+  ( SELECT C.IMLOOK FROM FMINVT AS C WHERE C.IMITEM = A.TRITEM
    ?c+                                       AND C.IMSIZE = A.TRSIZE )
    ?c+
    ?c/end-exec

      *? FIX FTRAYR
    ?c/exec sql
    ?c+
    ?c+  UPDATE FTRAYR  AS A
    ?c+  SET   TRALPH =
    ?c+  ( SELECT B.IMLOOK FROM FMINVT AS B WHERE B.IMITEM = A.TRITEM
    ?c+                                       AND B.IMSIZE = A.TRSIZE )
    ?c+  WHERE TRTAG# > 1200000
    ?c+    AND TRALPH <>
    ?c+  ( SELECT C.IMLOOK FROM FMINVT AS C WHERE C.IMITEM = A.TRITEM
    ?c+                                       AND C.IMSIZE = A.TRSIZE )
    ?c+
    ?c/end-exec

     C                   Eval      *InLR = *On


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C     *Entry        PList                                                  ?
    ?C                   Parm                    Item
    ?C                   Parm                    OldSize
    ?C                   Parm                    NewSize

    ?C                   EndSr                                                  ?
