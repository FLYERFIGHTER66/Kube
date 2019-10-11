     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Build Master Tag Drop Ship File                    :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  May 2005             ? Kube-Pak Corporation ?    :
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

      *? Function Prototypes
    ?D/COPY QFunctDefn,$isFile

      *? Arrays

      *? Data Structures

      *? Field Definitions

      *? Indicators

    ?C                   ExSr      BuildGriff
     C                   Eval      *InLR = *On


      *?  ...........................................................
      *?  :      BuildGriff   - Build Griffin Orders File           :
      *?  :.........................................................:

     C     BuildGriff    BegSr

      *? Delete File if it Exists

     C                   If        $isFile('GRIFFINORD')
    ?c/exec sql
    ?c+
    ?c+    DROP TABLE QTEMP/GRIFFINORD CASCADE
    ?c+
    ?c/end-exec
     C                   EndIf

      *? Create file in QTEMP

    ?c/exec sql
    ?c+
    ?c+    CREATE TABLE QTEMP/GRIFFINORD
    ?c+    (ShipDt  DEC  (  8, 0) NOT NULL WITH DEFAULT,
    ?c+     Order#  DEC  (  6, 0) NOT NULL WITH DEFAULT,
    ?c+     Item#   CHAR (    12) NOT NULL WITH DEFAULT,
    ?c+     SizeCd  CHAR (     3) NOT NULL WITH DEFAULT,
    ?c+     Descr   CHAR (    30) NOT NULL WITH DEFAULT,
    ?c+     Quant   DEC  ( 11, 2) NOT NULL WITH DEFAULT)
    ?c+
    ?c/end-exec

      *? Populate with Griffin Orders

    ?c/exec sql
    ?c+    INSERT INTO qtemp/GRIFFINORD
    ?c+    SELECT     OIRVDT + 19000000
    ?c+         ,     OIORD#
    ?c+         ,     OIITEM
    ?c+         ,     OISIZE
    ?c+         ,     OIDES1
    ?c+         ,     OIQORD
    ?c+    FROM       FIORDR
    ?c+    WHERE      OICUST =  2386
    ?c+      and      OIITYP =  ' '
    ?c+      and      OISTAT <> 'D'
    ?c+    ORDER BY   OIRVDT
    ?c+           ,   OIITMA
    ?c+
    ?c/end-exec


     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?


    ?C                   EndSr                                                  ?
