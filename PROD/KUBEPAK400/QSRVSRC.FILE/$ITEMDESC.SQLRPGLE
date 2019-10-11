    ?H/COPY QFunctDefn,@CopyRight
    ?H DatFmt(*usa)
    ?H NoMain
      *??:````````````````````````````````````````````````````````````:?
      *??:     Retrieve Item Description                              :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Feb. 2015            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program gets item description                      ?:
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
      *? :  WJB 02/03/15  ?Program creation...                       ?:
      *? :  xxx __/__/__  ?xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx?:
      *? :............................................................:

      *? Function Prototypes
    ?D/Copy QFunctDefn,$ItemDesc

     ?*   ..................................................................
     ?*   :  $isItem                                              function :
     ?*   :................................................................:

     P $ItemDesc       B                   Export
     D $ItemDesc       PI            30A
     D  #Item                        12A   const
     D  #Size                         3A   const
     D  #Desc          S             30A
      /Free

         #Desc = 'Item Not Found';

         Exec SQL
           Select   IMDES1
           into    :#Desc
           from     FMINVT
           where    IMITEM = :#Item
             and    IMSIZE = :#Size;

         Return #Desc;

      /End-Free

     P   $ItemDesc     E
