      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.   1999
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
      *PROGRAM NAME-------- ARR370
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- EXCEEDED CREDIT LIMIT FOR CURRENT ORDERS
      *DESCRIPTION--------- EXCEEDED CREDIT LIMIT REPORT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  5/16/01 EFD DELETE COL. A/R NAME AND PHONE MOVE OTHER PER BILL
      *  5/24/01 EFD GET TOTAL OF UNPOSTED ARWRK RECORDS.
      *
     FFMCUSTAL  IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFARWRKA   IF   E           K DISK
     FARR370    O    F   85        PRINTER OFLIND(*INOF)
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
     D  LCRED                  3      3  0
     D  LINCL                  4      4  0
     D  LBTERM                 5      6
     D  LETERM                 7      8
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN(N)  FMCORG                             88
      *
     C     LCRED         IFEQ      1
     C                   SETON                                        10
     C                   ELSE
     C                   SETON                                        11
     C                   ENDIF
      *
     C     LINCL         IFEQ      1
     C                   SETON                                        20
     C                   ELSE
     C                   SETON                                        21
     C                   ENDIF
      *
     C     LBTERM        IFGT      *ZEROS
     C                   SETON                                        30
     C                   ENDIF
      *
     C                   EXCEPT    HDG
      *
     C                   Z-ADD     0             CNT               6 0
      *
     C     NXT           TAG
     C                   SETOFF                                       3035
     C                   READ      FMCUSTAL                               90
     C   90              GOTO      END
     C                   MOVEL     CMNAME        NAME             27
      *
      * CREDIT LIMIT = ZERO
      *
     C     CMCRL$        IFEQ      *ZEROS
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK TERMS CODE RANGE
      *
     C   30CMTMCD        IFLT      LBTERM
     C     CMTMCD        ORGT      LETERM
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK IF OPEN ORDERS
      *
     C   20CMVOPO        IFLE      *ZEROS
     C                   GOTO      NXT
     C                   ENDIF
      *
      * ADD A/R DUE TO VALUE OF OPEN ORDERS
      *
     C   11CMARB$        ADD       CMVOPO        TOTAL             9 2
     C   10              Z-ADD     CMARB$        TOTAL
      ** GET UNPOSTED INVOICES
     C                   EXSR      GETUNP
      *
     C     TOTAL         SUB       CMCRL$        CUSTOL            9 2
      *
     C     CMCNAM        IFGT      *BLANKS
     C                   SETON                                        40
     C                   ENDIF
      *
     C     CMPHON        IFGT      *ZEROS
     C                   SETON                                        42
     C                   ENDIF
      *
     C     TOTAL         IFGT      CMCRL$
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
     C                   Add       CMARB$        LR_TOTAR         11 2           Total A/R Bal.   LR
     C                   Add       CUSTOL        LR_TOTOL         11 2           Total Over Limit LR
     C                   Add       CMVOPO        LR_TOTVO          9 2           Total Val Orders LR
     C                   EXCEPT    DETL
     C                   SETON                                        88
     C** 40 42             EXCPTDETL1
     C                   ADD       1             CUSCTR            6 0
     C                   ENDIF
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C   88              EXCEPT    TLR
     C  N88              EXCEPT    TLRN
     C                   SETON                                        LR
      *
      **********************
      * GET UNPOSTED ARWRK *
      **********************
     C     GETUNP        BEGSR
     C                   Z-ADD     0             ARWTOT           11 2
     C     CMCUST        SETLL     FARWRKA
     C     NXTUNP        TAG
     C     CMCUST        READE     FARWRKA                                91
     C  N91              DO
     C                   ADD       AT$AMT        ARWTOT
     C                   GOTO      NXTUNP
     C                   ENDDO
     C                   ADD       ARWTOT        TOTAL
     C                   ADD       ARWTOT        CMARB$
     C                   ENDSR
     OARR370    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              60
     O**                                 95 'Company:'
     O**                       LCO       98
     O                                           75 'Page'
     O                       PAGE          1     80
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           55 'Exceeded Credit Limit'
     O                       TIMOD               80 '  :  :  '
     O          E            HDG            2
     O               20                          23 'Only Customer With Open'
     O               20                          30 'Orders'
     O               21                          13 'All Customers'
     O               30                          43 'Terms Range:'
     O               30      LBTERM              46
     O               30                          48 '-'
     O               30      LETERM              51
     O          E            HDG            1
     O                                            9 'Customer'
     O                                           48 'Total A/R'
     O                                           80 'Value of'
     O                                           59 'Credit'
     O                                           69 'Exceeded'
     O          E            HDG            1
     O                                            8 'Number'
     O**                                 28 'N   A   M   E'
     O**                                 60 'A/R Name and Telephone'
     O                                           38 'Terms'
     O                                           47 'Balance'
     O                                           58 'Limit'
     O                                           69 'Limit By'
     O                                           80 'Orders'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           85 '_____________'
     O**                                120 '________________________'
     O          E            DETL           1
     O                       CMVOPO        L     81
     O                       CUSTOL        LB    70
     O                       CMCRL$        L     59
     O                       CMARB$        LB    48
     O                       CMTMCD              37
     O**               40      CMCNAM    68
     O**              N40 42   CMPHON    50 '   -   -    '
     O                       NAME                34
     O                       CMARCU        Z      6
     O**      E  1             DETL1
     O**                       CMPHON    50 '   -   -    '
     O          E            TLR         0  1
     O                                           48 '============'
     O                                           70 '============'
     O                                           81 '=========='
     O          E            TLR         0  1
     O                                           35 'Totals ===>'
     O                       LR_TOTAR      L     48
     O                       LR_TOTOL      L     70
     O                       LR_TOTVO      L     81
     O          E            TLR         2  1
     O                                           16 'Number of Custo'
     O                                           33 'mers Exceeding Cr'
     O                                           48 'edit Limit ===>'
     O                       CUSCTR        Z     54
     O          E            TLRN           1
     O                                           44 '**** There Are No Transa'
     O                                           67 'ctions For The Report S'
     O                                           81 'elections ****'
