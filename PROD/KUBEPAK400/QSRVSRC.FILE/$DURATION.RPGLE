     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

      *? Function Prototype(s)
     D/Copy QFunctDefn,$Duration


     ?*   ..................................................................
     ?*   :  $Duration                                            function :
     ?*   :................................................................:

     P $Duration       B                   Export
     D $Duration       PI             5S 0
     D   DateStart                     D   DatFmt(*usa) const
     D   DateEnd                       D   DatFmt(*usa) const
     D   DurExpr                      1A   const

?    ?*  The $Duration function returns the duration between two dates, expressed in either
?    ?*  Years, Months, or Days as specified in the DurExpr field.
?    ?*  ie. you pass 01/15/2004, 01/20/2004, D and you get 5 days
?    ?*      you pass 01/20/2004, 01/15/2004, D and you get -5 days
?    ?*      you pass 01/15/2004, 01/15/2005, Y and you get 1 year
?    ?*      you pass 01/15/2005, 01/15/2004, Y and you get -1 year
?    ?*      you pass 01/15/2004, 02/15/2005, M and you get 13 months
?    ?*      you pass 02/15/2005, 01/15/2004, M and you get -13 months

     D   wkDateS       S               D   DatFmt(*USA)
     D   wkDateE       S               D   DatFmt(*USA)
     D   Days          S              5S 0 Inz(*Zeros)
     D   Months        S              5S 0 Inz(*Zeros)
     D   Years         S              5S 0 Inz(*Zeros)

     C                   Eval      wkDateS = DateStart
     C                   Eval      wkDateE = DateEnd
     C     wkDateS       SubDur    wkDateE       Years:*Y
     C     wkDateS       SubDur    wkDateE       Months:*M
     C     wkDateS       SubDur    wkDateE       Days:*D

     C                   Select
     C                   When      DurExpr = 'D'
     C                   return    -Days
     C                   When      DurExpr = 'M'
     C                   return    -Months
     C                   When      DurExpr = 'Y'
     C                   return    -Years
     C                   Other
     C                   return    99999
     C                   EndSL

     P   $Duration     E
