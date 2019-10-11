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
      *PROGRAM NAME-------- LKPRCD
      *SYSTEM-------------- LOOK UP
      *DESCRIPTION--------- PRODUCTION CODE LOOKUP
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFPRODCD   IF   E           K DISK
     FLKPRCDFM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    PCCODE            3
     C                   PARM                    PCDESC           30
     C                   MOVE      PCCODE        HLDLOK            3
     C                   MOVE      PCCODE        VLOOK             3
     C                   MOVE      *BLANKS       OLDSRC            3
      *
     C                   Z-ADD     0             LINE
     C                   Z-ADD     0             VLINE
     C     VLOOK         SETLL     FPRODCD
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   MOVE      VLOOK         OLDSRC
     C     NXTX          TAG
     C                   SETOFF                                       50
     C                   READ      FPRODCD                                50
     C   50              GOTO      DSPL
      *
     C                   ADD       1             RECNO
     C                   ADD       1             VLINE
     C                   WRITE     RECSFL
     C                   GOTO      NXTX
      *
     C     DSPL          TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       1             RECNO
     C                   Z-ADD     0             VLINE
     C                   MOVE      *BLANKS       PCCODE
     C                   MOVE      *BLANKS       PCDESC
     C                   WRITE     RECSFL
     C                   ADD       1             RECNO
     C                   MOVEL     '* End of'    ENDD             16
     C                   MOVE      ' Data * '    ENDD
     C                   MOVEL     ENDD          PCDESC
     C                   WRITE     RECSFL
      *
     C     NXTFMT        TAG
     C                   Z-ADD     0             LINE#
     C                   Z-ADD     0             LINE
     C                   EXFMT     RECCTL
     C                   SETOFF                                       90
     C   KF              DO
     C                   MOVEL     *BLANKS       PCCODE
     C                   MOVEL     *BLANKS       PCDESC
     C                   GOTO      END
     C                   ENDDO
      ** SEE IF ON A SUBFILE LINE
     C     LINE          IFGT      0
     C     LINE          ANDLE     LSTREC
     C     LINE          CHAIN     RECSFL                             90
     C   90              GOTO      NXTFMT
     C                   GOTO      END
     C                   ELSE
     C                   Z-ADD     0             LINE
     C                   END
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
