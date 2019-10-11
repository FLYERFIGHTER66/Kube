     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DatFmt(*USA)
     H NoMain
      *??:````````````````````````````````````````````````````````````:?
      *??:                Check if a Printer is valid                 :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  May 2004             ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program verifies wether the provided Printer name  ?:
      *? : is valid on the system.                                   ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? : Subroutine ?-Subroutine Description                  ?  ?:
      *? :  $Command    -?Run System Command                         ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? : Function   ?-Function Description                    ?  ?:
      *? :  QCmdExc     -?Run an OS/400 command                      ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? : *IND  ?-Indicator Usage                              ?  ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     D   Cmd           S            100A   Dim(0001) CtData PerRcd(1)           ?Commands Array
     D                SDS
     D  SDSdata                1   5000A

      *
      *? Function Prototype(s)
     D/Copy QFunctDefn,$isPrinter
     D/Copy QFunctDefn,QCMDEXC

     ?*   ..................................................................
     ?*   :  $isPrinter                                           function :
     ?*   :................................................................:

     P  $isPrinter     B                        Export

     D  $isPrinter     PI              N
     D     #Printer                  10A        const

     D     Command     S            255A

     C                   Eval      Command = Cmd(1)
     C                   ExSr      $Command
     C                   Eval      *InLR = *On
     C                   return    *On

      *?  ..........................................................
      *?  :   *PSSR - Program Exception/Error Subroutine           :
      *?  :........................................................:
     C     *PSSR         BegSR
      *? If there is an error during the running of the command, the printer
      *? has a problem.  Either it doesn't exist or is allocated. return *FALSE

     C                   Eval      *InLR = *On
     C                   return    *Off

     C                   EndSR

      *?  ..........................................................
      *?  :   Run system command                                   :
      *?  :........................................................:
     C     $Command      BegSR
      *? Format the command String.  Put vaiable in place in the string.

      *?   |P?=Printer ID?    ?Put the Printer Name in the Override command?
     C                   DoW       %Scan('|P':Command) <> 0 and #Printer<>*Blanks
     C                   Eval      Command = %REPLACE
     C                             (%Trim(#Printer): Command :
     C                               %SCAN('|P': Command))
     C                   EndDo

      *?   ~ ?=Blank that needs to be removed??Replace with nothing?
     C                   DoW       %Scan('~':Command) <> 0
     C                   Eval      Command =
     C                               %SubSt(Command:1:%Scan('~':Command)-1)
     C                             + %SubSt(Command:%Scan('~':Command)+1:
     C                               %Len(Command) - %Scan('~':Command))
     C                   EndDo

      *? Execute the Command using QCMDEXC.
     C                   CALLP     qcmdexc(Command:%len(%Trim(Command)))

     C                   EndSR

     P  $isPrinter     E
**
VFYDEVPRT DEVICE(|P~~~~~~~~)
