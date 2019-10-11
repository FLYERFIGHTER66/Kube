
     ?*   ..................................................................
     ?*   :  $date                                                function :
     ?*   :................................................................:

     P $date           B                   Export
     D $date           PI              D
     D   Date                         8S 0 const

?    ?*  The $date function returns a date field value for a given date passed in to this
?    ?*  function in an eight digit numeric field in CCYYMMDD format.
?    ?*  ie. you pass 20060115 and get (01/15/2006)

     D  wkDate         S               D   datfmt(*USA)
     D dftDate         S               D   datfmt(*USA) inz(D'01/01/0001')

     D  DateDS         DS
     D  DateWk                 1      8  0 INZ(0)
     D        CC               1      2  0
     D        YY               2      4  0

     C                   Z-add     Date          DateWk
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
