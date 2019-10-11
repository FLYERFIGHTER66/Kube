    ?H/COPY QFunctDefn,@CopyRight
    ?H DatFmt(*usa)
    ?H NoMain
      *??:````````````````````````````````````````````````````````````:?
      *??:     Return P.O. Number for Invoice                         :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Dec. 2014            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? : Int   Date  ?-Change Description                     ?  ?:
      *? :  WJB 12/18/14  ?Program creation...                       ?:
      *? :  xxx __/__/__  ?xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx?:
      *? :............................................................:

      *? Function Prototypes
    ?D/Copy QFunctDefn,$InvoicePO

     ?*   ..................................................................
     ?*   :  $InvoicePO                                           function :
     ?*   :................................................................:

     P $InvoicePO      B                   Export
     D $InvoicePO      PI            15A
     D  #Invoice                      6S 0 const

     D  #PONumber      S             15A   Inz(*Blanks)

    ? /Free
    ?   Exec SQL   Select  WHPONO
                   into    :#PONumber
                   from    FHORDW
                   Where   WHINV# = :#Invoice ;
    ?
    ?     Return #PONumber;
    ?
      /End-Free
     P $InvoicePO      E
