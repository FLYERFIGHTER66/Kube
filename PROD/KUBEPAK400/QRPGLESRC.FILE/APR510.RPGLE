      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC. 1999
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
      *PROGRAM NAME--------- APR510
      *SYSTEM--------------- ACCOUNTS PAYABLE
      *DESCRIPTION---------- MONTHLY EXPENSE DISTRIBUTION.
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 2/19/01 EFD01 MISCELLANEOUS PRINTING CORRECTIONS
      *
      *
      *
     FFAPDETGL  IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FAPR510    O    F  120        PRINTER OFLIND(*INOF)
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
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         BDATE             5 0
     C                   Z-ADD     LEDATE        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         EDATE             5 0
      *
     C     LCO           CHAIN     FMCORG                             97
      *
     C                   Z-ADD     1             CNT               6 0
     C                   Z-ADD     1             FIRST             6 0
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       88
     C                   READ      FAPDETGL                               90
     C   90              GOTO      END
      *
     C     ADCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     ADAPER        IFGT      0
     C                   Z-ADD     ADAPER        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         GDATE             5 0
     C                   ENDIF
      *
     C     GDATE         IFLT      BDATE
     C     GDATE         ORGT      EDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     FIRST         IFNE      1
     C     ADGLA1        ANDNE     OLGLA1
     C                   Z-ADD     1             CNT
     C                   EXCEPT    TL1
EFD01C                   SETOFF                                       78
     C                   ENDIF
      *
     C     KEYGL         KLIST
     C                   KFLD                    ADCOMP
     C                   KFLD                    ADGLA1
     C     CNT           IFEQ      1
     C                   SETON                                        88
     C     KEYGL         CHAIN     FMGLCH                             98
     C  N98              MOVEL     GCDESC        SVDESC           25
     C  N98              MOVEL     GCDESC        OFDESC           15
     C                   ENDIF
      *
     C     ADVEND        CHAIN     FMVEND                             96
     C  N96              MOVEL     VMNAME        SVVNAM           15
      *
     C                   ADD       ADGL$1        TGLAMT           13 2          TOTAL FOR G/L
     C                   ADD       ADGL$1        TCOAMT           13 2          TOTAL FOR COMP
     C                   ADD       1             Y                 1 0          FOR LR PAGE
      *
     C   OF              DO
     C                   EXCEPT    HDG
EFD01C   78              EXCEPT    DOF
     C                   ENDDO
     C                   MOVEL     ADTDES        TDES             19
     C                   EXCEPT    DETL
EFD01C                   SETON                                        7778
     C                   ADD       1             CNT
     C                   ADD       1             FIRST
     C                   MOVEL     GCDESC        OLDESC           30
     C                   Z-ADD     ADGLA1        OLGLA1            8 0
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    TL1
     C                   EXCEPT    TLR
     C                   SETON                                          LR
      *
     OAPR510    E            HDG            1 03
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
     O                                           52 'Monthly Expense Distr'
     O                                           70 'ibution For Period'
     O                       LBDATE        Y     79
     O                                           81 '-'
     O                       LEDATE        Y     90
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           18 'Account'
     O                                           44 'Acct/Per'
     O                                           51 'Vouch'
     O                                           61 'Invoice'
     O                                           64 'T'
     O                                           93 'Vendor'
     O          E            HDG            0
     O                                           21 'G/L Acct  Description'
     O                                           42 'Date'
     O                                           49 '#'
     O                                           61 'Number'
     O                                           64 'P'
     O                                           76 'Description'
     O                                           99 ' #     Name'
     O                                          120 'Amount'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DOF         0  0
     O                       ADGLA1               9 '    -    '
     O                       OFDESC              25
     O                                           35 '-Continued'
     O          E            DETL           1
     O               88      ADGLA1               9 '    -    '
     O               88N98   SVDESC              35
     O               88 98                       33 '* Account Not On File *'
     O                       ADAPER        Y     44
     O                       ADVOUC        Z     51
     O                       ADINV#              62
     O                       ADITYP              64
     O                       TDES                84
     O                       ADVEND        Z     91
     O                       SVVNAM         B   107
     O                       ADGL$1        K    119
     O          E            TL1         1  2
     O                                           66 'Totals For G/L Acct'
     O                       OLGLA1              76 '    -    '
     O                       OLDESC         B   107
     O               98                         100 '* Account Not On File *'
     O                       TGLAMT        KB   119
     O                                          120 '*'
     O          E            TLR         2
     O               77                         100 'Totals for Report'
EFD01O               77      TCOAMT        JB   119
EFD01O              N77                          50 'There Are No Records Ava'
EFD01O              N77                          74 'ilable For This Accounti'
EFD01O              N77                          83 'ng Period'
      *
