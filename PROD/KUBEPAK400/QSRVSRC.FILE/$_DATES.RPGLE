     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

      *? Function Prototype(s)
     D/Copy QFunctDefn,$AddDate
     D/Copy QFunctDefn,$Date
     D/Copy QFunctDefn,$DateMDY
     D/Copy QFunctDefn,$Date6
     D/Copy QFunctDefn,$Date7
     D/Copy QFunctDefn,$Date8
     D/Copy QFunctDefn,$IsDate#
     D/Copy QFunctDefn,$IsDate@
     D/Copy QFunctDefn,$MDYDate
     D/Copy QFunctDefn,$MDYDate8
     D/Copy QFunctDefn,$today
     D/Copy QFunctDefn,$today7
     D/Copy QFunctDefn,$BillTest


     ?*   ..................................................................
     ?*   :  $AddDate                                             function :
     ?*   :................................................................:

     P $adddate        B                   Export
     D $adddate        PI              D
     D   Date                          D   DatFmt(*usa) const
     D   Days                         5S 0 const

?    ?*  The $adddate function returns a date field value for a given date and number of days
?    ?*  added together.
?    ?*  ie. you pass 01/15/2006 and 20 you get 02/04/2006
?    ?*      you pass 01/15/2006 and -20 you get 12/27/2005

     D   wkDate        S               D   DatFmt(*USA)

     C                   Eval      wkDate = Date
     C                   AddDur    Days:*D       wkDate
     C                   return    wkDate

     P   $adddate      E

     ?*   ..................................................................
     ?*   :  $date                                                function :
     ?*   :................................................................:

     P $date           B                   Export
     D $date           PI              D
     D   Date                         8S 0 const

?    ?*  The $date function returns a date field value for a given date passed in to this
?    ?*  function in an eight,seven, or six digit numeric field in CCYYMMDD format.
?    ?*  ie. you pass 20060115 and get (01/15/2006)
?    ?*  NOTE:  by default, if you pass a zero, you get todays date

     D  wkDate         S               D   datfmt(*USA)
     D dftDate         S               D   datfmt(*USA) inz(D'01/01/0001')

     D  DateDS         DS
     D  DateWk                 1      8  0 INZ(0)
     D        CC               1      2  0
     D        YY               2      4  0

     C                   Z-add     Date          DateWk
     C                   If        DateWk = *Zero
     C     10000.0001    Mult      *Date         DateWK
     C                   EndIf

     C                   Select
     C                   When      DateWk > 9999999                             Eight Digits +
      *                  No Action...  already 8 digits
     C                   When      DateWk > 999999                              Seven Digits +
     C                   Add       19            CC
     C                   Other                                                  Six Digits or Less
     C                   IF        YY > 70
     C                   Add       19            CC
     C                   Else
     C                   Add       20            CC
     C                   EndIF
     C                   EndSL

     C                   IF        $isDate#(DateWk:'*ISO')
     C     *ISO          Move      DateWk        wkDate
     C                   return    wkDate
     C                   else
     C                   return    dftDate
     C                   EndIF

     P   $date         E


     ?*   ..................................................................
     ?*   :  $dateMDY                                             function :
     ?*   :................................................................:

     P $dateMDY        B                   Export
     D $dateMDY        PI              D
     D   Date6                        6S 0 const

?    ?*  The $dateMDY function returns a date field value for a given date passed in to this
?    ?*  function in an six digit numeric field in MMDDYY format.
?    ?*  ie. you pass 011506 and get (01/15/2006)

     D  wkDate         S               D   datfmt(*USA)
     D dftDate         S               D   datfmt(*USA) inz(D'01/01/0001')

     D  DateDS         DS
     D  DateWk                 1      8  0
     D        CC               1      2  0
     D        YY               3      4  0

     C     Date6         Mult      10000.01      DateWk

     C                   IF        YY > 70
     C                   Z-Add     19            CC
     C                   Else
     C                   Z-add     20            CC
     C                   EndIF

     C                   IF        $isDate#(DateWk:'*ISO')
     C     *ISO          Move      DateWk        wkDate
     C                   return    wkDate
     C                   else
     C                   return    dftDate
     C                   EndIF

     P   $dateMDY      E


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



     ?*   ..................................................................
     ?*   :  $isDate#                                             function :
     ?*   :................................................................:


     P  $isDate#       B                        Export
     D  $isDate#       PI              N
     D     #isDate#                   8S 0      const
     D     #format                    9A        const

?    ?*  The $isDate function checks to see if the value passed is a valid Date in format speci
?    ?*  Use this function when the field to be tested is a numeric field not containing separa
?    ?*  ie. *USA is formated (mmddyyyy)
?    ?*  NOTE:  for testing alpha Date fields, use $isDate@
     D                 DS
     D    #isDate#8            1      8  0
     D    #isDate#7            2      8  0
     D    #isDate#6            3      8  0
     D    #isDate#5            4      8  0

     C                   Z-add     #isDate#      #isDate#8
     C                   Select

     ?*  Julian Date Formats
     C                   When      #format = '*LONGJUL'
     C     *JUL          Test (ED)               #isDate#5
     C                   When      #format = '*LONGJUL'
     C     *LONGJUL      Test (ED)               #isDate#7

     ?*  Two digit year date formats
     C                   When      #format = '*YMD'
     C     *YMD          Test (ED)               #isDate#6
     C                   When      #format = '*MDY'
     C     *MDY          Test (ED)               #isDate#6
     C                   When      #format = '*DMY'
     C     *DMY          Test (ED)               #isDate#6

