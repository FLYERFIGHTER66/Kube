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
      *PROGRAM NAME-------- APR400
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *DESCRIPTION--------- PAYMENT APPROVAL LISTING
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 10/17/99 GD LOG #5 ERROR ON CREDIT FOR VENDOR Y MVPC
      *  5/13/04 WB Added Vendor Message to report.
      *
      *
      *
     FFAPOPN    IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFAPCTL    UF   E           K DISK
     FAPR400    O    F  120        PRINTER OFLIND(*INOF)
      *
      * DESCRIPTION
     D MSG             S             30    DIM(2) CTDATA PERRCD(1)              DESCRIPTIONS
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
wb   D                 DS
wb   D  VMMSG                  1     60
wb   D  VMMSG#                 1     39
      *
     D                UDS
     D  LCO                    1      2  0
     D  LDATE                  3      8  0
     D  LS                     9      9  0
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
     C                   SETOFF                                       90
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN(N)  FMCORG                             90
     C*                    SETON                     OF  72VRD
      *
     C                   Z-ADD     1             CNT               4 0
     C                   Z-ADD     1             FIRST             4 0
     C                   Z-ADD     1             FINV              4 0
     C                   Z-ADD     1             CNTV              4 0
      *
     C                   EXCEPT    HDG                                          VRD
      *
     C     NXT           TAG
     C                   READ      FAPOPN                                 90
     C   90              GOTO      END
      *
     C     APSTAT        IFEQ      'D'
     C     APCLCD        OREQ      'C'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     APCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     APTBPD        IFNE      'Y'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     CNTV          IFNE      1
     C                   GOTO      NOT1
     C                   ENDIF
     C     APVEND        CHAIN     FMVEND                             12
      *
      * MULTI VOUCHERS PER CHECK 20 = NO
      *
     C     VMMVPC        IFEQ      'N'                                                      CS
     C                   SETON                                        20
     C                   ELSE
     C                   SETON                                        21
     C                   ENDIF
     C     NOT1          TAG
      *
     C*          FIRST     IFEQ 1                          110399
     C*                    GOTO NOCHK                      110399
     C*                    ENDIF                           110399
      *
     C   21APVEND        IFNE      OLVEND
     C     L2NET$        ANDLT     0
     C                   SETON                                          71
     C                   ENDIF
      *
     C   20APVOUC        IFNE      OLVOUC
     C     L1NET$        ANDLT     0
     C                   SETON                                          73
     C                   ENDIF
      *
     C   20
     CANN21APVOUC        IFNE      OLVOUC
     C     CNT           ANDNE     1                                            VRD
     C                   EXCEPT    TL1
     C                   ADD       1             MVCNT             4 0
     C                   ENDIF
     C   21
     CANN20APVEND        IFNE      OLVEND
     C     CNT           ANDNE     1                                            VRD
     C                   EXCEPT    TL1
     C                   SETOFF                                       2021
     C                   Z-ADD     1             CNT
     C                   ENDIF
     C   20
     CANN21APVEND        IFNE      OLVEND
     C*          MVCNT     ANDGT1                          110399
     C                   EXCEPT    TL2
     C                   SETOFF                                       2021
     C                   Z-ADD     1             CNT
     C                   Z-ADD     1             MVCNT
     C                   ENDIF
      *
      * AT NEW VENDOR, CHAIN TO GET VENDOR NAME
      *
     C     APVEND        CHAIN     FMVEND                             12
      *
      * MULTI VOUCHERS PER CHECK 20 = NO
      *
     C     VMMVPC        IFEQ      'N'                                                      CS
     C                   SETON                                        20
     C                   ELSE
     C                   SETON                                        21
     C                   ENDIF
      *
     C     NOCHK         TAG
      *
      * CALCULATE NET DUE AND ACCUMULATE DATE AND COMPANY TOTALS
      *
     C                   Z-SUB     APDISC        APDISC
     C     APITYP        IFEQ      'C'
     C                   Z-SUB     APDISC        APDISC
     C                   ENDIF
     C                   ADD       APDUE$        CO$AMT           11 2
     C                   ADD       APDISC        CODISC            7 2
     C                   ADD       AP$TOP        CONET$           11 2
     C                   ADD       APDUE$        L1$AMT           11 2
     C                   ADD       APDISC        L1DISC            7 2
     C                   ADD       AP$TOP        L1NET$           11 2
     C   20              ADD       APDUE$        L2$AMT           11 2          VRD
     C   20              ADD       APDISC        L2DISC            7 2          VRD
     C   20              ADD       AP$TOP        L2NET$           11 2          VRD
      *
     C     CNT           IFEQ      1
     C                   SETON                                        40
     C                   ENDIF
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   Z-ADD     APVEND        OLVEND            6 0
     C                   Z-ADD     APVOUC        OLVOUC            6 0
     C                   MOVEL     APMVPC        OLMVPC            1
     C                   ADD       1             CNT
     C                   ADD       1             CNTV
     C                   ADD       1             FIRST
     C                   SETOFF                                       40  72
      *
     C                   GOTO      NXT
     C     END           TAG
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C                   EXCEPT    TL1
      *
     C*          MVCNT     IFGT 1                          VRD
     C*          OLMVPC    IFEQ 'N'                        VRD
     C   20              EXCEPT    TL2
     C*                    ENDIF                           VRD
      *
     C                   EXCEPT    TLR
     C   71              EXCEPT    TERR
     C   72              EXCEPT    TERR72
     C   73              EXCEPT    TERR73
      *
     C     LCO           CHAIN     FAPCTL                             90
     C  N71
     CANN72              MOVEL     'Y'           AZOKC
     C   72
     COR 71              MOVEL     'N'           AZOKC
     C                   Z-ADD     TDATE         AZDTLA
     C                   Z-ADD     TIMOD         AZTIME
     C                   MOVEL     USERID        AZUSER
     C                   UPDATE    RAPCTL
      *
     C                   SETON                                        LR
      *
     OAPR400    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          1    120
     O                                          117 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           58 'Accounts Payable'
     O                                           75 'Payment Approval'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                       MSG(LS)             30
     O                                           58 'As Of:'
     O                       LDATE         Y     67
     O          E            HDG            1
     O                                            6 'Number'
     O                                           47 'Voucher'
     O                                           57 'Invoice'
     O                                           66 'Invoice'
     O                                           75 'Inv Due'
     O                                           90 'Amount '
     O                                          105 'Discount'
     O                                          120 'Amount To'
     O          E            HDG            0
     O                                           20 'Name'
     O                                            6 'Vendor'
     O                                           47 'Number'
     O                                           57 'Number'
     O                                           65 'Date'
     O                                           74 'Date'
     O                                           88 'Due'
     O                                          105 'To Take'
     O                                          120 'Be Paid'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O               40      APVEND        Z      6
     O               40      VMNAME              38
     O                       APVOUC        Z     46
     O                       APINV#              57
     O                       APIVDT        Y     66
     O                       APDUDT        Y     75
     O                       APDUE$        J     90
     O                       APDISC        J    105
     O                       AP$TOP        J    119
