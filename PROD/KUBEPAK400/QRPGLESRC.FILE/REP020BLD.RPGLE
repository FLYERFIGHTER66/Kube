    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      *??:````````````````````````````````````````````````````````````:?
      *??:     Populate the REP020PF file.                            :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Oct. 2007            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program replace two queries.  CUR600QRY and        ?:
      *? : CUR600QRYA.                                               ?:
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
      *? :  WJB 10/22/07  ?Initial Programming                       ?:
      *? :  ... ../../..  ?..........................................?:
      *? :............................................................:

     FFSOHSTCS  IP   E           K DISK

     FFCALEN    IF   E           K DISK    Rename(RCALEN:RCALEN6) Prefix(ORDR_)
     FFCALENCY  IF   E           K DISK    Rename(RCALEN:RCALEN7) Prefix(SHIP_)
     FFCALENWEEKIF   E           K DISK    Rename(RCALEN:WEEKREC) Prefix(Week_)

     FXATABLBROKIF   E           K DISK

     FFMCUST    IF   E           K DISK

     FREP020PF  UF A E           K DISK

     D  Week           S              2S 0
     D  Year           S              4S 0
     D  Date7          S              7S 0
     D  Date           S               D
     D  Valid_Record   S               N
     D  Account        S                   Like(SOBLCU)

     D  ShipDS         DS
     D  SHIP_CLCENT
     D  SHIP_CLYEAR
     D  SHIP_CLWEEK
     D   ShipWeek                     6S 0 Overlay(ShipDS)

     D  OrdrDS         DS
     D  ORDR_CLCENT
     D  ORDR_CLYEAR
     D  ORDR_CLWEEK
     D   OrdrWeek                     6S 0 Overlay(OrdrDS)

     D  WeekDS         DS
     D  WEEK_CLCENT
     D  WEEK_CLYEAR
     D  WEEK_CLWEEK
     D   Week_Year                    4S 0 Overlay(WeekDS)
     D   CurrWeek                     6S 0 Overlay(WeekDS)

     D/Copy QFunctDefn,$Year
     D/Copy QFunctDefn,$Date
     D/Copy QFunctDefn,$DateMDY
     D/Copy QFunctDefn,$Date7

      *?  ...........................................................
      *?  :    M A I N   C A L C U L A T I O N S                    :
      *?  :.........................................................:

     C                   ExSr      Validate
     C                   If        Valid_Record
     C                   ExSr      WhichAccount
     C                   ExSr      AddToHistory
     C                   EndIf

      *?  ...........................................................
      *?  :      VALIDATE - Check if Record is Valid for Inclusion  :
      *?  :.........................................................:

     C     VALIDATE      BegSR

      *?  The Order Date and Ship Date must be in range and in different weeks.
     C     SOSHDT        Chain     FCALENCY
     C     SOORDT        Chain     FCALEN
     C                   If        %Found(FCALENCY) and %Found(FCALEN)
     C                             and ((SHIP_CLCENT * 10000)
     C                               +  (SHIP_CLYEAR * 100)
     C                               +   SHIP_CLWEEK)
     C                              >  ((ORDR_CLCENT * 10000)
     C                               +  (ORDR_CLYEAR * 100)
     C                               +   ORDR_CLWEEK)
     C                   Eval      Valid_Record = *On
     C                   Else
     C                   Eval      Valid_Record = *Off
     C                   EndIf

      *?  The Product Class must be between '50' and '60'
     C     SOSHDT        Chain     FCALENCY
     C                   If             SOPCL1 < '10'
     C                             or   SOPCL1 >  '10'
     C                   Eval      Valid_Record = *Off
     C                   EndIf

     C                   EndSR

      *?  ...........................................................
      *?  :      WhichAccount - Which Account to Add To             :
      *?  :.........................................................:

     C     WhichAccount  BEGSR

     C     SOCUST        Chain     FMCUST
     C                   Eval      Account = CMBLCU
     C                   Eval      Account = 999999

     C                   EndSR

      *?  ...........................................................
      *?  :      AddToHistory - Add Sales to Order History          :
      *?  :.........................................................:

     C     AddToHistory  BEGSR

     C     Ordr_CLCYMD   SetLL     FCALENWEEK
     C                   Read      FCALENWEEK

     C                   DoW           Ship_CLCYMD > Week_CLCYMD

     C                   Clear                   REP020R
     C     REPKEY        Chain     REP020PF
     C                   Eval      R2QORD = R2QORD + SOQSHP
     C                   Eval      R2$ORD = R2$ORD + (SOQSHP * SOUPRI)
     C                   If        %Found(REP020PF)
     C                   Update    REP020R
     C                   Else
     C                   Eval      R2YEAR = Week_YEAR
     C                   Eval      R2WEEK = Week_CLWEEK
     C                   Eval      R2DATE = $DateMDY(Week_CLDATE)
     C                   Eval      R2ACCT = Account
     C                   Write     REP020R
     C                   EndIf

     C                   Read      FCALENWEEK
     C                   EndDo

     C                   EndSR

      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

     C     REPKEY        KList
     C                   KFld                    Week_YEAR
     C                   KFld                    Week_CLWEEK
     C                   KFld                    Account

     C                   EndSR
