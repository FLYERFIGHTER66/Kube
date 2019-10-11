      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC.   1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.   .  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR405
      *SYSTEM-------------- ORDER ENTRY
      *DESCRIPTION--------- OPEN ORDERS LISTED BY SALESPERSON
      *
      *
      *    CHANGE--DATE-------DESCRIPTION
      *
      *
     FFIORSCOR  IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMSLSM    IF   E           K DISK
     FBIR405    O    F  120        PRINTER OFLIND(*INOF)
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
     D  LBSLS                  3      4
     D  LESLS                  5      6
     D  LBDATE                 7     12  0
     D  LEDATE                13     18  0
     D  LBDAT                 19     23  0
     D  LEDAT                 24     28  0
     D  LBSHFR                29     31
     D  LESHFR                32     34
     D  LINCL                 37     37
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
     C     LBDATE        IFEQ      *ZEROS
     C                   SETON                                        65
     C                   ENDIF
      *
     C     LINCL         IFEQ      'Y'
     C                   SETON                                        20
     C                   ENDIF
      *
     C     LBSHFR        IFGT      *BLANKS
     C     LESHFR        ORGT      *BLANKS
     C                   SETON                                        62
     C                   ENDIF
      *
     C     LBSLS         IFGT      *BLANKS
     C                   SETON                                        60
     C                   ENDIF
      *
     C     LCO           CHAIN(N)  FMCORG                             90
      *
     C                   Z-ADD     1             ORD                            ORDER TOTAL
     C                   Z-ADD     1             ORDC                           CUST TOTAL
     C                   Z-ADD     1             ORDS                           SLS  TOTAL
     C                   Z-ADD     1             FIRST             2 0
      *
     C*                    EXCPTHDG
      *
     C     NXT           TAG
     C                   SETOFF                                       565740
     C                   READ      FIORSCOR                               77
     C   77              GOTO      END
      *
     C     OISTAT        IFEQ      'D'
     C     OIDTRQ        OREQ      0
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK SALESPERSON
      *
     C   60OISLM1        IFLT      LBSLS
     C     OISLM1        ORGT      LESLS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   65              GOTO      NODT
      *
     C                   Z-ADD     OIDTRQ        ##MDY
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
     C     ODATE         IFLT      LBDAT
     C     ODATE         ORGT      LEDAT
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     NODT          TAG
      *
      * CHECK IF ORDER HEADER RECORD EXISTS, IF NOT, DO NOT PRINT
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
     C     OIITYP        IFEQ      ' '
     C     OIQSHP        ANDGE     OIQORD
     C     OIITYP        OREQ      'N'
     C     OIQSHP        ANDGE     OIQORD
     C                   GOTO      NXT
     C                   ENDIF
      *
      *  CHECK TO SEE IF COMMENT, FRT CHARGE OR SPECIAL CHARGE
      *
     C  N20OIITYP        IFEQ      'C'
     C     OIITYP        OREQ      'F'
     C     OIITYP        OREQ      'S'
     C     OISEQ#        ORGT      989
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK SHIP FROM RANGE
      *
     C   62OISHFR        IFLT      LBSHFR
     C     OISHFR        ORGT      LESHFR
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK FOR ORDER TOTALS
      *
     C   55OIORD#        IFNE      SAVORD
     C                   EXCEPT    TL1
     C                   Z-ADD     1             ORD
     C                   ENDIF
      *
      * CHECK FOR CUSTOMER TOTALS
      *
     C   55OICUST        IFNE      SAVCUS
     C                   EXCEPT    TL2
     C                   Z-ADD     1             ORDC
     C                   ENDIF
      *
      * CHECK FOR SALESPERSON TOTALS
      *
     C   55OISLM1        IFNE      SAVSLS
     C                   EXCEPT    TL3
     C                   Z-ADD     1             ORDS
     C                   ENDIF
      *
      * CHECK IF THIS PO NUMBER GREATER THAN BLANKS
      *
     C     OHPONO        IFGT      *BLANKS
     C                   SETON                                        40
     C                   ENDIF
      *
      * COMPUTE PRICE
      *
     C     KEY18         KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     KEY18         CHAIN     FMINVT                             50
     C     OIITYP        IFEQ      ' '
     C                   EXSR      GETDES
     C                   ELSE
     C                   MOVEL     OIDES1        DESP
     C                   ENDIF
      *
      * COMPUTE PRICE
      *
     C     OIQORD        SUB       OIQSHP        QTYORD                         OPEN QTY
     C                   Z-ADD     OIUPRI        VUPRIC
     C                   Z-ADD     OIQDDC        VDISC
      *
     C                   CALL      '#EXLN'
     C                   PARM                    QTYORD            8 1
     C                   PARM                    VUPRIC            9 4
     C                   PARM                    VDISC             4 2
     C                   PARM                    #LINGR            9 2
     C                   PARM                    #LINNT            9 2
     C                   PARM                    #LINDS            7 2
      *
     C                   Z-ADD     #LINNT        VEXT              9 2
     C     OIITYP        IFEQ      'F'
     C     OIITYP        OREQ      'S'
     C                   Z-ADD     OIUPRI        #LINNT
     C                   ENDIF
      *
      * ACCUMULATE ORDER, CUSTOMER AND FINAL TOTALS
      *
     C                   ADD       #LINNT        ORDTOT           10 2
     C                   ADD       #LINNT        CUSTOT           10 2
     C                   ADD       #LINNT        SLSTOT           10 2
     C                   ADD       #LINNT        FINTOT           10 2
     C                   ADD       OIQSHP        TOTSHP           11 1
     C                   ADD       OIQORD        TOTORD           11 1
     C                   ADD       QTYORD        TOTOPN           11 1
     C                   ADD       OIQSHP        TL2SHP           11 1
     C                   ADD       OIQORD        TL2ORD           11 1
     C                   ADD       QTYORD        TL2OPN           11 1
     C                   ADD       OIQSHP        TL3SHP           11 1
     C                   ADD       OIQORD        TL3ORD           11 1
     C                   ADD       QTYORD        TL3OPN           11 1
      *
     C     OISLM1        CHAIN     FMSLSM                             90
      *
     C                   SETON                                        55
     C                   Z-ADD     OIORD#        SAVORD            6 0
     C                   Z-ADD     OICUST        SAVCUS            6 0
     C                   MOVEL     OISLM1        SAVSLS            2
     C     ORDS          IFEQ      1
     C                   EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DTL1
     C                   ENDIF
     C     ORD           IFEQ      1
     C   OF              EXCEPT    HDG
     C   OF              EXCEPT    DTL1
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DTL2
     C                   SETON                                        88
     C                   ENDIF
     C   OF              EXCEPT    HDG
     C   OF              EXCEPT    DTL1
     C   OF              EXCEPT    DTL2
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DTL3
     C                   ADD       1             ORD               4 0
     C                   ADD       1             ORDC              4 0
     C                   ADD       1             ORDS              4 0
     C                   GOTO      NXT
      *
     C     END           TAG
     C     ORD           IFGT      1
     C                   EXCEPT    TL1
     C                   EXCEPT    TL2
     C                   EXCEPT    TL3
     C                   ENDIF
     C  N88              EXCEPT    HDG
     C  N88              EXCEPT    TLRN
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
     C                   MOVEL     DESCO         DESP             40
     C                   ENDSR
      *
     OBIR405    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           58 'Open Orders'
     O                                           73 'by Salesperson'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O              N65                          20 'Requested Ship Dates'
     O              N65      LBDATE        Y     29
     O              N65                          31 '-'
     O              N65      LEDATE        Y     39
     O               60                          65 'Salesperson Range:'
     O               60      LBSLS               68
     O               60                          70 '-'
     O               60      LESLS               73
     O               62                         110 'Ship From Range:'
     O               62      LBSHFR             114
     O               62                         116 '-'
     O               62      LESHFR             120
     O              N62 65N60                    68 'Selections = ALL'
     O          E            HDG         1  1
     O                                           65 'Ship'
     O                                           76 'Reqd'
     O                                           89 'Unit'
     O                                          109 '- - Quantity - -'
     O                                          120 'Order'
     O          E            HDG            0
     O                                            5 'Seq #'
     O                                           15 'Item/Size'
     O                                           38 'Description'
     O                                           68 'UM'
     O                                           65 'From'
     O                                           78 'Shp Dte'
     O                                           89 'Price'
     O                                           96 'Ord'
     O                                          103 'Shipd'
     O                                          110 'Open'
     O                                          120 'Value'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DTL1        1  0
     O                       OISLM1               2
     O                       SMNAME              33
     O          E            DTL1           2
     O                                           24 '________________________'
     O                                           33 '_________'
     O          E            DTL2           0
     O                       OICUST        Z      6
     O                       OHNAME              37
     O                                           42 'Ord:'
     O                       SAVORD        Z     49
     O                                           55 'Date:'
     O                       OHDTOR        Y     64
     O               40                          69 'P.O.'
     O               40      OHPONO              75
     O          E            DTL2           1
     O                                           28 '________________________'
     O                                           37 '_________'
     O          EF           DTL3           1
     O                       #LINNT        1B   120
     O                       QTYORD        4B   110
     O                       OIQSHP        4    103
     O                       OIQORD        4     96
     O                       OIUPRI        M     89
     O                       OIDTRQ        Y     78
     O                       OIUUOM              68
     O                       OISHFR              65
     O                       DESP           B    61
     O                       OISIZE              19
     O                       OIITEM              16
     O                       OISEQ#        Z      3
     O          E            TL1            1
     O                                          120 '---------'
     O                                          110 '------'
     O                                          103 '------'
     O                                           96 '------'
     O          E            TL1            1
     O                                           77 'Order Totals:'
     O                       SAVORD        ZB    84
     O                       ORDTOT        4B   120
     O                       TOTOPN        4B   110
     O                       TOTSHP        4B   103
     O                       TOTORD        4B    96
     O          E            TL2            1
     O                                          120 '========='
     O                                          110 '======'
     O                                          103 '======'
     O                                           96 '======'
     O          E            TL2            2
     O                                           77 'Customer Totals:'
     O                       SAVCUS        ZB    84
     O                       CUSTOT        4B   120
     O                       TL2OPN        4B   110
     O                       TL2SHP        4B   103
     O                       TL2ORD        4B    96
     O          E            TL3            2
     O                                           77 'Salesperson Totals:'
     O                       SLSTOT        4B   120
     O                       TL3OPN        4B   110
     O                       TL3SHP        4B   103
     O                       TL3ORD        4B    96
     O          E            TLRN        2
     O                                           63 '**** No Orders Found For'
     O                                           79 'Selections ****'
      *
