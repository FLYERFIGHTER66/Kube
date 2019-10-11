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
      *PROGRAM NAME-------- LKDISC
      *SYSTEM-------------- LOOKUP
      *DESCRIPTION--------- PRODUCT CLASS 3 DISCOUNT LOOKUP
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  4/05/99 EFD ALLOW BLANK DEPARTMENT TO VIEW ALL
      *
     FFQDISC    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FLKDISCFM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
      *
      * MESSAGE ARRAY
     D MSG             S             30    DIM(1) CTDATA PERRCD(1)
      *
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    QCLOC
     C                   PARM                    QCPCL3
     C                   PARM                    QCDESC
     C                   MOVE      QCPCL3        HLDLOK            2
     C                   MOVE      QCPCL3        VLOOK             2
     C                   MOVE      *BLANKS       OLDSRC            2
     C                   MOVEL     QCLOC         OLOC              3
      *
     C                   Z-ADD     0             LINE
     C                   Z-ADD     0             VLINE
     C     QCLOC         SETLL     FQDISC
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   MOVE      VLOOK         OLDSRC
     C     NXTX          TAG
     C                   SETOFF                                       50
     C     OLOC          IFGT      *BLANKS
     C     QCLOC         READE     FQDISC                                 50
     C                   ELSE
     C                   READ      FQDISC                                 50
     C                   END
     C   50              GOTO      DSPL
     C     QCLOC         IFGT      *BLANKS
     C     QCLOC         CHAIN     FMDEPT                             71
     C                   ELSE
     C                   MOVEL     MSG(1)        DEDESC
     C                   END
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
     C                   MOVE      *BLANKS       QCPCL3
     C                   MOVE      *BLANKS       QCDESC
     C                   MOVE      *BLANKS       DEDESC
     C                   MOVE      *BLANKS       DEDEPT
     C                   WRITE     RECSFL
     C                   ADD       1             RECNO
     C                   MOVEL     '* End of'    ENDD             16
     C                   MOVE      ' Data * '    ENDD
     C                   MOVEL     ENDD          QCDESC
     C                   WRITE     RECSFL
      *
     C     NXTFMT        TAG
     C                   Z-ADD     0             LINE#
     C                   Z-ADD     0             LINE              5 0
     C                   EXFMT     RECCTL
     C   KF              MOVEL     *BLANKS       QCPCL3
     C   KF              MOVEL     *BLANKS       QCDESC
     C   KF              GOTO      END
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
** MESSAGE
All Departments
