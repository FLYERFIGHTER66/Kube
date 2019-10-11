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
      *PROGRAM NAME-------- SAR345
      *SYSTEM-------------- SALES ANALYSIS
      *DESCRIPTION--------- SALES ANALYSIS BY PRODUCT CLASS & ITEM
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFSHISTPC  IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FSAR345    O    F  120        PRINTER OFLIND(*INOF)
      *
      ** SHIST ARRAYS
     D CS$             S              9  2 DIM(13)
     D PS$             S              9  2 DIM(13)
     D CSQ             S             11  1 DIM(13)
     D PSQ             S             11  1 DIM(13)
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
     D  LBPC                   8      9
     D  LEPC                  10     11
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
     IRSHISTS
      *
     I              SHCS01                      CS$(1)
     I              SHCS02                      CS$(2)
     I              SHCS03                      CS$(3)
     I              SHCS04                      CS$(4)
     I              SHCS05                      CS$(5)
     I              SHCS06                      CS$(6)
     I              SHCS07                      CS$(7)
     I              SHCS08                      CS$(8)
     I              SHCS09                      CS$(9)
     I              SHCS10                      CS$(10)
     I              SHCS11                      CS$(11)
     I              SHCS12                      CS$(12)
     I              SHCS13                      CS$(13)
      *
     I              SHLS01                      PS$(1)
     I              SHLS02                      PS$(2)
     I              SHLS03                      PS$(3)
     I              SHLS04                      PS$(4)
     I              SHLS05                      PS$(5)
     I              SHLS06                      PS$(6)
     I              SHLS07                      PS$(7)
     I              SHLS08                      PS$(8)
     I              SHLS09                      PS$(9)
     I              SHLS10                      PS$(10)
     I              SHLS11                      PS$(11)
     I              SHLS12                      PS$(12)
     I              SHLS13                      PS$(13)
      *
     I              SHCQ01                      CSQ(1)
     I              SHCQ02                      CSQ(2)
     I              SHCQ03                      CSQ(3)
     I              SHCQ04                      CSQ(4)
     I              SHCQ05                      CSQ(5)
     I              SHCQ06                      CSQ(6)
     I              SHCQ07                      CSQ(7)
     I              SHCQ08                      CSQ(8)
     I              SHCQ09                      CSQ(9)
     I              SHCQ10                      CSQ(10)
     I              SHCQ11                      CSQ(11)
     I              SHCQ12                      CSQ(12)
     I              SHCQ13                      CSQ(13)
      *
     I              SHLQ01                      PSQ(1)
     I              SHLQ02                      PSQ(2)
     I              SHLQ03                      PSQ(3)
     I              SHLQ04                      PSQ(4)
     I              SHLQ05                      PSQ(5)
     I              SHLQ06                      PSQ(6)
     I              SHLQ07                      PSQ(7)
     I              SHLQ08                      PSQ(8)
     I              SHLQ09                      PSQ(9)
     I              SHLQ10                      PSQ(10)
     I              SHLQ11                      PSQ(11)
     I              SHLQ12                      PSQ(12)
     I              SHLQ13                      PSQ(13)
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LBPC          IFGT      *BLANKS
     C                   SETON                                        24
     C                   ENDIF
      *
     C     LACTIV        IFEQ      'Y'
     C                   SETON                                        22
     C                   END
      *
     C     LCO           CHAIN     FMCORG                             88
     C     LCO           CHAIN     FMAPER                             88
     C     ACMPCN        COMP      'M'                                525251
     C                   Z-ADD     LMONTH        P                 2 0
      *
     C                   Z-ADD     1             FIRST             4 0
     C                   Z-ADD     1             PCCNT             4 0
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
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       7778
     C                   READ      FSHISTPC                               90
     C   90              GOTO      END
      *
     C     SHSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SHCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SHITEM        IFEQ      *BLANKS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   24SHPCL1        IFLT      LBPC
     C     SHPCL1        ORGT      LEPC
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     FIRST         IFNE      1
     C     PCCNT         ANDGT     1
     C     SHPCL1        ANDNE     OLDPC
     C     OLDPC         CHAIN     FMPRCL                             92
     C   92              SETON                                        78
     C  N92              MOVEL     PCDESC        ODESC            30
     C                   EXCEPT    TL1
     C                   MOVEL     *BLANKS       ODESC
     C                   Z-ADD     1             PCCNT
     C                   ENDIF
      *
     C     KEY18         KLIST
     C                   KFLD                    SHITEM
     C                   KFLD                    SHSIZE
     C     KEY18         SETLL     FMINVT
     C                   READ      FMINVT                                 30
     C                   EXSR      GETDES
      *
     C                   Z-ADD     CSQ(P)        CQTY              8 0
     C                   ADD       CSQ(P)        PYQTY             9 0
     C                   ADD       CSQ(P)        RYQTY             9 0
     C                   ADD       CS$(P)        PCYCPS           10 2
     C                   ADD       CS$(P)        RCYCPS           10 2
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CSQ(X)        YQTY              8 0
     C                   ADD       CSQ(X)        CQTYP             9 0
     C                   ADD       CSQ(X)        CQTYT             9 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PSQ(X)        LQTY              8 0
     C                   ADD       PSQ(X)        LQTYP             9 0
     C                   ADD       PSQ(X)        LQTYT             9 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CS$(X)        YTDS              9 2
     C                   ADD       CS$(X)        YTDSP            10 2
     C                   ADD       CS$(X)        YTDST            10 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PS$(X)        LTDS              9 2
     C                   ADD       PS$(X)        LTDSP            10 2
     C                   ADD       PS$(X)        LTDST            10 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
      *
     C   22LQTY          IFEQ      0
     C     YQTY          ANDEQ     0
     C     CQTY          ANDEQ     0
     C     LTDS          ANDEQ     0
     C     YTDS          ANDEQ     0
     C     CS$(P)        ANDEQ     0
     C                   Z-ADD     0             LQTY
     C                   Z-ADD     0             YQTY
     C                   Z-ADD     0             CQTY
     C                   Z-ADD     0             LTDS
     C                   Z-ADD     0             YTDS
     C                   GOTO      NXT
     C                   ENDIF
      *
      * PRODUCT CLASS TOTALS
      *
     C                   ADD       CQTY          YQTYP             9 0
      *
      * REPORT TOTALS
      *
     C                   ADD       CS$(P)        CDOLT             9 2
     C                   ADD       CQTY          YQTYT             9 0
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
      *
     C     PCCNT         IFEQ      1
     C                   SETON                                        10
     C                   ENDIF
     C                   EXCEPT    DETL
     C                   SETOFF                                       10
     C                   ADD       1             FIRST
     C                   ADD       1             PCCNT
     C                   MOVEL     SHPCL1        OLDPC             2
     C                   GOTO      NXT
      *
     C     END           TAG
     C     PCCNT         IFGT      1
     C                   EXCEPT    TL1
     C                   ENDIF
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *
      **********
      * GETDES
      **********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESC             28
     C     DESC          IFEQ      *BLANKS
     C                   SETON                                        77
     C                   ENDIF
     C                   ENDSR
      *
     OSAR345    E            HDG            1 03
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
     O                                           58 'Sales Analysis By'
     O                                           79 'Product Class / Item'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           52 'For Period'
     O                       LMONTH              55
     O                       BEGDAT        Y     66
     O                                           69 '-'
     O                       ENDDAT        Y     79
     O               24                          16 'Product Classes:'
     O               24      LBPC                19
     O               24                          21 '-'
     O               24      LEPC                24
     O          E            HDG            1
     O                                           58 '-------'
     O                                           72 'SALES DOLLARS'
     O                                           82 '-------'
     O                                           96 '-------'
     O                                          110 'QUANTITIES'
     O                                          120 '-------'
     O          E            HDG            1
     O                                            2 'PR'
     O                                           58 'Current'
     O                                           70 'Current'
     O                                           82 'Last'
     O                                           96 'Current'
     O                                          108 'Current'
     O                                          120 'Last'
     O          E            HDG            1
     O                                            2 'CL'
     O                                           10 'Item'
     O                                           35 'Description'
     O                                           57 'Period'
     O                                           68 'YTD'
     O                                           82 'Year'
     O                                           95 'Period'
     O                                          106 'YTD'
     O                                          120 'Year'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DETL           1
     O               10      SHPCL1               2
     O                       SHITEM              15
     O                       SHSIZE              18
     O              N77      DESC           B    47
     O               77                          41 '** Item Not On File **'
     O                       LQTY          KB   120
     O                       YQTY          KB   109
     O                       CQTY          KB    97
     O                       LTDS          KB    85
     O                       YTDS          KB    72
     O                       CS$(P)        KB    59
     O          E            TL1            1
     O                                          119 '----------'
     O                                          108 '----------'
     O                                           96 '----------'
     O                                           84 '-----------'
     O                                           71 '-----------'
     O                                           58 '----------'
     O          E            TL1            2
     O                                           11 'Totals For:'
     O                       OLDPC               14
     O               78                          38 '** P/C Not On File **'
     O              N78      ODESC               46
     O                       LQTYP         KB   120
     O                       CQTYP         KB   109
     O                       PYQTY         KB    97
     O                       LTDSP         KB    85
     O                       YTDSP         KB    72
     O                       PCYCPS        KB    59
     O          E            TLR            1
     O                                          119 '=========='
     O                                          108 '=========='
     O                                           96 '=========='
     O                                           84 '==========='
     O                                           71 '==========='
     O                                           58 '=========='
     O          E            TLR            1
     O                                           42 'Report Totals:'
     O                       CQTYT         KB   109
     O                       LTDST         KB    85
     O                       RCYCPS        KB    59
     O          E            TLR            1
     O                       LQTYT         KB   120
     O                       YQTYT         KB    97
     O                       YTDST         KB    72
