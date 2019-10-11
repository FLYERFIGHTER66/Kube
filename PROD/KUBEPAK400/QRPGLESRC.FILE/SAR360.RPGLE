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
      *PROGRAM NAME-------- SAR360
      *SYSTEM-------------- SALES ANALYSIS
      *DESCRIPTION--------- SUMMARY S/A BY TERRITORY, SLSPERSON, CUST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFSHIDTSC  IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMTERR    IF   E           K DISK
     FFMSLSM    IF   E           K DISK
     FSAR360    O    F  120        PRINTER OFLIND(*INOF)
      *
      * SHIST ARRAYS
     D CS$             S              9  2 DIM(13)
     D PS$             S              9  2 DIM(13)
     D CSQ             S             11  1 DIM(13)
     D PSQ             S             11  1 DIM(13)
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10
      * RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    263
      * SOURCE LIBRARY
     D  SLIBR                314    323
      *
     D                UDS
     D  LCO                    1      2  0
     D  LMONTH                 3      4  0
     D  LDOLUN                 5      5  0
     D  LBTER                  8      9
     D  LETER                 10     11
     D  LACTIV                12     12
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
     C     LDOLUN        IFEQ      1
     C                   SETON                                        20
     C                   ENDIF
      *
     C     LDOLUN        IFEQ      2
     C                   SETON                                        21
     C                   ENDIF
      *
     C     LBTER         IFGT      *BLANKS
     C                   SETON                                        22
     C                   ENDIF
      *
     C     LACTIV        IFEQ      'Y'
     C                   SETON                                        10
     C                   END
      *
     C                   Z-ADD     1             NSLS              4 0
     C                   Z-ADD     1             NCUS              4 0
     C                   Z-ADD     1             NTER              4 0
      *
     C     LCO           CHAIN     FMCORG                             88
      *
      * GET PERIOD
      *
     C                   Z-ADD     LMONTH        P                 2 0
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
     C     NXT           TAG
     C                   MOVEL     *BLANKS       SMNAME
     C                   MOVEL     *BLANKS       TEDESC
     C                   SETOFF                                       7778
     C                   READ      FSHIDTSC                               90
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
     C   10SICQTL        IFEQ      0
     C     SILQTL        ANDEQ     0
     C     SICSTL        ANDEQ     0
     C     SIPSTL        ANDEQ     0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SITERR        IFEQ      *BLANKS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SISLSM        IFEQ      *BLANKS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SIITEM        IFEQ      *BLANKS
     C                   GOTO      NXT
     C                   ENDIF
     C     SICUST        IFEQ      *ZEROS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   22SITERR        IFLT      LBTER
     C     SITERR        ORGT      LETER
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     NTER          IFEQ      1
     C     SITERR        CHAIN     FMTERR                             90
     C   90              SETON                                        78
     C                   EXCEPT    HDG
     C                   EXCEPT    HDG1
     C                   ENDIF
      *
     C     NSLS          IFEQ      1
     C     SISLSM        CHAIN     FMSLSM                             90
     C   90              SETON                                        77
     C                   EXCEPT    DETL
     C                   ENDIF
      *
     C     SICUST        CHAIN     FMCUST                             90
      *
     C     NCUS          IFNE      1
     C     SICUST        ANDNE     OCUST
     C     SISLSM        ANDEQ     OSLSM
     C     SITERR        ANDEQ     OTERR
     C   21              EXCEPT    TL1
     C   20              EXCEPT    TL1B
     C                   ENDIF
      *
     C     NCUS          IFNE      1
     C     SISLSM        ANDNE     OSLSM
     C     SITERR        ANDEQ     OTERR
     C   21              EXCEPT    TL1
     C   20              EXCEPT    TL1B
     C   20
     COR 21              EXCEPT    TL2D
     C   21              EXCEPT    TL2
     C   20              EXCEPT    TL2B
      *
     C     SISLSM        CHAIN     FMSLSM                             90
     C   90              SETON                                        77
     C                   EXCEPT    DETL
     C                   ENDIF
      *
     C     NCUS          IFNE      1
     C     SITERR        ANDNE     OTERR
     C   21              EXCEPT    TL1
     C   20              EXCEPT    TL1B
     C   20
     COR 21              EXCEPT    TL2D
     C   21              EXCEPT    TL2
     C   20              EXCEPT    TL2B
     C   20
     COR 21              EXCEPT    TL3D
     C   21              EXCEPT    TL3
     C   20              EXCEPT    TL3B
     C                   EXCEPT    HDG
      *
     C     SITERR        CHAIN     FMTERR                             90
     C   90              SETON                                        78
     C                   EXCEPT    HDG1
      *
     C     SISLSM        CHAIN     FMSLSM                             90
     C   90              SETON                                        77
     C                   EXCEPT    DETL
     C                   ENDIF
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CS$(X)        TCYS              9 2
     C                   ADD       CS$(X)        TSYS             10 2
     C                   ADD       CS$(X)        TTYS             10 2
     C                   ADD       CS$(X)        TRYS             10 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CSQ(X)        TCYQ              8 0
     C                   ADD       CSQ(X)        TSYQ              9 0
     C                   ADD       CSQ(X)        TTYQ              9 0
     C                   ADD       CSQ(X)        TRYQ              9 0
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PS$(X)        TCRS              9 2
     C                   ADD       PS$(X)        TSRS              9 2
     C                   ADD       PS$(X)        TTRS              9 2
     C                   ADD       PS$(X)        TRRS              9 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PSQ(X)        TCRQ              8 0
     C                   ADD       PSQ(X)        TSRQ              9 0
     C                   ADD       PSQ(X)        TTRQ              9 0
     C                   ADD       PSQ(X)        TRRQ              9 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   ADD       CS$(P)        TCCS              9 2
     C                   ADD       CS$(P)        TSCS              9 2
     C                   ADD       CS$(P)        TTCS              9 2
     C                   ADD       CS$(P)        TRCS              9 2
      *
     C                   ADD       CSQ(P)        TCCQ              8 0
     C                   ADD       CSQ(P)        TSCQ              8 0
     C                   ADD       CSQ(P)        TTCQ              8 0
     C                   ADD       CSQ(P)        TRCQ              8 0
      *
     C                   ADD       PS$(P)        TCPS              9 2
     C                   ADD       PS$(P)        TSPS             10 2
     C                   ADD       PS$(P)        TTPS             10 2
     C                   ADD       PS$(P)        TRPS             10 2
      *
     C                   ADD       PSQ(P)        TCPQ              8 0
     C                   ADD       PSQ(P)        TSPQ              8 0
     C                   ADD       PSQ(P)        TTPQ              8 0
     C                   ADD       PSQ(P)        TRPQ              8 0
      *
     C                   ADD       1             NCUS
     C                   ADD       1             NSLS
     C                   ADD       1             NTER
     C                   MOVEL     SISLSM        OSLSM             2
     C                   MOVEL     SITERR        OTERR             2
     C                   Z-ADD     SICUST        OCUST             6 0
     C                   MOVEL     CMNAME        ONAME            30
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   EXCEPT    HDG1
     C                   SETOFF                                       OF
     C                   ENDDO
     C                   GOTO      NXT
      *
     C     END           TAG
     C   21              EXCEPT    TL1
     C   20              EXCEPT    TL1B
     C   20
     COR 21              EXCEPT    TL2D
     C   21              EXCEPT    TL2
     C   20              EXCEPT    TL2B
     C   20
     COR 21              EXCEPT    TL3D
     C   21              EXCEPT    TL3
     C   20              EXCEPT    TL3B
     C   21              EXCEPT    TLR
     C   20              EXCEPT    TLRB
     C                   SETON                                        LR
      *
     OSAR360    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                       PAGE          1    120
     O                                          115 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           59 'Sales Analysis By'
     O                                           71 'Territory -'
     O               20                          79 'Dollars'
     O               21                          79 'Units  '
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           52 'For Period'
     O                       LMONTH              55
     O                       BEGDAT        Y     66
     O                                           69 '-'
     O                       ENDDAT        Y     79
     O          E            HDG1           1
     O                                           10 'Territory:'
     O                       SITERR              13
     O                       TEDESC              44
     O               78                          38 '** Territory Not On File'
     O               78                          41 ' **'
     O          E            HDG1           1
     O                                           72 '------'
     O                                           85 'CURRENT YEAR'
     O                                           92 '------'
     O                                          102 '------'
     O                                          112 'LAST YEAR'
     O                                          120 '------'
     O          E            HDG1           0
     O                                           11 'Salesperson'
     O                                           36 'Customer'
     O                                           78 'This Period'
     O                                           90 'YTD'
     O                                          106 'This Period'
     O                                          118 'YTD'
     O          E            HDG1           2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       SISLSM               2
     O              N77      SMNAME              33
     O               77                          27 '** Salesperson Not On Fi'
     O               77                          32 'le **'
     O                       CS$(P)        K     56
     O          EF           TL1            1
     O                       OCUST         Z     26
     O                       ONAME               57
     O               21      TCRQ          KB   119
     O               21      TCPQ          KB   105
     O               21      TCYQ          KB    91
     O               21      TCCQ          KB    77
     O          EF           TL1B           1
     O                       OCUST         Z     16
     O                       ONAME               47
     O               20      TCRS          KB   120
     O               20      TCPS          KB   106
     O               20      TCYS          KB    92
     O               20      TCCS          KB    78
     O          E            TL2D           1
     O                                          119 '----------'
     O                                          105 '----------'
     O                                           91 '----------'
     O                                           77 '----------'
     O          E            TL2            1
     O               21                          60 'Total Salesperson:'
     O               21      TSRQ          KB   119
     O               21      TSPQ          KB   105
     O               21      TSYQ          KB    91
     O               21      TSCQ          KB    77
     O          E            TL2B           2
     O               20N21                       60 'Total Salesperson:'
     O               20      TSRS          KB   120
     O               20      TSPS          KB   106
     O               20      TSYS          KB    92
     O               20      TSCS          KB    78
     O          E            TL3D           1
     O                                          119 '=========='
     O                                          105 '=========='
     O                                           91 '=========='
     O                                           77 '=========='
     O          E            TL3            1
     O               21                          60 'Total Territory:'
     O               21      TTRQ          KB   119
     O               21      TTPQ          KB   105
     O               21      TTYQ          KB    91
     O               21      TTCQ          KB    77
     O          E            TL3B           2
     O               20N21                       60 'Total Territory:'
     O               20      TTRS          KB   120
     O               20      TTPS          KB   106
     O               20      TTYS          KB    92
     O               20      TTCS          KB    78
     O          E            TLR         2  1
     O               21                          60 'Report Totals:'
     O               21      TRRQ          KB   119
     O               21      TRPQ          KB   105
     O               21      TRYQ          KB    91
     O               21      TRCQ          KB    77
     O          E            TLRB        2  1
     O               20N21                       60 'Report Totals:'
     O               20      TRRS          KB   120
     O               20      TRPS          KB   106
     O               20      TRYS          KB    92
     O               20      TRCS          KB    78
      **
