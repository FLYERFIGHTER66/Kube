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
      **PROGRAM NAME-------- TRR520
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- PRINT MASTER TRUCK SCHEDULE
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
      * SUD01   12/11/18  S.Uthaya      Replaced FCMDIR File By using new
      *                                 FDIRECTL0 - Direction
      *
SUD01 //--------------------------------------------------------------------
  |   *?                :----------------------:
  |   *?                : Header Specification :
  |   *?                :----------------------:
  |   *
SUD01   Ctl-Opt DftActGrp(*no) BndDir('*LIBL/KPFUNCTION');
      //--------------------------------------------------------------------
     FFTRSCHDT  IF   E           K DISK
      *FFTRHDRHRIF  E           K        DISK
     FFTRHDRW   IF   E           K DISK
     FFOECTL    IF   E           K DISK
     FFMCUST    IF   E           K DISK
SUD01F*FCMDIR    IF   E           K DISK
  |   *?File: Ship-To Directions Logical File
  |   *?Key : Customer Number : Seq# Number
  |  FFDirectl0 IF   E           K DISK
  |   *
  |   *?File: Order Header Ship-to Logical File
  |   *?Key : Order# : Customer#
SUD01FFHORDRSHTLIF   E           K DISK                                         Order Header Ship-to
     FFHORDR    IF   E           K DISK
     FTRR520    O    F   80        PRINTER OFLIND(*INOF)
      *
      *
SUD01D/COPY QFunctDefn,$ChkDir
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
     D  LPRTR2                90     99
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133

     D categ           S              4    DIM(6) CTDATA PERRCD(1)              CATEGORIES

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

     D  COL1           S              1S 0 Inz(1)
     D  COL2           S              1S 0 Inz(1)
     D  COL3           S              1S 0 Inz(1)
     D  COL4           S              1S 0 Inz(1)
     D  COL5           S              1S 0 Inz(1)
     D  COL6           S              1S 0 Inz(1)

     D  VHDG5          S              4A   Inz('N/A')
     D  VHDG6          S              4A   Inz('OVRC')

     D  TRSTP#2        S              2S 0 Inz(*Zero)
     D  IN50           S              1A   Inz('0')
     D  IN23           S              1A   Inz('0')


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
WJB  C                   Z-ADD     0             TQTY4             5 0
WJB  C                   Z-ADD     0             TQTY5             5 0
WJB  C                   Z-ADD     0             TQTY6             5 0

     C                   Move      THSHDT        THSHDT@           7
     C                   Call      'TRR502'
     C                   Parm                    THTRK#
     C                   Parm                    THSHDT@

     C     TRKKEY        SETLL     FTRSCHDT
     C     NXTD          TAG
     C     TRKKEY        READE     FTRSCHDT                               90
     C   90              GOTO      ENDTRK
      /Free
       In23 = *Off;
       Exec SQL
         Select '1' into :IN23 from FHORDRCSTM where COORD# = :TRORD#
           Fetch First Row Only;
       *In23 = IN23;
      /End-Free
     C                   Z-Add     TRSTP#        TRSTP#2
     C                   ADD       1             STOP

     C                   IF        TRQTY(col1) = %INT(TRQTY(col1))
     C                   Z-ADD     TRQTY(col1)   QTY1              5 0                         QPK53
     C                   Else
     C                   Eval      QTY1 = %Int(TRQTY(col1)) + 1
     C                   EndIf

     C                   IF        TRQTY(col2) = %INT(TRQTY(col2))
     C                   Z-ADD     TRQTY(col2)   QTY2              5 0                         QPK53
     C                   Else
     C                   Eval      QTY2 = %Int(TRQTY(col2)) + 1
     C                   EndIf

     C                   IF        TRQTY(col3) = %INT(TRQTY(col3))
     C                   Z-ADD     TRQTY(col3)   QTY3              5 0                         QPK53
     C                   Else
     C                   Eval      QTY3 = %Int(TRQTY(col3)) + 1
     C                   EndIf

     C                   IF        TRQTY(col4) = %INT(TRQTY(col4))
WJB  C                   Z-ADD     TRQTY(col4)   QTY4              5 0                         QPK53
     C                   Else
     C                   Eval      QTY4 = %Int(TRQTY(col4)) + 1
     C                   EndIf

     C                   IF        TRQTY(col5) = %INT(TRQTY(col5))
