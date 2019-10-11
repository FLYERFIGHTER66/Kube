     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??: NCR600.02                                                  :?
      *??:............................................................:?
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? : Created:  2014                 ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Program Description                                     ?:
      *? : This program compares the FPUTORD and FPUTSCN files for a ?:
      *? : given order on a specific master and sets the trucking    ?:
      *? : header file as verified if the two match exactly.  No      :
      *? : action is taken if the files do not match.                ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? :  NCR605.01?Original Version                               ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :............................................................:
     FNPUTORDO  IF   E           K DISK

      //  Main procedure prototype & interface
     D NCR605          PR                  ExtPgm('NCR605')
     D   SelDate7                     7S 0 CONST
     D   SelMast                      2S 0 CONST
     D   SelOrder                     6S 0 CONST
     D NCR605          PI
     D   SelDate7                     7S 0 CONST
     D   SelMast                      2S 0 CONST
     D   SelOrder                     6S 0 CONST

      *? Function Prototypes
     D/COPY QFunctDefn,$TimeStamp
     D/COPY QFunctDefn,$User

      //   Main Logic
      /Free

         If GoodScan();
           UpdateTrucks();
         EndIf;
         *InLR = *On;
         Return;

      /End-Free


      // Sub Procedures

     P GoodScan        B
     D GoodScan        PI              N

     D QtyOrdered      S                   Like(PDQORD)
     D QtyScanned      S                   Like(PDQORD)
     D OverScan        S                   Like(PDQORD)

      /Free

         // First Check Scanned Quantity on each Item Ordered.
         SetLL (SelDate7:SelMast:SelOrder) NPUTORDO;
         ReadE (SelDate7:SelMast:SelOrder) NPUTORDO;
         DoW Not %EOF(NPUTORDO);
           //Process Each Ordered Item Only Once
           QtyOrdered = 0;
           QtyScanned = 0;
           Exec SQL Select Sum(PDQORD) INTO :QtyOrdered FROM NPUTORD
             Where PDSHPD = :PDSHPD
               and PDMSTR = :PDMSTR
               and PDORD# = :PDORD#
               and PDITEM = :PDITEM
               and PDSIZE = :PDSIZE;
           Exec SQL Select Sum(PSCSCN) INTO :QtyScanned FROM NPUTSCN
             Where PSSHPD = :PDSHPD
               and PSMSTR = :PDMSTR
               and PSORD# = :PDORD#
               and PSITEM = :PDITEM
               and PSSIZE = :PDSIZE;
           If QtyOrdered <> QtyScanned;
             Return *Off;  // It's NOT a GoodScan
           EndIf;
           SetGT (SelDate7:SelMast:SelOrder:PDITEM:PDSIZE) NPUTORDO; //SETGT ensures each item once
           ReadE (SelDate7:SelMast:SelOrder) NPUTORDO;
         EndDo;

         // Then Check for Scans of Items not Ordered
         OverScan = 0;
         Exec SQL
           SELECT   sum(PSCSCN)
           INTO     :OverScan
           FROM     nputscn
           WHERE    PSSHPD = :SelDate7
             and    PSMSTR = :SelMast
             and    PSORD# = :SelOrder
             and    PSSHPD||PSMSTR||PSORD#||PSITEM||PSSIZE not in
           ( SELECT   PDSHPD||PDMSTR||PDORD#||PDITEM||PDSIZE
             FROM     NPUTORD
             WHERE    PDSHPD = :SelDate7
               and    PDMSTR = :SelMast
               and    PDORD# = :SelOrder    );
         If OverScan <> 0;
           Return *Off;  // It's NOT a GoodScan
         EndIf;

         Return *On;  // It IS a GoodScan

      /End-Free

     P GoodScan        E

      //________________________________________________________________________
      //

     P UpdateTrucks    B
     D UpdateTrucks    PI

     D  #Truck         S                   Like(PDLOC)
     D  #TimeStamp     S               Z
     D  #User          S             10A
      /Free

         Exec SQL
           SELECT min(PDLOC)
           INTO   :#Truck
           FROM   NPUTORD
           WHERE  PDORD# = :SelOrder
             and  PDSHPD = :SelDate7
             and  PDMSTR = :SelMast;
         #Truck = %Trim(#Truck);
         If %Scan('-':#Truck:1) >= 1;
           #Truck = %Subst(#Truck:1:%Scan('-':#Truck:1)-1);
           #TimeStamp = $TimeStamp();
           #User = $User();
           Exec SQL
             UPDATE FTRSCHD
             SET    TRCODC = 'Y'
               ,    TRCODT = :#TimeStamp
               ,    TRCODU = :#User
             WHERE  TRTRK# = :#TRUCK
               and  TRSHDT = :SelDate7
               and  TRORD# = :SelOrder;
         EndIf;
      /End-Free
     P UpdateTrucks    E

