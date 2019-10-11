      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC. 1999
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
      *PROGRAM NAME-------- APR390
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *DESCRIPTION--------- OPEN ACCOUNTS PAYABLE BY VENDOR NUMBER
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFAPOPN    IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FAPR390    O    F  120        PRINTER OFLIND(*INOF)
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
     D                UDS
     D  LCO                    1      2  0
     D  LSEQ                   3      3  0
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
     C                   Z-ADD     1             FIRST             6 0
     C                   Z-ADD     1             CNT               6 0
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LSEQ          IFEQ      1
     C                   SETON                                        66
     C                   ENDIF
      *
     C                   Z-ADD     TDATE         ##MDY             6 0
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
     C     LCO           CHAIN     FMCORG                             97
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       44
     C                   READ      FAPOPN                                 90
     C   90              GOTO      END
      *
     C     APCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     APCLCD        IFEQ      'Y'
     C     APCLCD        OREQ      'C'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     APDUE$        IFEQ      0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     FIRST         IFNE      1
     C     APVEND        ANDNE     OLVEND
     C     CNT           ANDGT     1
     C                   EXCEPT    TL1
     C                   Z-ADD     1             CNT
     C                   ENDIF
      *
      * AT NEW VENDOR, CHAIN TO GET VENDOR NAME
      *
     C     CNT           IFEQ      1
     C     APVEND        CHAIN     FMVEND                             12
     C  N12VMSTAT        COMP      'D'                                    12
     C                   ENDIF
      *
      * IS INVOICE ON HOLD ?
      *
     C     APTBPD        IFEQ      'H'
     C                   SETON                                        44
     C                   ENDIF
      *
      * PUT APOPN DISCOUNT DUE DATE INTO CENTURY DATE
      *
     C                   Z-ADD     0             DCDTE
     C     APDCDT        IFGT      0
     C                   Z-ADD     APDCDT        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         DCDTE             5 0
     C                   ENDIF
      *
      * CALCULATE IF DISCOUNT IS WITHIN TERMS
      *
     C     DCDTE         IFGE      RDATE
     C                   SETON                                        50
     C                   ADD       APDAVL        DAVL              7 2
     C                   ELSE
     C                   Z-ADD     0             DAVL
     C                   ENDIF
      *
      * CALCULATE NET DUE AND ACCUMULATE COMPANY TOTALS
      *
     C                   Z-ADD     0             RESULT            9 2
     C                   Z-ADD     0             NETDUE            9 2
     C                   Z-ADD     0             PAID
     C                   ADD       APPAID        PAID              9 2
     C     DAVL          SUB       APDTAK        DAVL
     C     AP$AMT        SUB       PAID          NETDUE            9 256
     C   50NETDUE        SUB       DAVL          NETDUE
     C   56NETDUE        SUB       APDTAK        NETDUE
     C     NETDUE        IFEQ      *ZEROS
     C                   GOTO      NOPRT
     C                   ENDIF
     C                   Z-ADD     AP$AMT        $AMT              9 2
      *
     C                   ADD       AP$AMT        V$AMT             9 2
     C                   ADD       PAID          VPAID             9 2
     C                   ADD       NETDUE        VNET$             9 2
     C                   ADD       APDTAK        VDTAK             9 2
     C   50              ADD       DAVL          VDAVL             9 2
      *
     C                   ADD       AP$AMT        CO$AMT            9 2
     C                   ADD       PAID          COPAID            9 2
     C                   ADD       NETDUE        CONET$            9 2
     C                   ADD       APDTAK        CODTAK            9 2
     C   50              ADD       DAVL          CODAVL            9 2
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C     CNT           IFNE      1
     C                   SETON                                        60
     C                   EXCEPT    DOF
     C                   SETOFF                                       60
     C                   ENDIF
     C                   ENDDO
     C     CNT           IFEQ      1
     C                   EXCEPT    DOF
     C                   ENDIF
     C                   MOVEL     APTDES        DESC             26
     C                   EXCEPT    DETL
     C                   ADD       1             FIRST
     C                   ADD       1             CNT
     C     NOPRT         TAG
     C                   Z-ADD     APVEND        OLVEND            6 0
     C                   GOTO      NXT
      *
     C     END           TAG
     C     CNT           IFGT      1
     C                   EXCEPT    TL1
     C                   ENDIF
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *
     OAPR390    E            HDG            1 03
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
     O                                           71 'Open Accounts Payable'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O               66                          21 'Vendor Alpha Sequence'
     O              N66                          22 'Vendor Number Sequence'
     O          E            HDG            1
     O                                            6 'Vendor'
     O                                           28 'Transaction'
     O                                           40 'Voucher'
     O                                           51 'Invoice'
     O                                           60 'Invoice'
     O                                           67 'Due'
     O                                           79 'Invoice'
     O                                           88 'Disc.'
     O                                           99 'Amount'
     O                                          108 'Disc.'
     O                                          118 'Net'
     O          E            HDG            0
     O                                            6 'Number'
     O                                           12 'Name'
     O                                           28 'Description'
     O                                           37 '#'
     O                                           48 '#'
     O                                           68 'Date      Date'
     O                                           79 'Amount'
     O                                           88 'Avail'
     O                                           99 'Paid'
     O                                          108 'Taken'
     O                                          120 'Amt Due'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DOF            1
     O                       APVEND        Z      6
     O                       VMNAME              37
     O               60                          49 '(Continued)'
     O          E            DETL           1
     O                       NETDUE        MB   120
     O                       APDTAK        M    108
     O                       PAID          MB   100
     O               50      DAVL          MB    89
     O                       $AMT          MB    80
     O                       APDUDT        Y     69
     O                       APIVDT        Y     60
     O                       APINV#              51
     O                       APVOUC        Z     40
     O                       DESC                33
     O               44                           6 '*Held*'
     O          E            TL1            1
     O                                           79 '----------'
     O                                           88 '------'
     O                                           99 '---------'
     O                                          108 '------'
     O                                          120 '-----------'
     O          E            TL1            1
     O                                           68 '** Vendor Totals **'
     O                       VNET$         MB   120
     O                       VDTAK         MB   108
     O                       VPAID         MB   100
     O                       VDAVL         MB    89
     O                       V$AMT         MB    80
     O          E            TLR         1  1
     O                                           79 '=========='
     O                                           88 '======'
     O                                           99 '========='
     O                                          108 '======'
     O                                          120 '==========='
     O          E            TLR            1
     O                                           38 'Total Open Accounts'
     O                                           50 'Payable For'
     O                                           58 'Company'
     O                       APCOMP        Z     61
     O                       CONET$        MB   120
     O                       CODTAK        MB   108
     O                       COPAID        MB   100
     O                       CODAVL        MB    89
     O                       CO$AMT        MB    80
      *
