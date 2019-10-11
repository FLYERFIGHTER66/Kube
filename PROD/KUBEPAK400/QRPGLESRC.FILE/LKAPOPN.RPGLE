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
      *PROGRAM NAME-------- LKAPOPN
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *DESCRIPTION--------- OPEN PAYABLE LOOKUP
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFAPOPN    IF   E           K DISK
     FLKAPOPFM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
      *
     C     *ENTRY        PLIST
     C                   PARM                    APVEND            6 0
     C                   PARM                    VCO               2 0
     C                   PARM                    APVOUC            6 0
     C                   PARM                    APINV#           10
     C                   PARM                    APITYP            1
     C                   PARM                    APSEQ#            3 0
     C                   PARM                    APTDES           30
     C                   MOVE      APVEND        HLDLOK            6 0
     C                   MOVE      APVEND        VLOOK             6 0
     C                   Z-ADD     0             OLDSRC            6 0
      *
     C                   Z-ADD     0             LINE
     C                   Z-ADD     0             VLINE
     C     VLOOK         SETLL     FAPOPN
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   MOVE      VLOOK         OLDSRC
     C     NXTX          TAG
     C                   SETOFF                                       50
     C     VLOOK         READE     FAPOPN                                 50
     C   50              GOTO      DSPL
      *
     C     APSTAT        IFEQ      'D'
     C                   GOTO      NXTX
     C                   ENDIF
      *
     C     APCLCD        IFEQ      'Y'
     C     APCLCD        OREQ      'C'
     C                   GOTO      NXTX
     C                   ENDIF
      *
     C     APCOMP        IFNE      VCO
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
     C                   MOVE      *BLANKS       APITYP
     C                   MOVE      *BLANKS       APINV#
     C                   MOVEL     '*End Dat'    APINV#
     C                   MOVE      'a*'          APINV#
     C                   Z-ADD     *ZEROS        APCOMP
     C                   Z-ADD     *ZEROS        APVOUC
     C                   Z-ADD     *ZEROS        APIVDT
     C                   Z-ADD     *ZEROS        APDUDT
     C                   Z-ADD     *ZEROS        APDUE$
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
     C                   MOVE      *BLANKS       APITYP
     C                   MOVE      *BLANKS       APINV#
     C                   Z-ADD     *ZEROS        APCOMP
     C                   Z-ADD     *ZEROS        APVOUC
     C                   Z-ADD     *ZEROS        APIVDT
     C                   Z-ADD     *ZEROS        APDUDT
     C                   Z-ADD     *ZEROS        APDUE$
     C                   GOTO      END
     C                   ENDDO
      ** SEE IF ON A SUBFILE LINE
     C     LINE          IFGT      0
     C     LINE          ANDLE     LSTREC
     C     LINE          CHAIN     RECSFL                             90
     C   90              GOTO      NXTFMT
     C                   GOTO      END
     C                   END
     C     LINE#         IFEQ      0
     C                   GOTO      NXTFMT
     C                   END
     C     LINE#         IFGT      LSTREC
     C                   SETON                                        90
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
