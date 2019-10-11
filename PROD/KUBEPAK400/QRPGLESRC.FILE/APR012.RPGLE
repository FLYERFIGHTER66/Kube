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
      *PROGRAM NAME-------- APR012
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- VENDOR MASTER MAINTENANCE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FFPOHDRVE  IF   E           K DISK
      *
     C     *ENTRY        PLIST
     C                   PARM                    VVEND             6 0
     C                   PARM                    ERROR             1
      *
     C     VVEND         SETLL     FPOHDRVE
     C     NXT           TAG
     C     VVEND         READE     FPOHDRVE                               90
     C   90              GOTO      END
     C     PHSTAT        IFEQ      'A'
     C     PHCLOS        ANDNE     'Y'
     C                   MOVEL     'X'           ERROR             1
     C                   GOTO      END
     C                   ENDIF
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
