    ?H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H DATFMT(*USA)
    ?H NOMAIN

      *? Data Structures
     D                SDS
     D #Job                  244    253                                         ?Job Name

      *? Function Prototype(s)
     D/Copy QFunctDefn,$Job

     ?*   ..................................................................
     ?*   :  $Job                                                 function :
     ?*   :................................................................:

     P  $Job           B                        Export

     D  $Job           PI            10A

      *? The $Job function returns the current Job Name.

     C                   Return    #Job

     P  $Job           E
