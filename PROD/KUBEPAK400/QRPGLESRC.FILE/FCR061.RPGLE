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
      *? :   This program replaces FCR060.  This program allows      ?:
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
      *? :````````````````````````````````````````````````````````````:
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? : Date    Int  Change Description                         ?:
      *? : 03/23/05 WB01 ?Add Ounces to Print Function               ?:
      *? :............................................................:

     FFCR061FM  CF   E             WORKSTN
     F                                     SFILE(FCR06101S:SFLRRN01)
     FFCR061P   O    E             PRINTER USROPN OFLIND(*In80)
     FFMINVT    IF   E           K DISK
     FFFCMAPPR  UF A E           K DISK
     FFFCMTOT5  IF   E           K DISK
WB01 FFFCMPPM   IF   E           K DISK

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
     D $CMD_CMD        S            100A   Dim(0001) CtData PerRcd(1)           ?System Commands

      *? Program Data Structure
     D                SDS
     D   PgmID           *PROC

      *? Data Structures
     D  FCR061         DS
     D    APP01                                                                 ?Appl. 01
     D    APP02                                                                 ?Appl. 02
     D    APP03                                                                 ?Appl. 03
     D    APP04                                                                 ?Appl. 04
     D    APP05                                                                 ?Appl. 05
     D    APP06                                                                 ?Appl. 06
     D    APP07                                                                 ?Appl. 07
     D    APP08                                                                 ?Appl. 08
     D    APP09                                                                 ?Appl. 09
     D    APP10                                                                 ?Appl. 10
     D    APP11                                                                 ?Appl. 11
     D    APP12                                                                 ?Appl. 12
     D    APP13                                                                 ?Appl. 13
     D    APP14                                                                 ?Appl. 14
     D    APP15                                                                 ?Appl. 15
     D    APP16                                                                 ?Appl. 16
     D    APP17                                                                 ?Appl. 17
     D    APP18                                                                 ?Appl. 18
     D    APP19                                                                 ?Appl. 19
     D    APP20                                                                 ?Appl. 20
     D    APP21                                                                 ?Appl. 21
     D    APP22                                                                 ?Appl. 22
     D    APP23                                                                 ?Appl. 23
     D    APP24                                                                 ?Appl. 24
     D    APP                              like(APP01) dim(24) overlay(FCR061)  ?Applicator array

WB01 D  PPMOunce       DS
WB01 D    CMOZ1                                                                 ?Ounces
WB01 D    CMOZ2                                                                 ?Ounces
WB01 D    CMOZ3                                                                 ?Ounces
WB01 D    CMOZ4                                                                 ?Ounces
WB01 D    CMOZ5                                                                 ?Ounces
WB01 D    CMOZ6                                                                 ?Ounces
WB01 D    CMOZ7                                                                 ?Ounces
WB01 D    CMOZ8                                                                 ?Ounces
WB01 D    CMOZ9                                                                 ?Ounces
WB01 D    CMOZ10                                                                ?Ounces
WB01 D    CMOZ11                                                                ?Ounces
WB01 D    CMOZ12                                                                ?Ounces
WB01 D    CMOZ13                                                                ?Ounces
WB01 D    CMOZ14                                                                ?Ounces
WB01 D    CMOZ15                                                                ?Ounces
WB01 D    CMOZ16                                                                ?Ounces
WB01 D    CMOZ17                                                                ?Ounces
WB01 D    CMOZ18                                                                ?Ounces
WB01 D    CMOZ19                                                                ?Ounces
WB01 D    CMOZ20                                                                ?Ounces
WB01 D    CMOZ21                                                                ?Ounces
WB01 D    CMOZ22                                                                ?Ounces
WB01 D    CMOZ23                                                                ?Ounces
WB01 D    CMOZ24                                                                ?Ounces
WB01 D    CMOZ25                                                                ?Ounces
WB01 D    CMOZ26                                                                ?Ounces
WB01 D    CMOZ27                                                                ?Ounces
WB01 D    CMOZ28                                                                ?Ounces
WB01 D    CMOZ29                                                                ?Ounces
WB01 D    CMOZ30                                                                ?Ounces
WB01 D    CMOZ31                                                                ?Ounces
WB01 D    CMOZ32                                                                ?Ounces
WB01 D    CMOZ33                                                                ?Ounces
WB01 D    CMOZ34                                                                ?Ounces
WB01 D    CMOZ35                                                                ?Ounces
WB01 D    CMOZ36                                                                ?Ounces
WB01 D    CMOZ37                                                                ?Ounces
WB01 D    CMOZ38                                                                ?Ounces
WB01 D    CMOZ39                                                                ?Ounces
WB01 D    CMOZ40                                                                ?Ounces
WB01 D    CMOZ41                                                                ?Ounces
WB01 D    CMOZ42                                                                ?Ounces
WB01 D    CMOZ43                                                                ?Ounces
WB01 D    CMOZ44                                                                ?Ounces
WB01 D    CMOZ45                                                                ?Ounces
WB01 D    CMOZAra                     7S 3 Dim(45) OverLay(PPMOunce) Inz        ?Ounces Array
WB01
      *? Field Definitions
     D  DateLitDft1    S             22A   INZ(' Applicators for Date:')
     D  UserID         S             10A
     D  Today          S              6S 0
     D  Monday         S               D
     D  ThisMonday     S               D
     D  MondayCYMD     S              7S 0
     D  SflRRN01       S              4S 0
     D  UseTot         S               N
     D  UseApp         S               N
     D  X              S              5S 0
     D  PPMLkUp        S              4S 0
