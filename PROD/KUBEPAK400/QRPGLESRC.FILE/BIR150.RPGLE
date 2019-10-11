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
      *PROGRAM NAME-------- BIR150
      *SYSTEM-------------- MASTER FILES
      *APPLICATION--------- G/L DEFAULT MASTER LIST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFGLDF     IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FBIR150    O    F   80        PRINTER
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
     C     LCO           CHAIN(N)  FMCORG                             90
     C                   EXCEPT    HDG
      *
     C     LCO           SETLL     FGLDF
     C     NXT           TAG
     C                   SETOFF                                       90
     C     LCO           READE     FGLDF                                  90
     C   90              GOTO      END
      *
      * CHECK FOR DELETED RECORD
      *
     C     GDSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   OF              EXCEPT    HDG
     C                   SETOFF                                       OF
      *
     C     GDPAYR        IFGT      *ZEROS
     C                   SETON                                        60
     C                   ENDIF
     C                   EXCEPT    DETL
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     OBIR150    E            HDG            1 03
     O                       PROGID              10
     O                       RGNAMC              55
     O                       PAGE          1     80
     O                                           77 'Page'
     O          E            HDG            1
     O                       TDATE         Y      8
     O                                           46 'General Ledger Defaults'
     O                                           58 'Master List'
     O                       TIMOD               80 '  :  :  '
     O          E            HDG            2
     O                                           13 'Requested by:'
     O                       USERID              24
     O                                           44 'For Company:'
     O                       LCO                 47
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           80 '________'
     O          E            DETL           1
     O                                            5 'Sales'
     O                       GDSALE              36 '    -    '
     O                                           53 'Inventory'
     O                       GDINVN              78 '    -    '
     O          E            DETL           2
     O                                           65 'Inventory Adj.       '
     O                       GDINAJ              78 '    -    '
     O          E            DETL           1
     O                                           18 'Cost of Goods Sold'
     O                       GDCOGS              36 '    -    '
     O                                           63 'Accounts Receivable'
     O                       GDARRC              78 '    -    '
     O          E            DETL           1
     O                                            7 'Freight'
     O                       GDFRGT              36 '    -    '
     O                                           58 'Special Charge'
     O                       GDSCHG              78 '    -    '
     O          E            DETL           1
     O                                           15 'Volume Discount'
     O                       GDVDSC              36 '    -    '
     O                                           58 'Trade Discount'
     O                       GDTDSC              78 '    -    '
     O          E            DETL           1
     O                                           14 'Cash Discounts'
     O                       GDCDSC              36 '    -    '
     O                                           48 'Cash'
     O                       GDCASH              78 '    -    '
     O          E            DETL           2
     O                                           12 'Late Charges'
     O                       GDLCHG              36 '    -    '
     O          E            DETL           1
     O                                           15 'State Sales Tax'
     O                       GDSTTX              36 '    -    '
     O                                           60 'County Sales Tax'
     O                       GDCOTX              78 '    -    '
     O          E            DETL           3
     O                                           14 'City Sales Tax'
     O                       GDCITX              36 '    -    '
     O          E    60      DETL        3  1
     O                                            7 'Payroll'
     O                       GDPAYR              36 '    -    '
     O                                           48 'FICA'
     O                       GDFICA              78 '    -    '
     O          E    60      DETL           1
     O                                           12 'Payroll Cash'
     O                       GDPRCS              36 '    -    '
     O                                           47 'FIT'
     O                       GDFIT               78 '    -    '
     O          E    60      DETL           1
     O                                           22 'Other Earnings-Taxable'
     O                       GDOTAX              36 '    -    '
     O                                           61 'Employer FICA Exp'
     O                       GDAFIX              78 '    -    '
     O          E    60      DETL           2
     O                                           24 'Other Earnings-Non-Taxab'
     O                                           26 'le'
     O                       GDONTX              36 '    -    '
     O                                           52 'C.O.L.A.'
     O                       GDCOLA              78 '    -    '
     O          E    60      DETL        3  1
     O                                           16 'Accounts Payable'
     O                       GDAPPY              36 '    -    '
     O                                           64 'Stock Inventory Clea'
     O                                           68 'ring'
     O                       GDAPEX              78 '    -    '
     O          E    60      DETL           1
     O                                           12 'A/P Discount'
     O                       GDAPDS              36 '    -    '
     O                                           63 'Non-Stock Inventory'
     O                       GDPUNS              78 '    -    '
     O          E    60      DETL           1
     O                                            8 'A/P Cash'
     O                       GDAPCH              36 '    -    '
     O                                           58 'A/P Freight-In'
     O                       GDFRTI              78 '    -    '
     O          E            DETL        3  1
     O                                           11 'Profit/Loss'
     O                       GDINC$              36 '    -    '
