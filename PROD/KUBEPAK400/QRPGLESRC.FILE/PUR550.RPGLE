     H DFTACTGRP(*NO)
     H DATFMT(*USA)

     FPUR550FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFHORDWDT  UF   E           K DISK
      *
     D                SDS
     D  ##PGM            *PROC

     D LDA_DS         UDS                  DTAARA(*LDA)
     D  UDSEXT              1000   1000
     D  UDSDAT              1001   1004P 0
     D  UDSTRK              1005   1008

     D  Today          S              8  0
     D  Temp           S              1  0
     D  TDate          S               D
     D  GetMon         S               D
     D  MondayIs       S               D
      *
     D/COPY QFunctDefn,$Date
     D/COPY QFunctDefn,$Date6
     D/COPY QFunctDefn,$DateMDY
     D/COPY QFunctDefn,$WeekDay
     D/COPY QFunctDefn,$isDate#
      *
     C     *INLR         DOUEQ     *ON
      *
     C                   SELECT
     C     SCREEN        WHENEQ    1
     C                   EXSR      EDIT01
     C     SCREEN        WHENEQ    2
     C*                  EXSR      EDIT02
     C                   ENDSL
      *
     C                   ENDDO
      *
      *   ...........................................................
      *   :      Scrn01 - DISPLAY SCREEN 1                          :
      *   :.........................................................:
     C     Scrn01        BEGSR
      *
     C                   Z-ADD     1             SCREEN            3 0           Screen  Number
     C                   EXFMT     PUR55001
      *
     C                   ENDSR
      *
      *   ...........................................................
      *   :      ERRS01 - DISPLAY SCREEN 01 (ERROR CONDITON)        :
      *   :.........................................................:
     C     ERRS01        BEGSR
      *
     C                   WRITE     MSGCTL
     C                   EXSR      Scrn01
     C                   EXSR      ClrError
      *
     C                   ENDSR
      *
      *   ...........................................................
      *   :      EDIT01 - EDIT SCREEN 1                             :
      *   :.........................................................:
     C     EDIT01        BEGSR
      *
      *  EDIT THE SCREEN
     C                   SELECT
      *  Check for Exit
     C     *IN03         WHENEQ    *ON
     C                   MOVE      *ON           *INLR
      *  Check for errors
     C                   WHEN      not $isDate#(SDATE:'*MDY')
     C                   Eval      GetMon = $Date(Today)
     C                   ExSr      GetMonday
     C                   Eval      SDATE = $Date6(MondayIs)
     C                   Mult      100.0001      SDate
     C                   Eval      $#MSID = 'DATE114'
     C                   EXSR      SndError
     C                   EXSR      ERRS01

     C                   WHEN      $WeekDay($DateMDY(SDATE):'MON') <> 1
     C                   Eval      $#MSID = 'DATE115'
     C                   Eval      GetMon = $DateMDY(SDATE)
     C                   ExSr      GetMonday
     C                   Eval      SDATE = $Date6(MondayIs)
     C                   Mult      100.0001      SDate
     C                   EXSR      SndError
     C                   EXSR      ERRS01

     C     *In19         WhenEQ    *On
     C                   Eval      TDate = $DateMDY(SDate)
     C                   SubDur    7:*D          TDate
     C                   Eval      SDate = $Date6(TDate)
     C                   Mult      100.0001      SDate
     C                   EXSR      Scrn01

     C     *In20         WhenEQ    *On
     C                   Eval      TDate = $DateMDY(SDate)
     C                   AddDur    7:*D          TDate
     C                   Eval      SDate = $Date6(TDate)
     C                   Mult      100.0001      SDate
     C                   EXSR      Scrn01

     C     SMLOOK        WhenEQ    *Blanks
     C                   Eval      $#MSID = 'TRR5501'
     C                   EXSR      SndError
     C                   EXSR      ERRS01

     C     SMLOOK        WhenNE    *Blanks
     C                   Call      'PUR551'
     C                   Parm                    SDATE             6 0           Screen Date
     C                   Parm                    SMLOOK           15             Lookup Req'd
     C                   Parm                    SMACCT            6 0           Return Account
     C                   Parm                    SHPDAT            7 0           Truck
     C                   Parm                    TRUCK             4             Truck
     C                   IF        TRUCK <> *Blanks
     C                             and SHPDAT <> *Zero
     C                   IN        LDA_DS
     C                   Eval      *InU8 = *On
     C                   Eval      UDSTRK = TRUCK
     C                   Eval      UDSDAT = SHPDAT
     C                   Eval      UDSEXT = 'Y'
     C                   OUT       LDA_DS
     C                   Call      'PUR500'
     C                   Eval      UDSEXT = ' '
     C                   EndIF
     C                   EXSR      Scrn01
      *  If no actions then re-display
     C                   OTHER
     C                   EXSR      Scrn01
     C                   ENDSL
      *
     C                   ENDSR
      *
      *   ...........................................................
      *   :      SndError - Send Error message to PGM MSGQ          :
      *   :.........................................................:
     C     SndError      BEGSR
      *
     C                   MOVE      'S'           $#MSFN            1
     C                   EXSR      SRMSGF
      *
     C                   ENDSR
      *
      *   ...........................................................
      *   :      CLRERR - CLEAR ERRORS                              :
      *   :.........................................................:
     C     ClrError      BEGSR
      *
     C                   MOVE      'C'           $#MSFN            1
     C                   EXSR      SRMSGF
     C                   MOVE      'S'           $#MSFN            1
      *
     C                   ENDSR
      *
      ********************************************************************
      * ?SRMSGF - Clear or send messages to Pgm msg queue               ?*
      ********************************************************************
     CSR   SRMSGF        BEGSR
      *
      *? Define Parameter List - define variables         ?
      *
     C     PLMSGF        PLIST
     C                   PARM                    $#PGMQ           10            Pgm Msg Queue
     C                   PARM                    $#MSGF           10            Message File
     C                   PARM                    $#MSGL           10            Library
     C                   PARM                    $#MSID            7            Message Id
     C                   PARM                    $#MSGD          100            Message Data
     C                   PARM                    $#MSKY            4            Message Key
     C                   PARM                    $#MSFN            1            Send or Clear
      *
      *? Call Msg processing CL                           ?
      *
     C                   CALL      'XAMSFC'      PLMSGF
      *
     C                   ENDSR
      *
      *   ...........................................................
      *   :      GetMonday - Find associated Monday for given date  :
      *   :.........................................................:
     C     GetMonday     BEGSR
      *
     C                   Eval      Temp = $WeekDay(GetMon:'MON') - 1
     C                   IF        Temp > 4
     C                   Eval      Temp = Temp - 6
     C                   EndIf
     C     GetMon        SUBDUR    Temp:*D       MondayIs
      *
     C                   ENDSR
      *
      *   ...........................................................
      *   :      *INZSR - Initialization Subroutine                 :
      *   :.........................................................:
     C     *INZSR        BEGSR
      *
     C     *Date         Mult      10000.0001    Today
      *
     C                   MOVE      ##PGM         $#PGMQ                          PGM MSG QUEUE
     C                   MOVEL     'KPMSGF'      $#MSGF                          MSG FILE N/A
     C                   MOVEL     '*LIBL'       $#MSGL                          LIBRARY  N/A
     C                   MOVE      '*******'     $#MSID                          MESSAGE ID
      *
     C                   Eval      GetMon = $Date(Today)
     C                   ExSr      GetMonday
     C                   Eval      SDATE = $Date6(MondayIs)
     C                   Mult      100.0001      SDate
      * Do not load date initially per Bill S. 3/28/05 @ 09:30
     C                   Eval      SDate = *Zero
      *
     C                   EXSR      Scrn01
      *
     C                   ENDSR
      *
     C/Copy QFunctCode,$Date
     C/Copy QFunctCode,$Date6
     C/Copy QFunctCode,$DateMDY
     C/Copy QFunctCode,$WeekDay
     C/Copy QFunctCode,$isDate#
