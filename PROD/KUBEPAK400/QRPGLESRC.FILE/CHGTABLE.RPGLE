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
      *PROGRAM NAME-------- CHGTABLE
      *SYSTEM-------------- FIX FILE
      *APPLICATION--------- CHANGE TABLE IN FMINVT
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMINVT    UF   E             DISK
      *
     C     NXT           TAG
     C                   READ      FMINVT                                 90
     C                   SETOFF                                       50
     C   90              GOTO      END
     C     IMSIZE        IFNE      '162'
     C                   GOTO      NXT
     C                   ENDIF
     C     IMFTAB        IFNE      '02'
     C                   GOTO      NXT
     C                   ENDIF
     C                   MOVEL     '05'          IMFTAB
     C                   UPDATE    RMINVT
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
