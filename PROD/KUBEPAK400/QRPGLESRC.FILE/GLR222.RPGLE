      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- GLR222
      *SYSTEM-------------- GENERAL LEDGER
      *DESCRIPTION--------- CONSOLIDATION INQUIRY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FGLR222FM  CF   E             WORKSTN
     F                                     SFILE(DSPSFL:RECNO)
     FFGLDCOAC  IF   E           K DISK
     FFGLCTL    IF   E           K DISK
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10
      * RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    263
      * SOURCE LIBRARY
     D  SLIBR                314    323
      *
     D                UDS
     D  LCO                    1      2  0
     D  LCANCL               133    133
      *
     C     RSTRTA        TAG
     C                   Z-ADD     0             TOTBAL           11 2
     C                   Z-ADD     0             GTCON#
     C                   SETOFF                                       555677
     C                   SETOFF                                       4243
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       10
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
      *
     C     GTCON#        IFEQ      0
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * SET FGLDCOA BACK TO BEGINING OF CONSOLIDATION NUMBER
      *
     C     GTKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GTCON#
     C     GTKEY         SETLL     FGLDCOAC
     C                   MOVE      '1'           *IN80
     C                   WRITE     DSPCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     NXTB          TAG
     C                   SETOFF                                       90
     C     GTKEY         READE     FGLDCOAC                               90
     C   90              GOTO      DSPL
      *
     C     GTCOMP        IFNE      LCO
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C                   ADD       GTDOL$        TOTBAL
      *
     C                   ADD       1             RECNO
     C     RECNO         IFGT      1
     C                   SETON                                        55
     C                   ENDIF
     C                   WRITE     DSPSFL
     C                   GOTO      NXTB
      *
     C     DSPL          TAG
     C                   SETON                                        56
     C                   ADD       2             RECNO
     C                   Z-ADD     0             GTACCT
     C                   Z-ADD     0             GTTDAT
     C                   Z-ADD     0             GTAPER
     C                   MOVEL     *BLANKS       GTSRCE
     C                   MOVEL     *BLANKS       GTJEDS
     C                   Z-ADD     TOTBAL        GTDOL$
     C                   MOVEL     '* Detail'    DESC1            16
     C                   MOVE      ' Total  '    DESC1
     C                   MOVEL     DESC1         GTJEDS
     C                   WRITE     DSPSFL
     C                   EXFMT     DSPCTL
     C   KC
     COR KG              GOTO      END
     C                   GOTO      RSTRTA
      *
     C     END           TAG
     C                   SETON                                        LR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     0             COMP              2 0
     C     COMP          CHAIN     FGLCTL                             90
     C                   Z-ADD     GZPRCO        VCO
      *
     C                   ENDSR
      *
