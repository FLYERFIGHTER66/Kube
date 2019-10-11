    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *PROGRAM NAME-------- ARR310
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- A/R AGING BY CUSTOMER DETAIL REPORT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFAROPNAL  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFARCTL    IF   E           K DISK
     FARR310    O    F  121        PRINTER OFLIND(*INOF)
      *
     D #PP$            S             11  2 DIM(5)                               PRINT LINE $
     D #PD$            S             11  2 DIM(5)                               PAST DUE $
     D #FD$            S             11  2 DIM(5)                               FUTURE DUE $
     D #FD             S              5  0 DIM(4) ASCEND                        AGING DAYS ARRAY
     D SAR             S             11  2 DIM(5)
      *
     D ASOF7           S              7  0 Inz(*zero)
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
     D                UDS
     D  LCO                    1      2  0
     D  LDATE                  3      8  0
     D  LBCUST                 9     14  0
     D  LECUST                15     20  0
     D  LBSLSM                21     22
     D  LESLSM                23     24
     D  LDAYS                 25     27  0
     D  LINCL                 28     28
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
      *? Function Prototypes
    ?D/COPY QFunctDefn,$_Dates
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     TDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         TCYMD             5 0
      *
     C                   Z-ADD     1             FIRST             6 0
      *
     C     LCO           CHAIN     FMCORG                             97
     C     LCO           CHAIN     FARCTL                             97
      *
     C                   Z-ADD     LDATE         ##MDY
     C                   Eval      ASOF7 = $Date7($DateMDY(LDATE))
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   EXSR      #AGDY
     C                   Z-ADD     1             CCUST             5 0
      *
      * CHECK IF PRINTING SELECTIVE CUSTOMER, SALESPERSON OR DAYS
      *
     C     LBCUST        IFGT      *ZEROS
     C                   SETON                                        19
     C                   ENDIF
     C   19LECUST        IFEQ      *ZEROS
     C                   Z-ADD     LBCUST        LECUST
     C                   ENDIF
     C     LBSLSM        IFGT      *BLANKS
     C                   SETON                                        20
     C                   ENDIF
     C   20LESLSM        IFEQ      *BLANKS
     C                   MOVEL     LBSLSM        LESLSM
     C                   ENDIF
     C     LDAYS         IFGT      0
     C                   SETON                                        21
     C                   ENDIF
      *
      * PRINT AR CONTACT NAME AND TEL #
      *
     C     LINCL         IFEQ      'Y'
     C                   SETON                                        22
     C                   ENDIF
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       88
     C                   READ      FAROPNAL                               90
     C   90              GOTO      END
      *
     C     ARCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     ARSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     ARTDAT        IFGT      ASOF7
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   Z-ADD     ARTDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         TDAT              6 0
      *
     C                   Z-ADD     ARDUDT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         DUDT              6 0
      *
     C                   Z-ADD     ARDUDT        ##MDY
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ACYMD             5 0
      *
      * CHECK IF OVER DAYS
      *
     C  N21              GOTO      NODAY
     C*          TCYMD     SUB  ACYMD     DAYS    50
     C     #WKAOJ        SUB       ACYMD         DAYS              5 0
     C     DAYS          IFLE      LDAYS
     C                   GOTO      NXT
     C                   ENDIF
     C     NODAY         TAG
      *
      * CHECK IF CUSTOMER RANGE
      *
     C   19ARCUST        IFLT      LBCUST
     C     ARCUST        ORGT      LECUST
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK IF SALESPERSON RANGE
      *
     C   20ARSLM1        IFLT      LBSLSM
     C     ARSLM1        ORGT      LESLSM
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK FOR CUSTOMER TOTAL ?
      *
     C     FIRST         IFEQ      1
     C                   GOTO      NOL1
     C                   ENDIF
      *
     C   30ARCUST        IFNE      OCUST
     C     TARDUE        ANDGT     CMCRL$
     C                   SETON                                        88
     C                   ENDIF
     C     ARCUST        IFNE      OCUST
     C                   EXCEPT    TL1
     C                   ADD       1             CCUST             5 0          ACCUM # CUST
     C                   Z-ADD     1             FIRST
     C                   SETOFF                                       3088
     C                   ENDIF
     C     NOL1          TAG
      *
     C     FIRST         IFEQ      1
     C     ARCUST        CHAIN     FMCUST                             98        CUSTOMER MASTER
     C                   MOVEL     CMNAME        CNAME            30
     C     CMCRL$        IFGT      *ZEROS
     C                   SETON                                        30
     C                   ENDIF
     C                   EXCEPT    DETL1
     C                   ENDIF
      *
     C                   Z-ADD     ARCUST        OCUST             6 0
      *
     C                   EXSR      TYPE
     C                   EXSR      AGING
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   ENDDO
      *
     C   22FIRST         IFEQ      1
     C                   EXCEPT    DETNAM
     C                   ENDIF
     C                   EXCEPT    DETL
     C                   SETON                                        77
     C                   ADD       1             FIRST
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C   30TARDUE        IFGT      CMCRL$
     C                   SETON                                        88
     C                   ENDIF
     C   77              EXCEPT    TL1
     C   77              EXCEPT    TLR
     C  N77              EXCEPT    TLRN
     C                   SETON                                        LR
      *
      * DETERMINE A/R TYPE (INVOICE,CASH RECEIPTS,
      * ADJUSTMENT, OR CREDIT MEMO).  ACCUMULATE A/R RECORDS.
      *
     C     TYPE          BEGSR
      *
     C     ARTTYP        IFEQ      01                                           INVOICE TYPE
     C                   ADD       1             CINV              5 0          ACCUM # INV
     C                   MOVEL     'Inv'         TYP               3
     C                   GOTO      SKIP
     C                   ENDIF
     C     ARTTYP        IFEQ      02                                           CASH RECEIPT
     C     ARTTYP        OREQ      03                                           CASH RECEIPT
     C     ARTTYP        OREQ      08                                           CASH RECEIPT
     C                   ADD       1             CCAS              5 0
     C                   MOVEL     'Pmt'         TYP               3
     C                   GOTO      SKIP
     C                   ENDIF
     C     ARTTYP        IFEQ      04                                           ADJUSTMENT
     C                   ADD       1             CADJ              5 0
     C                   MOVEL     'Adj'         TYP               3
     C                   GOTO      SKIP
     C                   ENDIF
     C     ARTTYP        IFEQ      05                                           CREDIT MEMO
     C                   ADD       1             CCRM              5 0
     C                   MOVEL     'Crm'         TYP               3
     C                   GOTO      SKIP
     C                   ENDIF
     C     ARTTYP        IFEQ      07                                           LATE CHARGE TYP
     C                   ADD       1             CLC               5 0          ACCUM L/C
     C                   MOVEL     'L/C'         TYP               3
     C                   GOTO      SKIP
     C                   ENDIF
     C     ARTTYP        IFEQ      09                                           DISCOUNTS
     C                   MOVEL     'Dis'         TYP               3
     C                   ADD       1             CDIS              5 0          ACCUM DISC
     C                   ENDIF
     C     ARTTYP        IFEQ      10                                           CASH RECEIPT
     C                   ADD       1             CCAS              5 0
     C                   MOVEL     'CrC'         TYP               3
     C                   GOTO      SKIP
     C                   ENDIF
     C     ARTTYP        IFEQ      11                                           CASH RECEIPT
     C                   ADD       1             CCAS              5 0
     C                   MOVEL     'Dep'         TYP               3
     C                   GOTO      SKIP
     C                   ENDIF
     C     ARTTYP        IFEQ      12                                           CASH RECEIPT
     C                   ADD       1             CNSF              5 0
     C                   MOVEL     'NSF'         TYP               3
     C                   GOTO      SKIP
     C                   ENDIF
     C     ARTTYP        IFEQ      14                                           CASH RECEIPT
     C                   ADD       1             CCHC              5 0
     C                   MOVEL     'ChC'         TYP               3
     C                   GOTO      SKIP
     C                   ENDIF
      *
     C     SKIP          TAG
      *
      * IF INV, CM, LC, OR OA, CHECK IF A/R CUST# = SHIP TO CUST#.
      * IF NOT EQUAL, CHAIN TO MCUST WITH SHIP TO # FOR COMPANY NAME   .
      *
     C                   MOVE      *BLANKS       SHPNM
     C     ARSHCU        IFEQ      0
     C                   GOTO      NOSHIP
     C                   ENDIF
      *
     C     ARCUST        IFNE      ARSHCU
     C     ARSHCU        CHAIN     FMCUST                             98
     C                   MOVEL     CMNAME        SHPNM            20
     C                   ENDIF
      *
     C     NOSHIP        TAG
      *
     C                   ADD       1             CREC              5 0          ACCUM # RECS
     C                   ADD       AR$AMT        TARDUE           11 2          TOTAL BAL DUE
     C                   ADD       AR$AMT        CARDUT           11 2
     C                   ENDSR
      *********
      * AGING
      *********
      *  DETERMINE APPROPRIATE AGING BUCKET FOR REPORT
     C     AGING         BEGSR
     C                   SETON                                        18
      *
     C     *LIKE         DEFINE    AR$AMT        #WKAR$
     C                   Z-ADD     AR$AMT        #WKAR$
     C                   EXSR      #AGDL
     C                   ADD       #PP           SCUR             11 2
     C                   ADD       #PP$          SAR
      *
      *  CHECK IF PRINTING ONLY OVER CERTAIN AGING DAYS
      *
     C     LDAYS         IFNE      *ZEROS
     C     #WKTRR        ANDLT     *ZEROS
     C                   MLLZO     1             #WKTRR
     C                   ENDIF
     C     #WKTRR        IFGE      LDAYS
     C                   SETON                                        18
     C                   ELSE
     C                   SETOFF                                       18
     C                   ENDIF
      *
     C                   ENDSR
      *********
      * #AGDL
      *********
     C     #AGDL         BEGSR
      *
      *  USE THIS SUBROUTINE TO AGE ITEMS
      *      SUBROUTINE ASSUMES ARRAY #FD HAS BEEN LOADED - USE #AGDY
      *      SUBROUTINE ASSUMES FIELD #WKAOJ HAS BEEN LOADED
      *      LOAD DUE DATE INTO FIELD ##MDY
      *      LOAD DOLLAR AMOUNT INTO FIELD #WKAR$
      *
      *      USE FIELD #PP TO PRINT CURRENT DOLLAR AMOUNTS
      *      USE ARRAY #PP$ TO PRINT PAST DUE AMOUNTS 1 - 5
      *      USE FIELD #WKCR$ TO PRINT TOTAL CURRENT DOLLAR AMOUNTS
      *      USE ARRAY #PD$ TO PRINT TOTAL PAST DUE AMOUNTS 1 - 5
      *      USE ARRAY #FD$ TO FUTURE AGE THE CURRENT AMOUNT
      *
     C                   Z-ADD     0             #PP              11 2
     C                   Z-ADD     0             #PP$
     C                   Z-ADD     ARDUDT        ##MDY
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         #WKTRJ            5 0
      *
      * SUBTRACT AS OF DATE (JULIAN) FROM DUE DATE (JULIAN)
      *
     C     #WKTRJ        SUB       #WKAOJ        #WKTRJ
     C                   Z-ADD     #WKTRJ        #WKTRR            5 0
      *
      * ACCUMULATE FOR TOTAL BALANCE
      *
     C                   ADD       #WKAR$        #WKAT$           11 2
      *
      * TEST DATE RELATIVE TO AGING DAYS - POSITIVE = FUTURE DUE
      *                                    NEGATIVE = PAST DUE
      *
     C     #WKTRJ        IFGE      0
      *
      * ACCUMULATE CURRENT AMOUNTS AND AGE FUTURE DUE
      *
     C                   ADD       #WKAR$        #WKCR$           11 2
     C                   ADD       #WKAR$        #PP
     C                   Z-ADD     1             X                 1 0
     C     #WKTRJ        LOOKUP    #FD(X)                             90  90
     C   90              ADD       #WKAR$        #FD$(X)
     C  N90              ADD       #WKAR$        #FD$(5)
     C                   ELSE
      *
      * AGE PAST DUE AMOUNTS
      *
     C                   MLLZO     1             #WKTRJ
     C                   Z-ADD     1             X
     C     #WKTRJ        LOOKUP    #FD(X)                             90  90
     C   90              ADD       #WKAR$        #PD$(X)
     C  N90              ADD       #WKAR$        #PD$(5)
     C   90              ADD       #WKAR$        #PP$(X)
     C  N90              ADD       #WKAR$        #PP$(5)
      *
     C                   END
      *
     C                   ENDSR
      *                                                                ***
      *********
      * #AGDY
      *********
     C     #AGDY         BEGSR
      *
      * USE THIS SUBROUTINE TO LOAD AGING DAYS PRINT HEADINGS
      *
     C                   Z-ADD     ACAGPY        #WKP1             3 0
     C                   Z-ADD     ACAGP2        #WKP2             3 0
     C                   Z-ADD     ACAGP3        #WKP3             3 0
     C                   Z-ADD     ACAGP4        #WKP4             3 0
     C                   Z-ADD     1             #WKP0             3 0
     C     #WKP1         ADD       1             #WKP1A            3 0
     C     #WKP2         ADD       1             #WKP2A            3 0
     C     #WKP3         ADD       1             #WKP3A            3 0
     C                   Z-ADD     ACAGPY        #FD(1)
     C                   Z-ADD     ACAGP2        #FD(2)
     C                   Z-ADD     ACAGP3        #FD(3)
     C                   Z-ADD     ACAGP4        #FD(4)
      *
      * CONVERT AS OF DATE TO JULIAN DATE
      *
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         #WKAOJ            5 0
      *
     C                   ENDSR
     OARR310    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           56 'Detail A/R'
     O                                           74 'Aging By Customer'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                            8 'Customer'
     O                                           10 '-'
     O                 N19                       14 'All'
     O                  19   LBCUST        Z     17
     O                  19                       20 'To'
     O                  19   LECUST        Z     27
     O                                           61 'Aged As Of:'
     O                       LDATE         Y     70
     O                                          111 'Salesperson -'
     O                 N20                      115 'All'
     O                  20   LBSLSM             114
     O                  20                      117 'To'
     O                  20   LESLSM             120
     O          E            HDG            1
     O                                           59 'Overdue'
     O                 N21                       63 'All'
     O                  21   LDAYS         Z     63
     O                                           68 'Days'
     O          E            HDG            1
     O                                           12 'Customer'
     O                                           32 'Invoice'
     O                                           54 'Trans    Due   Tran'
     O                                           88 '------------------'
     O                                          102 'Days Past Due'
     O                                          121 '------------------'
     O          E            HDG            1
     O                                           14 'Number  Name'
     O                                           29 '#'
     O                                           48 'Date     Date'
     O                                           54 'Type'
     O                                           65 'Current'
     O                       #WKP0         3     72
     O                                           73 '-'
     O                       #WKP1         3     76
     O                       #WKP1A        3     83
     O                                           84 '-'
     O                       #WKP2         3     87
     O                       #WKP2A        3     94
     O                                           95 '-'
     O                       #WKP3         3     98
     O                       #WKP3A        3    105
     O                                          106 '-'
     O                       #WKP4         3    109
     O                                          117 'Over'
     O                       #WKP4         3    121
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL1       1  1
     O                       ARCUST        Z      6
     O                                            7 '-'
     O                       CMNAME              37
     O          E            DETNAM         1
     O                                            8 'Contact:'
     O                       CMCNAM              39
     O          E            DETNAM         1
     O                                            6 'Phone:'
     O                       CMPHON              21 '   -   -    '
     O          E            DETL           1
     O                       SHPNM               20
     O                       ARINV#        Z     30
     O                       ARSUFF              32
     O                       TDAT          Y     41
     O                       DUDT          Y     50
     O                       #PP$(5)       M    121
     O                       #PP$(4)       M    110
     O                       #PP$(3)       M     99
     O                       #PP$(2)       M     88
     O                       #PP$(1)       M     77
     O                       #PP           M     66
     O                       TYP                 54
     O          E            TL1            1
     O                                           65 '---------'
     O                                           76 '---------'
     O                                           87 '---------'
     O                                           98 '---------'
     O                                          109 '---------'
     O                                          120 '---------'
     O          E            TL1            1
     O                       SAR(5)        MB   121
     O                       SAR(4)        MB   110
     O                       SAR(3)        MB    99
     O                       SAR(2)        MB    88
     O                       SAR(1)        MB    77
     O                       SCUR          MB    66
     O          E            TL1            1
     O               30                          13 'Credit Limit:'
     O               30      CMCRL$        M     27
     O               88                          51 '** Over Credit Limit **'
     O                       CNAME          B    85
     O                       TARDUE        JB   118
     O                                          120 '**'
     O                                          105 'Total Balance Due:'
     O          E            TLR            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            TLR            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                       TIMOD              120 '  :  :  '
     O                                           61 'Aged As Of:'
     O                       LDATE         Y     70
     O          E            TLR            1
     O                                           53 'Customer'
     O                                           58 '-'
     O                 N19                       62 'All'
     O                  19   LBCUST        Z     65
     O                  19                       68 'To'
     O                  19   LECUST        Z     75
     O          E            TLR            1
     O                                           58 'Salesperson -'
     O                 N20                       62 'All'
     O                  20   LBSLSM              62
     O                  20                       65 'To'
     O                  20   LESLSM              68
     O          E            TLR            3
     O                                           52 'Overdue'
     O                 N21                       56 'All'
     O                  21   LDAYS         Z     56
     O                                           61 'Days'
     O          E            TLR            1
     O                                           61 'Grand Totals For'
     O                                           81 'Accounts Receivable'
     O          E            TLR            3
     O                                           63 '___________________'
     O                                           82 '___________________'
     O          E            TLR            1
     O                                           70 'Record Counts'
     O          E            TLR            2
     O                                           71 '_______________'
     O          E            TLR            1
     O                       CCUST         3     73
     O                                           63 'Customers......'
     O          E            TLR            1
     O                       CINV          3     73
     O                                           63 'Invoices.......'
     O          E            TLR            1
     O                       CCAS          3     73
     O                                           63 'Cash Receipts..'
     O          E            TLR            1
     O                       CADJ          3     73
     O                                           63 'Adjustments....'
     O          E            TLR            1
     O                       CCRM          3     73
     O                                           63 'Credit Memos...'
     O          E            TLR            1
     O                       CLC           3     73
     O                                           63 'Late Charges...'
     O          E            TLR            1
     O                       CNSF          3     73
     O                                           63 'Returned Checks'
     O          E            TLR            1
     O                       CCHC          3     73
     O                                           63 'Ret Check Chrg.'
     O          E            TLR            2
     O                       CDIS          3     73
     O                                           63 'Discounts......'
     O          E            TLR            3
     O                       CREC          3     73
     O                                           63 'Total Records..'
     O          E            TLR         2  1
     O                                           68 'A/R Balances'
     O          E            TLR            2
     O                                           68 '____________'
     O          E            TLR            1
     O                                           55 'Current'
     O                       #WKCR$        JB    74
     O          E            TLR            1
     O                       #WKP0         3     51
     O                                           52 '-'
     O                       #WKP1         3     55
     O                       #PD$(1)       JB    74
     O          E            TLR            1
     O                       #WKP1A        3     51
     O                                           52 '-'
     O                       #WKP2         3     55
     O                       #PD$(2)       JB    74
     O          E            TLR            1
     O                       #WKP2A        3     51
     O                                           52 '-'
     O                       #WKP3         3     55
     O                       #PD$(3)       JB    74
     O          E            TLR            1
     O                       #WKP3A        3     51
     O                                           52 '-'
     O                       #WKP4         3     55
     O                       #PD$(4)       JB    74
     O          E            TLR            2
     O                                           51 'Over'
     O                       #WKP4         3     55
     O                       #PD$(5)       JB    74
     O          E            TLR            3
     O                                           56 'Total A/R'
     O                       CARDUT        JB    74
     O                                           78 '***'
     O          E            TLR            1
     O                                           64 'Future Aging Of'
     O                                           79 'Current Amount'
     O          E            TLR            2
     O                                           64 '_______________'
     O                                           79 '_______________'
     O          E            TLR            1
     O                       #WKP0         3     51
     O                                           52 '-'
     O                       #WKP1         3     55
     O                       #FD$(1)       JB    74
     O          E            TLR            1
     O                       #WKP1A        3     51
     O                                           52 '-'
     O                       #WKP2         3     55
     O                       #FD$(2)       JB    74
     O          E            TLR            1
     O                       #WKP2A        3     51
     O                                           52 '-'
     O                       #WKP3         3     55
     O                       #FD$(3)       JB    74
     O          E            TLR            1
     O                       #WKP3A        3     51
     O                                           52 '-'
     O                       #WKP4         3     55
     O                       #FD$(4)       JB    74
     O          E            TLR            2
     O                                           51 'Over'
     O                       #WKP4         3     55
     O                       #FD$(5)       JB    74
      *                                                                ***@DT@B2
     O          E            TLRN           1
     O                                           55 '**** There Are No Transa'
     O                                           78 'ctions For The Report S'
     O                                           92 'elections ****'
      **                                                               ***@DT@B2
