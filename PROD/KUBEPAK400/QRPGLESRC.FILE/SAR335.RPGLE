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
      *PROGRAM NAME-------- SAR335
      *SYSTEM-------------- SALES ANALYSIS
      *DESCRIPTION--------- SALES ANALYSIS BY ITEM
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 5/25/00 EFD01 MOVE ** NOT ON FILE ** DESCRIPTIONS IF REC DEL
      *
     FFSHISTSI  IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FSAR335    O    F  120        PRINTER OFLIND(*INOF)
      *
      * SHIST ARRAYS
     D CS$             S              9  2 DIM(13)
     D PS$             S              9  2 DIM(13)
     D CSQ             S             11  1 DIM(13)
     D PSQ             S             11  1 DIM(13)
EFD01D MSG             S             30    DIM(1) CTDATA PERRCD(1)
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
     D  LDORP                  6      6
     D  LGROSS                 7      7
     D  LSSIZE                 8     10
     D  LESIZE                11     13
     D  LACTIV                14     14
     D  LPROG                 29     36
     D  LNAME                 37     66
     D  LPRTR                100    109
     D  LFORM                110    113
     D  LCOPY                114    115  0
     D  LJOB                 116    116
     D  LHOLD                117    120
     D  LSAVE                121    124
     D  LCANCL               133    133
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
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LACTIV        IFEQ      'Y'
     C                   SETON                                        22
     C                   END
      *
     C     LSSIZE        IFGT      *BLANKS
     C                   SETON                                        24
     C                   ENDIF
      *
     C     LCO           CHAIN     FMCORG                             88
     C     LCO           CHAIN     FMAPER                             88
     C     ACMPCN        COMP      'M'                                525251
     C                   Z-ADD     LMONTH        P                 2 0
     C                   Z-ADD     1             FIRST             4 0
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
     C                   SETOFF                                       77
     C                   READ      FSHISTSI                               90
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
     C   24SHSIZE        IFLT      LSSIZE
     C     SHSIZE        ORGT      LESIZE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     KEY18         KLIST
     C                   KFLD                    SHITEM
     C                   KFLD                    SHSIZE
     C     KEY18         CHAIN     FMINVT                             90
      *
EFD01C  N90              EXSR      GETDES
EFD01C   90              MOVEL     MSG(1)        DESP
EFD01C   90              MOVE      SHITAL        DESP
      *
     C                   ADD       CS$(P)        CSLST             9 2
     C                   ADD       CSQ(P)        CQTYT             9 0
     C                   Z-ADD     CSQ(P)        CQTY              8 0
      *
      * CURRENT YEAR QUANTITY
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CSQ(X)        YQTY              8 0
     C                   ADD       CSQ(X)        YQTYT             9 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
      * PRIOR YEAR QUANTITY
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PSQ(X)        LQTY              8 0
     C                   ADD       PSQ(X)        LQTYT             9 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
      * CURRENT YEAR SALES
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CS$(X)        YTDS              9 2
     C                   ADD       CS$(X)        YTDST             9 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
      * PRIOR YEAR SALES
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PS$(X)        LTDS              9 2
     C                   ADD       PS$(X)        LTDST             9 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C   22LQTY          IFEQ      0
     C     YQTY          ANDEQ     0
     C     CSQ(P)        ANDEQ     0
     C     LTDS          ANDEQ     0
     C     YTDS          ANDEQ     0
     C     CS$(P)        ANDEQ     0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   SETOFF                                       10
     C                   ADD       1             FIRST
     C                   GOTO      NXT
      *
     C     END           TAG
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
     C                   MOVEL     DESCO         DESP             36
EFD01C*          DESP      IFEQ *BLANKS
EFD01C*                    SETON                     77
EFD01C*                    ENDIF
     C                   ENDSR
      *
     OSAR335    E            HDG            1 03
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
     O                                           66 'Sales Analysis By'
     O                                           71 'Item'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           52 'For Period'
     O                       LMONTH              55
     O                       BEGDAT        Y     66
     O                                           69 '-'
     O                       ENDDAT        Y     79
     O               24                          11 'Size Codes:'
     O               24      LSSIZE              15
     O               24                          17 '-'
     O               24      LESIZE              21
     O          E            HDG            1
     O                                           63 '-------'
     O                                           78 'SALES DOLLARS'
     O                                           87 '-------'
     O                                           99 '-------'
     O                                          111 'QUANTITIES'
     O                                          120 '-------'
     O          E            HDG            1
     O                                           63 'Current'
     O                                           76 'Current'
     O                                           87 'Last'
     O                                           99 'Current'
     O                                          109 'Current'
     O                                          120 'Last'
     O          E            HDG            0
     O                                            4 'Item'
     O                                           27 'Description'
     O                                           62 'Period'
     O                                           74 'YTD'
     O                                           87 'Year'
     O                                           98 'Period'
     O                                          107 'YTD'
     O                                          120 'Year'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DETL           1
     O                       SHITEM              12
     O                       SHSIZE              15
     O                       LQTY          KB   120
     O                       YQTY          KB   110
     O                       CQTY          KB   100
     O                       LTDS          KB    90
     O                       YTDS          KB    77
     O                       CS$(P)        KB    64
EFD01O                       DESP                52
EFD01O*                77                38 '** Item Not On File **'
     O          E            TLR            1
     O                                          119 '--------'
     O                                          109 '--------'
     O                                           99 '--------'
     O                                           89 '-----------'
     O                                           76 '-----------'
     O                                           63 '----------'
     O          E            TLR         1  1
     O                                           43 'Report Totals:'
     O                       YQTYT         K    110
     O                       LTDST         K     90
     O                       CSLST         K     64
     O          E            TLR            1
     O                       LQTYT         K    120
     O                       CQTYT         K    100
     O                       YTDST         K     77
EFD01 *
**
* Item Deleted-
