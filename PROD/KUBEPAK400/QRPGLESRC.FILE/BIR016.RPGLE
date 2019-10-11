      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
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
      *PROGRAM NAME-------- BIR016
      *APPLICATION--------- MASTER FILES
      *DESCRIPTION--------- MAINTAIN RECORDS IN ROUTE FILE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMROUT    UF A E           K DISK
     FBIR016FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
      *
     D MSG             S              9    DIM(4) CTDATA PERRCD(1)
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
      * PROGRAM MAINLINE
      *
     C     RSTRTA        TAG
     C                   EXSR      CLRIT
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101620
     C                   SETOFF                                       2122
     C                   READ      SCRNA                                  90
      *
     C   KM              MOVEL     'X'           LLIST
     C   KC
     COR KM
     COR KG              GOTO      END
      *
      * LOOKUP ROUTE
      *
     C     1             SUBST     VCODE:1       VTST              1
     C     VTST          IFEQ      '?'
     C     VTST          OREQ      '/'
     C                   MOVEL     VCODE         RTCODE            2
     C                   CALL      'LKRTE'
     C                   PARM                    RTCODE
     C                   PARM                    RTDESC           30
     C                   MOVEL     *BLANKS       VCODE
     C                   MOVEL     RTCODE        VCODE
     C                   SETON                                        99
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * TEST ACTION CODE
      *
     C     VACT          IFEQ      'A'
     C     VACT          OREQ      'C'
     C     VACT          OREQ      'D'
     C                   GOTO      VACTOK
     C                   ENDIF
     C                   SETON                                        10
     C                   GOTO      RSTRTA
     C     VACTOK        TAG
      *
      * TEST ROUTE
      *
     C     VCODE         IFEQ      *BLANKS
     C                   SETON                                        2021
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VCODE         CHAIN     FMROUT                             90        90 NO REC
      *
     C  N90VACT          IFEQ      'A'
     C                   SETON                                        2022
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C   90VACT          IFNE      'A'
     C                   SETON                                        2021
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACT          IFEQ      'D'
     C                   SETON                                        16
     C                   ENDIF
      *
     C     ENDA          TAG
      *
      * LOAD MODE FOR OUTPUT
      *
     C     VACT          IFEQ      'A'
     C                   MOVEL     MSG(1)        VMODE
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   MOVEL     MSG(2)        VMODE
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   MOVEL     MSG(3)        VMODE
     C                   ENDIF
      *
     C     RSTRTB        TAG
     C                   WRITE     SCRNB
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       102098
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLRIT
     C   KF              GOTO      RSTRTA
      *
     C     VACT          IFNE      'D'
     C                   GOTO      NODEL
     C                   ENDIF
      *
     C   KX              GOTO      NODEL
     C                   GOTO      RSTRTA
      *
     C     NODEL         TAG
      *
      * TEST DESCRIPTION
      *
     C     RTDESC        IFEQ      *BLANKS
     C                   SETON                                        10
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     RTDESC        IFNE      ODESC
     C                   ADD       1             CNT
     C                   ENDIF
     C                   MOVEL     RTDESC        ODESC            30
      *
     C     CNT           IFGT      0
     C                   SETON                                        98
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
      * UPDATE UNIT OF MEASURE FILE
      *
     C                   MOVEL     VCODE         RTCODE
     C     VACT          IFEQ      'A'
     C                   WRITE     RMROUT
     C                   GOTO      ENDB
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RMROUT
     C                   GOTO      ENDB
     C                   ENDIF
     C                   UPDATE    RMROUT
     C     ENDB          TAG
     C                   EXSR      CLRIT
     C                   GOTO      RSTRTA
      *
     C     END           TAG
     C   KC
     COR KG              MOVEL     'X'           LCANCL
     C                   SETON                                        LR
      *
      * CLRIT - THIS SUBROUTINE PROCESSES RESTART AND UPDATE OPTIONS
      *
     C     CLRIT         BEGSR
     C                   MOVE      *BLANKS       VCODE
     C                   MOVE      *BLANKS       RTDESC
     C     ECLR          ENDSR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
      *
**
  Add
 Change
 Delete
 Inquire
