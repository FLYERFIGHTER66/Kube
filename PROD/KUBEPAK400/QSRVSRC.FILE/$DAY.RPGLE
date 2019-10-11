     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

      *? Function Prototype(s)
     D/Copy QFunctDefn,$day
     D/Copy QFunctDefn,$date8


     ?*   ..................................................................
     ?*   :  $day                                                 function :
     ?*   :................................................................:


     P $day            B                   Export
     D $day            PI             2S 0
     D   Date                          D   const

?    ?*  The $day routine returns the day portion of a given date in a date data type field

     D                 DS
     D   dayDate               1      8  0
     D   dd                    7      8  0

     C                   Eval      dayDate = $date8(Date)
     C                   return    dd

     P   $day          E
