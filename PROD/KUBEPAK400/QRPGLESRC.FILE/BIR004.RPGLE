      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.   ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *       EFD ENTERPRISES INC.  215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR004
      *SYSTEM-------------- MASTER FILES
      *DESCRIPTION--------- ENTER/UPDATE STATE CODES
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 6/28/00 EFD01 RUN CLRIT
      *
      *
     FBIR004FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMSTAT    UF A E           K DISK
     FFSYSCTL   IF   E             DISK
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
     D  LLIST                  1      1
     D  LCANCL               133    133
      *
     C                   READ      FSYSCTL                                90
     C     ZZTYPE        IFEQ      'G'
     C                   SETON                                        01
     C                   ELSE
     C                   SETON                                        02
     C                   ENDIF
      *
     C     RSTRT         TAG
     C                   UNLOCK    FMSTAT
     C                   SETOFF                                       101620
     C                   SETOFF                                       212298
     C     NXTA          TAG
EFD01C                   EXSR      CLRIT
     C                   WRITE     SCRNA
     C                   SETOFF                                       101620
     C                   SETOFF                                       212298
     C                   READ      SCRNA                                  90
      *
     C   KM              MOVEL     'X'           LLIST
     C   KM
     COR KC
     COR KG              GOTO      END
      *
     C                   MOVEL     STCODE        VCODE             2
     C                   MOVEL     STCODE        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   CALL      'LKSTAT'
     C                   PARM                    STCODE
     C                   PARM                    STNAME           30
     C                   MOVEL     *BLANKS       VCODE
     C                   MOVEL     STCODE        VCODE
     C                   MOVEL     VCODE         STCODE
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        10
     C                   GOTO      NXTA
     C     VACTOK        TAG
      *
      * VALIDATE STATE CODE
      *
     C     STCODE        CHAIN     FMSTAT                             96
      *
     C  N96VACT          IFEQ      'A'
     C                   SETON                                        2021
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C   96VACT          IFNE      'A'
     C                   SETON                                        2022
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        16
     C                   ENDIF
      *
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       1098
     C                   READ      SCRNB                                  90
      *
     C   KM              MOVEL     'X'           LLIST
     C   KM
     COR KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRT
      *
      * DESCRIPTION REQUIRED
      *
     C     STNAME        IFEQ      *BLANKS
     C                   SETON                                        10
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     STNAME        IFNE      ODESC
     C                   ADD       1             CNT
     C                   MOVEL     STNAME        ODESC            30
     C                   ENDIF
      *
     C     STPHYT        IFNE      OPHYT
     C                   ADD       1             CNT
     C                   MOVEL     STPHYT        OPHYT             1
     C                   ENDIF
      *
     C  N16CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     VACT          IFNE      'D'
     C                   GOTO      NODEL
     C                   ENDIF
      *
     C   KX              GOTO      NODEL
     C                   GOTO      NXTA
      *
     C     NODEL         TAG
     C     VACT          IFEQ      'A'
     C                   WRITE     RMSTAT
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RMSTAT
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RMSTAT
     C                   ENDIF
     C                   EXSR      CLRIT
     C                   GOTO      NXTA
      *
     C     END           TAG
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C   KC
     COR KM
     COR KG              SETON                                        LR
      *
      **********
      * CLRIT  *
      **********
     C     CLRIT         BEGSR
     C                   Z-ADD     0             CNT               2 0
     C                   MOVE      *BLANKS       VACT
     C                   MOVE      *BLANKS       STCODE
     C                   MOVE      *BLANKS       STNAME
     C                   MOVE      *BLANKS       STPHYT
     C                   ENDSR
      *