wb   O          E            DETL        0  0
wb   O               40      VMMSG#              39
wb   O          E            DETL        0  0
wb   O               40      VMMSG#              39
wb   O          E            DETL        0  0
wb   O               40      VMMSG#              39
     O          E            TL1            2
     O                                           71 'Check Total:'
     O                       L1$AMT        JB    90
     O                                           91 '*'
     O                       L1DISC        JB   105
     O                                          106 '*'
     O                       L1NET$        JB   119
     O                                          120 '*'
     O          E            TL2            2
     O                                           71 '*** Vendor Total:'
     O                       L2$AMT        JB    90
     O                                           91 '*'
     O                       L2DISC        JB   105
     O                                          106 '*'
     O                       L2NET$        JB   119
     O                                          120 '*'
     O          E            TLR            1
     O                                           90 '----------'
     O                                          105 '----------'
     O                                          119 '----------'
     O          E            TLR            1
     O                                           49 'Total Selected'
     O                                           62 'Payments For'
     O                                           71 'Company:'
     O                       APCOMP              75
     O                       CO$AMT        JB    90
     O                       CODISC        JB   105
     O                       CONET$        JB   119
     O          E            TERR        2  1
     O                                           13 '*** ERROR ***'
     O                                           33 'There is a negative'
     O                                           48 'check - Checks'
     O                                           72 'cannot be printed until'
     O                                           91 'this is corrected.'
     O                                          105 '*** ERROR ***'
     O          E            TERR73      2  1
     O                                           13 '*** ERROR ***'
     O                                           40 'There is a negative chec'
     O                                           64 'k for a vendor coded as '
     O                                           88 'multi vouchers NO.      '
     O          E            TERR73      1  1
     O                                           40 'Change this vendor to mu'
     O                                           64 'lti voucher YES and reru'
     O                                           88 'n this report if you wan'
     O                                          112 't to apply credit to inv'
     O                                          117 'oice.'
     O          E            TERR72      2  1
     O                                           40 '*** ERROR ***'
     O                                           60 'No Invoices were se'
     O                                           79 'lected for payment.'
     O                                           93 '*** ERROR ***'
** MESSAGE ARRAY
Sorted by Vendor Alpha                           1
Sorted by Vendor Number                          2
