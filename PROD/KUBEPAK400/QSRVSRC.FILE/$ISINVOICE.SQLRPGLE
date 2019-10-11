    ?H/COPY QFunctDefn,@CopyRight
    ?H DatFmt(*usa)
    ?H NoMain
      *??:````````````````````````````````````````````````````````````:?
      *??:     Determine if Invoice # is Valid                        :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Dec. 2014            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program determins if the Invoice #                 ?:
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
      *? :  WJB 12/18/14  ?Program creation...                       ?:
      *? :  xxx __/__/__  ?xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx?:
      *? :............................................................:

      *? Function Prototypes
    ?D/Copy QFunctDefn,$isInvoice

     ?*   ..................................................................
     ?*   :  $isInvoice                                           function :
     ?*   :................................................................:

     P $isInvoice      B                   Export
     D $isInvoice      PI              N
     D  #Invoice                      6S 0 const

     D  False          S               N   Inz(*Off)
     D  True           S               N   Inz(*On)
     D  Status         S              1A

    ? /Free
    ?   Exec SQL   Select  OHSTAT
                   into    :Status
                   from    FHORDR
                   Where   OHORD# = :#Invoice;
    ?
    ?   If  #Invoice = *Zero or Status <> 'A';
    ?     Return False;
    ?    Else;
          Return True;
        EndIf;
      /End-Free
     P   $isInvoice    E
