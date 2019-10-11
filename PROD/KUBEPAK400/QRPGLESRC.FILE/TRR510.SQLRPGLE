      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2002
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
      **PROGRAM NAME-------- TRR510
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- PRINT INDIVIDUAL TRUCK SCHEDULE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      //--------------------------------------------------------------------
      *?                :---------------:
      *?                : Modifications :
      *?                :---------------:
      * ------  --------   ----------   ------------------------------------
      * MOD#    MOD Date   Programmer   Description
      * ------  --------   ----------   ------------------------------------
      * SUD01   12/10/18  S.Uthaya      Replaced FCMDIR File By using new
      *                                 FDIRECTL0 - Direction
      //--------------------------------------------------------------------
     FFTRSCHDT  IF   E           K DISK
     FFTRHDRW   IF   E           K DISK
     FFOECTL    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFHORDR    IF   E           K DISK
SUD01F*FCMDIR    IF   E           K DISK           // Replaced by New FDirectl0 File
  |   *?File: Ship-To Directions Logical File
  |   *?Key : Customer Number : Seq# Number
  |  FFDirectl0 IF   E           K DISK
  |   *?File: Order Header Ship-to File
  |   *?Key : Order Number : Customer Number
SUD01FFHORDRSHTLIF   E           K DISK
     FTRR510    O    F   80        PRINTER OFLIND(*INOF)

     D  SavTRSTP#      S                   Like(TRSTP#)  Inz(999)
     D  SavTRTRK#      S                   Like(TRTRK#)  Inz('9990')

      *
      * ADDRESS WORK ARRAY
     D #SL             S             32    DIM(6)
      * DIRECTIONS ARRAY
     D WKD             S             72    DIM(11)                                               QPK
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
     D  LDATE                  3      8  0
     D  LSDATE                 9     15  0
     D  LTRUCK                16     19
     D  LROUT                 20     21
     D  LDIR                  22     22
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
WJB
WJB  D categ           S              4    DIM(6) CTDATA PERRCD(1)              CATEGORIES
WJB
WJB  D  TRQTY_DS       DS
WJB  D  TRQTY1
WJB  D  TRQTY2
WJB  D  TRQTY3
WJB  D  TRQTY4
WJB  D  TRQTY5
WJB  D  TRQTY6
WJB  D  TRQTY                              Like(TRQTY1) Dim(6) Overlay(TRQTY_DS)
WJB
WJB  D  OrdQTY_DS      DS                  Inz
WJB  D  OrdQTY1                            Like(TRQTY1)
WJB  D  OrdQTY2                            Like(TRQTY2)
WJB  D  OrdQTY3                            Like(TRQTY3)
WJB  D  OrdQTY4                            Like(TRQTY4)
WJB  D  OrdQTY5                            Like(TRQTY5)
WJB  D  OrdQTY6                            Like(TRQTY6)
WJB  D  OrdQTY                             Like(OrdQTY1) Dim(6)
WJB  D                                     Overlay(OrdQTY_DS)
WJB
WJB  D  COL1           S              1S 0 Inz(1)
WJB  D  COL2           S              1S 0 Inz(1)
WJB  D  COL3           S              1S 0 Inz(1)
WJB  D  COL4           S              1S 0 Inz(1)
WJB  D  COL5           S              1S 0 Inz(1)
WJB  D  COL6           S              1S 0 Inz(1)
WJB
WJB  D  VHDG5          S              4A   Inz('N/A')
WJB  D  VHDG6          S              4A   Inz('OVRC')
WJB
SUD01D  Direct         S             80A   Inz(' ')
SUD01D  IN24           S               N
      *
      * REDEFINE FIELD NAMES
     IRMCUST
     I              CMNAME                      #WSLD1
     I              CMADD2                      #WSLD2
     I              CMADD3                      #WSLD3
     I              CMADD4                      #WSLD4
     I              CMCITY                      #WSLCT
     I              CMSTST                      #WSLST
     I              CMZIP                       #WSLZP
      *                                                                   ARR510
     IRHORDR
     I              OHNAME                      #WSLD1
     I              OHSHP2                      #WSLD2
     I              OHSHP3                      #WSLD3
     I              OHSHP4                      #WSLD4
     I              OHSHCT                      #WSLCT
     I              OHSHST                      #WSLST
     I              OHSHZP                      #WSLZP
      *                                                                   ARR510
SUD01I*RCMDIR
  |  I*              CMDR01                      WKD(1)
  |  I*              CMDR02                      WKD(2)
  |  I*              CMDR03                      WKD(3)
  |  I*              CMDR04                      WKD(4)
  |  I*              CMDR05                      WKD(5)
  |  I*             CMDR06                      WKD(6)
  |  I*             CMDR07                      WKD(7)
  |  I*             CMDR08                      WKD(8)
  |  I*             CMDR09                      WKD(9)
  |  I*             CMDR10                      WKD(10)
