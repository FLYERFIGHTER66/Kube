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
      *            EFD ENTERPRISES, INC.  215-957-1730
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR605
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- SUMMARY ROUTE REPORT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFHORDRTE  IF   E           K DISK
     FFIORDR    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMROUT    IF   E           K DISK
     FBIR600    O    F  120        PRINTER OFLIND(*INOF)
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
     D                UDS
     D  LCO                    1      2  0
     D  LBRTE                  3      4
     D  LERTE                  5      6
     D  LBEGDT                33     37  0
     D  LBSHFR                43     45
     D  LESHFR                46     48
     D  LBDATE                49     54  0
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
     C                   ADD       1             FIRST             6 0
      *
     C     LCO           CHAIN     FMCORG                             88
      *
     C     LBRTE         IFGT      *BLANKS
     C                   SETON                                        60
     C                   ENDIF
      *
     C     LBSHFR        IFGT      *BLANKS
     C     LESHFR        ORGT      *BLANKS
     C                   SETON                                        63
     C                   ENDIF
      *
     C     LBDATE        IFGT      0
     C                   SETON                                        62
     C                   ENDIF
      *
     C                   EXCEPT    HDG
     C                   Z-ADD     1             RTE               6 0
      *
     C     NXT           TAG
      *
     C                   READ      FHORDRTE                               77
     C   77              GOTO      END
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
     C   55FIRST         IFGT      1
     C     OHROUT        ANDNE     ORTE
     C                   EXCEPT    TL1
     C                   Z-ADD     1             RTE
     C                   ENDIF
      *
     C                   MOVEL     OHROUT        ORTE              2
      *
     C     OHORD#        SETLL     FIORDR
     C     NXTI          TAG
     C                   SETOFF                                       12
     C                   READE     FIORDR                                 50
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
      *
     C   55RTE           IFEQ      1
     C     OHROUT        CHAIN     FMROUT                             90
     C                   EXCEPT    HDG1
     C                   ENDIF
      *
     C   50
     CAN 55              EXCEPT    DETL
     C                   ADD       1             FIRST
     C   50              GOTO      NXT
      *
      * ACTIVE ORDER
      *
     C     OISTAT        IFEQ      'D'
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     OIQORD        SUB       OIQSHP        QTYOPN           11 1
     C     QTYOPN        IFLE      0
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     OIDTRQ        IFNE      LBDATE
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C                   SETON                                        55
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
     C  N12              ADD       QTYORD        CSTOTL           11 1
     C  N12              ADD       #LINNT        ODTOTL            9 2
     C   12              ADD       OIUPRI        ODTOTL
      *
     C                   ADD       CSTOTL        CSRTTL           11 1
     C                   ADD       ODTOTL        ODRTTL            9 2
      *
     C     OIITYP        IFEQ      'F'
     C     OIITYP        OREQ      'S'
     C                   SETON                                        12
     C                   ENDIF
      *
     C                   GOTO      NXTI
      *
     C     END           TAG
     C                   EXCEPT    TL1
     C                   SETON                                        LR
      *
     OBIR600    E            HDG            1 03
     O                                            6 'BIR605'
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                       PAGE          Z    120
     O                                          114 'Page'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           70 'Summary Route Report'
     O          E            HDG            2
     O                                           20 'Requested Ship Date:'
     O                       LBDATE        Y     29
     O               63                         110 'Ship From Range:'
     O               63      LBSHFR             114
     O               63                         116 '-'
     O               63      LESHFR             120
     O              N63                         120 'Include All Ship Froms'
     O               60                          64 'Requested Routes:'
     O               60      LBRTE               67
     O               60                          70 'To'
     O               60      LERTE               73
     O              N60                          69 'Include All Routes'
     O          E            HDG            1
     O                                           13 'Order'
     O                                           60 'Ship'
     O                                           85 'Total Amount'
     O          E            HDG            0
     O                                            5 'Stop'
     O                                           13 'Number'
     O                                           23 'Customer'
     O                                           60 'From'
     O                                           70 'Quantity'
     O                                           84 'of Order'
     O                                          115 'Spec. Instructions'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            HDG1           0
     O                                            6 'Route:'
     O                       OHROUT               9
     O                       RTDESC              40
     O          E            HDG1           1
     O                                           24 '________________________'
     O                                           40 '________________'
     O          E            DETL           1
     O                       OHSTOP        Z      4
     O                       OHORD#        Z     12
     O                       OHCUST        Z     20
     O                       OHNAME              55
     O                       OHSHFR              60
     O                       CSTOTL        MB    70
     O                       ODTOTL        MB    85
     O                       OHSPIN             120
     O          E            TL1         1  2
     O                                           45 'Route:'
     O                       ORTE                48
     O                                           56 'Total:'
     O                       CSRTTL        MB    70
     O                       ODRTTL        MB    85
