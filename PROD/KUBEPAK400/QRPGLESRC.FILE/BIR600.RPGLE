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
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR600
      *APPLICATION--------- ORDER ENTRY
      *DESCRIPTION--------- OPEN ORDERS LISTED BY ROUTE NUMBER
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFHORDRTE  IF   E           K DISK
     FFIORDR    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFCMDIR    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMROUT    IF   E           K DISK
     FBIR600    O    F  120        PRINTER OFLIND(*INOF)
      *
     D #SH             S             32    DIM(5)
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
     D  LBRTE                  3      4
     D  LERTE                  5      6
     D  LDOS                   7      7
     D  LICFS                  8      8
     D  LIADDR                 9      9
     D  LIDIR                 10     10
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
      *
      * RENAME HORDR FIELDS
     IRHORDR
     I              OHNAME                      #WSHP1
     I              OHSHP2                      #WSHP2
     I              OHSHP3                      #WSHP3
     I              OHSHP4                      #WSHP4
     I              OHSHCT                      #WSHCT
     I              OHSHST                      #WSHST
     I              OHSHZP                      #WSHZP
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN     FMCORG                             90
      *
     C     LBRTE         IFGT      *BLANKS
     C                   SETON                                        60
     C                   ENDIF
      *
     C     LICFS         IFEQ      'Y'
     C                   SETON                                        20
     C                   ENDIF
      *
     C     LIDIR         IFEQ      'Y'
     C                   SETON                                        25
     C                   ENDIF
      *
     C     LIADDR        IFEQ      'Y'
     C                   SETON                                        30
     C                   ENDIF
      *
     C     LBSHFR        IFGT      *BLANKS
     C     LESHFR        ORGT      *BLANKS
     C                   SETON                                        63
     C                   ENDIF
      *
     C                   EXCEPT    HDG
     C                   Z-ADD     1             ORDC              3 0          CUST TOTAL
     C                   Z-ADD     1             RTE               3 0
      *
     C     NXT           TAG
      *
     C                   READ      FHORDRTE                               90
     C   90              GOTO      END
      *
     C     RTE           IFGT      1
     C     OHROUT        ANDNE     SAVRTE
     C     SAVRTE        ANDGT     *BLANKS
     C                   EXCEPT    TL1
     C                   EXCEPT    TL2
     C                   Z-ADD     1             RTE
     C                   Z-ADD     1             ORDC
     C                   EXCEPT    HDG
     C*          OHROUT    CHAINFMROUT               90
     C*                    EXCPTDTL1
     C                   SETOFF                                       66
     C                   MOVE      *BLANKS       SAVRTE            2
     C                   ENDIF
      *
     C     ORDC          IFGT      1
     C     OHCUST        ANDNE     SAVCUS
     C     OHROUT        ANDEQ     SAVRTE
     C                   Z-ADD     1             ORDC
     C                   EXCEPT    TL1
     C                   ENDIF
      *
      * ACTIVE ORDER
      *
     C     OHSTAT        IFEQ      'D'
     C     OHCOFL        OREQ      'Y'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     OHROUT        IFEQ      *BLANKS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   60OHROUT        IFLT      LBRTE
     C     OHROUT        ORGT      LERTE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   63OHSHFR        IFLT      LBSHFR
     C     OHSHFR        ORGT      LESHFR
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK IF THIS IS A QUOTE, IF SO, DO NOT PRINT
      *
     C     OHQUOT        IFEQ      'Y'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     OHORD#        SETLL     FIORDR
     C     NXTI          TAG
     C     OHORD#        READE     FIORDR                                 11
     C   11              GOTO      NXT
      *
      * CHECK IF QTY SHIPPED >= QTY ORDERED
      *
     C     OIITYP        IFEQ      ' '
     C     OIQSHP        ANDGE     OIQORD
     C     OIITYP        OREQ      'N'
     C     OIQSHP        ANDGE     OIQORD
     C                   GOTO      NXTI
     C                   ENDIF
      *
      * CHECK TO SEE IF COMMENT, FRT CHARGE OR SPECIAL CHARGE
      *
     C  N20OIITYP        IFEQ      'C'
     C     OIITYP        OREQ      'F'
     C     OIITYP        OREQ      'S'
     C     OISEQ#        ORGT      989
     C                   GOTO      NXTI
     C                   ENDIF
      *
      * CHECK DATE RANGE
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
     C     ODATE         IFNE      LBEGDT
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     NODT          TAG
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
     C     OIITYP        IFEQ      'F'
     C     OIITYP        OREQ      'S'
     C                   Z-ADD     OIUPRI        #LINNT
     C                   ENDIF
      *
      * ACCUMULATE ORDER, CUSTOMER AND FINAL TOTALS
      *
     C                   ADD       #LINNT        CUSTOT           12 2
     C                   ADD       OIQORD        CUSTOQ           11 1
     C                   ADD       OIQSHP        CUSTOS           11 1
     C                   ADD       QTYORD        CUSTOW           11 1
     C                   ADD       #LINNT        RTETOT           12 2
     C                   ADD       OIQORD        RTETOQ           11 1
     C                   ADD       OIQSHP        RTETOS           11 1
     C                   ADD       QTYORD        RTETOW           11 1
     C                   ADD       #LINNT        FINTOT           12 2
     C                   ADD       OIQORD        FINTOQ           11 1
     C                   ADD       OIQSHP        FINTOS           11 1
     C                   ADD       QTYORD        FINTOW           11 1
      *
     C                   MOVEL     OHROUT        SAVRTE            2
     C                   Z-ADD     OHCUST        SAVCUS            6 0
      *
     C     KEY18         KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C     KEY18         CHAIN     FMINVT                             50
      *
     C     OIITYP        IFEQ      ' '
     C                   EXSR      GETDES
     C                   ELSE
     C                   MOVEL     OIDES1        DESC
     C                   ENDIF
      *
     C     RTE           IFEQ      1
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C     OHROUT        CHAIN     FMROUT                             90
     C                   EXCEPT    DTL1
     C                   ENDIF
      *
     C     ORDC          IFEQ      1
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   EXCEPT    DTL2
     C  N30              GOTO      NOADDR
     C     OHCUST        CHAIN     FMCUST                             90
     C                   EXSR      #SHP
     C     #SH(2)        IFGT      *BLANKS
     C                   EXCEPT    DTL22
     C                   ENDIF
     C     #SH(3)        IFGT      *BLANKS
     C                   EXCEPT    DTL23
     C                   ENDIF
     C     #SH(4)        IFGT      *BLANKS
     C                   EXCEPT    DTL24
     C                   ENDIF
     C     #SH(5)        IFGT      *BLANKS
     C                   EXCEPT    DTL25
     C                   ENDIF
     C     NOADDR        TAG
     C  N25              GOTO      NODIR
     C     OHCUST        CHAIN     FCMDIR                             97
     C   97              GOTO      NODIR
     C                   EXCEPT    DIR
     C     CMDR01        IFGT      *BLANKS
     C                   EXCEPT    DIR1
     C                   ENDIF
     C     CMDR02        IFGT      *BLANKS
     C                   EXCEPT    DIR2
     C                   ENDIF
     C     CMDR03        IFGT      *BLANKS
     C                   EXCEPT    DIR3
     C                   ENDIF
     C     CMDR04        IFGT      *BLANKS
     C                   EXCEPT    DIR4
     C                   ENDIF
     C     CMDR05        IFGT      *BLANKS
     C                   EXCEPT    DIR5
     C                   ENDIF
     C     CMDR06        IFGT      *BLANKS
     C                   EXCEPT    DIR6
     C                   ENDIF
     C     CMDR07        IFGT      *BLANKS
     C                   EXCEPT    DIR7
     C                   ENDIF
     C     CMDR08        IFGT      *BLANKS
     C                   EXCEPT    DIR8
     C                   ENDIF
     C     CMDR09        IFGT      *BLANKS
     C                   EXCEPT    DIR9
     C                   ENDIF
     C     CMDR10        IFGT      *BLANKS
     C                   EXCEPT    DIR10
     C                   ENDIF
     C     CMDR11        IFGT      *BLANKS
     C                   EXCEPT    DIR11
     C                   ENDIF
     C     NODIR         TAG
     C                   ENDIF
      *
     C                   EXCEPT    DTL3
     C                   SETON                                        77
     C                   ADD       1             ORDC              3 0
     C                   ADD       1             RTE               3 0
     C                   SETON                                        66
     C                   GOTO      NXTI
      *
     C     END           TAG
     C   66              EXCEPT    TL1
     C   66              EXCEPT    TL2
     C  N77              EXCEPT    TLRN
     C                   SETON                                        LR
      ***********
      * #SHP    *
      ***********
      *
      *  THIS SUBROUTINE REMOVES BLANK ADDRESS LINES FROM THE SHIP TO
      *  ADDRESS.  WORK FIELDS ARE DEFINED AS:
      *
      *                 WORK  = CITY,STATE,ZIP(9 DIGIT)
      *                 WORK1 = CITY, STATE
      *                 WORK2 = ZIP CODE(XXXXX-XXXX)
      *                 WORK3 = STANDARD ZIP CODE(XXXXX)
      *                 WORK4 = ADDITIONAL ZIP CODE(-XXXX)
      *
      *  THE SUBROUTINE REQUIRES MOVING NAME AND ADDRESS INFORMATION TO
      *  BE CONDENSED TO A DATA STRUCTURE
      *
     C     #SHP          BEGSR
      *
     C                   MOVE      *BLANKS       #SH
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WSHP1        #SH(#X)
     C                   ADD       1             #X
     C     #WSHP2        COMP      *BLANKS                            929291
     C   91              GOTO      #SHP1
     C                   MOVEL     #WSHP2        #SH(#X)
     C                   ADD       1             #X
     C     #SHP1         TAG
     C     #WSHP3        COMP      *BLANKS                            929291
     C   91              GOTO      #SHP2
     C                   MOVEL     #WSHP3        #SH(#X)
     C                   ADD       1             #X
     C     #SHP2         TAG
     C     #WSHP4        COMP      *BLANKS                            929291
     C   91              GOTO      #SHP3
     C                   MOVEL     #WSHP4        #SH(#X)
     C                   ADD       1             #X
     C     #SHP3         TAG
     C                   MOVE      *BLANKS       WORK             32            BLANK
     C                   MOVE      *BLANKS       WORK1            21            BLANK
     C                   MOVE      *BLANKS       WORK2            10             "
     C                   MOVE      *BLANKS       WORK3             5             "
     C                   MOVE      *BLANKS       WORK4             5             "
     C     #WSHCT        CAT       #WSHST:1      WORK1
     C                   MOVEL     #WSHZP        WORK3
     C                   MOVE      #WSHZP        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2                          19002-1525
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #SH(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
      *
      *
      **********
      * GETDES
      **********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            39
     C                   MOVEL     'R'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESC             39
     C                   ENDSR
      *
     OBIR600    E            HDG            1 03
     O                                            6 'BIR600'
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
     O                                           60 'Open Orders'
     O                                           69 'By Route'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           20 'Requested Ship Date:'
     O                       LBDATE        Y     29
     O               63                         110 'Ship From Range:'
     O               63      LBSHFR             114
     O               63                         116 '-'
     O               63      LESHFR             120
     O               60                          64 'Requested Routes:'
     O               60      LBRTE               67
     O               60                          70 'To'
     O               60      LERTE               73
     O              N60N63                       68 'Selections = ALL'
     O          E            HDG            1
     O                                           69 'Ship'
     O                                           77 'Reqd'
     O                                           91 'Unit'
     O                                           99 'Order'
     O                                          105 'Qty'
     O                                          111 'Qty'
     O                                          120 'Order'
     O          E            HDG            0
     O                                            5 'Ord #'
     O                                           18 'Item/Size'
     O                                           50 'Description'
     O                                           69 'From'
     O                                           79 'Shp Date'
     O                                           82 'UM'
     O                                           91 'Price'
     O                                           98 'Qty'
     O                                          105 'Shpd'
     O                                          111 'Open'
     O                                          120 'Value'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DTL1        1  0
     O                                           47 'Route:'
     O                       OIROUT              50
     O                       RTDESC              81
     O          E            DTL1           1
     O                                           65 '________________________'
     O                                           81 '________________'
     O          E            DTL2        1  0
     O                                            9 'Customer:'
     O                       OICUST        Z     16
     O                                           17 '-'
     O                       #WSHP1              47
     O                                           55 'Stop:'
     O                       OHSTOP        Z     59
     O          E            DTL2           1
     O                                           24 '________________________'
     O                                           47 '_______________________'
     O          EF           DTL22          1
     O                       #SH(2)              49
     O                       CMPHON              62 '   -   -    '
     O          EF           DTL23          1
     O                       #SH(3)              49
     O          EF           DTL24          1
     O                       #SH(4)              49
     O          EF           DTL25          1
     O                       #SH(5)              49
     O          EF           DIR            0
     O                                           11 'Directions:'
     O          EF           DIR1           1
     O                       CMDR01              89
     O          EF           DIR2           1
     O                       CMDR02              89
     O          EF           DIR3           1
     O                       CMDR03              89
     O          EF           DIR4           1
     O                       CMDR04              89
     O          EF           DIR5           1
     O                       CMDR05              89
     O          EF           DIR6           1
     O                       CMDR06              89
     O          EF           DIR7           1
     O                       CMDR07              89
     O          EF           DIR8           1
     O                       CMDR08              89
     O          EF           DIR9           1
     O                       CMDR09              89
     O          EF           DIR10          1
     O                       CMDR10              89
     O          EF           DIR11          1
     O                       CMDR11              89
     O          EF           DTL3        1  0
     O                       #LINNT        1B   120
     O                       QTYORD        1B   111
     O                       OIQSHP        1    105
     O                       OIQORD        1     99
     O                       OIUPRI        1     92
     O                       OIUUOM              82
     O                       OIDTRQ              79 '  /  / 0'
     O                       OHSHFR              69
     O                       DESC           B    65
     O                       OIWHSE              26
     O                       OISIZE              22
     O                       OIITEM              19
     O                       OIORD#        Z      6
     O          EF           TL1         1  2
     O                       CUSTOT        1B   120
     O                       CUSTOW        1B   111
     O                       CUSTOS        1B   105
     O                       CUSTOQ        1B    99
     O                                           92 'Customer Totals:'
     O          EF           TL2         1  2
     O                       RTETOT        1B   120
     O                       RTETOW        1B   111
     O                       RTETOS        1B   105
     O                       RTETOQ        1B    99
     O                                           92 'Route Totals:'
     O          E            TLRN           2
     O                                           55 '**** There Are No Transa'
     O                                           78 'ctions For The Report S'
     O                                           92 'elections ****'
      *
