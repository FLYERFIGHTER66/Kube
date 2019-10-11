     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

     ?*? Function Prototype(s)                                        *
      /Copy QFunctDefn,$date7iso


     ?*   ..................................................................
     ?*   :  $date7                                               function :
     ?*   :................................................................:


     P $date7iso       B                   Export
     D $date7iso       PI             7S 0
     D   Date                          D   const datfmt(*ISO)

     ?*  The $date* function returns the seven numeric date in CYYMMDD format of the given date
     ?*  ie. you pass (01/15/2006) you get 1060115... you pass (02/01/2004) and get 1040201

     D  AlphaDate      DS            10
     D  Alpha                  1     10    INZ('0000-00-00')
     D   AlphaCCYY             1      4  0
     D   AlphaCC               1      2  0
     D   AlphaYY               3      4  0
     D   AlphaMM               6      7  0
     D   AlphaDD               9     10  0

     D   #Date7        S              7  0

     C                   Move      Date          AlphaDate
     C                   Eval      #Date7 =
     C                             (AlphaCC - 19) * 1000000 +
     C                              AlphaYY       * 10000 +
     C                              AlphaMM       * 100 +
     C                              AlphaDD       * 1
     C                   return    #Date7

     P   $date7iso     E

