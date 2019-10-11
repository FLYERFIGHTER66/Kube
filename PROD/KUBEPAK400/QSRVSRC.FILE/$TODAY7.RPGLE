     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

     ?*? Function Prototype(s)                                        *
      /Copy QFunctDefn,$today7
      /Copy QFunctDefn,$_Dates

     ?*   ..................................................................
     ?*   :  $today7                                              function :
     ?*   :................................................................:

     P $today7         B                   Export
     D $today7         PI             7S 0
     D #today7         S              7S 0

     ?*  The $today function returns the seven numeric date in CYYMMDD format for today

      /Free
         #today7 = $date7($date(0));
         return #today7;
      /End-Free
     P   $today7       E

