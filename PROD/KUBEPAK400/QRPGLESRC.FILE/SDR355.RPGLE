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
      **PROGRAM NAME-------- SDR355
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- PRINT ALL SERIES RECORDS WITH VENDOR
      *                      SELECTED
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFSERIESA  IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FSDR355    O    F  120        PRINTER OFLIND(*INOF)
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
     C     SEVND         IFLE      0
     C                   GOTO      NXT
     C                   END
     C     SEVND         CHAIN     FMVEND                             91
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   END
     C                   EXCEPT    DETL
     C                   GOTO      NXT
      ** END PROGRAM
     C     END           TAG
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
     OSDR355    E            HEAD           1 03
     O                                            6 'SDR355'
     O                                           20 'Requested by:'
     O                       USERID              31
     O                                           51 'Series With Vendor'
     O                                           60 'Selected'
     O                       PAGE          Z     81
     O                                           78 'Page:'
     O          E            HEAD           2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           72 'Time:'
     O                       TIMOD               81 '  :  :  '
     O          E            HEAD           1
     O                                           83 ' Price  '
     O          E            HEAD           0
     O                                           10 'Series    '
     O                                           22 'Description'
     O                                           45 'Form'
     O                                           55 'Vendor'
     O                                           83 'Per 1000'
     O          E            HEAD           1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O                                           83 '___'
     O          EF           DETL           1
     O                       SECODE              10
     O                       SEDESC              41
     O                       SEFORM              43
     O                       SEPRC         1     83
     O              N91      VMNAME              74
