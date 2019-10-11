
     ?*   ..................................................................
     ?*   :  $date7                                               function :
     ?*   :................................................................:


     P $date7          B                   Export
     D $date7          PI             7S 0
     D   Date                          D   const datfmt(*USA)

     ?*  The $date* function returns the seven numeric date in CYYMMDD format of the given date
     ?*  ie. you pass (01/15/2006) you get 1060115... you pass (02/01/2004) and get 1040201

     D  AlphaDate      DS            10
     D  Alpha                  1     10    INZ('00/00/0000')
     D   AlphaMM               1      2  0
     D   AlphaDD               4      5  0
     D   AlphaCCYY             7     10  0
     D   AlphaCC               7      8  0
     D   AlphaYY               9     10  0

     D   #Date7        S              7  0

     C                   Move      Date          AlphaDate
     C                   Eval      #Date7 =
     C                             (AlphaCC - 19) * 1000000 +
     C                              AlphaYY       * 10000 +
     C                              AlphaMM       * 100 +
     C                              AlphaDD       * 1
     C                   return    #Date7

     P   $date7        E

