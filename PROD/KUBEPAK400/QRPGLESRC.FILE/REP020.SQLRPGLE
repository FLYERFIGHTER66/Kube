    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      *??:````````````````````````````````````````````````````````````:?
      *??:     Populate the REP020PF file.                            :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Nov. 2007            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
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
      *? :  WJB 11/09/07  ?Initial Programming                       ?:
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

      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

      *?  Clear the file if rerun for this week
    ?c/exec sql
    ?c+
    ?c+    DELETE   FROM REP020PF
    ?c+    WHERE    R2YEAR = :Year
    ?c+      and    R2WEEK = :Week
    ?c+
    ?c/end-exec

      *?  Populate the File
1.    *?    All Customers (Bill To) Broken out individually
    ?c/exec sql
    ?c+
    ?c+    INSERT INTO REP020PF
    ?c+
    ?c+    SELECT       :YEAR
    ?c+         ,       :WEEK
    ?c+         ,       :DATE
    ?c+         ,       999999
    ?c+         ,       sum(OIQORD-OIQSHP)
    ?c+         ,       sum((OIQORD-OIQSHP)*oiupri)
    ?c+    FROM         FIORDR
    ?c+         ,       FHORDR
    ?c+    WHERE        OIORD# = OHORD#
    ?c*      and        OIRVDT > :DATE7
    ?c+      and        OIPRCL = '10'
    ?c+
    ?c/end-exec

     C                   Eval      *InLr = *On

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

     C                   Eval      Date  = $Date(0)
     C                   Eval      Year  = $Year($Date(0))
     C                   Eval      Date7 = $Date7($Date(0))
     C     Date7         Chain     FCALENCY
     C                   If        %Found(FCALENCY)
     C                   Eval      Week = CLWEEK
     C                   EndIf

     C                   EndSR
