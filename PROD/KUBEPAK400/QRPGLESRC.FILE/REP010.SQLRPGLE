    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      *??:````````````````````````````````````````````````````````````:?
      *??:     Populate the REP010PF file.                            :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Oct. 2007            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program replace two queries.  CUR600QRY and        ?:
      *? : CUR600QRYA.                                               ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? : Subroutine ?-Subroutine Description                  ?  ?:
      *? :  *INZSR      -?Initialization Subroutine                  ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? : Function   ?-Function Description                    ?  ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? : *IND  ?-Indicator Usage                              ?  ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? : Int   Date  ?-Change Description                     ?  ?:
      *? :  WJB 10/22/07  ?Initial Programming                       ?:
      *? :  ... ../../..  ?..........................................?:
      *? :............................................................:

     FFCALENCY  IF   E           K DISK

     D  Week           S              2S 0
     D  Year           S              4S 0
     D  Date7          S              7S 0
     D  Date           S               D

     D/Copy QFunctDefn,$Year
     D/Copy QFunctDefn,$Date
     D/Copy QFunctDefn,$Date7
     D/Copy QFunctDefn,$Monday

      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

      *?  Clear the file if rerun for this week
    ?c/exec sql
    ?c+
    ?c+    DELETE   FROM REP010PF
    ?c+    WHERE    R1YEAR = :Year
    ?c+      and    R1WEEK = :Week
    ?c+
    ?c/end-exec

      *?  Populate the File
1.    *?    Broker Customers Broken out individually
    ?c/exec sql
    ?c+
    ?c+    INSERT INTO REP010PF
    ?c+
    ?c+    SELECT       :YEAR,
    ?c+                 :WEEK,
    ?c+                 :DATE,
    ?c+                 CMBLCU,
    ?c+                 sum(OIQORD)
    ?c+    FROM         FIORDR,
    ?c+                 FHORDR,
    ?c+                 FMCUST
    ?c+    WHERE        OIORD# = OHORD#
    ?c+      and        OHCUST = CMCUST
    ?c+      and        OIRVDT > :DATE7
    ?c+      and        OIPRCL between '50' and '60'
    ?c+      and        OHTYPE not in ('15', '35')
    ?c+      and        OHCUST not in (2730, 1521)
    ?c+      and        CMBLCU in
    ?c+                        (SELECT DISTINCT TBBROK FROM XATABL
    ?c+                         WHERE substr(TBTBCD,1,2) = 'BR')
    ?c+    group by cmblcu
    ?c+    order by cmblcu
    ?c+
    ?c/end-exec

2.    *?    Non Broker Customers rolled into One
    ?c/exec sql
    ?c+
    ?c+    INSERT INTO REP010PF
    ?c+
    ?c+    SELECT       :YEAR,
    ?c+                 :WEEK,
    ?c+                 :DATE,
    ?c+                 777777,
    ?c+                 sum(OIQORD)
    ?c+    FROM         FIORDR,
    ?c+                 FHORDR,
    ?c+                 FMCUST
    ?c+    WHERE        OIORD# = OHORD#
    ?c+      and        OHCUST = CMCUST
    ?c+      and        OIRVDT > :DATE7
    ?c+      and        OIPRCL between '50' and '60'
    ?c+      and        OHTYPE not in ('15', '35')
    ?c+      and        OHCUST not in (2730, 1521)
    ?c+      and        CMBLCU not in
    ?c+                        (SELECT DISTINCT TBBROK FROM XATABL
    ?c+                         WHERE substr(TBTBCD,1,2) = 'BR')
    ?c+
    ?c/end-exec

3.    *?    Speculation
    ?c/exec sql
    ?c+
    ?c+    INSERT INTO REP010PF
    ?c+
    ?c+    SELECT       :YEAR,
    ?c+                 :WEEK,
    ?c+                 :DATE,
    ?c+                 888888,
    ?c+                 sum(OIQORD)
    ?c+    FROM         FIORDR,
    ?c+                 FHORDR,
    ?c+                 FMCUST
    ?c+    WHERE        OIORD# = OHORD#
    ?c+      and        OHCUST = CMCUST
    ?c+      and        OIRVDT > :DATE7
    ?c+      and        OIPRCL between '50' and '60'
    ?c+      and        OHCUST = 2730
    ?c+
    ?c/end-exec

4.    *?    Kube Pak Production
    ?c/exec sql
    ?c+
    ?c+    INSERT INTO REP010PF
    ?c+
    ?c+    SELECT       :YEAR,
    ?c+                 :WEEK,
    ?c+                 :DATE,
    ?c+                 999999,
    ?c+                 sum(OIQORD)
    ?c+    FROM         FIORDR,
    ?c+                 FHORDR,
    ?c+                 FMCUST
    ?c+    WHERE        OIORD# = OHORD#
    ?c+      and        OHCUST = CMCUST
    ?c+      and        OIRVDT > :DATE7
    ?c+      and        OIPRCL between '50' and '60'
    ?c+      and        OHTYPE in ('15', '35')
    ?c+      and        OHCUST <> 2730
    ?c+
    ?c/end-exec

     C                   Eval      *InLr = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

     C                   Eval      Date  = $Monday($Date(0):'FRI')
     C                   Eval      Date7 = $Date7($Monday($Date(0):'FRI'))
     C     Date7         Chain     FCALENCY
     C                   If        %Found(FCALENCY)
     C                   Eval      Week = CLWEEK
     C                   Eval      Year = (CLCENT * 100) + CLYEAR
     C                   EndIf

     C                   EndSR
