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
      *PROGRAM NAME-------- SAR415
      *SYSTEM-------------- SALES ANALYSIS
      *DESCRIPTION--------- SALES ANALYSIS BY PRODUCT CLASS SUMMARY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFSHISTPC  IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FSAR415    O    F  120        PRINTER OFLIND(*INOF)
      *
      ** SHIST ARRAYS
     D CS$             S              9  2 DIM(13)
     D PS$             S              9  2 DIM(13)
     D CSQ             S             11  1 DIM(13)
     D PSQ             S             11  1 DIM(13)
      *
      *
     D                UDS
     D  LCO                    1      2  0
     D  LMONTH                 3      4  0
     D  LDOLUN                 5      5  0
     D  LDORP                  6      6
     D  LGROSS                 7      7
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
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
     C     LCO           CHAIN     FMCORG                             88
     C     LCO           CHAIN     FMAPER                             88
     C     ACMPCN        COMP      'M'                                525251
     C                   Z-ADD     LMONTH        P                 2 0
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
     C                   READ      FSHISTPC                               90
     C                   SETOFF                                       77
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
     C     FIRST         IFNE      1
     C     SHPCL1        ANDNE     OLDPC
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C     OLDPC         CHAIN     FMPRCL                             90
     C   90              SETON                                        77
     C  N90              MOVEL     PCDESC        ODESC            30
     C                   EXCEPT    TL1
     C                   Z-ADD     1             PCCNT
     C                   Z-ADD     0             LQTY
     C                   Z-ADD     0             YQTY
     C                   Z-ADD     0             CQTY
     C                   Z-ADD     0             LTDS
     C                   Z-ADD     0             YTDS
     C                   Z-ADD     0             CDOL
     C                   ENDIF
      *
      * CURRENT MONTH QUANTITY AND DOLLARS
      *
     C                   ADD       CSQ(P)        CQTY              8 0
     C                   ADD       CSQ(P)        CQTYT             8 0
     C                   ADD       CS$(P)        CDOL              9 2
     C                   ADD       CS$(P)        CDOLT             9 2
      *
      * YTD QUANTITY
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CSQ(X)        YQTY              8 0
     C                   ADD       CSQ(X)        YQTYT             9 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
      * PTD QUANTITY
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PSQ(X)        LQTY              8 0
     C                   ADD       PSQ(X)        LQTYT             9 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
      * YTD DOLLARS
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CS$(X)        YTDS             10 2
     C                   ADD       CS$(X)        YDOLT            10 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
      * PTD DOLLARS
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PS$(X)        LTDS             10 2
     C                   ADD       PS$(X)        LDOLT            10 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   MOVEL     SHPCL1        OLDPC             2
     C                   MOVEL     PCDESC        ODESC            30
     C                   ADD       1             FIRST
     C                   GOTO      NXT
      *
     C     END           TAG
     C     OLDPC         CHAIN     FMPRCL                             90
     C   90              SETON                                        77
     C  N90              MOVEL     PCDESC        ODESC            30
     C                   EXCEPT    TL1
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *
     OSAR415    E            HDG            1 03
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
     O                                           52 'Sales Analysis By'
     O                                           66 'Product Class'
     O                                           84 ' - Dollars & Units'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           51 'For Period'
     O                       LMONTH              54
     O                       BEGDAT        Y     65
     O                                           68 '-'
     O                       ENDDAT        Y     78
     O          E            HDG            1
     O                                           49 '--------'
     O                                           65 'SALES DOLLARS'
     O                                           77 '--------'
     O                                           95 '-----------'
     O                                          107 'QUANTITIES'
     O                                          120 '----------'
     O          E            HDG            1
     O                                           49 'Current'
     O                                           64 'Current'
     O                                           77 'Last'
     O                                           92 'Current'
     O                                          106 'Current'
     O                                          120 'Last'
     O          E            HDG            0
     O                                           12 'PC'
     O                                           25 'Description'
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
     O          EF           TL1            2
     O                       OLDPC                2
     O              N77      ODESC               33
     O               77                          24 '** P/C Not On File **'
     O                       LQTY          KB   120
     O                       YQTY          KB   107
     O                       CQTY          KB    92
     O                       LTDS          KB    78
     O                       YTDS          KB    64
     O                       CDOL          KB    49
     O          E            TLR            1
     O                                          119 '---------'
     O                                          106 '---------'
     O                                           91 '---------'
     O                                           77 '----------'
     O                                           63 '----------'
     O                                           48 '---------'
     O          E            TLR         1  1
     O                                           25 'Report Totals:'
     O                       YQTYT         KB   107
     O                       LDOLT         KB    78
     O                       CDOLT         KB    49
     O          E            TLR            1
     O                       LQTYT         KB   120
     O                       CQTYT         KB    92
     O                       YDOLT         KB    64
