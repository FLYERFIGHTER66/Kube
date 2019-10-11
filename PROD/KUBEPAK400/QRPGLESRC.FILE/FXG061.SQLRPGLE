     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Retrieve Item Lot Loss Information                 :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Nov 2005             ? Kube-Pak Corporation ?    :
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

      *? Arrays

      *? Data Structures

      *? Field Definitions
     D   Item          S             12A                                        ?Item
     D   Size          S              3A                                        ?Size
     D   ShipDate      S              7S 0                                      ?Ship Date CYMD
     D   QtyOrdered    S              7S 0                                      ?Quantity Ordered
     D   QtyLost       S              7S 0                                      ?Quantity Lost
     D   QtySown       S              7S 0                                      ?Quantity Sown
     D   TotalLoss     S              7S 0                                      ?Total Loss Quantity
     D   Scanned       S              7S 0                                      ?Tot Scanned in Fix
     D   Unfixed       S              7S 0                                      ?Tray not fixed
     D   Partials      S              7S 0                                      ?Count Partials
     D   PartSum       S              7S 2                                      ?Sum Partials
     D   Reason        S              1A                                        ?Reason Code

     D   BlankJob      S              4A   Inz(*Blanks)                         ?Pass a blank job#

      *? Indicators

      *? Main Calcs
    ?C                   ExSr      GetVariables                                 ?

      *? Fix Sow Job Schedule if Bad
     C                   If        QtySown = 0 and
     C                             Scanned > 0
    ?C                   Call      'SOW037'
    ?C                   Parm                    ShipDate
    ?C                   Parm                    Item
    ?C                   Parm                    Size
    ?C                   Parm                    BlankJob
    ?C                   ExSr      GetVariables                                 ?
     C                   EndIf

     C                   Eval      *InLR = *On


      *?  ...........................................................
      *?  :      GetVariables - Run SQL to retrieve variables       :
      *?  :.........................................................:

     C     GetVariables  BegSr

      *? Get quantity ordered

    ?c/exec sql
    ?c+
    ?c+  SELECT  Sum(OIQORD)
    ?c+  INTO    :QtyOrdered
    ?c+  FROM    FIORDR
    ?c+  WHERE   OISTAT = 'A'
    ?c+    and   OIITEM = :Item
    ?c+    and   OISIZE = :Size
    ?c+    and   OIRVDT = :ShipDate
    ?c+    and   OICUST <> 2730
    ?c+
    ?c/end-exec


      *? Get quantity sown

    ?c/exec sql
    ?c+
    ?c+  SELECT  Sum(SOSOWQ)
    ?c+  INTO    :QtySown
    ?c+  FROM    FSOWSCH
WJB ?c*  WHERE   SOSTAT = 'C'   3/8 - Removed the reqirement for Complete Jobs
    ?c+  WHERE
    ?c+          SOITEM = :Item
    ?c+    and   SOSIZE = :Size
    ?c+    and   SORDYD = :ShipDate
    ?c+
    ?c/end-exec


      *? Get QtyLoss for this reason

    ?c/exec sql
    ?c+
    ?c+  SELECT  COUNT(*)
    ?c+  INTO    :QtyLost
    ?c+  FROM    FLOSSD
    ?c+  WHERE   LDCODE = :Reason
    ?c+    and   LDITEM = :Item
    ?c+    and   LDSIZE = :Size
    ?c+    and   LDREDY = :ShipDate
    ?c+
    ?c/end-exec

      *? Get TotalLoss for this lot.

    ?c/exec sql
    ?c+
    ?c+  SELECT  COUNT(*)
    ?c+  INTO    :TotalLoss
    ?c+  FROM    FLOSSD
    ?c+  WHERE   LDITEM = :Item
    ?c+    and   LDSIZE = :Size
    ?c+    and   LDREDY = :ShipDate
    ?c+
    ?c/end-exec

      *? Get Scanned Quantity

    ?c/exec sql
    ?c+
    ?c+  SELECT  COUNT(distinct(TFTAG#))
    ?c+  INTO    :Scanned
    ?c+  FROM    FTRAYFIXED as A, FTRAY as B
    ?c+  WHERE   A.TFTAG# = B.TRTAG#
    ?c+    and   B.TRITEM = :Item
    ?c+    and   B.TRSIZE = :Size
    ?c+    and   B.TRCRDT = :ShipDate
    ?c+
    ?c/end-exec

      *? Get Quantity Lost before fixing

    ?c/exec sql
    ?c+
    ?c+  SELECT  COUNT(*)
    ?c+  INTO    :UnFixed
    ?c+  FROM    FTRAY
    ?c+  WHERE   TRTAG# not in (Select TFTAG# from FTRAYFIXED)
    ?c+    and   TRTAG# not in (Select LDTAG# from FLOSSD)
    ?c+    and   TRSTAT <> ' '
    ?c+    and   TRSTAT <> 'D'
    ?c+    and   TRITEM = :Item
    ?c+    and   TRSIZE = :Size
    ?c+    and   TRCRDT = :ShipDate
    ?c+
    ?c/end-exec

      *? Get Count of Partials

    ?c/exec sql
    ?c+
    ?c+  SELECT  COUNT(*)
    ?c+  INTO    :Partials
    ?c+  FROM    FLOSSD
    ?c+  WHERE   LDITEM = :Item
    ?c+    and   LDSIZE = :Size
    ?c+    and   LDREDY = :ShipDate
    ?c+    and   LDCODE = 'P'
    ?c+
    ?c/end-exec

      *? Get Sum of Partials

    ?c/exec sql
    ?c+
    ?c+  SELECT  Sum(LDPCTF/100)
    ?c+  INTO    :PartSum
    ?c+  FROM    FPARTIAL
    ?c+  WHERE   LDITEM = :Item
    ?c+    and   LDSIZE = :Size
    ?c+    and   LDREDY = :ShipDate
    ?c+
    ?c/end-exec

     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C     *Entry        PList
    ?C                   Parm                    Item
    ?C                   Parm                    Size
    ?C                   Parm                    ShipDate
    ?C                   Parm                    Reason
    ?C                   Parm                    QtyOrdered
    ?C                   Parm                    QtySown
    ?C                   Parm                    QtyLost
    ?C                   Parm                    TotalLoss
    ?C                   Parm                    Scanned
    ?C                   Parm                    Unfixed
    ?C                   Parm                    Partials
    ?C                   Parm                    PartSum

    ?C                   EndSr                                                  ?
