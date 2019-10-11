    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      *??:````````````````````````````````````````````````````````````:?
      *??:     Calculate Quantity Sold since July 1st Last Year       :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Jul. 2005            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program calculates the number of trays of an item  ?:
      *? : sold since July 1st of Last Year and return the value to  ?:
      *? : the calling program.                                      ?:
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
      *? :  WJB 07/15/05  ?Program creation...                       ?:
      *? :  xxx __/__/__  ?xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx?:
      *? :............................................................:

      *?  LDA
     D                UDS

      *? Fields
     D Item            S             12A
     D Size            S              3A
     D Year            S              4A
     D July1st         S              7S 0
     D QtySold         S             15P 5
     D QtySoldParm     S             15P 5

      *? Indicators

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Year

      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

    ?C                   ExSr      GetData
    ?
     C                   Eval      QtySoldParm = QtySold
     C                   Eval      *InLR = *On


      *?  ...........................................................
      *?  :      GetData - Get selected A/R Open information        :
      *?  :.........................................................:

     C     GetData       BegSr

    ?c/exec sql
    ?c+
    ?c+    SELECT       SUM(WIQINV)
    ?c+    INTO         :QtySold
    ?c+    FROM         FIORDWIS
    ?c+    WHERE        WIITEM =  :Item
    ?c+      and        WISIZE =  :Size
    ?c+      and        WIRIND >= :July1st
    ?c+
    ?c/end-exec

     C                   EndSR

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

    ?C     *Entry        PList
    ?C                   Parm                    Item
    ?C                   Parm                    Size
    ?C                   Parm                    QtySoldParm

     C                   Eval      Year = %Char($Year($Date(0)) - 1)
     C                   Eval      July1st = $Date7($Date(%int(Year+'0701')))

     C                   EndSR
