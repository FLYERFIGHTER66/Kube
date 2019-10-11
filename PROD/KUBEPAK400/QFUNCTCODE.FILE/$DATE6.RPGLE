
     ?*   ..................................................................
     ?*   :  $date6                                               function :
     ?*   :................................................................:


     P $date6          B                   Export
     D $date6          PI             6S 0
     D   Date                          D   const datfmt(*USA)

     ?*  The $date* function returns the six numeric date in YYMMDD format of the given date
     ?*  ie. you pass (01/15/2006) you get 060115... you pass (02/01/2004) and get 040201

     D  AlphaDate      DS            10
     D  Alpha                  1     10    INZ('00/00/0000')
     D   AlphaMM               1      2  0
     D   AlphaDD               4      5  0
     D   AlphaYY               9     10  0

     C                   Move      Date          AlphaDate
     C                   return    AlphaYY   * 10000 +
     C                             AlphaMM   * 100 +
     C                             AlphaDD   * 1

     P   $date6        E

