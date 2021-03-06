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
      *PROGRAM NAME-------- GLR619
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- MARK GLCTL AS POSTED
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFGLCTL    UF   E           K DISK
     FFGLCLOS   UF A E           K DISK
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
     D  LLIBR                 88     96
      **********************
      * READ GLRJE RECORDS *
      **********************
     C     LCO           CHAIN     FGLCTL                             90
     C                   Z-ADD     TDATE         GZPREY
     C                   MOVEL     'Y'           GZPRYN
     C                   MOVEL     'N'           GZYCYN
     C  N90              UPDATE    RGLCTL
     C     LCO           CHAIN     FGLCLOS                            90
     C                   MOVEL     LLIBR         GZLIBR
     C                   Z-ADD     LCO           GZCOMP
     C  N90              UPDATE    RGLCLOS
     C   90              WRITE     RGLCLOS
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
