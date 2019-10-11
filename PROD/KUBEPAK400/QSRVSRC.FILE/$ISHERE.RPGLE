    ?H/COPY QFunctDefn,@CopyRight
    ?H DatFmt(*usa)
    ?H NoMain
      *??:````````````````````````````````````````````````````````````:?
      *??:     Determine if Person Clocked in to given job.           :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Dec. 2007            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program determins if the Timecard number provided  ?:
      *? : is clocked in to the Job Function provided.               ?:
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
      *? :  WJB 10/28/05  ?Program creation...                       ?:
      *? :  xxx __/__/__  ?xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx?:
      *? :............................................................:

     FFMATTEND  IF   E           K DISK    UsrOpn

      *? Function Prototypes
    ?D/Copy QFunctDefn,$isHere

     ?*   ..................................................................
     ?*   :  $isHere                                              function :
     ?*   :................................................................:

     P $isHere         B                   Export

     D $isHere         PI              N
     D  TimeCard                      8S 0 const
     D  JobCode                       1A   const

     D  Date           S               D
     D  Time           S               T

     D  ClockedIn      S               N

     C                   Call      '#EMPFILE#'
     C                   Parm      TimeCard      TimeCard#         9 0
     C                   Parm                    File#             6 0
     C                   Parm                    name             25

     C                   Time                    Date
     C                   Time                    Time

    ?C                   Open      FMATTEND
    ?C     ClockKey      SetGT     FMATTEND
    ?C     ClockKey      ReadPE    FMATTEND

     C                   If        not %EOF(FMATTEND)
     C                             and ATTYPE = JobCode
     C                             and ATSTRT = ATENDT
     C                   Eval      ClockedIn = *On
     C                   Else
     C                   Eval      ClockedIn = *Off
     C                   EndIf
    ?C                   Close     FMATTEND
     C                   Return    ClockedIn

    ?C     ClockKey      KList                                                  ?
    ?C                   KFld                    Date
    ?C                   KFld                    File#

     P   $isHere       E
