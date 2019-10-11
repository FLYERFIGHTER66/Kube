     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:     Determine Customer Price Code                          :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Oct. 2010            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program determins the Price Code for a given       ?:
      *? : Customer based on the customer's sales volume in the      ?:
      *? : previous and current year.                                ?:
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
      *? :  WJB 10/28/10  ?Program creation...                       ?:
      *? :  xxx __/__/__  ?xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx?:
      *? :............................................................:

     FFPLGPCT   IF   E           K DISK    UsrOpn
     FFPLGPCX   IF   E           K DISK    UsrOpn
     FFMCUST    IF   E           K DISK    UsrOpn

     D Cust            S                   Like(CMCUST)
     D PC              S                   Like(CMPRCD)
     D ThisYearEndYR   S              3S 0
     D ThisYearBegYR   S              3S 0
     D LastYearEndYR   S              3S 0
     D LastYearBegYR   S              3S 0
     D ThisYearEnd     S              7S 0
     D ThisYearBeg     S              7S 0
     D LastYearEnd     S              7S 0
     D LastYearBeg     S              7S 0
     D Volume          S              9S 0
     D LastYear        S              9S 0
     D ThisYear        S              9S 0
     D LastYearShip    S              7S 0
     D LastYearShip50  S              7S 0
     D ThisYearShip    S              7S 0
     D ThisYearShip50  S              7S 0
     D ThisYearOrdr    S              7S 0
     D ThisYearOrdr50  S              7S 0
      *? Function Prototype(s)
    ?D/Copy QFunctDefn,$Date
    ?D/Copy QFunctDefn,$Year
    ?D/Copy QFunctDefn,$Month

     C     *Entry        PList
     C                   Parm                    Cust
     C                   Parm                    PC

     C                   Eval      PC                  = *Zero
     C                   Eval      ThisYearEndYR       = *Zero
     C                   Eval      ThisYearBegYR       = *Zero
     C                   Eval      LastYearEndYR       = *Zero
     C                   Eval      LastYearBegYR       = *Zero
     C                   Eval      ThisYearEnd         = *Zero
     C                   Eval      ThisYearBeg         = *Zero
     C                   Eval      LastYearEnd         = *Zero
     C                   Eval      LastYearBeg         = *Zero
     C                   Eval      Volume              = *Zero
     C                   Eval      LastYear            = *Zero
     C                   Eval      ThisYear            = *Zero
     C                   Eval      LastYearShip        = *Zero
     C                   Eval      LastYearShip50      = *Zero
     C                   Eval      ThisYearShip        = *Zero
     C                   Eval      ThisYearShip50      = *Zero
     C                   Eval      ThisYearOrdr        = *Zero
     C                   Eval      ThisYearOrdr50      = *Zero

     ?*   1.    Check Exceptions table (FPLGPCX)
     C                   Open      FPLGPCX
     C     CUST          Chain     FPLGPCX
     C                   Close     FPLGPCX
     C                   If        %Found(FPLGPCX)
     C                   Eval      PC = PXXPC
     C                   Eval      *InLR = *On
     C                   Return
     C                   EndIf

     ?*   2.    Figure out the date ranges (Years run from Sep. 1st through Aug. 31)
     ?*     a.  Figure out the current year-end year
     C                   If        $Month($date(0)) < 9
     C                   Eval      ThisYearEndYR = $Year($Date(0))     - 1900
     C                   Else
     C                   Eval      ThisYearEndYR = $Year($Date(0)) + 1 - 1900
     C                   EndIf
     ?*     b.  Figure out the the rest of the years
     C                   Eval      ThisYearBegYR = ThisYearEndYR - 1
     C                   Eval      LastYearEndYR = ThisYearEndYR - 1
     C                   Eval      LastYearBegYR = LastYearEndYR - 1
     ?*     c.  Calculate the Dates
     C                   Eval      LastYearBeg = ((LastYearBegYR)*10000) + 0901
     C                   Eval      LastYearEnd = ((LastYearEndYR)*10000) + 0831
     C                   Eval      ThisYearBeg = ((ThisYearBegYR)*10000) + 0901
     C                   Eval      ThisYearEnd = ((ThisYearEndYR)*10000) + 0831

     ?*   3.    Get Last Year's Shipped Orders
    ?c/exec sql
    ?c+
    ?c+    SELECT   COALESCE( sum( FSOHST.SOQSHP ) , 0)
    ?c+    INTO     :LastYearShip
    ?c+    from     FSOHST, FMSIZC
    ?c+    where    FSOHST.SOSIZE=FMSIZC.SCSIZE
    ?c+      and    FMSIZC.SCCATG='PLUG'
    ?c+      and    FSOHST.SOSHDT between :LastYearBeg and :LastYearEnd
    ?c+      and    FSOHST.SOCUST = :CUST
    ?c*      and    FSOHST.SOSIZE <> '51'
    ?c+      and    FSOHST.SOSIZE not in ('51','702','704','705','706')
    ?c+
    ?c/end-exec

    ?c/exec sql
    ?c+
    ?c+    SELECT   COALESCE( sum( FSOHST.SOQSHP ) / 2 , 0)
    ?c+    INTO     :LastYearShip50
    ?c+    from     FSOHST, FMSIZC
    ?c+    where    FSOHST.SOSIZE=FMSIZC.SCSIZE
    ?c+      and    FMSIZC.SCCATG='PLUG'
    ?c+      and    FSOHST.SOSHDT between :LastYearBeg and :LastYearEnd
    ?c+      and    FSOHST.SOCUST = :CUST
    ?c+      and    FSOHST.SOSIZE = '51'
    ?c+
    ?c/end-exec

     ?*   4.    Get This Year's Shipped Orders
    ?c/exec sql
    ?c+
    ?c+    SELECT   COALESCE( sum( FSOHST.SOQSHP ), 0)
    ?c+    INTO     :ThisYearShip
    ?c+    from     FSOHST, FMSIZC
    ?c+    where    FSOHST.SOSIZE=FMSIZC.SCSIZE
    ?c+      and    FMSIZC.SCCATG='PLUG'
    ?c+      and    FSOHST.SOSHDT between :ThisYearBeg and :ThisYearEnd
    ?c+      and    FSOHST.SOCUST = :CUST
    ?c*      and    FSOHST.SOSIZE <> '51'
    ?c+      and    FSOHST.SOSIZE not in ('51','702','704','705','706')
    ?c+
    ?c/end-exec

    ?c/exec sql
    ?c+
    ?c+    SELECT   COALESCE( sum( FSOHST.SOQSHP ) / 2, 0)
    ?c+    INTO     :LastYearShip50
    ?c+    from     FSOHST, FMSIZC
    ?c+    where    FSOHST.SOSIZE=FMSIZC.SCSIZE
    ?c+      and    FMSIZC.SCCATG='PLUG'
    ?c+      and    FSOHST.SOSHDT between :ThisYearBeg and :ThisYearEnd
    ?c+      and    FSOHST.SOCUST = :CUST
    ?c+      and    FSOHST.SOSIZE = '51'
    ?c+
    ?c/end-exec

     ?*   5.    Get This Year's On-Order
    ?c/exec sql
    ?c+    SELECT   COALESCE( sum(OIQORD-OIQSHP), 0)
    ?c+    INTO     :ThisYearOrdr
    ?c+    from     FHORDR, FIORDR, FMSIZC
    ?c+    where    FIORDR.OISIZE = FMSIZC.SCSIZE
    ?c+      and    FHORDR.OHORD# = FIORDR.OIORD#
    ?c+      and    FMSIZC.SCCATG = 'PLUG'
    ?c+      and    FIORDR.OIRVDT between :ThisYearBeg and :ThisYearEnd
    ?c+      and    FHORDR.OHCUST = :CUST
    ?c+      and    FIORDR.OISTAT = 'A'
    ?c+      and    FIORDR.OIITYP = ' '
    ?c+      and    FIORDR.OISIZE <> '51'
    ?c+      and    FIORDR.OISIZE not in ('51','702','704','705','706')
    ?c+
    ?c/end-exec

    ?c/exec sql
    ?c+    SELECT   COALESCE( sum(OIQORD-OIQSHP) / 2, 0)
    ?c+    INTO     :ThisYearOrdr50
    ?c+    from     FHORDR, FIORDR, FMSIZC
    ?c+    where    FIORDR.OISIZE = FMSIZC.SCSIZE
    ?c+      and    FHORDR.OHORD# = FIORDR.OIORD#
    ?c+      and    FMSIZC.SCCATG = 'PLUG'
    ?c+      and    FIORDR.OIRVDT between :ThisYearBeg and :ThisYearEnd
    ?c+      and    FHORDR.OHCUST = :CUST
    ?c+      and    FIORDR.OISTAT = 'A'
    ?c+      and    FIORDR.OIITYP = ' '
    ?c+      and    FIORDR.OISIZE = '51'
    ?c+
    ?c/end-exec

     ?*   6.    Tally up the compnent of the Years
     C                   Eval      LastYear = LastYearShip
     C                                      + LastYearShip50
     C                   Eval      ThisYear = ThisYearShip
     C                                      + ThisYearShip50
     C                                      + ThisYearOrdr
     C                                      + ThisYearOrdr50

     ?*   7.    Determine which year has a higher Volume
     C                   If        ThisYear > LastYear
     C                   Eval      Volume = ThisYear
     C                   Else
     C                   Eval      Volume = LastYear
     C                   EndIf

     ?*   8.    Determine the Price Code
     C                   Open      FPLGPCT
     C     99            Chain     FPLGPCT
     C                   Close     FPLGPCT

     C                   Select
     C                   When      Volume >= PC5VOL
     C                   Eval      PC = 5
     C                   When      Volume >= PC4VOL
     C                   Eval      PC = 4
     C                   When      Volume >= PC3VOL
     C                   Eval      PC = 3
     C                   When      Volume >= PC2VOL
     C                   Eval      PC = 2
     C                   When      Volume = *Zero
     C                   Eval      PC = 0
     C                   Other
     C                   Eval      PC = 1
     C                   EndSl
     C                   Eval      *InLR = *On
     C                   Return

     C                   Open      FMCUST
     C     CUST          Chain     FMCUST
     C                   Close     FMCUST