WJB  C                   Z-ADD     TRQTY(col5)   QTY5              5 0                         QPK53
     C                   Else
     C                   Eval      QTY5 = %Int(TRQTY(col5)) + 1
     C                   EndIf

     C                   IF        TRQTY(col6) = %INT(TRQTY(col6))
WJB  C                   Z-ADD     TRQTY(col6)   QTY6              5 0                         QPK53
     C                   Else
     C                   Eval      QTY6 = %Int(TRQTY(col6)) + 1
     C                   EndIf
WJB
     C                   IF        QTY6 <> 0
     C*                  Eval      QTY3 = QTY6
     C*                  IF        QTY6 = 100
     C*                  Eval      QTY3 = *Zero
     C*                  EndIf
     C                   EndIf

     C                   ADD       QTY1          TQTY1                                         QPK53
     C                   ADD       QTY2          TQTY2                                         QPK53
     C                   ADD       QTY3          TQTY3                                         QPK53
WJB  C                   ADD       QTY4          TQTY4                                         QPK53
WJB  C                   ADD       QTY5          TQTY5                                         QPK53
WJB  C                   ADD       QTY6          TQTY6                                         QPK53

     C                   ADD       QTY1          LRQTY1            5 0                         QPK52
     C                   ADD       QTY2          LRQTY2            5 0                         QPK52
     C                   ADD       QTY3          LRQTY3            5 0                         QPK52
WJB  C                   ADD       QTY4          LRQTY4            5 0                         QPK52
WJB  C                   ADD       QTY5          LRQTY5            5 0                         QPK52
WJB  C                   ADD       QTY6          LRQTY6            5 0                         QPK52

     C     TRCUST        CHAIN     FMCUST                             21
     C                   Z-ADD     TRCUST        CUS#              5 0                         QPK52
     C                   MOVEL     CMNAME        CUSNAM           22                           QPK52
WJB  C                   MOVEL     CMNAME        CUSNAM17         17                           QPK52
     C                   MOVEL     CMCITY        CUSCTY           15                           QPK52
WJB  C                   MOVEL     CMCITY        CUSCTY13         13                           QPK52
     C     TRORD#        CHAIN     FHORDR
     C                   If        %Found(FHORDR)
     C                   MOVEL     OHSHCT        CUSCTY
WJB  C                   MOVEL     OHSHCT        CUSCTY13
WJB  C                   Eval      CMSTST = OHSHST
     C                   EndIf
     C     CMFILL        COMP      'NT'                                   26
