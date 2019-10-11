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
      *PROGRAM NAME-------- APR340
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- CHECK REGISTER - POST PROCEDURE
      *
      *           CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFTOPAYCK  IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFAPCTL    UF   E           K DISK
     FAPR340    O    F  120        PRINTER OFLIND(*INOF)
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
      *
     D  LCO                    1      2  0
     D  LDATE                  3      8  0
     D  LDISB                  9      9
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
     C     LCO           CHAIN     FMCORG                             97
      *
     C                   Z-ADD     1             CNT               6 0
     C                   Z-ADD     1             VCNT              6 0
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      FTOPAYCK                               90
     C   90              GOTO      END
      *
     C     TPCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     VCNT          IFNE      1
     C     TPCHEK        ANDNE     OLCHEK
     C                   EXCEPT    TL1
     C                   Z-ADD     1             CNT
     C                   SETON                                        10
     C                   ENDIF
      *
     C     CNT           IFEQ      1
     C     TPVEND        CHAIN(N)  FMVEND                             11
     C                   SETON                                        10
     C                   ENDIF
      *
      * ADD DISC TAKEN TO NET PAID TO GET GROSS AMOUNT
      *
     C     TP$TOP        ADD       TPDTAK        GROSS            11 2
      *
      * ACCUMULATE CHECK TOTALS AND COMPANY TOTALS
      *
     C                   ADD       GROSS         CKGROS           11 2
     C                   ADD       TP$TOP        CKPAID           11 2
     C                   ADD       TPDTAK        CKDISC            9 2
      *
     C                   ADD       GROSS         COGROS           11 2
     C                   ADD       TP$TOP        COPAID           11 2
     C                   ADD       TPDTAK        CODISC            9 2
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
      *
     C                   EXCEPT    DETL
     C                   Z-ADD     TPCHEK        OLCHEK            6 0
     C                   ADD       1             CNT
     C                   ADD       1             VCNT
     C                   SETOFF                                       10
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    TL1
     C                   EXCEPT    TLR
      *
     C     LCO           CHAIN     FAPCTL                             90
     C     TPCHEK        ADD       1             AZCHEK
     C                   Z-ADD     TDATE         AZDTCP
     C                   MOVEL     'N'           AZOKC
     C                   MOVEL     'N'           AZCKR
     C                   MOVEL     'N'           AZPAYS
     C                   Z-ADD     TDATE         AZDTLA
     C                   Z-ADD     TIMOD         AZTIME
     C                   MOVEL     USERID        AZUSER
     C                   Z-ADD     0             AZLSCK
     C                   UPDATE    RAPCTL
     C                   SETON                                        LR
     C* move to end of APR340CL   CALL      'PP0001CLSJ'
      *
     OAPR340    E            HDG            1 03
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
     O                                           67 'Accounts Payable Check'
     O                                           76 'Register'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           64 'For Checks Dated:'
     O                       LDATE         Y     73
     O          E            HDG            1
     O                                            6 'Check'
     O                                           74 'Invoice'
     O                                           87 'Gross'
     O                                          101 'Discount'
     O                                          116 'Net Amount'
     O          E            HDG            1
     O                                            4 '#'
     O                                           15 'Vendor'
     O                                           25 'Name'
     O                                           54 'Voucher'
     O                                           64 'Invoice'
     O                                           73 'Date'
     O                                           88 'Amount'
     O                                          100 'Taken'
     O                                          114 'Paid'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       TP$TOP        J    116
     O                       TPDTAK        1    100
     O                       GROSS         J     89
     O                       TPIVDT        Y     74
     O                       TPINV#              64
     O                       TPVOUC        Z     53
     O               10      VMNAME              44
     O               10      TPVEND        Z     13
     O               10      TPCHEK        Z      6
     O          E            TL1            1
     O                                           89 '----------'
     O                                          101 '----------'
     O                                          116 '----------'
     O          E            TL1            2
     O                                           70 'Check Total:'
     O                       CKGROS        1B    88
     O                       CKDISC        1B   100
     O                       CKPAID        1B   115
     O                                          117 '*'
     O          E            TLR         1  1
     O                                           89 '=========='
     O                                          101 '=========='
     O                                          116 '=========='
     O          E            TLR            1
     O                                           70 'Report Totals:'
     O                       COGROS        1     88
     O                       CODISC        1    100
     O                       COPAID        1    115
