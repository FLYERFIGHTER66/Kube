     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

      *? Function Prototype(s)
     D/Copy QFunctDefn,$year
     D/Copy QFunctDefn,$date8


     ?*   ..................................................................
     ?*   :  $year                                                function :
     ?*   :................................................................:

     P $year           B                   Export
     D $year           PI             4S 0
     D   Date                          D   const

?    ?*  The $year routine returns the year portion of a given date in a date data type field

     D                 DS             8
     D   yearDate              1      8  0
     D   yyyy                  1      4  0

     C                   Eval      yearDate = $date8(Date)
     C                   return    yyyy

     P   $year         E

