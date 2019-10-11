    ?H/COPY QFunctDefn,@CopyRight
    ?H DatFmt(*usa)
    ?H NoMain
      *??:````````````````````````````````````````````````````````````:?
      *??:     Return Order's Ship to Customer                        :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Oct. 2014            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program determins the Ship to Customer # for an    ?:
      *? : order passed in.                                          ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? : Int   Date  ?-Change Description                     ?  ?:
      *? :  WJB 10/15/14  ?Program creation...                       ?:
      *? :  xxx __/__/__  ?xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx?:
      *? :............................................................:

      *? Function Prototypes
    ?D/Copy QFunctDefn,$OrderShp2

     ?*   ..................................................................
     ?*   :  $isCust                                              function :
     ?*   :................................................................:

     P $OrderShp2      B                   Export
     D $OrderShp2      PI             6S 0
     D  #Order                        6S 0 const

     D  #ShipCust      S              6S 0

    ? /Free
    ?   Exec SQL   Select  OHCUST
                   into    :#ShipCust
                   from    FHORDR
                   Where   OHORD# = :#Order ;
    ?
    ?     Return #ShipCust;
    ?
      /End-Free
     P $OrderShp2      E
