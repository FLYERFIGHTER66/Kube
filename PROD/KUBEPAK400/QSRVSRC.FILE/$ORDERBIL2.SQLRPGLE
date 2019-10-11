    ?H/COPY QFunctDefn,@CopyRight
    ?H DatFmt(*usa)
    ?H NoMain
      *??:````````````````````````````````````````````````````````````:?
      *??:     Return Order's Bill to Customer                        :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Oct. 2014            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program determins the Bill to Customer # for an    ?:
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
    ?D/Copy QFunctDefn,$OrderBil2

     ?*   ..................................................................
     ?*   :  $isCust                                              function :
     ?*   :................................................................:

     P $OrderBil2      B                   Export
     D $OrderBil2      PI             6S 0
     D  #Order                        6S 0 const

     D  #BillCust      S              6S 0

    ? /Free
    ?   Exec SQL   Select  OHBLCU
                   into    :#BillCust
                   from    FHORDR
                   Where   OHORD# = :#Order ;
    ?
    ?     Return #BillCust;
    ?
      /End-Free
     P $OrderBil2      E
