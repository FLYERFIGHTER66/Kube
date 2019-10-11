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
      *PROGRAM NAME-------- APR396
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *DESCRIPTION--------- OPEN ACCOUNTS PAYABLE LIST BY ALPHA - MTHLY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *       10/17/99 GD LOG #2 CORRECT LOGIC FOR GETPAY
      * EFD01 01/27/02 GD DO NOT PRINT IF AMOUNT DUE EQ 0
      *
      *
     FFAPOPN    IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFAPDTP    IF   E           K DISK
     FAPR395    O    F  120        PRINTER OFLIND(*INOF)
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
     D  LSEQ                   5      5  0
     D  LBDATE                 6     11  0
     D  LEDATE                12     17  0
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
      *
     C                   Z-ADD     1             FIRST             6 0
     C                   Z-ADD     1             CNT               6 0
      *
     C                   Z-ADD     LEDATE        ##MDY             6 0
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN     FMCORG                             97
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   Z-ADD     0             AMTPD
     C                   Z-ADD     0             AMTDIS
     C                   SETOFF                                       44
     C                   READ      FAPOPN                                 90
     C   90              GOTO      END
      *
     C     APCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     APSTAT        IFEQ      'D'                                          EFD
     C     APCHEK        ANDEQ     0                                            EFD
     C                   GOTO      NXT                                          EFD
     C                   ENDIF                                                  EFD
      *
      *  DO NOT INCLUDE ON REPORT IF ACCTG DATE HIGHER THAN PROMPT
      *
     C                   Z-ADD     0             ADATE
     C                   Z-ADD     APAPER        ##MDY             6 0
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
EFD01C     APSTAT        IFEQ      'D'                                          EFD
EFD01C     APDUE$        ANDEQ     0                                            EFD
EFD01C                   GOTO      NXT                                          EFD
EFD01C                   ENDIF                                                  EFD
      *
