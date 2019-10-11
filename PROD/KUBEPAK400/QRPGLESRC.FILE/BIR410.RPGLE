      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.      ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES INC.      215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR410
      *SYSTEM-------------- ORDER ENTRY
      *DESCRIPTION--------- OPEN ORDERS BY SHIP DATE/ITEM -DETAIL
      *
      *
      *    CHANGE--DATE-------DESCRIPTION
      *
      *
     FFIORDRSI  IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFARHST    IF   E           K DISK
     FBIR410    O    F  120        PRINTER OFLIND(*INOF)
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
     D  LDOS                  35     35
     D  LBSVIA                36     37
     D  LESVIA                38     39
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
      *
     C                   Z-ADD     1             FIRST             4 0
     C     LBEGDT        IFEQ      0
     C                   SETON                                        65
     C                   ENDIF
      *
     C     LPC1          IFGT      *BLANKS
     C                   SETON                                        60
     C                   ENDIF
      *
     C     LBSHFR        IFGT      *BLANKS
     C     LESHFR        ORGT      *BLANKS
     C                   SETON                                        62
     C                   ENDIF
      *
     C     LBSVIA        IFGT      *BLANKS
     C                   SETON                                        63
     C                   ENDIF
      *
     C   60
     COR 62
     COR 63
     CORN65              SETON                                        66
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      FIORDRSI                               90
     C   90              GOTO      END
      *
      * ACTIVE ORDER
      *
     C     OISTAT        IFEQ      'D'
     C     OIDTRQ        OREQ      0
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK TO SEE IF COMMENT, FRT CHARGE OR SPECIAL CHARGE
      *
     C     OIITYP        IFEQ      'C'
     C     OIITYP        OREQ      'F'
     C     OIITYP        OREQ      'S'
     C                   GOTO      NXT
     C                   ENDIF
     C     OISEQ#        IFGT      989
     C                   GOTO      NXT
     C                   ENDIF
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
     C     ODATE         IFLT      LBEGDT
     C     ODATE         ORGT      LENDDT
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     NODT          TAG
      *
      * CHECK FROM LOCATIONS
      *
     C   62OISHFR        IFLT      LBSHFR
     C     OISHFR        ORGT      LESHFR
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK IF QTY SHIPPED >= QTY ORDERED, DO NOT PRINT
      *
     C     OIQSHP        IFGE      OIQORD
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK IF ORDER HEADER RECORD EXISTS, IF NOT, DO NOT PRIN       T
      *
     C     OIORD#        CHAIN     FHORDR                             11
      *
      * CHECK IF THIS IS A QUOTE, IF SO, DO NOT PRINT
      *
     C     OHQUOT        IFEQ      'Y'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   63OHSHPC        IFLT      LBSVIA
     C     OHSHPC        ORGT      LESVIA
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
      * DO NOT INCLUDE INTERNAL ORDERS
      *
     C     OHCUST        CHAIN     FARHST                             57
     C  N57HSINCL        IFEQ      'N'
     C                   GOTO      NXT
     C                   ENDIF
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
      * NEW SHIP DATE
      *
     C   55OIDTRQ        IFNE      SAVDTE
     C     TOTORD        ANDNE     0
     C                   EXCEPT    TL1
     C                   ENDIF
     C                   SETON                                        55
      *
     C                   EXSR      GETDES
      *
     C     OIQORD        SUB       OIQSHP        QTYOPN           11 1
      *
      * ACCUMULATE TOTALS FOR DATE, LOCATION
      *
     C                   ADD       OIQORD        TOTORD           11 1
     C                   ADD       OIQORD        TLRORD           11 1
     C                   ADD       OIQSHP        TOTSHP           11 1
     C                   ADD       OIQSHP        TLRSHP           11 1
     C                   ADD       QTYOPN        TOTOPN           11 1
     C                   ADD       QTYOPN        TLROPN           11 1
      *
     C   OF              EXCEPT    HDG
     C                   EXCEPT    DETL
     C                   SETON                                        77
      *
     C                   Z-ADD     OIDTRQ        SAVDTE            6 0
     C                   MOVEL     OISHFR        SAVLOC            3
     C                   MOVEL     OIITEM        SAVITM           12
     C                   MOVEL     OISIZE        SAVSIZ            3
     C                   MOVEL     DESP          SAVDES           46
     C                   MOVEL     OIUUOM        SAVUM             2
     C                   SETON                                        55
     C                   ADD       1             FIRST
     C                   GOTO      NXT
      *
     C     END           TAG
     C     TOTORD        IFGT      0
     C                   EXCEPT    TL1
     C                   ENDIF
     C   77              EXCEPT    TLR
     C  N77              EXCEPT    TLRN
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
     C                   MOVEL     DESCO         DESP             35
     C                   ENDSR
      *
     OBIR410    E            HDG            1 03
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
     O                                           52 'Open Items by'
     O                                           72 'Requested Ship Date'
     O                                           82 ' - Detail '
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
     O               60                         112 'Product Classes'
     O               60      LPC1               115
     O               60                         117 '-'
     O               60      LPC2               120
     O              N66                          68 'Selections = ALL'
     O          E            HDG            1
     O               63                          63 'Ship Via Range:'
     O               63      LBSVIA              67
     O               63                          69 '-'
     O               63      LESVIA              73
     O          E            HDG            1
     O                                            9 'Requested'
     O                                           74 'Ship'
     O                                           85 'Ship'
     O                                           67 'Order'
     O                                           90 '- -'
     O                                          117 ' - - - Quantity - - - -'
     O                                          119 ' -'
     O          E            HDG            0
     O                                            9 'Ship Date'
     O                                           18 'Item'
     O                                           46 'D e s c r i p t i o n'
     O                                           74 'Via'
     O                                           85 'From'
     O                                           67 '  #  '
     O                                           79 'UM'
     O                                           97 'Ordered'
     O                                          109 'Shipped'
     O                                          120 'Open'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DETL           1
     O                       QTYOPN        MB   120
     O                       OIQSHP        MB   109
     O                       OIQORD        MB    98
     O                       OISHFR              87
     O                       OIUUOM              79
     O                       OHSHPC              74
     O                       OHPOS               69
     O                       OIORD#        Z     67
     O                       DESP                60
     O                       OISIZE              24
     O                       OIITEM              21
     O                       OIDTRQ        Y      8
     O          E            TL1            1
     O                                          120 '--------'
     O                                          109 '--------'
     O                                           98 '--------'
     O          E            TL1            2
     O                                           73 'Total Ship Date:'
     O                       SAVDTE        YB    82
     O                       TOTOPN        MB   120
     O                       TOTSHP        MB   109
     O                       TOTORD        MB    98
     O          E            TLR            2
     O                                           73 'Total Report:'
     O                       TLROPN        MB   120
     O                       TLRSHP        MB   109
     O                       TLRORD        MB    98
     O          E            TLRN           2
     O                                           55 '**** There Are No Transa'
     O                                           78 'ctions For The Report S'
     O                                           92 'elections ****'
      *
