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
      *PROGRAM NAME-------- APR520
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- RECONCILED CHECK REPORT
      *
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFAPREC    IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FAPR520    O    F  120        PRINTER OFLIND(*INOF)
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
      *
     D                UDS
     D  LCO                    1      2  0
     D  LPURGE                 3      3
     D  LDATE                  4      9  0
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
     C                   Z-ADD     LDATE         ##MDY             6 0
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
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      FAPREC                                 90
     C   90              GOTO      END
      *
     C     AKCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     AKCKRC        IFEQ      *BLANKS
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     AKDTRC        IFEQ      0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   Z-ADD     AKDTRC        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         CDATE             5 0
      *
     C     AKCTYP        IFEQ      '5'
     C     AKCTYP        OREQ      'V'
     C                   GOTO      NOCHK
     C                   ENDIF
      *
     C     CDATE         IFNE      RDATE
     C                   GOTO      NXT
     C                   ENDIF
     C     NOCHK         TAG
      *
      * CHAIN TO VENDOR MASTER FILE TO GET VENDOR NAME
      *
     C     AKVEND        CHAIN     FMVEND                             22
     C  N22VMSTAT        COMP      'D'                                    22
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
     C                   EXCEPT    DETL
     C                   SETON                                        88
     C     AK$NET        ADD       WKTOT1        WKTOT1           11 2
     C                   ADD       1             TOTCNT            6 0
     C                   GOTO      NXT
      *
     C     END           TAG
     C   88              EXCEPT    TLR
     C  N88              EXCEPT    TLRN
     C  N88              MOVEL     'N'           LPURGE
     C                   SETON                                        LR
      *
     OAPR520    E            HDG            1 03                                APR500
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           90 'Company:'
     O                       LCO                 93
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            1                                   APR500
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           70 'Check Reconciliation'      APR500
     O                       TIMOD              120 '  :  :  '                  APR500
     O          E            HDG            2                                   APR500
     O                                           66 'Bank Statement Dated:'     APR500
     O                       LDATE         Y     75                             APR500
     O          E            HDG            1                                   APR500
     O                                           11 'Check'
     O                                           25 'Check'
     O                                           39 'Vendor'
     O                                           87 'Date'
     O                                          104 'Check'
     O          E            HDG            0                                   APR500
     O                                            9 '#'
     O                                           24 'Date'
     O                                           39 'Number'
     O                                           56 'Vendor Name'
     O                                           90 'Reconciled'
     O                                          104 'Amount'
     O          E            HDG            2                                   APR500
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       AKCHEK        Z     11
     O                       AKCKDT        Y     26
     O                       AKVEND        Z     38
     O              N22      VMNAME              75
     O               22                          65 'Invalid Vendor Number'
     O                       AKDTRC        Y     89
     O                       AK$NET        1    104
     O          E            TLR         1  1
     O                                          105 '----------'
     O          E            TLR            2
     O                                           75 'Total Checks Reconciled '
     O                                           80 '===>'
     O                       TOTCNT        Z     87
     O                       WKTOT1        1B   104
     O          E            TLRN           1
     O                                           53 '**** There Were No Check'
     O                                           76 's Reconciled For This S'
     O                                           94 'tatement Date ****'
      *
