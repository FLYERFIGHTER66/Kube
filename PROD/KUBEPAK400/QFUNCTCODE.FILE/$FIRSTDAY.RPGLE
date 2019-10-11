
     ?*   ..................................................................
     ?*   :  $firstDay                                            function :
     ?*   :................................................................:


     P $firstDay       B                   Export
     D $firstDay       PI              D
     D   Date                          D   const datfmt(*ISO)

?    ?*  The $firstDay routine returns the first day of the month for the month of the given da
?    ?*  ie. you pass 01/15/2006 you get 01/01/2006... you pass 02/28/2004 and get 02/01/2004

     D   #DaysBack     S              2S 0
     D   wkDate        S               D   datfmt(*ISO)

     C                   Eval      wkDate = Date
     C                   Eval      #DaysBack  = $day(Date) - 1
     C     wkDate        SUBDUR    #DaysBack:*D  wkDate
     C                   return    wkDate

     P   $firstDay     E

