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
      *****************************************************************
      *PROGRAM NAME------- GLR150
      *SYSTEM------------- GENERAL LEDGER
      *DESCRIPTION-------- FORMAT MASTER LIST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFGLFMH    IF   E           K DISK
     FFGLFMI    IF   E           K DISK
     FFGLREF    IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FGLR150    O    F  120        PRINTER OFLIND(*INOF)
      *
     D                UDS
     D  LCO                    1      2  0
     D  LREF                   3     10
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
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
     C     LCO           CHAIN(N)  FMCORG                             90
      *
     C     RKEY          KLIST
     C                   KFLD                    LCO
     C                   KFLD                    LREF
     C     RKEY          CHAIN     FGLREF                             90
      *
     C     GLKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GIGLAC
      *
     C     GXRTYP        IFEQ      1                                                        T
     C                   SETON                                        01
     C                   ENDIF
     C     GXRTYP        IFEQ      2                                                        T
     C                   SETON                                        02
     C                   ENDIF
     C     GXRTYP        IFEQ      3                                                        T
     C                   SETON                                        03
     C                   ENDIF
     C     GXRTYP        IFEQ      4                                                        T
     C                   SETON                                        04
     C                   ENDIF
      *
     C                   EXCEPT    HDG
      *
      * READ FORMAT MASTER
      *
     C     RKEY          SETLL     FGLFMH
     C     NXTH          TAG
     C                   READ      FGLFMH                                 91
     C   91              GOTO      END
      *
     C     GHLVBR        IFEQ      'H'
     C                   EXCEPT    DETH
     C                   GOTO      NXTH
     C                   ENDIF
      *
     C     GHLVBR        IFEQ      '1'
     C                   Z-ADD     1             CNT               6 0
     C     IKEY          KLIST
     C                   KFLD                    LCO
     C                   KFLD                    LREF
     C                   KFLD                    GHGRUP
     C     IKEY          SETLL     FGLFMI
     C     NXTI          TAG
     C     IKEY          READE     FGLFMI                                 10
     C   10              GOTO      NXTH
      *
     C     GISTAT        IFEQ      'D'
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     GLKEY         CHAIN     FMGLCH                             97
     C     CNT           IFEQ      1
     C                   SETON                                        20
     C                   ENDIF
      *
     C                   EXCEPT    DETI
     C                   ADD       1             CNT
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     GHLVBR        IFNE      'H'
     C     GHLVBR        ANDNE     '1'
     C                   EXCEPT    DETH
     C                   GOTO      NXTH
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      *
     OGLR150    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested by:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                                          114 'Page:'
     O                       PAGE          1    120
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           72 'Format File Master List'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           53 'For Format:'
     O                       GXRPRT              62
     O                       GXLOOK              78
     O          E            HDG            1
     O               01                          66 'Balance Sheet'
     O               02                          68 'Income Statement'
     O               03                          66 'Trial Balance'
     O               04                          63 'Budget'
     O          E            HDG            1
     O                                           56 'Space'
     O          E            HDG            1
     O                                            5 'Group'
     O                                           56 'B  A'
     O                                           70 'Rev'
     O                                           74 'Lev'
     O                                           78 'Seq'
     O                                           87 'Account'
     O                                          106 'G/L Account Desc.'
     O                                          120 'Dept'
     O          E            HDG            1
     O                                            3 '#'
     O                                           37 'Report Description'
     O                                           56 'F  F'
     O                                           71 'Sign'
     O                                           75 'Brk'
     O                                           86 'Number'
     O                                          119 'No'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETH           1
     O                       GHGRUP        Z      4
     O                       GHDESC              45
     O                       GHSPBF              53
     O                       GHSPAF              56
     O                       GHRVSN              70
     O                       GHLVBR              74
     O                       GHDPSQ        Z    120
      *
     O          E            DETI           1
     O                       GISEQ#        Z     78
     O                       GIGLAC              88 '    -    '
     O                       GCDESC             114
     O                       GIDPSQ        Z    120
      *