SUD01I*             CMDR11                      WKD(11)
      *******************
      * START HERE      *
      *******************
     C     LSDATE        SETLL     FTRHDRW
     C     NXT           TAG
     C     LSDATE        READE     FTRHDRW                                90
     C   90              GOTO      END
     C     LROUT         IFGT      *BLANKS
     C     THROUT        ANDNE     LROUT
     C                   GOTO      NXT
     C                   END
     C     LTRUCK        IFGT      *BLANKS
     C     THTRK#        ANDNE     LTRUCK
     C                   GOTO      NXT
     C                   END
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF  DO
     C*          THTRK#    IFLE *BLANKS
     C*                    MOVELTHROUT    THTRK#
     C*                    END
     C                   EXCEPT    TRKHED
      ** GET DETAIL RECS
     C     TRKKEY        KLIST
     C                   KFLD                    THTRK#
     C                   KFLD                    THSHDT
     C                   Z-ADD     0             STOP              3 0
     C                   Z-ADD     0             TQTY1             5 0
     C                   Z-ADD     0             TQTY2             5 0
     C                   Z-ADD     0             TQTY3             5 0
     C                   Z-ADD     0             TQTY4             5 0

     C                   Move      THSHDT        THSHDT@           7
     C                   Call      'TRR502'
     C                   Parm                    THTRK#
     C                   Parm                    THSHDT@

     C     TRKKEY        SETLL     FTRSCHDT
     C     NXTD          TAG
     C     TRKKEY        READE     FTRSCHDT                               90
     C   90              GOTO      ENDTRK
     C                   ADD       1             STOP
     C                   If        TRSTP# = SavTRSTP# and
     C                             TRTRK# = SavTRTRK#
     C                   Eval      *In60 = *On
     C                   Else
     C                   Eval      *In60 = *Off
     C                   Eval      SavTRTRK# = TRTRK#
     C                   Eval      SavTRSTP# = TRSTP#
     C                   EndIf
      /Free
       In24 = *Off;
       Exec SQL
         Select '1' into :IN24 from FHORDRCSTM where COORD# = :TRORD#
           Fetch First Row Only;
       *In24 = IN24;
      /End-Free
WJB
WJB  C                   IF        TRQTY(col1) = %INT(TRQTY(col1))
WJB  C                   Z-ADD     TRQTY(col1)   QTY1              5 0
WJB  C                   Else
WJB  C                   Eval      QTY1 = %Int(TRQTY(col1)) + 1
WJB  C                   EndIf
WJB
WJB  C                   IF        TRQTY(col2) = %INT(TRQTY(col2))
WJB  C                   Z-ADD     TRQTY(col2)   QTY2              5 0
WJB  C                   Else
WJB  C                   Eval      QTY2 = %Int(TRQTY(col2)) + 1
WJB  C                   EndIf
WJB
WJB  C                   IF        TRQTY(col3) = %INT(TRQTY(col3))
WJB  C                   Z-ADD     TRQTY(col3)   QTY3              5 0
WJB  C                   Else
WJB  C                   Eval      QTY3 = %Int(TRQTY(col3)) + 1
WJB  C                   EndIf
WJB
WJB  C                   IF        TRQTY(col4) = %INT(TRQTY(col4))
WJB  C                   Z-ADD     TRQTY(col4)   QTY4              5 0
WJB  C                   Else
WJB  C                   Eval      QTY4 = %Int(TRQTY(col4)) + 1
WJB  C                   EndIf
WJB
WJB  C                   IF        TRQTY(col5) = %INT(TRQTY(col5))
WJB  C                   Z-ADD     TRQTY(col5)   QTY5              5 0
WJB  C                   Else
WJB  C                   Eval      QTY5 = %Int(TRQTY(col5)) + 1
WJB  C                   EndIf
WJB
WJB  C                   IF        TRQTY(col6) = %INT(TRQTY(col6))
WJB  C                   Z-ADD     TRQTY(col6)   QTY6              5 0
WJB  C                   Else
WJB  C                   Eval      QTY6 = %Int(TRQTY(col6)) + 1
WJB  C                   EndIf
WJB
     C                   IF        QTY6 <> 0
     C                   Eval      QTY3 = QTY6
     C                   IF        QTY6 = 100
     C                   Eval      QTY3 = *Zero
     C                   EndIf
     C                   EndIf

     C                   ADD       QTY1          TQTY1                                         QPK53
     C                   ADD       QTY2          TQTY2                                         QPK53
     C                   ADD       QTY3          TQTY3                                         QPK53
     C                   ADD       QTY4          TQTY4                                         QPK53
     C                   Clear                   RHORDR
     C     TRORD#        CHAIN     FHORDR                             21
     C                   CLEAR                   RMCUST
     C                   If        not %Found(FHORDR)
     C     TRCUST        CHAIN     FMCUST                             21
     C                   Else
     C     OHCUST        CHAIN     FMCUST                             21
      * moved the chain to fhordr after customer per Bill S. so pgm uses address from Order Header
     C     TRORD#        CHAIN     FHORDR
     C                   EndIf
     C                   EXSR      #SLD
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF  DO
     C                   EXCEPT    CUST1
     C                   Z-ADD     2             C                 2 0
     C                   EXCEPT    CUSTORD
     C                   EXCEPT    CUST2
     C     NXTC          TAG
     C                   ADD       1             C
     C     C             IFLE      6
     C     #SL(C)        IFGT      *BLANKS
     C  N60              EXCEPT    CUST2
     C                   GOTO      NXTC
     C                   END
     C                   END
      ** GET DIRECTIONS
     C     LDIR          IFEQ      'Y'
     C                   If        %Found(FHORDR)
     C                   Eval      CMCUST = OHCUST
     C                   EndIf
