      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.      ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- BIR375
      **APPLICATION--------- ORDER ENTRY
      **DESCRIPTION--------- OPEN ORDERS LISTED BY ITEM
      *
      *
      *       CHANGE--DATE-------DESCRIPTION
      *
      *
     FFIORDISC  IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FBIR375    O    F  120        PRINTER OFLIND(*INOF)
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
     D  LBITEM                 3     14
     D  LEITEM                15     26
     D  LBSIZE                27     29
     D  LESIZE                30     32
     D  LBEGDT                33     37  0
     D  LENDDT                38     42  0
     D  LBSHFR                43     45
     D  LESHFR                46     48
     D  LBDATE                49     54  0
     D  LEDATE                55     60  0
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
     C*
     C   OF              SETON                                        OF
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     1             ORD
      *
     C     LBITEM        IFGT      *BLANKS
     C                   SETON                                        60
     C                   ENDIF
      *
     C     LBSIZE        IFGT      *BLANKS
     C                   SETON                                        61
     C                   ENDIF
      *
     C     LBDATE        IFGT      0
     C                   SETON                                        62
     C                   ENDIF
      *
     C     LBSHFR        IFGT      *BLANKS
     C     LESHFR        ORGT      *BLANKS
     C                   SETON                                        63
     C                   ENDIF
      *
     C   60
     COR 61
     COR 62
     COR 63              SETON                                        66
      *
     C     LCO           CHAIN(N)  FMCORG                             90
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
      *
     C                   READ      RIORDR                                 77
     C   77              GOTO      END
      *
      * ACTIVE ORDER
      *
     C     OISTAT        IFEQ      'D'
     C     OIDTRQ        OREQ      0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   60OIITEM        IFLT      LBITEM
     C     OIITEM        ORGT      LEITEM
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   61OISIZE        IFLT      LBSIZE
     C     OISIZE        ORGT      LESIZE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LBEGDT        IFEQ      0
     C                   GOTO      NODT
     C                   ENDIF
      *
     C                   Z-ADD     OIDTRQ        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ODATE             5 0
      *
     C     ODATE         IFLT      LBEGDT
     C     ODATE         ORGT      LENDDT
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     NODT          TAG
      *
      * CHECK SHIP FROM RANGE
      *
     C   63OISHFR        IFLT      LBSHFR
     C     OISHFR        ORGT      LESHFR
     C                   GOTO      NXT
     C                   ENDIF
      *
      *  CHECK FOR ORDER TOTALS
      *
     C   55OIITEM        IFGT      SAVITM
     C                   Z-ADD     1             ORD
     C                   EXCEPT    TL1
     C                   SETOFF                                       55
     C                   ENDIF
      *
      *   CHECK IF ORDER HEADER RECORD EXISTS, IF NOT, DO NOT PRINT
      *
     C     OIORD#        CHAIN     FHORDR                             11
      *
      * CHECK IF THIS IS A QUOTE, IF SO, DO NOT PRINT
      *
     C     OHQUOT        IFEQ      'Y'
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK IF CLOSED ORDER OR DELETED ORDER, IF SO, DO NOT PRINT
      *
     C     OHCOFL        IFEQ      'Y'
     C     OHSTAT        OREQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK IF QTY SHIPPED >= QTY ORDERED, DO NOT PRINT
      *
     C     OIQSHP        IFGE      OIQORD
     C                   GOTO      NXT
     C                   ENDIF
      *
      * GET SALESPERSON
      *
      *  CHECK TO SEE IF COMMENT, FRT CHARGE OR SPECIAL CHARGE
      *
     C     OIITYP        IFEQ      'C'
     C     OIITYP        OREQ      'F'
     C     OIITYP        OREQ      'S'
     C                   GOTO      NXT
     C                   ENDIF
     C     OISEQ#        IFGT      989
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     KEY18         KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     KEY18         CHAIN     FMINVT                             50
      *
     C     OIITYP        IFEQ      ' '
     C                   EXSR      GETDES
     C                   ELSE
     C                   MOVEL     OIDES1        DESC
     C                   ENDIF
      *
      * ACCUMULATE ORDER TOTAL AND FINAL TOTAL
      *
     C                   ADD       OIQSHP        TOTSHP           11 1
     C                   ADD       OIQORD        TOTORD           11 1
     C                   ADD       OIQSHP        TLRSHP           11 1
     C                   ADD       OIQORD        TLRORD           11 1
     C     OIQSHP        SUB       OIQORD        QTYOPN           11 1
     C                   ADD       QTYOPN        TOTOPN           11 1
     C                   ADD       QTYOPN        TLROPN           11 1
      *
     C                   MOVEL     OIITEM        SAVITM           12
     C     ORD           IFEQ      1
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   EXCEPT    DTL1
     C                   SETON                                        5588
     C                   ENDIF
     C                   EXCEPT    DTL2
     C                   ADD       1             ORD               3 0
     C                   GOTO      NXT
      *
     C     END           TAG
     C   88ORD           IFGT      1
     C                   EXCEPT    TL1
     C                   ENDIF
     C   88              EXCEPT    TLR
     C  N88              EXCEPT    TLRN
     C                   SETON                                        LR
      *
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
     C                   MOVEL     DESCO         DESC             60
     C                   ENDSR
      *
     OBIR375    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                       PAGE          1    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           69 'Open Orders By Item'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O               62                          20 'Requested Ship Dates'
     O               62      LBDATE        Y     29
     O               62                          31 '-'
     O               62      LEDATE        Y     39
     O               63                          61 'Ship From Range:'
     O               63      LBSHFR              65
     O               63                          67 '-'
     O               63      LESHFR              71
     O               60                          88 'Item Range:'
     O               60      LBITEM             105
     O               60                         107 '-'
     O               60      LEITEM             120
     O              N66                          68 'Selections = ALL'
     O          E            HDG            1
     O               61                          88 'Size Range:'
     O               61      LBSIZE              92
     O               61                          94 '-'
     O               61      LESIZE              98
     O          E            HDG            1
     O                                           15 'Item       Size'
     O                                           49 'Order'
     O                                           56 'Ship'
     O                                           66 'Reqd'
     O                                           78 'Unit'
     O                                          110 '- - - - Quantity - - - -'
     O                                          115 'T'
     O                                          120 'P'
     O          E            HDG            0
     O                                           16 'Ship To Customer'
     O                                           37 'Ord #'
     O                                           49 'Date'
     O                                           41 'Sls'
     O                                           56 'From'
     O                                           67 'Shp Dte'
     O                                           78 'Price'
     O                                           90 'Ord'
     O                                          110 'Open'
     O                                          100 'Shpd'
     O                                          115 'P'
     O                                          120 'H'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DTL1           0
     O                       OIITEM              12
     O                       OISIZE              15
     O                       DESC                76
     O          EF           DTL1           1
     O                                           15 '_______________'
     O          EF           DTL2           1
     O                       OIPHYT         B   120
     O                       OHPOS          B   115
     O                       QTYOPN        4    110
     O                       OIQSHP        4    100
     O                       OIQORD        4     90
     O                       OIUPRI        4     78
     O                       OIDTRQ        Y     67
     O                       OISHFR              56
     O                       OHDTOR        YB    49
     O                       OISLM1              40
     O                       OIORD#        ZB    37
     O                       OHNAME              30
     O          E            TL1            1
     O                                          110 '------'
     O                                          100 '------'
     O                                           90 '------'
     O          E            TL1            2
     O                                           75 'Item Totals:'
     O                       TOTOPN        4B   110
     O                       TOTSHP        4B   100
     O                       TOTORD        4B    90
     O          E            TLR            1
     O                                          110 '======='
     O                                          100 '======='
     O                                           90 '======='
     O          E            TLR            1
     O                                           75 'Report Totals:'
     O                       TLROPN        4B   110
     O                       TLRSHP        4B   100
     O                       TLRORD        4B    90
     O          E            TLRN           1
     O                                           55 '**** There Are No Transa'
     O                                           78 'ctions For The Report S'
     O                                           92 'elections ****'
      *