SUD01C*    TRCUST        CHAIN     FCMDIR                             25
  |  C* N25              DO
  |  C*    CMDR01        IFLE      *BLANKS
  |  C*    CMSTAT        OREQ      'D'
  |  C*                  SETON                                        25
  |  C*                  END
  |  C*                  ENDDO                                                  N25  DO
  |   /Free
  |       OSSEQ# = 0;
  |   *?  // Get Seq# from Order Header Ship-to File
  |       Chain (TRORD#:CUS#) FHORDRSHTL;
  |    //wjb   If %Found;
  |
  |   *?     // Get Seq# from Order Header Ship-to File
  |    //wjb If $ChkDir(CUS#:OSSEQ#);
  |    //wjb    *In25 = *Off;
  |    //wjb Endif;
  |          *In25 = not($ChkDir(CUS#:OSSEQ#));
SUD01  //wjb Endif;

     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF  DO
      /Free

         IN50 = *Off;

         Exec SQL // Determine if Customer should be flagged for not having Sales Tax Documentation
           SELECT '1'
           INTO :IN50
           FROM fmcust, FCUSTCOM
           WHERE FMCUST.CMCUST=FCUSTCOM.CCUST
             and FMCUST.CMCUST=:CUS#
             and FCUSTCOM.CCSEQ=1
             and FCUSTCOM.CCST3='N'
             and FMCUST.CMTXST='Y'
           Fetch First Row Only;

         *In50 = IN50;

      /End-Free
     C                   EXCEPT    CUST1
     C                   GOTO      NXTD
      ** END OF TRUCK
     C     ENDTRK        TAG
     C                   EXCEPT    TRKTOT
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    LRTOT
     C                   SETON                                        LR
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
WJB  C                   MOVE      OCHDG4        VHDG4             4
WJB  C                   MOVEL     'N/A'         VHDG5             4
WJB  C                   MOVEL     'N/A'         VHDG6             4            #6 Override Carts

WJB  C                   Eval      COL1 = 1
WJB  C                   Eval      COL2 = 1
WJB  C                   Eval      COL3 = 1
WJB  C                   Eval      COL4 = 1
WJB  C                   Eval      COL5 = 5
WJB  C                   Eval      COL6 = 6

WJB  C     VHDG1         LOOKUP    CATEG(COL1)                            33
WJB  C     VHDG2         LOOKUP    CATEG(COL2)                            34
WJB  C     VHDG3         LOOKUP    CATEG(COL3)                            35
WJB  C     VHDG4         LOOKUP    CATEG(COL4)                            36
WJB  C*    VHDG5         LOOKUP    CATEG(COL5)                            37
WJB  C*    VHDG6         LOOKUP    CATEG(COL6)                            38

     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OTRR520    E            HEAD           1 03
     O                                            6 'TRR520'
     O                                           24 'Requested by:'
     O                       USERID              35
     O                                           45 'Kube-Pak'
     O                       PAGE          Z     80
     O                                           76 'Page:'
     O          E            HEAD           2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           52 'Master Truck Schedule'
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
     O                                           45 'D'
     O                                           47 'T'
     O                                           54 'Order#'
     O                       VHDG1               65
     O                       VHDG2               70
     O                       VHDG4               75
     O                       VHDG3               80
     O          E            TRKHED         0                                   QPK520
     O                                           45 '_'
     O                                           47 '_'
     O                                           54 '______'
     O                                           60 '____'
     O                                           65 '____'
     O                                           70 '____'
     O                                           75 '____'
     O                                           80 '____'
WJB  O          EF           CUST1       1                                      QPK530
WJB  O*                      TRSTP#        Z      3                             QPK530
WJB  O                       CUS#          Z      8                             QPK530
WJB  O                       TRSTP#2       Z      2                             QPK530
WJB  O              N21      CUSNAM17            26                             QPK530
WJB  O              N21      CUSCTY13            40                             QPK530
WJB  O              N21      CMSTST              43                             QPK530
WJB  O              N21 25                       45 'D'
WJB17O               50                          46 '*'
WJB  O              N21 26                       47 'N'
WJB  O*             N21      CMPHON              60 '   -   -    '              QPK530
WJB  O                       TRORD#        Z     54                             QPK530
WJB  O               23                          55 'C'                         QPK530
WJB  O               21                          43 ' ** Customer NOT on file'  QPK530
WJB  O               21                          47 ' ** '                      QPK530
WJB  O                       QTY1          Z     65                             QPK530
WJB  O                       QTY2          Z     70                             QPK530
WJB  O                       QTY4          Z     75                             QPK530
WJB  O                       QTY3          Z     80                             QPK530
WJB  O          E            TRKTOT      0  0                                   QPK530
     O                                           60 '____'
     O                                           65 '____'
     O                                           70 '____'
     O                                           75 '____'
     O                                           80 '____'
WJB  O          E            TRKTOT      1  2                                   QPK530
WJB  O                                           52 '** Truck Totals **'        QPK530
WJB  O                       TQTY1         Z     65                             QPK530
WJB  O                       TQTY2         Z     70                             QPK530
WJB  O                       TQTY4         Z     75                             QPK530
WJB  O                       TQTY3         Z     80                             QPK530
WJB  O          E            LRTOT       1  1                                   QPK530
WJB  O                                           52 '** Final Totals **'        QPK530
WJB  O                       LRQTY1        Z     65                             QPK530
WJB  O*                      LRQTY2        Z     70                             QPK530
WJB  O                       LRQTY4        Z     75                             QPK530
WJB  O*                      LRQTY3        Z     80                             QPK530
WJB  O          E            LRTOT          1                                   QPK530
WJB  O*                      LRQTY1        Z     65                             QPK530
WJB  O                       LRQTY2        Z     70                             QPK530
WJB  O*                      LRQTY4        Z     75                             QPK530
WJB  O                       LRQTY3        Z     80                             QPK530
** HDG NAMES
PLUG
FLAT
CART
HBPT
POIN
OVRC
