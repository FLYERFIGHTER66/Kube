    ?H/COPY QFunctDefn,@CopyRight
    ?H DatFmt(*usa)
    ?H NoMain
      *??:````````````````````````````````````````````````````````````:?
      *??:     Determine if Customer# is Valid                        :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Sep. 2014            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program determins if the Customer #                ?:
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
    ?D/Copy QFunctDefn,$isCust

     ?*   ..................................................................
     ?*   :  $isCust                                              function :
     ?*   :................................................................:

     P $isCust         B                   Export
     D $isCust         PI              N
     D  #Cust                         6S 0 const

     D  False          S               N   Inz(*Off)
     D  True           S               N   Inz(*On)
     D  Status         S              1A

    ? /Free
    ?   Exec SQL   Select  CMSTAT
                   into    :Status
                   from    FMCUST
                   Where   CMCUST = :#Cust ;
    ?
    ?   If  #Cust  = *Zero or Status <> 'A';
    ?     Return False;
    ?    Else;
          Return True;
        EndIf;
      /End-Free
     P   $isCust       E
