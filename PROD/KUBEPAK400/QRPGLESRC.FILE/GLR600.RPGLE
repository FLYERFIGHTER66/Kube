      *--------------------------------------------------------------     GLR360
      *                                                                   GLR360
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999                          GLR360
      *                                                                   GLR360
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO         GLR360
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE         GLR360
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED      GLR360
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR         GLR360
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT      GLR360
      *       BY EXPRESS WRITTEN PERMISSION OF                            GLR360
      *            EFD ENTERPRISES, INC.     215-643-5352                 GLR360
      *                                                                   GLR360
      *--------------------------------------------------------------     GLR360
      *PROGRAM NAME-------- GLR600                                        GLR360
      *SYSTEM-------------- GENERAL LEDGER                                GLR360
      *DESCRIPTION--------- PRINT FISCAL YEAR CHECK LIST                  GLR360
      *                                                                   GLR360
      *                                                                   GLR360
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCORG    IF   E           K DISK
     FGLR600    O    F   80        PRINTER OFLIND(*INOF)                        GLR360
      *                                                                   GLR360
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
      *                                                                   GLR360
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN     FMCORG                             97
      *
     C                   EXCEPT    HDG
      *
     C                   SETON                                        LR
      *
     OGLR600    E            HDG            1 03                                GLR360
     O                       PROGID              10                             GLR360
     O                       RGNAMC              55
     O                                           65 'Company:'
     O                       LCO                 68
     O                       PAGE          Z     80
     O                                           77 'Page:'
     O          E            HDG            2                                   GLR360
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           51 'Fiscal Year Check List'    GLR360
     O                       TIMOD               80 '  :  :  '                  GLR360
     O          E            HDG            0                                   GLR360
     O                                           15 'BILLING and A/R'           GLR360
     O          E            HDG            1                                   GLR360
     O                                           15 '_______________'           GLR360
     O          E            HDG            2                                   GLR360
     O                                           44 '1. Last Daily Order Post'  GLR360
     O                                           70 '___/___/____'              GLR360
     O          E            HDG            2                                   GLR360
     O                                           40 '2. All Cash Receipts'      GLR360
     O                                           48 'Entered'                   GLR360
     O                                           70 '___/___/____'              GLR360
     O          E            HDG            2                                   GLR360
     O                                           38 '3. Transfer to G/L'        GLR360
     O                                           70 '___/___/____'              GLR360
     O          E            HDG            0                                   GLR360
     O                                           16 'ACCOUNTS PAYABLE'          GLR360
     O          E            HDG            1                                   GLR360
     O                                           16 '________________'          GLR360
     O          E            HDG            2                                   GLR360
     O                                           44 '1. All Vendor Invoices E'  GLR360
     O                                           50 'ntered'                    GLR360
     O                                           70 '___/___/____'              GLR360
     O          E            HDG            2                                   GLR360
     O                                           44 '2. Month End Reports Run'  GLR360
     O                                           70 '___/___/____'              GLR360
     O          E            HDG            2                                   GLR360
     O                                           38 '3. Transfer to G/L'        GLR360
     O                                           70 '___/___/____'              GLR360
     O          E            HDG            2                                   GLR360
     O                                           40 '4. Monthly Close Run'      GLR360
     O                                           70 '___/___/____'              GLR360
     O          E            HDG            2                                   GLR360
     O                                           41 '5. Fiscal Closing Run'     GLR360
     O                                           70 '___/___/____'              GLR360
     O          E            HDG            0                                   GLR360
     O                                           14 'GENERAL LEDGER'            GLR360
     O          E            HDG            1                                   GLR360
     O                                           14 '______________'            GLR360
     O          E            HDG            2                                   GLR360
     O                                           44 '1. All Journal Entries E'  GLR360
     O                                           50 'ntered'                    GLR360
     O                                           70 '___/___/____'              GLR360
     O          E            HDG            2                                   GLR360
     O                                           44 '2. Month End Reports Run'  GLR360
     O                                           70 '___/___/____'              GLR360
     O          E            HDG            2                                   GLR360
     O                                           40 '3. Post G/L Balances'      GLR360
     O                                           70 '___/___/____'              GLR360
