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
      *PROGRAM NAME-------- FXHORDW
      *SYSTEM-------------- FIX FILE
      *APPLICATION--------- CHANGE FHORDW AS NEEDED
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFHORDW    UF   E           K DISK
      *
     C     NXT           TAG
     C                   READ      FHORDW                                 90
     C   90              GOTO      END
     C     WHDTAC        IFGT      1010000
     C                   GOTO      NXT
     C                   END
     C     WHDTAC        IFLT      1010000
     C     WHDTAC        ANDGT     0000000
     C                   DELETE    RHORDW
     C                   GOTO      NXT
     C                   END
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
