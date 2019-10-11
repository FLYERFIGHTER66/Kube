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
      *PROGRAM NAME-------- GLR612
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- CLEAR POST FLAGS IN GLRJE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFGLRJE    UF   E           K DISK
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
      **********************
      * READ GLRJE RECORDS *
      **********************
     C     LCO           SETLL     FGLRJE
     C     NXT           TAG
     C     LCO           READE     FGLRJE                                 90
     C   90              GOTO      END
     C                   MOVE      *BLANKS       GJPP01
     C                   MOVE      *BLANKS       GJPP02
     C                   MOVE      *BLANKS       GJPP03
     C                   MOVE      *BLANKS       GJPP04
     C                   MOVE      *BLANKS       GJPP05
     C                   MOVE      *BLANKS       GJPP06
     C                   MOVE      *BLANKS       GJPP07
     C                   MOVE      *BLANKS       GJPP08
     C                   MOVE      *BLANKS       GJPP09
     C                   MOVE      *BLANKS       GJPP10
     C                   MOVE      *BLANKS       GJPP11
     C                   MOVE      *BLANKS       GJPP12
     C                   MOVE      *BLANKS       GJPP13
     C                   UPDATE    RGLRJE
     C                   GOTO      NXT
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
