     H DFTACTGRP(*NO)
     H DATFMT(*USA)

     FTRR553FM  CF   E             WORKSTN
     F                                     SFILE(TRR55301:RRN01)
     F                                     SFILE(TRR55302:RRN02)
     F                                     DEVID(WSID)
     FFTRSCHDS  IF   E           K DISK
     FFTRSCHDC  IF   E           K DISK    RENAME(RTRSCHD:RCUST)
     FFMCUST    IF   E           K DISK
     FFOECTL    IF   E           K DISK

     D                SDS
     D  ##PGM            *PROC

     D CustOrders      S            127    Dim(750) Ascend
     D CustDS          DS                  Inz
     D   TRORD#
     D   CMCITY
     D   CMLOOK
     D   CMNAME
     D   CMCUST
     D   CMSTST
     D   CMZIP
     D   CMADD2
     D   TRTRK#
     D   TRSHDT

     D Count           S              3  0 Inz(0)
     D Count2          S              3  0 Inz(0)
     D HoldORDER       S              6S 0
     D DateFld         S               D   DatFmt(*usa)
     D F8              S              7S 0
     D F9              S              7S 0
     D MinusWeek       S              5S 0 Inz(-7)
     D PlusWeek        S              5S 0 Inz( 7)
     D BegDate         S              7S 0                                      Week Beggining Date
     D EndDate         S              7S 0                                      Week Ending Date
     D HDR1            S                   Like(OCHDG1)
     D HDR2            S                   Like(OCHDG2)
     D HDR3            S                   Like(OCHDG3)
     D HDR4            S                   Like(OCHDG4)
     D HDR5            S                   Like(OCHDG5)
     D HDR6            S                   Like(OCHDG6)

     D/Copy QFunctDefn,$Date
     D/Copy QFunctDefn,$Date6
     D/Copy QFunctDefn,$Date7
     D/Copy QFunctDefn,$DateMDY
     D/Copy QFunctDefn,$IsDate#

     C     *INLR         DOUEQ     *ON

     C                   SELECT
     C     SCREEN        WHENEQ    01
     C                   EXSR      EDIT01
     C     SCREEN        WHENEQ    02
     C                   EXSR      EDIT02
     C                   ENDSL

     C                   ENDDO

      *   ...........................................................
      *   :      LOAD01 - LOAD SCREEN 01                            :
      *   :.........................................................:
     C     LOAD01        BEGSR

     C                   Eval      HoldORDER = SMORDER
     C                   Eval      DateFld = $DateMDY(MonDate)
     C                   SubDur    2:*Days       DateFld
     C                   Eval      BegDate = $Date7(DateFld)
     C                   AddDur    6:*Days       DateFld
     C                   Eval      EndDate = $Date7(DateFld)

     C                   Z-add     1             X                 3 0
     C                   DoW       CustOrders(X) <> *Blanks  and
     C                             X <= %Elem(CustOrders)
     C                   Eval      CustOrders(X) = *Blanks
     C                   Add       1             X
     C                   EndDo

     C                   Eval      *In60 = *On
     C     BegDate       SetLL     FTRSCHDS
     C                   Read      FTRSCHDS

     C                   Eval      Count = *Zero

     C                   DoW       TRSHDT >= BegDate and
     C                             TRSHDT <= EndDate and
     C                             not %EOF( FTRSCHDS )
      *? Get the Customer Master File information
     C     TRCUST        Chain     FMCUST
     C                   If        not %found(FMCUST)
     C                   Read      FTRSCHDS
     C                   Iter
     C                   EndIf
      *? Load information into Array
     C                   Eval      Count = Count + 1
     C                   Eval      CustOrders(Count) = CustDS

     C                   Read      FTRSCHDS
     C                   EndDo
      *? Sort the Array
     C                   SortA     CustOrders
      *? Move Blanks to the End
     C                   Eval      Count2 = %Elem(CustOrders) - Count + 1
     C                   Eval      Count  = 1
     C                   DoW       Count2 <= %Elem(CustOrders)
     C                   Eval      CustOrders(Count) = CustOrders(Count2)
     C                   Eval      CustOrders(Count2) = *Blanks
     C                   Eval      Count  = Count  + 1
     C                   Eval      Count2 = Count2 + 1
     C                   EndDo

      *? Clear the Subfile
     C                   Eval      *In25 = *Off
     C                   Eval      *In26 = *Off
     C                   Write     TRR55301C

      *? Load the Subfile from the Array
     C                   Z-add     0             RRN01
     C                   Z-add     1             Recount           3 0
     C                   Z-add     *Zero         SMCUST
     C                   DoW       CustOrders(Recount) <> *Blanks
     C                   Eval      CustDS = CustOrders(Recount)
      *? If this is a new Customer, load into Subfile
     C                   IF        TRORD#  = SMORDER
     C                   Eval      RRN01 = RRN01 + 1
     C                   Eval      SMCUST = CMCUST
     C                   Eval      SMNAME = CMNAME
     C*                  Eval      SMZIP  = CMZIP
     C                   Eval      CITYST = %Trim(%Subst(CMCITY:1:
     C                                      %Len(CITYST)-3)) + ',' + CMSTST
     C                   Write     TRR55301
     C                   Eval      *In26 = *On
     C                   Else
      *? If this is a repeat for the same customer, set on the Multiple Listings
      *? flag for this customer and update the last subfile record to reflect change.
     C                   IF        TRORD# = SMORDER
     C     RRN01         Chain     TRR55301
     C                   Eval      *In51 = *On                                  Multiple Listings Fl
     C                   Eval      TRTRK# = '*MLT'
     C                   Update    TRR55301
     C                   Eval      *In51 = *Off                                 Multiple Listings Fl
     C                   EndIf
     C                   EndIf
     C                   Eval      Recount = Recount + 1
     C                   EndDo
     C                   IF        *In26 = *On
     C     RRN01         Chain     TRR55301
     C                   Eval      *In27 = *On
     C                   IF        TRTRK# = '*MLT'
     C                   Eval      *In51 = *On
     C                   EndIF
     C                   Update    TRR55301
     C                   Eval      *In27 = *Off
     C                   Eval      *In51 = *Off
     C                   EndIF

     C                   ENDSR

      *   ...........................................................
      *   :      SCRN01 - DISPLAY SCREEN 1                          :
      *   :.........................................................:
     C     SCRN01        BEGSR

     C                   Z-ADD     01            SCREEN            3 0           Screen  Number
     C                   If        RRN01 > 0
     C                   Eval      *In26 = *On
     C                   Else
     C                   Eval      *In26 = *Off
     C                   EndIF
     C                   Eval      *In25 = *On
     C*                  Eval      SFLSIZ = RRN01
      *                  Eval      SFLSIZ = 1
     C                   EXFMT     TRR55301C
     C                   Eval      *In25 = *Off

     C                   ENDSR

      *   ...........................................................
      *   :      ERRS01 - DISPLAY SCREEN 01 (ERROR CONDITON)        :
      *   :.........................................................:
     C     ERRS01        BEGSR

     C*                  WRITE     MSGCTL
     C                   EXSR      SCRN01

     C                   ENDSR

      *   ...........................................................
      *   :      EDIT01 - EDIT SCREEN 1                             :
      *   :.........................................................:
     C     EDIT01        BEGSR

      *   Pre-edits
     C                   Eval      DateFld = $Date(KDate)
     C                   If        *In08 = *On
     C                   AddDur    MinusWeek:*D  DateFld
     C                   EndIF
     C                   If        *In09 = *On
     C                   AddDur    PlusWeek:*D   DateFld
     C                   EndIF
     C                   Eval      KDate = $Date7(DateFld)
     C                   Eval      MonDate = $Date6(DateFld)
     C                   Mult      100.0001      MonDate
      *  EDIT THE SCREEN
     C                   SELECT
      *  Check for Exit
     C     *IN03         WHENEQ    *ON
     C                   Eval      SMACCT = *zeros
     C                   Eval      SHPDAT = *Zeros
     C                   Eval      TRUCK  = *Blanks
     C                   MOVE      *ON           *INLR
      *  When the Search request is changed or Week Changed
     C     SMORDER       WhenNe    HoldORDER
     C     *In08         orEq      *On
     C     *In09         orEq      *On
     C                   ExSr      Load01
     C                   ExSr      Scrn01
      *  When a Subfile record is returned
     C                   When      SFLCSRRRN <> *Zero
      *    first check changed records to see if selected by SSEL
     C                   ReadC     TRR55301
     C                   DoW       not %EOF(TRR553FM)
     C                   IF        SSEL <> ' '
     C                   Eval      SFLCSRRRN = RRN01
     C                   Leave
     C                   EndIF
     C                   ReadC     TRR55301
     C                   EndDo
     C
     C     SFLCSRRRN     Chain     TRR55301
     C                   Eval      TRCUST = SMCUST
     C                   IF        TRTRK# <> '*MLT'
     C                   Eval      SDATE  = MONDATE
     C                   Eval      SHPDAT = TRSHDT
     C                   Eval      TRUCK  = TRTRK#
     C                   Eval      *InLR  = *On
     C                   Return
     C                   Else
     C                   ExSr      Load02
     C                   EXSR      Scrn02
     C                   EndIF
      *  If no actions then re-display
     C                   OTHER
     C                   EXSR      Scrn01
     C                   ENDSL

     C                   ENDSR
      *   ...........................................................
      *   :      LOAD02 - LOAD SCREEN 02                            :
      *   :.........................................................:
     C     LOAD02        BEGSR

      *? Clear the Subfile
     C                   Eval      *In25 = *Off
     C                   Eval      *In26 = *Off
     C                   Eval      *In27 = *Off
     C                   Eval      SSEL  = *Blanks
     C                   Write     TRR55302C

      *? Load the Subfile
     C     CustDate      KList
     C                   KFld                    TRCUST
     C                   KFld                    BegDate
     C     CustDate      SetLL     FTRSCHDC
     C     TRCUST        ReadE     FTRSCHDC

     C                   Z-ADD     0             RRN02

     C                   DoW       TRSHDT >= BegDate and
     C                             TRSHDT <= EndDate and
     C                             not %EOF( FTRSCHDC )

     C                   Eval      RRN02 = RRN02 + 1
     C                   Eval      SRSHDT = $Date6($Date(TRSHDT))
     C                   Mult      100.0001      SRSHDT
     C                   Eval      SRQTY1 = TRQTY1
     C                   Eval      SRQTY2 = TRQTY2
     C                   Eval      SRQTY3 = TRQTY3
     C                   Eval      SRQTY4 = TRQTY4
     C                   Write     TRR55302
     C                   Eval      *In26 = *On
     C     TRCUST        ReadE     FTRSCHDC
     C                   EndDo

     C                   IF        *In26 = *On
     C     RRN02         Chain     TRR55302
     C                   Eval      *In27 = *On                                  SFLEND Indicator
     C                   Update    TRR55302
     C                   EndIF

     C                   ENDSR

      *   ...........................................................
      *   :      SCRN02 - DISPLAY SCREEN 1                          :
      *   :.........................................................:
     C     SCRN02        BEGSR

     C                   Z-ADD     02            SCREEN            3 0           Screen  Number
     C                   If        RRN02 > 0
     C                   Eval      *In26 = *On
     C                   Else
     C                   Eval      *In26 = *Off
     C                   EndIF
     C                   Eval      *In25 = *On
     C                   EXFMT     TRR55302C
     C                   Eval      *In25 = *Off

     C                   ENDSR

      *   ...........................................................
      *   :      ERRS02 - DISPLAY SCREEN 02 (ERROR CONDITON)        :
      *   :.........................................................:
     C     ERRS02        BEGSR

     C*                  WRITE     MSGCTL
     C                   EXSR      SCRN02

     C                   ENDSR

      *   ...........................................................
      *   :      EDIT02 - EDIT SCREEN 1                             :
      *   :.........................................................:
     C     EDIT02        BEGSR

      *  EDIT THE SCREEN
     C                   SELECT
      *  Check for Exit
     C     *IN03         WHENEQ    *ON
     C                   Eval      SMACCT = *zeros
     C                   Eval      SHPDAT = *Zeros
     C                   Eval      TRUCK  = *Blanks
     C                   MOVE      *ON           *INLR
     C     *IN12         WHENEQ    *ON
     C                   ExSr      Scrn01
      *  When a Subfile record is returned
     C                   When      SFLCSRRRN <> *Zero
      *    first check changed records to see if selected by SSEL
     C                   ReadC     TRR55302
     C                   DoW       not %EOF(TRR553FM)
     C                   IF        SSEL <> ' '
     C                   Eval      SFLCSRRRN = RRN02
     C                   Leave
     C                   EndIF
     C                   ReadC     TRR55302
     C                   EndDo

     C     SFLCSRRRN     Chain     TRR55302
     C                   Eval      SHPDAT = TRSHDT
     C                   Eval      TRUCK  = TRTRK#
     C                   Eval      *InLR  = *On
      *  If no actions then re-display
     C                   OTHER
     C                   EXSR      Scrn02
     C                   ENDSL

     C                   ENDSR

      *   ...........................................................
      *   :      CLRERR - CLEAR ERRORS                              :
      *   :.........................................................:
     C     CLRERR        BEGSR

     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN            1

     C                   ENDSR

      ********************************************************************
      * ?SRMSGF - Clear or send messages to Pgm msg queue               ?*
      ********************************************************************
     CSR   SRMSGF        BEGSR

      *? Define Parameter List - define variables         ?

     C     PLMSGF        PLIST
     C                   PARM                    $#PGMQ           10            Pgm Msg Queue
     C                   PARM                    $#MSGF           10            Message File
     C                   PARM                    $#MSGL           10            Library
     C                   PARM                    $#MSID            7            Message Id
     C                   PARM                    $#MSGD          100            Message Data
     C                   PARM                    $#MSKY            4            Message Key
     C                   PARM                    $#MSFN            1            Send or Clear

      *? Call Msg processing CL                           ?

     C                   CALL      'XAMSFC'      PLMSGF

     C                   ENDSR

      *   ...........................................................
      *   :      *INZSR - Initialization Subroutine                 :
      *   :.........................................................:
     C     *INZSR        BEGSR

     C     *Entry        PList
     C     MONDATE       Parm                    SDATE             6 0           Screen Date
     C                   Parm                    SMORDER           6 0           Lookup Req'd
     C                   Parm                    SMACCT            6 0           Return Account
     C                   Parm                    SHPDAT            7 0           Ship Date
     C                   Parm                    TRUCK             4             Return Truck

     C     01            Chain     FOECTL
     C                   If        %Found(FOECTL)
     C                   Eval      HDR1 = OCHDG1
     C                   Eval      HDR2 = OCHDG2
     C                   Eval      HDR3 = OCHDG3
     C                   Eval      HDR4 = OCHDG4
     C                   Eval      HDR5 = OCHDG5
     C                   Eval      HDR6 = OCHDG6
     C                   EndIf

     C                   MOVE      ##PGM         $#PGMQ                          PGM MSG QUEUE
     C                   MOVEL     'KPMSGF'      $#MSGF                          MSG FILE N/A
     C                   MOVEL     '*LIBL'       $#MSGL                          LIBRARY  N/A
     C                   MOVE      '*******'     $#MSID                          MESSAGE ID
     C                   Z-add     *Zero         RRN01             4 0           RRN Screen 01
     C                   Z-add     *Zero         RRN02             4 0           RRN Screen 02

     C                   Call      '@DT@A1'      @DT@A1
     C     @DT@A1        PList
     C                   Parm                    SDATE
     C                   Parm                    KDATE             7 0
     C                   Parm                    ##ERR             1

     C                   EXSR      LOAD01
     C                   EXSR      SCRN01

     C                   ENDSR
     C/Copy QFunctCode,$Date
     C/Copy QFunctCode,$Date6
     C/Copy QFunctCode,$Date7
     C/Copy QFunctCode,$DateMDY
     C/Copy QFunctCode,$IsDate#
