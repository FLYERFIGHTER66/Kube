     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

      *? Function Prototype(s)
     D/Copy QFunctDefn,$weekDay


     ?*   ..................................................................
     ?*   :  $weekDay                                             function :
     ?*   :................................................................:


     P $weekDay        B                   Export                               Day of the Week
     D $weekDay        PI             1S 0
     D   Date                          D   const
     D   FirstDay                     3A   const

?    ?*  The $weekDay routine returns the number (1-7) corresponding to the Week Day of the dat
?    ?*  specified.  The number is the day number based on the First day of the week specified.
?    ?*  ie.  If you pass January 1st (a Monday for argument sake) as the date and specify that
?    ?*  'SUN' is the first day of the week, this routine will return a value of 2.

     D   FirstDate     S               D   DATFMT(*USA)
     D   HighestDate   S               D   DATFMT(*USA) INZ(D'12/31/3000')
     D   FirstMon      S               D   DATFMT(*USA) INZ(D'01/01/1900')
     D   FirstTue      S               D   DATFMT(*USA) INZ(D'01/02/1900')
     D   FirstWed      S               D   DATFMT(*USA) INZ(D'01/03/1900')
     D   FirstThu      S               D   DATFMT(*USA) INZ(D'01/04/1900')
     D   FirstFri      S               D   DATFMT(*USA) INZ(D'01/05/1900')
     D   FirstSat      S               D   DATFMT(*USA) INZ(D'01/06/1900')
     D   FirstSun      S               D   DATFMT(*USA) INZ(D'01/07/1900')

     C                   Select
     C                   When      FirstDay = 'MON'
     C                   Eval      FirstDate = FirstMon
     C                   When      FirstDay = 'TUE'
     C                   Eval      FirstDate = FirstTue
     C                   When      FirstDay = 'WED'
     C                   Eval      FirstDate = FirstWed
     C                   When      FirstDay = 'THU'
     C                   Eval      FirstDate = FirstThu
     C                   When      FirstDay = 'FRI'
     C                   Eval      FirstDate = FirstFri
     C                   When      FirstDay = 'SAT'
     C                   Eval      FirstDate = FirstSat
     C                   When      FirstDay = 'SUN'
     C                   Eval      FirstDate = FirstSun
     C                   Other
     C                   return    0
     C                   EndSL

     C                   IF        Date < FirstDate or
     C                             Date > HighestDate
     C                   return    0
     C                   EndIF

     C     Date          SUBDUR    FirstDate     #Days:*D          7 0
     C                   return    %Rem(#Days:7) + 1
     P $weekDay        E

