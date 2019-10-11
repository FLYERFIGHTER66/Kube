      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
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
      **PROGRAM NAME-------- SDR350
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- PRINT ALL SERIES RECORDS WITH NO VENDOR
      *                      SELECTED
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFSERIESA  IF   E           K DISK
     FSDR350    O    F  120        PRINTER OFLIND(*INOF)
      *
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ****************
      *   LDA        *
      ****************
     D                UDS
     D**                                      1   20LCO                   ARC380
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
      ***********************
      *   START HERE        *
      ***********************
     C     NXT           TAG
     C                   READ      FSERIESA                               90
     C   90              GOTO      END
     C     SEVND         IFGT      0
     C                   GOTO      NXT
     C                   END
     C                   ADD       1             COUNT
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   END
     C                   EXCEPT    DETL
     C                   GOTO      NXT
      ** END PROGRAM
     C     END           TAG
     C     COUNT         IFLE      0
     C   OF              EXCEPT    HEAD
     C                   EXCEPT    TOTOK
     C                   ELSE
     C                   EXCEPT    TOTERR
     C                   END
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   SETON                                        OF
     C                   Z-ADD     0             COUNT             5 0
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OSDR350    E            HEAD           1 03
     O                                            6 'SDR350'
     O                                           20 'Requested by:'
     O                       USERID              31
     O                                           51 'Series With No Vendor'
     O                                           60 'Selected'
     O                       PAGE          Z     81
     O                                           78 'Page:'
     O          E            HEAD           2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           72 'Time:'
     O                       TIMOD               81 '  :  :  '
     O          E            HEAD           0
     O                                           20 'Series    '
     O                                           32 'Description'
     O                                           62 'Form'
     O          E            HEAD           1
     O                                           20 '__________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           62 '__'
     O          EF           DETL           1
     O                       SECODE              20
     O                       SEDESC              51
     O                       SEFORM              60
     O          E            TOTOK       2  1
     O                                           40 'No Series Records found'
     O                                           64 'Without Selected Vendor'
     O          E            TOTERR      2  1
     O                       COUNT         2     20
     O                                           40 'Error Records Found'