WB01
WB01  *? Arrays
WB01 D   PPMArray      S              4S 0 Dim(0045) CtData PerRcd(15)          ?PPM Array

      /Free
    ?   /COPY QFunctDefn,LASTUSEDCB
      /End-Free
    ? ***********************
    ? ** START HERE        **
    ? ***********************
     C                   Eval      Printer = $DftPrt(UserID:PgmID:'*PGM')
     C                   Eval      $CMD_Command = $CMD_CMD(1)
     C                   Eval      $CMD_Printer = Printer
     C                   ExSr      $Command
     C                   ExSr      Load01
     C                   ExSr      Scrn01

     C                   DoW       *InLR <> *On
    ?C                   Select
    ?C     Screen        WhenEq    01
     C                   ExSr      Edit01
    ?C     Screen        WhenEq    02
     C                   ExSr      Edit02
    ?C     Screen        WhenEq    03
     C                   ExSr      Edit03
    ?C                   Other
     C                   Eval      *InLR = *On
    ?C                   EndSL
     C                   EndDo

    ?C                   Out       FCR061

      *?  ...........................................................
      *?  :      Load01   - Load Screen 01                          :
      *?  :.........................................................:

     C     Load01        BegSr

    ?C                   Eval      *In25 = *Off                                 |Subfile Display
    ?C                   Eval      *In26 = *Off                                 |Subfile No Records
    ?C                   Eval      *In27 = *Off                                 |Subfile End
     C                   Eval      SflRRN01 = 0
    ?C                   Write     FCR06101C

     C                   Eval      MondayCYMD = $Date7(Monday)
     C     MondayCYMD    SetLL     FFCMTOT5
     C                   Eval      SflRcds = *Zero
      *?    If the Week to be displayed is the current week in the
      *?    Chemical Totals File base Subfile on FFCMTOT5
     C                   If        %Equal(FFCMTOT5)
     C                   ExSr      LoadCurrent
     C                   Else
     C                   ExSr      LoadHistory
     C                   EndIf

     C                   EndSr



      *?  ...........................................................
      *?  :      LoadCurrent - Load Current Week Data               :
      *?  :.........................................................:

     C     LoadCurrent   BegSr

     C                   Eval      *In48 = *On

     C     MondayCYMD    SetLL     FFCMTOT5
    ?C     MondayCYMD    ReadE     FFCMTOT5                               30

     C                   DoW       not %Eof(FFCMTOT5)

     C                   MOVE      CTPPM         PPM
     C                   MOVEL     CTSPIT        ITEM
     C                   MOVEL     CTSPIT        ITEM5
     C                   MOVEL     CTSPIT        CTSPIT8           8
     C                   MOVE      CTSPRY        SPRAY

     C                   MOVE      *ZEROS        GALS
     C                   MOVEL     CTSPIT        CTSPIT
     C                   MOVE      CTPPM         CTPPM
     C                   MOVEL     CTSPRY        CTSPRY
     C                   MOVEL     CTTRAY        TRAYS
     C                   MOVEL     CTPOLE        POLES
     C                   MOVEL     CTGALS        GALS              5 2

     C                   MOVEL     ITEM5         IMITEM
     C                   MOVEL     '700'         SIZE
     C                   MOVEL     '700'         IMSIZE
    ?C     INVKEY        CHAIN     FMINVT                             92
     C                   MOVEL     IMDES1        DESC             10
     C                   MOVEL     IMDES1        DESC15

     C     APPKEY        Chain     FFCMAPPR
     C                   If        %Found(FFCMAPPR)
     C                   Eval      APP1 = CAAPP1
     C                   Eval      APP2 = CAAPP2
     C                   Else
     C                   Eval      APP1 = *Blanks
     C                   Eval      APP2 = *Blanks
     C                   EndIf

     C                   Eval      *In26 = *On                                  |Subfile Has Records
     C                   Eval      SflRRN01 = SflRRN01 + 1
    ?C     MondayCYMD    ReadE     FFCMTOT5
     C                   If        %Found(FFCMTOT5)
     C                   Eval      *In27 = *Off
     C                   Else
     C                   Eval      *In27 = *On
     C                   EndIf
