     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

     C/Copy QFunctDefn,$Monday
     C/Copy QFunctDefn,$weekDay
     C/Copy QFunctDefn,$addDate


     ?*   ..................................................................
     ?*   :  $Monday                                              function :
     ?*   :................................................................:

     P $Monday         B                   Export
     D $Monday         PI              D
     D   Date                          D   DatFmt(*usa) const                   ?Date to get Mon. of
     D   StartsOn                     3A   const                                ?Day the Week Starts

?    ?*  The $Monday function returns a date field value for the Monday date of the week in
?    ?*  which the given date falls, based on the day on which the week begins on.
?    ?*   ie. - If you pass a date which is a Thursday and say that the week begins on
?    ?*         Wednesday you will get the following Monday.  If you pass the same date and
?    ?*         say that the week begins on Saturday, you get the Monday before Thursday.

     D   StartVal      S              1S 0
     D   CompVal       S              1S 0
     D   x             S              1S 0
     D   wkDate        S               D   DatFmt(*usa)

     C                   Eval      CompVal = $WeekDay(Date:'MON')

     C                   If        $WeekDay(Date:StartsOn)>=$weekDay(Date:'MON')
     C                   Eval      wkDate = $AddDate(Date:-CompVal+1)
     C                   else
     C                   Eval      wkDate = $AddDate(Date:-CompVal+8)
     C                   EndIf

     C                   return    wkDate

     P   $Monday       E
