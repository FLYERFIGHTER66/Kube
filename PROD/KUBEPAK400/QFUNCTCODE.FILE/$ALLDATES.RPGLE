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





     ?*   ..................................................................
     ?*   :  $dotw                                                function :
     ?*   :................................................................:


     P $dotw           B                   Export
     D $dotw           PI             9A
     D   Date                          D   const

?    ?*  The dotw routine returns the day of the Week for the Date passed

     D  #dotwDS        DS
     D   Sunday                       9A   INZ('Sunday   ')
     D   Monday                       9A   INZ('Monday   ')
     D   Tuesday                      9A   INZ('Tuesday  ')
     D   Wednesday                    9A   INZ('Wednesday')
     D   Thursday                     9A   INZ('Thursday ')
     D   Friday                       9A   INZ('Friday   ')
     D   Saturday                     9A   INZ('Saturday ')
     D     dotw                       9A   DIM(7) OverLay(#dotwDS)

     C                   return    dotw($weekDay(Date:'SUN'))

     P $dotw           E




     ?*   ..................................................................
     ?*   :  $monYear                                             function :
     ?*   :................................................................:


     P $monYear        B                   Export
     D $monYear        PI            15A
     D   Date                          D   const

?    ?*  The $monYear function return the character description of a month/year ie. September,

     D  Months         DS
     D   January                      9A   INZ('January  ')
     D   February                     9A   INZ('February ')
     D   March                        9A   INZ('March    ')
     D   April                        9A   INZ('April    ')
     D   May                          9A   INZ('May      ')
     D   June                         9A   INZ('June     ')
     D   July                         9A   INZ('July     ')
     D   August                       9A   INZ('August   ')
     D   September                    9A   INZ('September')
     D   October                      9A   INZ('October  ')
     D   November                     9A   INZ('November ')
     D   December                     9A   INZ('December ')
     D  Month                         9A   DIM(12) Overlay(Months)

     C                   Return    %Trim( Month( $month( Date ) ) )
     C                             + ', ' + %Char( $year( Date ) )

     P $monYear        E




     ?*   ..................................................................
     ?*   :  $year                                                function :
     ?*   :................................................................:

     P $year           B                   Export
     D $year           PI             4S 0
     D   Date                          D   const

?    ?*  The $year routine returns the year portion of a given date in a date data type field

     D                 DS             8
     D   yearDate              1      8  0
     D   yyyy                  1      4  0

     C                   Eval      yearDate = $date8(Date)
     C                   return    yyyy

     P   $year         E





     ?*   ..................................................................
     ?*   :  $month                                               function :
     ?*   :................................................................:

     P $month          B                   Export
     D $month          PI             2S 0
     D   Date                          D   const

?    ?*  The $month routine returns the month portion of a given date in a date data type field

     D                 DS
     D   monthDate             1      8  0
     D   mm                    5      6  0

     C                   Eval      monthDate = $date8(Date)
     C                   return    mm

     P   $month        E





     ?*   ..................................................................
     ?*   :  $day                                                 function :
     ?*   :................................................................:


     P $day            B                   Export
     D $day            PI             2S 0
     D   Date                          D   const

?    ?*  The $day routine returns the day portion of a given date in a date data type field

     D                 DS
     D   dayDate               1      8  0
     D   dd                    7      8  0

     C                   Eval      dayDate = $date8(Date)
     C                   return    dd

     P   $day          E





     ?*   ..................................................................
     ?*   :  $lastDay                                             function :
     ?*   :................................................................:


     P $lastDay        B                   Export
     D $lastDay        PI              D
     D   Date                          D   const datfmt(*ISO)

?    ?*  The $lastDay routine returns the last day of the month for the month of the given date
?    ?*  ie. you pass 01/15/2006 you get 01/31/2006... you pass 02/01/2004 and get 02/29/2004

     D   wkDate        S               D   datfmt(*ISO)

     D                 DS
     D   dayDate               1      8  0
     D   dd                    7      8  0

     C                   Eval      dayDate = $date8(Date)
     C                   Eval      dd = 01
     C                   Move      dayDate       wkDate
     C     wkDate        AddDur    1:*M          wkDate
     C     wkDate        SubDur    1:*D          wkDate
     C                   return    wkDate

     P   $lastDay      E





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
     ?*   :  $date                                                function :
     ?*   :................................................................:


     P $date           B                   Export
     D $date           PI              D
     D   Date                         8S 0 const

  ?   *  The $date function returns a date field value for a given date passed in to this
?    ?*  function in an eight digit numeric field in CCYYMMDD format.
?    ?*  ie. you pass 20060115 and get (01/15/2006)

     D  wkDate         S               D   datfmt(*USA)
     D dftDate         S               D   datfmt(*USA) inz(D'01/01/0001')

     C                   IF        $isDate#(Date:'*ISO')
     C     *ISO          Move      Date          wkDate
     C                   return    wkDate
     C                   else
     C                   return    dftDate
     C                   EndIF

     P   $date         E





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
