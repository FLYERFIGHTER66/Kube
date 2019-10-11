    ?H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H DATFMT(*USA)
    ?H NOMAIN

      *? Data Structures
     D                SDS
     D #JobNbr               264    269S 0                                      ?Job Number

      *? Function Prototype(s)
     D/Copy QFunctDefn,$JobNbr

     ?*   ..................................................................
     ?*   :  $JobNbr                                              function :
     ?*   :................................................................:

     P  $JobNbr        B                        Export

     D  $JobNbr        PI             6S 0

      *? The $JobNbr function returns the current Job Number.

     C                   Return    #JobNbr

     P  $JobNbr        E
