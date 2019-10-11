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
      *PROGRAM NAME-------- LKGLRF
      *SYSTEM-------------- LOOKUP
      *DESCRIPTION--------- G/L REPORT REFERENCE LOOKUP
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFGLREFA   IF   E           K DISK
     FLKGLRFFM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
      * TYPE ARRAY
     D MSG             S             20    DIM(5) CTDATA PERRCD(1)              TYPE REPORT
      *
     C     *ENTRY        PLIST
     C                   PARM                    GXLOOK
     C                   PARM                    GXRPRT
     C                   PARM                    GXRTYP
     C                   MOVE      GXLOOK        HLDLOK           15
     C                   MOVE      GXLOOK        VLOOK            15
     C                   Z-ADD     GXRTYP        HLDTYP            1 0
     C                   MOVE      *BLANKS       OLDSRC           15
      *
     C                   Z-ADD     0             LINE
     C                   Z-ADD     0             VLINE
     C     VLOOK         SETLL     FGLREFA
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   MOVE      VLOOK         OLDSRC
     C     NXTX          TAG
     C                   SETOFF                                       50
     C                   READ      FGLREFA                                50
     C   50              GOTO      DSPL
     C     HLDTYP        IFGT      0
     C     HLDTYP        ANDNE     GXRTYP
     C                   GOTO      NXTX
     C                   ENDIF
      *
     C                   ADD       1             RECNO
     C                   ADD       1             VLINE
     C                   MOVEL     MSG(GXRTYP)   TYPE
     C                   WRITE     RECSFL
     C                   GOTO      NXTX
      *
     C     DSPL          TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       1             RECNO
     C                   Z-ADD     0             VLINE
     C                   MOVE      *BLANKS       GXRPRT
     C                   MOVE      *BLANKS       GXLOOK
     C                   MOVE      *BLANKS       GXSTAT
     C                   MOVE      *BLANKS       TYPE
     C                   Z-ADD     *ZEROS        GXCOMP
     C                   WRITE     RECSFL
     C                   ADD       1             RECNO
     C                   MOVEL     '* End of'    ENDD             15
     C                   MOVE      ' Data *'     ENDD
     C                   MOVEL     ENDD          GXLOOK
     C                   WRITE     RECSFL
      *
     C     NXTFMT        TAG
     C                   Z-ADD     0             LINE#
     C                   Z-ADD     0             LINE
     C                   EXFMT     RECCTL
     C   KF              MOVEL     *BLANKS       GXLOOK
     C   KF              MOVEL     *BLANKS       GXRPRT
     C   KF              GOTO      END
     C                   SETOFF                                       90
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
** REPORT TYPE
Balance Sheet
Income Statement
Trial Balance
Budget
Combined
