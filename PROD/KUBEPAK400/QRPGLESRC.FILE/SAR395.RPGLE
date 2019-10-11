      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC. 1998
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
      **PROGRAM NAME-------- SAR395
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT INC.
      **DESCRIPTION--------- SALES ANALYSIS BY BILL TO CUSTOMER
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFSHISTBA  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FSAR395    O    F  132        PRINTER OFLIND(*INOF)
      *
      ** SHIST ARRAYS
     D CS$             S              9  2 DIM(13)
     D PS$             S              9  2 DIM(13)
     D CSQ             S             11  1 DIM(13)
     D PSQ             S             11  1 DIM(13)
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
     D  LDOLUN                 5      5  0
     D  LDORP                  6      6
     D  LGROSS                 7      7
     D  LSTYP                  8      9
     D  LETYP                 10     11
     D  LACTIV                12     12
     D  LPROG                 29     36
     D  LNAME                 37     66
     D  LPRTR                100    109
     D  LFORM                110    113
     D  LCOPY                114    115  0
     D  LJOB                 116    116
     D  LHOLD                117    120
     D  LSAVE                121    124
     D  LCANCL               133    133
      *
     IRSHISTB
      *
     I              SBCS01                      CS$(1)
     I              SBCS02                      CS$(2)
     I              SBCS03                      CS$(3)
     I              SBCS04                      CS$(4)
     I              SBCS05                      CS$(5)
     I              SBCS06                      CS$(6)
     I              SBCS07                      CS$(7)
     I              SBCS08                      CS$(8)
     I              SBCS09                      CS$(9)
     I              SBCS10                      CS$(10)
     I              SBCS11                      CS$(11)
     I              SBCS12                      CS$(12)
     I              SBCS13                      CS$(13)
      *
     I              SBLS01                      PS$(1)
     I              SBLS02                      PS$(2)
     I              SBLS03                      PS$(3)
     I              SBLS04                      PS$(4)
     I              SBLS05                      PS$(5)
     I              SBLS06                      PS$(6)
     I              SBLS07                      PS$(7)
     I              SBLS08                      PS$(8)
     I              SBLS09                      PS$(9)
     I              SBLS10                      PS$(10)
     I              SBLS11                      PS$(11)
     I              SBLS12                      PS$(12)
     I              SBLS13                      PS$(13)
      *
     I              SBCQ01                      CSQ(1)
     I              SBCQ02                      CSQ(2)
     I              SBCQ03                      CSQ(3)
     I              SBCQ04                      CSQ(4)
     I              SBCQ05                      CSQ(5)
     I              SBCQ06                      CSQ(6)
     I              SBCQ07                      CSQ(7)
     I              SBCQ08                      CSQ(8)
     I              SBCQ09                      CSQ(9)
     I              SBCQ10                      CSQ(10)
     I              SBCQ11                      CSQ(11)
     I              SBCQ12                      CSQ(12)
     I              SBCQ13                      CSQ(13)
      *
     I              SBLQ01                      PSQ(1)
     I              SBLQ02                      PSQ(2)
     I              SBLQ03                      PSQ(3)
     I              SBLQ04                      PSQ(4)
     I              SBLQ05                      PSQ(5)
     I              SBLQ06                      PSQ(6)
     I              SBLQ07                      PSQ(7)
     I              SBLQ08                      PSQ(8)
     I              SBLQ09                      PSQ(9)
     I              SBLQ10                      PSQ(10)
     I              SBLQ11                      PSQ(11)
     I              SBLQ12                      PSQ(12)
     I              SBLQ13                      PSQ(13)
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LACTIV        IFEQ      'Y'
     C                   SETON                                        22
     C                   END
      *
     C     LSTYP         IFGT      *BLANKS
     C                   SETON                                        24
     C                   ENDIF
      *
     C     LCO           CHAIN     FMCOMP                             88
     C     LCO           CHAIN     FMAPER                             88
     C     ACMPCN        COMP      'M'                                525251
      *
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
     C                   READ      FSHISTBA                               90
     C   90              GOTO      END
      *
     C     SBSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SBCUST        IFEQ      *ZEROS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   24SBCUTP        IFLT      LSTYP
     C     SBCUTP        ORGT      LETYP
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SBCUST        CHAIN     FMCUST                             90
      *
     C                   Z-ADD     CSQ(P)        CQTY              8 0
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CSQ(X)        YQTY              8 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PSQ(X)        LQTY              8 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CS$(X)        YTDS              9 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PS$(X)        LTDS              9 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C   22LQTY          IFEQ      0
     C     YQTY          ANDEQ     0
     C     CQTY          ANDEQ     0
     C     LTDS          ANDEQ     0
     C     YTDS          ANDEQ     0
     C     CS$(P)        ANDEQ     0
     C                   GOTO      NXT
     C                   ENDIF
      *
      * REPORT TOTALS
      *
     C                   ADD       CS$(P)        CDOLT             9 2
     C                   ADD       YTDS          YDOLT             9 2
     C                   ADD       LTDS          LDOLT             9 2
     C                   ADD       CQTY          CQTYT             8 0
     C                   ADD       YQTY          YQTYT             8 0
     C                   ADD       LQTY          LQTYT             8 0
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
     OSAR395    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       MCNAME              75
     O                                           90 'Company:'                  APR500
     O                       LCO                 93                             APR500
     O                       PAGE          1    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           63 'Sales Analysis By'
     O                                           80 'Bill To Customer'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           52 'For Period:'
     O                       LMONTH              55
     O                       BEGDAT        Y     66
     O                                           69 '-'
     O                       ENDDAT        Y     79
     O               24                          15 'Customer Types:'
     O               24      LSTYP               18
     O               24                          20 '-'
     O               24      LETYP               23
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
     O                                           15 'Customer'
     O                                           48 'Period'
     O                                           62 'YTD'
     O                                           77 'Year'
     O                                           91 'Period'
     O                                          104 'YTD'
     O                                          120 'Year'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DETL           1
     O                       SBCUST        Z      6
     O                       CMNAME              37
     O                       LQTY          KB   120
     O                       YQTY          KB   107
     O                       CQTY          KB    92
     O                       LTDS          KB    78
     O                       YTDS          KB    64
     O                       CS$(P)        KB    49
     O          E            TLR            1
     O                                          119 '----------'
     O                                          106 '----------'
     O                                           91 '----------'
     O                                           77 '-----------'
     O                                           63 '-----------'
     O                                           48 '----------'
     O          E            TLR            1
     O                                           33 'Report Totals:'
     O                       LQTYT         KB   120
     O                       YQTYT         KB   107
     O                       CQTYT         KB    92
     O                       LDOLT         KB    78
     O                       YDOLT         KB    64
     O                       CDOLT         KB    49
