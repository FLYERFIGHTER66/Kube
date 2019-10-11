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
      *PROGRAM NAME-------- BIR380
      *SYSTEM-------------- ORDER ENTRY
      *DESCRIPTION--------- OPEN ORDERS LISTED BY ORDER NUMBER
      *
      *
      *       CHANGE--DATE-------DESCRIPTION
      *
     FFIORDR    IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FBIR380    O    F  120        PRINTER OFLIND(*INOF)
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
     D                UDS
     D  LCO                    1      2  0
     D  LBDATE                 3      8  0
     D  LEDATE                 9     14  0
     D  LPC1                  15     16
     D  LPC2                  17     18
     D  LBSHFR                19     21
     D  LESHFR                22     24
     D  LBEGDT                25     29  0
     D  LENDDT                30     34  0
     D  LCOMM                 35     35  0
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
     C                   Z-ADD     1             ORD
      *
     C     LBDATE        IFGT      0
     C                   SETON                                        65
     C                   ENDIF
      *
     C     LPC1          IFGT      *BLANKS
     C                   SETON                                        60
     C                   ENDIF
      *
     C     LCOMM         IFEQ      1
     C                   SETON                                        63
     C                   ENDIF
      *
     C     LBSHFR        IFGT      *BLANKS
     C     LESHFR        ORGT      *BLANKS
     C                   SETON                                        62
     C                   ENDIF
      *
     C     LCO           CHAIN(N)  FMCORG                             90
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
      *
     C                   READ      RIORDR                                 77
     C   77              GOTO      END
      *
     C     OICOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
      * ACTIVE ORDER
      *
     C     OISTAT        IFEQ      'D'
     C     OIDTRQ        OREQ      0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   63OIITYP        IFNE      ' '
     C     OIITYP        ANDNE     'N'
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
      * CHECK FOR ORDER TOTALS
      *
     C   55OIORD#        IFGT      SAVORD
     C                   Z-ADD     1             ORD
     C   OF              DO                                                     EFD
     C                   EXCEPT    HDG                                          EFD
     C                   ENDDO                                                  EFD
     C                   EXCEPT    TL1
     C                   SETOFF                                       55
     C                   ENDIF
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
     C     OIITYP        IFNE      ' '
     C                   GOTO      NOOPN
     C                   ENDIF
      *
     C     OIQSHP        IFGE      OIQORD
     C                   GOTO      NXT
     C                   ENDIF
     C     NOOPN         TAG
      *
      * CHECK PRODUCT CLASS RANGE
      *
     C     KEY18         KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     KEY18         CHAIN     FMINVT                             50
      *
     C     LPC1          IFEQ      *BLANKS
     C                   GOTO      NOPC
     C                   ENDIF
      *
     C     IMPCL1        IFLT      LPC1
     C     IMPCL1        ORGT      LPC2
     C                   GOTO      NXT
     C                   ENDIF
     C     NOPC          TAG
      *
      * CHECK SHIP FROM RANGE
      *
     C   62OISHFR        IFLT      LBSHFR
     C     OISHFR        ORGT      LESHFR
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     OIITYP        IFEQ      ' '
     C                   EXSR      GETDES
     C                   ELSE
     C                   MOVEL     OIDES1        DESC
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
      *
     C     OIITYP        IFEQ      'F'
     C     OIITYP        OREQ      'S'
     C                   Z-ADD     OIUPRI        #LINNT
     C                   ENDIF
      *
      * ACCUMULATE ORDER TOTAL AND FINAL TOTAL
      *
     C                   ADD       #LINNT        ORDTOT            9 2
     C                   ADD       #LINNT        FINTOT            9 2
     C                   ADD       OIQSHP        TOTSHP           11 1
     C                   ADD       OIQORD        TOTORD           11 1
     C                   ADD       QTYORD        TOTOPN           11 1
     C                   ADD       OIQSHP        TLRSHP           11 1
     C                   ADD       OIQORD        TLRORD           11 1
     C                   ADD       QTYORD        TLROPN           11 1
      *
     C                   Z-ADD     OIORD#        SAVORD            6 0
     C     ORD           IFEQ      1
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   EXCEPT    DTL1
     C                   SETON                                        5588
     C                   ENDIF
     C   OF              DO                                                     EFD
     C                   EXCEPT    HDG                                          EFD
     C                   ENDDO                                                  EFD
     C                   EXCEPT    DTL2
     C                   ADD       1             ORD               3 0
     C                   GOTO      NXT
      *
     C     END           TAG
     C     ORD           IFGT      1
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
     C                   MOVEL     DESCO         DESC             40
     C                   ENDSR
      *
     OBIR380    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                       PAGE          1    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           60 'Open Orders By'
     O                                           73 'Order Number'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O               65                          20 'Requested Ship Dates'
     O               65      LBDATE        Y     29
     O               65                          31 '-'
     O               65      LEDATE        Y     39
     O               62                          63 'Ship From Range:'
     O               62      LBSHFR              67
     O               62                          69 '-'
     O               62      LESHFR              73
     O               60                         112 'Product Classes'
     O               60      LPC1               115
     O               60                         117 '-'
     O               60      LPC2               120
     O              N60N62N65                    68 'Selections = ALL'
     O          E            HDG            1
     O                                            6 'Ord #'
     O                                           32 'Ship To Customer'
     O                                           54 'Type'
     O                                           64 'Ship'
     O                                           71 'Reqd'
     O                                           85 'Unit'
     O                                           96 'Order'
     O                                          103 'Qty'
     O                                          109 'Qty'
     O                                          120 'Order'
     O          E            HDG            0
     O                                            4 'Seq'
     O                                           10 'Item'
     O                                           19 'Size'
     O                                           40 'Description'
     O                                           64 'From'
     O                                           73 'Shp Dte'
     O                                           76 'UM'
     O                                           86 'Price'
     O                                           95 'Qty'
     O                                          103 'Shpd'
     O                                          110 'Open'
     O                                          120 'Value'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DTL1           0
     O                       OIORD#        Z      6
     O                       OHCUST        Z     13
     O                       OHNAME              44
     O                       OHPOS               53
     O          EF           DTL1           1
     O                                           24 '________________________'
     O                                           44 '____________________'
     O          EF           DTL2           1
     O                       #LINNT        4B   120
     O                       QTYORD        4B   110
     O                       OIQSHP        4    103
     O                       OIQORD        4     96
     O                       OIUPRI        4     86
     O                       OIUUOM              76
     O                       OIDTRQ        Y     73
     O                       OISHFR              64
     O                       DESC                60
     O                       OISEQ#        Z      3
     O                       OIITEM              16
     O                       OISIZE              19
     O          EF           TL1            1
     O                                          120 '--------'
     O                                          110 '------'
     O                                          103 '------'
     O                                           96 '------'
     O          EF           TL1            2
     O                                            8 'P.O. # '
     O                       OHPONO              25
     O                                           40 'Order Date:'
     O                       OHDTOR        Y     50
     O                                           84 'Order Totals:'
     O                       ORDTOT        4B   120
     O                       TOTOPN        4B   110
     O                       TOTSHP        4B   103
     O                       TOTORD        4B    96
     O          E            TLR            1
     O                                          120 '========'
     O                                          110 '======'
     O                                          103 '======'
     O                                           96 '======'
     O          E            TLR            1
     O                                           84 'Report Totals:'
     O                       FINTOT        4    120
     O                       TLROPN        4B   110
     O                       TLRSHP        4B   103
     O                       TLRORD        4B    96
     O          E            TLRN           1
     O                                           55 '**** There Are No Transa'
     O                                           78 'ctions For The Report S'
     O                                           92 'elections ****'
      *
