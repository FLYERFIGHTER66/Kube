      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC.      1999
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
      *PROGRAM NAME-------- BIR390
      *SYSTEM-------------- ORDER ENTRY
      *DESCRIPTION--------- OPEN ORDERS LISTED BY CUSTOMER NUMBER
      *
      *
      *    CHANGE--DATE-------DESCRIPTION
      *
      *
     FFIORCAOR  IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FBIR390    O    F  132        PRINTER OFLIND(*INOF)
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
     D  LCUST                  3      8  0
     D  LBDATE                 9     14  0
     D  LEDATE                15     20  0
     D  LBEGDT                21     25  0
     D  LENDDT                26     30  0
     D  LBSHFR                31     33
     D  LESHFR                34     36
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
     C     LCUST         IFGT      0
     C                   SETON                                        60
     C                   ENDIF
      *
     C     LINCL         IFEQ      'Y'
     C                   SETON                                        20
     C                   ENDIF
      *
     C     LBEGDT        IFEQ      *ZEROS
     C                   SETON                                        65
     C                   ENDIF
      *
     C     LBSHFR        IFGT      *BLANKS
     C     LESHFR        ORGT      *BLANKS
     C                   SETON                                        62
     C                   ENDIF
      *
     C     LCO           CHAIN(N)  FMCORG                             90
      *
     C                   Z-ADD     1             ORD                            ORDER TOTAL
     C                   Z-ADD     1             ORDC                           CUST TOTAL
     C                   Z-ADD     1             FIRST             2 0
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       565740
     C                   READ      FIORCAOR                               90
     C   90              GOTO      END
      *
     C     OICOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     OISTAT        IFEQ      'D'
     C     OIDTRQ        OREQ      0
     C                   GOTO      NXT
     C                   ENDIF
      *
      *  CHECK CUSTOMER
      *
     C     LCUST         IFEQ      *ZEROS
     C                   GOTO      NOCUS
     C                   ENDIF
     C     OICUST        IFNE      LCUST
     C                   GOTO      NXT
     C                   ENDIF
     C     NOCUS         TAG
      *
     C   65              GOTO      NODT
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
      * CHECK TO SEE IF COMMENT, FRT CHARGE OR SPECIAL CHARGE
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
      *  CHECK FOR ORDER TOTALS
      *
     C   55OIORD#        IFNE      SAVORD
     C                   EXCEPT    TL1
     C                   Z-ADD     1             ORD
     C                   ENDIF
      *
      *  CHECK FOR CUSTOMER TOTALS
      *
     C   55OICUST        IFNE      SAVCUS
     C                   EXCEPT    TL2
     C                   Z-ADD     1             ORDC
     C                   ENDIF
      *
      * CHECK IF THIS PO NUMBER GREATER THAN BLANKS
      *
     C     OHPONO        IFGT      *BLANKS
     C                   SETON                                        40
     C                   ENDIF
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
     C                   ADD       #LINNT        FINTOT           10 2
     C                   ADD       OIQSHP        TOTSHP           11 1
     C                   ADD       OIQORD        TOTORD           11 1
     C                   ADD       QTYORD        TOTOPN           11 1
     C                   ADD       OIQSHP        TL2SHP           11 1
     C                   ADD       OIQORD        TL2ORD           11 1
     C                   ADD       QTYORD        TL2OPN           11 1
     C                   ADD       OIQSHP        TLRSHP           11 1
     C                   ADD       OIQORD        TLRORD           11 1
     C                   ADD       QTYORD        TLROPN           11 1
      *
     C                   SETON                                        55
     C                   Z-ADD     OIORD#        SAVORD            6 0
     C                   Z-ADD     OICUST        SAVCUS            6 0
     C     ORDC          IFEQ      1
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DTL1
     C                   SETON                                        77
     C                   ENDIF
     C     ORD           IFEQ      1
     C   OF              EXCEPT    HDG
     C   OF              EXCEPT    DTL1
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DTL2
     C                   ENDIF
     C   OF              EXCEPT    HDG
     C   OF              EXCEPT    DTL1
     C   OF              EXCEPT    DTL2
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DTL3
     C                   ADD       1             ORD               6 0
     C                   ADD       1             ORDC              6 0
     C                   GOTO      NXT
      *
     C     END           TAG
     C     ORD           IFGT      1
     C                   EXCEPT    TL1
     C                   EXCEPT    TL2
     C                   ENDIF
     C  N60              EXCEPT    TLR
     C  N77              EXCEPT    TLRN
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
     OBIR390    E            HDG            1 03
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
     O                                           56 'Open Orders'
     O                                           76 'by Ship To Customer'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O              N65                          20 'Requested Ship Dates'
     O              N65      LBDATE        Y     29
     O              N65                          31 '-'
     O              N65      LEDATE        Y     39
     O               62                          63 'Ship From Range:'
     O               62      LBSHFR              67
     O               62                          69 '-'
     O               62      LESHFR              73
     O               60                         113 'Include Only Cust:'
     O               60      LCUST         Z    120
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
     O                       OICUST        Z      6
     O                       OHNAME              37
     O          E            DTL1           1
     O                                           24 '________________________'
     O                                           37 '_____________'
     O          E            DTL2           1
     O                                            6 'Order:'
     O                       SAVORD        Z     13
     O                                           27 'Order Date:'
     O                       OHDTOR        Y     36
     O               40                          45 'P.O. # '
     O               40      OHPONO              62
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
     O          E            TL2            1
     O                                           77 'Customer Totals:'
     O                       SAVCUS        ZB    84
     O                       CUSTOT        4B   120
     O                       TL2OPN        4B   110
     O                       TL2SHP        4B   103
     O                       TL2ORD        4B    96
     O          E            TLR         2
     O                                           77 'Report Totals:'
     O                       FINTOT        4B   120
     O                       TLROPN        4B   110
     O                       TLRSHP        4B   103
     O                       TLRORD        4B    96
     O          E            TLRN           2
     O                                           55 '**** There Are No Transa'
     O                                           78 'ctions For The Report S'
     O                                           92 'elections ****'
      *
