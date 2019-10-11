      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1996
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
      **PROGRAM NAME-------- LKALTP
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- GD
      **DESCRIPTION--------- ALTERNATE PRICE CODE LOOKUP
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMALTP    IF   E           K DISK
     FLKALTPFM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    ALCODE            1
     C                   MOVE      ALCODE        HLDLOK            1
     C                   MOVE      ALCODE        VLOOK             1
     C                   MOVE      *BLANKS       OLDSRC            1
      *
     C                   Z-ADD     0             LINE
     C     VLOOK         SETLL     FMALTP
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   MOVE      VLOOK         OLDSRC
     C     NXTX          TAG
     C                   SETOFF                                       50
     C                   READ      FMALTP                                 50
     C   50              GOTO      DSPL
      *
     C                   ADD       1             RECNO
     C                   ADD       1             LINE
     C                   WRITE     RECSFL
     C                   GOTO      NXTX
      *
     C     DSPL          TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       1             RECNO
     C                   Z-ADD     0             LINE
     C                   MOVE      *BLANKS       ALCODE
     C                   Z-ADD     *ZEROS        ALBDTE
     C                   Z-ADD     *ZEROS        ALEDTE
     C                   Z-ADD     *ZEROS        ALUPRI
     C                   WRITE     RECSFL
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
      *
     C     NXTFMT        TAG
     C                   EXFMT     RECCTL
     C   KF              MOVEL     *BLANKS       ALCODE
     C   KF              Z-ADD     *ZEROS        ALBDTE
     C   KF              Z-ADD     *ZEROS        ALEDTE
     C   KF              Z-ADD     *ZEROS        ALUPRI
     C   KF              GOTO      END
     C     LINE#         IFEQ      0
     C                   GOTO      NXTFMT
     C                   END
     C     LINE#         IFGT      LSTREC
     C                   SETON                                        90
     C                   GOTO      NXTFMT
     C                   END
      ** GET THE SELECTED ITEM
     C                   Z-ADD     LINE#         RECNO
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTFMT
     C     END           TAG
     C                   SETON                                        LR
      **
