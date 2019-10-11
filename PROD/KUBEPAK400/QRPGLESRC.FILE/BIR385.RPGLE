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
      *PROGRAM NAME-------- BIR385
      *APPLICATION--------- ORDER ENTRY
      *DESCRIPTION--------- OPEN ORDERS LISTED BY PRODUCT CLASS/ITEM
      *
      *
      *       CHANGE--DATE-------DESCRIPTION
      *
      *
     FFIORDRPC  IF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FBIR385    O    F  120        PRINTER OFLIND(*INOF)
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
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
     C     LCO           CHAIN     FMCORG                             90
     C                   Z-ADD     1             PRC
      *
     C     LBEGDT        IFGT      0
     C                   SETON                                        65
     C                   ENDIF
      *
     C     LPC1          IFGT      *BLANKS
     C                   SETON                                        60
     C                   ENDIF
      *
     C     LBSHFR        IFGT      *BLANKS
     C                   SETON                                        62
     C                   ENDIF
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   Z-ADD     0             OIQORD
     C                   Z-ADD     0             OIQSHP
     C                   Z-ADD     0             QTYOPN
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
     C     LPC1          IFEQ      *BLANKS
     C                   GOTO      NOPC
     C                   ENDIF
      *
     C     OIPRCL        CHAIN     FMPRCL                             90
      *
     C     OIPRCL        IFLT      LPC1
     C     OIPRCL        ORGT      LPC2
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     NOPC          TAG
      *
     C     OIPRCL        IFEQ      *BLANKS
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
      * CHECK FOR PRODUCT CLASS TOTALS
      *
     C   55OIPRCL        IFGT      SAVPRC
     C                   Z-ADD     1             PRC
     C                   EXCEPT    TL1
     C                   EXCEPT    HDG
     C                   SETOFF                                       55
     C                   ENDIF
      *
      * CHECK IF ORDER HEADER RECORD EXISTS, IF NOT, DO NOT PRINT
      *
     C     OIORD#        CHAIN     FHORDR                             11
     C                   MOVEL     OHNAME        SHNAME           24
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
      *  CHECK TO SEE IF COMMENT, FRT CHARGE OR SPECIAL CHARGE
      *
     C     OIITYP        IFEQ      'C'
     C     OIITYP        OREQ      'F'
     C     OIITYP        OREQ      'S'
     C     OISEQ#        ORGT      989
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
     C                   EXSR      GETDES
      *
     C     OIQORD        SUB       OIQSHP        QTYOPN           11 1          OPEN QTY
     C                   ADD       OIQORD        TOTORD           11 1
     C                   ADD       OIQSHP        TOTSHP           11 1
     C                   ADD       QTYOPN        TOTOPN           11 1
      *
     C                   MOVEL     OIPRCL        SAVPRC            2
     C     PRC           IFEQ      1
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C     OIPRCL        CHAIN     FMPRCL                             90
     C                   EXCEPT    DTL1
     C                   SETON                                        5588
     C                   ENDIF
     C                   EXCEPT    DTL2
     C                   ADD       1             PRC               3 0
     C                   GOTO      NXT
      *
     C     END           TAG
     C   88              EXCEPT    TL1
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
     C                   MOVEL     DESCO         DESC             35
     C                   ENDSR
      *
      *
     OBIR385    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          1    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           57 'Open Orders By'
     O                                           76 'Product Class/Item'
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
     O                                           87 'Ship'
     O                                           97 'Reqd'
     O                                          120 '- - - Quantity - - -'
     O          E            HDG            0
     O                                            6 'Ord #'
     O                                           26 'Ship To Customer'
     O                                           36 'Item'
     O                                           47 'Size'
     O                                           65 'Description'
     O                                           87 'From'
     O                                           99 'Shp Dte'
     O                                           90 'UM'
     O                                          106 'Ord'
     O                                          113 'Shpd'
     O                                          120 'Open'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DTL1           0
     O                       OIPRCL               2
     O                       PCDESC              33
     O          EF           DTL1           1
     O                                           24 '________________________'
     O                                           33 '_________'
     O          EF           DTL2           1
     O                       QTYOPN        4B   120
     O                       OIQSHP        4B   113
     O                       OIQORD        4B   106
     O                       OIDTRQ        Y     99
     O                       OIUUOM              90
     O                       OISHFR              87
     O                       DESC                83
     O                       OISIZE              47
     O                       OIITEM              44
     O                       SHNAME         B    31
     O                       OIORD#        Z      6
     O          E            TL1            1
     O                                          120 '------'
     O                                          113 '------'
     O                                          106 '------'
     O          E            TL1            2
     O                                           90 'Product Class Totals:'
     O                       TOTOPN        4B   120
     O                       TOTSHP        4B   113
     O                       TOTORD        4B   106
     O          E            TLR            1
     O          E            TLRN           1
     O                                           55 '**** There Are No Transa'
     O                                           78 'ctions For The Report S'
     O                                           92 'elections ****'
      *
      *
