     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

      *? Function Prototype(s)
     D/Copy QFunctDefn,$month
     D/Copy QFunctDefn,$date8


     ?*   ..................................................................
     ?*   :  $month                                               function :
     ?*   :................................................................:

     P $month          B                   Export
     D $month          PI             2S 0
     D   Date                          D   const

?    ?*  The $month routine returns the month portion of a given date in a date data type field

     D                 DS
     D   monthDate             1      8  0
     D   mm                    5      6  0

     C                   Eval      monthDate = $date8(Date)
     C                   return    mm

     P   $month        E

