      *--------------------------------------------------------------     GLR400
      *                                                                   GLR400
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999                          GLR400
      *                                                                   GLR400
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO         GLR400
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE         GLR400
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED      GLR400
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR         GLR400
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT      GLR400
      *       BY EXPRESS WRITTEN PERMISSION OF                            GLR400
      *            EFD ENTERPRISES, INC.     215-643-5352                 GLR400
      *                                                                   GLR400
      *--------------------------------------------------------------     GLR400
      *PROGRAM NAME-        GLR400                                        GLR400
      *SYSTEM-              GENERAL LEDGER                                GLR400
      *APPLICATION-         FORMAT EXCEPTION REPORT                       GLR400
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFGLBAL    IF   E           K DISK
     FFGLFMIAC  IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FGLR400    O    F  120        PRINTER OFLIND(*INOF)                        GLR400
      *                                                                   GLR400
     D GLP             S             11  2 DIM(13)
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
     IRGLBAL
     I              GLT01                       GLP(1)
     I              GLT02                       GLP(2)
     I              GLT03                       GLP(3)
     I              GLT04                       GLP(4)
     I              GLT05                       GLP(5)
     I              GLT06                       GLP(6)
     I              GLT07                       GLP(7)
     I              GLT08                       GLP(8)
     I              GLT09                       GLP(9)
     I              GLT10                       GLP(10)
     I              GLT11                       GLP(11)
     I              GLT12                       GLP(12)
     I              GLT13                       GLP(13)
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN     FMCORG                             99                       GLR40
      *
     C                   EXCEPT    HDG
      *
     C                   Z-ADD     0             GLNO              8 0
     C     BKEY          KLIST
     C                   KFLD                    LCO                                           GLR40
     C                   KFLD                    GLNO                                          GLR40
     C     BKEY          SETLL     FGLBAL
     C     NXTB          TAG
     C                   READ      FGLBAL                                 90
     C   90              GOTO      END
      *                                                                   GLR400
     C     GLGLNO        CHAIN     FGLFMIAC                           92
     C  N92              GOTO      NXTB
      *
      * CHAIN FOR G/L ACCOUNT DESCRIPTION                                 GLR400
      *                                                                   GLR400
     C     GKEY          KLIST
     C                   KFLD                    GLCOMP                                        GLR40
     C                   KFLD                    GLGLNO                                        GLR40
     C     GKEY          CHAIN     FMGLCH                             50                       GLR40
      *                                                                   GLR400
     C                   XFOOT     GLP           AMT              11 2                         GLR40
     C     AMT           ADD       GLBALT        AMT                                           GLR40
      *
     C                   EXCEPT    DETL
     C                   SETON                                        77
     C                   GOTO      NXTB
      *                                                                   GLR400
     C     END           TAG                                                                   GLR40
     C  N77              EXCEPT    TLR
     C                   SETON                                        LR
      *
     OGLR400    E            HDG            1 03
     O                       PROGID              10
     O                                           25 'Requested by:'
     O                       USERID              36
     O                       RGNAMC              75
     O                                          115 'Page:'
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          1    120
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           68 'Format File Exception '
     O                                           74 'Report'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           11 'G/L'                       GLR400
     O                                          120 'Account'                   GLR400
     O          E            HDG            1
     O                                            2 'Co'                        GLR400
     O                                           13 'Account'                   GLR400
     O                                           35 'Description'               GLR400
     O                                           65 'Message'                   GLR400
     O                                          120 'Balance'                   GLR400
     O          E            HDG            2
     O                                           24 '________________________'  GLR570
     O                                           48 '________________________'  GLR570
     O                                           72 '________________________'  GLR570
     O                                           96 '________________________'  GLR570
     O                                          120 '________________________'  GLR570
     O          E            DETL           1                                   GLR400
     O                       GLCOMP         B     2                             GLR400
     O                       GLGLNO         B    13 '    -    '                 GLR400
     O                       GCDESC         B    44                             GLR400
     O                       AMT           JB   120                             GLR400
     O                                           68 '* This Account Has No'     GLR400
     O                                           82 'Report Format'             GLR400
     O                                           96 'File Record *'             GLR400
     O          E            TLR         2                                      GLR400
     O                                           68 '* All G/L Balance Rec'     GLR400
     O                                           82 'ords Are in a'             GLR400
     O                                           98 'Report Format *'           GLR400
