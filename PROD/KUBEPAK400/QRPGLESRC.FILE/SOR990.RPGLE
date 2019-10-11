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
      *PROGRAM NAME--------- SOR990
      *APPLICATION---------- SHIPPED ORDER HISTORY
      *DESCRIPTION---------- PURGE RECORDS
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FSOC990FM  O    E             WORKSTN
     FFSOHST    UF   E           K DISK
     F                                     RENAME(RSOHST:SOHSTI)
     FFSOHSTOO  O  A E           K DISK
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
     D  LDATE                  3      8  0
     D  LPDATE                 9     15  0
     D  LOKAY                 16     16
     D  LFILE                 17     26
     D  LCANCL               133    133
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     0             PRECS
     C                   Z-ADD     0             DRECS
     C     NXT           TAG
     C                   READ      FSOHST                                 90
     C   90              GOTO      END
     C     SOSHDT        IFLE      LPDATE
     C                   WRITE     RSOHST
     C                   DELETE    SOHSTI
     C                   ADD       1             DRECS
     C                   END
     C                   ADD       1             PRECS
     C                   ADD       1             TRECS
     C     TRECS         IFEQ      1000
     C                   WRITE     SCRNB
     C                   Z-ADD     0             TRECS             5 0
     C                   END
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      *
