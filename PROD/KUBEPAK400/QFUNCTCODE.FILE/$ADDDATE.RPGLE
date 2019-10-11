
     ?*   ..................................................................
     ?*   :  $AddDate                                             function :
     ?*   :................................................................:

     P $adddate        B                   Export
     D $adddate        PI              D
     D   Date                          D   DatFmt(*usa)
     D   Days                         5S 0

?    ?*  The $adddate function returns a date field value for a given date and number of days
?    ?*  added together.
?    ?*  ie. you pass 01/15/2006 and 20 you get 02/04/2006
?    ?*      you pass 01/15/2006 and -20 you get 12/27/2005

     D   wkDate        S               D   DatFmt(*USA)

     C                   Eval      wkDate = Date
     C                   AddDur    Days:*D       wkDate
     C                   return    wkDate

     P   $adddate      E
