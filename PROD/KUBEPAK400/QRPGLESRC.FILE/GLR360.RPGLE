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
      *PROGRAM NAME-------- GLR360                                        GLR360
      *SYSTEM-------------- GENERAL LEDGER                                GLR360
      *DESCRIPTION--------- LIST GENERAL JOURNAL                          GLR360
      *                                                                   GLR360
      *                                                                   GLR360
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFGLDETJD  IF   E           K DISK                                         GLR360
     FFMGLCH    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FGLR360    O    F  120        PRINTER OFLIND(*INOF)                        GLR360
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
     D  LACTP                  3      4  0
     D  LBCYMD                 5     11  0
     D  LECYMD                12     18  0
     D  LBDATE                19     24  0
     D  LEDATE                25     30  0
     D  LSRCE                 31     33
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
     C     LSRCE         IFGT      *BLANKS
     C                   SETON                                        77
     C                   ENDIF
      *
     C                   Z-ADD     1             FIRST             8 0
     C                   Z-ADD     1             CNT               8 0
      *
     C     LCO           CHAIN     FMCORG                             97
      *
     C                   EXCEPT    HDG
      *
     C                   Z-ADD     0             JENM              6 0
     C                   Z-ADD     0             ACCT              8 0
     C                   MOVEL     *BLANKS       JEPR              2
     C                   MOVEL     *BLANKS       JESF              2
     C     GTKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    JEPR
     C                   KFLD                    JENM
     C                   KFLD                    JESF
     C                   KFLD                    LBCYMD
     C                   KFLD                    LSRCE
     C                   KFLD                    ACCT
     C     GTKEY         SETLL     FGLDETJD
      *
     C     NXT           TAG
     C                   SETOFF                                       1112
     C                   READ      FGLDETJD                               90
     C   90              GOTO      END
      *                                                                   GLR360
     C     GTCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     GTCYMD        IFLT      LBCYMD
     C     GTCYMD        ORGT      LECYMD
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   77GTSRCE        IFNE      LSRCE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     FIRST         IFNE      1
     C     GTCYMD        ANDNE     OLCYMD
     C                   Z-ADD     1             CNT
     C                   EXCEPT    TL2
     C                   ENDIF
      *
     C                   MOVEL     GTJEPR        NWJE              8
     C                   MOVE      GTJENM        NWJE
     C                   MOVEL     NWJE          NWJENM           10
     C                   MOVE      GTJESF        NWJENM
      *
     C     FIRST         IFNE      1
     C     NWJENM        ANDNE     OLJENM
     C                   Z-ADD     1             CNT
     C                   EXCEPT    TL1
     C                   ENDIF
      *
      * CHECK FOR DEBIT OR CREDIT AMOUNT                                  GLR360
      *                                                                   GLR360
     C     GTDOL$        IFLT      0                                                           GLR36
     C                   ADD       GTDOL$        TODCRD           10 2                         GLR36
     C                   ADD       GTDOL$        TOJCRD           10 2                         GLR36
     C                   ADD       GTDOL$        TOCCRD           10 2                         GLR36
     C                   SETON                                        12
     C                   ENDIF
     C     GTDOL$        IFGT      0                                                           GLR36
     C                   ADD       GTDOL$        TODDEB           10 2                         GLR36
     C                   ADD       GTDOL$        TOJDEB           10 2                         GLR36
     C                   ADD       GTDOL$        TOCDEB           10 2                         GLR36
     C                   SETON                                        11
     C                   ENDIF
      *                                                                   GLR360
      * CHAIN FOR G/L ACCOUNT DESCRIPTION                                 GLR360
      *                                                                   GLR360
     C     GLKEY         KLIST
     C                   KFLD                    GTCOMP
     C                   KFLD                    GTACCT
     C     GLKEY         CHAIN     FMGLCH                             94                       GLR36
     C  N94              MOVEL     GCDESC        DESC             25
      *                                                                   GLR360
     C   OF              DO
     C                   EXCEPT    HDG
     C                   Z-ADD     1             CNT
     C                   ENDDO
      *
     C     CNT           IFEQ      1
     C                   SETON                                        50
     C                   ENDIF
      *
     C                   EXCEPT    DETL
     C                   SETON                                        88
      *
     C                   ADD       1             CNT
     C                   ADD       1             FIRST
     C                   Z-ADD     GTCYMD        OLCYMD            7 0
     C                   Z-ADD     GTJENM        OLJENU            6 0
     C                   Z-ADD     GTTDAT        OLTDAT            6 0
     C                   MOVEL     GTJEPR        OLJEPR            2
     C                   MOVEL     GTJESF        OLJESF            2
     C                   MOVEL     GTJEPR        OLJE              8
     C                   MOVE      GTJENM        OLJE
     C                   MOVEL     OLJE          OLJENM           10
     C                   MOVE      GTJESF        OLJENM
      *
     C                   GOTO      NXT
      *
     C     END           TAG                                                                   GLR36
     C   88              EXCEPT    TL1
     C   88              EXCEPT    TL2
     C   88              EXCEPT    TLR
     C  N88              EXCEPT    TLRN
     C                   SETON                                        LR
      *                                                                   GLR360
     OGLR360    E            HDG            1 03                                GLR360
     O                       PROGID              10                             GLR360
     O                                           25 'Requested by:'
     O                       USERID              36
     O                       RGNAMC              75                             GLR360
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            1                                   GLR360
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           67 'General Journal'           GLR360
     O                       TIMOD              120 '  :  :  '                  GLR360
     O          E            HDG            2                                   GLR360
     O                                           52 'For Period:'
     O                       LACTP               55
     O                       LBDATE        Y     66
     O                                           69 '-'
     O                       LEDATE        Y     79
     O               77                         116 'For Source:'               GLR360
     O               77      LSRCE              120
     O          E            HDG            1                                   GLR360
     O                                            8 'J.E.'                      GLR360
     O                                          106 '-------'                   GLR360
     O                                          120 'Amounts ------'            GLR360
     O          E            HDG            1                                   GLR360
     O                                            9 'Number'                    GLR360
     O                                           20 'Date'                      GLR360
     O                                           25 'SRC'                       GLR360
     O                                           39 'Explanation'               GLR360
     O                                           65 'Account'                   GLR360
     O                                           88 'Account Description'       GLR360
     O                                          105 'Debit'                     GLR360
     O                                          119 'Credit'                    GLR360
     O          E            HDG            2                                   GLR360
     O                                           24 '________________________'  GLR360
     O                                           48 '________________________'  GLR360
     O                                           72 '________________________'  GLR360
     O                                           96 '________________________'  GLR360
     O                                          120 '________________________'  GLR360
     O          E            DETL           1                                   GLR360
     O               12      GTDOL$        JB   120                             GLR360
     O               11      GTDOL$        1B   105                             GLR360
     O                       DESC                92                             GLR360
     O                       GTACCT              66 '    -    '                 GLR360
     O                       GTJEDS              56                             GLR360
     O                       GTSRCE              25                             GLR360
     O                       GTTDAT        Y     21                             GLR360
     O               50      GTJESF              12                             GLR360
     O               50      GTJENM        Z      9                             GLR360
     O               50      GTJEPR               2                             GLR360
     O          E            TL1         1  2                                   GLR360
     O                                           75 'Journal Entry Totals:'     GLR360
     O                       OLJEPR              78                             GLR360
     O                       OLJENU        Z     85                             GLR360
     O                       OLJESF              88                             GLR360
     O                       TOJDEB        1B   105                             GLR360
     O                       TOJCRD        JB   120                             GLR360
     O          E            TL2            1
     O                                          105 '------------'
     O                                          119 '------------'
     O          E            TL2            2                                   GLR360
     O                                           75 'Totals For Date:'          GLR360
     O                       OLTDAT        Y     85                             GLR360
     O                       TODDEB        1B   105                             GLR360
     O                       TODCRD        JB   120                             GLR360
     O          E            TLR            1
     O                                          105 '============'
     O                                          119 '============'
     O          E            TLR            2                                   GLR360
     O                                           75 'Company Totals:'           GLR360
     O                       LCO                 85                             GLR360
     O                       TOCDEB        1B   105                             GLR360
     O                       TOCCRD        JB   120                             GLR360
     O          E            TLRN           1
     O                                           45 '**** There Are No Transa'
     O                                           68 'ctions For This Account'
     O                                           92 'ing Period And/Or Source'
     O                                           97 ' ****'
