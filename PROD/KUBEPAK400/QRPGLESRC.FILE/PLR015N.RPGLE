    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *??:````````````````````````````````````````````````````````````:?
      *??:     Process Physical Inventory Upload                      :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Aug. 2005            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program provides the ability to update seed        ?:
      *? : inventory based on an uploaded seed physical inventory.   ?:
      *? : The physical inventory is uploaded in file FPYHINV and    ?:
      *? : is procesed by this program.  The seed inventory on file  ?:
      *? : FMINVT is adjusted based on the Physical inventory and    ?:
      *? : adjusted based on the sowing done since the date of the   ?:
      *? : inventory.                                                ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? : Subroutine ?-Subroutine Description                  ?  ?:
      *? :  *INZSR      -?Initialization Subroutine                  ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? : Function   ?-Function Description                    ?  ?:
      *? :  $Date        ?Get Date Value                             ?:
      *? :  $DateMDY     ?Get Date Number in MM/DD/YY                ?:
      *? :  $Monday      ?Get Monday Date Value                      ?:
      *? :  $AddDate     ?Add/Subtract Days from Date                ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? : *IND  ?-Indicator Usage                              ?  ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
     FFCALENCY  UF A E           K DISK

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$WeekDay
    ?D/COPY QFunctDefn,$Day
    ?D/COPY QFunctDefn,$Month
    ?D/COPY QFunctDefn,$Year
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date7

      *? Field Definitions
     D  LastDate       S               D                                        ?
     D  LastDOTW       S              1S 0                                      ?
     D  ThisDate       S               D                                        ?
     D  NewYear        S               N   Inz(*Off)                            ?New Year Indicator

      *? Determine where to start.
    ?C     *HiVal        SetGt     FCALENCY
    ?C                   ReadP     FCALENCY
     C                   Eval      LastDate = $Date(CLCYMD)
     C                   Eval      LastDOTW = $WeekDay(LastDate:'MON')

      *? Build the calendar file through and including December 31st.  (ie. Add 1 Year)
     C                   DoU       $Day(LastDate) = 31 and $Month(LastDate) = 12

      *? Get the next date on the calendar  (Previous Date + 1)
     C                   Eval      ThisDate = $AddDate(LastDate:1)

      *? If we are near the end of the year, check that we have not started a new year
      *?    ( The new year could occur before, after, or on Jan. 1st)
     C                   If        CLWEEK > 50 and LastDOTW = 7
     C                   ExSr      Check4NewYear
     C                   EndIf

      *? Load the Calendar fields
     C                   Eval      CLSTAT  = 'A'
     C                   Eval      CLDATE  = $MDYDate(ThisDate)
     C                   If        LastDOTW = 7
     C                   Eval      CLWEEK  =  CLWEEK + 1
      *?                 Only Chnage the Year and Century During a Week Change
     C                   Eval      CLCENT  =
     C                             %Int(%Subst(%Char($Year(ThisDate)):1:2))
     C                   If        NewYear
     C                   Eval      CLYEAR  = CLYEAR + 1
     C                   Eval      NewYear = *Off
     C                   Else
     C                   Eval      CLYEAR  =
     C                             %Int(%Subst(%Char($Year(ThisDate)):3:2))
     C                   EndIf
     C                   Else
     C                   Eval      CLWEEK  =  CLWEEK
     C                   EndIf
     C                   Eval      CL#Y    =  $WeekDay(ThisDate:'MON')
     C                   Eval      CLCYMD  =  $Date7(ThisDate)

      *? Load the Calendar fields
    ?C                   Write     RCALEN
     C                   Eval      LastDate = $Date(CLCYMD)
     C                   Eval      LastDOTW = $WeekDay(LastDate:'MON')

     C                   EndDo

     C                   Eval      *InLR = *On

      *?  ...........................................................
      *?  :      Check4NewYear - Check to see if we start new year  :
      *?  :.........................................................:

    ?C     Check4NewYear BEGSR

      *? If the Thursday of this week is in this Jan then it's a new year.
      *?    This should comply with ISO date standards... for more info, visit
      *?    http://en.wikipedia.org/wiki/ISO_week_date
     C                   If        $Month($AddDate(ThisDate:3)) = 1
     C                   Eval      CLWEEK = *Zero
     C                   Eval      NewYear = *On
     C                   EndIf

    ?C                   EndSR

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

    ?C     *INZSR        BEGSR


    ?C                   EndSR
