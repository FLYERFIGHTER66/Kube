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
      *PROGRAM NAME-------- FXSOHST
      *SYSTEM-------------- FIX FILE
      *APPLICATION--------- CHANGE FSOHST AS NEEDED
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMSALE    UF   E             DISK
      *
     C     NXT           TAG
     C                   READ      FMSALE                                 90
     C                   SETOFF                                       50
     C   90              GOTO      END
     C     MSSHPR        IFEQ      99
     C                   MOVE      MSTDAT        WRK4              4 0
     C                   MOVEL     WRK4          MSSHPR
     C                   MOVEL     'P'           MSARUD
     C                   UPDATE    RMSALE
     C                   END
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
