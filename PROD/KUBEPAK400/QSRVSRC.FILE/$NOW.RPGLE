     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

      *? Function Prototype(s)
     D/Copy QFunctDefn,$Now


     ?*   ..................................................................
     ?*   :  $Now                                                 function :
     ?*   :................................................................:

     P $Now            B                   Export
     D $Now            PI             6S 0

?    ?*  The $Now routine returns the hh:mm:ss portion of the current timestamp

     D   Timenow       S              6  0

     C                   Time                    Timenow
     C                   return    Timenow

     P   $Now          E

