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
      *PROGRAM NAME-------- ORLSLOOK
      *SYSTEM-------------- LOOKUP
      *DESCRIPTION--------- ORDER LIST LOOKUP
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMORLH    IF   E           K DISK
     FORLSSRFM  CF   E             WORKSTN
      *
     D LN              S              2  0 DIM(17)
     D CD              S              6    DIM(17)
     D NM              S             30    DIM(17)
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    HLLIST            6
     C                   PARM                    HLDESC           30
     C                   MOVEL     *BLANKS       HLDLOK            6
     C                   MOVEL     *BLANKS       VLOOK             6
     C                   MOVEL     *BLANKS       OLDSRC            6
      *
     C     RSTRT         TAG
     C                   MOVEA     *ZEROS        LN
     C                   MOVEA     *BLANKS       CD
     C                   MOVEA     *BLANKS       NM
     C                   Z-ADD     1             X                 2 0
     C                   Z-ADD     0             LINE#
     C     OLDSRC        IFNE      VLOOK
     C     VLOOK         SETLL     FMORLH
     C                   MOVE      VLOOK         OLDSRC
     C                   ENDIF
     C     NXTX          TAG
     C                   SETOFF                                       50
     C                   READ      FMORLH                                 50
     C   50              GOTO      ENDX
     C     HLSTAT        IFEQ      'D'
     C                   GOTO      NXTX
     C                   ENDIF
     C                   Z-ADD     X             LN(X)
     C                   MOVEL     HLDESC        NM(X)
     C                   MOVEL     HLLIST        CD(X)
     C                   ADD       1             X
     C     X             IFLE      17
     C                   GOTO      NXTX
     C                   ENDIF
     C     ENDX          TAG
     C     X             IFLE      17
     C     X             ANDGT     0
     C                   MOVE      *BLANKS       CD(X)
     C                   MOVE      *BLANKS       NM(X)
     C                   MOVE      *BLANKS       OLDSRC
     C                   MOVEL     '* End of'    ENDD             16
     C                   MOVE      ' Data * '    ENDD
     C                   MOVEL     ENDD          NM(X)
     C                   ENDIF
     C                   SUB       1             X
      *
     C                   EXSR      LOADC
     C     OUTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       1050
     C                   READ      SCRNA                                  90
     C   KF              SETON                                        LR
     C   KF              GOTO      END
     C   50LINE#         IFEQ      0
     C*          VLOOK     ANDEQOLDSRC
     C                   MOVEL     HLDLOK        VLOOK
     C                   GOTO      RSTRT
     C                   ENDIF
     C     LINE#         IFGT      0
     C     LINE#         ANDLE     17
     C                   MOVEL     CD(LINE#)     HLLIST
     C                   MOVEL     NM(LINE#)     HLDESC
     C                   SETON                                        LR
     C                   GOTO      END
     C                   ENDIF
     C     LINE#         IFGT      X
     C                   SETON                                        10
     C                   GOTO      OUTA
     C                   ELSE
     C                   Z-ADD     0             LINE#
     C                   ENDIF
     C                   GOTO      RSTRT
     C     END           TAG
     C                   SETON                                        LR
      *
     C     LOADC         BEGSR
      **
     C                   Z-ADD     LN(1)         LN1
     C                   Z-ADD     LN(2)         LN2
     C                   Z-ADD     LN(3)         LN3
     C                   Z-ADD     LN(4)         LN4
     C                   Z-ADD     LN(5)         LN5
     C                   Z-ADD     LN(6)         LN6
     C                   Z-ADD     LN(7)         LN7
     C                   Z-ADD     LN(8)         LN8
     C                   Z-ADD     LN(9)         LN9
     C                   Z-ADD     LN(10)        LN10
     C                   Z-ADD     LN(11)        LN11
     C                   Z-ADD     LN(12)        LN12
     C                   Z-ADD     LN(13)        LN13
     C                   Z-ADD     LN(14)        LN14
     C                   Z-ADD     LN(15)        LN15
     C                   Z-ADD     LN(16)        LN16
     C                   Z-ADD     LN(17)        LN17
      **
     C                   MOVEL     CD(1)         CD1
     C                   MOVEL     CD(2)         CD2
     C                   MOVEL     CD(3)         CD3
     C                   MOVEL     CD(4)         CD4
     C                   MOVEL     CD(5)         CD5
     C                   MOVEL     CD(6)         CD6
     C                   MOVEL     CD(7)         CD7
     C                   MOVEL     CD(8)         CD8
     C                   MOVEL     CD(9)         CD9
     C                   MOVEL     CD(10)        CD10
     C                   MOVEL     CD(11)        CD11
     C                   MOVEL     CD(12)        CD12
     C                   MOVEL     CD(13)        CD13
     C                   MOVEL     CD(14)        CD14
     C                   MOVEL     CD(15)        CD15
     C                   MOVEL     CD(16)        CD16
     C                   MOVEL     CD(17)        CD17
      **
     C                   MOVEL     NM(1)         NM1
     C                   MOVEL     NM(2)         NM2
     C                   MOVEL     NM(3)         NM3
     C                   MOVEL     NM(4)         NM4
     C                   MOVEL     NM(5)         NM5
     C                   MOVEL     NM(6)         NM6
     C                   MOVEL     NM(7)         NM7
     C                   MOVEL     NM(8)         NM8
     C                   MOVEL     NM(9)         NM9
     C                   MOVEL     NM(10)        NM10
     C                   MOVEL     NM(11)        NM11
     C                   MOVEL     NM(12)        NM12
     C                   MOVEL     NM(13)        NM13
     C                   MOVEL     NM(14)        NM14
     C                   MOVEL     NM(15)        NM15
     C                   MOVEL     NM(16)        NM16
     C                   MOVEL     NM(17)        NM17
      **
     C                   ENDSR
