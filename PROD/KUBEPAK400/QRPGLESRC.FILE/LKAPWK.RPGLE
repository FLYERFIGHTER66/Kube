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
      *PROGRAM NAME-------- LKAPWK
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *DESCRIPTION--------- WORK FILE OPEN PAYABLES LOOKUP
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFAPWKINV  IF   E           K DISK
     FLKAPWKFM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    AWVEND
     C                   PARM                    COMP              2 0
     C                   PARM                    AWVOUC
     C                   PARM                    AWINV#           10
     C                   PARM                    AWITYP            1
     C*                    PARM           AWTDES 30
     C*                    PARM           AWIVDT  60
     C*                    PARM           AWDUDT  60
     C*                    PARM           AWDCDT  60
     C*                    PARM           AWDAVL  72
     C*                    PARM           AW$AMT 112
      *
     C     APWKEY        KLIST
     C                   KFLD                    COMP
     C                   KFLD                    AWVEND
     C                   KFLD                    AWINV#
     C                   KFLD                    AWITYP
     C     APWCMP        KLIST
     C                   KFLD                    COMP
     C                   KFLD                    AWVEND
     C                   Z-ADD     0             LINE
     C                   Z-ADD     0             VLINE
     C     APWKEY        SETLL     FAPWKINV
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     NXTX          TAG
     C                   SETOFF                                       50
     C     APWCMP        READE     FAPWKINV                               50
     C   50              GOTO      DSPL
     C     AWSTAT        IFEQ      'P'
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
     C                   MOVE      *BLANKS       AWITYP
     C                   MOVE      *BLANKS       AWINV#
     C                   MOVEL     '*End Dat'    AWINV#
     C                   MOVE      'a*'          AWINV#
     C                   Z-ADD     *ZEROS        AWCOMP
     C                   Z-ADD     *ZEROS        AWVOUC
     C                   Z-ADD     *ZEROS        AWIVDT
     C                   Z-ADD     *ZEROS        AWDUDT
     C                   Z-ADD     *ZEROS        AWDUE$
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
     C                   MOVE      *BLANKS       AWITYP
     C                   MOVE      *BLANKS       AWINV#
     C                   Z-ADD     *ZEROS        AWCOMP
     C                   Z-ADD     *ZEROS        AWVOUC
     C                   Z-ADD     *ZEROS        AWIVDT
     C                   Z-ADD     *ZEROS        AWDUDT
     C                   Z-ADD     *ZEROS        AWDUE$
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
