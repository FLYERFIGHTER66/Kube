      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.  215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- SAR480
      *SYSTEM-------------- SALES ANALYSIS
      *DESCRIPTION--------- SALES ANALYSIS BY CUSTOMER/PRODUCT CLASS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFSHIDCPC  IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FSAR480    O    F  120        PRINTER OFLIND(*INOF)
      *
      * SHIST ARRAYS
     D CS$             S              9  2 DIM(13)                              SALES CUR YEAR
     D PS$             S              9  2 DIM(13)                              SALES LST YEAR
     D CSQ             S             11  1 DIM(13)                              QTY CUR YEAR
     D PSQ             S             11  1 DIM(13)                              QTY LAST YEAR
      *
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
      *
     D                UDS
     D  LCO                    1      2  0
     D  LMONTH                 3      4  0
     D  LBPC                   5      6
     D  LEPC                   7      8
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
     IRSHIST
      *
     I              SICS01                      CS$(1)
     I              SICS02                      CS$(2)
     I              SICS03                      CS$(3)
     I              SICS04                      CS$(4)
     I              SICS05                      CS$(5)
     I              SICS06                      CS$(6)
     I              SICS07                      CS$(7)
     I              SICS08                      CS$(8)
     I              SICS09                      CS$(9)
     I              SICS10                      CS$(10)
     I              SICS11                      CS$(11)
     I              SICS12                      CS$(12)
     I              SICS13                      CS$(13)
      *
     I              SILS01                      PS$(1)
     I              SILS02                      PS$(2)
     I              SILS03                      PS$(3)
     I              SILS04                      PS$(4)
     I              SILS05                      PS$(5)
     I              SILS06                      PS$(6)
     I              SILS07                      PS$(7)
     I              SILS08                      PS$(8)
     I              SILS09                      PS$(9)
     I              SILS10                      PS$(10)
     I              SILS11                      PS$(11)
     I              SILS12                      PS$(12)
     I              SILS13                      PS$(13)
      *
     I              SICQ01                      CSQ(1)
     I              SICQ02                      CSQ(2)
     I              SICQ03                      CSQ(3)
     I              SICQ04                      CSQ(4)
     I              SICQ05                      CSQ(5)
     I              SICQ06                      CSQ(6)
     I              SICQ07                      CSQ(7)
     I              SICQ08                      CSQ(8)
     I              SICQ09                      CSQ(9)
     I              SICQ10                      CSQ(10)
     I              SICQ11                      CSQ(11)
     I              SICQ12                      CSQ(12)
     I              SICQ13                      CSQ(13)
      *
     I              SILQ01                      PSQ(1)
     I              SILQ02                      PSQ(2)
     I              SILQ03                      PSQ(3)
     I              SILQ04                      PSQ(4)
     I              SILQ05                      PSQ(5)
     I              SILQ06                      PSQ(6)
     I              SILQ07                      PSQ(7)
     I              SILQ08                      PSQ(8)
     I              SILQ09                      PSQ(9)
     I              SILQ10                      PSQ(10)
     I              SILQ11                      PSQ(11)
     I              SILQ12                      PSQ(12)
     I              SILQ13                      PSQ(13)
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
      * GET PERIOD
      *
     C                   Z-ADD     LMONTH        P                 2 0
      *
     C     LCO           CHAIN     FMCORG                             90
     C     LCO           CHAIN     FMAPER                             90
     C     ACMPCN        IFEQ      'M'
     C                   SETON                                        51
     C                   ENDIF
     C     ACMPCN        IFEQ      'P'
     C                   SETON                                        52
     C                   ENDIF
      *
      * GET PERIOD DATES
      *
     C                   Z-ADD     LCO           CONO
     C                   Z-ADD     LMONTH        ACTPER
     C                   CALL      'GETPDAT'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    ERR               1 0
      *
     C                   Z-ADD     1             CUST              6 0
     C                   Z-ADD     1             PC                6 0
     C                   Z-ADD     0             CNT               6 0
     C                   EXCEPT    HDG
      *
     C     LBPC          IFGT      *BLANKS
     C                   SETON                                        10
     C                   ENDIF
      *
     C     NXT           TAG
     C                   SETOFF                                       88
     C                   READ      FSHIDCPC                               90
     C   90              GOTO      END
      *
     C     SISTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SICOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SICUST        IFEQ      0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SIPCL1        IFEQ      *BLANKS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   XFOOT     CS$           CSLS             10 2
     C                   XFOOT     PS$           PSLS             10 2
     C                   XFOOT     CSQ           TCQTY             9 0
     C                   XFOOT     PSQ           TPQTY             9 0
      *
     C     CSLS          IFEQ      0
     C     PSLS          ANDEQ     0
     C     TCQTY         ANDEQ     0
     C     TCQTY         ANDEQ     0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   10SIPCL1        IFLT      LBPC
     C     SIPCL1        ORGT      LEPC
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SICUST        CHAIN     FMCUST                             90
      *
     C                   ADD       1             CNT
      *
     C     PC            IFNE      1
     C     SIPCL1        ANDNE     OLPC
     C     OLPC          CHAIN     FMPRCL                             90
     C   90              SETON                                        88
     C                   EXCEPT    TL1
     C                   ADD       1             PC
     C                   ENDIF
     C                   MOVEL     SIPCL1        OLPC              2
      *
     C     CUST          IFNE      1
     C     SICUST        ANDNE     OLCUST
     C                   EXCEPT    TL2
     C                   EXCEPT    DETC
     C                   ADD       1             CUST
     C                   ENDIF
     C                   MOVEL     SICUST        OLCUST            6 0
      *
     C     CNT           IFEQ      1
     C                   EXCEPT    DETC
     C                   ADD       1             PC
     C                   ADD       1             CUST
     C                   ENDIF
      *
     C                   ADD       CS$(P)        CCS$              9 2
     C                   ADD       CS$(P)        CURSC            10 2
     C                   ADD       CS$(P)        CURST            10 2
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CS$(X)        YTDS              9 2
     C                   ADD       CS$(X)        YTDSC            10 2
     C                   ADD       CS$(X)        YTDST            10 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PS$(X)        LTDS              9 2
     C                   ADD       PS$(X)        LTDSC            10 2
     C                   ADD       PS$(X)        LTDST            10 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   ADD       CSQ(P)        CQTY              8 0
     C                   ADD       CSQ(P)        CQTYC             9 0
     C                   ADD       CSQ(P)        CQTYT             9 0
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CSQ(X)        YQTY              8 0
     C                   ADD       CSQ(X)        YQTYC             9 0
     C                   ADD       CSQ(X)        YQTYT             9 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PSQ(X)        LQTY              8 0
     C                   ADD       PSQ(X)        LQTYC             9 0
     C                   ADD       PSQ(X)        LQTYT             9 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   EXCEPT    DETC
     C                   ENDDO
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *
     OSAR480    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                       PAGE          1    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           57 'Sales Analysis By'
     O                                           80 'Customer/Product Class'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           52 'For Period:'
     O                       LMONTH              55
     O                       BEGDAT        Y     66
     O                                           69 '-'
     O                       ENDDAT        Y     79
     O          E            HDG            1
     O                                            8 'Customer'
     O                                           23 'N   A   M   E'
     O                                           48 '--------'
     O                                           65 'SALES DOLLARS'
     O                                           77 '--------'
     O                                           94 '-----------'
     O                                          107 'QUANTITIES'
     O                                          120 '----------'
     O          E            HDG            1
     O                                            7 'Number'
     O                                           47 'This Period'
     O                                           63 'Year To Date'
     O                                           77 'Last YTD'
     O                                           92 'This Period'
     O                                          106 'Year To Date'
     O                                          120 'Last YTD'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETC           1
     O                       SICUST        Z      6
     O                       CMNAME              37
     O          E            TL1            1
     O                       LQTY          KB   120
     O                       YQTY          KB   107
     O                       CQTY          KB    92
     O                       LTDS          KB    78
     O                       YTDS          KB    64
     O                       CCS$          KB    49
     O              N88      PCDESC              40
     O               88                          31 '** P/C Not On File **'
     O                       OLPC                 9
     O          E            TL2            1
     O                                          119 '----------'
     O                                          106 '----------'
     O                                           91 '----------'
     O                                           77 '-----------'
     O                                           63 '-----------'
     O                                           48 '----------'
     O          E            TL2            1
     O                       LQTYC         KB   120
     O                       YQTYC         KB   107
     O                       CQTYC         KB    92
     O                       LTDSC         KB    78
     O                       YTDSC         KB    64
     O                       CURSC         KB    49
     O                                           31 'Total Customer:'
     O          E            TLR            1
     O                                          119 '=========='
     O                                          106 '=========='
     O                                           91 '=========='
     O                                           77 '==========='
     O                                           63 '==========='
     O                                           48 '=========='
     O          E            TLR            1
     O                                           31 'Total Report:'
     O                       LQTYT         KB   120
     O                       YQTYT         KB   107
     O                       CQTYT         KB    92
     O                       LTDST         KB    78
     O                       YTDST         KB    64
     O                       CURST         KB    49
