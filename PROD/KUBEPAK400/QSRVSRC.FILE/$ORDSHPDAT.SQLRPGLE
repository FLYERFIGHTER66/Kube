    ?H/COPY QFunctDefn,@CopyRight
    ?H DatFmt(*usa)
    ?H NoMain
      *??:````````````````````````````````````````````````````````````:?
      *??:     Return Order's Ship Date                               :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Nov. 2015            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program determins the Ship Date for an             ?:
      *? : order passed in.                                          ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? : Int   Date  ?-Change Description                     ?  ?:
      *? :  WJB 11/16/15  ?Program creation...                       ?:
      *? :  xxx __/__/__  ?xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx?:
      *? :............................................................:

      *? Function Prototypes
    ?D/Copy QFunctDefn,$OrdShpDat

     ?*   ..................................................................
     ?*   :  $OrdShpDat                                           function :
     ?*   :................................................................:

     P $OrdShpDat      B                   Export
     D $OrdShpDat      PI             6S 0
     D  #Order                        6S 0 const

     D  #ShipDate      S              6S 0

    ? /Free
    ?   Exec SQL   Select  OHDTCN
                   into    :#ShipDate
                   from    FHORDR
                   Where   OHORD# = :#Order ;
    ?
    ?     Return #ShipDate;
    ?
      /End-Free
     P $OrdShpDat      E