?    ?*  Three digit year date formats
     C                   When      #format = '*CYMD'
     C     *CYMD         Test (ED)               #isDate#7
     C                   When      #format = '*CMDY'
     C     *CMDY         Test (ED)               #isDate#7
     C                   When      #format = '*CMDY'
     C     *CDMY         Test (ED)               #isDate#7

?    ?*  Four digit year date formats
     C                   When      #format = '*USA'
     C     *USA          Test (ED)               #isDate#8
     C                   When      #format = '*ISO'
     C     *ISO          Test (ED)               #isDate#8
     C                   When      #format = '*JIS'
     C     *JIS          Test (ED)               #isDate#8


     C                   Other
     C                   return    *On
     C                   EndSL

     C                   return    not %Error

     P  $isDate#       E


     ?*   ..................................................................
     ?*   :  $isDate@                                             function :
     ?*   :................................................................:


     P  $isDate@       B                        Export
     D  $isDate@       PI              N
     D     #isDate@                  10A        const
     D     #format                    9A        const

?    ?*  The $isDate function checks to see if the value passed is a valid Date in format speci
?    ?*  Use this function when the field to be tested is an alpha field containing separators.
?    ?*  ie. *USA is formated ('mm/dd/yyyy')
?    ?*  NOTE:  for testing numeric Date fields, use $isDate#
     D                 DS
     D    #isDate@10           1     10
     D    #isDate@9            1      9
     D    #isDate@8            1      8
     D    #isDate@6            1      6

     C                   Move      #isDate@      #isDate@10
     C                   Select

     ?*  Julian Date Formats
     C                   When      #format = '*LONGJUL'
     C     *JUL          Test (ED)               #isDate@6
     C                   When      #format = '*LONGJUL'
     C     *LONGJUL      Test (ED)               #isDate@8

     ?*  Two digit year date formats
     C                   When      #format = '*YMD'
     C     *YMD          Test (ED)               #isDate@8
     C                   When      #format = '*MDY'
     C     *MDY          Test (ED)               #isDate@8
     C                   When      #format = '*DMY'
     C     *DMY          Test (ED)               #isDate@8

?    ?*  Three digit year date formats
     C                   When      #format = '*CYMD'
     C     *CYMD         Test (ED)               #isDate@9
     C                   When      #format = '*CMDY'
     C     *CMDY         Test (ED)               #isDate@9
     C                   When      #format = '*CMDY'
     C     *CDMY         Test (ED)               #isDate@9

?    ?*  Four digit year date formats
     C                   When      #format = '*USA'
     C     *USA          Test (ED)               #isDate@10
     C                   When      #format = '*ISO'
     C     *ISO          Test (ED)               #isDate@10
     C                   When      #format = '*JIS'
     C     *JIS          Test (ED)               #isDate@10


     C                   Other
     C                   return    *On
     C                   EndSL

     C                   return    not %Error

     P  $isDate@       E



     ?*   ..................................................................
     ?*   :  $MDYDate                                             function :
     ?*   :................................................................:

     P $MDYDate        B                   Export
     D $MDYDate        PI             6S 0
     D   $date                         D   const

?    ?*  The $MDYDate function returns a 6 digit daye in MDY format for Date field passed
?    ?*  ie. you pass (01/15/2006) and you get 011506

     D  DateDS         DS
     D  DateWk                 1      8  0
     D    Last6                3      8  0


     C     *ISO          Move      $date         DateWk
     C                   Mult      100.0001      Last6
     C                   return    Last6

     P   $MDYDate      E


     ?*   ..................................................................
     ?*   :  $MDYDate8                                            function :
     ?*   :................................................................:

     P $MDYDate8       B                   Export
     D $MDYDate8       PI             8S 0
     D   $date                         D   const

?    ?*  The $MDYDate8function returns a 6 digit daye in MDY format for Date field passed
?    ?*  ie. you pass (01/15/2006) and you get 01152006

     D  DateWk         S              8  0

     C     *USA          Move      $date         DateWk
     C                   return    DateWk

     P   $MDYDate8     E


     ?*   ..................................................................
     ?*   :  $BillTest                                            function :
     ?*   :................................................................:

     P $BillTest       B                   Export
     D $BillTest       PI              N
      /Free
         //?  This is a TEST
         Return *On;
      /End-Free
     P $BillTest       E
     ?*   ..................................................................
     ?*   :  $today                                               function :
     ?*   :................................................................:

     P $today          B                   Export
     D $today          PI             6S 0
     D   #today        S              6S 0

      /Free
         #today = $MDYDate($Date(0));
         Return #today;
      /End-Free

     P $today          E
     ?*   ..................................................................
     ?*   :  $today7                                              function :
     ?*   :................................................................:

     P $today7         B                   Export
     D $today7         PI             7S 0
     D #today7         S              7S 0

     ?*  The $today function returns the seven numeric date in CYYMMDD format for today

      /Free
         #today7 = $date7($date(0));
         return #today7;
      /End-Free
     P   $today7       E

