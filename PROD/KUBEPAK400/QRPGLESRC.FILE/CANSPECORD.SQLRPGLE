     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:         Cancel Spec Order Lines by Sow Week                :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Jan 2007             ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :  This program will mark all SPEC order line items sown    ?:
      *? :  on the specified week as "D"eleted.  This will release   ?:
      *? :  the inventory as available instead of allocated to SPEC. ?:
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
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$MDYDate

      *? Arrays

      *? Data Structures

      *? Field Definitions
    ?D SowDate         S              7S 0

      *? Indicators

    ?C                   ExSr      GetDate                                      ?
    ?C                   ExSr      ZeroOrders                                   ?
     C*                  Call      'DLCLOTINV'
     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      GetDate - Get the Monday Date for Week to Clear.   :
      *?  :.........................................................:

     C     GetDate       BegSr

      *? Load a default date of Monday of last week.
     C                   Eval      #Date = $MDYDate
     C                             ($AddDate($Monday($Date(0):'SAT'):-7))
      *? Load the description fields for the Date Prompt.
     C                   Eval      #Text01 = *Blanks
     C                   Eval      #Text02 =
     C                             'Enter the MONDAY Sow Date for the SPEC  '
     C                   Eval      #Text03 =
     C                             'Orders you wish to clear.               '
     C                   Eval      #Text04 = *Blanks
     C                   Eval      #Text05 = *Blanks

    ?C                   Call      '#GETDATE'                                      ?
    ?C                   Parm                    #Date             6 0
    ?C                   Parm      0             #FromDate         6 0
    ?C                   Parm      999999        #ToDate           6 0
    ?C                   Parm      '0010000'     #DaysOK           7
    ?C                   Parm      '1'           #ReqPrior         1
    ?C                   Parm      '0'           #ReqFuture        1
    ?C                   Parm      '1'           #TodayOK          1
    ?C                   Parm                    #Text01          40
    ?C                   Parm                    #Text02          40
    ?C                   Parm                    #Text03          40
    ?C                   Parm                    #Text04          40
    ?C                   Parm                    #Text05          40

     C                   If        #Date = *Zeros
     C                   Eval      *InLR = *On
     C                   Return
     C                   EndIf

     C                   Eval      SOWDATE = $Date7($DateMDY(#Date))

     C                   EndSr


      *?  ...........................................................
      *?  :      ZeroOrders - Zero SPEC orders out for given week.  :
      *?  :.........................................................:

     C     ZeroOrders    BegSr

      *? Zero out Order Quantity on SPEC orders sown on given date.

    ?c/exec sql
    ?c+
    ?c+  update   FIORDR
    ?c+  set      OISTAT = 'D'
    ?c+  where    OICUST = 2730
    ?c+    and    OISOW  = :SOWDATE
    ?c+
    ?c/end-exec

    ?c/exec sql
    ?c+
    ?c+   DELETE FROM FALITEM
    ?c+   WHERE       AIORD#||AIOSEQ in (
    ?c+                SELECT     OIORD#||OISEQ#
    ?c+                FROM       FIORDR
    ?c+                WHERE      OICUST=2730
    ?c+                  and      OISTAT='D' )
    ?c+
    ?c/end-exec

    ?c/exec sql
    ?c+
    ?c+   update FDLOTRD
    ?c+   set    LRQTAV = LRQTOH
    ?c+     ,    LRQTAL = 0
    ?c+   WHERE  LRSOWD = :SOWDATE
    ?c+   and    LRCUST = 2730
    ?c+
    ?c/end-exec

    ?c/exec sql
    ?c+
    ?c+  update  fiordr
    ?c+  SET     oistat = 'D'
    ?c+  WHERE   oistat = 'A'
    ?c+    and   oiityp <> ' '
    ?c+    and   oicust = 2730
    ?c+    and   oiord# not in
    ?c+        ( SELECT distinct oiord#
    ?c+          from   fiordr
    ?c+          WHERE  oistat = 'A'
    ?c+            and  oiityp = ' '
    ?c+            and  oicust = 2730 )
    ?c+
    ?c/end-exec

    ?c/exec sql
    ?c+
    ?c+  Update  fhordr
    ?c+  Set     OHSTAT = 'D'
    ?c+  where   ohstat = 'A'
    ?c+    and   ohcust = 2730
    ?c+    and   ohord# not in
    ?c+         (select oiord# from fiordr where oistat = 'A')
    ?c+
    ?c/end-exec

     C                   EndSr


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

    ?C                   EndSr                                                  ?
