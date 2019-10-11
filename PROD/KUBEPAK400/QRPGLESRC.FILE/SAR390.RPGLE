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
      **PROGRAM NAME-------- SAR390
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT INC.
      **DESCRIPTION--------- SALES ANALYSIS BY BILL TO CUSTOMER
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFSHISTBA  IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FSAR390    O    F  132        PRINTER OFLIND(*INOF)
      *
      * SHISTB ARRAYS
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
     I              SBCC01                      CC$(1)
     I              SBCC02                      CC$(2)
     I              SBCC03                      CC$(3)
     I              SBCC04                      CC$(4)
     I              SBCC05                      CC$(5)
     I              SBCC06                      CC$(6)
     I              SBCC07                      CC$(7)
     I              SBCC08                      CC$(8)
     I              SBCC09                      CC$(9)
     I              SBCC10                      CC$(10)
     I              SBCC11                      CC$(11)
     I              SBCC12                      CC$(12)
     I              SBCC13                      CC$(13)
      *
     I              SBLC01                      PC$(1)
     I              SBLC02                      PC$(2)
     I              SBLC03                      PC$(3)
     I              SBLC04                      PC$(4)
     I              SBLC05                      PC$(5)
     I              SBLC06                      PC$(6)
     I              SBLC07                      PC$(7)
     I              SBLC08                      PC$(8)
     I              SBLC09                      PC$(9)
     I              SBLC10                      PC$(10)
     I              SBLC11                      PC$(11)
     I              SBLC12                      PC$(12)
     I              SBLC13                      PC$(13)
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
     C     LGROSS        IFEQ      'Y'
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
     C     LSTYP         IFGT      *BLANKS
     C                   SETON                                        24
     C                   ENDIF
      *
     C     LCO           CHAIN     FMCOMP                             88
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
      * SELECT CUSTOMER TYPE
      *
     C   24SBCUTP        IFLT      LSTYP
     C     SBCUTP        ORGT      LETYP
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
     CAN 22PYTD$         IFEQ      0
     C     PYPP$         ANDEQ     0
     C     PYCP$         ANDEQ     0
     C     CYTD$         ANDEQ     0
     C     CYPP$         ANDEQ     0
     C     CYCP$         ANDEQ     0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   21
     CAN 22PYTDQ         IFEQ      0
     C     PYPPQ         ANDEQ     0
     C     PYCPQ         ANDEQ     0
     C     CYTDQ         ANDEQ     0
     C     CYPPQ         ANDEQ     0
     C     CYCPQ         ANDEQ     0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
      *
     C     SBCUST        CHAIN     FMCUST                             90
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
     C                   Z-ADD     CS$(Q)        CYPP$             9 2          PRI MTH SLS
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CS$(X)        CYTD$             9 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C   97              Z-ADD     CC$(P)        CYCPC             9 2          CUR COST
     C   97              Z-ADD     CC$(Q)        CYPPC             9 2          PRIOR COST
      *
     C                   Z-ADD     1             X                 2 0
     C   97X             DOUGT     P
     C                   ADD       CC$(X)        CYTDC             9 2
     C                   ADD       1             X
     C                   ENDDO
      *
      * REPORT TOTALS
      *
     C                   ADD       CS$(P)        RCYCP$           10 2
     C                   ADD       CS$(Q)        RCYPP$           10 2
     C                   ADD       CYTD$         RCYTD$           10 2
      *
      * COSTS TOTALS
      *
     C                   ADD       CC$(P)        RCYCPC           10 2
     C                   ADD       CC$(Q)        RCYPPC           10 2
     C                   ADD       CYTDC         RCYTDC           10 2
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
     C                   ADD       PS$(P)        PYCP$             9 2          LYR MTH SLS
     C                   Z-ADD     PS$(Q)        PYPP$             9 2          PRI MTH SLS
      *
     C                   Z-ADD     PC$(P)        PYCPC             9 2          CUR COST
     C                   Z-ADD     PC$(Q)        PYPPC             9 2          PRIOR COST
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PS$(X)        PYTD$             9 2
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PC$(X)        PYTDC             9 2
     C                   ADD       1             X
     C                   ENDDO
      *
      * REPORT TOTALS
      *
     C                   ADD       PS$(P)        RPYCP$           10 2
     C                   ADD       PS$(Q)        RPYPP$           10 2
     C                   ADD       PYTD$         RPYTD$           10 2
      *
      * COSTS TOTALS
      *
     C                   ADD       PC$(P)        RPYCPC           10 2
     C                   ADD       PC$(Q)        RPYPPC           10 2
     C                   ADD       PYTDC         RPYTDC           10 2
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
     C                   ADD       CSQ(P)        CYCPQ            11 0          CUR MTH QTY
     C                   Z-ADD     CSQ(P)        CYPPQ            11 0          PRI MTH QTY
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       CSQ(X)        CYTDQ            11 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
      * REPORT TOTALS
      *
     C                   ADD       CSQ(P)        RCYCPQ           12 0
     C                   ADD       CSQ(Q)        RCYPPQ           12 0
     C                   ADD       CYTDQ         RCYTDQ           12 0
     C                   ENDSR
      **********
      * UPREYR *
      **********
      *
      * GET PRIOR YEAR QUANTITY
      *
     C     UPREYR        BEGSR
      *
     C                   ADD       PSQ(P)        PYCPQ            11 0
     C                   Z-ADD     PSQ(P)        PYPPQ            11 0
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     P
     C                   ADD       PSQ(X)        PYTDQ            11 0
     C                   ADD       1             X                 2 0
     C                   ENDDO
      *
      * REPORT TOTALS
      *
     C                   ADD       PSQ(P)        RPYCPQ           12 0
     C                   ADD       PSQ(Q)        RPYPPQ           12 0
     C                   ADD       PYTDQ         RPYTDQ           12 0
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
     C     CYPP$         SUB       CYPPC         TPGP              9 2
     C     CYTD$         SUB       CYTDC         TYGP              9 2
      *
     C     PYCP$         SUB       PYCPC         LCGP              9 2
     C     PYPP$         SUB       PYPPC         LPGP              9 2
     C     PYTD$         SUB       PYTDC         LYGP              9 2
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
     C     CYPP$         IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             TPGP
     C  N98TPGP          DIV(H)    CYPP$         PTPGP             9 4              GROSS
     C  N98PTPGP         MULT      100           TPGP
      *
      * THIS YEAR TO DATE
      *
     C                   SETOFF                                       98
     C     CYTD$         IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             TYGP
     C  N98TYGP          DIV(H)    CYTD$         PTYGP             9 4                   PROFIT
     C  N98PTYGP         MULT      100           TYGP
      *
     C                   SETOFF                                       98
     C     PYCP$         IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             LCGP
     C  N98LCGP          DIV(H)    PYCP$         PLCGP             9 4
     C  N98PLCGP         MULT      100           LCGP
      *
     C                   SETOFF                                       98
     C     PYPP$         IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             LPGP
     C  N98LPGP          DIV(H)    PYPP$         PLPGP             9 4
     C  N98PLPGP         MULT      100           LPGP
      *
     C                   SETOFF                                       98
     C     PYTD$         IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             LYGP
     C  N98LYGP          DIV(H)    PYTD$         PLYGP             9 4
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
     C     RCYCP$        SUB       RCYCPC        CTCGP            10 2
     C     RCYPP$        SUB       RCYPPC        CTPGP            10 2
     C     RCYTD$        SUB       RCYTDC        CTYGP            10 2
      *
     C     RPYCP$        SUB       RPYCPC        CLCGP            10 2
     C     RPYPP$        SUB       RPYPPC        CLPGP            10 2
     C     RPYTD$        SUB       RPYTDC        CLYGP            10 2
      *
     C  N30              GOTO      ECOMGP
      *
      * IF SALES = 0 PUT 0 IN GROSS PROFIT WHEN % REQUESTED
      *
      * THIS YEAR CURRENT PERIOD
      *
     C                   SETOFF                                       98
     C     RCYCP$        IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             CTCGP
     C  N98CTCGP         DIV(H)    RCYCP$        PTCGP             9 4          PERCENT
     C  N98PTCGP         MULT      100           CTCGP
      *
      * THIS YEAR PRIOR PERIOD
      *
     C                   SETOFF                                       98
     C     RCYPP$        IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             CTPGP
     C  N98CTPGP         DIV(H)    RCYPP$        PTPGP             9 4              GROSS
     C  N98PTPGP         MULT      100           CTPGP
      *
      * THIS YEAR TO DATE
      *
     C                   SETOFF                                       98
     C     RCYTD$        IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             CTYGP
     C  N98CTYGP         DIV(H)    RCYTD$        PTYGP             9 4                      FIT
     C  N98PTYGP         MULT      100           CTYGP
      *
     C                   SETOFF                                       98
     C     RPYCP$        IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             CLCGP
     C  N98CLCGP         DIV(H)    RPYCP$        PLCGP             9 4
     C  N98PLCGP         MULT      100           CLCGP
      *
     C                   SETOFF                                       98
     C     RPYPP$        IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             CLPGP
     C  N98CLPGP         DIV(H)    RPYPP$        PLPGP             9 4
     C  N98PLPGP         MULT      100           CLPGP
      *
     C                   SETOFF                                       98
     C     RPYTD$        IFEQ      0
     C                   SETON                                        98
     C                   ENDIF
      *
     C   98              Z-ADD     0             CLYGP
     C  N98CLYGP         DIV(H)    RPYTD$        PLYGP             9 4
     C  N98PLYGP         MULT      100           CLYGP
      *
     C     ECOMGP        TAG
     C                   ENDSR
      *
     OSAR390    E            HDG            1 03
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
     O               20                          45 'Dollar'
     O               21                          45 ' Unit'
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
     O                       SBCUST        Z      6
     O                       CMNAME              37
     O               20      PYTD$         KB   120
     O               21      PYTDQ         KB   120
     O               20      PYPP$         KB   106
     O               21      PYPPQ         KB   106
     O               20      PYCP$         KB    92
     O               21      PYCPQ         KB    92
     O               20      CYTD$         KB    76
     O               21      CYTDQ         KB    76
     O               20      CYPP$         KB    62
     O               21      CYPPQ         KB    62
     O               20      CYCP$         KB    48
     O               21      CYCPQ         KB    48
     O          E            D97            2
     O                                           22 'Gross Profit'
     O                    N30                    31 'Dollars:'
     O                     30                    35 'Percentages:'
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
     O               20      RPYPP$        KB   106
     O               21      RPYPPQ        KB   106
     O               20      RCYTD$        KB    76
     O               21      RCYTDQ        KB    76
     O               20      RCYCP$        KB    48
     O               21      RCYCPQ        KB    48
     O          E            TLR            2
     O               21      RPYTDQ        KB   120
     O               20      RPYTD$        KB   120
     O               21      RPYCPQ        KB    92
     O               20      RPYCP$        KB    92
     O               21      RCYPPQ        KB    62
     O               20      RCYPP$        KB    62
     O          E            T97            1
     O                       CLPGP         KB   106
     O                       CTYGP         KB    76
     O                       CTCGP         KB    48
     O          E            T97            2
     O                                           22 'Report Gross Profit'
     O                    N30                    31 'Dollars:'
     O                     30                    35 'Percentages:'
     O                       CTPGP         KB    62
     O                       CLCGP         KB    92
     O                       CLYGP         KB   120
