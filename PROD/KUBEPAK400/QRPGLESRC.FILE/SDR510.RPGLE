      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- SDR510
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- UPDATE SELECTED VENDOR AND SEED FORM BY
      *                      SPECIES/VARIETY.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FSDR510FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFSERIESA  IF   E           K DISK
     F                                     RENAME(RSERIES:SERI)
     FFSERIES   UF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFSERPRC   IF   E           K DISK
     FFSERPRCS  IF   E           K DISK
     F                                     RENAME(RSERPRC:SERPRC)
     FFSEDCTL   IF   E           K DISK
      *
      * SERPRC ARRAY
     D PRC             S              9  4 DIM(3)                               PRICES
      *
     D White           S              1A   Inz('?')                             ?Code for?White
     D Blank45         S             45A   Inz(*Blanks)                          45 Blanks

     D  VxxF1DS        DS                  INZ
     D  V01F1
     D  V02F1
     D  V03F1
     D  V04F1
     D  V05F1
     D  V06F1
     D  V07F1
     D  V08F1
     D  V09F1
     D  V10F1
     D  V11F1
     D  V12F1
     D  V13F1
     D  V14F1
     D  V15F1
     D  V16F1
     D  V17F1
     D  V18F1
     D  V19F1
     D  V20F1
     D  V21F1
     D  V22F1
     D  V23F1
     D  V24F1
     D  V25F1
     D  V26F1
     D  V27F1
     D  V28F1
     D  V29F1
     D  V30F1
     D  V31F1
     D  V32F1
     D  V33F1
     D  V34F1
     D  V35F1
     D  V36F1
     D  V37F1
     D  V38F1
     D  V39F1
     D  V40F1
     D  VxxF1                         5S 2 Dim(40) Overlay(VxxF1DS)
      *
     D  VxxF2DS        DS                  INZ
     D  V01F2
     D  V02F2
     D  V03F2
     D  V04F2
     D  V05F2
     D  V06F2
     D  V07F2
     D  V08F2
     D  V09F2
     D  V10F2
     D  V11F2
     D  V12F2
     D  V13F2
     D  V14F2
     D  V15F2
     D  V16F2
     D  V17F2
     D  V18F2
     D  V19F2
     D  V20F2
     D  V21F2
     D  V22F2
     D  V23F2
     D  V24F2
     D  V25F2
     D  V26F2
     D  V27F2
     D  V28F2
     D  V29F2
     D  V30F2
     D  V31F2
     D  V32F2
     D  V33F2
     D  V34F2
     D  V35F2
     D  V36F2
     D  V37F2
     D  V38F2
     D  V39F2
     D  V40F2
     D  VxxF2                         5S 2 Dim(40) Overlay(VxxF2DS)
      *
     D  VxxF3DS        DS                  INZ
     D  V01F3
     D  V02F3
     D  V03F3
     D  V04F3
     D  V05F3
     D  V06F3
     D  V07F3
     D  V08F3
     D  V09F3
     D  V10F3
     D  V11F3
     D  V12F3
     D  V13F3
     D  V14F3
     D  V15F3
     D  V16F3
     D  V17F3
     D  V18F3
     D  V19F3
     D  V20F3
     D  V21F3
     D  V22F3
     D  V23F3
     D  V24F3
     D  V25F3
     D  V26F3
     D  V27F3
     D  V28F3
     D  V29F3
     D  V30F3
     D  V31F3
     D  V32F3
     D  V33F3
     D  V34F3
     D  V35F3
     D  V36F3
     D  V37F3
     D  V38F3
     D  V39F3
     D  V40F3
     D  VxxF3                         5S 2 Dim(40) Overlay(VxxF3DS)
      *
     D  VNMDS          DS                  INZ
     D  V01NM
     D  V02NM
     D  V03NM
     D  V04NM
     D  V05NM
     D  V06NM
     D  V07NM
     D  V08NM
     D  V09NM
     D  V10NM
     D  V11NM
     D  V12NM
     D  V13NM
     D  V14NM
     D  V15NM
     D  V16NM
     D  V17NM
     D  V18NM
     D  V19NM
     D  V20NM
     D  V21NM
     D  V22NM
     D  V23NM
     D  V24NM
     D  V25NM
     D  V26NM
     D  V27NM
     D  V28NM
     D  V29NM
     D  V30NM
     D  V31NM
     D  V32NM
     D  V33NM
     D  V34NM
     D  V35NM
     D  V36NM
     D  V37NM
     D  V38NM
     D  V39NM
     D  V40NM
     D  VNM                           6    Dim(40) Overlay(VNMDS)               VENDOR NAME
      *
     D  VN#DS          DS                  INZ
     D  SZVND1
     D  SZVND2
     D  SZVND3
     D  SZVND4
     D  SZVND5
     D  SZVND6
     D  SZVND7
     D  SZVND8
     D  SZVND9
     D  SZVND0
     D  SZVND11                       6  0
     D  SZVND12                       6  0
     D  SZVND13                       6  0
     D  SZVND14                       6  0
     D  SZVND15                       6  0
     D  SZVND16                       6  0
     D  SZVND17                       6  0
     D  SZVND18                       6  0
     D  SZVND19                       6  0
     D  SZVND20                       6  0
     D  SZVND21                       6  0
     D  SZVND22                       6  0
     D  SZVND23                       6  0
     D  SZVND24                       6  0
     D  SZVND25                       6  0
     D  SZVND26                       6  0
     D  SZVND27                       6  0
     D  SZVND28                       6  0
     D  SZVND29                       6  0
     D  SZVND30                       6  0
     D  SZVND31                       6  0
     D  SZVND32                       6  0
     D  SZVND33                       6  0
     D  SZVND34                       6  0
     D  SZVND35                       6  0
     D  SZVND36                       6  0
     D  SZVND37                       6  0
     D  SZVND38                       6  0
     D  SZVND39                       6  0
     D  SZVND40                       6  0
     D  VN#                           6  0 DIM(40) Overlay(VN#DS)
      *
     D  LIN#DS         DS                  INZ
     D  LIN01
     D  LIN02
     D  LIN03
     D  LIN04
     D  LIN05
     D  LIN06
     D  LIN07
     D  LIN08
     D  LIN09
     D  LIN10
     D  LIN11
     D  LIN12
     D  LIN13
     D  LIN14
     D  LIN15
     D  LIN16
     D  LIN17
     D  LIN18
     D  LIN19
     D  LIN20
     D  LIN21
     D  LIN22
     D  LIN23
     D  LIN24
     D  LIN25
     D  LIN26
     D  LIN27
     D  LIN28
     D  LIN29
     D  LIN30
     D  LIN31
     D  LIN32
     D  LIN33
     D  LIN34
     D  LIN35
     D  LIN36
     D  LIN37
     D  LIN38
     D  LIN39
     D  LIN40
     D  LIN                                DIM(40) Overlay(LIN#DS) Like(LIN01)
      *
     D  VNUM#DS        DS                  INZ
     D  VNUM01
     D  VNUM02
     D  VNUM03
     D  VNUM04
     D  VNUM05
     D  VNUM06
     D  VNUM07
     D  VNUM08
     D  VNUM09
     D  VNUM10
     D  VNUM11
     D  VNUM12
     D  VNUM13
     D  VNUM14
     D  VNUM15
     D  VNUM16
     D  VNUM17
     D  VNUM18
     D  VNUM19
     D  VNUM20
     D  VNUM21
     D  VNUM22
     D  VNUM23
     D  VNUM24
     D  VNUM25
     D  VNUM26
     D  VNUM27
     D  VNUM28
     D  VNUM29
     D  VNUM30
     D  VNUM31
     D  VNUM32
     D  VNUM33
     D  VNUM34
     D  VNUM35
     D  VNUM36
     D  VNUM37
     D  VNUM38
     D  VNUM39
     D  VNUM40
     D  VNUM                               DIM(40) Overlay(VNUM#DS) Like(VNUM01)
      *
     D  VNAM#DS        DS                  INZ
     D  VNAM01
     D  VNAM02
     D  VNAM03
     D  VNAM04
     D  VNAM05
     D  VNAM06
     D  VNAM07
     D  VNAM08
     D  VNAM09
     D  VNAM10
     D  VNAM11
     D  VNAM12
     D  VNAM13
     D  VNAM14
     D  VNAM15
     D  VNAM16
     D  VNAM17
     D  VNAM18
     D  VNAM19
     D  VNAM20
     D  VNAM21
     D  VNAM22
     D  VNAM23
     D  VNAM24
     D  VNAM25
     D  VNAM26
     D  VNAM27
     D  VNAM28
     D  VNAM29
     D  VNAM30
     D  VNAM31
     D  VNAM32
     D  VNAM33
     D  VNAM34
     D  VNAM35
     D  VNAM36
     D  VNAM37
     D  VNAM38
     D  VNAM39
     D  VNAM40
     D  VNAM                               DIM(40) Overlay(VNAM#DS) Like(VNAM01)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LCO                    1      2  0                                      ARC380
      *
     IRSERPRC
     I              SPPRC1                      PRC(1)
     I              SPPRC2                      PRC(2)
     I              SPPRC3                      PRC(3)

      ***********************
      ** START HERE        **
      ***********************
     C     RSTART        TAG
     C                   EXSR      BLDSFL
     C                   SETOFF                                       9899
     C     NXTSFL        TAG
     C     PAGE#         IFLE      0
     C     PAGE#         ORGT      LSTREC
     C                   Z-ADD     1             PAGE#
     C                   END
     C   99              SETOFF                                       98
     C     F2RTN         TAG
     C                   If        RECNO > 0
     C                   Eval      *In85 = *On
     C                   Else
     C                   Eval      *In85 = *Off
     C                   EndIf
     C                   EXFMT     RECCTL
      ** CHECK FUNCTION KEYS
     C   KA              DO
     C     LINE          IFGT      0
     C     LINE          CHAIN     RECSFL                             90
     C                   Z-ADD     LINE          PAGE#
     C                   EXSR      GETVEN
     C                   END
     C                   GOTO      NXTSFL
     C                   ENDDO
     C   KB              DO
     C                   WRITE     SCRNV
     C                   READ      SCRNV                                  90
     C                   GOTO      F2RTN
     C                   ENDDO
     C   KF              GOTO      RSTART
     C   KC
     COR KG              GOTO      END
      ** CHECK SUB FILE
     C                   EXSR      CHKSFL
     C   99              GOTO      NXTSFL
      ** IF ALL OK CHECK FOR F4
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTSFL
     C                   END
      ** IF F4 UPDATE ELSE RETURN
     C  NKD              GOTO      NXTSFL
     C                   EXSR      PUTSFL
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** BUILD SUB FILE    **
      ***********************
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     RECCTL
     C                   SETOFF                                       80
      ** INDICATORS 01 THRU 10 INDICATE IF VENDOR COLUMN NEEDED. (ON)
     C                   SETOFF                                       818283
     C                   SETOFF                                       84
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             VENDOR
     C                   Move      SubSet        OldSubSet        10
     C                   Move      LowOnly       OldLowOnly        1
     C                   MOVE      *BLANKS       SECODE
     C                   MOVE      *BLANKS       SEDESC
     C     SEDESC        SETLL     FSERIESA
     C     NXTSER        TAG
     C                   READ      FSERIESA                               90
     C   90              GOTO      ENDBLD
     C                   Z-Add     *Zero         TEST             10 0
      *                Only include Series Codes Requested in SubSet
     C                   If        SubSet <> *Blank and
     C                             %Scan(%Trim(SubSet):SECODE:1) = *Zero
     C                   GOTO      NXTSER
     C                   EndIf
     C                   Eval      SEDESCCODE = %Subst( %Trim(SEDESC) + White +
     C                              '('+%Trim(SECODE)+')' + Blank45 : 1 : 45)
     C                   Eval      LowVend = 0
     C                   Eval      *In96 = *Off
     C                   if        SEPRC > SELPRC                                Low Price not Selec
     C                   Eval      LowVend = 1
     C     SELVND        LOOKUP    VN#(LowVend)                           94
     C                   If        *In94 and SELVND <> SEVND
     C                   Eval      *In96 = *On
     C                   If        SeLPrc <> *Zero
     C                   If        ((SePrc-SeLPrc)/SeLPrc) * 100 > 999.9
     C                   Eval      LowDiff = 999.9
     C                   Else
     C                   Eval      LowDiff = ((SePrc-SeLPrc)/SeLPrc) * 100
     C                   EndIf
     C                   Else
     C                   Eval      LowDiff = 0
     C                   EndIf
     C                   Else
     C                   Eval      LowVend = *Zero
     C                   EndIf
     C                   EndIf
     C                   If        LowOnly = 'Y' and not *In96
     C                   GOTO      NXTSER
     C                   EndIf
     C     SECODE        SETLL     FSERPRCS
     C                   EXSR      RSTIND
     C                   Z-ADD     0             VENDOR
     C                   Z-ADD     SEFORM        FORM
     C     NXTPRC        TAG
     C     SECODE        READE     FSERPRCS                               91
     C   91              DO
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   CLEAR                   RECSFL
     C                   GOTO      NXTSER
     C                   ENDDO
     C     SPSTAT        IFEQ      'D'
     C                   GOTO      NXTPRC
     C                   END
      ** NOW I HAVE A RECORD I NEED
     C                   Z-ADD     1             Y                 2 0
     C     SPVEND        LOOKUP    VN#(Y)                                 94
     C  N94              GOTO      NXTPRC
      ** GET SEL VENDOR
     C     SPVEND        IFEQ      SEVND
     C                   Z-ADD     Y             VENDOR
     C                   END
      ** DETERMINE WHICH COLUMN
      /Free

         VxxF1(Y) = SPPRC1;
         VxxF2(Y) = SPPRC2;
         VxxF3(Y) = SPPRC3;

         If  SPVEND = SEVND and Y <= 20;
           *In((SEFORM * 20) + Y) = *On;
         ENDIF;

      /End-Free
     C                   GOTO      SKIPTHIS
      ** COLUMN 1
     C     Y             IFEQ      1
     C                   Z-ADD     SPPRC1        V01F1                    11
     C                   Z-ADD     SPPRC2        V01F2                    21
     C                   Z-ADD     SPPRC3        V01F3                    31
      ** SEL VENDOR?
     C     SPVEND        IFEQ      SEVND
     C     SEFORM        IFGT      0
     C     SEFORM        COMP      2                                  614151
     C                   END
     C                   END
     C                   GOTO      NXTPRC
     C                   ENDIF                                                  Y = 1
      ** COLUMN 2
     C     Y             IFEQ      2
     C                   Z-ADD     SPPRC1        V02F1                    12
     C                   Z-ADD     SPPRC2        V02F2                    22
     C                   Z-ADD     SPPRC3        V02F3                    32
      ** SEL VENDOR?
     C     SPVEND        IFEQ      SEVND
     C     SEFORM        IFGT      0
     C     SEFORM        COMP      2                                  624252
     C                   END
     C                   END
     C                   GOTO      NXTPRC
     C                   ENDIF                                                  Y = 2
      ** COLUMN 3
     C     Y             IFEQ      3
     C                   Z-ADD     SPPRC1        V03F1                    13
     C                   Z-ADD     SPPRC2        V03F2                    23
     C                   Z-ADD     SPPRC3        V03F3                    33
      ** SEL VENDOR?
     C     SPVEND        IFEQ      SEVND
     C     SEFORM        IFGT      0
     C     SEFORM        COMP      2                                  634353
     C                   END
     C                   END
     C                   GOTO      NXTPRC
     C                   ENDIF                                                  Y = 3
      ** COLUMN 4
     C     Y             IFEQ      4
     C                   Z-ADD     SPPRC1        V04F1                    14
     C                   Z-ADD     SPPRC2        V04F2                    24
     C                   Z-ADD     SPPRC3        V04F3                    34
      ** SEL VENDOR?
     C     SPVEND        IFEQ      SEVND
     C     SEFORM        IFGT      0
     C     SEFORM        COMP      2                                  644454
     C                   END
     C                   END
     C                   GOTO      NXTPRC
     C                   ENDIF                                                  Y = 4
      ** COLUMN 5
     C     Y             IFEQ      5
     C                   Z-ADD     SPPRC1        V05F1                    15
     C                   Z-ADD     SPPRC2        V05F2                    25
     C                   Z-ADD     SPPRC3        V05F3                    35
      ** SEL VENDOR?
     C     SPVEND        IFEQ      SEVND
     C     SEFORM        IFGT      0
     C     SEFORM        COMP      2                                  654555
     C                   END
     C                   END
     C                   GOTO      NXTPRC
     C                   ENDIF                                                  Y = 5
      ** COLUMN 6
     C     Y             IFEQ      6
     C                   Z-ADD     SPPRC1        V06F1                    16
     C                   Z-ADD     SPPRC2        V06F2                    26
     C                   Z-ADD     SPPRC3        V06F3                    36
      ** SEL VENDOR?
     C     SPVEND        IFEQ      SEVND
     C     SEFORM        IFGT      0
     C     SEFORM        COMP      2                                  664656
     C                   END
     C                   END
     C                   GOTO      NXTPRC
     C                   ENDIF                                                  Y = 6
      ** COLUMN 7
     C     Y             IFEQ      7
     C                   Z-ADD     SPPRC1        V07F1                    17
     C                   Z-ADD     SPPRC2        V07F2                    27
     C                   Z-ADD     SPPRC3        V07F3                    37
      ** SEL VENDOR?
     C     SPVEND        IFEQ      SEVND
     C     SEFORM        IFGT      0
     C     SEFORM        COMP      2                                  674757
     C                   END
     C                   END
     C                   GOTO      NXTPRC
     C                   ENDIF                                                  Y = 7
      ** COLUMN 8
     C     Y             IFEQ      8
     C                   Z-ADD     SPPRC1        V08F1                    18
     C                   Z-ADD     SPPRC2        V08F2                    28
     C                   Z-ADD     SPPRC3        V08F3                    38
      ** SEL VENDOR?
     C     SPVEND        IFEQ      SEVND
     C     SEFORM        IFGT      0
     C     SEFORM        COMP      2                                  684858
     C                   END
     C                   END
     C                   GOTO      NXTPRC
     C                   ENDIF                                                  Y = 8
      ** COLUMN 9
     C     Y             IFEQ      9
     C                   Z-ADD     SPPRC1        V09F1                    19
     C                   Z-ADD     SPPRC2        V09F2                    29
     C                   Z-ADD     SPPRC3        V09F3                    39
      ** SEL VENDOR?
     C     SPVEND        IFEQ      SEVND
     C     SEFORM        IFGT      0
     C     SEFORM        COMP      2                                  694959
     C                   END
     C                   END
     C                   GOTO      NXTPRC
     C                   ENDIF                                                  Y = 9
      ** COLUMN 10
     C     Y             IFEQ      10
     C                   Z-ADD     SPPRC1        V10F1                    20
     C                   Z-ADD     SPPRC2        V10F2                    30
     C                   Z-ADD     SPPRC3        V10F3                    40
      ** SEL VENDOR?
     C     SPVEND        IFEQ      SEVND
     C     SEFORM        IFGT      0
     C     SEFORM        COMP      2                                  705060
     C                   END
     C                   END
     C                   GOTO      NXTPRC
     C                   ENDIF                                                  Y = 10
     C     SKIPTHIS      TAG
     C                   GOTO      NXTPRC
      ** END BUILD
     C     ENDBLD        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ENDSR
      ***********************
      ** CHECK SUB FILE    **
      ***********************
     C     CHKSFL        BEGSR
     C                   SETOFF                                       818283
     C                   SETOFF                                       84  99
     C                   Z-ADD     0             RECNO
     C                   Z-ADD     0             PAGE#
     C     SubSet        IfNe      OldSubSet
     C                   Goto      RStart
     C                   EndIf
     C     LowOnly       IfNe      OldLowOnly
     C                   Goto      RStart
     C                   EndIf
     C     NXTCHK        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDCHK
     C                   END
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTCHK
     C     NEW           IFGT      SEDESC
     C**                   Z-ADDRECNO     PAGE#
     C     RECNO         ADD       1             PAGE#
     C     PAGE#         IFGT      LSTREC
     C                   Z-ADD     RECNO         PAGE#
     C                   END
     C                   END
     C                   SETOFF                                       8283
     C                   EXSR      RSTIND
     C     FORM          IFGT      3
     C     FORM          ORLT      0                                            ALLOW 0
     C                   SETON                                        828499
     C                   END
     C     VENDOR        IFGT      NUMVEN
     C     VENDOR        ORLT      0                                            ALLOW 0
     C                   SETON                                        819349    9
     C                   END
      ** SET INDICATORS FOR SUBFILE
      /Free
         // Clear all 'Selected Price' Indicators (Reverse Image)
         For x = 21 to 80;
             *In(x) = *Off;
         EndFor;
         If LowVend <> *Zero ;
           *In96 = *On;
         Else ;
           *In96 = *Off;
         EndIf;
         // Set the Indicator for the 'Selected Price'
             *In((20 * Form) + Vendor) = *On;
      /End-Free
     C                   Goto      SkipCheck
      ** COLUMN 1
     C     V01F1         COMP      0                                      11
     C     V01F2         COMP      0                                      21
     C     V01F3         COMP      0                                      31
      ** SEL VENDOR?
     C     VENDOR        IFEQ      1
     C     FORM          ANDGT     0
     C     FORM          COMP      2                                  614151
     C                   END
      ** COLUMN 2
     C     V02F1         COMP      0                                      12
     C     V02F2         COMP      0                                      22
     C     V02F3         COMP      0                                      32
      ** SEL VENDOR?
     C     VENDOR        IFEQ      2
     C     FORM          ANDGT     0
     C     FORM          COMP      2                                  624252
     C                   END
      ** COLUMN 3
     C     V03F1         COMP      0                                      13
     C     V03F2         COMP      0                                      23
     C     V03F3         COMP      0                                      33
      ** SEL VENDOR?
     C     VENDOR        IFEQ      3
     C     FORM          ANDGT     0
     C     FORM          COMP      2                                  634353
     C                   END
      ** COLUMN 4
     C     V04F1         COMP      0                                      14
     C     V04F2         COMP      0                                      24
     C     V04F3         COMP      0                                      34
      ** SEL VENDOR?
     C     VENDOR        IFEQ      4
     C     FORM          ANDGT     0
     C     FORM          COMP      2                                  644454
     C                   END
      ** COLUMN 5
     C     V05F1         COMP      0                                      15
     C     V05F2         COMP      0                                      25
     C     V05F3         COMP      0                                      35
      ** SEL VENDOR?
     C     VENDOR        IFEQ      5
     C     FORM          ANDGT     0
     C     FORM          COMP      2                                  654555
     C                   END
      ** COLUMN 6
     C     V06F1         COMP      0                                      16
     C     V06F2         COMP      0                                      26
     C     V06F3         COMP      0                                      36
      ** SEL VENDOR?
     C     VENDOR        IFEQ      6
     C     FORM          ANDGT     0
     C     FORM          COMP      2                                  664656
     C                   END
      ** COLUMN 7
     C     V07F1         COMP      0                                      17
     C     V07F2         COMP      0                                      27
     C     V07F3         COMP      0                                      37
      ** SEL VENDOR?
     C     VENDOR        IFEQ      7
     C     FORM          ANDGT     0
     C     FORM          COMP      2                                  674757
     C                   END
      ** COLUMN 8
     C     V08F1         COMP      0                                      18
     C     V08F2         COMP      0                                      28
     C     V08F3         COMP      0                                      38
      ** SEL VENDOR?
     C     VENDOR        IFEQ      8
     C     FORM          ANDGT     0
     C     FORM          COMP      2                                  684858
     C                   END
      ** COLUMN 9
     C     V09F1         COMP      0                                      19
     C     V09F2         COMP      0                                      29
     C     V09F3         COMP      0                                      39
      ** SEL VENDOR?
     C     VENDOR        IFEQ      9
     C     FORM          ANDGT     0
     C     FORM          COMP      2                                  694959
     C                   END
      ** COLUMN 10
     C     V10F1         COMP      0                                      20
     C     V10F2         COMP      0                                      30
     C     V10F3         COMP      0                                      40
      ** SEL VENDOR?
     C     VENDOR        IFEQ      10
     C     FORM          ANDGT     0
     C     FORM          COMP      2                                  705060
     C                   END
     C     SkipCheck     TAG
     C                   UPDATE    RECSFL
     C                   GOTO      NXTCHK
     C     ENDCHK        TAG
     C                   ENDSR
      ***********************
      **   PUT SUB FILE    **
      ***********************
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   END
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTPUT
     C     SECODE        CHAIN     FSERIES                            91
     C     VENDOR        IFGT      0
     C                   Z-ADD     VN#(VENDOR)   SEVND
     C     PRCKEY        KLIST
     C                   KFLD                    SEVND
     C                   KFLD                    SECODE
     C     PRCKEY        CHAIN     FSERPRC                            92
     C     FORM          IFGT      0
     C                   Z-ADD     PRC(FORM)     SEPRC
     C                   ELSE
     C                   Z-ADD     0             SEPRC
     C                   END
     C                   ELSE
     C                   Z-ADD     0             SEVND
     C                   Z-ADD     0             SEPRC
     C                   END
     C                   Z-ADD     FORM          SEFORM
     C  N91              UPDATE    RSERIES
     C                   GOTO      NXTPUT
     C     ENDPUT        TAG
     C                   ENDSR
      ***********************
      ** GET VENDOR PRICE  **
      ***********************
     C     GETVEN        BEGSR
     C                   MOVEL     SECODE        SERIES           10
     C                   Z-ADD     FORM          SEFORM
     C                   Z-ADD     0             SPVEND
     C                   CALL      'SDR500'
     C                   PARM                    SERIES
     C                   PARM                    SPVEND
     C                   PARM                    SEFORM
     C                   Z-ADD     1             Y
     C     LINE          CHAIN     RECSFL                             90
     C     SPVEND        LOOKUP    VN#(Y)                                 94
     C   94
     CANN90              Z-ADD     Y             VENDOR
     C  N90              UPDATE    RECSFL
     C                   ENDSR
      ***********************
      ** RESET SUBFILE IND **
      ***********************
     C     RSTIND        BEGSR
     C                   Z-ADD     21            Y
     C                   DOW       Y < 80
     C                   MOVEA     '0'           *IN(Y)
     C                   ADD       1             Y
     C                   ENDDO
     C                   ENDSR
      ***********************
      ** GET VENDOR NAMES  **
      ***********************
     C     GETVNM        BEGSR
     C                   Eval      VNMDS = *Blanks
     C                   Z-ADD     0             VEND              6 0
     C     VEND          SETLL     FSERPRC
     C     NXTVNM        TAG
     C                   READ      FSERPRC                                90
     C   90              GOTO      ENDVNM
     C     SPVEND        IFEQ      VEND
     C                   GOTO      NXTVNM
     C                   END
     C                   Z-ADD     1             Y                 2 0
     C     SPVEND        LOOKUP    VN#(Y)                                 94
     C  N94              DO
     C     X             IFLT      40
     C                   ADD       1             X
     C                   Z-ADD     SPVEND        VN#(X)
     C                   Z-ADD     SPVEND        VEND
     C                   GOTO      NXTVNM
     C                   END
     C                   GOTO      ENDVNM
     C                   ENDDO
     C                   GOTO      NXTVNM
     C     ENDVNM        TAG
      ** IF MORE THAN 10 ONLY USE 10 FOR HEADING
     C                   Z-ADD     X             NUMVEN            2 0
     C     X             IFGT      40
     C                   SETON                                        97
     C                   Z-ADD     20            X1                2 0
     C                   ELSE
     C                   Z-ADD     X             X1                2 0
     C                   END
     C                   Z-ADD     1             Y
     C     Y             DOUGT     X1
     C     VN#(Y)        CHAIN     FMVEND                             90
     C  N90              MOVEL     VMLOOK        VNM(Y)
     C  N90              MOVE      '1'           *IN(Y)
     C   90              MOVE      '0'           *IN(Y)
     C                   ADD       1             Y
     C                   ENDDO
     C*                  MOVEL     VNM(1)        V01NM
     C*                  MOVEL     VNM(2)        V02NM
     C*                  MOVEL     VNM(3)        V03NM
     C*                  MOVEL     VNM(4)        V04NM
     C*                  MOVEL     VNM(5)        V05NM
     C*                  MOVEL     VNM(6)        V06NM
     C*                  MOVEL     VNM(7)        V07NM
     C*                  MOVEL     VNM(8)        V08NM
     C*                  MOVEL     VNM(9)        V09NM
     C*                  MOVEL     VNM(10)       V10NM
     C*                  MOVEL     VNM(11)       V11NM
     C*                  MOVEL     VNM(12)       V12NM
     C*                  MOVEL     VNM(13)       V13NM
     C*                  MOVEL     VNM(14)       V14NM
     C*                  MOVEL     VNM(15)       V15NM
     C*                  MOVEL     VNM(16)       V16NM
     C*                  MOVEL     VNM(17)       V17NM
     C*                  MOVEL     VNM(18)       V18NM
     C*                  MOVEL     VNM(19)       V19NM
     C*                  MOVEL     VNM(20)       V20NM
      ** BUILD SCRNV
     C                   Z-ADD     0             V                 2 0
      //Free
         For V = 1 to 40;
           If VN#(V) > 0;
             Clear RMVEND;
             Chain VN#(V) FMVEND;
               If %Found(FMVEND);
                 LIN(V) = V;
                 VNUM(V) = VN#(V);
                 VNAM(V) = VMNAME;
               EndIF;
           EndIf;
         EndFor;
     C*    VN#(1)        IFGT      0
     C*                  Z-ADD     1             Y
     C*    VN#(Y)        CHAIN     FMVEND                             90
     C* N90              MOVEL     VMNAME        VNAM01
     C* N90              Z-ADD     Y             LIN01
     C* N90              Z-ADD     VN#(Y)        VNUM01
     C*                  END
      *
     C*    VN#(2)        IFGT      0
     C*                  Z-ADD     2             Y
     C*    VN#(Y)        CHAIN     FMVEND                             90
     C* N90              MOVEL     VMNAME        VNAM02
     C* N90              Z-ADD     Y             LIN02
     C* N90              Z-ADD     VN#(Y)        VNUM02
     C*                  END
     C*    VN#(3)        IFGT      0
     C*                  Z-ADD     3             Y
     C*    VN#(Y)        CHAIN     FMVEND                             90
     C* N90              MOVEL     VMNAME        VNAM03
     C* N90              Z-ADD     Y             LIN03
     C* N90              Z-ADD     VN#(Y)        VNUM03
     C*                  END
     C*    VN#(4)        IFGT      0
     C*                  Z-ADD     4             Y
     C*    VN#(Y)        CHAIN     FMVEND                             90
     C* N90              MOVEL     VMNAME        VNAM04
     C* N90              Z-ADD     Y             LIN04
     C* N90              Z-ADD     VN#(Y)        VNUM04
     C*                  END
     C*    VN#(5)        IFGT      0
     C*                  Z-ADD     5             Y
     C*    VN#(Y)        CHAIN     FMVEND                             90
     C* N90              MOVEL     VMNAME        VNAM05
     C* N90              Z-ADD     Y             LIN05
     C* N90              Z-ADD     VN#(Y)        VNUM05
     C*                  END
     C*    VN#(6)        IFGT      0
     C*                  Z-ADD     6             Y
     C*    VN#(Y)        CHAIN     FMVEND                             90
     C* N90              MOVEL     VMNAME        VNAM06
     C* N90              Z-ADD     Y             LIN06
     C* N90              Z-ADD     VN#(Y)        VNUM06
     C*                  END
     C*    VN#(7)        IFGT      0
     C*                  Z-ADD     7             Y
     C*    VN#(Y)        CHAIN     FMVEND                             90
     C* N90              MOVEL     VMNAME        VNAM07
     C* N90              Z-ADD     Y             LIN07
     C* N90              Z-ADD     VN#(Y)        VNUM07
     C*                  END
     C*    VN#(8)        IFGT      0
     C*                  Z-ADD     8             Y
     C*    VN#(Y)        CHAIN     FMVEND                             90
     C* N90              MOVEL     VMNAME        VNAM08
     C* N90              Z-ADD     Y             LIN08
     C* N90              Z-ADD     VN#(Y)        VNUM08
     C*                  END
     C*    VN#(9)        IFGT      0
     C*                  Z-ADD     9             Y
     C*    VN#(Y)        CHAIN     FMVEND                             90
     C* N90              MOVEL     VMNAME        VNAM09
     C* N90              Z-ADD     Y             LIN09
     C* N90              Z-ADD     VN#(Y)        VNUM09
     C*                  END
     C*    VN#(10)       IFGT      0
     C*                  Z-ADD     10            Y
     C*    VN#(Y)        CHAIN     FMVEND                             90
     C* N90              MOVEL     VMNAME        VNAM10
     C* N90              Z-ADD     Y             LIN10
     C* N90              Z-ADD     VN#(Y)        VNUM10
     C*                  END
     C*    VN#(11)       IFGT      0
     C*                  Z-ADD     11            Y
     C*    VN#(Y)        CHAIN     FMVEND                             90
     C* N90              MOVEL     VMNAME        VNAM11
     C* N90              Z-ADD     Y             LIN11
     C* N90              Z-ADD     VN#(Y)        VNUM11
     C*                  END
     C*    VN#(12)       IFGT      0
     C*                  Z-ADD     12            Y
     C*    VN#(Y)        CHAIN     FMVEND                             90
     C* N90              MOVEL     VMNAME        VNAM12
     C* N90              Z-ADD     Y             LIN12
     C* N90              Z-ADD     VN#(Y)        VNUM12
     C*                  END
     C*    VN#(13)       IFGT      0
     C*                  Z-ADD     13            Y
     C*    VN#(Y)        CHAIN     FMVEND                             90
     C* N90              MOVEL     VMNAME        VNAM13
     C* N90              Z-ADD     Y             LIN13
     C* N90              Z-ADD     VN#(Y)        VNUM13
     C*                  END
     C*    VN#(14)       IFGT      0
     C*                  Z-ADD     14            Y
     C*    VN#(Y)        CHAIN     FMVEND                             90
     C* N90              MOVEL     VMNAME        VNAM14
     C* N90              Z-ADD     Y             LIN14
     C* N90              Z-ADD     VN#(Y)        VNUM14
     C*                  END
     C*    VN#(15)       IFGT      0
     C*                  Z-ADD     15            Y
     C*    VN#(Y)        CHAIN     FMVEND                             90
     C* N90              MOVEL     VMNAME        VNAM15
     C* N90              Z-ADD     Y             LIN15
     C* N90              Z-ADD     VN#(Y)        VNUM15
     C*                  END
     C*    VN#(16)       IFGT      0
     C*                  Z-ADD     16            Y
     C*    VN#(Y)        CHAIN     FMVEND                             90
     C* N90              MOVEL     VMNAME        VNAM16
     C* N90              Z-ADD     Y             LIN16
     C* N90              Z-ADD     VN#(Y)        VNUM16
     C*                  END
     C*    VN#(17)       IFGT      0
     C*                  Z-ADD     17            Y
     C*    VN#(Y)        CHAIN     FMVEND                             90
     C* N90              MOVEL     VMNAME        VNAM17
     C* N90              Z-ADD     Y             LIN17
     C* N90              Z-ADD     VN#(Y)        VNUM17
     C*                  END
     C*    VN#(18)       IFGT      0
     C*                  Z-ADD     18            Y
     C*    VN#(Y)        CHAIN     FMVEND                             90
     C* N90              MOVEL     VMNAME        VNAM18
     C* N90              Z-ADD     Y             LIN18
     C* N90              Z-ADD     VN#(Y)        VNUM18
     C*                  END
     C*    VN#(19)       IFGT      0
     C*                  Z-ADD     19            Y
     C*    VN#(Y)        CHAIN     FMVEND                             90
     C* N90              MOVEL     VMNAME        VNAM19
     C* N90              Z-ADD     Y             LIN19
     C* N90              Z-ADD     VN#(Y)        VNUM19
     C*                  END
     C*    VN#(20)       IFGT      0
     C*                  Z-ADD     20            Y
     C*    VN#(Y)        CHAIN     FMVEND                             90
     C* N90              MOVEL     VMNAME        VNAM20
     C* N90              Z-ADD     Y             LIN20
     C* N90              Z-ADD     VN#(Y)        VNUM20
     C*                  END
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Eval      LowOnly = 'N'
     C     01            CHAIN     FSEDCTL                            90
     C                   Z-ADD     1             X                 2 0
     C                   DOW       VN#(X) > 0 and X < 10
     C                   Eval      x += 1
     C                   EndDO
     C*    SZVND1        IFGT      0
     C*                  ADD       1             X
     C*                  Z-ADD     SZVND1        VN#(X)
     C*                  END
     C*    SZVND2        IFGT      0
     C*                  ADD       1             X
     C*                  Z-ADD     SZVND2        VN#(X)
     C*                  END
     C*    SZVND3        IFGT      0
     C*                  ADD       1             X
     C*                  Z-ADD     SZVND3        VN#(X)
     C*                  END
     C*    SZVND4        IFGT      0
     C*                  ADD       1             X
     C*                  Z-ADD     SZVND4        VN#(X)
     C*                  END
     C*    SZVND5        IFGT      0
     C*                  ADD       1             X
     C*                  Z-ADD     SZVND5        VN#(X)
     C*                  END
     C*    SZVND6        IFGT      0
     C*                  ADD       1             X
     C*                  Z-ADD     SZVND6        VN#(X)
     C*                  END
     C*    SZVND7        IFGT      0
     C*                  ADD       1             X
     C*                  Z-ADD     SZVND7        VN#(X)
     C*                  END
     C*    SZVND8        IFGT      0
     C*                  ADD       1             X
     C*                  Z-ADD     SZVND8        VN#(X)
     C*                  END
     C*    SZVND9        IFGT      0
     C*                  ADD       1             X
     C*                  Z-ADD     SZVND9        VN#(X)
     C*                  END
     C*    SZVND0        IFGT      0
     C*                  ADD       1             X
     C*                  Z-ADD     SZVND0        VN#(X)
     C*                  END
     C                   EXSR      GETVNM
     C                   ENDSR
