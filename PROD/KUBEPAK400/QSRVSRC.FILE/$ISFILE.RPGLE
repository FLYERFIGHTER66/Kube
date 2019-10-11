     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DatFmt(*USA)
     H NoMain
      *??:````````````````````````````````````````````````````````````:?
      *??:                Check if a File exists                      :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  May 2004             ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program verifies the existence of given file.      ?:
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
     D/Copy QFunctDefn,$isFile
     D/Copy QFunctDefn,QCMDEXC

     ?*   ..................................................................
     ?*   :  $isFile                                              function :
     ?*   :................................................................:

     P  $isFile        B                        Export

     D  $isFile        PI              N
     D     #File                     10A        const

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

      *?   |F?=File Name?     ?Put the File Name in the command?
     C                   DoW       %Scan('|F':Command) <> 0
     C                   Eval      Command = %REPLACE
     C                             (%Trim(#File): Command :
     C                               %SCAN('|F': Command))
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

     P  $isFile        E
**
CHKOBJ OBJ(|F ~~~~~~~) OBJTYPE(*FILE)
