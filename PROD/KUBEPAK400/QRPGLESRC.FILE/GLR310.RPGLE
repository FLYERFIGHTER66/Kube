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
      *PROGRAM NAME-------- GLR310
      *SYSTEM-------------- GENERAL LEDGER
      *DESCRIPTION--------- RECURRING JOURNAL ENTRY EDIT LIST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFGLRJE    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFGLCTL    UF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FGLR310    O    F  120        PRINTER OFLIND(*INOF)
      *
     D POS             S              1    DIM(13)                              POSTED
     D SOU             S              1    DIM(13)                              SKIP OR USE
     D MSG             S             50    DIM(2) CTDATA PERRCD(1)
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
     D  LACTP                  3      4  0
     D  LBDATE                 5     10  0
     D  LEDATE                11     16  0
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
     IRGLRJE
     I              GJSP01                      SOU(1)
     I              GJSP02                      SOU(2)
     I              GJSP03                      SOU(3)
     I              GJSP04                      SOU(4)
     I              GJSP05                      SOU(5)
     I              GJSP06                      SOU(6)
     I              GJSP07                      SOU(7)
     I              GJSP08                      SOU(8)
     I              GJSP09                      SOU(9)
     I              GJSP10                      SOU(10)
     I              GJSP11                      SOU(11)
     I              GJSP12                      SOU(12)
     I              GJSP13                      SOU(13)
      *
     I              GJPP01                      POS(1)
     I              GJPP02                      POS(2)
     I              GJPP03                      POS(3)
     I              GJPP04                      POS(4)
     I              GJPP05                      POS(5)
     I              GJPP06                      POS(6)
     I              GJPP07                      POS(7)
     I              GJPP08                      POS(8)
     I              GJPP09                      POS(9)
     I              GJPP10                      POS(10)
     I              GJPP11                      POS(11)
     I              GJPP12                      POS(12)
     I              GJPP13                      POS(13)
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     LACTP         P                 2 0
      *
     C                   Z-ADD     LEDATE        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        PEDATE            7 0
      *
     C                   Z-ADD     1             FIRST             8 0
     C                   Z-ADD     1             CNT               8 0
      *
     C     LCO           CHAIN     FMCORG                             97
     C     LCO           CHAIN     FGLCTL                             97
      *
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       335098
     C                   READ      FGLRJE                                 90
     C   90              GOTO      END
      *
     C     GJCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     FIRST         IFNE      1
     C     GJJENM        ANDNE     OLJENM
     C     GJJEPR        ORNE      OLJEPR
     C                   SETON                                        33
     C                   ENDIF
     C   33              DO
     C                   Z-ADD     1             CNT
     C     TOTL1         IFNE      0
     C                   SETON                                        2077
     C                   ENDIF
     C                   EXCEPT    TL1
     C                   MOVEL     *BLANKS       ERR
     C                   Z-ADD     0             TOTL1
     C                   SETOFF                                       20
     C                   ENDDO
      *                                                                   GLR360
     C     SOU(P)        IFEQ      'S'
     C                   MOVEL     MSG(1)        ERR              50
     C                   ENDIF
     C     POS(P)        IFEQ      'Y'
     C     SOU(P)        ANDEQ     *BLANKS
     C                   MOVEL     MSG(2)        ERR              50
     C                   ENDIF
      *
     C                   ADD       GJ$AMT        TOTL1            10 2
     C                   ADD       GJ$AMT        TOTLR            10 2
      *                                                                   GLR360
      * CHAIN FOR G/L ACCOUNT DESCRIPTION                                 GLR360
      *                                                                   GLR360
     C     GLKEY         KLIST
     C                   KFLD                    GJCOMP
     C                   KFLD                    GJGLAC
     C     GLKEY         CHAIN     FMGLCH                             94                       GLR36
      *                                                                   GLR360
     C   OF              DO
     C                   EXCEPT    HDG
     C                   Z-ADD     1             CNT
     C                   ENDDO
      *
     C     CNT           IFEQ      1
     C                   SETON                                        50
     C                   ENDIF
     C                   EXCEPT    DETL
     C                   ADD       1             CNT
     C                   ADD       1             FIRST
     C                   Z-ADD     GJJENM        OLJENM            6 0
     C                   MOVEL     GJJEPR        OLJEPR            2
     C                   MOVEL     GJJESF        OLJESF            2
     C                   GOTO      NXT
      *
     C     END           TAG                                                                   GLR36
     C                   EXCEPT    TL1
     C                   EXCEPT    TLR
     C   77              EXCEPT    TLRE
     C   77              GOTO      NUPD
     C                   MOVEL     'Y'           GZOKRE
     C                   MOVEL     USERID        GZUSER
     C                   Z-ADD     TDATE         GZDTLA
     C                   Z-ADD     TIMOD         GZTIME
     C                   UPDATE    RGLCTL
     C     NUPD          TAG
     C                   SETON                                        LR
      *                                                                   GLR360
     OGLR310    E            HDG            1 03
     O                       PROGID              10
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          Z    120
     O                                          117 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           68 'G/L Recurring J.E. Pre-P'
     O                                           76 'ost Edit'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           59 'For Accounting Period:'
     O                       LACTP               62
     O                       LBDATE        Y     71
     O                                           73 '-'
     O                       LEDATE        Y     82
     O          E            HDG            1
     O                                           16 '----- J/E -----'
     O                                           59 'Last Per'
     O                                           69 'Account'
     O          E            HDG            1
     O                                            9 'Number'
     O                                           16 'Seq'
     O                                           33 'Description'
     O                                           58 'Posted'
     O                                           69 'Number'
     O                                           83 'Amount'
     O                                           97 'Reference'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O               50      GJJEPR               2
     O               50      GJJENM        Z      9
     O               50      GJJESF              12
     O                       GJSEQ#        Z     16
     O               50      GJJEDS              47
     O                       GJPSTL        Y     58
     O                       GJGLAC              69 '    -    '
     O                       GJ$AMT        M     88
     O                       GJDDES             120
     O          E            TL1            1
     O                                           89 '----------'
     O          E            TL1            2
     O               20                         120 '* Out of Balance Entry *'
     O                       ERR                 50
     O                                           60 'Totals:'
     O                       GJJEPR              63
     O                       OLJENM        Z     70
     O                       GJJESF              73
     O                       TOTL1         JB    88
     O          E            TLR            1
     O                                           89 '=========='
     O          E            TLR            2
     O                                           70 'Totals For Company:'
     O                       LCO                 73
     O                       TOTLR         JB    88
     O          E            TLRE           1
     O                                           34 '***** Recurring Entries '
     O                                           58 'Cannot Be Posted - There'
     O                                           82 ' Is An Out Of Balance Jo'
     O                                           99 'urnal Entry *****'
**
This J/E Is Scheduled To Be Skipped This Period
This J/E Was Previously Posted To This Period
