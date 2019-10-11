    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *??:````````````````````````````````````````````````````````````:?
      *??:     Assign People to Apply Chemicals                       :?
      *??:............................................................:?
      *? :````````````````````````````````````````````````````````````:
      *? : Created:  Dec. 2004            ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :````````````````````````````````````````````````````````````:
      *? :?  Program Description                                     ?:
      *? :                                                           ?:
      *? :   This program replaces CHR060.  This program allows      ?:
      *? : the growers to make Chem. Application Assignments to the  ?:
      *? : people spraying.                                          ?:
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

     FMOV502FM  CF   E             WORKSTN
     F                                     SFILE(MOV50201S:SFLRRN01)
     F                                     SFILE(MOV50204S:SFLRRN04)
     F                                     SFILE(MOV50205S:SFLRRN05)
     FFMINVT    IF   E           K DISK
     FFMOVTO    UF A E           K DISK
     FFMOVDFT   UF A E           K DISK
     FFMOVDFTUS IF   E           K DISK    RENAME(RMOVDFT:MOVDFTUS)
     FFMOVDEST  UF   E           K DISK
     FFMOVDESTNMIF   E           K DISK    RENAME(RMOVDEST:MOVDESTNM)
     FFMOVJBL0A IF   E           K DISK

      *? Function Prototypes
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Date7
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Monday
    ?D/COPY QFunctDefn,$AddDate
    ?D/COPY QFunctDefn,$ChgPrt
    ?D/COPY QFunctDefn,$DftPrt
    ?D/COPY QFunctDefn,$Command

      *? Data Structures
     D                SDS                                                       ?
     D    ProgID         *PROC                                                  ?Program Name

     D  BtnsDS         DS                                                       ?
     D    Dest01                                                                ?Destination 01
     D    Dest02                                                                ?Destination 02
     D    Dest03                                                                ?Destination 03
     D    Dest04                                                                ?Destination 04
     D    Dest05                                                                ?Destination 05
     D    Dest06                                                                ?Destination 06
     D    Dest07                                                                ?Destination 07
     D    Dest08                                                                ?Destination 08
     D    Dest09                                                                ?Destination 09
     D    Dest10                                                                ?Destination 10
     D    Dest11                                                                ?Destination 11
     D    Dest12                                                                ?Destination 12
     D    Dest13                                                                ?Destination 13
     D    Dest14                                                                ?Destination 14
     D    Dest15                                                                ?Destination 15
     D    Dest16                                                                ?Destination 16
     D    Dest17                                                                ?Destination 17
     D    Dest18                                                                ?Destination 18
     D    Dest19                                                                ?Destination 19
     D    Dest20                                                                ?Destination 20
     D    Dest21                                                                ?Destination 21
     D    Dest22                                                                ?Destination 22
     D    Dest23                                                                ?Destination 23
     D    Dest24                                                                ?Destination 24
     D    Dest25                                                                ?Destination 25
     D    Dest26                                                                ?Destination 26
     D    Dest27                                                                ?Destination 27
     D    Dest28                                                                ?Destination 28
     D    Dest29                                                                ?Destination 29
     D    Dest30                                                                ?Destination 30
     D    Dest31                                                                ?Destination 31
     D    Dest32                                                                ?Destination 32
     D    Dest33                                                                ?Destination 33
     D    Dest34                                                                ?Destination 34
     D    Dest35                                                                ?Destination 35
     D    Dest36                                                                ?Destination 36
     D    Dest37                                                                ?Destination 03
     D    Dest38                                                                ?Destination 38
     D    Dest39                                                                ?Destination 39
     D    Dest40                                                                ?Destination 40
     D    Dest41                                                                ?Destination 41
     D    Dest42                                                                ?Destination 42
     D    Dest43                                                                ?Destination 43
     D    Dest44                                                                ?Destination 44
     D    Dest45                                                                ?Destination 45
     D    Dest46                                                                ?Destination 46
     D    Dest47                                                                ?Destination 47
     D    Dest48                                                                ?Destination 48
     D    Dest49                                                                ?Destination 49
     D    Dest50                                                                ?Destination 50
     D  ButtonText                         Like(Dest01) Dim(50) OverLay(BtnsDS) ?Destinations

      *? Array Definitions
     D  ButtonDestID   S                   Like(Destin#) Dim(50)                ?Destinations
     D  $CMD_CMD       S            100A   Dim(1) CtData PerRcd(1)              ?Destinations

      *? Field Definitions
     D  UserID         S             10A                                        ?
     D  Today          S              6S 0                                      ?
     D  Screen         S              3S 0                                      ?Current Screen
     D  LastScreen     S              3S 0                                      ?Previous Screen
     D  Monday         S               D                                        ?
     D  ThisMonday     S               D                                        ?
     D  MondayCYMD     S              7S 0                                      ?
     D  SflRRN01       S              4S 0                                      ?Subfile RRN Scrn01
     D  SflRRN04       S              4S 0                                      ?Subfile RRN Scrn04
     D  SflRRN05       S              4S 0                                      ?Subfile RRN Scrn05
     D  RRN            S                   Like(SflRRN01)                       ?Loop Counter for SF
     D  X              S              5S 0                                      ?Generic Counter Fld
     D  Hold#          S                   Like(Destin#  )                      ?Hold for Destin#
     D  Hold@          S                   Like(Destin   )                      ?Hold for Destin
     D  HoldP          S                   Like(DestinPct)                      ?Hold for %Used
     D  ButtonScreen   S              1S 0                                      ?
     D  Button         S              2S 0                                      ?
     D  Dest           S                   LIKE(DESTID)
     D  savMOVEDATE    S                   LIKE(MOVEDATE)
     D  savMOVE#       S                   LIKE(MOVE#)

      *? Indicators
     D  UseTot         S               N                                        ?
     D  UseApp         S               N                                        ?
     D  PriorAssign    S               N                                        ?
     D  UpdateMode     S               N                                        ?

    ? /Eject
      /Free
    ?   /COPY QFunctDefn,LASTUSEDCB
      /End-Free
      *?  ...........................................................
      *?  :              C A L C U L A T I O N S                    :
      *?  :.........................................................:

     C                   DoW       *InLR <> *On
    ?C                   Select
    ?C     Screen        WhenEq    01
     C                   ExSr      Edit01
    ?C     Screen        WhenEq    02
     C                   ExSr      Edit02
    ?C     Screen        WhenEq    03
     C                   ExSr      Edit03
    ?C     Screen        WhenEq    04
     C                   ExSr      Edit04
    ?C     Screen        WhenEq    05
     C                   ExSr      Edit05
    ?C                   Other
     C                   Eval      *InLR = *On
    ?C                   EndSL
     C                   EndDo


    ? /Eject
      *?  ...........................................................
      *?  :      Load01   - Load Screen 01                          :
      *?  :.........................................................:

     C     Load01        BegSr

     C                   Eval      savMOVEDATE = MOVEDATE
     C                   Eval      savMOVE#    = MOVE#
     C                   Eval      SflPosTo1 = 1
      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?Subfile Display
     C                   Eval      *In26 = *Off                                 ?Subfile No Records
     C                   Eval      *In27 = *Off                                 ?Subfile End
     C                   Eval      SflRRN01 = 0
    ?C                   Write     MOV50201C

     C                   Eval      SflRcds1 = *Zero

      *? Get the Job Records
     C                   Eval      SflRcds1 = *Zero
    ?C     kFMOVJBL0A    KList
    ?C                   KFld                    MoveDate
    ?C                   KFld                    Move#
    ?C*    *LoVal        SetLL     FMOVJBL0A
    ?C     kFMOVJBL0A    SetLL     FMOVJBL0A
    ?C*                  Read      FMOVJBL0A
    ?C     kFMOVJBL0A    ReadE     FMOVJBL0A

     C                   DoW       not %Eof(FMOVJBL0A)

     C                   Clear                   MOV50201S
    ?C     ItemKey       Chain     FMINVT
     C                   Eval      ITEM5   = MJITEM
     C                   Eval      DESC15  = IMDES1
     C                   Eval      JOB#    = MJJOB#
     C                   Eval      SIZE    = MJSIZE
     C                   Eval      GH      = MJHSE
     C                   Eval      SECTION = MJSECT
     C                   Eval      BAY     = MJBAY
     C                   Eval      NORS    = MJNOS
     C                   Eval      POLE    = MJSPOL
     C                   Eval      LORR    = MJSLOR

      *? Calculate Poles and Trays
     C                   If        MJTRAY = 0 and MJPOLE <> 0
     C                   Eval      TRAYS = MJPOLE * 55
     C                   Else
     C                   Eval      TRAYS   = MJTRAY
     C                   EndIf
     C                   If        MJPOLE = 0 and MJTRAY <> 0
     C                   Eval      POLES = MJTRAY / 55
     C                   Else
     C                   Eval      POLES   = MJPOLE
     C                   EndIf

      *? Get Default or Previously Assigned Move Destinations
    ?C     MovToKey      SetLL     FMOVTO
     C                   If        not %Equal(FMOVTO)
     C                   Eval      PriorAssign = *Off
     C                   ExSr      GetDefault
     C                   Else
     C                   Eval      PriorAssign = *On
     C                   ExSr      GetDefault
    ?C                   Read(N)   FMOVTO
    ?C     M2DSID        Chain(N)  FMOVDEST
     C                   If        DESNAM = ALTDEST
     C*                  ExSr      SwapDest
     C                   Eval      Hold#      = Destin#
     C                   Eval      Hold@      = Destin
     C                   Eval      HoldP      = DestinPct
     C                   Eval      Destin#    = AltDest#
     C                   Eval      Destin     = AltDest
     C                   Eval      DestinPct  = AltDestPct
     C                   Eval      AltDest#   = Hold#
     C                   Eval      AltDest    = Hold@
     C                   Eval      AltDestPct = HoldP
     C                   EndIf
     C                   Eval      DESTIN  = DESNAM
     C                   Eval      DESTIN# = DESTID
    ?C     DFTLOCKEY     Chain     FMOVDFTUS
     C                   If        %Found(FMOVDFTUS)
     C                   Eval      DESTINPCT = DFPCTU
     C                   Else
     C                   Eval      DESTINPCT = 0
     C                   EndIF
     C                   EndIF

     C                   Eval      *In26 = *On                                  ?Subfile Has Records
     C                   Eval      SflRRN01 = SflRRN01 + 1
    ?C*                  Read      FMOVJBL0A
    ?C     kFMOVJBL0A    ReadE     FMOVJBL0A
     C                   If        %Found(FMOVJBL0A)
     C                   Eval      *In27 = *Off                                 ?SFLEND Indicator
     C                   Else
     C                   Eval      *In27 = *On                                  ?SFLEND Indicator
     C                   EndIf
     C                   ExSr      Colors

    ?C                   Write     MOV50201S
     C                   Eval      SflRcds1 = SflRcds1 + 1
     C                   EndDo

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Load02   - Load Screen 02                          :
      *?  :.........................................................:

     C     Load02        BegSr

      *? Clear the Button Values
     C                   Clear                   ButtonText
     C                   Clear                   ButtonDestID
      *? Load the Button Values
     C                   Eval      ButtonScreen = 1
     C                   Eval      Button = *Zero
    ?C     *LoVal        SetLL     FMOVDESTNM
    ?C                   Read(N)   FMOVDESTNM

     C                   DoW       not %Eof(FMOVDESTNM)

     C                   Eval      Button = Button + 1
     C                   Eval      ButtonText(Button) = DesNam
     C                   Eval      ButtonDestID(Button) = DestID
    ?C                   Read(N)   FMOVDESTNM
     C                   EndDo

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Load04   - Load Screen 04                          :
      *?  :.........................................................:

     C     Load04        BegSr

     C                   Eval      SflPosTo4 = 1
      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?Subfile Display
     C                   Eval      *In31 = *Off                                 ?Subfile No Records
     C                   Eval      *In32 = *Off                                 ?Subfile End
     C                   Eval      SflRRN04 = 0
    ?C                   Write     MOV50204C

     C                   Eval      SflRcds4 = *Zero

      *? Get all Destinations
    ?C     *LoVal        SetLL     FMOVDESTNM
    ?C                   Read(N)   FMOVDESTNM

     C                   DoW       not %Eof(FMOVDESTNM)

     C                   Eval      S4DESTID = DESTID
     C                   Eval      S4DESNAM = DESNAM
     C                   Eval      S4DESDSC = DESDSC
     C                   Eval      S4DESLOC = DESLOC

     C                   Eval      *In31 = *On                                  ?Subfile Has Records
     C                   Eval      SflRRN04 = SflRRN04 + 1
    ?C                   Read(N)   FMOVDESTNM
     C                   If        not %EOF(FMOVDESTNM)
     C                   Eval      *In32 = *Off                                 ?SFLEND Indicator
     C                   Else
     C                   Eval      *In32 = *On                                  ?SFLEND Indicator
     C                   EndIf

    ?C                   Write     MOV50204S
     C                   Eval      SflRcds4 = SflRcds4 + 1
     C                   EndDo

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Load05   - Load Screen 05                          :
      *?  :.........................................................:

     C     Load05        BegSr

     C                   Eval      SflPosTo5 = 1
      *? Clear the Subfile
     C                   Eval      *In25 = *Off                                 ?Subfile Display
     C                   Eval      *In33 = *Off                                 ?Subfile No Records
     C                   Eval      *In34 = *Off                                 ?Subfile End
     C                   Eval      SflRRN05 = 0
    ?C                   Write     MOV50205C

     C                   Eval      SflRcds5 = *Zero

      *? Get all Destinations
    ?C     DFTLOCKEY     SetLL     FMOVDFTUS
    ?C     DFTLOCKEY     ReadE(N)  FMOVDFTUS

     C                   DoW       not %Eof(FMOVDFTUS)

     C                   Eval      S5DFUSED = DFUSED
     C                   Eval      S5DFPCTU = DFPCTU
    ?C     DFDSID        Chain(N)  FMOVDEST
     C                   Eval      S5DESTID = DESTID
     C                   Eval      S5DESNAM = DESNAM
     C                   Eval      S5DESDSC = DESDSC

     C                   Eval      *In33 = *On                                  ?Subfile Has Records
     C                   Eval      SflRRN05 = SflRRN05 + 1
    ?C     DFTLOCKEY     ReadE(N)  FMOVDFTUS
     C                   If        not %EOF(FMOVDFTUS)
     C                   Eval      *In34 = *Off                                 ?SFLEND Indicator
     C                   Else
     C                   Eval      *In34 = *On                                  ?SFLEND Indicator
     C                   EndIf

    ?C                   Write     MOV50205S
     C                   Eval      SflRcds5 = SflRcds5 + 1
     C                   EndDo

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Scrn01   - Display Screen 01                       :
      *?  :.........................................................:

     C     Scrn01        BegSr

     C                   Eval      LastScreen =  Screen                         ?Previous Screen
     C                   Eval      Screen = 01                                  ?Screen  Number

     C                   If        *In26 = *off
    ?C                   Write     MOV50201N
     C                   Else
    ?C                   Write     MOV50201F
     C                   EndIf
     C                   Eval      *In25 = *On                                  ?SubFile Display
    ?C                   ExFmt     MOV50201C
     C                   Eval      *In25 = *Off                                 ?
     C                   If        SFLCSRRRN1 > 0
     C                   Eval      SFLPOSTO1 = SFLCSRRRN1
     C                   EndIf

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Scrn02   - Display Screen 02                       :
      *?  :.........................................................:

     C     Scrn02        BegSr

     C                   Eval      LastScreen =  Screen                         ?Previous Screen
     C                   Eval      Screen = 02                                  ?Screen  Number

     C                   If        UpdateMode
     C                   Eval      *In49 = *On
     C                   Else
     C                   Eval      *In49 = *Off
     C                   EndIf
    ?C     SFLCSRRRN1    Chain     MOV50201S
    ?C                   ExFmt     MOV50202

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Scrn03   - Display Screen 03                       :
      *?  :.........................................................:

     C     Scrn03        BegSr

     C                   Eval      LastScreen =  Screen                         ?Previous Screen
     C                   Eval      Screen = 03                                  ?Screen  Number

    ?C                   ExFmt     MOV50203

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Scrn04   - Display Screen 04                       :
      *?  :.........................................................:

     C     Scrn04        BegSr

     C                   Eval      LastScreen =  Screen                         ?Previous Screen
     C                   Eval      Screen = 04                                  ?Screen  Number

    ?C                   Write     MOV50204F
     C                   Eval      *In25 = *On                                  ?SubFile Display
    ?C                   ExFmt     MOV50204C
     C                   Eval      *In25 = *Off                                 ?
     C                   If        SFLCSRRRN4 > 0
     C                   Eval      SFLPOSTO4 = SFLCSRRRN4
     C                   EndIf

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Scrn05   - Display Screen 05                       :
      *?  :.........................................................:

     C     Scrn05        BegSr

     C                   Eval      LastScreen =  Screen                         ?Previous Screen
     C                   Eval      Screen = 05                                  ?Screen  Number

    ?C*                  Write     MOV50205F
     C                   Eval      *In25 = *On                                  ?SubFile Display
    ?C                   ExFmt     MOV50205C
     C                   Eval      *In25 = *Off                                 ?
     C                   If        SFLCSRRRN5 > 0
     C                   Eval      SFLPOSTO5 = SFLCSRRRN5
     C                   EndIf

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Edit01   - Edit Screen 01                          :
      *?  :.........................................................:

     C     Edit01        BegSr

    ?C                   Select
    ?C                   When      *In01
     C                   ExSr      Updates
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   When      *In03
     C                   Eval      *InLR = *On
    ?C                   When      *In05
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   When      MOVEDATE <> savMOVEDATE or
    ?C                             MOVE#    <> savMOVE#
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   When      *In06
     C                   Eval      $CMD_Command = $CMD_CMD(1)
     C                   Eval      $CMD_Printer = Printer
     C                   ExSr      $Command
     C                   Call      'MOV503'
     C                   Parm      MOVEDATE      SelDate           6 0
     C                   Parm      MOVE#         SelMove           2 0
     C                   ExSr      Scrn01
    ?C                   When      *In10
     C                   ExSr      SwapDest
    ?C                   Update    MOV50201S
     C                   ExSr      Scrn01
    ?C                   When      *In11
     C                   Eval      Printer = $ChgPrt($User():ProgID:Printer)
     C                   ExSr      Scrn01
    ?C                   When      *In23 or *In08
     C                   If        Dest# <> 0
     C                   ExSr      SwapDest
     C                   Eval      DEST = ButtonDestID(Dest#)
     C                   Eval      Destin  = ButtonText(Dest#)
     C                   Eval      Destin# = ButtonDestID(Dest#)
     C                   ExSr      Colors
    ?C                   Update    MOV50201S
     C                   If        SFLCSRRRN1 < SflRcds1
     C                   Eval      SflPosTo1 = SFLCSRRRN1 + 1
     C                   EndIf
     C                   EndIf
     C                   ExSr      Scrn01
    ?C                   When      *In22
    ?C                   Select
    ?C                   When      CSRFLD = 'ALTDEST'
     C                   ExSr      SwapDest
    ?C                   Update    MOV50201S
     C                   ExSr      Scrn01
    ?C                   When      CSRFLD = 'DESTIN'
     C                   ExSr      Scrn02
    ?C                   When      CSRFLD = 'DESTINPCT'
    ?C     SflCsrRRN1    Chain     MOV50201S
     C                   ExSr      Load05
     C                   ExSr      Scrn05
    ?C                   Other
     C                   ExSr      Scrn01
    ?C                   EndSl
    ?C                   Other
     C                   ExSr      Scrn01
    ?C                   EndSl

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Edit02   - Edit Screen 02                          :
      *?  :.........................................................:

     C     Edit02        BegSr

    ?C                   Select
    ?C                   When      *In13 and UpdateMode
     C                   Eval      UpdateMode = *Off
     C                   ExSr      Scrn02
    ?C                   When      *In13 and not UpdateMode
     C                   Eval      UpdateMode = *On
     C                   ExSr      Scrn02
    ?C                   When      *In12
     C                   ExSr      Scrn01
    ?C                   When      Dest# <> 0
     C                   If        UpdateMode
     C                   Eval      DEST = ButtonDestID(Dest#)
    ?C     DEST          Chain     FMOVDEST
     C                   ExSr      Scrn03
     C                   Else
     C                   Eval      Destin  = ButtonText(Dest#)
     C                   Eval      Destin# = ButtonDestID(Dest#)
     C                   ExSr      Colors
    ?C                   Update    MOV50201S
     C                   ExSr      Scrn01
     C                   EndIf
    ?C                   When      HelpMe <> 0
     C                   ExSr      Load04
     C                   ExSr      Scrn04
    ?C                   Other
     C                   ExSr      Scrn02
    ?C                   EndSL

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Edit03   - Edit Screen 03                          :
      *?  :.........................................................:

     C     Edit03        BegSr

     C                   If        not *In12
    ?C                   Update    RMOVDEST
     C                   EndIf

    ?C                   Select
    ?C                   When      LastScreen = 02
     C                   ExSr      Scrn02
    ?C                   When      LastScreen = 04
     C                   ExSr      Load04
     C                   ExSr      Scrn04
    ?C                   Other
     C                   ExSr      Scrn03
    ?C                   EndSL

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Edit04   - Edit Screen 04                          :
      *?  :.........................................................:

     C     Edit04        BegSr

    ?C                   Select
    ?C                   When      *In23
    ?C     SflCsrRRN4    Chain     MOV50204S
    ?C     S4DESTID      Chain(N)  FMOVDEST
     C                   ExSr      Scrn03
    ?C                   When      *In22 or not *In12
    ?C     SflCsrRRN4    Chain     MOV50204S
     C                   Eval      Destin  = S4DESNAM
     C                   Eval      Destin# = S4DESTID
     C                   ExSr      Colors
    ?C                   Update    MOV50201S
     C                   ExSr      Scrn01
    ?C                   When      *In12
     C                   ExSr      Scrn02
    ?C                   Other
     C                   ExSr      Scrn04
    ?C                   EndSl

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Edit05   - Edit Screen 05                          :
      *?  :.........................................................:

     C     Edit05        BegSr

    ?C                   Select
    ?C                   When      *In12
     C                   ExSr      Scrn01
    ?C                   Other
      *?  Read through all of the Subfile records
     C                   Eval      RRN = 0
     C                   DoW       RRN < SFLRCDS5
     C                   Eval      RRN = RRN + 1

      *?  Update the Default Destinations File FMOVDFT
    ?C     RRN           Chain     MOV50205S

     C                   Eval      Destin# = S5DESTID
    ?C     DftKey        Chain     FMOVDFT
     C                   If        %Found(FMOVDFT)
     C                   If        S5DFUSED <> *Zeros
     C                   Eval      DFUSED = S5DFUSED
     C                   Eval      DFPCTU = S5DFPCTU
    ?C                   Update    RMOVDFT
     C                   Else
    ?C                   Delete    RMOVDFT
     C                   EndIf
     C                   EndIf
     C                   EndDo
     C                   Call      'MOV301'                                     ?Recalc % Used

     C                   If        not PriorAssign
     C                   ExSr      GetDefault
     C                   ExSr      Colors
    ?C                   Update    MOV50201S
     C                   EndIf
     C                   ExSr      Scrn01
    ?C                   EndSl

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      GetDefault - Get Default Location and Alternate    :
      *?  :.........................................................:

     C     GetDefault    BegSr
       //? Get the Primary default for this item
     C                   Eval      DESTIN#    = *ZEROS
     C                   Eval      DESTIN     = *BLANKS
     C                   Eval      DESTINPCT  = *ZEROS
     C                   Eval      ALTDEST#   = *ZEROS
     C                   Eval      ALTDEST    = *BLANKS
     C                   Eval      ALTDESTPCT = *ZEROS
     C                   Clear                   RMOVDEST
     C     DFTLOCKEY     SetLL     FMOVDFTUS
     C                   IF        %Equal(FMOVDFTUS)
    ?C     DFTLOCKEY     ReadE     FMOVDFTUS
     C                   Eval      DESTINPCT = DFPCTU
     C                   Eval      DESTIN#   = DFDSID
    ?C     DFDSID        Chain(N)  FMOVDEST
     C                   Eval      DESTIN    = DESNAM
      *?  Get the Secondary default for this item
    ?C     DFTLOCKEY     ReadE     FMOVDFTUS
     C                   If        not %EOF(FMOVDFTUS)
     C                   Eval      ALTDESTPCT = DFPCTU
     C                   Eval      ALTDEST#   = DFDSID
     C                   Clear                   RMOVDEST
    ?C     DFDSID        Chain(N)  FMOVDEST
     C                   Eval      ALTDEST   = DESNAM
     C                   EndIf

     C                   EndIf

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Colors - Set Display colors for Subfile Records    :
      *?  :.........................................................:

     C     Colors        BegSr

     C                   SetOff                                       505152
     C                   If        PriorAssign
     C                   Eval      *In52 = *On                                  ?Wht - Prior Assigne
     C                   Else
     C                   If        DESTIN = *Blanks
     C                   Eval      *In50 = *On                                  ?Red - No to Destina
     C                   Else
     C                   If        DESTINPCT < 70
     C                   Eval      *In51 = *On                                  ?Pnk - Low % Rate
     C                   EndIf
     C                   EndIf
     C                   EndIf

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      SwapDest - Swap Destinations                       :
      *?  :.........................................................:

     C     SwapDest      BegSr

    ?C     SFLCSRRRN1    Chain     MOV50201S
     C                   Eval      Hold#      = Destin#
     C                   Eval      Hold@      = Destin
     C                   Eval      HoldP      = DestinPct
     C                   Eval      Destin#    = AltDest#
     C                   Eval      Destin     = AltDest
     C                   Eval      DestinPct  = AltDestPct
     C                   Eval      AltDest#   = Hold#
     C                   Eval      AltDest    = Hold@
     C                   Eval      AltDestPct = HoldP
     C                   ExSr      Colors

     C                   EndSr


    ? /Eject
      *?  ...........................................................
      *?  :      Updates  - Update the Chemical Application File    :
      *?  :.........................................................:

     C     Updates       BegSr

      *?  Read through all of the Subfile records
     C                   Eval      RRN = 0
     C                   DoW       RRN < SFLRCDS1
     C                   Eval      RRN = RRN + 1

    ?C     RRN           Chain     MOV50201S
     C                   If        Destin# <> *Zeros

      *?  Update the Default Destinations File FMOVDFT
    ?C     DftKey        Chain     FMOVDFT
     C                   Eval      DFUSED = DFUSED + 1
     C                   If        %Found(FMOVDFT)
    ?C                   Update    RMOVDFT
     C                   Else
     C                   Eval      DFITEM = ITEM5
     C                   Eval      DFSIZE = SIZE
     C                   Eval      DFDSID = DESTIN#
     C                   Eval      DFUSED = 1
     C                   Eval      DFPCTU = 100.00
    ?C                   Write     RMOVDFT
     C                   EndIf

      *?  Update the Move To File FMOVTO
    ?C     MovToKey      Chain     FMOVTO
     C                   If        %Found(FMOVTO)
     C                   Eval      M2DSID = DESTIN#
    ?C                   Update    RMOVTO
     C                   Else
     C                   Eval      M2ITEM = ITEM5
     C                   Eval      M2SIZE = SIZE
     C                   Eval      M2JOB# = JOB#
     C                   Eval      M2DSID = DESTIN#
    ?C                   Write     RMOVTO
     C                   EndIf

     C                   EndIf
     C                   EndDo

     C                   Call      'MOV301'                                     ?Recalc % Used

     C                   EndSr

    ? /Eject
    ?C/COPY QFunctDefn,$CommandSR


    ? /Eject
      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

    ?C     INVKEY        KLIST
    ?C                   KFLD                    IMITEM
    ?C                   KFLD                    IMSIZE

    ?C     DftKey        KList
    ?C                   KFld                    ITEM5
    ?C                   KFld                    SIZE
    ?C                   KFld                    DESTIN#

    ?C     ItemKey       KList
    ?C                   KFld                    MJITEM
    ?C                   KFld                    MJSIZE

    ?C     MovToKey      KLIST
    ?C                   KFLD                    MOVEDATE
    ?C                   KFLD                    MOVE#
    ?C                   KFLD                    ITEM5
    ?C                   KFLD                    SIZE
    ?C                   KFLD                    JOB#

    ?C     DFTLOCKEY     KLIST
    ?C                   KFLD                    ITEM5
    ?C                   KFLD                    SIZE

     C                   Eval      Today = $MDYDate($Date(0))
     C                   Eval      Printer = $DftPrt($User():ProgID:'*PGM')
     C                   Eval      UserID= $User()
     C                   Eval      Monday = $Monday($Date(0):'SAT')
     C                   Eval      ThisMonday = Monday

    ?C     *HiVal        SetGT     FMOVJBL0A
    ?C                   ReadP     FMOVJBL0A
     C*                  Eval      MoveDate = MJTDAT
     C*                  Eval      Move#    = MJMOVE

     C                   ExSr      Load01
     C                   ExSr      Load02
     C                   ExSr      Scrn01

     C                   EndSR
**
OVRPRTF FILE(MOV503P) FORMTYPE(*NAR) CPI(10) PAGRTT(0) OVRSCOPE(*JOB) OUTQ(|P~~~~~~~~)
