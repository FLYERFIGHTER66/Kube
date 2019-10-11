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
      *PROGRAM NAME-------- LKAPENT
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *DESCRIPTION--------- START UP OPEN PAYABLES LOOKUP
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFAPENT    IF   E           K DISK
     FLKAPENFM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    ANVEND            6 0
     C                   PARM                    ANCOMP            2 0
     C                   PARM                    ANVOUC            6 0
     C                   PARM                    ANINV#           10
     C                   PARM                    ANITYP            1
     C                   PARM                    ANTDES           30
     C                   PARM                    ANIVDT            6 0
     C                   PARM                    ANDUDT            6 0
     C                   PARM                    ANDCDT            6 0
     C                   PARM                    ANDAVL            7 2
     C                   PARM                    AN$AMT           11 2
     C                   MOVE      ANVEND        HLDLOK            6 0
     C                   MOVE      ANVEND        VLOOK             6 0
     C                   Z-ADD     0             OLDSRC            6 0
      *
     C                   Z-ADD     0             LINE
     C                   Z-ADD     0             VLINE
     C     VLOOK         SETLL     FAPENT
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   MOVE      VLOOK         OLDSRC
     C     NXTX          TAG
     C                   SETOFF                                       50
     C     VLOOK         READE     FAPENT                                 50
     C   50              GOTO      DSPL
     C     ANSTAT        IFEQ      'D'
     C                   GOTO      NXTX
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
     C                   MOVE      *BLANKS       ANITYP
     C                   MOVE      *BLANKS       ANINV#
     C                   MOVEL     '*End Dat'    ANINV#
     C                   MOVE      'a*'          ANINV#
     C                   Z-ADD     *ZEROS        ANCOMP
     C                   Z-ADD     *ZEROS        ANVOUC
     C                   Z-ADD     *ZEROS        ANIVDT
     C                   Z-ADD     *ZEROS        ANDUDT
     C                   Z-ADD     *ZEROS        ANDUE$
     C                   WRITE     RECSFL
     C*                    ADD  1         RECNO
     C*                    WRITERECSFL
      *
     C     NXTFMT        TAG
     C                   Z-ADD     0             LINE#
     C                   Z-ADD     0             LINE
     C                   EXFMT     RECCTL
     C                   SETOFF                                       90
     C   KF              DO
     C                   MOVE      *BLANKS       ANITYP
     C                   MOVE      *BLANKS       ANINV#
     C                   Z-ADD     *ZEROS        ANCOMP
     C                   Z-ADD     *ZEROS        ANVOUC
     C                   Z-ADD     *ZEROS        ANIVDT
     C                   Z-ADD     *ZEROS        ANDUDT
     C                   Z-ADD     *ZEROS        ANDUE$
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
