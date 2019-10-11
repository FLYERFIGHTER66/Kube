      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- APR500
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *DESCRIPTION--------- A/P MONTHLY DISBURSEMENTS JOURNAL
      *
      *                                                                ME
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFAPMTHCK  IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FAPR500    O    F  120        PRINTER OFLIND(*INOF)
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
     D  LINCL                  5      5
     D  LBDATE                 6     11  0
     D  LEDATE                12     17  0
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
     C                   Z-ADD     LBDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##DDD             5 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##DDD         BDATE             5 0
     C                   Z-ADD     LEDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##ERR             1
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##DDD             5 0
     C                   PARM                    ##ERR             1
     C                   Z-ADD     ##DDD         EDATE             5 0
      *
     C     LCO           CHAIN     FMCORG                             97
      *
     C     LINCL         IFEQ      'R'                                                      KS
     C                   SETON                                        20
     C                   ENDIF
     C     LINCL         IFEQ      'M'                                                      KS
     C                   SETON                                        21
     C                   ENDIF
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   READ      FAPMTHCK                               90
     C   90              GOTO      END
      *
     C     AMCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   20AMCTYP        IFEQ      'M'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C*  20      AMCTYP    IFNE ' '
     C*          AMCTYP    ORNE '5'                        EFD 11/18
     C*                    GOTO NXT
     C*                    ENDIF
      *
     C   21AMCTYP        IFNE      'M'
     C*          AMCTYP    ORNE '5'                        EFD 11/18
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   Z-ADD     AMCKDT        ##MDY             6 0
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
     C     CDATE         IFLT      BDATE
     C     CDATE         ORGT      EDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     AMCTYP        IFEQ      '5'
     C                   SETON                                        23
     C                   ELSE
     C                   SETOFF                                       23
     C                   ENDIF
      *
      * CHAIN TO VENDOR MASTER FOR VENDOR NAME
      *
     C     AMCTYP        IFEQ      '5'
     C                   SETON                                        23
     C                   ELSE
     C                   SETOFF                                       23
     C                   ENDIF
     C     AMVEND        CHAIN     FMVEND                             12
     C  N12VMSTAT        IFEQ      'D'
     C                   SETON                                        12
     C                   ENDIF
      *
     C                   MOVEL     AMTDES        TDES             27
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C                   EXCEPT    DETL
     C                   SETON                                        88
      *
      * ACCUMULATE COMPANY TOTALS
      *
     C                   ADD       AM$AMT        CO$AMT           12 2
     C                   ADD       AMDTAK        CODTAK           10 2
     C                   ADD       AM$NET        CO$NET           12 2
     C                   GOTO      NXT
      *
     C     END           TAG
     C   88              EXCEPT    TLR
     C  N88              EXCEPT    TLRN
     C                   SETON                                        LR
      *
     OAPR500    E            HDG            1 03
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
     O                                           55 'Monthly Disbursements'
     O                                           66 'For Period'
     O                       LBDATE        Y     76
     O                                           78 '-'
     O                       LEDATE        Y     87
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                     20                    69 '* Regular Checks *'
     O                     21                    68 '* Manual Checks *'
     O              N20N21                       67 '* All Checks *'
     O          E            HDG            1
     O                                            6 'Check'
     O                                           15 'Check'
     O                                           91 'Gross'
     O                                          103 'Discount'
     O                                          117 'Check'
     O                                          120 'T'
     O          E            HDG            0
     O                                            4 '#'
     O                                           15 'Date'
     O                                           25 'Vendor'
     O                                           64 'Description'
     O                                           91 'Amount'
     O                                          103 'Taken'
     O                                          117 'Amount'
     O                                          120 'P'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       AMCHEK        Z      6
     O                       AMCKDT        Y     15
     O                       AMVEND        Z     22
     O                       VMNAME              53
     O               12                          43 '** Invalid Vendor **'
     O              N23      TDES                80
     O               23                          78 '*** Voided Check ***'
     O                       AM$AMT        J     92
     O                       AMDTAK        J    104
     O                       AM$NET        J    118
     O                       AMCTYP             120
     O          E            TLR            1
     O                                           92 '=========='
     O                                          104 '=========='
     O                                          118 '============'
     O          E            TLR            1
     O                                           75 'Report Totals:'
     O                       CO$NET        JB   118
     O                       CODTAK        JB   104
     O                       CO$AMT        JB    92
     O          E            TLRN           1
     O                                           55 '**** There Are No Transa'
     O                                           78 'ctions For The Report S'
     O                                           92 'elections ****'
      *
