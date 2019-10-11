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
      *PROGRAM NAME-------- LKSIZE
      *SYSTEM-------------- LOOKUP
      *DESCRIPTION--------- SIZE CODE LOOKUP
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMSIZE    IF   E           K DISK
     FFMSIZD    IF   E           K DISK
     FLKSIZEFM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)

      ****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    SZCODE            3
     C                   PARM                    SZDESC           10
     C                   MOVE      SZCODE        HLDLOK            3
     C                   MOVE      SZCODE        VLOOK             3
     C                   MOVE      *BLANKS       OLDSRC            3
      *
     C                   Z-ADD     0             LINE
     C                   Z-ADD     0             VLINE
     C     VLOOK         SETLL     FMSIZE
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   MOVE      VLOOK         OLDSRC
     C     NXTX          TAG
     C                   SETOFF                                       50
     C                   READ      FMSIZE                                 50
     C     SZCODE        CHAIN     FMSIZD
     C                   If        %Found(FMSIZD)
     C                   Eval      SZLONG50 = SZLONG
     C                   Eval      SZCTRDPT1= %subst(SZCTRD:01:15)
     C                   Eval      SZCTRDPT2= %subst(SZCTRD:16:15)
     C                   EndIf
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
     C                   MOVE      *BLANKS       SZCODE
     C                   MOVE      *BLANKS       SZDESC
     C                   WRITE     RECSFL
     C                   ADD       1             RECNO
     C                   MOVEL     '*End Dat'    ENDD             10
     C                   MOVE      'a*'          ENDD
     C                   MOVEL     ENDD          SZDESC
     C                   WRITE     RECSFL
      *
     C     NXTFMT        TAG
     C                   Z-ADD     0             LINE
     C                   EXFMT     RECCTL
     C   KF              DO
     C                   MOVEL     *BLANKS       SZCODE
     C                   MOVEL     *BLANKS       SZDESC
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
