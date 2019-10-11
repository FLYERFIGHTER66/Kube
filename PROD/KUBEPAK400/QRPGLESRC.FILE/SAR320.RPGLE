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
      *PROGRAM NAME-------- SAR320
      *SYSTEM-------------- SALES ANALYSIS
      *DESCRIPTION--------- SALES ANALYSIS BY CUSTOMER
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 5/21/00 EFD01 MOVE ** NOT ON FILE ** DESCRIPTIONS IF REC DEL
      *
      *
      *
     FFSHISTSC  IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FSAR320    O    F  132        PRINTER OFLIND(*INOF)
      *
EFD01D MSG             S             30    DIM(1) CTDATA PERRCD(1)
      *
      * SHIST ARRAYS
     D CS$             S              9  2 DIM(13)                              SALES CUR YEAR
     D PS$             S              9  2 DIM(13)                              SALES LST YEAR
     D CC$             S              9  2 DIM(13)                              COST CUR YEAR
     D PC$             S              9  2 DIM(13)                              COST LAST YEAR
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
     D  LDOLUN                 5      5  0
     D  LGRPRO                 6      6
     D  LDORP                  7      7
     D  LBTYP                  8      9
     D  LETYP                 10     11
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
      * GET PERIOD
      *
     C                   Z-ADD     LMONTH        P                 2 0
      *
      * SALES DOLLARS ONLY
      *
     C     LDOLUN        IFEQ      1
     C                   SETON                                        20
     C                   ENDIF
      *
      * SALES QUANTITY ONLY
      *
     C     LDOLUN        IFEQ      2
     C                   SETON                                        21
     C                   ENDIF
      *
      * PRINT ONLY ACTIVE CUSTOMERS
      *
     C     LACTIV        IFEQ      'Y'
     C                   SETON                                        22
     C                   END
      *
      * PRINT GROSS PROFIT
      *
     C     LGRPRO        IFEQ      'Y'
     C                   SETON                                        97
     C                   END
      *
      * PRINT PROFIT AS $ OR %
      *
     C     LDORP         IFEQ      '%'
     C                   SETON                                        30
     C                   ENDIF
      *
      * CUSTOMER TYPE RANGE
      *
     C     LBTYP         IFGT      *BLANKS
     C                   SETON                                        24
     C                   ENDIF
      *
     C     LCO           CHAIN     FMCORG                             88
     C     LCO           CHAIN     FMAPER                             88
     C     ACMPCN        IFEQ      'M'
     C                   SETON                                        51
     C                   ENDIF
     C     ACMPCN        IFEQ      'P'
     C                   SETON                                        52
     C                   ENDIF
      *
      * CHECK IF MONTH = 01
      *
     C     P             IFGT      1
     C     P             SUB       1             Q                 2 0
     C                   ENDIF
     C   51P             IFEQ      1
     C                   SETON                                        44
     C                   Z-ADD     12            Q                 2 0
     C                   ENDIF
     C   52P             IFEQ      1
     C                   Z-ADD     13            Q                 2 0
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
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   Z-ADD     0             PYTDC
     C                   Z-ADD     0             CYTDC
      *
     C                   READ      FSHISTSC                               90
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
     C     SHCUST        IFEQ      *ZEROS
     C                   GOTO      NXT
     C                   ENDIF
      *
      * SELECT CUSTOMER TYPE
      *
     C   24SHCUTP        IFLT      LBTYP
     C     SHCUTP        ORGT      LETYP
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   20              EXSR      CURRYR                                       DOLLARS
     C   20              EXSR      PREVYR                                       DOLLARS
     C   21              EXSR      UCURYR                                       UNITS
     C   21              EXSR      UPREYR                                       UNITS
     C   97              EXSR      CUSPRO
      *
     C   20
     CAN 22PYTDS         IFEQ      0
     C     PYPPS         ANDEQ     0
     C     PYCPS         ANDEQ     0
     C     CYTDS         ANDEQ     0
     C     CYPPS         ANDEQ     0
     C     CYCP$         ANDEQ     0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   21
     CAN 22PYTDQ         IFEQ      0
     C     PYPPQ         ANDEQ     0
     C     PQTY          ANDEQ     0
     C     CYTDQ         ANDEQ     0
     C     CYPPQ         ANDEQ     0
     C     CQTY          ANDEQ     0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
      *
