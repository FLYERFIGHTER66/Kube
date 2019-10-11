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
      *PROGRAM NAME-------- SAR410
      *SYSTEM-------------- SALES ANALYSIS
      *DESCRIPTION--------- SALES ANALYSIS BY PRODUCT CLASS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFSHISTPC  IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FSAR410    O    F  120        PRINTER OFLIND(*INOF)
      *
      ** SHIST ARRAYS
     D CS$             S              9  2 DIM(13)
     D PS$             S              9  2 DIM(13)
     D CSQ             S             11  1 DIM(13)
     D PSQ             S             11  1 DIM(13)
      *
     D                UDS
     D  LCO                    1      2  0
     D  LMONTH                 3      4  0
     D  LDOLUN                 5      5  0
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
     C     LDOLUN        IFEQ      1
     C                   SETON                                        20
     C                   ENDIF
      *
     C     LDOLUN        IFEQ      2
     C                   SETON                                        21
     C                   ENDIF
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
     C                   SETOFF                                       77
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
     C     FIRST         IFNE      1
     C     SHPCL1        ANDNE     OLDPC
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C     OLDPC         CHAIN     FMPRCL                             90
     C   90              SETON                                        77
     C                   EXCEPT    TL1
     C                   Z-ADD     1             PCCNT
     C                   ENDIF
      *
     C                   ADD       CSQ(P)        CQTY              8 0
     C                   ADD       CSQ(P)        CQTYT             9 0
     C                   ADD       CS$(P)        CDOL              9 2
     C                   ADD       CS$(P)        CDOLT            10 2
     C                   ADD       PSQ(P)        PQTY              8 0
     C                   ADD       PSQ(P)        PQTYT             9 0
     C                   ADD       PS$(P)        PDOL              9 2
     C                   ADD       PS$(P)        PDOLT            10 2
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CSQ(X)        YQTY              8 0
     C                   ADD       CSQ(X)        YQTYT             9 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PSQ(X)        LQTY              8 0
     C                   ADD       PSQ(X)        LQTYT             9 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CS$(X)        YTDS              9 2
     C                   ADD       CS$(X)        YDOLT            10 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PS$(X)        LTDS              9 2
     C                   ADD       PS$(X)        LDOLT            10 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   MOVEL     SHPCL1        OLDPC             2
     C                   MOVEL     PCDESC        ODESC            30
      *
     C                   ADD       1             FIRST
     C                   GOTO      NXT
      *
     C     END           TAG
     C     OLDPC         CHAIN     FMPRCL                             90
     C   90              SETON                                        77
     C                   EXCEPT    TL1
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *
     OSAR410    E            HDG            1 03
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
     O                                           56 'Sales Analysis By'
     O                                           70 'Product Class'
     O               20                          80 ' - Dollars'
     O               21                          80 ' - Units  '
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           51 'For Period'
     O                       LMONTH              54
     O                       BEGDAT        Y     65
     O                                           68 '-'
     O                       ENDDAT        Y     78
     O          E            HDG            1
     O                                           53 '-------'
     O                                           66 'CURRENT YEAR'
     O                                           75 '--------'
     O                                           93 '--------'
     O                                          104 'LAST YEAR'
     O                                          113 '--------'
     O          E            HDG            1
     O                                            8 'PC'
     O                                           21 'Description'
     O                                           56 'This Period'
     O                                           75 'Year To Date'
     O                                           95 'This Period'
     O                                          114 'Year To Date'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           TL1            2
     O                       OLDPC                8
     O              N77      PCDESC              39
     O               77                          30 '** P/C Not On File **'
     O               21      LQTY          KB   115
     O               20      LTDS          KB   115
     O               21      PQTY          KB    96
     O               20      PDOL          KB    96
     O               21      YQTY          KB    76
     O               20      YTDS          KB    76
     O               21      CQTY          KB    57
     O               20      CDOL          KB    57
     O          E            TLR            1
     O                                          114 '------------'
     O                                           95 '------------'
     O                                           75 '------------'
     O                                           56 '------------'
     O          E            TLR         1  1
     O                                           40 'Report Totals:'
     O               21      LQTYT         KB   115
     O               20      LDOLT         KB   115
     O               21      PQTYT         KB    96
     O               20      PDOLT         KB    96
     O               21      YQTYT         KB    76
     O               20      YDOLT         KB    76
     O               21      CQTYT         KB    57
     O               20      CDOLT         KB    57
