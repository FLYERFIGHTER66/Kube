    ?H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H DATFMT(*USA)
    ?H NOMAIN

     FFCALEN    IF   E           K DISK    UsrOpn

      *? Function Prototype(s)
    ?D/Copy QFunctDefn,$IsoYear
    ?D/Copy QFunctDefn,$MDYDate

     ?*   ..................................................................
     ?*   :  $IsoYear                                             function :
     ?*   :................................................................:

    ?P  $IsoYear       B                        Export

    ?D  $IsoYear       PI             4S 0
    ?D     #Date                       D        const                           ?Date

    ?D     MDYDate     S              6S 0                                      ?Date
    ?D     WasOpened   S               N   Inz(*Off)                            ?Was File Opened ?

      *? The $IsoYear  function returns the calendar week number for the date given.

     C                   If        not %Open(FCALEN)
    ?C                   Open      FCALEN
     C                   Eval      WasOpened = *On
     C                   EndIf

     C                   Eval      MDYDate = $MDYDate(#Date)

    ?C     MDYDate       Chain     FCALEN

     C                   If        %Found(FCALEN)
    ?C                   Return    (CLCENT * 100) + CLYEAR
     C                   Else
    ?C                   Return    *Zero
     C                   EndIf

     C                   If        WasOpened
     C                   Close     FCALEN
     C                   EndIf

    ?P  $IsoYear       E
