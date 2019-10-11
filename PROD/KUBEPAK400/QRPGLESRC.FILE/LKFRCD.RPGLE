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
      *PROGRAM NAME-------- LKFRTZ
      *SYSTEM-------------- LOOK UP
      *DESCRIPTION--------- FREIGHT ZONE LOOKUP
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFFPERC    IF   E           K DISK
     FLKFRCDFM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
      * TYPE DESCRIPTION
     D MSG             S              6    DIM(2) CTDATA PERRCD(1)
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    FPCONO
     C                   PARM                    FPCODE
      *
     C                   Z-ADD     0             LINE
     C                   Z-ADD     0             VLINE
     C     FPCONO        SETLL     FFPERC
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     NXTX          TAG
     C                   SETOFF                                       50
     C     FPCONO        READE     FFPERC                                 50
     C   50              GOTO      DSPL
      *
     C     FPTYPE        IFEQ      'P'
     C                   MOVEL     MSG(1)        TYPE
     C                   ELSE
     C                   MOVEL     MSG(2)        TYPE
     C                   END
     C                   ADD       1             RECNO
     C                   ADD       1             VLINE
     C                   WRITE     RECSFL
     C                   GOTO      NXTX
      *
     C     DSPL          TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       1             RECNO
     C                   Z-ADD     0             VLINE
     C                   MOVEL     *BLANKS       FPCODE
     C                   MOVEL     *BLANKS       FPDESC
     C                   MOVE      *BLANKS       TYPE
     C                   Z-ADD     0             FPCHRG
     C                   Z-ADD     0             FPMIN
     C                   Z-ADD     0             FPMAX
     C                   WRITE     RECSFL
     C                   ADD       1             RECNO
     C                   MOVEL     'End of'      FPCODE
     C                   MOVEL     'Data ***'    TYPE
     C                   WRITE     RECSFL
      *
     C     NXTFMT        TAG
     C                   Z-ADD     0             LINE#
     C                   Z-ADD     0             LINE
     C                   EXFMT     RECCTL
     C                   SETOFF                                       90
     C   KF              DO
     C                   MOVEL     *BLANKS       FPCODE
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
     C                   MOVEA     '0'           *IN
     C                   SETON                                        LR
      **
**  TYPE
Percent
Flat Rate
