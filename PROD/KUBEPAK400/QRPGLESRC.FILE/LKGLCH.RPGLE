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
      *PROGRAM NAME-------- LKGLCH
      *SYSTEM-------------- LOOKUP
      *DESCRIPTION--------- CHART OF ACCOUNTS LOOKUP
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMGLCHAL  IF   E           K DISK
     FLKGLCHFM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    GCLOOK
     C                   PARM                    VCO               2 0
     C                   PARM                    GCGLNO
     C                   PARM                    GCDESC
     C                   MOVE      GCLOOK        HLDLOK           15
     C                   MOVE      GCLOOK        VLOOK            15
     C                   MOVE      *BLANKS       OLDSRC           15
     C                   MOVE      *BLANKS       GCDESC
     C                   MOVE      *BLANKS       GCGLNO
      *
     C                   Z-ADD     0             LINE#
     C                   Z-ADD     0             VLINE
     C     NEWSRC        TAG
     C     VLOOK         SETLL     FMGLCHAL
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   MOVE      VLOOK         OLDSRC
     C     NXTX          TAG
     C                   MOVEL     *BLANKS       TYPE
     C                   SETOFF                                       50
     C                   READ      FMGLCHAL                               50
     C   50              GOTO      DSPL
     C     GCSTAT        IFEQ      'D'
     C                   GOTO      NXTX
     C                   ENDIF
      *
     C     GCCOMP        IFNE      VCO
     C                   GOTO      NXTX
     C                   ENDIF
      *
     C     GCATYP        IFEQ      1
     C                   MOVEL     'Asset'       TYPE
     C                   ENDIF
      *
     C     GCATYP        IFEQ      2
     C                   MOVEL     'Liabilit'    TYPE1             8
     C                   MOVEL     'y '          TYPE2             2
     C                   MOVEL     TYPE1         TYPE
     C                   MOVE      TYPE2         TYPE
     C                   ENDIF
      *
     C     GCATYP        IFEQ      3
     C                   MOVEL     'Revenue'     TYPE
     C                   ENDIF
      *
     C     GCATYP        IFEQ      4
     C                   MOVEL     'Expense'     TYPE
     C                   ENDIF
      *
     C                   ADD       1             RECNO
     C                   ADD       1             VLINE
     C                   WRITE     RECSFL
     C                   GOTO      NXTX
      *
     C     DSPL          TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       2             RECNO
     C                   Z-ADD     0             VLINE
     C                   MOVEL     '* End of'    ENDFLD           16
     C                   MOVE      ' Data * '    ENDFLD
     C                   MOVEL     ENDFLD        GCDESC
     C                   Z-ADD     0             GCCOMP
     C                   Z-ADD     0             GCGLNO
     C                   Z-ADD     0             GCATYP
     C                   MOVEL     *BLANKS       TYPE
     C                   WRITE     RECSFL
      *
     C     NXTFMT        TAG
     C                   Z-ADD     0             LINE
     C                   EXFMT     RECCTL
     C                   SETOFF                                       90
     C   KF              DO
     C                   MOVE      *BLANKS       GCDESC
     C                   MOVE      *BLANKS       TYPE
     C                   Z-ADD     0             GCGLNO
     C                   Z-ADD     0             GCCOMP
     C                   Z-ADD     0             GCATYP
     C                   GOTO      END
     C                   ENDDO
      * SEE IF ON A SUBFILE LINE
     C     LINE          IFGT      0
     C     LINE          ANDLE     LSTREC
     C     LINE          CHAIN     RECSFL                             90
     C   90              GOTO      NXTFMT
     C                   GOTO      END
     C                   ELSE
     C                   Z-ADD     0             LINE
     C                   END
     C     LINE#         IFGT      LSTREC
     C                   SETON                                        90
     C                   GOTO      NXTFMT
     C                   END
     C     VLOOK         IFNE      OLDSRC
     C                   GOTO      NEWSRC
     C                   END
     C     LINE#         IFEQ      0
     C                   GOTO      NXTFMT
     C                   END
      *
      * GET THE SELECTED ITEM
      *
     C                   Z-ADD     LINE#         RECNO
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTFMT
     C     END           TAG
     C                   SETON                                        LR
      **
