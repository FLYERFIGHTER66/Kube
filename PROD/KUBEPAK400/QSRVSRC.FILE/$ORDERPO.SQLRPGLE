    ?H/COPY QFunctDefn,@CopyRight
    ?H DatFmt(*usa)
    ?H NoMain
      *??:````````````````````````````````````````````````````````````:?
      *??:     Return P.O. Number for Order                           :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Oct. 2014            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? : Int   Date  ?-Change Description                     ?  ?:
      *? :  WJB 10/16/14  ?Program creation...                       ?:
      *? :  xxx __/__/__  ?xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx?:
      *? :............................................................:

      *? Function Prototypes
    ?D/Copy QFunctDefn,$OrderPO

     ?*   ..................................................................
     ?*   :  $isCust                                              function :
     ?*   :................................................................:

     P $OrderPO        B                   Export
     D $OrderPO        PI            15A
     D  #Order                        6S 0 const

     D  #PONumber      S             15A

    ? /Free
    ?   Exec SQL   Select  OHPONO
                   into    :#PONumber
                   from    FHORDR
                   Where   OHORD# = :#Order ;
    ?
    ?     Return #PONumber;
    ?
      /End-Free
     P $OrderPO        E
