    ?H/COPY QFunctDefn,@CopyRight
    ?H DatFmt(*usa)
    ?H NoMain
      *??:````````````````````````````````````````````````````````````:?
      *??:     Determine if Customer# is Valid                        :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  2016                 ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program determins if the Object                    ?:
      *? : passed to it is a valid and return a true indicator       ?:
      *? : if it is.                                                 ?:
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
      *? :  WJB 09/16/14  ?Program creation...                       ?:
      *? :  xxx __/__/__  ?xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx?:
      *? :............................................................:

      *? Function Prototypes
    ?D/Copy QFunctDefn,$isIFSObj

     ?*   ..................................................................
     ?*   :  $isIFSObj                                            function :
     ?*   :................................................................:

     P $isIFSObj       B                   Export
     D $isIFSObj       PI              N
     D  #Object                     256A   const

    ?D #CHKIFSOBJ      PR                  ExtPgm('#CHKIFSOBJ')
     D  #Object                     256A   const
     D  #Status                        N

     D  Object         S            256A   Inz(*Blanks)
     D  Status         S               N

    ? /Free

        Object = #Object;
    ?   CallP #CHKIFSOBJ( Object : Status );
    ?   Return Status;

      /End-Free
     P   $isIFSObj     E
