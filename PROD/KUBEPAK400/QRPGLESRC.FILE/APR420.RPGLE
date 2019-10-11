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
      *PROGRAM NAME-------- APR420
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- START-UP EDIT LISTING
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFAPENT    IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFAPCTL    UF   E           K DISK
     FAPR420    O    F  120        PRINTER OFLIND(*INOF)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      *  PROGRAM NAME
     D  PROGID                 1     10
      *  RUN LIBRARY
     D  RLIBR                 81     90
      *  USER I.D.
     D  USERID               254    263
      *  SOURCE LIBRARY
     D  SLIBR                314    323
      *
     D                UDS
     D  LCO                    1      2  0
     D  LCANCL               133    133
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     1             CNT               6 0
      *
     C     LCO           CHAIN     FMCORG                             88
     C     LCO           CHAIN     FAPCTL                             88
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      FAPENT                                 90
     C   90              GOTO      END
      *
     C     ANCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     ANSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     CNT           IFGT      1
     C     ANVEND        ANDNE     OVEND
     C                   EXCEPT    TL1
     C                   ENDIF
      *
      * CHAIN TO VENDOR MASTER FOR VENDOR NAME
      *
     C     ANVEND        CHAIN(N)  FMVEND                             91
     C  N91              MOVEL     VMNAME        VNAME            23
      *
      * MOVE DETAIL TOTALS INTO OUTPUT FIELDS
      *
     C                   Z-ADD     AN$AMT        D$AMT             9 2
     C                   Z-ADD     ANDAVL        DDAVL             7 2
      *
      * ADD TO GET VENDOR TOTALS
      *
     C                   ADD       AN$AMT        V$AMT             9 2
     C                   ADD       ANDAVL        VDAVL             7 2
      *
      * ADD TO GET COMPANY TOTALS
      *
     C                   ADD       AN$AMT        C$AMT            10 2
     C                   ADD       ANDAVL        CDAVL             8 2
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
     C                   EXCEPT    DETL
      *
     C                   Z-ADD     ANVEND        OVEND             6 0
     C                   MOVEL     ANINV#        OINV#            10
     C                   ADD       1             CNT
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    TL1
     C                   EXCEPT    TLR
     C                   MOVEL     'Y'           AZOKSU
     C                   Z-ADD     TDATE         AZDTLA
     C                   Z-ADD     TIMOD         AZTIME
     C                   MOVEL     USERID        AZUSER
     C                   UPDATE    RAPCTL
     C                   SETON                                        LR
      *
     OAPR420    E            HDG            1 03
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
     O                                           60 'Accounts Payable'
     O                                           77 'Start-up Listing'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                            6 'Vendor'
     O                                           40 'Invoice'
     O                                           52 'Invoice'
     O                                           58 'Due'
     O                                           70 'Invoice'
     O                                           88 '-- Discount --'
     O          E            HDG            0
     O                                            6 'Number'
     O                                           15 'Name'
     O                                           40 'Number'
     O                                           44 'Typ'
     O                                           52 'Date'
     O                                           59 'Date'
     O                                           70 'Amount'
     O                                           79 'Avail'
     O                                           88 'Date'
     O                                          105 'Description'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       ANTDES             120
     O                       ANDCDT              88 '  /  / 0'
     O                       ANDAVL        LB    79
     O                       AN$AMT        LB    71
     O                       ANDUDT        Y     61
     O                       ANIVDT        Y     52
     O                       ANITYP              43
     O                       ANINV#              41
     O                       VNAME               30
     O                       ANVEND        Z      6
     O          E            TL1         1  1
     O                                           55 '** Vendor Totals'
     O                       VDAVL         LB    79
     O                       V$AMT         LB    71
     O          E            TLR         1  1
     O                                           55 '*** Company Totals'
     O                       CDAVL         LB    79
     O                       C$AMT         LB    71
