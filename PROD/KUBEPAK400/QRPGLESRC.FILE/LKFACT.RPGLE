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
      *PROGRAM NAME-------- LKFACT
      *SYSTEM-------------- LOOK UP
      *DESCRIPTION--------- FACTOR TABLE LOOKUP
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFPTABLE   IF   E           K DISK
     FLKFACTFM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    PTABID            2
     C                   PARM                    PTDESC           30
     C                   MOVE      PTABID        HLDLOK            2
     C                   MOVE      PTABID        VLOOK             2
     C                   MOVE      *BLANKS       OLDSRC            2
      *
     C     Restart       Tag
     C                   Z-ADD     0             LINE
     C                   Z-ADD     0             VLINE
     C     VLOOK         SETLL     FPTABLE
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   MOVE      VLOOK         OLDSRC
     C     NXTX          TAG
     C                   SETOFF                                       50
     C                   READ      FPTABLE                                50
     C   50              GOTO      DSPL

      *  Skip Deleted records unless requested
     C                   If        PTSTAT = 'D' and not *In30
     C                   GOTO      NXTX
     C                   EndIf

     C                   If        PTSTAT = 'D'
     C                   Eval      *In31 = *On
     C                   Eval      Deleted = '- Deleted'
     C                   Else
     C                   Eval      *In31 = *Off
     C                   Eval      Deleted = *Blanks
     C                   EndIf

     C                   ADD       1             RECNO
     C                   ADD       1             VLINE
     C                   WRITE     RECSFL
     C                   GOTO      NXTX
      *
     C     DSPL          TAG
     C                   Eval      *In31 = *Off
     C                   Eval      Deleted = *Blanks
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ADD       1             RECNO
     C                   Z-ADD     0             VLINE
     C                   MOVE      *BLANKS       PTABID
     C                   MOVE      *BLANKS       PTDESC
     C                   WRITE     RECSFL
     C                   ADD       1             RECNO
     C                   MOVEL     '* End of'    ENDD             16
     C                   MOVE      ' Data * '    ENDD
     C                   MOVEL     ENDD          PTDESC
     C                   WRITE     RECSFL
      *
     C     NXTFMT        TAG
     C                   Z-ADD     0             LINE
     C                   Z-ADD     0             LINE#
     C                   EXFMT     RECCTL
     C                   SETOFF                                       90
     C   11              DO
     C                   If        *In30 = *On
     C                   Eval      *In30 = *Off
     C                   Else
     C                   Eval      *In30 = *On
     C                   EndIf
     C                   Goto      Restart
     C                   EndDo
     C   KF              DO
     C                   MOVEL     *BLANKS       PTABID
     C                   MOVEL     *BLANKS       PTDESC
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
