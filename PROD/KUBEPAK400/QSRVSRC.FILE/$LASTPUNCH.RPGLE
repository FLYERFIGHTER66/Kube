     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

     FFMATTENDEMIF   E           K DISK    UsrOpn

      *? Function Prototype(s)
     D/Copy QFunctDefn,$LastPunch
     D/Copy QFunctDefn,$date8


     ?*   ..................................................................
     ?*   :  $LastPunch                                           function :
     ?*   :................................................................:


     P $LastPunch      B                   Export
     D $LastPunch      PI              Z
     D   File#                        6S 0 const

     D   NODATE        S               Z   Inz

?    ?*  The $LastPunch Routine returns the last know clock punch for the given Employee.

     C                   If        not %Open(FMATTENDEM)
    ?C                   Open      FMATTENDEM
     C                   EndIf

     C     File#         SetGt     FMATTENDEM
     C     File#         ReadPe    FMATTENDEM
     C                   If        %Found(FMATTENDEM)
    ?C                   Close     FMATTENDEM
     C                   return    ATTIME
     C                   else
    ?C                   Close     FMATTENDEM
     C                   return    NODATE
     C                   EndIf

     P   $LastPunch    E

