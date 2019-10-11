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
      *PROGRAM NAME-------- LKAPER
      *SYSTEM-------------- LOOKUP
      *DESCRIPTION--------- ACCOUNTING PERIOD LOOKUP - NO SELECT LINE
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMAPER    IF   E           K DISK
     FLKAPERFM  CF   E             WORKSTN
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACCOMP            2 0
     C                   PARM                    VACTP             2 0
      *
     C     NXT           TAG
     C     ACCOMP        CHAIN     FMAPER                             90
     C     ACST13        IFGT      *ZEROS
     C                   SETON                                        72
     C                   ENDIF
     C                   WRITE     SCRNA
     C                   SETOFF                                       10
      *
     C                   READ      SCRNA                                  91
     C   KF              GOTO      END
      *
     C     END           TAG
     C                   SETON                                        LR
      *
