     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

      *? Function Prototype(s)
     D/Copy QFunctDefn,$today
     D/Copy QFunctDefn,$_dates

     ?*   ..................................................................
     ?*   :  $today                                               function :
     ?*   :................................................................:

     P $today          B                   Export
     D $today          PI             6S 0
     D   #today        S              6S 0

      /Free
         #today = $MDYDate($Date(0));
         Return #today;
      /End-Free

     P $today          E
