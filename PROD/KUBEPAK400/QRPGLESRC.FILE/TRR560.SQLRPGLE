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
      *? :  97      ?Lookup Indicator                                ?:
      *? :  50      ?Error Indicator (All Errors)                    ?:
      *? :  70      ?Push Buttone Default 70 = Yes, N70 = No         ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:
     FTRR560FM  CF   E             WORKSTN
     F                                     SFILE(TRR56001:RRN01)
     F                                     DEVID(WSID)
     F*TRR500FM  CF   E             WORKSTN
     FTRR560P   O    E             PRINTER OFLIND(*IN29) USROPN

     FFMCUST    IF   E           K DISK                                         ?Customer Master
     FFTRHDRH1  IF   E           K DISK                                         ?Truck Schd Header
     FFTRSCHD   IF   E           K DISK                                         ?Truck Schd Details
     FFTRSCHDTO IF   E           K DISK    RENAME(RTRSCHD:RTRSCHDTO)            ?Truck Schd Details
     FFHORDR    IF   E           K DISK                                         ?Order Header
     FFOECTL    IF   E           K DISK

     FFCRTORDORDIF   E           K DISK
     FFCRTORDCRTIF   E           K DISK    RENAME(RCRTORD:RCRTORDCRT)

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$isDate#
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$Center
    ?D/COPY QFunctDefn,QCmdExc

      *? Arrays
     D   Cmd           S            100A   Dim(0002) CtData                     ?System Commands
     D   Categ         S              4A   Dim(0006) CtData PerRcd(01)          ?Categories
     D   Rpt           S             93A   Dim(0006) CtData PerRcd(01)          ?Report Literals

     D   STP#          S              2S 0 Dim(0040)                            ?STOP NUMBER
     D   NAME          S             22A   Dim(0040)                            ?CUTOMER NAME
     D   ORD#          S              6S 0 Dim(0040)                            ?ORDER Number
     D   CSTM          S              1A   Dim(0040)                            ?custom order flag
     D   CSEQ          S              2S 0 Dim(0040)                            ?CART SEQ Number
     D   CART          S                   Dim(0040) Like(COCART)               ?CART Number
     D   USED          S              4S 0 Dim(0040)                            ?CARTS Used on Truck

      *? Data Structures
     D                SDS
     D  ##PGM            *PROC
     D  User                 254    263

      *? Data Areas
     D TRR560DP        DS                  DTAARA(TRR560DP)
     D  PlugsPRT               1     10                                         ?Dft Chart Printer

     D TRR560DF        DS                  DTAARA(TRR560DF)
     D  FinishPRT              1     10                                         ?Dft Chart Printer

     D LDA_DS          DS                  DTAARA(*LDA)
     D  UDSEXT              1000   1000
     D  UDSDAT              1001   1004P 0
     D  UDSTRK              1005   1008

     D  TRQTY_DS       DS
     D  TRQTY1
     D  TRQTY2
     D  TRQTY3
     D  TRQTY4
     D  TRQTY5
     D  TRQTY6
     D  TRQTY                              Like(TRQTY1) Dim(6) Overlay(TRQTY_DS)

     D  OrdQTY_DS      DS                  Inz
     D  OrdQTY1                            Like(TRQTY1)
     D  OrdQTY2                            Like(TRQTY2)
     D  OrdQTY3                            Like(TRQTY3)
     D  OrdQTY4                            Like(TRQTY4)
     D  OrdQTY5                            Like(TRQTY5)
     D  OrdQTY6                            Like(TRQTY6)
     D  OrdQTY                             Like(OrdQTY1) Dim(6)
     D                                     Overlay(OrdQTY_DS)

     D  CART_AD        DS                  INZ
     D  CART_A6
     D  CART_A5
     D  CART_A4
     D  CART_A3
     D  CART_A2
     D  CART_A1
     D  CART_A                             Like(CART_A6) DIM(6) OVERLAY(CART_AD)
     D  ORD#_AD        DS                  INZ
     D  ORD#_A6
     D  ORD#_A5
     D  ORD#_A4
     D  ORD#_A3
     D  ORD#_A2
     D  ORD#_A1
     D  ORD#_A                             Like(ORD#_A6) DIM(6) OVERLAY(ORD#_AD)
     D  CSTM_AD        DS                  INZ
     D  CSTM_A6
     D  CSTM_A5
     D  CSTM_A4
     D  CSTM_A3
     D  CSTM_A2
     D  CSTM_A1
     D  CSTM_A                             Like(CSTM_A6) DIM(6) OVERLAY(CSTM_AD)
     D  STOP_AD        DS                  INZ
     D  STOP_A6
     D  STOP_A5
     D  STOP_A4
     D  STOP_A3
     D  STOP_A2
     D  STOP_A1
     D  STOP_A                             Like(STOP_A6) DIM(6) OVERLAY(STOP_AD)
     D  CART_BD        DS                  INZ
     D  CART_B6
     D  CART_B5
     D  CART_B4
     D  CART_B3
     D  CART_B2
     D  CART_B1
     D  CART_B                             Like(CART_B6) DIM(6) OVERLAY(CART_BD)
     D  ORD#_BD        DS                  INZ
     D  ORD#_B6
     D  ORD#_B5
     D  ORD#_B4
     D  ORD#_B3
     D  ORD#_B2
     D  ORD#_B1
     D  ORD#_B                             Like(ORD#_B6) DIM(6) OVERLAY(ORD#_BD)
     D  CSTM_BD        DS                  INZ
     D  CSTM_B6
     D  CSTM_B5
     D  CSTM_B4
     D  CSTM_B3
     D  CSTM_B2
     D  CSTM_B1
     D  CSTM_B                             Like(CSTM_B6) DIM(6) OVERLAY(CSTM_BD)
     D  STOP_BD        DS                  INZ
     D  STOP_B6
     D  STOP_B5
     D  STOP_B4
     D  STOP_B3
     D  STOP_B2
     D  STOP_B1
     D  STOP_B                             Like(STOP_B6) DIM(6) OVERLAY(STOP_BD)
     D  CART_CD        DS                  INZ
     D  CART_C6
     D  CART_C5
     D  CART_C4
     D  CART_C3
     D  CART_C2
     D  CART_C1
     D  CART_C                             Like(CART_C6) DIM(6) OVERLAY(CART_CD)
     D  ORD#_CD        DS                  INZ
     D  ORD#_C6
     D  ORD#_C5
     D  ORD#_C4
     D  ORD#_C3
     D  ORD#_C2
     D  ORD#_C1
     D  ORD#_C                             Like(ORD#_C6) DIM(6) OVERLAY(ORD#_CD)
     D  CSTM_CD        DS                  INZ
     D  CSTM_C6
     D  CSTM_C5
     D  CSTM_C4
     D  CSTM_C3
     D  CSTM_C2
     D  CSTM_C1
     D  CSTM_C                             Like(CSTM_C6) DIM(6) OVERLAY(CSTM_CD)
     D  STOP_CD        DS                  INZ
     D  STOP_C6
     D  STOP_C5
     D  STOP_C4
     D  STOP_C3
     D  STOP_C2
     D  STOP_C1
     D  STOP_C                             Like(STOP_C6) DIM(6) OVERLAY(STOP_CD)
     D  CART_DD        DS                  INZ
     D  CART_D6
     D  CART_D5
     D  CART_D4
     D  CART_D3
     D  CART_D2
     D  CART_D1
     D  CART_D                             Like(CART_D6) DIM(6) OVERLAY(CART_DD)
     D  ORD#_DD        DS                  INZ
     D  ORD#_D6
     D  ORD#_D5
     D  ORD#_D4
     D  ORD#_D3
     D  ORD#_D2
     D  ORD#_D1
     D  ORD#_D                             Like(ORD#_D6) DIM(6) OVERLAY(ORD#_DD)
     D  CSTM_DD        DS                  INZ
     D  CSTM_D6
     D  CSTM_D5
     D  CSTM_D4
     D  CSTM_D3
     D  CSTM_D2
     D  CSTM_D1
     D  CSTM_D                             Like(CSTM_D6) DIM(6) OVERLAY(CSTM_DD)
     D  STOP_DD        DS                  INZ
     D  STOP_D6
     D  STOP_D5
     D  STOP_D4
     D  STOP_D3
     D  STOP_D2
     D  STOP_D1
     D  STOP_D                             Like(STOP_D6) DIM(6) OVERLAY(STOP_DD)

      *? Field Definitions
     D  RRN01          S              4  0 Inz(0)                               ?SFLRRN Screen 02
     D  Today          S               D                                        ?Today
     D  SDate          S              6S 0 Inz(0)                               ?Ship Date MDY
     D  SDateYMD7      S              7S 0 Inz(0)                               ?Ship Date YMD7
     D  ThisMonday     S              6S 0 Inz(0)                               ?Monday ( MDY )
     D  ThisMonCYMD    S              7S 0 Inz(0)                               ?Monday ( CYMD )
     D  ErrCount       S              3S 0 Inz(0)                               ?Error Count
     D  PrtChart       S              3S 0 Inz(0)                               ?Chart Cells Printed
     D  Pink           S              1A   Inz('?')                             ?Color Code for?PINK
     D  SavePRTR       S             10A                                        ?Save Curr PRTR
     D  #Printer       S             10A                                        ?OverRide to Printer
     D  Command        S            100A   Inz(*Blanks)                         ?System Command
     D  SSTOP#         S                   Like(TRSTP#)                         ?Stop Number
     D  Sav_TRSTP#     S                   Like(TRSTP#)                         ?Saved Stop Number
     D  Lines_Header   S              3S 0 Inz(0)                               ?Print Lines Header
     D  Lines_Orders   S              3S 0 Inz(0)                               ?Print Lines Orders
     D  Lines_Row      S              3S 0 Inz(0)                               ?Print Lines Charts
     D  Lines_Total    S              3S 0 Inz(0)                               ?Print Lines Total
     D  X              S              3S 0 Inz(0)                               ?Misc. Array Index
     D  Y              S              3S 0 Inz(0)                               ?Misc. Array Index
     D  Z              S              3S 0 Inz(0)                               ?Misc. Array Index
     D  QTY5           S                   Like(TRQTY5)                         ?
     D  QTY6           S                   Like(TRQTY6)                         ?

     D  LastStop       S                   Like(TRSTP#)                         ?Last Stop Processed
     D  StopCarts      S              2S 0 Inz(0)                               ?Carts At Stop
     D  TruckCarts     S              2S 0 Inz(0)                               ?Carts Scan on Truck
     D  CARTS          S              2S 0 Inz(0)                               ?Carts On Orders
     D  ROWS           S              2S 0 Inz(0)                               ?Rows On Orders
     D  CurrentRow     S              2S 0 Inz(0)                               ?Row being processed
     D  CARTSEQ        S              2S 0 Inz(0)                               ?Cart Seq In Order
     D  CurrentCart    S              2S 0 Inz(0)                               ?Cart in process
     D  SEQ1           S              2S 0 Inz(0)                               ?Seq# for Column 1
     D  SEQ2           S              2S 0 Inz(0)                               ?Seq# for Column 2
     D  SEQ3           S              2S 0 Inz(0)                               ?Seq# for Column 3
     D  SEQ4           S              2S 0 Inz(0)                               ?Seq# for Column 4

     D  COL1           S              1S 0 Inz(1)
     D  COL2           S              1S 0 Inz(1)
     D  COL3           S              1S 0 Inz(1)
     D  COL4           S              1S 0 Inz(1)
     D  COL5           S              1S 0 Inz(1)
     D  COL6           S              1S 0 Inz(1)

     D  HDG5           S                   Like(HDG4) Inz('N/A')
     D  HDG6           S                   Like(HDG4) Inz('OVRC')
     D  TOTAL5         S                   Like(TOTAL4)
     D  TOTAL6         S                   Like(TOTAL4)
     D  GTOTAL5        S                   Like(GTOTAL4)
     D  GTOTAL6        S                   Like(GTOTAL4)
     D  WkQty1         S                   Like(TRQTY1)
     D  WkQty2         S                   Like(TRQTY2)
     D  WkQty3         S                   Like(TRQTY3)
     D  WkQty4         S                   Like(TRQTY4)
     D  WkQty5         S                   Like(TRQTY5)
     D  WkQty6         S                   Like(TRQTY6)

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
    ?C                   Write     TRR56001F                                   ?
    ?C                   Write     MSGCTL                                       ?
    ?C                   ExFmt     TRR56001C                                    ?
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
    ?C                   Write     TRR56001C                                    ?

      *? Load the Subfile
     C                   Eval      *In28 = *On                                  ?Write w/ SFLNXTCHG
    ?C     SDateYMD7     SetLL     FTRHDRH1                                     ?
    ?C     SDateYMD7     ReadE     FTRHDRH1                                     ?

     C                   Z-add     *Zero         RRN01                          ?
     C                   DoW       not %EOF(FTRHDRH1)
     C                   Add       1             RRN01                          ?
     C*                  MoveL     THCOMM        SHCOMM
     C                   Eval      THSTOP = %Trim(THSTOP)
WJB  C                   Eval      WkQty1  = *Zero
WJB  C                   Eval      WkQty2  = *Zero
WJB  C                   Eval      WkQty3  = *Zero
WJB  C                   Eval      WkQty4  = *Zero
WJB  C                   Eval      WkQty5  = *Zero
WJB  C                   Eval      WkQty6  = *Zero
     C                   Eval      ORDERCOUNT = *Zero
     C                   Eval      CARTSCANS = *Zero

    ?C     DetailKey     SetLL     FTRSCHD
    ?C     DetailKey     ReadE     FTRSCHD
     C                   DoW       not %EOF(FTRSCHD)

     C                   Eval      ORDERCOUNT = ORDERCOUNT + 1

     C*                  IF        TRQTY6 <> 0
     C*                  Eval      TRQTY3 = TRQTY6
     C*                  IF        TRQTY6 = 99.9
     C*                  Eval      TRQTY3 = *Zero
     C*                  EndIf
     C*                  EndIf

     C                   If        TRQTY3 <> %Int(TRQTY3)
     C                   Eval      TRQTY3 = %Int(TRQTY3) + 1
     C                   EndIf

     C                   Eval      WkQty1  = WkQty1 + TRQTY(COL1)
     C                   Eval      WkQty2  = WkQty2 + TRQTY(COL2)
     C                   Eval      WkQty3  = WkQty3 + TRQTY(COL3)
     C                   Eval      WkQty4  = WkQty4 + TRQTY(COL4)
     C                   Eval      WkQty5  = WkQty5 + TRQTY(COL5)
     C                   Eval      WkQty6  = WkQty6 + TRQTY(COL6)

     C                   If        TRORD# <> 0
    ?C     TRORD#        SetLL     FCRTORDORD
    ?C     TRORD#        ReadE     FCRTORDORD
     C                   DoW       not %EOF(FCRTORDORD)
     C                   Eval      CARTSCANS = CARTSCANS + 1
    ?C     TRORD#        ReadE     FCRTORDORD
     C                   EndDo
     C                   EndIf

    ?C     DetailKey     ReadE     FTRSCHD
     C                   EndDo

     C                   Eval      Qty1  = WkQty1
     C                   Eval      Qty2  = WkQty2
     C                   Eval      Qty3  = WkQty3
     C                   Eval      Qty4  = WkQty4
     C                   Eval      Qty5  = WkQty5
     C                   Eval      Qty6  = WkQty6

      *?   Old Chart Size Method
    ?C                   Select
    ?C                   When      QTY3   <= 16
     C                   Eval      SChart =  16
    ?C                   When      QTY3   <= 20
     C                   Eval      SChart =  20
    ?C                   When      QTY3   <= 32
     C                   Eval      SChart =  32
    ?C                   When      QTY3   <= 36
     C                   Eval      SChart =  36
    ?C                   Other
     C                   Eval      SChart = 0
    ?C                   EndSL
      *?   New Chart Size Method
     C                   Eval      SChart =  20
     C                   If        %Subst(THTRK#:3:1) = 'T'
     C                   Eval      SChart =  32
     C*                  If        %Len(%Trim(%Subst(THTRK#:2:1))) = 1
     C                   If        %Int(%Trim(%Subst(THTRK#:1:2))) <= 7
     C                   Eval      SChart =  36
     C                   EndIf
     C*                  EndIf
     C                   EndIf

    ?C                   Write     TRR56001                                     ?
     C                   Eval      *In26 = *On                                  ?
    ?C     SDateYMD7     ReadE     FTRHDRH1                                     ?
     C                   EndDo                                                  ?

     C                   IF        *In26 = *On                                  ?
    ?C     RRN01         Chain     TRR56001                                     ?
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   Update    TRR56001                                     ?
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
    ?C                   ReadC     TRR56001
     C                   Eval      *In28 = *On
     C                   DoW       not %EOF(TRR560FM)

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
    ?C                   Update    TRR56001
     C                   Eval      *In51 = *Off
     C                   Eval      *In52 = *Off
    ?C                   ReadC     TRR56001
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
    ?C                   ExFmt     TRR56002                                     ?
     C                   ExSr      ClrError                                     ?
    ?C                   EndSr                                                  ?
      *?  ...........................................................
      *?  :      Load02 - Load Screen 02                            :
      *?  :.........................................................:
    ?C     Load02        BegSr                                                  ?

      *? Get the Current Default Printer
     C   41*Lock         In        TRR560DF
     C  N41*Lock         In        TRR560DP
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
     C   41              Unlock    TRR560DF
     C  N41              Unlock    TRR560DP
     C                   ExSr      Scrn01
      *? Check for Default Request
    ?C                   When      *In11 = *ON                                          ?
     C                   Eval      PRTToUse = PRTDefault
     C   41              Unlock    TRR560DF
     C  N41              Unlock    TRR560DP
     C                   ExSr      Scrn01
      *? When Default Printer Change is requested
    ?C                   When      *In13 = *ON
     C                   Eval      PRTDefault = PRTToUse
     C   41              Eval      FinishPRT  = PRTToUse
     C  N41              Eval      PlugsPRT   = PRTToUse
     C   41              Out       TRR560DF
     C  N41              Out       TRR560DP
     C                   Eval      $#MSGD = Pink + PRTDefault
     C   41              Eval      $#MSID = 'TRR5602'
     C  N41              Eval      $#MSID = 'TRR5605'
     C                   EXSR      SndError
     C                   ExSr      Scrn01                                       ?
      *? If no Functions, Check for Options and Re-display
    ?C                   OTHER                                                  ?
     C   41              Unlock    TRR560DF
     C  N41              Unlock    TRR560DP
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
     C                   Call      'TRR500'
     C                   Eval      UDSEXT = ' '

    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      PrintTruck - Print Chart for Selected Truck        :
      *?  :.........................................................:
    ?C     PrintTruck    BegSr                                                  ?

     C                   Eval      Lines_Header = 10
     C                   Eval      Lines_Orders = OrderCount + 2
     C                   Eval      Lines_Row    = *Zero
     C                   Eval      Lines_Row    = 6
     C                   Eval      Lines_Total  = *Zero
     C                   Eval      CurrentCART  = *Zero
     C                   Eval      CARTSEQ      = *Zeros

     C                   Clear                   STP#
     C                   Clear                   ORD#
     C                   Clear                   CART

     C                   SetOff                                       61  62
     C                   SetOff                                       63  64

     C*                  If        SChart <= 20
     C*                  Eval      *In40 = *On
     C*                  Eval      *In42 = *On
     C*                  Eval      *In43 = *On
     C*                  Eval      Lines_Row    = 8
     C*                  Else
     C*                  Eval      *In40 = *Off
     C*                  Eval      *In42 = *Off
     C*                  Eval      *In43 = *Off
     C*                  Eval      Lines_Row    = 6
     C*                  EndIf

     C                   Eval      Lines_Total = Lines_Header +
     C                             Lines_Orders               +
     C                             ((SChart / 4 ) * Lines_Row)

     C                   If        not %Open(TRR560P)
     C                   If        Lines_Total <= 60
     C                   Eval      Command = Cmd(1)                             ?Short Paper 8.5x11
     C                   ExSr      $Command
     C                   Else
     C                   Eval      Command = Cmd(2)                             ?Long Paper  8.5x14
     C                   ExSr      $Command
     C                   EndIf
    ?C                   Open      TRR560P
     C                   EndIf

    ?C                   Write     Header
    ?C     DetailKey     SetLL     FTRSCHD
    ?C     DetailKey     ReadE     FTRSCHD
     C                   Eval      SSTOP# = *Zero
     C                   Eval      TOTAL1 = *Zero
     C                   Eval      TOTAL2 = *Zero
     C                   Eval      TOTAL3 = *Zero
     C                   Eval      TOTAL4 = *Zero
     C                   Eval      GTOTAL1 = *Zero
     C                   Eval      GTOTAL2 = *Zero
     C                   Eval      GTOTAL3 = *Zero
     C                   Eval      GTOTAL4 = *Zero
     C                   Eval      GTOTAL5 = *Zero
     C                   Eval      GTOTAL6 = *Zero

     C                   DoW       not %EOF(FTRSCHD)

      /Free
       TRCSTM = customFlag(TRORD#);
      /End-Free

     C                   Eval      SSTOP# = SSTOP# + 1
     C                   Eval      TOTAL1 = TRQTY(COL1)
     C                   Eval      TOTAL2 = TRQTY(COL2)

     C                   If        TRQTY(COL3) <> %Int(TRQTY(COL3))
     C                   Eval      TRQTY(COL3) = %Int(TRQTY(COL3)) + 1
     C                   EndIf

     C                   Eval      TOTAL3 = TRQTY(COL3)
     C                   Eval      TOTAL4 = TRQTY(COL4)
     C                   Eval      TOTAL5 = TRQTY(COL5)
     C                   Eval      TOTAL6 = TRQTY(COL6)
     C*                  IF        TOTAL6 <> 0
     C* wjb              Eval      TOTAL3 = QTY6
     C*                  Eval      TOTAL3 = TOTAL6
     C*                  IF        TOTAL6 = 99
     C*                  Eval      TOTAL3 = *Zero
     C*                  EndIf
     C*                  EndIf

     C                   Eval      GTOTAL1 = GTOTAL1 + TOTAL1
     C                   Eval      GTOTAL2 = GTOTAL2 + TOTAL2
     C                   Eval      GTOTAL3 = GTOTAL3 + TOTAL3
     C                   Eval      GTOTAL4 = GTOTAL4 + TOTAL4
     C                   Eval      GTOTAL5 = GTOTAL5 + TOTAL5
     C                   Eval      GTOTAL6 = GTOTAL6 + TOTAL6

     C                   Eval      *In98 = *Off
    ?C     TRORD#        SetLL     FCRTORDORD                             98
    ?C     TRORD#        ReadE     FCRTORDORD
     C                   Eval      CartCount = *Zero
     C                   Dow       not %EOF(FCRTORDORD)
     C                   Eval      CartCount = CartCount + 1
    ?C     TRORD#        ReadE     FCRTORDORD
     C                   EndDo

    ?C     TRCUST        Chain     FMCUST
     C                   If        not %Found(FMCUST)
     C                   Clear                   RMCUST
     C                   EndIf
     C                   MoveL     CMNAME        RMNAME
     C                   MoveL     CMCITY        RMCITY
    ?C     TRORD#        Chain     FHORDR
     C                   If        %Found(FHORDR)
     C                   MoveL     OHNAME        RMNAME
     C                   Eval      RMCITY = OHSHCT
     C                   Eval      CMSTST = OHSHST
     C                   EndIf

     C                   If        TRSTP# <> LastStop
     C                   Eval      LastStop = TRSTP#
     C                   Eval      CARTSEQ = *Zeros
     C                   If        CartCount = *Zeros
     C                   Eval      StopCarts = TOTAL3
     C                   Else
     C                   Eval      StopCarts = CartCount
     C                   EndIf
     C                   Else
     C                   If        CartCount = *Zeros
     C                   Eval      StopCarts = StopCarts + TOTAL3
     C                   Else
     C                   Eval      StopCarts = StopCarts + CartCount
     C                   EndIf
     C                   EndIf
    ?C     TRORD#        SetLL     FCRTORDORD
     C                   If        %Equal(FCRTORDORD)
    ?C     TRORD#        READE     FCRTORDORD
     C                   DoW       not %EOF(FCRTORDORD)
     C     COCART        Lookup    CART                                   97
     C                   If        not %Found
     C                   Eval      CurrentCART        = CurrentCART + 1
     C                   Eval      CARTSEQ            = CARTSEQ     + 1
     C                   Eval      STP#(CurrentCART)  = TRSTP#
     C                   Eval      NAME(CurrentCART)  =
     C                                 $Center( RMNAME: %Len( %Trim(RMNAME) ) )
     C                   Eval      ORD#(CurrentCART)  = TRORD#
     C                   Eval      CSTM(CurrentCART)  = customFlag(TRORD#)
     C                   Eval      CSEQ(CurrentCART)  = CARTSEQ
     C                   Eval      CART(CurrentCART)  = COCART
     C                   EndIf
    ?C     TRORD#        READE     FCRTORDORD
     C                   EndDo
     C                   Else
     C                   DoW       CARTSEQ < StopCarts
     C                   Eval      CurrentCART        = CurrentCART + 1
     C                   Eval      CARTSEQ            = CARTSEQ     + 1
     C                   Eval      STP#(CurrentCART)  = TRSTP#
     C                   Eval      NAME(CurrentCART)  =
     C                                 $Center( RMNAME: %Len( %Trim(RMNAME) ) )
     C                   Eval      ORD#(CurrentCART)  = TRORD#
     C                   Eval      CSTM(CurrentCART)  = customFlag(TRORD#)
     C                   Eval      CSEQ(CurrentCART)  = CARTSEQ
     C                   Eval      CART(CurrentCART)  = *Zeros
     C                   EndDo
     C                   EndIf

    ?C                   Write     Detail
     C                   Eval      Sav_TRSTP# = TRSTP#
    ?C     DetailKey     ReadE     FTRSCHD
     C                   If        TRSTP# <> Sav_TRSTP#
    ?C                   Write     UNDLINREC
     C                   EndIf
     C                   EndDo
    ?C                   Write     Footer1

     C                   If        SSTOP# >= 10
     C                   Eval      *In42 = *off
     C                   If        SSTOP# >= 15
     C                   Eval      *In43 = *off
     C                   EndIF
     C                   EndIF

     C                   If        %Int(CurrentCART / 4) <> CurrentCART / 4
     C                   Eval      ROWS = (CurrentCART / 4) + 1
     C                   Else
     C                   Eval      ROWS = (CurrentCART / 4)
     C                   EndIf

     C                   Eval      PrtChart = 0
     C                   Eval      CurrentRow = 0
     C                   DoW       PrtChart < SChart or
     C                             PrtChart < CurrentCart

     C                   Eval      CurrentRow = CurrentRow + 1
     C                   Eval      Seq1 = (ROWS - CurrentRow + 1 )
     C                   Eval      Seq2 = Seq1 + ROWS
     C                   Eval      Seq3 = Seq2 + ROWS
     C                   Eval      Seq4 = Seq3 + ROWS

      *?   Initialize Chart Boxes
     C                   Clear                   STOP_AD
     C                   Clear                   STOP_BD
     C                   Clear                   STOP_CD
     C                   Clear                   STOP_DD

     C                   Clear                   ORD#_AD
     C                   Clear                   ORD#_BD
     C                   Clear                   ORD#_CD
     C                   Clear                   ORD#_DD

     C                   Clear                   CSTM_AD
     C                   Clear                   CSTM_BD
     C                   Clear                   CSTM_CD
     C                   Clear                   CSTM_DD

     C                   Clear                   CART_AD
     C                   Clear                   CART_BD
     C                   Clear                   CART_CD
     C                   Clear                   CART_DD

     C                   If        Seq1 >= 1
      *?   Load First Order
     C                   Eval      STOP_A1 = STP#(Seq1)
     C                   Eval      STOP_B1 = STP#(Seq2)
     C                   Eval      STOP_C1 = STP#(Seq3)
     C                   Eval      STOP_D1 = STP#(Seq4)

     C                   Eval      ORD#_A1 = ORD#(Seq1)
     C                   Eval      ORD#_B1 = ORD#(Seq2)
     C                   Eval      ORD#_C1 = ORD#(Seq3)
     C                   Eval      ORD#_D1 = ORD#(Seq4)

     C                   Eval      CSTM_A1 = CSTM(Seq1)
     C                   Eval      CSTM_B1 = CSTM(Seq2)
     C                   Eval      CSTM_C1 = CSTM(Seq3)
     C                   Eval      CSTM_D1 = CSTM(Seq4)

     C                   Eval      CART_A1 = CART(Seq1)
     C                   Eval      CART_B1 = CART(Seq2)
     C                   Eval      CART_C1 = CART(Seq3)
     C                   Eval      CART_D1 = CART(Seq4)

      *?   Check Each Cart for additional Orders
    ?C     TRKKEY        KList                                                  ?
    ?C                   KFld                    TRTRK#
    ?C                   KFld                    COORD#
    ?C                   KFld                    THSHDT
    ?C     CART_A1       SetLL     FCRTORDCRT
    ?C     CART_A1       ReadE     FCRTORDCRT
     C                   Eval      x = 6
     C                   DoW       not %EOF(FCRTORDCRT)
     C                   If        COORD# <> ORD#_A1
     C                   Eval      x = x - 1
     C                   Eval      ORD#_A(x) = COORD#
     C                   Eval      CSTM_A(x) = customFlag(COORD#)
     C                   Eval      CART_A(x) = COCART
    ?C     TRKKEY        Chain     FTRSCHDTO
     C                   Eval      STOP_A(x) = TRSTP#
     C                   EndIf
    ?C     CART_A1       ReadE     FCRTORDCRT
     C                   EndDo

    ?C     CART_B1       SetLL     FCRTORDCRT
    ?C     CART_B1       ReadE     FCRTORDCRT
     C                   Eval      x = 6
     C                   DoW       not %EOF(FCRTORDCRT)
     C                   If        COORD# <> ORD#_B1
     C                   Eval      x = x - 1
     C                   Eval      ORD#_B(x) = COORD#
     C                   Eval      CSTM_B(x) = customFlag(COORD#)
     C                   Eval      CART_B(x) = COCART
    ?C     TRKKEY        Chain     FTRSCHDTO
     C                   Eval      STOP_B(x) = TRSTP#
     C                   EndIf
    ?C     CART_B1       ReadE     FCRTORDCRT
     C                   EndDo

    ?C     CART_C1       SetLL     FCRTORDCRT
    ?C     CART_C1       ReadE     FCRTORDCRT
     C                   Eval      x = 6
     C                   DoW       not %EOF(FCRTORDCRT)
     C                   If        COORD# <> ORD#_C1
     C                   Eval      x = x - 1
     C                   Eval      ORD#_C(x) = COORD#
     C                   Eval      CSTM_C(x) = customFlag(COORD#)
     C                   Eval      CART_C(x) = COCART
    ?C     TRKKEY        Chain     FTRSCHDTO
     C                   Eval      STOP_C(x) = TRSTP#
     C                   EndIf
    ?C     CART_C1       ReadE     FCRTORDCRT
     C                   EndDo

    ?C     CART_D1       SetLL     FCRTORDCRT
    ?C     CART_D1       ReadE     FCRTORDCRT
     C                   Eval      x = 6
     C                   DoW       not %EOF(FCRTORDCRT)
     C                   If        COORD# <> ORD#_D1
     C                   Eval      x = x - 1
     C                   Eval      ORD#_D(x) = COORD#
     C                   Eval      CSTM_D(x) = customFlag(COORD#)
     C                   Eval      CART_D(x) = COCART
    ?C     TRKKEY        Chain     FTRSCHDTO
     C                   Eval      STOP_D(x) = TRSTP#
     C                   EndIf
    ?C     CART_D1       ReadE     FCRTORDCRT
     C                   EndDo

     C                   EndIf                                                  Seq1 >= 1

      *?   Move all Stops to Top of Box
     C                   Eval      x = 1
     C                   DoW       ORD#_A(1) = *Zeros and X < 6
     C     1             Do        5             y
     C                   Eval      STOP_A(y) = STOP_A(y+1)
     C                   Eval      ORD#_A(y) = ORD#_A(y+1)
     C                   Eval      CSTM_A(y) = CSTM_A(y+1)
     C                   Eval      CART_A(y) = CART_A(y+1)
     C                   EndDo     1
     C                   Eval      STOP_A(6) = *Zeros
     C                   Eval      ORD#_A(6) = *Zeros
     C                   Eval      CSTM_A(6) = *Blanks
     C                   Eval      CART_A(6) = *Zeros
     C                   Eval      x = x + 1
     C                   EndDo
     C                   If        STOP_A(1) = *Zeros
     C                   Eval      *In61 = *On
     C                   EndIf

     C                   Eval      x = 1
     C                   DoW       ORD#_B(1) = *Zeros and X < 6
     C     1             Do        5             y
     C                   Eval      STOP_B(y) = STOP_B(y+1)
     C                   Eval      ORD#_B(y) = ORD#_B(y+1)
     C                   Eval      CSTM_B(y) = CSTM_B(y+1)
     C                   Eval      CART_B(y) = CART_B(y+1)
     C                   EndDo     1
     C                   Eval      STOP_B(6) = *Zeros
     C                   Eval      ORD#_B(6) = *Zeros
     C                   Eval      CSTM_B(6) = *Blanks
     C                   Eval      CART_B(6) = *Zeros
     C                   Eval      x = x + 1
     C                   EndDo
     C                   If        STOP_B(1) = *Zeros
     C                   Eval      *In62 = *On
     C                   EndIf

     C                   Eval      x = 1
     C                   DoW       ORD#_C(1) = *Zeros and X < 6
     C     1             Do        5             y
     C                   Eval      STOP_C(y) = STOP_C(y+1)
     C                   Eval      ORD#_C(y) = ORD#_C(y+1)
     C                   Eval      CSTM_C(y) = CSTM_C(y+1)
     C                   Eval      CART_C(y) = CART_C(y+1)
     C                   EndDo     1
     C                   Eval      STOP_C(6) = *Zeros
     C                   Eval      ORD#_C(6) = *Zeros
     C                   Eval      CSTM_C(6) = *Blanks
     C                   Eval      CART_C(6) = *Zeros
     C                   Eval      x = x + 1
     C                   EndDo
     C                   If        STOP_C(1) = *Zeros
     C                   Eval      *In63 = *On
     C                   EndIf

     C                   Eval      x = 1
     C                   DoW       ORD#_D(1) = *Zeros and X < 6
     C     1             Do        5             y
     C                   Eval      STOP_D(y) = STOP_D(y+1)
     C                   Eval      ORD#_D(y) = ORD#_D(y+1)
     C                   Eval      CSTM_D(y) = CSTM_D(y+1)
     C                   Eval      CART_D(y) = CART_D(y+1)
     C                   EndDo     1
     C                   Eval      STOP_D(6) = *Zeros
     C                   Eval      ORD#_D(6) = *Zeros
     C                   Eval      CSTM_D(6) = *Blanks
     C                   Eval      CART_D(6) = *Zeros
     C                   Eval      x = x + 1
     C                   EndDo
     C                   If        STOP_D(1) = *Zeros
     C                   Eval      *In64 = *On
     C                   EndIf



    ?C                   Write     UNDLINBOX
    ?C                   Write     NEWCHART

     C                   SetOff                                       61  62
     C                   SetOff                                       63  64

     C                   Eval      PrtChart = PrtChart + 4
     C                   EndDo
    ?C                   Write     UNDLINBOX
    ?C                   Write     Footer2
     C                   If        %Open(TRR560P)
    ?C                   Close     TRR560P
     C                   EndIf

     C
    ?C   99              Write     Chart
    ?C                   EndSr                                                  ?

      *?  ...........................................................
      *?  :      PrintAll - Print all Truck Charts                  :
      *?  :.........................................................:
    ?C     PrintAll      BegSr                                                  ?

     C                   ReadC     TRR56001
     C                   DoU       %EOF(TRR560FM)
     C                   If        THTRK# <> *Blanks
     C                   ExSr      PrintTruck
     C                   EndIf
     C                   ReadC     TRR56001
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

     C                   Eval      *In99 = *Off

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
     C   41              In        TRR560DF
     C  N41              In        TRR560DP
     C   41              Eval      PRTDefault = FinishPRT
     C  N41              Eval      PRTDefault = PlugsPRT
     C                   Eval      PRTToUse = PRTDefault

     C     01            CHAIN     FOECTL                             90
     C                   MOVEL     OCHDG1        HDG1
     C                   MOVEL     OCHDG2        HDG2
     C                   MOVEL     OCHDG3        HDG3
     C                   MOVEL     OCHDG4        HDG4
WJB  C                   MOVEL     'N/A'         HDG5              4
WJB  C                   MOVEL     'N/A'         HDG6              4            #6 Override Carts

WJB  C                   Eval      COL1 = 1
WJB  C                   Eval      COL2 = 1
WJB  C                   Eval      COL3 = 1
WJB  C                   Eval      COL4 = 1
WJB  C                   Eval      COL5 = 5
WJB  C                   Eval      COL6 = 6

WJB  C     HDG1          LOOKUP    CATEG(COL1)                            33
WJB  C     HDG2          LOOKUP    CATEG(COL2)                            34
WJB  C     HDG3          LOOKUP    CATEG(COL3)                            35
WJB  C     HDG4          LOOKUP    CATEG(COL4)                            36
WJB  C*    HDG5          LOOKUP    CATEG(COL5)                            37
WJB  C*    HDG6          LOOKUP    CATEG(COL6)                            38
     C                   Eval      BLNKLINE = Rpt(1)
     C                   Eval      BOXWALLS1 = Rpt(2)
     C                   Eval      BOXWALLS2 = Rpt(2)
     C                   Eval      BOXWALLS3 = Rpt(2)
     C                   Eval      BOXWALLS4 = Rpt(2)
     C                   Eval      BOXWALLS5 = Rpt(2)
     C                   Eval      BOXWALLS6 = Rpt(2)
     C                   Eval      BOXWALLS7 = Rpt(2)
     C                   Eval      BOXWALLS8 = Rpt(2)
     C                   Eval      STOPLINE = Rpt(3)
     C                   Eval      CUSTLINE = Rpt(4)
     C                   Eval      ORD#LINE = Rpt(5)
     C                   Eval      CARTLINE = Rpt(6)


     C                   ExSr      Load01                                       ?
     C                   ExSr      Scrn01                                       ?

     C     DetailKey     KList
     C                   KFld                    THTRK#
     C                   KFld                    THSHDT

    ?C                   EndSr                                                  ?
      /free
        dcl-proc customFlag;
          dcl-pi *n char(1);
            order# packed(6:0) const;
          END-PI;
          dcl-s cstm char(1);

           CSTM = *Blanks;
           Exec SQL
             Select 'C' into :CSTM from FHORDRCSTM where COORD# = :order#
               Fetch First Row Only;

           return cstm;

        END-PROC;
      /end-free
**
OVRPRTF FILE(TRR560P) PAGESIZE(14 8.5 *UOM) FORMTYPE(*LONG) OVRSCOPE(*JOB) PAGRTT(0) OUTQ(|P
OVRPRTF FILE(TRR560P) PAGESIZE(14 8.5 *UOM) FORMTYPE(*LONG) OVRSCOPE(*JOB) PAGRTT(0) OUTQ(|P
** HDG NAMES
PLUG
FLAT
CART
HBPT
POIN
OVRC
** RPT.. 1 ...+... 2 ...+... 3 ...+... 4 ...+... 5 ...+... 6 ...+... 7 ...+... 8 ...+... 9 ...+... 0

|                      |                      |                      |                      |
| Stop # ____________  | Stop # ____________  | Stop # ____________  | Stop # ____________  |
|                      |                      |                      |                      |
|   Order #            |   Order #            |   Order #            |   Order #            |
| Cart(  ) #_________  | Cart(  ) #_________  | Cart(  ) #_________  | Cart(  ) #_________  |