EFD01C     APSTAT        IFEQ      'X'                                          EFD
EFD01C                   GOTO      NXT                                          EFD
EFD01C                   ENDIF                                                  EFD
      *
     C*          APCLCD    IFEQ 0
     C*          APCKDT    ANDLE0
     C*                    GOTO NXT
     C*                    ENDIF
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
     C                   ENDIF
      *
      * IS INVOICE ON HOLD ?
      *
     C     APTBPD        IFEQ      'H'
     C                   SETON                                        44
     C                   ENDIF
      *
      * PUT INCOMING DATE PD IN APOPN INTO CENTURY DATE
      * DO NOT CK APDTP IF PAID DATE LOWER THAN PROMPT
      *
     C     APPAID        IFEQ      *ZEROS
     C                   GOTO      NOPAY
     C                   END
      *
     C                   Z-ADD     APCKDT        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         PDATE             5 0
      *
     C     PDATE         IFGT      RDATE
     C                   EXSR      GETPAY
     C                   END
      *
     C   77              SUB       AMTPD         APPAID
     C   77APDTAK        IFGT      0
     C                   SUB       AMTDIS        APDTAK
     C                   ENDIF
      *
     C     NOPAY         TAG
      *
      * CALCULATE NET DUE AND ACCUMULATE COMPANY TOTALS
      *
     C                   Z-ADD     0             RESULT            9 2
     C                   Z-ADD     0             NETDUE            9 2
     C                   Z-ADD     0             DAVL
     C     APDAVL        IFGT      0                                            EFD
     C     APDAVL        SUB       APDTAK        DAVL              7 2
     C                   ENDIF                                                  EFD
     C     APDAVL        IFEQ      0                                            EFD
     C     APDTAK        ANDGT     0                                            EFD
     C                   Z-ADD     APDTAK        DAVL                           EFD
     C                   ENDIF                                                  EFD
     C     AP$AMT        SUB       APPAID        NETDUE            9 256
     C   56NETDUE        SUB       APDTAK        NETDUE
     C     NETDUE        IFEQ      0
     C                   GOTO      NOPRT
     C                   ENDIF
      *
     C                   ADD       AP$AMT        V$AMT             9 2
     C                   ADD       APPAID        VPAID             9 2
     C                   ADD       NETDUE        VNET$             9 2
     C                   ADD       APDTAK        VDTAK             9 2
     C   50              ADD       DAVL          VDAVL             9 2
      *
     C                   ADD       AP$AMT        CO$AMT            9 2
     C                   ADD       APPAID        COPAID            9 2
     C                   ADD       NETDUE        CONET$            9 2
     C                   ADD       APDTAK        CODTAK            9 2
     C   50              ADD       DAVL          CODAVL            9 2
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C     CNT           IFNE      1
     C                   EXCEPT    DOF
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
      **********
      * GETPAY *
      **********
      *
      * GET PAYMENTS MADE AFTER PROMPT DATE FROM APDTP FILE
      *
     C     GETPAY        BEGSR
     C                   Z-ADD     0             AMTPD
     C                   Z-ADD     0             AMTDIS
     C                   Z-ADD     0             APCYMD            7 0
     C     ADKEY         KLIST
     C                   KFLD                    APVEND
     C                   KFLD                    APCOMP
     C                   KFLD                    APCYMD
     C                   KFLD                    APVOUC
     C                   KFLD                    APINV#
     C*          ADKEY     SETLLFAPDTP
     C     APVEND        SETLL     FAPDTP
     C     REREAD        TAG
     C*          ADKEY     READEFAPDTP                   65
     C     APVEND        READE     FAPDTP                                 65
     C   65              GOTO      ENDGET
     C     ATVOUC        IFNE      APVOUC
     C                   GOTO      REREAD
     C                   ENDIF
     C     ATINV#        IFNE      APINV#
     C                   GOTO      REREAD
     C                   ENDIF
     C     ATCOMP        IFNE      APCOMP
     C                   GOTO      REREAD
     C                   ENDIF
     C                   Z-ADD     ATCKDT        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         DDATE             5 0
     C     DDATE         IFLE      RDATE
     C                   GOTO      REREAD
     C                   ENDIF
     C                   ADD       ATPAID        AMTPD             9 2
     C                   ADD       ATDTAK        AMTDIS            7 2
     C                   SETON                                        77
     C                   GOTO      REREAD
     C     ENDGET        ENDSR
      *
     OAPR395    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           61 'Monthly Open Accounts'
     O                                           69 'Payable'
     O                                           76 'As of:'
     O                       LEDATE        Y     85
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                            9 'Vendor'
     O                                           28 'Transaction'
     O                                           40 'Voucher'
     O                                           51 'Invoice'
     O                                           60 'Invoice'
     O                                           67 'Due'
     O                                           79 'Invoice'
     O                                           88 'Disc.'
     O                                           95 'Disc.'
     O                                          107 'Amount'
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
     O                                           95 'Taken'
     O                                          107 'Paid'
     O                                          120 'Amt Due'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DOF            1
     O                       APVEND        Z      6
     O                       VMNAME              38
     O          E            DETL           1
     O                       NETDUE        MB   120
     O                       APPAID        MB   108
     O                       APDTAK        MB    96
     O               50      DAVL          MB    88
     O                       AP$AMT        MB    80
     O               44                           6 '*Held*'
     O                       DESC                33
     O                       APVOUC        Z     40
     O                       APINV#              51
     O                       APIVDT        Y     60
     O                       APDUDT        Y     69
     O          E            TL1            1
     O                                           80 '----------'
     O                                           88 '------'
     O                                           96 '------'
     O                                          108 '---------'
     O                                          120 '-----------'
     O          E            TL1            1
     O                                           61 '** Vendor Totals **'
     O                       VNET$         MB   120
     O                       VPAID         MB   108
     O                       VDTAK         MB    96
     O                       VDAVL         MB    88
     O                       V$AMT         MB    80
     O          E            TLR         1  1
     O                                           80 '=========='
     O                                           88 '======'
     O                                           96 '======'
     O                                          108 '========='
     O                                          120 '==========='
     O          E            TLR            1
     O                                           38 'Total Open Accounts'
     O                                           50 'Payable For'
     O                                           58 'Company'
     O                       APCOMP        Z     61
     O                       CONET$        MB   120
     O                       COPAID        MB   108
     O                       CODTAK        MB    96
     O                       CODAVL        MB    88
     O                       CO$AMT        MB    80
      *
