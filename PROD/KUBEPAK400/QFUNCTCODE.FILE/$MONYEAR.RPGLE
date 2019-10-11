
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

