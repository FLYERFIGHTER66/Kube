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
      *PROGRAM NAME-------- LKACTP
      *SYSTEM-------------- LOOKUP
      *DESCRIPTION--------- ACCOUNTING PERIOD LOOKUP
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMAPER    IF   E           K DISK
     FLKACTPFM  CF   E             WORKSTN
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACCOMP            2 0
     C                   PARM                    VACTP             2 0
     C                   Z-ADD     0             VACTP
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
     C   72VACTP         IFGT      13
     C                   SETON                                        10
     C   10              GOTO      NXT
     C                   ENDIF
     C  N72VACTP         IFGT      12
     C                   SETON                                        10
     C   10              GOTO      NXT
     C                   ENDIF
      *
     C     END           TAG
     C                   MOVEA     '0'           *IN
     C                   SETON                                        LR
      *
