    ?H/COPY QFunctDefn,@CopyRight
    ?H DatFmt(*usa)
    ?H NoMain PGMINFO(*PCML:*MODULE) THREAD(*SERIALIZE)
      *??:````````````````````````````````````````````````````````````:?
      *??:     Determine if Email Address is Valid                    :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Dec. 2014            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program determins if the email address passed      ?:
      *? : to it is a valid and return a true indicator if it ?is.    :
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
      *? :  WJB 12/02/14  ?Program creation...                       ?:
      *? :  xxx __/__/__  ?xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx?:
      *? :............................................................:


     ?*   ..................................................................
     ?*   :  $isEmail                                             function :
     ?*   :................................................................:

     d $isEmail        pr
      *****************************************
     d  email_in                    256    const
     d  email_ok                      1
      *****************************************
     p $isEmail        b                   export
      *****************************************
     d  $isEmail       pi
     d  email_in                    256    const
     d  email_ok                      1
      *****************************************
     D  False          S               N   Inz(*Off)
     D  True           S               N   Inz(*On)
     D  EML            S            256A
     D  LastDot        S              3S 0
     D  Valid          S             83A   Inz('ABCDEFGHIJKLMNOPQRSTUVWXYZ+
     D                                     abcdefghijklmnopqrstuvwxyz1234567890+
     D                                     .!#$%&*+-/=?^_-{|}~@ ')
      /Free

        EML = email_in;

        LastDot = 0;
        If %Scan('.':EML:2) > 0;
          LastDot = 1;
          DoU (%Scan('.':EML:LastDot+1) = 0);
            LastDot = %Scan('.':EML:LastDot+1);
          EndDo;
        EndIf;

        *InLR = *On;

        If %Check(Valid:%Trim(EML)) = 0;                                // Check all valid Char
         If %Scan('.':EML) > 0;                                        // Check that . exists
          If %Scan('@':EML) > 0;                                      // Check that @ exists
           If LastDot > %Scan('@':EML);                              // Check that . follows @
            If %Scan(' ':EML) > 5;                                  // Check no leading blanks
             If %Scan(' ':EML) > %Len(%Trim(EML));                 // Check no embedded blanks
              If %Len(%Trim(EML)) > LastDot;                      // Check that . not last char
               If %Scan('@':EML) > 1;                            // Check that @ not first char
                If %Scan('@':EML:%Scan('@':EML)+1) = 0;         // Check that first @ is last @
                 If %Scan('..':EML) = 0;                       // Check no ..
                  Return True;
                 EndIf;
                EndIf;
               EndIf;
              EndIf;
             EndIf;
            EndIf;
           EndIf;
          EndIf;
         EndIf;
        EndIf;
        Return False;

      /End-Free
     P   $isEmail      E
