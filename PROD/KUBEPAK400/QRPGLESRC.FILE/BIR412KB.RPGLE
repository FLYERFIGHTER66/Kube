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
      *PROGRAM NAME-------- BIR412
      *SYSTEM-------------- ORDER ENTRY
      *DESCRIPTION--------- OPEN ORDERS BY SHIP DATE/ITEM -SUMMARY
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
     C     LBEGDT        IFEQ      *ZEROS
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
     C     FIRST         IFGT      1
     C     OIDTRQ        ANDNE     OLDATE
     C                   EXCEPT    TL1
     C                   ENDIF
      *
     C     OIITEM        IFNE      OITEM
     C     OISIZE        ORNE      OSIZE
     C                   EXCEPT    DETLS
     C                   ENDIF
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
     C*  55      OIDTRQ    IFNE SAVDTE
     C*          ORDTOT    ANDNE*ZEROS
     C*                    EXCPTTL1
     C*                    ENDIF
     C*                    SETON                     55
      *
     C                   EXSR      GETDES
      *
     C     OHSTA         IFEQ      'Y'
     C     OIQORD        SUB       OIQSHP        #WRFRQ           11 1
     C                   ADD       #WRFRQ        L1SHP            11 1
     C                   ADD       #WRFRQ        SPDTOT           11 1
     C                   ADD       #WRFRQ        SHWTOT           11 1
     C                   ADD       #WRFRQ        SHCTOT           12 1
     C                   ELSE
     C     OIQORD        SUB       OIQSHP        #WRFRQ
     C                   ADD       #WRFRQ        SORD             11 1
     C                   ADD       #WRFRQ        ORDTOT           11 1
     C                   ADD       #WRFRQ        ORWTOT           11 1
     C                   ADD       #WRFRQ        ORCTOT           12 1
     C                   ENDIF
     C                   ADD       #WRFRQ        L1OPN            11 1
      *
      * ACCUMULATE TOTALS FOR DATE, LOCATION
      *
     C                   ADD       #WRFRQ        OPDTOT           11 1
     C                   ADD       #WRFRQ        OPWTOT           11 1
     C                   ADD       #WRFRQ        OPCTOT           12 1
      *
     C                   Z-ADD     OIDTRQ        OLDATE            6 0
     C                   MOVEL     OISHFR        SAVLOC            3
     C                   MOVEL     OIITEM        OITEM            12
     C                   MOVEL     OISIZE        OSIZE             3
     C                   MOVEL     DESP          ODESC            46
     C                   MOVEL     OIUUOM        OUM               2
     C                   SETON                                        55
     C                   ADD       1             FIRST
     C                   GOTO      NXT
      *
     C     END           TAG
     C     ORDTOT        IFGT      *ZEROS
     C                   EXCEPT    TL1
     C                   ENDIF
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
     C                   MOVEL     DESCO         DESP             40
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
     O                                           82 ' - Summary'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
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
     O          E            HDG            1
     O                                            9 'Requested'
     O                                           84 'Ship'
     O                                           93 'Qty'
     O                                          108 'STA Qty'
     O                                          119 'Total'
     O          E            HDG            1
     O                                            9 'Ship Date'
     O                                           18 'Item'
     O                                           46 'D e s c r i p t i o n'
     O                                           84 'From'
     O                                           79 'UM'
     O                                           95 'Ordered'
     O                                          108 'Ordered'
     O                                          120 'Ordered'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DETLS          1
     O                       OIDTRQ        Y      8
     O                       OITEM               21
     O                       OSIZE               24
     O                       ODESC               71
     O                       OUM                 83
     O                       SORD          MB    96
     O                       L1SHP         MB   108
     O                       L1OPN         MB   120
     O          E            TL1            1
     O                                          120 '--------'
     O                                          108 '--------'
     O                                           96 '--------'
     O          E            TL1            2
     O                                           67 'Total Ship Date:'
     O                       ODATE         YB    76
     O                       ORDTOT        MB    96
     O                       SPDTOT        MB   108
     O                       OPDTOT        MB   120
      *