EFD01C                   MOVEL     *BLANKS       CMNAME
     C     SHCUST        CHAIN     FMCUST                             90
EFD01C*  90                MOVELMSG,1     CMNAME
EFD01C   90              MOVEL     MSG(1)        CMNAME
EFD01C   90              MOVE      SHCMAL        CMNAME
     C                   EXCEPT    DETL
     C   97              EXCEPT    D97
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXSR      COMPRO
     C                   EXCEPT    TLR
     C   97              EXCEPT    T97
     C                   SETON                                        LR
      **********
      * CURRYR *
      **********
      *
      * GET CURRENT YEAR SALES
      *
     C     CURRYR        BEGSR
      *
     C                   Z-ADD     CS$(P)        CYCP$             9 2          CUR MTH SLS
     C                   Z-ADD     CS$(Q)        CYPPS             9 2          PRI MTH SLS
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CS$(X)        CYTDS             9 2
     C                   ADD       CS$(X)        RCYTDS           10 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C   97              Z-ADD     CC$(P)        CYCPC             9 2          CUR COST
     C   97              Z-ADD     CC$(Q)        CYPPC             9 2          PRIOR COST
      *
     C                   Z-ADD     1             X                 2 0
     C   97X             DOUGT     P
     C                   ADD       CC$(X)        CYTDC             9 2
     C                   ADD       CC$(X)        RCYTDC           10 2
     C                   ADD       1             X
     C                   ENDDO
      *
      * REPORT TOTALS
      *
     C                   ADD       CS$(P)        RCYCPS           10 2
     C                   ADD       CS$(Q)        RCYPPS           10 2
      *
      * COSTS TOTALS
      *
     C                   ADD       CC$(P)        RCYCPC           10 2
     C                   ADD       CC$(Q)        RCYPPC           10 2
      *
     C                   ENDSR
      **********
      * PREVYR *
      **********
      *
      * GET PRIOR YEAR SALES
      *
     C     PREVYR        BEGSR
      *
     C                   ADD       PS$(P)        PYCPS             9 2          LYR MTH SLS
     C                   Z-ADD     PS$(Q)        PYPPS             9 2          PRI MTH SLS
      *
     C                   Z-ADD     PC$(P)        PYCPC             9 2          CUR COST
     C                   Z-ADD     PC$(Q)        PYPPC             9 2          PRIOR COST
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PS$(X)        PYTDS             9 2
     C                   ADD       PS$(X)        RPYTDS            9 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PC$(X)        PYTDC             9 2
     C                   ADD       PC$(X)        RPYTDC           10 2
     C                   ADD       1             X
     C                   ENDDO
      *
      * REPORT TOTALS
      *
     C                   ADD       PS$(P)        RPYCPS           10 2
     C                   ADD       PS$(Q)        RPYPPS           10 2
      *
      * COSTS TOTALS
      *
     C                   ADD       PC$(P)        RPYCPC           10 2
     C                   ADD       PC$(Q)        RPYPPC           10 2
      *
     C                   ENDSR
      *
      **********
      * UCURYR *
      **********
      *
      * GET CURRENT YEAR QUANTITY
      *
     C     UCURYR        BEGSR
      *
     C                   Z-ADD     CSQ(P)        CQTY             11 0          CUR MTH QTY
     C                   Z-ADD     CSQ(Q)        CYPPQ            11 0          PRI MTH QTY
     C                   ADD       CSQ(P)        RCQTY            12 0
     C                   ADD       CSQ(Q)        RCYPPQ           12 0
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CSQ(X)        CYTDQ            11 0
     C                   ADD       CSQ(X)        RCYTDQ           12 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   ENDSR
      **********
      * UPREYR *
      **********
      *
      * GET PRIOR YEAR QUANTITY
      *
     C     UPREYR        BEGSR
      *
     C                   Z-ADD     PSQ(P)        PQTY             11 0          CUR MTH QTY
     C                   Z-ADD     PSQ(Q)        PYPPQ            11 0          PRI MTH QTY
     C                   ADD       PSQ(P)        RPYCPQ           12 0
     C                   ADD       PSQ(Q)        RPYPPQ           12 0
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PSQ(X)        PYTDQ            11 0
     C                   ADD       PSQ(X)        RPYTDQ           12 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   ENDSR
      *
      **********************************************************
      * THIS SUBROUTINE COMPUTES GROSS PROFIT BY EITHER $ OR % *
      **********************************************************
      *
     C     CUSPRO        BEGSR
      *
     C                   Z-ADD     0             TCGP
     C                   Z-ADD     0             TPGP
     C                   Z-ADD     0             TYGP
     C                   Z-ADD     0             LCGP
     C                   Z-ADD     0             LPGP
     C                   Z-ADD     0             LYGP
      *
      * GET DOLLAR PROFIT
      *
     C     CYCP$         SUB       CYCPC         TCGP              9 2
     C     CYPPS         SUB       CYPPC         TPGP              9 2
     C     CYTDS         SUB       CYTDC         TYGP              9 2
      *
     C     PYCPS         SUB       PYCPC         LCGP              9 2
     C     PYPPS         SUB       PYPPC         LPGP              9 2
     C     PYTDS         SUB       PYTDC         LYGP              9 2
      *
     C  N30              GOTO      ECUSGP                                       NOT PERCENT
      *
      * IF SALES = 0 PUT 0 IN GROSS PROFIT WHEN % REQUESTED
      *
      * THIS YEAR CURRENT PERIOD
      *
     C                   SETOFF                                       98
     C     CYCP$         IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             TCGP
     C  N98TCGP          DIV(H)    CYCP$         PTCGP             9 4          PERCENT
     C  N98PTCGP         MULT      100           TCGP
      *
      * THIS YEAR PRIOR PERIOD
      *
     C                   SETOFF                                       98
     C     CYPPS         IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             TPGP
     C  N98TPGP          DIV(H)    CYPPS         PTPGP             9 4              GROSS
     C  N98PTPGP         MULT      100           TPGP
      *
      * THIS YEAR TO DATE
      *
     C                   SETOFF                                       98
     C     CYTDS         IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             TYGP
     C  N98TYGP          DIV(H)    CYTDS         PTYGP             9 4                   PROFIT
     C  N98PTYGP         MULT      100           TYGP
      *
     C                   SETOFF                                       98
     C     PYCPS         IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             LCGP
     C  N98LCGP          DIV(H)    PYCPS         PLCGP             9 4
     C  N98PLCGP         MULT      100           LCGP
      *
     C                   SETOFF                                       98
     C     PYPPS         IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             LPGP
     C  N98LPGP          DIV(H)    PYPPS         PLPGP             9 4
     C  N98PLPGP         MULT      100           LPGP
      *
     C                   SETOFF                                       98
     C     PYTDS         IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             LYGP
     C  N98LYGP          DIV(H)    PYTDS         PLYGP             9 4
     C  N98PLYGP         MULT      100           LYGP
      *
     C     ECUSGP        TAG
     C                   ENDSR
      *
      ***********************************************************
      * COMPUTES THE GROSS PROFIT FOR COMPANY TOTALS BY % OR $  *
      ***********************************************************
      *
     C     COMPRO        BEGSR
      *
     C     RCYCPS        SUB       RCYCPC        CTCGP            10 2
     C     RCYPPS        SUB       RCYPPC        CTPGP            10 2
     C     RCYTDS        SUB       RCYTDC        CTYGP            10 2
      *
     C     RPYCPS        SUB       RPYCPC        CLCGP            10 2
     C     RPYPPS        SUB       RPYPPC        CLPGP            10 2
     C     RPYTDS        SUB       RPYTDC        CLYGP            10 2
      *
     C  N30              GOTO      ECOMGP
      *
      * IF SALES = 0 PUT 0 IN GROSS PROFIT WHEN % REQUESTED
      *
      * THIS YEAR CURRENT PERIOD
      *
     C                   SETOFF                                       98
     C     RCYCPS        IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             CTCGP
     C  N98CTCGP         DIV(H)    RCYCPS        PTCGP             9 4          PERCENT
     C  N98PTCGP         MULT      100           CTCGP
      *
      * THIS YEAR PRIOR PERIOD
      *
     C                   SETOFF                                       98
     C     RCYPPS        IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             CTPGP
     C  N98CTPGP         DIV(H)    RCYPPS        PTPGP             9 4              GROSS
     C  N98PTPGP         MULT      100           CTPGP
      *
      * THIS YEAR TO DATE
      *
     C                   SETOFF                                       98
     C     RCYTDS        IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             CTYGP
     C  N98CTYGP         DIV(H)    RCYTDS        PTYGP             9 4                      FIT
     C  N98PTYGP         MULT      100           CTYGP
      *
     C                   SETOFF                                       98
     C     RPYCPS        IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             CLCGP
     C  N98CLCGP         DIV(H)    RPYCPS        PLCGP             9 4
     C  N98PLCGP         MULT      100           CLCGP
      *
     C                   SETOFF                                       98
     C     RPYPPS        IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             CLPGP
     C  N98CLPGP         DIV(H)    RPYPPS        PLPGP             9 4
     C  N98PLPGP         MULT      100           CLPGP
      *
     C                   SETOFF                                       98
     C     RPYTDS        IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             CLYGP
     C  N98CLYGP         DIV(H)    RPYTDS        PLYGP             9 4
     C  N98PLYGP         MULT      100           CLYGP
      *
     C     ECOMGP        TAG
     C                   ENDSR
      *
     OSAR320    E            HDG            1 03
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
     O               20                          49 'Dollar'
     O               21                          49 ' Unit'
     O                                           67 'Sales Analysis By'
     O                                           76 'Customer'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           52 'For Period:'
     O                       LMONTH              55
     O                       BEGDAT        Y     66
     O                                           69 '-'
     O                       ENDDAT        Y     79
     O               24                          15 'Customer Types:'
     O               24      LBTYP               18
     O               24                          20 '-'
     O               24      LETYP               23
     O          E            HDG            1
     O                                            8 'Customer'
     O                                           23 'N   A   M   E'
     O                                           44 '-------'
     O                                           58 'C U R R E N T'
     O                                           75 'Y E A R -------'
     O                                           91 '---------'
     O                                          110 'P R I O R  Y E A R'
     O                                          120 '---------'
     O          E            HDG            1
     O                                            7 'Number'
     O                                           47 'This Period'
     O                                           61 'Prior Period'
     O                                           75 'Year To Date'
     O                                           92 'This Period'
     O                                          106 'Prior Period'
     O                                          120 'Year To Date'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       SHCUST        Z      6
     O                       CMNAME              37
     O               20      PYTDS         KB   120
     O               21      PYTDQ         KB   120
     O               20      PYPPS         KB   106
     O               21      PYPPQ         KB   106
     O               20      PYCPS         KB    92
     O               21      PQTY          KB    92
     O               20      CYTDS         KB    76
     O               21      CYTDQ         KB    76
     O               20      CYPPS         KB    62
     O               21      CYPPQ         KB    62
     O               20      CS$(P)        KB    48
     O               21      CQTY          KB    48
     O          E            D97            2
     O                                           25 'Gross Profit'
     O                    N30                    34 'Dollars:'
     O                     30                    35 'Percents:'
     O                       TCGP          KB    48
     O                       TPGP          KB    62
     O                       TYGP          KB    76
     O                       LCGP          KB    92
     O                       LPGP          KB   106
     O                       LYGP          KB   120
     O          E            TLR            1
     O                                          119 '----------'
     O                                          105 '----------'
     O                                           91 '----------'
     O                                           75 '-----------'
     O                                           61 '-----------'
     O                                           47 '----------'
     O          E            TLR            1
     O                                           31 'Total Report:'
     O               20      RPYPPS        KB   106
     O               21      RPYPPQ        KB   106
     O               20      RCYTDS        KB    76
     O               21      RCYTDQ        KB    76
     O               20      RCYCPS        KB    48
     O               21      RCQTY         KB    48
     O          E            TLR            2
     O               21      RPYTDQ        KB   120
     O               20      RPYTDS        KB   120
     O               21      RPYCPQ        KB    92
     O               20      RPYCPS        KB    92
     O               21      RCYPPQ        KB    62
     O               20      RCYPPS        KB    62
     O          E            T97            1
     O                       CLPGP         KB   106
     O                       CTYGP         KB    76
     O                       CTCGP         KB    48
     O          E            T97            2
     O                                           25 'Report Gross Profit'
     O                    N30                    34 'Dollars:'
     O                     30                    35 'Percents:'
     O                       CTPGP         KB    62
     O                       CLCGP         KB    92
     O                       CLYGP         KB   120
EFD01 *
**
* Cust Deleted-
