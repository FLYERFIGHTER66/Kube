     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      *??:````````````````````````````````````````````````````````````:?
      *??:            Truck Chart Selection and Print                 :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  April 2004           ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Subroutine Usage                                        ?:
      *? :                                                           ?:
      *? :  Scrn01   -?Display Screen 01                             ?:
      *? :  Load01   -?Load Screen 01                                ?:
      *? :  Edit01   -?EDIT Screen 01                                ?:
      *? :  ClrError -?Clear Error MEssage Subfile                   ?:
      *? :  SndError -?Send an Error Message to the PGMMSGQ          ?:
      *? :  SRMSGF   -?Clear or send messages to Pgm msg queue       ?:
      *? :  *INZSR   -?Initialization Subroutine                     ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  01 - 24 ?Return Screen Functions                         ?:
      *? :  03      ?Exit                                            ?:
      *? :  06      ?Restart                                         ?:
      *? :          ?                                                ?:
      *? :  25      ?SFLDSP, SFLDSPCTL, SFLCLR(N)                    ?:
      *? :  26      ?SFLDSP (Subfile has Data)                       ?:
      *? :  27      ?SFLEND                                          ?:
      *? :  28      ?SFLNXTCHG                                       ?:
      *? :  40      ?Lookup Indicator                                ?:
      *? :  50      ?Error Indicator (All Errors)                    ?:
      *? :  70      ?Push Buttone Default 70 = Yes, N70 = No         ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
     FPUR560FM  CF   E             WORKSTN
     F                                     SFILE(PUR56001:RRN01)
     F                                     DEVID(WSID)
     FPUR500FM  CF   E             WORKSTN
     FPUR560P   O    E             PRINTER OFLIND(*IN29) USROPN

     FFMCUST    IF   E           K DISK                                         ?Customer Master
     FFPUHDRH1  IF   E           K DISK                                         ?Truck Schd Header
     FFPUSCHD   IF   E           K DISK                                         ?Truck Schd Details
     FFOECTL    IF   E           K DISK

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$isDate#
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,QCmdExc

      *? Arrays
     D   Cmd           S            100A   Dim(0002) CtData                     ?System Commands

      *? Data Structures
     D                SDS
     D  ##PGM            *PROC
     D  User                 254    263

      *? Data Areas
     D PUR560DP        DS                  DTAARA(PUR560DP)
     D  PlugsPRT               1     10                                         ?Dft Chart Printer

     D PUR560DF        DS                  DTAARA(PUR560DF)
     D  FinishPRT              1     10                                         ?Dft Chart Printer

     D LDA_DS          DS                  DTAARA(*LDA)
     D  UDSEXT              1000   1000
     D  UDSDAT              1001   1004P 0
     D  UDSTRK              1005   1008

      *? Field Definitions
     D   RRN01         S              4  0 Inz(0)                               ?SFLRRN Screen 02
     D   Today         S               D                                        ?Today
     D   SDate         S              6S 0 Inz(0)                               ?Ship Date MDY
     D   SDateYMD7     S              7S 0 Inz(0)                               ?Ship Date YMD7
     D   ThisMonday    S              6S 0 Inz(0)                               ?Monday ( MDY )
     D   ThisMonCYMD   S              7S 0 Inz(0)                               ?Monday ( CYMD )
     D   ErrCount      S              3S 0 Inz(0)                               ?Error Count
     D   PrtChart      S              3S 0 Inz(0)                               ?Chart Cells Printed
     D   Pink          S              1A   Inz('?')                             ?Color Code for?PINK
     D   SavePRTR      S             10A                                        ?Save Curr PRTR
     D   #Printer      S             10A                                        ?OverRide to Printer
     D   Command       S            100A   Inz(*Blanks)                         ?System Command
     D   SSTOP#        S                   Like(TRSTP#)                         ?Stop Number


     C     *INLR         DOUEQ     *ON                                          ?COMMENT

     C                   SELECT                                                 ?
     C     Screen        WhenEq    1                                            ?
     C                   ExSr      Edit01                                       ?
     C     Screen        WhenEq    2                                            ?
     C                   ExSr      Edit02                                       ?
     C                   ENDSL                                                  ?

     C                   ENDDO                                                  ?

      *?  ...........................................................
      *?  :      Scrn01 - Display Screen 01                         :
      *?  :.........................................................:
    ?C     Scrn01        BegSr                                                  ?
     C                   Z-Add     01            Screen            3 0          ?Screen  Number
     C                   Eval      *In25 = *On                                  ?
    ?C                   Write     ASSUME
    ?C                   Write     PUR56001F                                   ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     PUR56001C                                    ?
     C                   ExSr      ClrError                                     ?
     C                   Eval      *In25 = *Off                                 ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load01 - Load Screen 01                            :
      *?  :.........................................................:
    ?C     Load01        BegSr                                                  ?

      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?
     C                   Eval      *In26 = *Off                                 ?
     C                   Eval      *In27 = *Off                                 ?
    ?C                   Write     PUR56001C                                    ?

      *? Load the Subfile
     C                   Eval      *In28 = *On                                  ?Write w/ SFLNXTCHG
     C     SDateYMD7     SetLL     FPUHDRH1                                     ?
    ?C     SDateYMD7     ReadE     FPUHDRH1                                     ?

     C                   Z-add     *Zero         RRN01                          ?
     C                   DoW       not %EOF(FPUHDRH1)
     C                   Add       1             RRN01                          ?
     C                   MoveL     THCOMM        SHCOMM
     C                   Eval      SPLHB = *Zero
     C                   Eval      SFLAT = *Zero
     C                   Eval      SCART = *Zero
