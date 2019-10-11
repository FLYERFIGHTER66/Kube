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
      *PROGRAM NAME-------- SAR425
      *SYSTEM-------------- SALES ANALYSIS
      *DESCRIPTION--------- SALES ANALYSIS BY TOP RANKED ITEMS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFSHISTSU  IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FSAR425    O    F  120        PRINTER OFLIND(*INOF)
      *
      * SHIST ARRAYS
     D CS$             S              9  2 DIM(13)
     D PS$             S              9  2 DIM(13)
     D CC$             S              9  2 DIM(13)
     D PC$             S              9  2 DIM(13)
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
     D  LRANK                  6     11  0
     D  LBPC                  12     13
     D  LEPC                  14     15
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
     I              SHCC01                      CC$(1)
     I              SHCC02                      CC$(2)
     I              SHCC03                      CC$(3)
     I              SHCC04                      CC$(4)
     I              SHCC05                      CC$(5)
     I              SHCC06                      CC$(6)
     I              SHCC07                      CC$(7)
     I              SHCC08                      CC$(8)
     I              SHCC09                      CC$(9)
     I              SHCC10                      CC$(10)
     I              SHCC11                      CC$(11)
     I              SHCC12                      CC$(12)
     I              SHCC13                      CC$(13)
      *
     I              SHLC01                      PC$(1)
     I              SHLC02                      PC$(2)
     I              SHLC03                      PC$(3)
     I              SHLC04                      PC$(4)
     I              SHLC05                      PC$(5)
     I              SHLC06                      PC$(6)
     I              SHLC07                      PC$(7)
     I              SHLC08                      PC$(8)
     I              SHLC09                      PC$(9)
     I              SHLC10                      PC$(10)
     I              SHLC11                      PC$(11)
     I              SHLC12                      PC$(12)
     I              SHLC13                      PC$(13)
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
     C     LRANK         IFGT      *ZEROS
     C                   Z-ADD     1             CNT               5 0
     C                   SETON                                        98
     C                   ENDIF
      *
     C     LBPC          IFGT      *BLANKS
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
     C                   SETOFF                                       96
     C                   READ      FSHISTSU                               90
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
     C                   SETON                                        25
     C                   GOTO      NXT
     C                   ENDIF
      *
      * # OF ITEMS TO RANK
      *
     C     LRANK         IFGT      *ZEROS
     C     FIRST         ANDGT     LRANK
     C                   SETON                                        77
     C                   ENDIF
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
      *
     C     KEY18         KLIST
     C                   KFLD                    SHITEM
     C                   KFLD                    SHSIZE
     C     KEY18         CHAIN     FMINVT                             90
     C   90              SETON                                        96
     C                   EXSR      GETDES
      *
     C                   Z-ADD     CSQ(P)        CQTY              8 0
     C                   Z-ADD     PSQ(P)        PQTY              8 0          MTH PRIOR YR
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
     C     YTDS          IFEQ      0
     C                   GOTO      NXT
     C                   ENDIF
      *
      * TOTALS FOR LISTED ITEMS
      *
     C  N77              ADD       CS$(P)        LCDOLT            9 2
     C  N77              ADD       YTDS          LYDOLT            9 2
     C  N77              ADD       LTDS          LLDOLT            9 2
     C  N77              ADD       CQTY          LCQTYT            8 0
     C  N77              ADD       YQTY          LYQTYT            8 0
     C  N77              ADD       LQTY          LLQTYT            8 0
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
     C  N77              EXCEPT    DETL
     C                   ADD       1             FIRST
     C                   GOTO      NXT
      *
     C     END           TAG
     C   77
     CANN24              EXCEPT    T98
     C                   EXCEPT    TLR
     C                   SETON                                        LR
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
     C                   MOVEL     DESCO         DESP             25
     C                   ENDSR
      *
     OSAR425    E            HDG            1 03
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
     O                                           60 'Sales Analysis By Item'
     O                                           83 '- Top Ranked By Units'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O               24                          16 'Product Classes:'
     O               24      LBPC                19
     O               24                          21 '-'
     O               24      LEPC                24
     O                                           52 'For Period'
     O                       LMONTH              55
     O                       BEGDAT        Y     66
     O                                           69 '-'
     O                       ENDDAT        Y     79
     O          E            HDG            1
     O               98      LRANK         Z     50
     O               98                          70 '= # of Items Ranked'
     O          E            HDG            1
     O                                           55 '----------'
     O                                           70 'SALES DOLLARS'
     O                                           82 '----------'
     O                                           99 '---------'
     O                                          110 'QUANTITIES'
     O                                          120 '---------'
     O          E            HDG            1
     O                                           54 'Current'
     O                                           68 'Current'
     O                                           82 'Last'
     O                                           97 'Current'
     O                                          108 'Current'
     O                                          120 'Last'
     O          E            HDG            1
     O                                            4 'Item'
     O                                           30 'Description'
     O                                           53 'Period'
     O                                           66 'YTD'
     O                                           82 'Year'
     O                                           96 'Period'
     O                                          106 'YTD'
     O                                          120 'Year'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       SHITEM              12
     O                       SHSIZE              15
     O               96                          38 '** Item Not On File **'
     O              N96      DESP                41
     O                       LQTY          KB   120
     O                       YQTY          KB   109
     O                       CQTY          KB    97
     O                       LTDS          KB    83
     O                       YTDS          KB    69
     O                       CS$(P)        KB    55
     O          E            T98         1  1
     O                                          119 '---------'
     O                                          108 '---------'
     O                                           96 '---------'
     O                                           82 '-----------'
     O                                           68 '-----------'
     O                                           54 '-----------'
     O          E            T98            1
     O                                           36 'Totals - Items Listed:'
     O                       LLQTYT        KB   120
     O                       LYQTYT        KB   109
     O                       LCQTYT        KB    97
     O                       LLDOLT        KB    83
     O                       LYDOLT        KB    69
     O                       LCDOLT        KB    55
     O          E            TLR         1  1
     O              N98                         119 '---------'
     O              N98                         108 '---------'
     O              N98                          96 '---------'
     O              N98                          82 '-----------'
     O              N98                          68 '-----------'
     O              N98                          54 '-----------'
     O               98                         119 '========='
     O               98                         108 '========='
     O               98                          96 '========='
     O               98                          82 '==========='
     O               98                          68 '==========='
     O               98                          54 '==========='
     O          E            TLR            1
     O                                           36 'Report Totals:'
     O                       LQTYT         KB   120
     O                       YQTYT         KB   109
     O                       CQTYT         KB    97
     O                       LDOLT         KB    83
     O                       YDOLT         KB    69
     O                       CDOLT         KB    55
