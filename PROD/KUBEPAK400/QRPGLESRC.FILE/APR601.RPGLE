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
      *PROGRAM NAME-------- APR601
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- VENDOR PAYMENT HISTORY REPORT BY ALPHA
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFAPDTPAL  IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FAPR600    O    F  120        PRINTER OFLIND(*INOF)
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
     D  LVEND                  4      9  0
     D  LCKDTE                10     15  0
     D  LCYMD                 16     22  0
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
     C     LCKDTE        IFGT      0
     C                   SETON                                        77
     C                   ENDIF
      *
     C     LVEND         IFGT      0
     C                   SETON                                        50
     C                   ENDIF
      *
     C     LCO           CHAIN     FMCORG                             97
      *
     C                   Z-ADD     1             FIRST             6 0
     C                   Z-ADD     1             CNT               6 0
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      FAPDTPAL                               90
     C   90              GOTO      END
      *
     C     ATCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LVEND         IFGT      0
     C     ATVEND        ANDNE     LVEND
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LCKDTE        IFGT      0
     C     ATCYMD        ANDLT     LCYMD
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     ATVEND        IFNE      OLVEND
     C     FIRST         ANDGT     1
     C                   Z-ADD     1             CNT
     C                   EXCEPT    TL1
     C                   ENDIF
      *
     C     CNT           IFEQ      1
     C     ATVEND        CHAIN     FMVEND                             91
     C                   ENDIF
     C  N91VMSTAT        IFEQ      'D'
     C                   MOVEL     '*Deleted'    NAME             16
     C                   MOVE      ' Vendor*'    NAME
     C                   MOVEL     NAME          VMNAME
     C                   ENDIF
     C   91              MOVEL     '*Vendor '    NAMEA            16
     C   91              MOVE      'Not on F'    NAMEA
     C   91              MOVE      'ile'         NAMEB             3
     C   91              MOVEL     NAMEA         NAMEC            19
     C   91              MOVE      NAMEB         NAMEC
     C   91              MOVEL     NAMEC         VMNAME
      *
     C     TESTCK        IFNE      ATCHEK
     C                   ADD       1             CKS               5 0
     C                   ENDIF
      *
     C                   ADD       ATPAID        VPAID            10 2
     C                   ADD       ATDTAK        VDTAK            10 2
      *
     C                   ADD       ATPAID        COPAID           10 2
     C                   ADD       ATDTAK        CODTAK           10 2
      *
     C     CNT           IFEQ      1
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
     C                   EXCEPT    DET1
     C                   ENDIF
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
     C                   MOVEL     ATDESC        DESC             25
     C                   EXCEPT    DETL
     C                   SETON                                        78
     C                   Z-ADD     ATCHEK        TESTCK            6 0
     C                   Z-ADD     ATVEND        OLVEND            6 0
     C                   ADD       1             FIRST
     C                   ADD       1             CNT
     C                   GOTO      NXT
      *
     C     END           TAG
     C   78              EXCEPT    TL1
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *
     OAPR600    E            HDG            1 03
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
     O                                           66 'Paid Accounts Payable'
     O                                           76 'By Vendor'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           21 'Vendor Alpha Sequence'
     O               77                          61 'Only Checks Dated On'
     O               77                          71 'Or After:'
     O               77      LCKDTE        Y     80
     O               50                         113 'Include Only Vendor:'
     O               50      LVEND         Z    120
     O          E            HDG            0
     O                                            6 'Vend #'
     O                                           12 'Name'
     O                                           50 'Description'
     O                                           70 'Voucher'
     O                                           81 'Invoice'
     O                                           92 'Amount'
     O                                          102 'Discount'
     O                                          110 'Check#'
     O                                          119 'Date'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DET1           0
     O                       ATVEND        Z      6
     O                       VMNAME              37
     O          E            DETL           1
     O                       ATCKDT        YB   120
     O                       ATCHEK        ZB   111
     O                       ATDTAK        MB   104
     O                       ATPAID        MB    94
     O                       ATITYP              83
     O                       ATINV#              81
     O                       ATVOUC        Z     70
     O                       DESC                63
     O          E            TL1            1
     O                                           94 '-----------'
     O                                          104 '-------'
     O          E            TL1            2
     O                                           80 '** Vendor Totals **'
     O                       VDTAK         MB   104
     O                       VPAID         MB    94
     O          E            TLR            1
     O               78                          94 '==========='
     O               78                         104 '======='
     O          E            TLR            1
     O               78                          80 '** Report Totals **'
     O               78      CODTAK        MB   104
     O               78      COPAID        MB    94
     O              N78                          59 '** No Vendor Payments Fo'
     O              N78                          82 'und For This Report ***'
