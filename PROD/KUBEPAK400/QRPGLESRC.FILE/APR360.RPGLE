      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC. 1999
      *
      *       THIS MATERIAL WAS PREPAPED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN APE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PAPT, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME--------- APR360
      *SYSTEM--------------- ACCOUNTS PAYABLE
      *APPLICATION---------- AGING BY VENDOR
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFAPOPN    IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFAPCTL    IF   E           K DISK
     FAPR360    O    F  120        PRINTER OFLIND(*INOF)
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
     D                UDS
     D  LCO                    1      2  0
     D  LACTP                  3      4  0
     D  LBDATE                 6     11  0
     D  LEDATE                12     17  0
     D  LSEQ                  18     18  0
     D  LTYPE                 19     19
     D  LVEND                 20     25  0
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
     C     LCO           CHAIN     FAPCTL                             97
      *
     C     LSEQ          IFEQ      1
     C                   SETON                                        66
     C                   ENDIF
      *
     C     LVEND         IFGT      0
     C                   SETON                                        77
     C                   ENDIF
     C   77LVEND         CHAIN     FMVEND                             90
      *
     C                   Z-ADD     1             FIRST             6 0
     C                   Z-ADD     1             CNT               6 0
      *
     C                   Z-ADD     LEDATE        ##MDY                          GET DAY OF
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         ASDATE            5 0          AS OF DATE
     C     ASDATE        ADD       AZAGPY        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SVDUE2            6 0
     C     ASDATE        ADD       AZAGP2        ##DDD
     C                   CALL      '@DT@D0'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SVDUE3            6 0
     C                   Z-ADD     *ZEROS        ##DDD
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       323344
     C                   SETOFF                                       69
     C                   READ      FAPOPN                                 90
     C   90              GOTO      END
      *
     C     APCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     APDUE$        IFEQ      0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     APCLCD        IFEQ      'Y'
     C     APCLCD        OREQ      'C'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   77APVEND        IFNE      LVEND
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     FIRST         IFNE      1
     C     OLCRLM        ANDGT     0
     C     TAPDUE        ANDGT     OLCRLM                                       OVER CREDIT LIM
     C                   SETON                                        28
     C                   ENDIF
      *
     C     FIRST         IFNE      1
     C     APVEND        ANDNE     OLVEND
     C     CNT           ANDGT     1
     C                   EXCEPT    TL1
     C                   Z-ADD     1             CNT
     C                   SETOFF                                       28
     C                   ENDIF
      *
     C     APVEND        CHAIN     FMVEND                             98                    R
     C     VMPHON        IFGT      *ZEROS
     C                   SETON                                        52
     C                   ENDIF
     C     VMCRLM        IFGT      0
     C                   SETON                                        69
     C                   ENDIF
     C                   Z-ADD     APVEND        OLVEND            6 0          SAVE VEND#
     C                   Z-ADD     VMCRLM        OLCRLM            9 2
      *
      *  DETAIL CALCS
      *
     C     APTBPD        IFEQ      'Y'
     C                   SETON                                            32
     C                   ENDIF
     C     APTBPD        IFEQ      'H'
     C                   SETON                                            33
     C                   ENDIF
      *                                                                D
     C                   EXSR      CREDIT
     C                   EXSR      AGING
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C     CNT           IFNE      1
     C                   SETON                                        50
     C                   EXCEPT    DOF
     C                   SETOFF                                       50
     C                   ENDIF
     C                   ENDDO
     C     CNT           IFEQ      1
     C                   EXCEPT    DOF
     C                   ENDIF
     C                   EXCEPT    DETL
     C                   SETON                                        88
     C                   ADD       1             FIRST
     C                   ADD       1             CNT
     C                   GOTO      NXT
      *
     C     END           TAG
     C   88              EXCEPT    TL1
     C   88              EXCEPT    TLR
     C  N88              EXCEPT    TLRN
     C                   SETON                                        LR
      *                                                                ***
      * ACCUMULATE TOTAL A/P DUE                                         *
      *                                                                  *
     C     CREDIT        BEGSR
     C                   ADD       APDUE$        TAPDUE           11 2          TOTAL A/P
     C                   ENDSR
      *
      *  DETERMINE APPROPRIATE AGING BUCKET FOR REPORT.                  *
      *                                                                ***
     C     AGING         BEGSR
     C                   SETOFF                                       181920
     C                   SETOFF                                       2122
     C                   Z-ADD     APDUDT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         SVDUDT            5 0             DUE DATE
     C     SVDUDT        SUB       ASDATE        RESULT            5 0                      OF
     C     RESULT        IFLE      0                                                        OF
     C                   Z-ADD     APDUE$        APCURR           11 2
     C                   GOTO      EAGE
     C                   ENDIF
     C     RESULT        IFGT      0                                                        OF
     C     RESULT        ANDLE     AZAGPY                                                   OF
     C                   Z-ADD     APDUE$        APAGE1           11 2
     C                   GOTO      EAGE
     C                   ENDIF
     C     RESULT        IFGT      AZAGPY                                                   OF
     C     RESULT        ANDLE     AZAGP2                                                   OF
     C                   Z-ADD     APDUE$        APAGE2           11 2
     C                   GOTO      EAGE
     C                   ENDIF
     C                   Z-ADD     APDUE$        APAGE3           11 2
     C     EAGE          TAG
      *
     C*                    ADD  APDUE$    TAPDUE 112       TOTAL A/P
     C                   ADD       APDUE$        TVEDUE           11 2          TOTAL A/P
     C                   ADD       APCURR        SFAPDU           11 2
     C                   ADD       APCURR        TFAPDU           11 2
     C                   ADD       APAGE1        SAPDU1           11 2
     C                   ADD       APAGE1        TAPDU1           11 2
     C                   ADD       APAGE2        SAPDU2           11 2
     C                   ADD       APAGE2        TAPDU2           11 2
     C                   ADD       APAGE3        SAPDU3           11 2
     C                   ADD       APAGE3        TAPDU3           11 2
     C                   ENDSR
      ********************************************************************
     OAPR360    E            HDG            1 03
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
     O                                           64 'Detail Aged Accounts'
     O                                           82 'Payable By Vendor'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O               66N77                       21 'Vendor Alpha Sequence'
     O              N66N77                       22 'Vendor Number Sequence'
     O                                           61 'Aging Date:'
     O                       LEDATE        Y     70
     O               77                         108 'For Vendor:'
     O               77      LVEND         Z    115
     O               77                         120 'Only'
     O          E            HDG            1
     O                                           68 'Due On Or'
     O          E            HDG            1
     O                                           12 'Vendor  '
     O                                           27 'Vouch'
     O                                           38 'Invoice'
     O                                           47 'Invoice'
     O                                           54 'Due'
     O                                           66 'Before'
     O                                           82 '-----------'
     O                                           95 '--- Due After'
     O                                          107 '-----------'
     O                                          120 'Total'
     O          E            HDG            0
     O                                            6 'Number'
     O                                           14 'Name'
     O                                           25 '#'
     O                                           38 'Number'
     O                                           46 'Date'
     O                                           54 'Date'
     O                                          120 'Amount'
     O                       SVDUE3        Y    106
     O                       SVDUE2        Y     93
     O                       LEDATE        Y     80
     O                       LEDATE        Y     67
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DOF            1
     O                       APVEND        Z      6
     O                       VMNAME              37
     O               52N50   VMPHON              49 '   -   -    '
     O               69N50                       63 'Credit Limit:'
     O               69N50   VMCRLM        M     74
     O               50                          48 '(Continued)'
     O          E            DETL           1
     O                       APAGE3        MB   107
     O                       APAGE2        MB    94
     O                       APAGE1        MB    81
     O                       APCURR        MB    68
     O                       APVOUC        Z     27
     O                       APINV#              38
     O                       APIVDT        Y     47
     O                       APDUDT        Y     56
     O                     32                    20 'Released For Payment'
     O                     33                     4 'Held'
     O          E            TL1            1
     O                                           68 '----------'
     O                                           81 '----------'
     O                                           94 '----------'
     O                                          107 '----------'
     O                                          120 '------------'
     O          E            TL1            1
     O                       SAPDU3        MB   107
     O                       SAPDU2        MB    94
     O                       SAPDU1        MB    81
     O                       SFAPDU        MB    68
     O                       TVEDUE        MB   120
     O               28                          55 '** Over Credit Limit **'
     O          E            TLR            1
     O                                           68 '=========='
     O                                           81 '=========='
     O                                           94 '=========='
     O                                          107 '=========='
     O                                          120 '============'
     O          E            TLR            1
     O                                           55 'Report Totals:'
     O                       TAPDU3        MB   107
     O                       TAPDU2        MB    94
     O                       TAPDU1        MB    81
     O                       TFAPDU        MB    68
     O                       TAPDUE        MB   120
     O          E            TLRN           1
     O                                           55 '**** There Are No Transa'
     O                                           78 'ctions For The Report S'
     O                                           92 'elections ****'
