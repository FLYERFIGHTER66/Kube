     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

      *? Function Prototype(s)
     D/Copy QFunctDefn,$lastDay
     D/Copy QFunctDefn,$date8


     ?*   ..................................................................
     ?*   :  $lastDay                                             function :
     ?*   :................................................................:


     P $lastDay        B                   Export
     D $lastDay        PI              D
     D   Date                          D   const datfmt(*ISO)

?    ?*  The $lastDay routine returns the last day of the month for the month of the given date
?    ?*  ie. you pass 01/15/2006 you get 01/31/2006... you pass 02/01/2004 and get 02/29/2004

     D   wkDate        S               D   datfmt(*ISO)

     D                 DS
     D   dayDate               1      8  0
     D   dd                    7      8  0

     C                   Eval      dayDate = $date8(Date)
     C                   Eval      dd = 01
     C                   Move      dayDate       wkDate
     C     wkDate        AddDur    1:*M          wkDate
     C     wkDate        SubDur    1:*D          wkDate
     C                   return    wkDate

     P   $lastDay      E

