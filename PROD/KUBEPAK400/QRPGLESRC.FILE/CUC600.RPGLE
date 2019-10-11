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
      *PROGRAM NAME--------- CUC600
      *APPLICATION---------- CUTTING REQUIREMENTS
      *DESCRIPTION---------- CUT TRAY UNAVAILABLE REPORT
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FCUC600FM  CF   E             WORKSTN
     FFCALEN    IF   E           K DISK
     F                                     RENAME(RCALEN:CALENI)
     FFCALEX    IF   E           K DISK
WJB  FFMVEND    IF   E           K DISK
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
     D                UDS
      ** SEQUENCE  A=ALPHA  N=NUMERIC
     D  RPTSEQ                 1      1
      ** BEGIN READY DATE
     D  BEGDAT                 2      7  0
      ** END READY DATE
     D  ENDDAT                 8     13  0
      ** BEGIN READY DATE CYMD
     D  BEGCYM                14     20  0
      ** ENDING READY DATE CYMD
     D  ENDCYM                21     27  0
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      *
WJB  D  Vendor         S                   Like(VMVEND)
      *
WJB  C     *Entry        PList
WJB  C                   Parm                    Vendor
WJB  C     Vendor        Chain     FMVEND
     C     RSTART        TAG
     C                   Z-ADD     0             BEGDAT
     C                   Z-ADD     0             BEGCYM
     C                   Z-ADD     0             ENDDAT
     C                   Z-ADD     0             ENDCYM
     C                   Z-ADD     0             BEGYR
     C                   Z-ADD     0             BEGWK
     C                   Z-ADD     0             OBEG              6 0
     C                   Z-ADD     0             OBYR              4 0
     C                   Z-ADD     0             OBWK              2 0
     C                   Z-ADD     0             ENDYR
     C                   Z-ADD     0             ENDWK
     C                   Z-ADD     0             OEND              6 0
     C                   Z-ADD     0             OEYR              4 0
     C                   Z-ADD     0             OEWK              2 0
     C                   MOVEL     'A'           RPTSEQ
     C                   MOVE      *BLANKS       ORPTSE            1
     C                   MOVEL     'XERPRT01'    LPRTR
     C                   MOVEL     '*NAR'        LFORM
     C                   MOVEL     'N'           LJOBQ
     C                   Z-ADD     1             VOUT
     C                   Z-ADD     1             LCOPY
     C                   SETOFF                                       103938
     C                   SETOFF                                       303135
     C                   SETOFF                                       404145
     C                   SETOFF                                       489899
     C                   SETOFF                                       525354
      *
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C                   SETOFF                                       103938
     C                   SETOFF                                       303135
     C                   SETOFF                                       215051
     C                   SETOFF                                       404145
     C                   SETOFF                                       48  99
     C                   SETOFF                                       525354
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C     RPTSEQ        IFNE      'A'                                                      K
     C     RPTSEQ        ANDNE     'N'                                                      K
     C                   SETON                                        1099
     C                   GOTO      NXTA
     C                   ENDIF
      *
      *
      * CHECK FOR BEGINING DATE
     C     BEGDAT        IFGT      0
     C     BEGDAT        CHAIN     FCALEN                             30
     C   30              DO
     C                   SETON                                        99
     C                   Z-ADD     0             BEGCYM
     C                   Z-ADD     0             BEGYR
     C                   Z-ADD     0             BEGWK
     C                   GOTO      NXTA
     C                   ENDDO                                                  30 DO
     C     CL#Y          IFNE      1
     C                   SETON                                        303199
     C                   GOTO      NXTA
     C                   END                                                    CL#Y><1
     C                   MOVEL     CLCENT        BEGYR
     C                   MOVE      CLYEAR        BEGYR
     C                   Z-ADD     CLWEEK        BEGWK
     C                   Z-ADD     CLCYMD        BEGCYM
     C                   END                                                    BEGDAT>0
      * SEE IF WEEK NUMBER ENTERED
     C     BEGDAT        IFLE      0
     C     BEGYR         ANDGT     0
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    CLWEEK
     C                   KFLD                    CL#Y
     C                   MOVEL     BEGYR         CLCENT
     C                   MOVE      BEGYR         CLYEAR
     C                   Z-ADD     BEGWK         CLWEEK
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             35
     C   35              DO
     C                   SETON                                        99
     C                   Z-ADD     0             BEGCYM
     C                   GOTO      NXTA
     C                   ENDDO
     C                   Z-ADD     CLDATE        BEGDAT
     C                   Z-ADD     CLCYMD        BEGCYM
     C                   END                                                    BEGDAT=0
      *
      *
      * CHECK FOR END DATE
     C     ENDDAT        IFGT      0
     C     ENDDAT        CHAIN     FCALEN                             40
     C   40              DO
     C                   SETON                                        99
     C                   Z-ADD     0             ENDCYM
     C                   Z-ADD     0             ENDYR
     C                   Z-ADD     0             ENDWK
     C                   GOTO      NXTA
     C                   ENDDO                                                  40 DO
     C     CL#Y          IFNE      1
     C                   SETON                                        404199
     C                   GOTO      NXTA
     C                   END                                                    CL#Y><1
     C                   MOVEL     CLCENT        ENDYR
     C                   MOVE      CLYEAR        ENDYR
     C                   Z-ADD     CLWEEK        ENDWK
     C                   Z-ADD     CLCYMD        ENDCYM
     C                   END                                                    ENDDAT>0
      * SEE IF WEEK NUMBER ENTERED
     C     ENDDAT        IFLE      0
     C     ENDYR         ANDGT     0
     C                   MOVEL     ENDYR         CLCENT
     C                   MOVE      ENDYR         CLYEAR
     C                   Z-ADD     ENDWK         CLWEEK
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             45
     C   45              DO
     C                   SETON                                        99
     C                   Z-ADD     0             ENDCYM
     C                   GOTO      NXTA
     C                   ENDDO
     C                   Z-ADD     CLDATE        ENDDAT
     C                   Z-ADD     CLCYMD        ENDCYM
     C                   END                                                    SOWDAT=0
     C     ENDCYM        IFGT      0
     C     BEGCYM        ANDGT     0
     C     ENDCYM        ANDLT     BEGCYM
     C                   SETON                                        2999
     C                   GOTO      NXTA
     C                   END
      *
     C     LPRTR         IFEQ      *BLANKS                                                  K
     C                   SETON                                        5099
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LFORM         IFEQ      *BLANKS                                                  K
     C                   SETON                                        5199
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LCOPY         IFEQ      *ZEROS                                                   OS
     C                   SETON                                        5299
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     LJOBQ         IFNE      'Y'
     C     LJOBQ         ANDNE     'N'
     C                   SETON                                        5399
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VOUT          IFLT      1                                                        OS
     C     VOUT          ORGT      3                                                        OS
     C                   SETON                                        5499
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VOUT          IFEQ      1
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*NO '        LSAVE
     C                   ENDIF
      *
     C     VOUT          IFEQ      2
     C                   MOVEL     '*NO '        LHOLD
     C                   MOVEL     '*YES'        LSAVE
     C                   ENDIF
      *
     C     VOUT          IFEQ      3
     C                   MOVEL     '*YES'        LHOLD
     C                   MOVEL     '*YES'        LSAVE
     C                   ENDIF
      ** REDISPLAY
     C     BEGDAT        IFNE      OBEG
     C     ENDDAT        ORNE      OEND
     C     RPTSEQ        ORNE      ORPTSE
     C                   SETOFF                                       98
     C                   Z-ADD     BEGDAT        OBEG
     C                   Z-ADD     ENDDAT        OEND
     C                   MOVEL     RPTSEQ        ORPTSE
     C                   ENDIF
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTA
     C                   ENDDO                                                  N98 DO
      *
     C     END           TAG
     C                   SETON                                        LR
      **
