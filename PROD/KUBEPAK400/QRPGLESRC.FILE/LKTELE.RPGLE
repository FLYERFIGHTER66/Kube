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
      *PROGRAM NAME-------- LKTELE
      *SYSTEM-------------- LOOKUP
      *DESCRIPTION--------- LOOKUP CUSTOMER BY TELEPHONE NUMBER
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCUSTTL  IF   E           K DISK
     FLKTELEFM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    CMPHON           10 0
     C                   PARM                    CMCUST            6 0
     C                   PARM                    CMNAME           30
     C                   MOVEL     CMPHON        HLDLOK           10
     C                   MOVEL     CMPHON        VLOOK            10
     C                   MOVE      *BLANKS       OLDSRC           10
      *
     C                   Z-ADD     0             LINE
     C                   Z-ADD     0             VLINE
     C     NEWSRC        TAG
     C                   Z-ADD     0             VLOOKN           10 0
     C                   MOVEL     VLOOK         VLOOKN
     C                   MOVEL     VLOOK         OLDSRC
     C                   MOVEL     VLOOK         OTEST             3
     C     VLOOKN        SETLL     FMCUSTTL
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     NXTX          TAG
     C                   SETOFF                                       50
     C                   READ      FMCUSTTL                               50
     C   50              GOTO      DSPL
     C     CMSTAT        IFEQ      'D'
     C                   GOTO      NXTX
     C                   ENDIF
     C                   MOVEL     CMPHON        CTEST             3
     C     CTEST         IFGT      OTEST
     C                   GOTO      DSPL
     C                   END
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
     C                   MOVEL     *BLANKS       CMNAME
     C                   MOVEL     '* End of'    ENDFLD           16
     C                   MOVE      ' Data * '    ENDFLD
     C                   MOVEL     ENDFLD        CMNAME
     C                   Z-ADD     0             CMCOMP
     C                   Z-ADD     0             CMCUST
     C                   Z-ADD     0             CMPHON
     C                   WRITE     RECSFL
      *
     C     NXTFMT        TAG
     C                   Z-ADD     0             LINE#
     C                   Z-ADD     0             LINE
     C                   EXFMT     RECCTL
     C                   SETOFF                                       90
     C   KF              DO
     C                   MOVE      *BLANKS       CMNAME
     C                   MOVE      *BLANKS       CMBABB
     C                   Z-ADD     0             CMCOMP
     C                   Z-ADD     0             CMCUST
     C                   Z-ADD     0             CMPHON
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
