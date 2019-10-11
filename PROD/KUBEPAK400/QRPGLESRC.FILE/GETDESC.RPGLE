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
      *PROGRAM NAME-------- GETDESC
      *SYSTEM-------------- DISTRIBUTION.
      *APPLICATION--------- GET DESCRIPTION FROM FMINVT IN SELECTED
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMINVT    IF   E           K DISK
     FFMPRCL    IF   E           K DISK
      *
     D DS              S             30    DIM(4)                               DESR IN
     D DO              S             30    DIM(4)                               DESR ORDERED
      *
     IRMINVT
     I              IMDES1                      DS(1)
     I              IMDES2                      DS(2)
     I              IMDES3                      DS(3)
     I              IMDES4                      DS(4)
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE              1
     C                   PARM                    DESC             60
      ** SET UP FOR CONCAT
     C                   MOVE      *BLANKS       DESC
     C                   MOVE      *BLANKS       DESC1            30
     C                   MOVE      *BLANKS       DESC2            30
     C                   MOVE      *BLANKS       DESC3            30
     C                   MOVE      *BLANKS       DESC4            30
      ** GET ITEM MASTER
     C     MINKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    IMWHSE
     C     MINKEY        CHAIN     FMINVT                             90
     C   90              GOTO      END
      ** GET PRODUCT CLASS RECORD
     C     IMPCL1        CHAIN     FMPRCL                             90
     C   90              GOTO      ENDP
      ** INVOICES
     C     TYPE          IFEQ      'I'
     C                   Z-ADD     PCPRI1        P1                1 0
     C                   Z-ADD     PCPRI2        P2                1 0
     C                   Z-ADD     PCPRI3        P3                1 0
     C                   Z-ADD     PCPRI4        P4                1 0
     C     PCPRI1        IFGT      0
     C                   MOVEL     DS(1)         DO(P1)
     C                   END
     C     PCPRI2        IFGT      0
     C                   MOVEL     DS(2)         DO(P2)
     C                   END
     C     PCPRI3        IFGT      0
     C                   MOVEL     DS(3)         DO(P3)
     C                   END
     C     PCPRI4        IFGT      0
     C                   MOVEL     DS(4)         DO(P4)
     C                   END
     C                   GOTO      ENDTYP
     C                   END
      ** PICK SLIPS
     C     TYPE          IFEQ      'P'
     C                   Z-ADD     PCPRP1        P1
     C                   Z-ADD     PCPRP2        P2
     C                   Z-ADD     PCPRP3        P3
     C                   Z-ADD     PCPRP4        P4
     C     PCPRP1        IFGT      0
     C                   MOVEL     DS(1)         DO(P1)
     C                   END
     C     PCPRP2        IFGT      0
     C                   MOVEL     DS(2)         DO(P2)
     C                   END
     C     PCPRP3        IFGT      0
     C                   MOVEL     DS(3)         DO(P3)
     C                   END
     C     PCPRP4        IFGT      0
     C                   MOVEL     DS(4)         DO(P4)
     C                   END
     C                   GOTO      ENDTYP
     C                   END
      ** REPORTS
     C     TYPE          IFEQ      'R'
     C                   Z-ADD     PCPRR1        P1
     C                   Z-ADD     PCPRR2        P2
     C                   Z-ADD     PCPRR3        P3
     C                   Z-ADD     PCPRR4        P4
     C     PCPRR1        IFGT      0
     C                   MOVEL     DS(1)         DO(P1)
     C                   END
     C     PCPRR2        IFGT      0
     C                   MOVEL     DS(2)         DO(P2)
     C                   END
     C     PCPRR3        IFGT      0
     C                   MOVEL     DS(3)         DO(P3)
     C                   END
     C     PCPRR4        IFGT      0
     C                   MOVEL     DS(4)         DO(P4)
     C                   END
     C                   GOTO      ENDTYP
     C                   END
     C     ENDTYP        TAG
      ** IF HERE AND NO DESC SELECTED FORCE DESC 1
     C*          DO,1      IFEQ *BLANKS
     C*          DO,2      ANDEQ*BLANKS
     C*          DO,3      ANDEQ*BLANKS
     C*          DO,4      ANDEQ*BLANKS
     C*                    MOVELDS,1      DESC
     C*                    GOTO END
     C*                    END
      ** NOW GET DESCRIPTION TOGETHER
     C     DO(1)         CAT       DO(2):1       DESA             60
     C     DO(3)         CAT       DO(4):1       DESB             60
     C     DESA          CAT       DESB:1        DESC
     C     ENDP          TAG
     C     DESC          IFLE      *BLANKS
     C     DS(1)         CAT       DS(2):1       DESA
     C     DS(3)         CAT       DS(4):1       DESB
     C     DESA          CAT       DESB:1        DESC
     C                   END
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
