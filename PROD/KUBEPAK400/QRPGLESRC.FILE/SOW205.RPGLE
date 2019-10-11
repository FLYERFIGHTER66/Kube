      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2001
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
      **PROGRAM NAME-------- SOW205
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- JOB # INQUIRY
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FSOW205FM  CF   E             WORKSTN
     FFTRAYJ    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFCALEN    IF   E           K DISK
     FFCALEX    IF   E           K DISK
     F                                     RENAME(RCALEN:CALEX)
     FFCALENCY  IF   E           K DISK
     F                                     RENAME(RCALEN:CALEN)
     FFSOWSCHJ  IF   E           K DISK
      *
      * MESSAGE
     D MSG             S             30    DIM(10) CTDATA PERRCD(1)             MESSAGES
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LFILE                 11     20
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
      ***********************
      ** START HERE        **
      ***********************
     C     RSTART        TAG
     C                   Z-ADD     0             JOB#
     C                   MOVE      *BLANKS       LCANCL
     C                   SETOFF                                       1020
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C                   SETOFF                                       102030
     C                   SETOFF                                       215051
     C                   SETOFF                                       404145
     C                   SETOFF                                       48  99
     C                   SETOFF                                       525354
      *
      * CHECK FOR SOW DATE
     C     SOWDAT        IFGT      0
     C     SOWDAT        CHAIN     FCALEN                             40
     C   40              DO
     C                   SETON                                        99
     C                   Z-ADD     0             SOWCYM
     C                   Z-ADD     0             YEAR
     C                   Z-ADD     0             WEEK
     C                   GOTO      NXTA
     C                   ENDDO                                                  40 DO
     C     CL#Y          IFNE      1
     C                   SETON                                        404199
     C                   GOTO      NXTA
     C                   END                                                    CL#Y><1
     C                   MOVEL     CLCENT        YEAR
     C                   MOVE      CLYEAR        YEAR
     C                   Z-ADD     CLWEEK        WEEK
     C                   Z-ADD     CLCYMD        SOWCYM
     C                   END                                                    SOWDAT>0
      * SEE IF WEEK NUMBER ENTERED
     C     SOWDAT        IFLE      0
     C     YEAR          ANDGT     0
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    CLWEEK
     C                   KFLD                    CL#Y
     C                   MOVEL     YEAR          CLCENT
     C                   MOVE      YEAR          CLYEAR
     C                   Z-ADD     WEEK          CLWEEK
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             45
     C   45              DO
     C                   SETON                                        99
     C                   Z-ADD     0             SOWCYM
     C                   GOTO      NXTA
     C                   ENDDO
     C                   Z-ADD     CLDATE        SOWDAT
     C                   Z-ADD     CLCYMD        SOWCYM            7 0
     C                   END                                                    SOWDAT=0
     C                   MOVEL     CLCENT        YEAR
     C                   MOVE      CLYEAR        YEAR
     C                   MOVEL     CLCENT        SYEAR
     C                   MOVE      CLYEAR        SYEAR
     C                   Z-ADD     CLWEEK        SWEEK
      ** CHECK JOB#
     C     JOBKEY        KLIST
     C                   KFLD                    SOWCYM
     C                   KFLD                    JOB#
     C     JOBKEY        CHAIN     FSOWSCHJ                           10
     C   10              GOTO      NXTA
      ** IF HERE INPUT OK SHOW TAG INFO
     C     MINKEY        KLIST
     C                   KFLD                    SOITEM
     C                   KFLD                    SOSIZE
     C     MINKEY        CHAIN     FMINVT                             90
     C                   MOVEL     IMITEM        ITEM
     C     SORDYD        CHAIN     FCALENCY                           90
     C                   Z-ADD     CLDATE        RDYDAT
     C                   MOVEL     CLCENT        RYEAR
     C                   MOVE      CLYEAR        RYEAR
     C                   Z-ADD     CLWEEK        RWEEK
     C     SOASOW        CHAIN     FCALENCY                           90
     C                   Z-ADD     CLDATE        ASOWD
      ** GET BEG AND END TAG NUMBER.
     C     TRYKEY        KLIST
     C                   KFLD                    TRSCYW
     C                   KFLD                    JOB#
     C                   MOVEL     SYEAR         TRSCYW
     C                   MOVE      SWEEK         TRSCYW
     C     TRYKEY        SETLL     FTRAYJ
     C                   Z-ADD     0             BEGTAG
     C     NXTTRY        TAG
     C     TRYKEY        READE     FTRAYJ                                 91
     C   91              GOTO      ENDTRY
     C     BEGTAG        IFLE      0
     C                   Z-ADD     TRTAG#        BEGTAG
     C                   END
     C                   Z-ADD     TRTAG#        ENDTAG
     C                   GOTO      NXTTRY
     C     ENDTRY        TAG
      ** GET STATUS
     C                   MOVE      *BLANKS       STDESC
     C     SOSTAT        IFEQ      'A'
     C                   MOVEL     MSG(1)        STDESC
     C                   END
     C     SOSTAT        IFEQ      'C'
     C                   MOVEL     MSG(2)        STDESC
     C                   END
     C     SOSTAT        IFEQ      'D'
     C                   MOVEL     MSG(3)        STDESC
     C                   END
     C     SOSTAT        IFEQ      'S'
     C                   MOVEL     MSG(4)        STDESC
     C                   END
     C                   Z-ADD     0             LEFT
     C     SOSTAT        IFNE      'D'
     C     SOSOWT        SUB       SOSOWQ        LEFT
     C                   END
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C                   GOTO      RSTART
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
**   Message
Open                                    1
Complete                                2
Deleted                                 3
Scheduled                               4
