    ?H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H DATFMT(*USA)
    ?H NOMAIN

     FFDLOTRD   UF   E           K DISK    UsrOpn

      *? Function Prototype(s)
     D/Copy QFunctDefn,$Allocate
     D/Copy QFunctDefn,$User

     ?*   ..................................................................
     ?*   :  $Allocate                                            function :
     ?*   :................................................................:

     P  $Allocate      B                        Export

     D  $Allocate      PI
     D     #Item                     12A        const                           ?Item to Allocate
     D     #Size                      3A        const                           ?Item Size
     D     #Qty                       7S 0      const                           ?Quantity Allocated
     D     #Type                      1A        const                           ?Type of Allocation

      *? The $Allocate function updates the Inventory (FDLOTRD) file for the specified
      *? product.  If it's an Order being processed, the Available is adjusted.  If an
      *? it's a ship confirm, the on-hand amount is adjusted.

    ?C                   Open      FDLOTRD

     C     ItemKey       KList
     C                   KFld                    #Item
     C                   KFld                    #Size

    ?C     ItemKey       Chain     FDLOTRD

     C                   If        %Found(FDLOTRD)

     C                   Select

     C                   When      #Type  = 'O'                                 ?Order
     C                   Eval      LRQTAV  = LRQTAV - #Qty                      ?Adj. Available
     C                   Eval      LRQTAL  = LRQTAL + #Qty                      ?Adj. Allocated

     C                   When      #Type  = 'C'                                 ?Cancel Order
     C                   Eval      LRQTAV  = LRQTAV + #Qty                      ?Adj. Available
     C                   Eval      LRQTAL  = LRQTAL - #Qty                      ?Adj. Allocated

     C                   When      #Type  = 'S'                                 ?Ship confirm
     C                   Eval      LRQTOH  = LRQTOH - #Qty                      ?Adj. On-hand

     C                   When      #Type  = 'U'                                 ?un-confirm Ship
     C                   Eval      LRQTOH  = LRQTOH + #Qty                      ?Adj. On-hand

     C                   When      #Type  = 'R'                                 ?Return OK
     C                   Eval      LRQTAV  = LRQTAV + #Qty                      ?Adj. Available
     C                   Eval      LRQTOH  = LRQTOH + #Qty                      ?Adj. On-hand

     C                   When      #Type  = 'D'                                 ?Dumped
     C                   Eval      LRQTAV  = LRQTAV - #Qty                      ?Adj. Available
     C                   Eval      LRQTOH  = LRQTOH - #Qty                      ?Adj. On-hand

     C                   EndSL

     C                   Eval      LRDTLA = UDATE
     C                   Time                    LRTIME
     C                   Eval      LRUSER = $User()

     C                   Update    RDLOTRD
     C                   EndIf
     C                   Close     FDLOTRD

     P  $Allocate      E
