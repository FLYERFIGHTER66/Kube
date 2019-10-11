BLU |H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
BLU |H DATFMT(*USA)
BLU |H NOMAIN

WHT   *| Data Structures
     D                SDS
WHT  D #User                 254    263                                         |User I.D.

      *? Function Prototype(s)
     D/Copy QFunctDefn,$User

     ?*   ..................................................................
     ?*   :  $User                                                function :
     ?*   :................................................................:

     P  $User          B                        Export

     D  $User          PI            10A

WHT   *| The $User function returns the current User I.D.

     C                   Return    #User

     P  $User          E
