     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:        Return default Printer to non-ILE Program           :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Jan 2005             ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :  This program is used to select the Default Printer for   ?:
      *? :  the current program.                                     ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? :  *none    -?no subroutines defined                        ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  $DftPrt ?Retrieve Default Printer                        ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

      *? Function Prototype(s)
    ?D/COPY QFunctDefn,$DftPrt


     C     *Entry        PList
     C                   Parm                    #User            10
     C                   Parm                    #Pgm             10
     C                   Parm                    #Printer         10

      *? First see if calling program requested a specific lookup type
     C                   If        %SUBST(#Printer:1:1) = '*'
     C                   Eval      #Printer = $DftPrt(#User:#Pgm:#Printer)
     C                   EndIf

      *? If the request specified didn't get a printer use this...
     C                   If        #Printer = *Blank

      *?   First we'll try to use the last printer used
     C                   Eval      #Printer = $DftPrt(#User:#Pgm:'*LAST')

      *?   Next we'll try to use the User Default Printer
     C                   If        #Printer = *Blank
     C                   Eval      #Printer = $DftPrt(#User:#Pgm:'*USER')

      *?   Then we'll see if there is a Program Default Printer
     C                   If        #Printer = *Blank
     C                   Eval      #Printer = $DftPrt(#User:#Pgm:'*PGM')

      *?   If no Default Printers are found at all then ask the user which one to use.
     C                   If        #Printer = *Blank
     C                   Call      '#CHGPRT'     #ChgPrt
     C                   EndIf

     C                   EndIf
     C                   EndIf
     C                   EndIf

     C                   Eval      *InLR = *On

     C     #ChgPrt       PList
     C                   Parm                    #User
     C                   Parm                    #Pgm
     C                   Parm                    #Printer
