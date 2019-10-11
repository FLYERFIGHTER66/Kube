     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

      *? Function Prototype(s)
     D/Copy QFunctDefn,$TimeStamp


     ?*   ..................................................................
     ?*   :  $TimeStamp                                           function :
     ?*   :................................................................:

     P $TimeStamp      B                   Export
     D $TimeStamp      PI              Z

?    ?*  The $TimeStamp function returns the current Date/Time Stamp

     D   DateTime      S               Z

     C                   Time                    DateTime
     C                   return    DateTime

     P   $TimeStamp    E

