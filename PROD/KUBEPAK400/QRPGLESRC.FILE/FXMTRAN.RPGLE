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
      *PROGRAM NAME-------- FXMTRAN
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- FIX MTRAN - CHANGE FOR EACH FIX
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMTRAN    UF   E             DISK
      ** GET NEXT RECORD
     C     NXT           TAG
     C                   READ      FMTRAN                                 90
     C   90              GOTO      END
     C     MTTDAT        IFEQ      1010504
     C                   MOVE      *BLANKS       MTGLUD
     C                   UPDATE    RMTRAN
     C                   END
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