SUD01C*    CMCUST        CHAIN     FCMDIR                             80
  |  C* N80              DO
  |  C*                  Z-ADD     0             X                 3 0
  |  C*  OF              DO
  |  C*                  EXCEPT    HEAD
  |  C*                  SETOFF                                       OF
  |  C*                  ENDDO                                                  OF  DO
  |  C*                  EXCEPT    DIRLN1
  |  C*    NXTX          TAG
  |  C*                  ADD       1             X
  |  C*    X             IFLE      11
  |  C*    WKD(X)        IFGT      *BLANKS
  |  C*  OF              DO
  |  C*                  EXCEPT    HEAD
  |  C*                  SETOFF                                       OF
  |  C*                  ENDDO                                                  OF  DO
  |  C*                  EXCEPT    DIRLN
  |  C*                  END                                                    WKD,X>" "
  |  C*                  GOTO      NXTX
  |  C*                  END                                                    X<=11
  |  C*                  ENDDO                                                  N80  DO
  |  C                   END                                                    LDIR=Y
  |   /Free
  |        OSSeq# = 0;
  |   *?   // Check Record Exits in FHORDRSHTO
  |        Chain (TRORD#:OHCUST) FHORDRSHTL;
  |    //  If %Found;
  |
  |   *?      // Write Detail1
  |           Except DIRLN1;
  |           Setll (OHCust:OSSeq#) FDIRECTL0;
  |           ReadE (OHCust:OSSeq#) FDIRECTL0;
  |           Dow Not %Eof(FDIRECTL0);
  |
  |   *?         // Write Header
  |              If *InOF = *On;
  |                 *InOF = *Off;
  |                 Except Head;
  |              Endif;
  |
  |   *?         // Write Detail2
  |              Direct = SDText;
  |              Except DIRLN;
  |              ReadE (OHCust:OSSeq#) FDIRECTL0;
  |           Enddo;
  |      //Endif;
  |   /End-Free
SUD01C                   GOTO      NXTD
      ** END OF TRUCK
     C     ENDTRK        TAG
     C                   EXCEPT    TRKTOT
     C                   SETON                                        OF
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      ***********
      * #SLD    *
      ***********
      *  THIS SUBROUTINE REMOVES BLANK ADDRESS LINES FROM THE SOLD TO
      *  ADDRESS.  WORK FIELDS ARE DEFINED AS:
      *
      *                 WORK  = CITY,STATE,ZIP(9 DIGIT)
      *                 WORK1 = CITY, STATE
      *                 WORK2 = ZIP CODE(XXXXX-XXXX)
      *                 WORK3 = STANDARD ZIP CODE(XXXXX)
      *                 WORK4 = ADDITIONAL ZIP CODE(-XXXX)
      *
      *  THE SUBROUTINE REQUIRES MOVING NAME AND ADDRESS INFORMATION TO
      *  BE CONDENSED TO A DATA STRUCTURE
      *
     C     #SLD          BEGSR
      *
     C                   MOVE      *BLANKS       #SL
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WSLD1        #SL(#X)
     C                   ADD       1             #X
     C     #WSLD2        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD1
     C                   MOVEL     #WSLD2        #SL(#X)
     C                   ADD       1             #X
     C     #SLD1         TAG
     C     #WSLD3        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD2
     C                   MOVEL     #WSLD3        #SL(#X)
     C                   ADD       1             #X
     C     #SLD2         TAG
     C     #WSLD4        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD3
     C                   MOVEL     #WSLD4        #SL(#X)
     C                   ADD       1             #X
     C     #SLD3         TAG
     C                   MOVE      *BLANKS       WORK             32
     C                   MOVE      *BLANKS       WORK1            21
     C                   MOVE      *BLANKS       WORK2            10
     C                   MOVE      *BLANKS       WORK3             5
     C                   MOVE      *BLANKS       WORK4             5
     C     #WSLCT        CAT       #WSLST:1      WORK1
     C                   MOVEL     #WSLZP        WORK3
     C                   MOVE      #WSLZP        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #SL(#X)
     C                   SETOFF                                       919293
     C                   ADD       1             #X
     C                   MOVEL     CMCOUN        #SL(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   SETON                                        OF
     C     01            CHAIN     FOECTL                             90
     C                   MOVE      OCHDG1        VHDG1             4
     C                   MOVE      OCHDG2        VHDG2             4
     C                   MOVE      OCHDG3        VHDG3             4
     C                   MOVE      OCHDG4        VHDG4             4
WJB  C                   MOVEL     'N/A'         VHDG5             4
WJB  C                   MOVEL     'N/A'         VHDG6             4            #6 Override Carts
WJB
WJB  C                   Eval      COL1 = 1
WJB  C                   Eval      COL2 = 1
WJB  C                   Eval      COL3 = 1
WJB  C                   Eval      COL4 = 1
WJB  C                   Eval      COL5 = 5
WJB  C                   Eval      COL6 = 6
WJB
WJB  C     VHDG1         LOOKUP    CATEG(COL1)                            33
WJB  C     VHDG2         LOOKUP    CATEG(COL2)                            34
WJB  C     VHDG3         LOOKUP    CATEG(COL3)                            35
WJB  C     VHDG4         LOOKUP    CATEG(COL4)                            36
WJB  C*    VHDG5         LOOKUP    CATEG(COL5)                            37
WJB  C*    VHDG6         LOOKUP    CATEG(COL6)                            38
WJB
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OTRR510    E            HEAD           1 03
     O                                            6 'TRR510'
     O                                           24 'Requested by:'
     O                       USERID              35
     O                                           45 'Kube-Pak'
     O                       PAGE          Z     80
     O                                           76 'Page:'
     O          E            HEAD           2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           48 'Truck Schedule'
     O                                           71 'Time:'
     O                       TIMOD               80 '  :  :  '
     O          E            TRKHED         1                                   QPK530
     O                                            7 'Truck:'                    QPK520
     O                       THTRK#              12                             QPK520
     O                                           25 'Ship Date:'                QPK520
     O                       LDATE         Y     34                             QPK520
     O                                           44 'Driver:'
     O                       THDRIV              51
     O                                           63 '1st Stop:'
     O                       THSTOP              74
     O          E            TRKHED         0                                   QPK530
     O**                       THCOMM    45
     O                       VHDG1               64
     O                       VHDG2               69
     O                       VHDG4               74
     O                       VHDG3               79
     O          E            TRKHED         1                                   QPK520
     O                                           64 '____'
     O                                           69 '____'
     O                                           74 '____'
     O                                           79 '____'
     O          EF           CUST1       1  1                                   QPK530
WJB  O*                      STOP          Z      3                             QPK530
WJB  O                       TRSTP#        Z      3                             QPK530
     O                       OHCUST        Z     10                             QPK530
     O              N21      #SL(1)              43                             QPK530
     O              N21      CMPHON              57 '   -   -    '              QPK530
     O               21                          37 ' ** Customer NOT on file'  QPK530
     O               21                          41 ' ** '                      QPK530
     O                       QTY1          Z     64                             QPK530
     O                       QTY2          Z     69                             QPK530
     O                       QTY4          Z     74                             QPK530
     O                       QTY3          Z     79                             QPK530
     O          E            CUSTORD        0                                   QPK530
     O               60                          36 '----Additional Order-----'
     O                                           50 'Order:'
     O                       TRORD#        Z     57                             QPK530
     O          EF           CUST2          1                                   QPK530
     O              N60      #SL(C)              43                             QPK530
     O          EF           DIRLN1      1  1
     O              N60                          17 '** Directions **'
     O               60                          27 '** See Directions Above **'
SUD01O*             N60                          35 'Map coordinates:'
  |  O*             N60      CMCOR1              38
  |  O*             N60                          39 '-'
SUD01O*             N60      CMCOR2              41
     O          EF  N60      DIRLN          1
SUD01O*                      WKD(X)              80
SUD01O                       DIRECT              80
     O          E            TRKTOT         1                                   QPK530
     O                                           59 '** Truck Totals **'        QPK530
     O                       TQTY1         Z     64                             QPK530
     O                       TQTY2         Z     69                             QPK530
     O                       TQTY4         Z     74                             QPK530
     O                       TQTY3         Z     79                             QPK530
** HDG NAMES
PLUG
FLAT
CART
HBPT
POIN
OVRC
