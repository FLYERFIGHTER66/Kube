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
      *PROGRAM NAME-------- FXIORDW
      *SYSTEM-------------- FIX FILE
      *APPLICATION--------- CHANGE FIORDW AS NEEDED
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFIORDW    UF   E           K DISK
      *
     C     NXT           TAG
     C                   READ      FIORDW                                 90
     C   90              GOTO      END
     C     WIRIND        IFGT      1010000
     C                   GOTO      NXT
     C                   END
     C     WIRIND        IFLT      1010000
     C     WIRIND        ANDGT     0000000
     C                   DELETE    RIORDW
     C                   GOTO      NXT
     C                   END
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
