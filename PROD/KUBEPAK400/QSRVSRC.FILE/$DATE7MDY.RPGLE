     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

     ?*? Function Prototype(s)                                        *
      /Copy QFunctDefn,$date7iso


     ?*   ..................................................................
     ?*   :  $date7                                               function :
     ?*   :................................................................:


     P $date7MDY       B                   Export
     D $date7MDY       PI             7S 0
     D   Date                         6S 0 const

     ?*  The $date* function returns the seven numeric date in CYYMMDD format of the given date
     ?*  ie. you pass (01/15/2006) you get 1060115... you pass (02/01/2004) and get 1040201

     D  AlphaDate      DS            10
     D  Alpha                  1     10    INZ('0000-00-00')
     D   AlphaCCYY             1      4  0
     D   AlphaCC               1      2  0
     D   AlphaYY               3      4  0
     D   AlphaMM               6      7  0
     D   AlphaDD               9     10  0

     D   #Date7        S              7  0
     D   DateFld       S               D   DatFmt(*Iso)
      /Copy QFunctDefn,$dateMDY
     C                   Move      DateFld       AlphaDate
      /Free
         DateFld = $DateMDY(Date);
         AlphaDate = %char(DateFld);
         #Date7 =
         (AlphaCC - 19) * 1000000 +
          AlphaYY       * 10000 +
          AlphaMM       * 100 +
          AlphaDD       * 1;
         return #Date7;

      /End-Free
     P   $date7MDY     E

