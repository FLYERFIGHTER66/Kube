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
      *PROGRAM NAME-------- ARR505
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- CREATE ARTOT FILE FOR STATEMENT PRINT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFAROPN    IF   E           K DISK
     FFARTOT    O  A E           K DISK
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
     D  LDATE                  3      8  0
     D  LBCUST                 9     14  0
     D  LECUST                15     20  0
     D  LZERO                 21     21
     D  LCRED                 22     22
     D  LSDATE                23     29  0
     D  LDAC                  67     75
     D  LDACL9                75     75  0
     D  LPRTR                100    109
     D  LFORM                110    113
     D  LCOPY                114    115  0
     D  LJOB                 116    116
     D  LHOLD                117    120
     D  LSAVE                121    124
     D  LCANCL               133    133
      *
     C                   Z-ADD     0             ARCUST
     C     ARCUST        SETLL     FAROPN
      *
     C     NXT           TAG
     C                   READ      FAROPN                                 90
     C   90              GOTO      END
      *
     C     ARCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     ARTDAT        IFGT      LSDATE
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     ARCUST        IFNE      OCUST
     C     CNT           ANDGT     1
     C                   Z-ADD     TOTAMT        RT$AMT
     C                   Z-ADD     OCUST         RTCUST
     C                   MOVEL     OLOOK         RTLOOK
     C                   WRITE     RARTOT
     C                   Z-ADD     0             TOTAMT
     C                   ENDIF
      *
     C                   Z-ADD     ARCUST        OCUST             6 0
     C                   MOVEL     ARLOOK        OLOOK            15
     C                   ADD       AR$AMT        TOTAMT           11 2
     C                   ADD       1             CNT               7 0
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   Z-ADD     TOTAMT        RT$AMT
     C                   Z-ADD     OCUST         RTCUST
     C                   MOVEL     OLOOK         RTLOOK
     C                   WRITE     RARTOT
     C                   SETON                                        LR
      *
