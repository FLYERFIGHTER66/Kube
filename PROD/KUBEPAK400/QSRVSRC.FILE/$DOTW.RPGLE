     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN

      *? Function Prototype(s)
     D/Copy QFunctDefn,$dotw
     D/Copy QFunctDefn,$weekDay


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

