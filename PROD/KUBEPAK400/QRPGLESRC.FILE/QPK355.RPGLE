      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC. 2000
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
      *PROGRAM NAME-------- QPK350
      *SYSTEM-------------- SALES ANALYSIS
      *DESCRIPTION--------- SALES ANALYSIS BY PRODUCT CLASS SELECTED
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 11/03/00 EFD ADD LOGIC FOR SEL CUST # AND TYPE RANGE
      *
      *
     FFSOHSCIP  IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FQPK355    O    F  120        PRINTER OFLIND(*INOF)
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
     D  LBPC                  11     12
     D  LEPC                  13     14
     D  BDATE                 15     21  0
     D  EDATE                 22     28  0
     D  CUSTNO                29     34  0
     D  BEGTYP                35     36
     D  ENDTYP                37     38
     D  LBDATE                39     44  0
     D  LEDATE                45     50  0
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
     C     LCO           CHAIN     FMCORG                             88
     C                   Z-ADD     1             CCNT              4 0          CUST
     C                   Z-ADD     1             PCCNT             4 0          P/C
     C                   Z-ADD     1             ICNT              4 0          ITEM
     C                   Z-ADD     1             FIRST             6 0
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       77
     C                   READ      FSOHSCIP                               90
     C   90              GOTO      END
      *
     C     CUSTNO        IFGT      0
     C     SOCUST        ANDNE     CUSTNO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SOCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SOPCL1        IFLT      LBPC
     C     SOPCL1        ORGT      LEPC
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SOSHDT        IFLT      BDATE
     C     SOSHDT        ORGT      EDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   SETOFF                                       9166
     C     SOCUST        CHAIN     FMCUST                             91
     C   91              SETON                                        66
      *
     C     BEGTYP        IFGT      *BLANKS
     C     CMCTYP        IFLT      BEGTYP
     C     CMCTYP        ORGT      ENDTYP
     C                   GOTO      NXT
     C                   ENDIF
     C                   END
      *
     C     CCNT          IFEQ      1
     C*                  EXCEPT    DETC
     C                   ENDIF
      *
      * ITEM TOTALS
      *
     C     FIRST         IFNE      1
     C     ICNT          ANDGT     1
     C     CCNT          ANDGT     1
     C     SOITEM        ANDNE     OLITEM
     C     SOSIZE        ORNE      OLSIZE
     C     FIRST         ANDNE     1
     C*                  EXCEPT    TL1
     C                   Z-ADD     1             ICNT
     C                   ENDIF
      *
      * PRODUCT CLASS TOTALS
      *
     C     FIRST         IFNE      1
     C     PCCNT         ANDGT     1
     C     SOPCL1        ANDNE     OLPC
     C     SOCUST        ORNE      OLCUST
     C     FIRST         ANDNE     1
     C     OLPC          CHAIN     FMPRCL                             92
     C   92              SETON                                        78
     C                   EXCEPT    TL2
     C                   Z-ADD     1             PCCNT
     C                   ENDIF
      *
      * CUSTOMER TOTALS
      *
     C     FIRST         IFNE      1
     C     CCNT          ANDGT     1
     C     SOCUST        ANDNE     OLCUST
     C*                  EXCEPT    TL3
?    C*                  EXCEPT    DETC
     C*                    Z-ADD1         CCNT
     C                   ENDIF
      *
      * ITEM TOTALS
      *
     C                   ADD       SOQSHP        TL1QTY            6 0
     C                   ADD       SOEXT$        TL1AMT            9 2
      *
      * PRODUCT CLASS TOTALS
      *
     C                   ADD       SOQSHP        TL2QTY            6 0
     C                   ADD       SOEXT$        TL2AMT            9 2
      *
      * CUSTOMER TOTALS
      *
     C                   ADD       SOQSHP        TL3QTY            6 0
     C                   ADD       SOEXT$        TL3AMT            9 2
      *
      * REPORT TOTALS
      *
     C                   ADD       SOQSHP        TLRQTY            6 0
     C                   ADD       SOEXT$        TLRAMT            9 2
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
      *
     C                   ADD       1             FIRST
     C                   ADD       1             PCCNT
     C                   ADD       1             CCNT
     C                   ADD       1             ICNT
      *
     C                   MOVEL     SOPCL1        OLPC              2
     C                   MOVEL     SOITEM        OLITEM           12
     C                   MOVEL     SOSIZE        OLSIZE            3
     C                   MOVEL     SODES1        OLDESC           30
     C                   MOVEL     SOUUOM        OLUOM             2
     C                   Z-ADD     SOCUST        OLCUST            6 0
     C                   GOTO      NXT
      *
     C     END           TAG
     C     ICNT          IFGT      1
     C*                  EXCEPT    TL1
     C                   ENDIF
     C     PCCNT         IFGT      1
     C     OLPC          CHAIN     FMPRCL                             92
     C   92              SETON                                        78
     C                   EXCEPT    TL2
     C                   ENDIF
     C     CCNT          IFGT      1
     C*                  EXCEPT    TL3
     C                   ENDIF
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *
     OQPK355    E            HDG            1 03
     O                       PROGID              10
     O                                           19 'Req by:'
     O                       USERID              30
     O                       RGNAMC              55
     O*                                  65 'Company:'                    APR500
     O*                        LCO       98                               APR500
     O                       PAGE          1     80
     O                                           76 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           42 'Unit S/A By Customer'
     O                                           58 '& Product Class'
     O                       TIMOD               80 '  :  :  '
     O          E            HDG            1
     O                                           37 'For Dates:'
     O                       LBDATE        Y     46
     O                                           48 '-'
     O                       LEDATE        Y     57
     O          E            HDG            1
     O                                           44 'Product Classes:'
     O                       LBPC                47
     O                                           49 '-'
     O                       LEPC                52
     O          E            HDG            1
     O                                            2 'PR'
     O          E            HDG            1
     O                                            2 'CL'
     O                                           12 'Cust #'
     O                                           27 'Customer Name'
     O                                           52 'Phone'
     O                                           65 'Units'
     O                                           79 'Dollars'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           81 '_________'
     O          EF           TL2            2
     O                       OLPC                 2
     O                       SOCUST        Z     12
     O              N66      CMNAME              43
     O               66                          43 '** Cust Not On File **'
WJB  O              N66      CMPHON              55 '   -   -    '
WJB  O               66                          50 'N/A'
     O                       TL2QTY        JB    65
     O                       TL2AMT        JB    80
     O          EF           TLR            1
     O                                           40 'Report Totals:'
     O                       TLRQTY        JB    65
     O                       TLRAMT        JB    80
