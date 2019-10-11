    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

     FFPUTORDS  IP   E           K DISK
     FFMINVT    IF   E           K DISK
     FFCHMJOBITMIF   E           K DISK
     FQPRINT98  O    F   96        PRINTER OFLIND(*INOF)

     D                SDS                                                       ?PROG DATA STRUCTURE
     D  PROGID                 1     10                                         ?PROGRAM NAME
     D  RLIBR                 81     90                                         ?RUN LIBRARY
     D  USERID               254    263                                         ?USER I.D.
     D  SLIBR                314    323                                         ?SOURCE LIBRARY

     D  PDITEM2        S                   Like(PDITEM)
     D  TotPDQORD      S                   Like(PDQORD)
     D  TotPDQSCH      S                   Like(PDQSCH)
     D  TotDueNow      S                   Like(PDQSCH)
     D  TotRBOrdr      S                   Like(PDQSCH)
     D  GrdPDQORD      S                   Like(PDQORD)
     D  GrdPDQSCH      S                   Like(PDQSCH)
     D  GrdDueNow      S                   Like(PDQSCH)
     D  GrdRBOrdr      S                   Like(PDQSCH)
     D  FIRSTDETL      S               N   Inz(*On)

     D   ReptItem      S                   Like(PDITEM)
     D   ReptSize      S                   Like(PDSIZE)
     D   ShipDate      S                   Like(PDSHPD)
     D   ShipDateMDY   S                   Like(CJRDYD)
     D   IncludeRB     S               N

      *? Function Prototypes
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$MDYDate

     C                   If        PDSHPD = ShipDate
     C
     C  N99              Eval      ReptItem = PDITEM
     C  N99              Eval      ReptSize = PDSIZE
     C  N99              SetOn                                        99

     C                   If        PDITEM + PDSIZE <> ReptItem + ReptSize

     C                   If        *InOF or FirstDETL

     C                   EXCEPT    HEAD
     C                   Eval      *InOF = *Off
     C                   Eval      FirstDETL = *Off
     C                   EndIf

     C                   If        TotDueNow > *Zero
     C                   If        %SubSt(ReptItem:12:1) = 'P'
     C                   Eval      PDITEM2 = %SubSt(ReptItem:1:11) + ' '
     C                   Else
     C                   Eval      PDITEM2 = ReptItem
     C                   EndIf
     C     ItemSize      CHAIN     FMINVT                             91
     C  N99              Eval      IMDES1 = 'Item Not Found'
     C                   Except    DETL

     C     ItemSizeWeek  SetLL     FCHMJOBITM
     C     ItemSizeWeek  ReadE     FCHMJOBITM
     C                   DoW       not %EOF(FCHMJOBITM)
     C                   Except    DETL2
     C     ItemSizeWeek  ReadE     FCHMJOBITM
     C                   EndDo

     C                   EndIf
     C                   Eval      TotPDQORD = *Zero
     C                   Eval      TotPDQSCH = *Zero
     C                   Eval      TotDueNow = *Zero
     C                   Eval      TotRBOrdr = *Zero

     C                   Eval      ReptItem = PDITEM
     C                   Eval      ReptSize = PDSIZE

     C                   EndIf


     C                   If            (   IncludeRB or
     C                                 (not IncludeRB and PDLOC <> '  888888'))
     C                   Eval      TotPDQORD = TotPDQORD + PDQORD
     C                   Eval      TotPDQSCH = TotPDQSCH + PDQSCH
     C                   Eval      TotDueNow = TotPDQORD - TotPDQSCH
     C                   Eval      GrdPDQORD = GrdPDQORD + PDQORD
     C                   Eval      GrdPDQSCH = GrdPDQSCH + PDQSCH
     C                   Eval      GrdDueNow = GrdPDQORD - GrdPDQSCH
     C                   EndIf
     C                   If        PDLOC > '  999999'
     C                   Eval      TotRBOrdr = TotRBOrdr + PDQORD - PDQSCH
     C                   Eval      GrdRBOrdr = GrdRBOrdr + PDQORD - PDQSCH
     C                   EndIf
     C                   EndIf

     C   LR              EXCEPT    TOTL
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR

     C     *Entry        PLIST
     C     ShipDate      Parm                    PDSHPD
     C                   Parm                    Include_RB        1
     C                   If        Include_RB = 'Y'
     C                   Eval      IncludeRB = *On
     C                   Else
     C                   Eval      IncludeRB = *Off
     C                   EndIf

     C                   Eval      ShipDateMDY = $MDYDate($Date(PDSHPD))

     C     ItemSize      KLIST
     C                   KFLD                    PDITEM2
     C                   KFLD                    ReptSize

     C     ItemSizeWeek  KLIST
     C                   KFLD                    PDITEM2
     C                   KFLD                    ReptSize
     C                   KFLD                    ShipDateMDY

     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   SETON                                        OF
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************  PRINT CONTROL NUMBER ABOVE CLIP
     OQPRINT98  E            HEAD           1 03
     O                                            6 'PSR201'
     O                                           21 'Requested by:'
     O                       USERID              32
     O                                           52 'Master List Update'
     O                       PAGE          Z     80
     O                                           76 'Page:'
     O          E            HEAD           1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           71 'Time:'
     O                       TIMOD               80 '  :  :  '
     O          E            HEAD           0
     O                                           12 'Item        '
     O                                           16 'Size'
     O                                           28 'Description'
     O                                           60 'Ordered'
     O                                           70 'Scheduled'
     O                                           80 'Due Now'
     O                                           90 'R/B Due'
     O          E            HEAD           1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O                                           90 '____________________'
     O          EF           DETL           1
     O                       ReptItem            12
     O                       ReptSize            16
     O                       IMDES1              47
     O                       TotRBOrdr     4     90
     O                       TotDueNow     4     80
     O                       TotPDQSCH     4     70
     O                       TotPDQORD     4     60
     O          EF           DETL2          1
     O                       CJDTLA        Y     25
     O                       CJSECT              29
     O                                           30 '-'
     O                       CJNOS               31
     O                                           32 '-'
     O                       CJBAY               34
     O                                           35 '-'
     O                       CJSLOR              36
     O                                           37 '-'
     O                       CJSPOL              39

     O                       CJSECT              44
     O                                           45 '-'
     O                       CJNOS               46
     O                                           47 '-'
     O                       CJBAY               49
     O                                           50 '-'
     O                       CJELOR              51
     O                                           52 '-'
     O                       CJEPOL              54
     O          EF           TOTL           1
     O                                           60 '========='
     O                                           70 '========='
     O                                           80 '========='
     O                                           80 '========='
     O          EF           TOTL           1
     O                       GrdRBOrdr     4     90
     O                       GrdDueNow     4     80
     O                       GrdPDQSCH     4     70
     O                       GrdPDQORD     4     60
     O                                           50 'Total Quantity=========>'
