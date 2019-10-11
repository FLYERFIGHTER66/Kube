
     ?*   ..................................................................
     ?*   :  $date8                                               function :
     ?*   :................................................................:


     P $date8          B                   Export
     D $date8          PI             8S 0
     D   Date                          D   const datfmt(*USA)

     ?*  The $date* function returns the eight numeric date in CCYYMMDD format of the given dat
     ?*  ie. you pass (01/15/2006) you get 20060115... you pass (02/01/2004) and get 20040201

     D  AlphaDate      DS            10
     D  Alpha                  1     10    INZ('00/00/0000')
     D   AlphaMM               1      2  0
     D   AlphaDD               4      5  0
     D   AlphaCCYY             7     10  0

     C                   Move      Date          AlphaDate
     C                   return    AlphaCCYY * 10000 +
     C                             AlphaMM   * 100 +
     C                             AlphaDD   * 1

     P   $date8        E