WB01  *? Get the Ounces for this item
WB01 C                   ExSr      OunceSR
    ?C                   Write     FCR06101S
     C                   Eval      SflRcds = SflRcds + 1
     C                   EndDo

     C                   EndSr


      *?  ...........................................................
      *?  :      LoadHistory - Load History Week Data               :
      *?  :.........................................................:

     C     LoadHistory   BegSr

     C                   Eval      *In48 = *Off

     C     MondayCYMD    SetLL     FFCMAPPR
    ?C     MondayCYMD    ReadE     FFCMAPPR                               30

     C                   Eval      *In61 = *On
     C                   DoW       not %Eof(FFCMAPPR)

     C                   MOVE      '700'         SPSIZE            3
     C                   MOVE      CAPPM         PPM
     C                   MOVE      CAITEM        ITEM
     C                   MOVEL     CAITEM        ITEM5
     C                   MOVE      CASPRY        SPRAY
     C                   MOVE      CAAPP1        APP1
     C                   MOVE      CAAPP2        APP2

     C                   MOVE      *ZEROS        GALS
     C                   MOVEL     CAITEM        CTSPIT
     C                   MOVE      CAPPM         CTPPM
     C                   MOVEL     CASPRY        CTSPRY
     C*                  MOVEL     CTGALS        GALS              5 2
     C                   MOVE      *Zeros        GALS              5 2
     C                   MOVE      *Zeros        TRAYS
     C                   MOVE      *Zeros        POLES

     C                   MOVEL     ITEM5         IMITEM
     C                   MOVEL     SPSIZE        IMSIZE
     C                   MOVEL     SPSIZE        SIZE
    ?C     INVKEY        CHAIN     FMINVT                             92
     C                   MOVEL     IMDES1        DESC             10

     C                   Eval      *In26 = *On                                  |Subfile Has Records
     C                   Eval      SflRRN01 = SflRRN01 + 1
     C                   Eval      *In61 = *Off
    ?C     MondayCYMD    ReadE     FFCMAPPR                               30
     C                   If        %Found(FFCMAPPR)
     C                   Eval      *In27 = *Off
     C                   Else
     C                   Eval      *In27 = *On
     C                   EndIf
