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
      *PROGRAM NAME-------- ARR540
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- LATE CHARGES JOURNAL
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMTRANDT  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FARR540    O    F  121        PRINTER OFLIND(*INOF)
      *
     D MSG             S             30    DIM(2) CTDATA PERRCD(1)              MESSAGES
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
     D  LACTP                  3      4  0
     D  LBDATE                 5     11  0
     D  LEDATE                12     18  0
     D  LPROG                 29     36
     D  LNAME                 37     66
     D  LPRTR                100    109
     D  LFORM                110    113
     D  LCOPY                114    115  0
     D  LJOB                 116    116
     D  LHOLD                117    120
     D  LSAVE                121    124
     D  LCANCL               133    133
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     LBDATE        ##CYMD            7 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##MDY             6 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##MDY         PERBEG            6 0
     C                   Z-ADD     LEDATE        ##CYMD            7 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##MDY             6 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##MDY         PEREND            6 0
      *
     C     LCO           CHAIN     FMCORG                             97
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      FMTRANDT                               90
     C   90              GOTO      END
      *
     C     MTCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     MTTTYP        IFNE      07
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     MTTDAT        IFLT      LBDATE
     C     MTTDAT        ORGT      LEDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     MTCUST        CHAIN     FMCUST                             90
      *
     C  N90CMSTAT        IFEQ      'D'
     C                   SETON                                        90
     C                   ENDIF
     C   90              MOVEL     MSG(1)        CMNAME
      *
     C                   ADD       MT$AMT        TOTAMT           11 2
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   ENDDO
      *
     C                   Z-ADD     MTTDAT        ##CYMD            7 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##MDY             6 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##MDY         DAYDTE            6 0
     C                   Z-ADD     MTDUDT        ##CYMD            7 0
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##MDY             6 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##MDY         DUEDTE            6 0
      *
     C                   EXCEPT    DETL
     C                   SETON                                        88
     C                   GOTO      NXT
      *
     C     END           TAG
     C   88              EXCEPT    TLR
     C  N88              EXCEPT    TLRN
     C                   SETON                                        LR
      *
     OARR540    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           96 'Company:'
     O                       LCO                 99
     O                       PAGE          1    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           66 'Monthly Late Charges'
     O                                           74 'Journal'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           56 'For Period:'
     O                       PERBEG        Y     65
     O                                           67 '-'
     O                       PEREND        Y     76
     O          E            HDG            1
     O                                           49 'Trans'
     O                                           57 'Due'
     O*                                  90 'Amount'
     O          E            HDG            1
     O                                            8 'A/R Cust'
     O                                           24 'N   A   M   E'
     O                                           48 'Date'
     O                                           58 'Date'
     O                                           68 'Ref.'
     O                                           74 'Suff'
     O*                                  84 'Over'
     O*                        MCAGDYZ   88
     O*                                  93 'Days'
     O                                           96 'Late Charges'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       MTCUST        Z      7
     O                       CMNAME              40
     O                       DAYDTE        Y     50
     O                       DUEDTE        Y     60
     O                       MTINV#        Z     69
     O                       MTSUFF              73
     O*                        MTO30$1   94
     O                       MT$AMT        1     94
     O          E            TLR         1  1
     O                                           95 '----------'
     O          E            TLR            1
     O                                           70 'Total Late Charges:'
     O                       TOTAMT        1     94
      *
     O          E            TLRN
     O                                           32 '**********'
     O                                           51 'There Were No Late'
     O                                           75 'Charges For This Period'
     O                                           86 '**********'
** MESSAGE
 ** Customer # Not On File **
