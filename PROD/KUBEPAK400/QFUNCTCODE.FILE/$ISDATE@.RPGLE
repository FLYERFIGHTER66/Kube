
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

