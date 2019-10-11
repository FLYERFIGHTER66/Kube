     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DATFMT(*USA)
     H NOMAIN
      *??:````````````````````````````````````````````````````````````:?
      *??:     Determine if we need directions for Customer           :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Feb. 2009            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program determins if the CUST Number               ?:
      *? :  passed to it needs directions on the Customer Master.     :
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
      *? :  WJB 02/09/09  ?Program creation...                       ?:
      *? :  xxx __/__/__  ?xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx?:
      *? :............................................................:

     FFCMDIR    IF   E           K DISK    UsrOpn


      *? Function Prototype(s)
     D/Copy QFunctDefn,$NeedDir


     ?*   ..................................................................
     ?*   :  $NeedDir                                             function :
     ?*   :................................................................:

     P $NeedDir        B                   Export
     D $NeedDir        PI              N
     D   #Cust                        6S 0 Const

?    ?*  The $NeedDir routine returns true we need directions for given Customer
    ?C                   Open      FCMDIR
     C                   Eval      CMDR01 = *Blanks                             ?DIRECTION LINE 01
    ?C     #Cust         Chain     FCMDIR
    ?C                   Close     FCMDIR
     C                   If        CMDR01 = *Blanks                             ?DIRECTION LINE 01
     C                   Return    *On                                          ?TRUE! Need Dir.
     C                   Else                                                   ?
     C                   Return    *Off                                         ?FALSE! We have Dir.
     C                   EndIf                                                  ?

     P   $NeedDir      E

