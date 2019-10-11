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
      *PROGRAM NAME-------- FXARHISDT
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- FIX HIST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFARHIST   UF   E           K DISK
      ** GET NEXT RECORD
     C     NXT           TAG
     C                   READ      FARHIST                                90
     C   90              GOTO      END
     C     AHSEQ#        IFEQ      000
     C                   Z-ADD     AHDUDT        DUDT              7 0
     C                   ELSE
     C                   Z-ADD     DUDT          AHDUDT
     C                   UPDATE    RARHIS
     C                   END
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
