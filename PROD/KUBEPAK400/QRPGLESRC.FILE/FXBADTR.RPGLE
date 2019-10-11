      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2002
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
      *PROGRAM NAME-------- FXBADTR
      *SYSTEM-------------- BAR CODES
      *APPLICATION--------- FIX BADTR - CHANGE FOR EACH FIX
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFBADTR    UF   E           K DISK
      *
      ** GET NEXT RECORD
     C     NXT           TAG
     C                   READ      FBADTR                                 90
     C   90              GOTO      END
     C*          BTSCYM    IFNE 1020128
     C                   DELETE    RBADTR
     C*                    END
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
