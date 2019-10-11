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
      *PROGRAM NAME-------- LKZIP
      *SYSTEM-------------- LOOKUP
      *DESCRIPTION--------- LOOKUP CUSTOMER BY ZIP CODE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMCUSTZC  IF   E           K DISK
     F*FMCUST  IF  E           K        DISK
     F*           RMCUST                            KRENAMEMCUST
     FLKZIPFM   CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    CMZIP             9
     C                   PARM                    CMCUST            6 0
     C                   PARM                    CMNAME           30
     C                   MOVEL     CMZIP         HLDLOK            9
     C                   MOVEL     CMZIP         VLOOK             9
     C                   MOVE      *BLANKS       OLDSRC            9
      *
     C                   Z-ADD     0             LINE
     C                   Z-ADD     0             VLINE
     C     VLOOK         SETLL     FMCUSTZC
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C                   MOVE      VLOOK         OLDSRC
     C     NXTX          TAG
     C*                  SETOFF                                       50
     C                   SETOFF                                       5051
     C                   READ      FMCUSTZC                               50
     C   50              GOTO      DSPL
     C                   If        RECNO > 9990
     C                   GOTO      DSPL
     C                   EndIf
     C     CMSTAT        IFEQ      'D'
     C*                  GOTO      NXTX
     C     CMCTYP        OREQ      '30'
     C     CMCTYP        OREQ      '32'
     C                   Eval      *In51 = *On
     C                   ENDIF
     C                   MOVEL     CMNAME        NAME
     C                   MOVEL     CMADD2        ADDR
     C                   MOVEL     CMCITY        CITY
     C                   MOVEL     CMZIP         ZIP
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
     C                   MOVEL     *BLANKS       NAME
     C                   MOVEL     '* End of'    ENDFLD           16
     C                   MOVE      ' Data * '    ENDFLD
     C                   MOVEL     ENDFLD        NAME
     C                   Z-ADD     0             CMCOMP
     C                   Z-ADD     0             CMCUST
     C                   MOVEL     *BLANKS       ADDR
     C                   MOVEL     *BLANKS       CITY
     C                   MOVEL     *BLANKS       CMSTST
     C                   MOVEL     *BLANKS       ZIP
     C                   WRITE     RECSFL
      *
     C     NXTFMT        TAG
     C*???                 Z-ADD0         LINE#
     C                   Z-ADD     0             LINE
     C                   EXFMT     RECCTL
     C                   SETOFF                                       90
     C   KF              DO
     C                   MOVE      *BLANKS       NAME
     C                   Z-ADD     0             CMCOMP
     C                   Z-ADD     0             CMCUST
     C                   MOVEL     *BLANKS       ADDR
     C                   MOVEL     *BLANKS       CITY
     C                   MOVEL     *BLANKS       CMSTST
     C                   MOVEL     *BLANKS       ZIP
     C                   GOTO      END
     C                   ENDDO
      * SEE IF ON A SUBFILE LINE
     C     LINE          IFGT      0
     C     LINE          ANDLE     LSTREC
     C     LINE          CHAIN     RECSFL                             90
     C   90              GOTO      NXTFMT
     C*          CMCUST    CHAINFMCUST               90
     C*  90                GOTO NXTFMT
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
      *
      * GET THE SELECTED ITEM
      *
     C                   Z-ADD     LINE#         RECNO
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTFMT
     C     END           TAG
     C                   SETON                                        LR
      **