WJB  C                   Eval      SCOL4 = *Zero
    ?C     DetailKey     SetLL     FPUSCHD
    ?C     DetailKey     ReadE     FPUSCHD
     C                   DoW       not %EOF(FPUSCHD)
     C                   Eval      SPLHB = SPLHB + TRQTY1
     C                   Eval      SFLAT = SFLAT + TRQTY2
     C                   Eval      SCART = SCART + TRQTY3
     C                   Eval      SCOL4 = SCOL4 + TRQTY4
    ?C     DetailKey     ReadE     FPUSCHD
     C                   EndDo
    ?C                   Select
    ?C                   When      SCART  <= 16
     C                   Eval      SChart =  16
    ?C                   When      SCART  <= 20
     C                   Eval      SChart =  20
    ?C                   When      SCART  <= 32
     C                   Eval      SChart =  32
    ?C                   When      SCART  <= 36
     C                   Eval      SChart =  36
    ?C                   Other
     C                   Eval      SChart = 0
    ?C                   EndSL
    ?C                   Write     PUR56001                                     ?
     C                   Eval      *In26 = *On                                  ?
    ?C     SDateYMD7     ReadE     FPUHDRH1                                     ?
     C                   EndDo                                                  ?

     C                   IF        *In26 = *On                                  ?
    ?C     RRN01         Chain     PUR56001                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    PUR56001                                     ?
     C                   EndIF                                                  ?

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit01 - EDIT Screen 01                            :
      *?  :.........................................................:
    ?C     Edit01        BegSr                                                  ?

    ?C                   SELECT                                                 ?
      *? Exit Requested
    ?C                   When      *In03 = *ON                                          ?
     C                   MOVE      *ON           *INLR                          ?
     C                   LeaveSR                                                ?
      *? Switch Chart Type
    ?C                   When      *In02 = *ON                                          ?
     C                   If        *In41 = *On
     C                   Eval      *In41 = *Off
     C                   Else
     C                   Eval      *In41 = *On
     C                   EndIF
     C                   ExSr      Scrn01                                       ?
      *? Change Printer Requested
    ?C                   When      *In11 = *ON                                          ?
     C                   ExSr      Load02
     C                   ExSr      Scrn02
     C                   LeaveSR                                                ?
      *? When Date is invalid
    ?C                   When      not $isDate#(SDATE:'*MDY')                           ?
     C                   Eval      $#MSID = 'TRR5601'
     C                   EXSR      SndError
     C                   Eval      *In26 = *Off                                 ?Do not Display SFL
     C                   ExSr      Scrn01                                       ?
      *? When Date is Changed
    ?C                   When      $DateMDY(SDate) <> $Date(SDateYMD7)             ?
     C                   Eval      SDateYMD7 = $Date7($DateMDY(SDate))
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? When Previou Day is Requested
    ?C                   When      *In08 = *ON                                  ?
     C                   Eval      SDate=$MDYDate($AddDate($DateMDY(SDate):-1))
     C                   Eval      SDateYMD7 = $Date7($DateMDY(SDate))
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? When Next Day is Requested
    ?C                   When      *In09 = *ON                                  ?
     C                   Eval      SDate=$MDYDate($AddDate($DateMDY(SDate):1))
     C                   Eval      SDateYMD7 = $Date7($DateMDY(SDate))
     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?
      *? When Print All is Requested
    ?C                   When      *In10 = *ON                                  ?
     C                   ExSr      PrintAll                                     ?
     C                   ExSr      Scrn01                                       ?
      *? If no Functions, Check for Options and Re-display
    ?C                   OTHER                                                  ?
    ?C                   ReadC     PUR56001
     C                   Eval      *In28 = *On
     C                   DoW       not %EOF(PUR560FM)

    ?C                   Select
    ?C                   When      Sel01 = *Blanks
     C*                  Do Nothing (Skip Subfile Record)
    ?C                   When      Sel01 = '1'
     C                   ExSr      PrintTruck
     C                   Eval      *In51 = *On                                  ?Change to Blue
     C                   Eval      Sel01 = *Blanks
    ?C                   When      Sel01 = '5'
     C                   ExSr      ViewTruck
     C                   Eval      Sel01 = *Blanks
    ?C                   Other
     C                   Eval      $#MSGD = Sel01
     C                   Eval      $#MSID = 'TRR5604'
     C                   EXSR      SndError
     C                   Eval      *In52 = *On
    ?C                   ENDSL                                                  ?
    ?C                   Update    PUR56001
     C                   Eval      *In51 = *Off
     C                   Eval      *In52 = *Off
    ?C                   ReadC     PUR56001
     C                   EndDo                                                  ?
     C                   ExSr      Scrn01
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      Scrn02 - Display Screen 02                         :
      *?  :.........................................................:
    ?C     Scrn02        BegSr                                                  ?
     C                   Z-Add     02            Screen            3 0          ?Screen  Number
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     PUR56002                                     ?
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load02 - Load Screen 02                            :
      *?  :.........................................................:
    ?C     Load02        BegSr                                                  ?

      *? Get the Current Default Printer
     C   41*Lock         In        PUR560DF
     C  N41*Lock         In        PUR560DP
     C   41              Eval      PRTDefault = FinishPRT
     C  N41              Eval      PRTDefault = PlugsPRT

      *? Save the Current Printer
     C                   Eval      SavePRTR = PRTToUse

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Edit02 - EDIT Screen 02                            :
      *?  :.........................................................:
    ?C     Edit02        BegSr                                                  ?

    ?C                   SELECT                                                 ?
      *? Check for Cancel Request
    ?C                   When      *In12 = *ON                                          ?
     C                   Eval      PRTToUse = SavePRTR
     C   41              Unlock    PUR560DF
     C  N41              Unlock    PUR560DP
     C                   ExSr      Scrn01
      *? Check for Default Request
    ?C                   When      *In11 = *ON                                          ?
     C                   Eval      PRTToUse = PRTDefault
     C   41              Unlock    PUR560DF
     C  N41              Unlock    PUR560DP
     C                   ExSr      Scrn01
      *? When Default Printer Change is requested
    ?C                   When      *In13 = *ON
     C                   Eval      PRTDefault = PRTToUse
     C   41              Eval      FinishPRT  = PRTToUse
     C  N41              Eval      PlugsPRT   = PRTToUse
     C   41              Out       PUR560DF
     C  N41              Out       PUR560DP
     C                   Eval      $#MSGD = Pink + PRTDefault
     C   41              Eval      $#MSID = 'TRR5602'
     C  N41              Eval      $#MSID = 'TRR5605'
     C                   EXSR      SndError
     C                   ExSr      Scrn01                                       ?
      *? If no Functions, Check for Options and Re-display
    ?C                   OTHER                                                  ?
     C   41              Unlock    PUR560DF
     C  N41              Unlock    PUR560DP
     C                   If        PRTToUse <> SavePRTR
     C                   Eval      $#MSGD = Pink + PRTToUse
     C                   Eval      $#MSID = 'TRR5603'
     C                   EXSR      SndError
     C                   EndIf
     C                   ExSr      Scrn01                                       ?
    ?C                   ENDSL                                                  ?

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ViewTruck - Print Chart for Selected Truck         :
      *?  :.........................................................:
    ?C     ViewTruck     BegSr                                                  ?

     C                   IN        LDA_DS
     C                   Eval      *InU8 = *On
     C                   Eval      UDSTRK = THTRK#
     C                   Eval      UDSDAT = SDateYMD7
     C                   Eval      UDSEXT = 'Y'
     C                   OUT       LDA_DS
     C                   Call      'PUR500'
     C                   Eval      UDSEXT = ' '

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      PrintTruck - Print Chart for Selected Truck        :
      *?  :.........................................................:
    ?C     PrintTruck    BegSr                                                  ?

     C                   If        SChart <= 20
     C                   Eval      *In40 = *On
     C                   Eval      *In42 = *On
     C                   Eval      *In43 = *On
     C                   Else
     C                   Eval      *In40 = *Off
     C                   Eval      *In42 = *Off
     C                   Eval      *In43 = *Off
     C                   EndIf

     C                   If        not %Open(PUR560P)
     C                   If        SChart <= 28
     C                   Eval      Command = Cmd(1)                             ?Short Paper 8.5x11
     C                   ExSr      $Command
     C                   Else
     C                   Eval      Command = Cmd(2)                             ?Long Paper  8.5x14
     C                   ExSr      $Command
     C                   EndIf
    ?C                   Open      PUR560P
     C                   EndIf

    ?C                   Write     Header
    ?C     DetailKey     SetLL     FPUSCHD
    ?C     DetailKey     ReadE     FPUSCHD
     C                   Eval      SSTOP# = *Zero
     C                   Eval      TOTAL1 = *Zero
     C                   Eval      TOTAL2 = *Zero
     C                   Eval      TOTAL3 = *Zero
     C                   Eval      TOTAL4 = *Zero
     C                   Eval      GTOTAL1 = *Zero
     C                   Eval      GTOTAL2 = *Zero
     C                   Eval      GTOTAL3 = *Zero
     C                   Eval      GTOTAL4 = *Zero
     C                   DoW       not %EOF(FPUSCHD)
     C                   Eval      SSTOP# = SSTOP# + 1
     C                   Eval      TOTAL1 = TRQTY1
     C                   Eval      TOTAL2 = TRQTY2
     C                   Eval      TOTAL3 = TRQTY3
     C                   Eval      TOTAL4 = TRQTY4
     C                   Eval      GTOTAL1 = GTOTAL1 + TRQTY1
     C                   Eval      GTOTAL2 = GTOTAL2 + TRQTY2
     C                   Eval      GTOTAL3 = GTOTAL3 + TRQTY3
     C                   Eval      GTOTAL4 = GTOTAL4 + TRQTY4
     C     TRCUST        Chain     FMCUST
     C                   If        not %Found(FMCUST)
     C                   Clear                   RMCUST
     C                   EndIf
     C                   MoveL     CMNAME        RMNAME
     C                   MoveL     CMCITY        RMCITY
     C                   Write     Detail
    ?C     DetailKey     ReadE     FPUSCHD
     C                   EndDo
    ?C                   Write     Footer1
     C                   If        SSTOP# >= 10
     C                   Eval      *In42 = *off
     C                   If        SSTOP# >= 15
     C                   Eval      *In43 = *off
     C                   EndIF
     C                   EndIF
     C                   Eval      PrtChart = 0
     C                   DoW       PrtChart < SChart
    ?C                   Write     Chart
     C                   Eval      PrtChart = PrtChart + 4
     C                   EndDo
    ?C                   Write     Footer2
    ?C                   Write     Footer3

     C                   If        %Open(PUR560P)
    ?C                   Close     PUR560P
     C                   EndIf

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      PrintAll - Print all Truck Charts                  :
      *?  :.........................................................:
    ?C     PrintAll      BegSr                                                  ?

     C                   ReadC     PUR56001
     C                   DoU       %EOF(PUR560FM)
     C                   If        THTRK# <> *Blanks
     C                   ExSr      PrintTruck
     C                   EndIf
     C                   ReadC     PUR56001
     C                   EndDo

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      ClrError - Clear Error Message Subfile             :
      *?  :.........................................................:
    ?C     ClrError      BegSr                                                  ?

     C                   MOVE      'C'           $#MSFN            1            ?
     C                   ExSr      SRMSGF                                       ?
     C                   Eval      ErrCount = *Zero                             ?
     C                   Eval      *In50 = *Off                                 ?Error Indicator

    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      SndError - Send an Error Message to the PGMMSGQ    :
      *?  :.........................................................:
    ?C     SndError      BegSr                                                  ?

     C                   MOVE      'S'           $#MSFN            1            ?
     C                   ExSr      SRMSGF                                       ?
     C                   Eval      ErrCount = ErrCount + 1                      ?
     C                   Eval      *In50 = *On                                  ?Error Indicator

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      * ? :      SRMSGF - Clear or send messages to Pgm msg queue   :
      *?  :.........................................................:
    ?C     SRMSGF        BegSr                                                  ?

      *? Define Parameter List - define variables         ?

     C     PLMSGF        PLIST                                                  ?
     C                   Parm                    $#PGMQ           10            ?Pgm Msg Queue
     C                   Parm                    $#MSGF           10            ?Message File
     C                   Parm                    $#MSGL           10            ?Library
     C                   Parm                    $#MSID            7            ?Message Id
     C                   Parm                    $#MSGD          100            ?Message Data
     C                   Parm                    $#MSKY            4            ?Message Key
     C                   Parm                    $#MSFN            1            ?Send or Clear

      *? Call Msg processing CL                           ?

     C                   CALL      'XAMSFC'      PLMSGF                         ?

    ?C                   EndSr                                                  ?

      *?  ..........................................................
      *?  :   Run system command                                   :
      *?  :........................................................:
     C     $Command      BegSR
      *? Format the command String.  Put vaiable in place in the string.

      *?   |P?=Printer ID?    ?Put the Printer Name in the Override command?
     C                   Eval      #Printer = PrtToUse
     C                   DoW       %Scan('|P':Command) <> 0
     C                   Eval      Command = %REPLACE
     C                             (%Trim(#Printer) + ')': Command :
     C                               %SCAN('|P': Command))
     C                   EndDo

      *?   ~ ?=Blank that needs to be removed??Replace with nothing?
     C                   DoW       %Scan('~':Command) <> 0
     C                   Eval      Command =
     C                               %SubSt(Command:1:%Scan('~':Command)-1)
     C                             + %SubSt(Command:%Scan('~':Command)+1:
     C                               %Len(Command) - %Scan('~':Command))
     C                   EndDo

      *? Execute the Command using QCMDEXC.
     C                   CALLP     QCmdExc(Command:%len(%Trim(Command)))

     C                   EndSR


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:
    ?C     *INZSR        BegSr                                                  ?

     C     *Entry        PList
WHT  C                   Parm                    PlugFinish        1            |Plugs or Finished

     C                   If        PlugFinish = 'F'
     C                   Eval      *In41 = *On
     C                   Else
     C                   Eval      *In41 = *Off
     C                   EndIF

     C                   MOVE      ##PGM         $#PGMQ                         ?PGM MSG QUEUE
     C                   MOVEL     'KPMSGF'      $#MSGF                         ?MSG FILE N/A
     C                   MOVEL     '*LIBL'       $#MSGL                         ?LIBRARY  N/A
     C                   MOVE      '*******'     $#MSID                         ?MESSAGE ID

     C                   Eval      Today = $Date(0)                             ?Today MDY
     C                   Eval      SDate = $MDYDate($AddDate(Today:1))          ?Ship Date MDY
     C                   Eval      SDateYMD7 = $Date7($AddDate(Today:1))        ?Ship Date YMD7

      *? Get the Current Default Printer
     C   41              In        PUR560DF
     C  N41              In        PUR560DP
     C   41              Eval      PRTDefault = FinishPRT
     C  N41              Eval      PRTDefault = PlugsPRT
     C                   Eval      PRTToUse = PRTDefault

     C     01            CHAIN     FOECTL                             90
     C                   MOVEL     OCHDG1        HDG1
     C                   MOVEL     OCHDG2        HDG2
     C                   MOVEL     OCHDG3        HDG3
     C                   MOVEL     OCHDG4        HDG4

     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

     C     DetailKey     KList
     C                   KFld                    THTRK#
     C                   KFld                    THSHDT

    ?C                   EndSr                                                  ?
**
OVRPRTF FILE(PUR560P) PAGESIZE(11 8.5 *UOM) FORMTYPE(*NAR) OVRSCOPE(*JOB) PAGRTT(0) OUTQ(|P
OVRPRTF FILE(PUR560P) PAGESIZE(14 8.5 *UOM) FORMTYPE(*LONG) OVRSCOPE(*JOB) PAGRTT(0) OUTQ(|P
