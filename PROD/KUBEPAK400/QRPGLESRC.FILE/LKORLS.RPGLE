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
      *PROGRAM NAME-------- LKORLS
      *SYSTEM-------------- LOOK UP
      *DESCRIPTION--------- ORDER LIST LOOKUP
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMORLHSE  IF   E           K DISK
     FLKORLSFM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
      *
      *? Data Areas
     D WEB020CL        DS                  DTAARA(WEB020CL)
     D  Season1                       2S 0                                      ?Season Number 1
     D  Season2                       2S 0                                      ?Season Number 2
     D  Season3                       2S 0                                      ?Season Number 3
     D* Season4                       2S 0                                      ?Season Number 4

     D SaveHSSNCD      S                   Like(HSSNCD)                         ?Save HSSNCD
     D SaveHLLIST      S                   Like(HLLIST)                         ?Save HLLIST
     D SaveHLDESC      S                   Like(HLDESC)                         ?Save HLDESC
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    HLLIST            6
     C                   PARM                    HLDESC           30
     C*                  PARM                    SELECT            1            1=Current 0=All
     C                   MOVE      *BLANKS       HLDLOK            6
     C                   MOVE      *BLANKS       VLOOK             6
     C                   MOVE      *BLANKS       OLDSRC            6
      *
     C                   In        WEB020CL
      *
     C                   Z-ADD     0             LINE
     C                   Z-ADD     0             VLINE
     C*    VLOOK         SETLL     FMORLHSE
     C     *Loval        SETLL     FMORLHSE
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   MOVE      VLOOK         OLDSRC
     C     NXTX          TAG
     C                   SETOFF                                       50
     C                   READ      FMORLHSE                               50
     C   50              GOTO      DSPL
      *
     C                   If        HSSNCD <> SaveHSSNCD
     C                   Eval      SaveHSSNCD = HSSNCD
     C                   Eval      SaveHLLIST = HLLIST
     C                   Eval      SaveHLDESC = HLDESC
     C                   Eval      HLLIST = '--' + %Char(HSSNCD) + '--'
     C                   Eval      HLDESC = HSSEAS
     C                   Eval      *In05 = *On
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   Eval      *In05 = *Off
     C                   Eval      HLLIST = SaveHLLIST
     C                   Eval      HLDESC = SaveHLDESC
     C                   EndIf
      *
     C                   ADD       1             RECNO
     C                   ADD       1             VLINE
     C                   WRITE     RECSFL
     C                   GOTO      NXTX
      *
     C     DSPL          TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   Z-ADD     VLINE         LSTLINE           5 0
     C                   ADD       1             RECNO
     C                   Z-ADD     0             VLINE
     C                   MOVE      *BLANKS       HLLIST
     C                   MOVE      *BLANKS       HLDESC
     C                   WRITE     RECSFL
     C                   ADD       1             RECNO
     C                   MOVEL     '* End of'    ENDD             16
     C                   MOVE      ' Data * '    ENDD
     C                   MOVEL     ENDD          HLDESC
     C                   WRITE     RECSFL
      *
     C     NXTFMT        TAG
     C                   Z-ADD     0             LINE#
     C                   Z-ADD     0             LINE
     C                   EXFMT     RECCTL
     C                   SETOFF                                       90
     C   KF              DO
     C                   MOVEL     *BLANKS       HLLIST
     C                   MOVEL     *BLANKS       HLDESC
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
     C     LINE#         IFGT      LSTLINE
     C                   SETON                                        90
     C                   GOTO      NXTFMT
     C                   END
      ** GET THE SELECTED ITEM
     C                   Z-ADD     LINE#         RECNO
     C     RECNO         CHAIN     RECSFL                             90
     C                   DOW       LINE# <> VLINE
     C                   ADD       1             RECNO
     C     RECNO         CHAIN     RECSFL                             90
     C                   ENDDO
     C   90              GOTO      NXTFMT
     C     END           TAG
     C                   MOVEA     '0'           *IN
     C                   SETON                                        LR
      **
