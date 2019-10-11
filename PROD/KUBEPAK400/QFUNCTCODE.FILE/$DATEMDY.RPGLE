
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
