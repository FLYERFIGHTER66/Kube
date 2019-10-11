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
      *PROGRAM NAME-------- BIR129
      *SYSTEM-------------- MASTER FILES
      *APPLICATION--------- DEPARTMENT MASTER LISTING
      *
      *
     FFMDEPT    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FBIR129    O    F  120        PRINTER OFLIND(*INOF)
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   MOVEL     '00'          COMP              2 0
     C     COMP          CHAIN     FMCORG                             90
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       901011
     C                   READ      FMDEPT                                 90
     C   90              GOTO      END
      *
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   EXCEPT    DETL
     C*          DEPPC2    IFGT *BLANKS
     C                   EXCEPT    DETL2
     C*                    ENDIF
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     OBIR129    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                       PAGE          1    120
     O                                          117 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           70 'Department Codes List'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           45 '=========='
     O                                           64 'P R I N T E R S'
     O                                           78 '=========='
     O                                           83 'G/L'
     O                                           90 'Ship'
     O                                          103 'Cash/Carry'
     O          E            HDG            1
     O                                            3 'Cd'
     O                                           15 'Description'
     O                                           43 'Invoices'
     O                                           54 'PickSlips'
     O                                           64 'Reports'
     O                                           72 'P.O.'
     O                                           83 'Dept'
     O                                           90 'From'
     O                                           96 'Y/N'
     O                                          104 'Disc'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DETL           1
     O                       DEDEPT               3
     O                       DEDESC              34
     O                       DEPINV              45
     O                       DEPPCK              56
     O                       DEPREP              67
     O                       DEPPO               78
     O                       DEGLNO              83
     O                       DESHFR              90
     O                       DECCAL              95
     O                       DECANC        4    104
     O          EF           DETL2          1
     O                       DEPPC2              56
     O                       DECCDE             120
