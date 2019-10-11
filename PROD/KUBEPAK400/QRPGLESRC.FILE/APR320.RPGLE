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
      *PROGRAM NAME-------- APR320
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- CASH REQUIREMENTS REPORT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFAPOPNDT  IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FAPR320    O    F  120        PRINTER OFLIND(*INOF)
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
     D  LDATE                  3      8  0
     D  LTOTAL                 9      9
     D  LSEQ                  10     10  0
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
      * 77 = PRINT TOTALS FOR EACH DATE
      *
     C     LTOTAL        IFEQ      'Y'
     C                   SETON                                        77
     C                   ENDIF
      *
     C     LSEQ          IFEQ      1
     C                   SETON                                        66
     C                   ENDIF
      *
     C                   Z-ADD     1             CNT               6 0
     C                   Z-ADD     1             VCNT              6 0
     C                   Z-ADD     0             VCNT3             6 0
      *
     C     LCO           CHAIN     FMCORG                             97
      *
     C                   Z-ADD     TDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         SDATE             5 0
      *
     C                   Z-ADD     LDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         RDATE             5 0
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      FAPOPNDT                               90
     C   90              GOTO      END
      *
     C     APCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     APCLCD        IFEQ      'Y'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     APSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     APDUE$        IFEQ      0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   Z-ADD     APDUDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ADATE             5 0
      *
     C     ADATE         IFGT      RDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     APVEND        CHAIN     FMVEND                             91
     C                   MOVEL     VMNAME        VNAME            19
     C     APVEND        IFNE      VVEND
     C     VCNT3         IFGT      0
     C                   EXCEPT    TLCUS
     C                   ENDIF
wjb  C                   Z-add     *Zero         L3$AMT           11 2
wjb  C                   Z-add     *Zero         L3DAVL            7 2
wjb  C                   Z-add     *Zero         L3NET$           11 2
wjb  C                   Z-add     *Zero         VCNT3
     C                   Z-add     APVEND        VVEND             6 0
     C                   ENDIF
wjb  C                   Add       1             VCNT3
      *
     C   77CNT           IFGT      1
     C     APDUDT        ANDNE     OLDATE
     C                   EXCEPT    TL1
     C                   Z-ADD     1             CNT
     C                   ENDIF
      *
     C                   EXCEPT    DETL1
      *
     C                   MOVEL     APTDES        DESC             19
     C                   Z-ADD     APDUDT        OLDATE            6 0
     C                   ADD       1             CNT
      *
      * CALCULATE NET DUE AND ACCUMULATE DATE AND COMPANY TOTALS
      *
     C                   Z-ADD     0             NETDUE           11 2
     C     APDAVL        SUB       APDTAK        REMDIS            7 2          ACTUAL DISC.TAK
     C     REMDIS        IFLE      0
     C                   Z-ADD     0             APDCDT
     C                   ENDIF
     C     REMDIS        IFNE      0
     C     APDCDT        ANDGT     0
     C                   Z-ADD     APDCDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         DSDTE             5 0
     C                   ENDIF
     C     SDATE         IFGT      DSDTE
     C                   Z-ADD     0             APDCDT
     C                   Z-ADD     0             REMDIS
     C                   ENDIF
     C     APDUE$        SUB       REMDIS        NETDUE                         EFD 11/9
      *
wjb  C                   ADD       APDUE$        L3$AMT           11 2
wjb  C                   ADD       REMDIS        L3DAVL            7 2
wjb  C                   ADD       NETDUE        L3NET$           11 2
      *
     C                   ADD       APDUE$        L2$AMT           11 2
     C                   ADD       REMDIS        L2DAVL            7 2
     C                   ADD       NETDUE        L2NET$           11 2
      *
     C                   ADD       APDUE$        CO$AMT           11 2
     C                   ADD       REMDIS        CODAVL            7 2
     C                   ADD       NETDUE        CONET$           11 2
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   SETON                                        88
     C                   EXCEPT    DETL1
     C                   ENDDO
      *
     C                   SETOFF                                       88
     C   77              EXCEPT    DETL1
     C                   EXCEPT    DETL
     C                   ADD       1             VCNT
     C                   GOTO      NXT
      *
     C     END           TAG
     C     VCNT          IFGT      1
     C                   SETON                                        78
     C                   ENDIF
     C   77
     CAN 78              EXCEPT    TL1
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *
     OAPR320    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           59 'Accounts Payable'
     O                                           77 'Cash Requirements'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O               66                          24 'Vendor Alpha Within Date'
     O              N66                          24 'Vendor Number Within Dat'
     O              N66                          25 'e'
     O                                           63 'Due On Or Before:'
     O                       LDATE         Y     73
     O          E            HDG            1
     O                                           74 '*** Invoice ***'
     O                                           80 'Due'
     O                                           92 'Balance'
     O                                          108 '* Discount *'
     O          E            HDG            0
     O                                            6 'Vendor'
     O                                           20 'Name'
     O                                           35 'Desc'
     O                                           54 'Voucher'
     O                                           65 'Number'
     O                                           74 'Date'
     O                                           81 'Date'
     O                                           90 'Due'
     O                                          108 'Avail   Date'
     O                                          120 'Net Amount'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL1          0
     O                       APVEND        Z      6
     O                       VNAME               26
     O               88                          38 '(Continued)'
     O          E            DETL           1
     O                       NETDUE        M    120
     O                       APDCDT             109 '  /  / 0'
     O                       REMDIS        MB   100
     O                       APDUE$        M     93
     O                       APDUDT        Y     82
     O                       APIVDT        Y     73
     O                       APINV#              64
     O                       APVOUC        Z     53
     O                       DESC                46
     O          E            TLCUS          2
     O                       L3NET$        MB   120
     O                       L3DAVL        MB   100
     O                       L3$AMT        MB    93
     O                                           82 'Vendor Subtotal:'
     O          E            TL1            1
     O                                           92 '---------'
     O                                          100 '-------'
     O                                          119 '---------'
     O          E            TL1            2
     O                       L2NET$        MB   120
     O                       L2DAVL        MB   100
     O                       L2$AMT        MB    93
     O                                           73 '** Total Due On:'
     O                       OLDATE        Y     82
     O          E            TLR            1
     O               78                          92 '========='
     O               78                         100 '======='
     O               78                         119 '========='
     O          E            TLR            1
     O               78      CONET$        MB   120
     O               78      CODAVL        MB   100
     O               78      CO$AMT        MB    93
     O               78                          73 '*** Total For Company:'
     O               78      LCO           Z     79
     O              N78                          59 '*** No Open Payables D'
     O              N78                          75 'ue On Or Before:'
     O              N78      LDATE         Y     84
      *
