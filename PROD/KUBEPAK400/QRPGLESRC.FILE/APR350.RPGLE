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
      *PROGRAM NAME-------- APR350
      *SYSTEM-------------- ACCCOUNTS PAYABLE
      *APPLICATION--------- CASH DISBURSEMENTS JOURNAL
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFAPCHK    IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FAPR350    O    F  120        PRINTER OFLIND(*INOF)
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
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      FAPCHK                                 90
     C   90              GOTO      END
      *
      * CHECK COMPANY
      *
     C     ACCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   END
      *
      * CHAIN TO VENDOR MASTER FOR VENDOR NAME
      *
     C     ACVEND        CHAIN     FMVEND                             12
      *
     C                   SETOFF                                       50
     C     ACCTYP        IFEQ      'V'
     C                   SETON                                        50
     C                   ENDIF
      *
     C                   ADD       AC$AMT        CO$AMT           12 2
     C                   ADD       ACDTAK        CODTAK           10 2
     C                   ADD       AC$NET        CO$NET           12 2
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
      *
     C                   EXCEPT    DETL
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    TLR
     C                   SETON                                        LR
      *
     OAPR350    E            HDG            1 03
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
     O                                           71 'A/P Cash Disbursements'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                            6 'Check'
     O                                           14 'Check'
     O                                           77 'Gross'
     O                                           92 'Discount'
     O                                          107 'Check'
     O          E            HDG            1
     O                                            4 '#'
     O                                           14 'Date'
     O                                           24 'Vendor'
     O                                           35 'Name'
     O                                           77 'Amount'
     O                                           91 'Taken'
     O                                          107 'Amount'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       ACCHEK        Z      6
     O                       ACCKDT        Y     15
     O              N50      ACVEND        Z     22
     O              N50      VMNAME              53
     O               50      ACTDES              53
     O              N50      AC$AMT        1     77
     O              N50      ACDTAK        1     91
     O              N50      AC$NET        1    107
     O          E            TLR            1
     O                                           78 '----------'
     O                                           92 '----------'
     O                                          108 '----------'
     O          E            TLR            1
     O                                           60 'Report Totals:'
     O                       CO$NET        1B   107
     O                       CO$AMT        1B    77
     O                       CODTAK        1B    91
