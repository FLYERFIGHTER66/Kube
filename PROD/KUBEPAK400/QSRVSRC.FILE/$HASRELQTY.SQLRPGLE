    ?H/COPY QFunctDefn,@CopyRight
    ?H DatFmt(*usa)
    ?H NoMain
      *??:````````````````````````````````````````````````````````````:?
      *??:     Check Order for Release Quantity                       :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Dec. 2014            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program determins if the Order number              ?:
      *? : passed to it has a Released Quantity.                     ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? : Function   ?-Function Description                    ?  ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? : *IND  ?-Indicator Usage                              ?  ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? : Int   Date  ?-Change Description                     ?  ?:
      *? :  WJB 12/10/14  ?Program creation...                       ?:
      *? :  xxx __/__/__  ?xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx?:
      *? :............................................................:

      *? Function Prototypes
    ?D/Copy QFunctDefn,$hasRelQty

     ?*   ..................................................................
     ?*   :  $hasRelQty                                           function :
     ?*   :................................................................:

     P $hasRelQty      B                   Export
     D $hasRelQty      PI              N
     D  #Order                        6S 0 const

     D  Status         S               N   Inz(*Off)

    ? /Free

    ?   Exec SQL   Select  '1'
                   into    :Status
                   from    FIORDR
                   Where   OIORD# = :#Order
                     and   OISTAT = 'A'
                     and   OIITYP = ' '
                     and   OIRQTY > 0
                   FETCH FIRST ROW ONLY;
    ?
    ?     Return Status;
    ?
      /End-Free
     P   $hasRelQty    E
