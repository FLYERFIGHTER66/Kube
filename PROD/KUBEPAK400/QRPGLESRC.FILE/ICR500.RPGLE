      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- ICR500
      *SYSTEM-------------- INVENTORY CONTROL
      *DESCRIPTION--------- MONTHLY INVENTORY TRANSACTION REGISTER
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFTINVTTP  IF   E           K DISK
     FFMWHSE    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFPRODCD   IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FICR500    O    F  120        PRINTER OFLIND(*INOF)
      *
     D MSG             S             20    DIM(4) CTDATA PERRCD(1)
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
     D  LACTP                  3      4  0
     D  LUSER                 10     19
     D  LTYPE                 20     20
     D  LLOC                  21     23
     D  LBDATE                24     29  0
     D  LEDATE                30     35  0
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
     C                   Z-ADD     1             FIRST             6 0
     C                   Z-ADD     1             CNT               6 0
      *
     C                   Z-ADD     LBDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         BDATE             5 0
     C                   Z-ADD     LEDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EDATE             5 0
      *
     C     LTYPE         IFEQ      'R'
     C                   SETON                                        04
     C                   ENDIF
     C     LTYPE         IFEQ      'A'
     C                   SETON                                        05
     C                   ENDIF
     C     LTYPE         IFEQ      'O'
     C                   SETON                                        06
     C                   ENDIF
     C     LTYPE         IFEQ      'I'
     C                   SETON                                        07
     C                   ENDIF
     C     LTYPE         IFEQ      ' '
     C                   SETON                                        08
     C                   ENDIF
      *
     C     LLOC          IFGT      *BLANKS
     C                   SETON                                        09
     C                   ENDIF
      *
     C     LUSER         IFGT      *BLANKS
     C                   SETON                                        10
     C                   ENDIF
      *
     C                   Z-ADD     1             CNT
     C     LCO           CHAIN(N)  FMCORG                             90
     C                   EXCEPT    HDG
      *
     C     LTYPE         SETLL     FTINVTTP
     C     NXT           TAG
     C                   SETOFF                                       20
     C                   SETOFF                                       212324
     C                   SETOFF                                       252728
     C                   SETOFF                                       808182
     C                   SETOFF                                       83
     C                   READ      FTINVTTP                               90
     C   90              GOTO      ENDP
      *
     C     ITSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   Z-ADD     ITTDAT        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ITDTE             5 0
      *
     C     ITDTE         IFLT      BDATE
     C     ITDTE         ORGT      EDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LTYPE         IFGT      *BLANKS
     C     ITTYPE        ANDNE     LTYPE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LUSER         IFGT      *BLANKS
     C     ITUSER        ANDNE     LUSER
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LLOC          IFGT      *BLANKS
     C     ITTWSE        ANDNE     LLOC
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     CNT           IFEQ      1
     C                   EXSR      GETTYP
     C                   EXCEPT    DETL1
     C                   ENDIF
      *
     C     CNT           IFGT      1
     C     ITTYPE        ANDNE     OLTYPE
     C                   EXSR      GETTYP
     C                   EXCEPT    DETL1
     C                   ENDIF
      *
     C                   MOVEL     ITUSER        USER              5
      *
     C     ITTWSE        CHAIN     FMWHSE                             22
      *
      * SETUP FOR OUTPUT
      *
     C     KEY18         KLIST
     C                   KFLD                    ITITEM
     C                   KFLD                    ITSIZE
     C                   KFLD                    ITTWSE
     C     KEY18         CHAIN     FMINVT                             33
     C                   EXSR      GETDES
      *
     C     ITVEND        IFGT      0
     C                   SETON                                        24
     C                   ENDIF
     C   24ITVEND        CHAIN     FMVEND                             44
     C  N44VMSTAT        IFEQ      'D'
     C                   SETON                                        44
     C                   ENDIF
      *
     C     ITVITM        IFGT      *BLANKS
     C                   SETON                                        21
     C                   ENDIF
      *
      * DETERMINE TRANSACTION TYPE
      *
     C     BY            TAG
     C     ITTYPE        IFEQ      'I'
     C                   SETON                                        80
     C                   ENDIF
     C     ITTYPE        IFEQ      'R'
     C                   SETON                                        81
     C                   ENDIF
     C     ITTYPE        IFEQ      'A'
     C                   SETON                                        82
     C                   ENDIF
     C     ITTYPE        IFEQ      'O'
     C                   SETON                                        83
     C                   ENDIF
      *
     C   83              MOVE      *BLANKS       TRNAMT
     C  N83              MOVEL     'Transact'    TRNAMT           16
     C  N83              MOVE      'ion Amt:'    TRNAMT
      *
      * DETERMINE IF COST DEVIATION, AND IF SO -
      * SET ON INDICATOR AND INCREMENT COUNTER
      *
     C     ITCDFL        COMP      'C'                                    95
     C   95CTR           ADD       1             CTR               4 0
     C   95TCTR          ADD       1             TCTR              4 0
      *
      * IF ADJUSTMENT DETERMINE WHETHER CASH ONLY ADJUSTMENT
      *
     C                   SETOFF                                       55
     C   82ITCFLG        COMP      'Y'                                    55
      *
      * ADD QUANTITY TO APPROPRIATE TRANSACTION TYPE ITEM TOTAL
      *
     C   80              ADD       ITTQTY        ITOT             11 1          ISSUES
     C   81              ADD       ITTQTY        RTOT             11 1          RECEIPTS
     C   82
     CANN55              ADD       ITTQTY        ATOT             11 1          ADJUSTMENTS
     C   83              ADD       ITTQTY        OTOT             11 1          ON P.O.
      *
      * ACCUMULATE VALUE OF TRANSACTION FOR TYPES I, R, A
      *
     C   80ITTQTY        MULT(H)   ITCOAV        FITOTX           12 2          ISSUES
     C   80FITOT$        ADD       FITOTX        FITOT$           12 2
      *
      * TURN SIGN TO NEGATIVE FOR ISSUES
      *
     C   80              Z-SUB     FITOT$        FITOTN           12 2
     C   81ITTQTY        MULT(H)   ITCOST        FRTOTX           12 2          RECEIPTS
     C   81FRTOT$        ADD       FRTOTX        FRTOT$           12 2
     C   82
     CANN55ITTQTY        MULT(H)   ITCOAV        FATOTX           12 2          ADJUSTMENTS
     C   82
     CAN 55              Z-ADD     ITCOST        FATOTX
     C   82FATOT$        ADD       FATOTX        FATOT$           12 2
      *
     C                   Z-ADD     ITTQTY        QTY               7 1
      *
     C     ITCOST        IFNE      *ZEROS
     C                   SETON                                        25
     C                   ENDIF
     C     ITCOAV        IFNE      *ZEROS
     C                   SETON                                        27
     C                   ENDIF
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   ADD       1             FIRST
     C                   ADD       1             CNT
     C                   MOVEL     ITTYPE        OLTYPE            1
     C                   SETON                                        77
      *
     C   27              EXCEPT    DETL5
      *
      * ADJUSTMENTS
      *
     C   82ITREAS        CHAIN     FPRODCD                            90
     C   82              EXCEPT    DETL4
      *
     C     ITDESC        IFGT      *BLANKS
     C                   SETON                                        23
     C                   ENDIF
     C     ITTREF        IFGT      *BLANKS
     C                   SETON                                        20
     C                   ENDIF
     C   20              EXCEPT    DETREF
     C   23              EXCEPT    DETDES
      *
     C   24              EXCEPT    DETL3
      *
      * ADD ITEM TOTALS TO LOCATION TOTALS
      *
     C                   ADD       ITOT          WITOT            11 1
     C                   ADD       RTOT          WRTOT            11 1
     C                   ADD       ATOT          WATOT            11 1
     C                   ADD       OTOT          WOTOT            11 1
      *
     C                   GOTO      NXT
      *
      * ADD LOCATION TOTALS TO COMPANY TOTALS
      *
     C                   ADD       WITOT         FITOT            11 1
     C                   ADD       WRTOT         FRTOT            11 1
     C                   ADD       WATOT         FATOT            11 1
     C                   ADD       WOTOT         FOTOT            11 1
      *
     C     ENDP          TAG
     C   77              EXCEPT    TLR
     C  N77              EXCEPT    TLRN
     C                   SETON                                        LR
      *
      *********
      * GETTYP
      *********
     C     GETTYP        BEGSR
     C     ITTYPE        IFEQ      'R'
     C                   MOVEL     MSG(1)        TDES             20
     C                   ENDIF
     C     ITTYPE        IFEQ      'A'
     C                   MOVEL     MSG(2)        TDES             20
     C                   ENDIF
     C     ITTYPE        IFEQ      'O'
     C                   MOVEL     MSG(3)        TDES             20
     C                   ENDIF
     C     ITTYPE        IFEQ      'I'
     C                   MOVEL     MSG(4)        TDES             20
     C                   ENDIF
     C                   ENDSR
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
     C                   MOVEL     DESCO         DESP             28
     C                   ENDSR
      *
     OICR500    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'                  APR500
     O                       LCO                 98                             APR500
     O                       PAGE          1    120
     O                                          114 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           48 'Monthly'
     O                                           70 'Inventory Transaction'
     O                                           79 'Register'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           13 'For Location:'
     O               09      LLOC                17
     O              N09                          17 'ALL'
     O                                           58 'For Accounting Period:'
     O                       LACTP               61
     O                       LBDATE        Y     72
     O                                           74 '-'
     O                       LEDATE        Y     83
     O               04                         120 'Receipts Only'
     O               05                         120 'Adjustments Only'
     O               06                         120 'On Purchase Order Only'
     O               07                         120 'Issues Only'
     O               08                         120 'For All Types'
     O          E            HDG            1
     O                                            9 'For User:'
     O               10      LUSER               20
     O              N10                          13 'ALL'
     O          E            HDG            1
     O                                           66 'Trans'
     O                                           93 'On'
     O                                          120 'Unit'
     O          E            HDG            1
     O                                            4 'Item'
     O                                           15 'Size'
     O                                           19 'Loc'
     O                                           38 'Description'
     O                                           52 'UM'
     O                                           57 'User'
     O                                           66 'Date'
     O                                           73 'Rec'
     O                                           84 'Adj'
     O                                           95 'Order'
     O                                          105 'Iss'
     O                                          120 'Cost'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL1          1
     O                                            6 'Type ='
     O                       ITTYPE               8
     O                       TDES                29
     O          E            DETL1          1
     O                                           24 '________________________'
     O          E            DETL        1  1
     O               25      ITCOST        L    120
     O               80      QTY           MB   108
     O               83      QTY           MB    97
     O               82 55                       89 'Cash Only Adj.'
     O               82N55   QTY           MB    86
     O               81      QTY           MB    75
     O                       ITTDAT        Y     67
     O                       USER                58
     O                       ITTUOM              52
     O                       DESP           B    49
     O                       ITTWSE         B    19
     O                       ITSIZE              15
     O                       ITITEM              12
     O          E            DETL5          1
     O                                           13 'Average Cost:'
     O                       ITCOAV        L     26
     O                       TRNAMT              56
     O                  80   FITOTX        MB    73
     O                  81   FRTOTX        MB    73
     O                  82   FATOTX        MB    73
     O          E            DETREF         1
     O                                           10 'Reference:'
     O                       ITTREF              41
     O          E            DETDES         1
     O                                            8 'Comment:'
     O                       ITDESC              40
     O          E            DETL4          1
     O                                           12 'Reason Code:'
     O                       ITREAS              16
     O                       PCDESC              47
     O          E            DETL3          1
     O                                            5 'Vend:'
     O                       ITVEND        Z     12
     O              N44      VMNAME         B    43
     O               44                          30 'Inactive Vendor'
     O               21                          51 'Item #:'
     O               21      ITVITM              82
     O               95                         120 '** Cost Deviation'
     O          E            TLR            1
     O                                           55 '** Report Totals:'
     O                       ITOT          M    108
     O                       OTOT          M     97
     O                       ATOT          M     86
     O                       RTOT          M     75
     O          E            TLRN           1
     O                                           55 '**** There Are No Transa'
     O                                           78 'ctions For The Report S'
     O                                           92 'elections ****'
      *
**
 Receipt
 Adjustment
 On Purchase Order
 Issue
