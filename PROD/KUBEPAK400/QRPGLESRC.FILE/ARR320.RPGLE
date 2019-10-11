      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- ARR320
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- A/R AGING BY CUSTOMER SUMMARY REPORT. THIS
      *                     PROGRAM USES THE LDA AREA FROM THE PROMPT
      *                     SCREEN TO DETERMINE AS OF DATE, IF CUSTOME R
      *                     NUMBER RANGE SELECTED, IF SALESPERSON RANG E
      *                     SELECTED AND IF AGING REQUESTED FOR OVER
      *                     A CERTAIN NUMBER OF DAYS.
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFAROPNAL  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFARCTL    IF   E           K DISK
     FARR320    O    F  120        PRINTER OFLIND(*INOF)
      *
     D #PP$            S             11  2 DIM(5)                               PRINT LINE $
     D #PD$            S             11  2 DIM(5)                               PAST DUE $
     D #FD$            S             11  2 DIM(5)                               FUTURE DUE $
     D #FD             S              5  0 DIM(4) ASCEND                        AGING DAYS ARRAY
     D SAR             S             11  2 DIM(5)
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
     D  LCRED                 67     67
     D  LPRTR                100    109
     D  LFORM                110    113
     D  LCOPY                114    115  0
     D  LJOB                 116    116
     D  LHOLD                117    120
     D  LSAVE                121    124
     D  LCANCL               133    133
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
     C     LCO           CHAIN     FMCORG                             97
     C     LCO           CHAIN     FARCTL                             97
      *
     C                   Z-ADD     LDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   EXSR      #AGDY
     C                   Z-ADD     1             CCUST             5 0
     C                   Z-ADD     1             DCUST             5 0
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
     C     LDAYS         IFGT      *ZEROS
     C                   SETON                                        21
     C                   ENDIF
     C     LINCL         IFEQ      'Y'
     C                   SETON                                        22
     C                   ENDIF
     C     LCRED         IFEQ      'Y'
     C                   SETON                                        66
     C                   ELSE
     C                   SETON                                        65
     C                   ENDIF
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       30
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
     C                   Z-ADD     ARDUDT        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ACYMD             5 0
      *
     C  N21              GOTO      NODAY
     C     TCYMD         SUB       ACYMD         DAYS              5 0
     C     DAYS          IFLE      LDAYS
     C                   GOTO      NXT
     C                   ENDIF
     C     NODAY         TAG
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
     C     DCUST         IFEQ      1
     C                   GOTO      NOL1
     C                   ENDIF
      *
     C   65ARCUST        IFNE      OCUST
     C     TARDUE        ANDNE     0
     C     OCUST         CHAIN     FMCUST                             98        CUSTOMER MASTER
     C                   MOVEL     CMNAME        CNAME            20
     C                   EXCEPT    TL1
     C   22              EXCEPT    TLNAM
     C                   ADD       1             CCUST             5 0          ACCUM # CUST
     C                   Z-ADD     1             DCUST
     C                   ENDIF
     C   66ARCUST        IFNE      OCUST
     C     TARDUE        ANDGT     0
     C     OCUST         CHAIN     FMCUST                             98        CUSTOMER MASTER
     C                   MOVEL     CMNAME        CNAME            20
     C                   EXCEPT    TL1
     C   22              EXCEPT    TLNAM
     C                   ADD       1             CCUST             5 0          ACCUM # CUST
     C                   Z-ADD     1             DCUST
     C                   ENDIF
     C     ARCUST        IFNE      OCUST
     C                   Z-ADD     0             TARDUE
     C                   Z-ADD     0             SAR
     C                   Z-ADD     0             SAR(1)
     C                   Z-ADD     0             SAR(2)
     C                   Z-ADD     0             SAR(3)
     C                   Z-ADD     0             SAR(4)
     C                   Z-ADD     0             SAR(5)
     C                   Z-ADD     0             SCUR
     C                   ENDIF
      *
     C     NOL1          TAG
      *
     C                   Z-ADD     ARCUST        OCUST             6 0
