     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

     FFMINVT    IF   E           K DISK    UsrOpn
     FFMCUST    IF   E           K DISK    UsrOpn

      *? Function Prototype(s)
     D/Copy QFunctDefn,$UnitPrice

     ?*   ..................................................................
     ?*   :  $UnitPrice                                           function :
     ?*   :................................................................:

     P  $UnitPrice     B                        Export

     D  $UnitPrice     PI             9S 4
     D     #Item                     12A        const
     D     #Size                      3A        const
     D     #Customer                  6S 0      const

?    ?*  The $UnitPrice function gets the unit price of an Item based on the customer to
?    ?*  whom the item is to be sold.
?
?    ?*  NOTE - at some time in the future it would be nice for this routine to handle
?    ?*         quantity discounts and variable UOM prices as well

     D     #Price      S              9S 4

     C                   Open      FMINVT
     C                   Open      FMCUST

     C     ItemKey       KList
     C                   KFld                    #Item
     C                   KFld                    #Size

     C     #Customer     Chain     FMCUST
     C     ItemKey       Chain     FMINVT

     C                   Select
     C                   When      CMPRCD = 1
     C                             or not %Found(FMCUST)
     C                   Eval      #Price  = IMSEL1

     C                   When      CMPRCD = 2
     C                   Eval      #Price  = IMSEL2

     C                   When      CMPRCD = 3
     C                   Eval      #Price  = IMSEL3

     C                   When      CMPRCD = 4
     C                   Eval      #Price  = IMSEL4

     C                   When      CMPRCD = 5
     C                   Eval      #Price  = IMSEL5

     C                   EndSL

     C                   Close     FMINVT
     C                   Close     FMCUST
     C                   return     #Price

     P  $UnitPrice     E
