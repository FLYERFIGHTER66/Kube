      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC.   1996
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.   .  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- BIR392 - OPEN ORDERS/SHIP TO CUST SUMMARY
      **COMPANY------------- EFD ENTERPRISES INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT
      **DESCRIPTION--------- OPEN ORDERS LISTED BY CUSTOMER NUMBER
      **
      *
      *    CHANGE--DATE-------DESCRIPTION
      *
      *
     FFHORCUSA  IF   E           K DISK
     FFMCOMP    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FBIR392    O    F  132        PRINTER OFLIND(*INOF)
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      *
     D                UDS
     D  LCODE                  1      1  0
     D  LFORM                  2      5
     D  LPRTR                  6     15
     D  LCANCL               133    133
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   MOVEL     '00'          MCCOMP
     C     CKEY          KLIST
     C                   KFLD                    MCCOMP
     C     CKEY          CHAIN(N)  FMCOMP                             90
      *
     C                   Z-ADD     1             FIRST             2 0
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       50
     C                   READ      FHORCUSA                               77
     C   77              GOTO      END
      *
     C     LCODE         IFEQ      3
     C     OHSHFR        ANDNE     'TAG'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LCODE         IFEQ      2
     C     OHSHFR        ANDEQ     'TAG'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     OHQUOT        IFEQ      'Y'
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK IF CLOSED ORDER OR DELETED ORDER, IF SO, DO NOT PRINT
      *
     C     OHCOFL        IFEQ      'Y'
     C     OHSTAT        OREQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     OHCUST        IFEQ      OLCUST
     C                   SETON                                        50
     C                   ENDIF
     C     OHCUST        IFNE      OLCUST
     C                   EXCEPT    SKIP
     C                   ENDIF
      *
     C     OHCUST        CHAIN     FMCUST                             90
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DTL1
     C                   Z-ADD     OHCUST        OLCUST            6 0
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      *
     OBIR392    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       MCNAME              75
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           59 'Open Orders by Ship'
     O                                           81 'To Customer - Summary'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           37 'Ship To'
     O                                           46 'Bill To'
     O                                           56 'Purchase'
     O                                           69 'Ship'
     O                                           77 'Order'
     O                                           84 'Ship'
     O                                           92 'Order'
     O                                           97 'Sls'
     O                                          120 '  Last  '
     O          E            HDG            1
     O                                           12 'Ship To Name'
     O                                           37 'Number'
     O                                           45 'Number'
     O                                           55 'Order #'
     O                                           69 'Date'
     O                                           78 'Number'
     O                                           83 'Via'
     O                                           91 'Date'
     O                                           96 '#'
     O                                          108 'Phone #'
     O                                          120 'Activity'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DTL1           1
     O                       OHNAME              30
     O              N50      OHCUST        Z     37
     O              N50      OHBLCU        Z     45
     O                       OHPONO              62
     O                       OHDTRQ        Y     71
     O                       OHORD#        Z     78
     O                       OHSHPC              83
     O                       OHDTOR        Y     93
     O                       OHSLM1              97
     O              N50      CMPHON             111 '   -   -    '
     O                       OHDTLA        Y    120
     O          E            SKIP           1
     O                                            1 ' '
