      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1996
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
      **PROGRAM NAME-------- ARR370
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **APPLICATION--------- EXCEEDED CREDIT LIMIT
      **DESCRIPTION--------- PRINTS WITH INVOICES
      **                     ONLY FOR CURRENT INVOICE CUSTOMERS
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCUST    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFHORDW    IF   E           K DISK
     FARR371    O    F  132        PRINTER OFLIND(*INOF)
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
      *
      ****************
      *   LDA        *
      ****************
     D                UDS
      ** COMPANY
     D  LDACOP                 1      2  0
      ** REPRINT Y/N
     D  LDARPT                 3      3
      ** JOBQ Y/N
     D  LDAJBQ                 4      4
      ** ROUTE I.D.
     D  LDARTE                 5      6
      ** ROUTE ALL
     D  LDAALL                 7      9
      ** BEGINING INVOICE NUMBER (REPRINT)
     D  LBINV                 10     15  0
      ** ENDING INVOICE NUMBER (REPRINT)
     D  LEINV                 16     21  0
      ** FORM NUMBER
     D**                                     22  30 LFORM
      ** PRINTER I.D.
     D  LPRTR                 31     40
      ** INVOICE DATE
     D  LDATE                 41     46  0
      ** SHIP FROM LOCATION
     D  LSHFR                 47     49
      ** BEGINING ORDER NUMBER
     D  LBORD                 50     55  0
      ** ENDING ORDER NUMBER
     D  LEORD                 56     61  0
      ** CANCEL  X=CANCEL
     D  LCANCL                62     62
      ** POINT OF SALE INVOICE Y/N
     D  LPOS                  63     63
      ** IMMEDIATE PRINT  Y/N
     D  LIMED                 64     64
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     01            KEY               2 0
     C     KEY           CHAIN     FMCORG                             88
      *
     C                   SETON                                        OF
      *
     C                   Z-ADD     0             CNT               6 0
     C                   Z-ADD     0             COUNT             6 0
      *
     C     LBINV         SETLL     FHORDW
     C     NXT           TAG
     C                   SETOFF                                       3035
     C                   READ      FHORDW                                 90
     C   90              GOTO      END
     C     WHINV#        IFGT      LEINV
     C                   GOTO      END
     C                   END
     C     WHBLCU        CHAIN     FMCUST                             91
      *
      * CREDIT LIMIT = ZERO
      *
     C     CMTMCD        IFEQ      '02'
     C                   GOTO      NOCHK
     C                   ENDIF
      *
     C     CMCRL$        IFEQ      *ZEROS
     C                   GOTO      NXT
     C                   ENDIF
     C     NOCHK         TAG
      *
      * ADD A/R DUE TO VALUE OF OPEN ORDERS
      *
     C     WH$AMT        ADD       CMARB$        TOTAL             9 2
      *
     C     TOTAL         SUB       CMCRL$        CUSTOL            9 2
      *
     C     CMCNAM        IFGT      *BLANKS
     C                   SETON                                        30
     C                   ENDIF
      *
     C     CMPHON        IFGT      *ZEROS
     C                   SETON                                        35
     C                   ENDIF
      *
     C     TOTAL         IFGT      CMCRL$
     C   OF              DO
     C                   EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   ADD       1             COUNT
     C                   ENDDO
     C                   Add       CMARB$        LR_TOTAR         11 2           Total A/R Bal.   LR
     C                   Add       CUSTOL        LR_TOTOL         11 2           Total Over Limit LR
     C                   Add       CMVOPO        LR_TOTVO          9 2           Total Val Orders LR
     C                   EXCEPT    TL1
     C   30
     CAN 35              EXCEPT    TL1P
     C                   ADD       1             CUSCTR            6 0
     C                   ENDIF
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C     COUNT         IFGT      0
     C                   EXCEPT    TLR
     C                   END
     C                   SETON                                        LR
      *
     OARR371    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                          114 'Page'
     O                       PAGE          1    120
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           62 'Exceeded Credit Limit'
     O                                           81 ' - Todays Invoices'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                            9 'Customer'
     O                                           80 'Total A/R'
     O                                           93 'Credit'
     O                                          106 'Exceeded'
     O                                          120 'Value of'
     O          E            HDG            1
     O                                            8 'Number'
     O                                           28 'N   A   M   E'
     O                                           60 'A/R Name and Telephone'
     O                                           71 'Terms'
     O                                           80 'Balance'
     O                                           93 'Limit'
     O                                          106 'Limit By'
     O                                          120 'Orders'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            TL1            1
     O                       CUSTOL        LB   106
     O                       CMCRL$        L     96
     O                       CMVOPO        L    120
     O                       CMARB$        LB    81
     O                       CMARCU        Z      6
     O                       CMNAME              37
     O               30      CMCNAM              68
     O              N30 35   CMPHON              50 '   -   -    '
     O                       CMTMCD              71
     O          E            TL1P           1
     O                       CMPHON              50 '   -   -    '
     O          E            TLR         0  1
     O                                           81 '============'
     O                                          106 '============'
     O                                          120 '=========='
     O          E            TLR         0  1
     O                                           35 'Totals ===>'
     O                       LR_TOTAR      L     81
     O                       LR_TOTOL      L    106
     O                       LR_TOTVO      L    120
     O          E            TLR         2  1
     O                                           16 'Number of Custo'
     O                                           33 'mers Exceeding Cr'
     O                                           48 'edit Limit ===>'
     O                       CUSCTR        Z     54