EFD  C                   ADD       AR$AMT        TARDUE           11 2          TOTAL BAL DUE
EFD  C                   ADD       AR$AMT        CARDUT           11 2
      *
     C                   EXSR      TYPE
     C                   EXSR      AGING
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C                   ADD       1             DCUST
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C     TARDUE        IFNE      0
     C     OCUST         CHAIN     FMCUST                             98        CUSTOMER MASTER
     C                   MOVEL     CMNAME        CNAME            20
     C                   EXCEPT    TL1
     C   22              EXCEPT    TLNAM
     C                   ENDIF
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *
      *********
      * TYPE
      *********
      * DETERMINE A/R TYPE (INVOICE,CASH RECEIPTS,
      * ADJUSTMENT, OR CREDIT MEMO).  ACCUMULATE A/R RECORDS.
      *
     C     TYPE          BEGSR
      *
     C     ARTTYP        IFEQ      01                                           INVOICE TYPE
     C                   ADD       1             CINV              5 0          ACCUM # INV
     C                   GOTO      SKIP
     C                   ENDIF
     C     ARTTYP        IFEQ      02                                           CASH RECEIPT
     C     ARTTYP        OREQ      03                                           CASH RECEIPT
     C     ARTTYP        OREQ      08                                           CASH RECEIPT
     C                   ADD       1             CCAS              5 0
     C                   GOTO      SKIP
     C                   ENDIF
     C     ARTTYP        IFEQ      04                                           ADJUSTMENT
     C                   ADD       1             CADJ              5 0
     C                   GOTO      SKIP
     C                   ENDIF
     C     ARTTYP        IFEQ      05                                           CREDIT MEMO
     C                   ADD       1             CCRM              5 0
     C                   GOTO      SKIP
     C                   ENDIF
     C     ARTTYP        IFEQ      07                                           LATE CHARGE TYP
     C                   ADD       1             CLC               5 0          ACCUM L/C
     C                   GOTO      SKIP
     C                   ENDIF
     C     ARTTYP        IFEQ      09                                           DISCOUNTS
     C                   ADD       1             CDIS              5 0          ACCUM DISC
     C                   ENDIF
     C     SKIP          TAG
      *
     C                   ADD       1             CREC              5 0          ACCUM # RECS
     C*                    ADD  AR$AMT    TARDUE 112       TOTAL BAL DUE
     C*                    ADD  AR$AMT    CARDUT 112
     C                   ENDSR
      *********
      * AGING
      *********
      *  DETERMINE APPROPRIATE AGING BUCKET FOR REPORT.
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
      *       USE FIELD #PP TO PRINT CURRENT DOLLAR AMOUNTS
      *       USE ARRAY #PP$ TO PRINT PAST DUE AMOUNTS 1 - 5
      *       USE FIELD #WKCR$ TO PRINT TOTAL CURRENT DOLLAR AMOUNTS
      *       USE ARRAY #PD$ TO PRINT TOTAL PAST DUE AMOUNTS 1 - 5
      *       USE ARRAY #FD$ TO FUTURE AGE THE CURRENT AMOUNT
      *
     C                   Z-ADD     0             #PP              11 2
     C                   Z-ADD     *ZEROS        #PP$
     C                   Z-ADD     ARDUDT        ##MDY
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         #WKTRJ            5 0
      *
      *  SUBTRACT AS OF DATE (JULIAN) FROM DUE DATE (JULIAN)
      *
     C     #WKTRJ        SUB       #WKAOJ        #WKTRJ
     C                   Z-ADD     #WKTRJ        #WKTRR            5 0
      *
      *  ACCUMULATE FOR TOTAL BALANCE
     C                   ADD       #WKAR$        #WKAT$           11 2
      *
      *  TEST DATE RELATIVE TO AGING DAYS - POSITIVE = FUTURE DUE
      *                                     NEGATIVE = PAST DUE
      *
     C     #WKTRJ        IFGE      0
      *
      *  ACCUMULATE CURRENT AMOUNTS AND AGE FUTURE DUE
      *
     C                   ADD       #WKAR$        #WKCR$           11 2
     C                   ADD       #WKAR$        #PP
     C                   Z-ADD     1             X                 1 0
     C     #WKTRJ        LOOKUP    #FD(X)                             90  90
     C   90              ADD       #WKAR$        #FD$(X)
     C  N90              ADD       #WKAR$        #FD$(5)
     C                   ELSE
      *
      *  AGE PAST DUE AMOUNTS
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
      * LOAD "AS OF DATE" INTO FIELD ##MDY
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
     OARR320    E            HDG            1 03
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
     O                                           55 'Summary A/R'
     O                                           73 'Aging By Customer'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           61 'Aged As Of:'
     O                       LDATE         Y     70
     O          E            HDG            1
     O                                            8 'Customer'
     O                                           10 '-'
     O                 N19                       14 'All'
     O                  19   LBCUST        Z     17
     O                  19                       20 'To'
     O                  19   LECUST        Z     27
     O                                           59 'Overdue'
     O                 N21                       63 'All'
     O                  21   LDAYS         Z     63
     O                                           68 'Days'
     O                                          111 'Salesperson -'
     O                 N20                      115 'All'
     O                  20   LBSLSM             114
     O                  20                      117 'To'
     O                  20   LESLSM             120
     O          E            HDG            1
     O                                           12 'Customer'
     O                                           62 '-------------------'
     O                                           72 '----------'
     O                                           80 'Days Past Due'
     O                                          104 '-----------------------'
     O          E            HDG            1
     O                                           13 'Number  Name'
     O                                           39 'Current'
     O                       #WKP0         3     48
     O                                           49 '-'
     O                       #WKP1         3     52
     O                       #WKP1A        3     61
     O                                           62 '-'
     O                       #WKP2         3     65
     O                       #WKP2A        3     74
     O                                           75 '-'
     O                       #WKP3         3     78
     O                       #WKP3A        3     87
     O                                           88 '-'
     O                       #WKP4         3     91
     O                                          100 'Over'
     O                       #WKP4         3    104
     O                                          117 'Total Due'
     O          E            HDG            2
     O                                           24 '------------------------'
     O                                           48 '------------------------'
     O                                           72 '------------------------'
     O                                           96 '------------------------'
     O                                          120 '------------------------'
     O          E            TL1            1
     O                       OCUST         Z      6
     O                       CNAME          B    27
     O                       TARDUE        JB   118
     O                       SAR(5)        MB   105
     O                       SAR(4)        MB    92
     O                       SAR(3)        MB    79
     O                       SAR(2)        MB    66
     O                       SAR(1)        MB    53
     O                       SCUR          MB    40
     O                                          120 '*'
     O          E            TLNAM          1
     O                                            8 'Contact:'
     O                       CMCNAM              39
     O          E            TLNAM          1
     O                                            6 'Phone:'
     O                       CMPHON              21 '   -   -    '
     O          E            TLR            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            TLR            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           61 'Aged As Of:'
     O                       LDATE         Y     70
     O                       TIMOD              120 '  :  :  '
     O          E            TLR            1
     O                                           53 'Customer'
     O                 N19                       60 'All'
     O                  19   LBCUST        Z     65
     O                  19                       68 'To'
     O                  19   LECUST        Z     75
     O          E            TLR            1
     O                                           58 'Salesperson -'
     O                 N20                       60 'All'
     O                  20   LBSLSM              63
     O                  20                       68 'To'
     O                  20   LESLSM              73
     O          E            TLR            3
     O                                           52 'Overdue'
     O                 N21                       56 'All'
     O                  21   LDAYS         Z     56
     O                                           61 'Days'
     O          E            TLR            1
     O                                           61 'Grand Totals For'
     O                                           81 'Accounts Receivable'
     O          E            TLR            3
     O                                           63 '-------------------'
     O                                           82 '-------------------'
     O          E            TLR            1
     O                                           67 'Record Counts'
     O          E            TLR            2
     O                                           68 '--------------'
     O          E            TLR            1
     O                       CCUST         3     57
     O                                           67 'Customers'
     O          E            TLR            1
     O                       CINV          3     57
     O                                           66 'Invoices'
     O          E            TLR            1
     O                       CCAS          3     57
     O                                           71 'Cash Receipts'
     O          E            TLR            1
     O                       CADJ          3     57
     O                                           69 'Adjustments'
     O          E            TLR            1
     O                       CCRM          3     57
     O                                           71 'Credit Memo''s'
     O          E            TLR            1
     O                       CLC           3     57
     O                                           70 'Late Charges'
     O          E            TLR            2
     O                       CDIS          3     57
     O                                           67 'Discounts'
     O          E            TLR            3
     O                       CREC          3     57
     O                                           71 'Total Records'
     O          E            TLR            3
     O*                                  59 'Total A/R'
     O*                        #WKAT$J   76
     O*                                  80 '***'
     O          E            TLR         2  1
     O                                           68 'A/R Balances'
     O          E            TLR            2
     O                                           68 '------------'
     O          E            TLR            1
     O                                           63 'Current'
     O                       #WKCR$        JB    82
     O          E            TLR            1
     O                       #WKP0         3     59
     O                                           60 '-'
     O                       #WKP1         3     63
     O                       #PD$(1)       JB    82
     O          E            TLR            1
     O                       #WKP1A        3     59
     O                                           60 '-'
     O                       #WKP2         3     63
     O                       #PD$(2)       JB    82
     O          E            TLR            1
     O                       #WKP2A        3     59
     O                                           60 '-'
     O                       #WKP3         3     63
     O                       #PD$(3)       JB    82
     O          E            TLR            1
     O                       #WKP3A        3     59
     O                                           60 '-'
     O                       #WKP4         3     63
     O                       #PD$(4)       JB    82
     O          E            TLR            2
     O                                           59 'Over'
     O                       #WKP4         3     63
     O                       #PD$(5)       JB    82
     O          E            TLR            3
     O                                           65 'Total A/R'
     O                       CARDUT        JB    82
     O                                           86 '***'
     O          E            TLR            1
     O                                           64 'Future Aging Of'
     O                                           79 'Current Amount'
     O          E            TLR            2
     O                                           64 '_______________'
     O                                           79 '_______________'
     O          E            TLR            1
     O                       #WKP0         3     59
     O                                           60 '-'
     O                       #WKP1         3     63
     O                       #FD$(1)       JB    82
     O          E            TLR            1
     O                       #WKP1A        3     59
     O                                           60 '-'
     O                       #WKP2         3     63
     O                       #FD$(2)       JB    82
     O          E            TLR            1
     O                       #WKP2A        3     59
     O                                           60 '-'
     O                       #WKP3         3     63
     O                       #FD$(3)       JB    82
     O          E            TLR            1
     O                       #WKP3A        3     59
     O                                           60 '-'
     O                       #WKP4         3     63
     O                       #FD$(4)       JB    82
     O          E            TLR            2
     O                                           59 'Over'
     O                       #WKP4         3     63
     O                       #FD$(5)       JB    82
      **