WB01  *? Get the Ounces for this item
WB01 C                   ExSr      OunceSR
    ?C                   Write     FCR06101S
     C                   Eval      SflRcds = SflRcds + 1
     C                   EndDo

     C                   Eval      *In49 = *Off
     C                   If        not *In26 and Monday > ThisMonday
     C                   Eval      *In49 = *On
     C                   EndIf

     C                   EndSr


      *?  ...........................................................
      *?  :      Scrn01   - Display Screen 01                       :
      *?  :.........................................................:

     C     Scrn01        BegSr

     C                   Z-Add     01            Screen            3 0          ?Screen  Number

     C                   If        *In26 = *off
    ?C                   Write     FCR06101N
     C                   Else
    ?C                   Write     FCR06101F
     C                   EndIf
     C                   Eval      *In25 = *On                                  ?SubFile Display
    ?C                   ExFmt     FCR06101C
     C                   Eval      *In25 = *Off                                 ?
     C                   If        SFLCSRRRN > 0
     C                   Eval      SFLPOSTO1 = SFLCSRRRN
     C                   EndIf

     C                   EndSr


      *?  ...........................................................
      *?  :      Edit01   - Edit Screen 01                          :
      *?  :.........................................................:

     C     Edit01        BegSr

    ?C                   Select
    ?C                   When      *In01
     C                   ExSr      Updates
     C                   ExSr      Scrn01
    ?C                   When      *In03
     C                   Eval      *InLR = *On
    ?C                   When      *In05
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   When      *In06
     C                   ExSr      Print01
     C                   ExSr      Scrn01
    ?C                   When      *In07
     C                   Eval      Monday = $AddDate(Monday:-1)
     C                   ExSr      GetLit
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   When      *In08
     C                   Eval      Monday = $AddDate(Monday:+1)
     C                   ExSr      GetLit
     C                   ExSr      Load01
     C                   ExSr      Scrn01
    ?C                   When      *In22 or *In09
     C                   If        *In48
     C                   ExSr      Scrn02
     C                   Else
     C                   ExSr      Scrn01
     C                   EndIf
    ?C                   When      *In23 or *In10
     C                   If        Applic <> 0  and *In48
     C                   ExSr      AssignApp
     C                   EndIf
     C                   ExSr      Scrn01
    ?C                   When      *In11
     C                   Eval      Printer = $ChgPrt(UserID:PgmID:Printer)
     C                   Eval      $CMD_Command = $CMD_CMD(1)
     C                   Eval      $CMD_Printer = Printer
     C                   ExSr      $Command
     C                   ExSr      Scrn01
    ?C                   When      *In16
     C                   ExSr      ClearAll
     C                   ExSr      Scrn01
    ?C                   Other
     C                   ExSr      Scrn01
    ?C                   EndSL

     C                   EndSr


      *?  ...........................................................
      *?  :      Scrn02   - Display Screen 02                       :
      *?  :.........................................................:

     C     Scrn02        BegSr

     C                   Z-Add     02            Screen            3 0          ?Screen  Number

    ?C                   ExFmt     FCR06102

     C                   EndSr


      *?  ...........................................................
      *?  :      Edit02   - Edit Screen 01                          :
      *?  :.........................................................:

     C     Edit02        BegSr

    ?C                   Select
     C                   When      APPLIC <> 0
     C                   ExSr      AssignApp
     C                   ExSr      Scrn01
    ?C                   When      *In13 = *On
     C                   ExSr      Scrn03
    ?C                   Other
     C                   ExSr      Scrn02
    ?C                   EndSL

     C                   EndSr


      *?  ...........................................................
      *?  :      Scrn03   - Display Screen 03                       :
      *?  :.........................................................:

     C     Scrn03        BegSr

     C                   Z-Add     03            Screen            3 0          ?Screen  Number

    ?C                   ExFmt     FCR06103

     C                   EndSr


      *?  ...........................................................
      *?  :      Edit03   - Edit Screen 03                          :
      *?  :.........................................................:

     C     Edit03        BegSr

     C                   ExSr      Scrn02

     C                   EndSr


      *?  ...........................................................
      *?  :      AssignApp - Assign Applicator to Chemical Record   :
      *?  :.........................................................:

     C     AssignApp     BegSr

    ?C     SFLCSRRRN     Chain     FCR06101S

    ?C                   Select
    ?C                   When      CSRFLD = 'APP1'
     C                   Eval      App1 = App(Applic)
    ?C                   When      CSRFLD = 'APP2'
     C                   Eval      App2 = App(Applic)
    ?C                   When      CSRFLD <> 'APP1' and CSRFLD <> 'APP2'
    ?C                             and APP1 <> *Blanks
    ?C                             and APP2 <> *Blanks
     C                   Eval      App1 = App(Applic)
    ?C                   When      CSRFLD <> 'APP1' and CSRFLD <> 'APP2'
    ?C                             and APP1 = *Blanks
     C                   Eval      App1 = App(Applic)
    ?C                   When      CSRFLD <> 'APP1' and CSRFLD <> 'APP2'
    ?C                             and APP2 = *Blanks
     C                   Eval      App2 = App(Applic)
    ?C                   Other
    ?C                   EndSl
     C                   Eval      *In61 = *Off
     C                   Eval      *In62 = *Off
    ?C                   UPDATE    FCR06101S

      *? Figure out which record to position the cusor on next
     C                   If        SFLCSRRRN < SFLRCDS
     C                   If        APP1 <> *Blanks and APP2 <> *Blanks
     C                   Eval      SFLCSRRRN = SFLCSRRRN + 1
     C                   EndIf

      *? Remove all previous position cursor indicators
     C                   Eval      X = 1
     C     X             DoUGT     SFLRCDS
    ?C     X             Chain     FCR06101S
     C                   Eval      *In61 = *Off
     C                   Eval      *In62 = *Off
    ?C                   UPDATE    FCR06101S
     C                   Eval      X = X + 1
     C                   EndDo

      *? Now set the position Cursor Indicator on the selected record
    ?C     SFLCSRRRN     Chain     FCR06101S
     C                   If        APP1 = *Blanks or APP2 <> *Blanks
     C                   Eval      *In61 = *On
     C                   Eval      *In62 = *Off
     C                   Else
     C                   Eval      *In61 = *Off
     C                   Eval      *In62 = *On
     C                   EndIf
    ?C                   UPDATE    FCR06101S
     C                   EndIf

     C                   EndSr


      *?  ...........................................................
      *?  :      Updates  - Update the Chemical Application File    :
      *?  :.........................................................:

     C     Updates       BegSr

     C                   Eval      X = 1
     C     X             DoUGT     SFLRCDS
    ?C     X             Chain     FCR06101S

     C     AppKey2       Chain     FFCMAPPR
     C     AppKey2       KList
     C                   KFLD                    MondayCYMD
     C                   KFLD                    CTSPIT8
     C                   KFLD                    SIZE
     C                   KFLD                    PPM
     C                   KFLD                    SPRAY

     C                   EVAL      CAWKDT = MondayCYMD
     C*                  EVAL      CAWK#
     C*                  EVAL      CASTAT
     C*                  EVAL      CAJOB
     C*                  EVAL      CARUN
     C                   EVAL      CASPRY = SPRAY
     C                   EVAL      CAITEM = ITEM5
     C                   EVAL      CASIZE = '700'
     C                   EVAL      CAPPM  = PPM
     C                   EVAL      CAAPP1 = APP1
     C                   EVAL      CAAPP2 = APP2
     C                   EVAL      CADTLA = Today
     C                   TIME                    CATIME
     C                   EVAL      CAUSER = UserID
     C                   If        %Found(FFCMAPPR)
    ?C                   UPDATE    RCHMAPP
     C                   Else
    ?C                   WRITE     RCHMAPP
     C                   EndIf

     C                   Eval      X = X + 1
     C                   EndDo

     C                   EndSr


      *?  ...........................................................
      *?  :      Print01 - Print Applicator Summary                 :
      *?  :.........................................................:

     C     Print01       BegSr

     C                   If        not %Open(FCR061P)
    ?C                   OPEN      FCR061P
     C                   EndIf
      *? Read through Subfile and Print report
    ?C                   WRITE     HEAD
     C                   Eval      X = 1
     C     X             DoUGT     SFLRCDS
    ?C     X             Chain     FCR06101S
    ?C   80              WRITE     HEAD
    ?C                   WRITE     DETL
     C                   Eval      X = X + 1
     C                   EndDo
     C                   If        %Open(FCR061P)
    ?C                   CLOSE     FCR061P
     C                   EndIf


     C                   EndSr


      *?  ...........................................................
      *?  :      OunceSR - Calculate Ounces of Chemical Needed      :
      *?  :.........................................................:

     C     OunceSR       BegSr

