
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
