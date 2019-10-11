      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.   .  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES INC.      215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR490
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- MONTHLY SALES JOURNAL
      *DESCRIPTION--------- FOR EACH DAY INVOICES ARE LISTED SHOWING
      *                     DETAILS FOR EACH LINE ITEM.  LINE
      *                     ITEM EXTENDED AMTS, INVOICE TOTALS, &
      *                     DAILY TOTALS CALCULATED.
      *
      *
      *
      *    CHANGE--DATE-------DESCRIPTION
      *
      *  25 -      INVOICE TRANSACTION
      *  26 -      CREDIT MEMO TRANS.
      *  27 -      INVOICE ONLY CODE=Y
      *  50 -      ZERO DISCOUNT
      *  51 -      ZERO TRADE DISCOUNT
      *
     FFMSALEDI  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMSLSM    IF   E           K DISK
     FBIR490    O    F  120        PRINTER OFLIND(*INOF)
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
     D  LACTP                  3      4  0
     D  LBDATE                 5     11  0
     D  LEDATE                12     18  0
     D  LINCL                 19     19  0
     D  LSLSM                 20     21
     D  LCUST                 22     27  0
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
     C     NXT           TAG
     C                   READ      FMSALEDI                               90
     C   90              GOTO      END
      *
     C     MSSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   60MSTTYP        IFEQ      05
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   61MSTTYP        IFEQ      01
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     MSCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     MSTDAT        IFLT      LBDATE
     C     MSTDAT        ORGT      LEDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
      * INVOICE TOTALS
      *
     C     FIRST         IFGT      1
     C     MSINV#        ANDNE     OLINV#
     C                   EXCEPT    TL1
     C                   Z-ADD     0             IDISAM
     C                   Z-ADD     0             ITRDSC
     C                   Z-ADD     1             FINV
     C                   ENDIF
      *
      * DATE TOTALS
      *
     C     FIRST         IFGT      1
     C     MSTDAT        ANDNE     OLDATE
     C                   EXCEPT    TL2
     C                   Z-ADD     0             DDISAM
     C                   Z-ADD     0             DTRDSC
     C                   Z-ADD     1             FINV
     C                   ENDIF
     C                   Z-ADD     MSTDAT        OLDATE            7 0
      *
     C     FINV          IFEQ      1
     C     MSCUST        CHAIN     FMCUST                             11
     C  N11CMSTAT        COMP      'D'                                    11
      *
     C     MSSLM1        CHAIN     FMSLSM                             11
     C                   Z-ADD     MSINV#        OLINV#            6 0
      *
     C                   Z-ADD     MSTDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         TRDTE             6 0
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
     C                   EXCEPT    DTL1
     C                   ENDIF
      *
     C                   ADD       1             FINV
     C                   ADD       1             FIRST
     C                   ADD       1             CNT
      *
      * CALCULATE GROSS AMT, NET AMT, DISCOUNT AMOUNT
      *
     C                   Z-ADD     MSQSHP        QTYORD
     C                   Z-ADD     MSUPRI        VUPRIC
     C                   Z-ADD     MSDIS1        VDISC
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
     C                   Z-ADD     #LINGR        EXAMT             9 2
     C                   Z-ADD     #LINNT        NETAMT            9 2
     C                   Z-ADD     #LINDS        DISAMT            7 2    50
      *
     C                   ADD       MSEXT$        IEXAMT            9 2
     C                   ADD       MSEXT$        DEXAMT            9 2
     C                   ADD       MSEXT$        CEXAMT           10 2
     C                   ADD       NETAMT        INETAM            9 2
     C                   ADD       NETAMT        DNETAM            9 2
     C                   ADD       NETAMT        CNETAM           10 2
      *
      * REVERSE SIGN ON DISCOUNT AMOUNT
      *
     C                   Z-SUB     DISAMT        DISAMT
     C     DISAMT        ADD       IDISAM        IDISAM            9 2
      *
      * CHECK FOR TRANSACTION TYPE AND INVOICE ONLY CODE
      *
     C     MSTTYP        COMP      01                                     25
     C  N25MSTTYP        COMP      05                                     26
     C   25MSIOCD        COMP      'Y'                                    27
      *
     C                   ADD       IDISAM        DDISAM            9 2
     C                   Z-ADD     INETAM        PRICE1            9 2
     C                   Z-ADD     MSTRDC        DISHLD            4 2    51
     C  N51              MOVE      DISHLD        DISREF            4 4
     C  N511             SUB       DISREF        DISREF
     C  N51PRICE1        MULT      DISREF        PRICE1
     C     INETAM        SUB       PRICE1        ITRDSC            9 2
      *
      * REVERSE THE SIGN FOR TRADE DISCOUNT
      *
     C                   Z-SUB     ITRDSC        ITRDSC
     C                   ADD       ITRDSC        DTRDSC            9 2
     C                   ADD       DDISAM        CDISAM           10 2
     C                   ADD       DTRDSC        CTRDSC           10 2
      *
     C     KEY18         KLIST
     C                   KFLD                    MSITEM
     C                   KFLD                    MSSIZE
     C                   KFLD                    MSWHSE
     C     KEY18         CHAIN     FMINVT                             90
     C                   EXSR      GETDES
      *
     C                   EXCEPT    DTL2
     C                   SETON                                        77
     C                   Z-ADD     0             EXAMT
     C                   Z-ADD     0             NETAMT
     C                   GOTO      NXT
      *
     C     END           TAG
     C   77              EXCEPT    TL1
     C   77              EXCEPT    TL2
     C   77              EXCEPT    TLR
     C  N77              EXCEPT    TLRN
     C                   SETON                                        LR
      *
      *********
      * GETDES
      *********
     C     GETDES        BEGSR
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'I'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         DESP             45
     C                   ENDSR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     1             FIRST             6 0
     C                   Z-ADD     1             CNT               6 0
     C                   Z-ADD     1             FINV              6 0
      *
     C                   Z-ADD     LBDATE        ##CYMD            7 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##MDY             6 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##MDY         PERBEG            6 0
      *
     C                   Z-ADD     LEDATE        ##CYMD            7 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##MDY             6 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##MDY         PEREND            6 0
      *
      * INCLUDE 1 = INVOICES  2 = CREDIT MEMOS  3 = BOTH
      *
     C     LINCL         IFEQ      1
     C                   SETON                                        60
     C                   ENDIF
     C     LINCL         IFEQ      2
     C                   SETON                                        61
     C                   ENDIF
      *
      * INCLUDE SPECIFIC SALESPERSON
      *
     C     LSLSM         IFGT      *BLANKS
     C                   SETON                                        20
     C                   ENDIF
      *
      * INCLUDE ONLY SPECIFIC SALES CUSTOMER
      *
     C     LCUST         IFGT      0
     C                   SETON                                        30
     C                   ENDIF
      *
     C     LCO           CHAIN     FMCORG                             97
     C                   EXCEPT    HDG
      *
     C                   ENDSR
      *
     OBIR490    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                                          114 'Page'
     O                       PAGE          1    120
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           71 'Monthly Sales Journal'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           55 'For Period:'
     O                       PERBEG        Y     64
     O                                           66 '-'
     O                       PEREND        Y     75
     O          E            HDG            1
     O                                            6 'Inv #'
     O                                           15 'S/A #'
     O*                                  32 'Customer'
     O                                           53 'A/R #'
     O                                           61 'Date'
     O                                           69 'Ord #'
     O                                           85 'Qty'
     O                                           95 'Unit'
     O                                          107 'Merch.'
     O                                          117 'Net'
     O          E            HDG            1
     O                                            4 'Item'
     O                                           19 'Seq'
     O                                           27 'Pr Cl'
     O                                           77 'UM'
     O                                           86 'Ship'
     O                                           95 'Price'
     O                                          107 'Amount'
     O                                          119 'Amount'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O*       E  0             DTL1
     O          E            DTL1           1
     O                       MSINV#        Z      6
     O                       MSSUFF               8
     O                       MSCUST        Z     15
     O                 N11   CMNAME              46
     O                  11                       36 '*Inactive Customer*'
     O                       CMARCU        Z     53
     O                       TRDTE         Y     62
     O                       MSORD#        Z     69
     O*                        MSSLM1    79
     O*                        SMNAME   110
     O          E            DTL1           1
     O                                           24 '________________________'
     O                                           46 '______________________'
     O          E            DTL2           1
     O                       NETAMT        JB   119
     O                       MSEXT$        JB   107
     O                       MSUPRI        L     97
     O                       MSQSHP        M     87
     O                       MSUUOM              77
     O                       DESP           B    73
     O                       MSPCL2              27
     O                       MSPCL1              24
     O                       MSSEQ#        Z     19
     O                       MSSIZE              15
     O                       MSITEM              12
     O                    N50                   120 'Q'
     O          E            TL1         1  1
     O                                           77 'Invoice Totals:'
     O                       IEXAMT        JB   107
     O                       INETAM        JB   119
     O                    N51                   120 'T'
     O          E            TL2            2
     O                                           77 'Total For Date:'
     O                       TRDTE         Y     86
     O                       DEXAMT        JB   107
     O                       DNETAM        JB   119
     O          E            TLR            1
     O                                           25 'Total For Company:'
     O                       MSCOMP              32
     O                                           55 'Merchandise Amount'
     O                       CEXAMT        JB    79
     O          E            TLR            1
     O                                           52 'Qty. Disc. Amt.'
     O                       CDISAM        JB    79
     O                                          110 'Q = Qty. Disc. Applied'
     O          E            TLR            1
     O                                           47 'Net Amount'
     O                       CNETAM        JB    79
     O          E            TLR            2
     O                                           52 'Trd. Disc. Amt.'
     O                       CTRDSC        JB    79
     O                                          110 'T = Trd. Disc. Applied'
     O          E            TLRN           1
     O                                           55 '**** There Are No Transa'
     O                                           78 'ctions For The Report S'
     O                                           92 'elections ****'
