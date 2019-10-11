    ?H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H DATFMT(*USA)
    ?H NOMAIN

     FFCALEN    IF   E           K DISK    UsrOpn

      *? Function Prototype(s)
    ?D/Copy QFunctDefn,$Week#
    ?D/Copy QFunctDefn,$MDYDate

     ?*   ..................................................................
     ?*   :  $Week#                                               function :
     ?*   :................................................................:

    ?P  $Week#         B                        Export

    ?D  $Week#         PI             2S 0
    ?D     #Date                       D        const                           ?Date

    ?D     MDYDate     S              6S 0                                      ?Date
    ?D     WasOpened   S               N   Inz(*Off)                            ?Was File Opened ?

      *? The $Week# function returns the calendar week number for the date given.

     C                   If        not %Open(FCALEN)
    ?C                   Open      FCALEN
     C                   Eval      WasOpened = *On
     C                   EndIf

     C                   Eval      MDYDate = $MDYDate(#Date)

    ?C     MDYDate       Chain     FCALEN

     C                   If        %Found(FCALEN)
    ?C                   Return    CLWEEK
     C                   Else
    ?C                   Return    *Zero
     C                   EndIf

     C                   If        WasOpened
     C                   Close     FCALEN
     C                   EndIf

    ?P  $Week#         E
