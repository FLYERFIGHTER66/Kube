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
      *PROGRAM NAME-------- ARR700
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- ANNUAL PROCESSING
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCUST    UF   E           K DISK
     FFARHST    UF   E           K DISK
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     NXTC          TAG
     C                   READ      FMCUST                                 90
     C   90              GOTO      NXTH
      *
     C                   Z-ADD     0             CMOYTD
     C                   Z-ADD     0             CMYSL$
     C                   Z-ADD     0             CMYCS$
     C                   UPDATE    RMCUST
     C                   GOTO      NXTC
      *
     C     NXTH          TAG
     C                   READ      FARHST                                 90
     C   90              GOTO      END
      *
     C                   Z-ADD     0             HS#INV
     C                   Z-ADD     0             HS#ORD
     C                   Z-ADD     0             HS#CRM
     C                   UPDATE    RARHST
     C                   GOTO      NXTH
      *
     C     END           TAG
     C                   SETON                                        LR
      *