WB01?C     ItemSize      Chain     FFCMPPM
WB01?C     ItemSize      KList
WB01?C                   KFld                    ITEM
WB01?C                   KFld                    SIZE
WB01 C                   Eval      PPMLkUp = PPM
WJB1 C                   If        PPM < 1
WB01 C                   Eval      PPMLkUp = 1
WB01 C                   EndIf
WB01 C                   Eval      X = 1
WB01 C     PPMLkUp       LookUp    PPMArray(x)                            50
WJB1 C                   If        not %Equal()
WB01?C                   Select
WB01?C                   When      PPM < 1
WB01 C                   Eval      OUNCES = CMOZAra(1) * GALS * PPM
WB01?C                   When      CMOZAra(1) <> 0
WB01 C                   Eval      OUNCES = CMOZAra(1) * GALS * PPM
WB01?C                   When      CMOZAra(19) <> 0
WB01 C                   Eval      OUNCES = CMOZAra(19) * GALS * PPM/100
WB01?C                   When      CMOZAra(37) <> 0
WB01 C                   Eval      OUNCES = CMOZAra(37) * GALS * PPM/1000
WB01?C                   OTHER
WB01 C                   Eval      OUNCES = 999.999
WB01?C                   EndSl
WB01 C                   Else
WB01 C                   Eval      OUNCES = CMOZAra(x) * GALS
WB01 C                   EndIf

     C                   EndSr


      *?  ...........................................................
      *?  :      ClearAll - Clear all Applicator Assignments        :
      *?  :.........................................................:

     C     ClearAll      BegSr

      *? Remove APP1 and APP2 from all subfile records
     C                   Eval      X = 1
     C     X             DoUGT     SFLRCDS
    ?C     X             Chain     FCR06101S
     C                   Eval      APP1 = *Blanks
     C                   Eval      APP2 = *Blanks
    ?C                   UPDATE    FCR06101S
     C                   Eval      X = X + 1
     C                   EndDo

     C                   EndSr


      *?  ...........................................................
      *?  :      GetLit   - Get Date Literal                        :
      *?  :.........................................................:

     C     GetLit        BegSr

     C                   Eval      WeekDate = $MDYDate(Monday)
     C                   Eval      %Subst(DateLit:24:08)
     C                             = %EditC(WeekDate:'Y')

     C                   EndSr

    ? /Eject
    ?C/COPY QFunctDefn,$CommandSR


      *?  ...........................................................
      *?  :      *INZSR - Initialization Subroutine                 :
      *?  :.........................................................:

     C     *INZSR        BEGSR

     C     INVKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE

     C     APPKEY        KLIST
     C                   KFLD                    CTWKDT
     C                   KFLD                    CTSPIT8
     C                   KFLD                    CTSPSZ
     C                   KFLD                    CTPPM
     C                   KFLD                    CTSPRY

     C     TOTKEY        KLIST
     C                   KFLD                    CTSPIT
     C                   KFLD                    CTPPM
     C                   KFLD                    CTSPRY

     C     *DtaAra       Define                  FCR061
    ?C     *Lock         In        FCR061

     C                   Eval      Today = $MDYDate($Date(0))
     C                   Eval      UserID= $User()
     C                   Eval      DateLit = DateLitDft1
     C                   Eval      Monday = $Monday($Date(0):'SAT')
     C                   Eval      ThisMonday = Monday
     C                   Eval      SFLPOSTO1 = 1
     C                   ExSr      GetLit

     C                   EndSR

**
OVRPRTF FILE(FCR061P) FORMTYPE(*NAR) CPI(10) PAGRTT(0) OVRSCOPE(*JOB) OUTQ(|P~~~~~~~~)
**  |   |   |   |   |   |   |   |   |   |   |   |   |   |  WB01
000100020003000400050006000700080009001000150020002500300035
004000450050010001500200025003000350040004500500055006000650
070007500800085009000950100015002000250030003500400045005000
