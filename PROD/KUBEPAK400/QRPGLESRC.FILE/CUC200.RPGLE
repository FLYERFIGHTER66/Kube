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
      *PROGRAM NAME--------- CUC200
      *APPLICATION---------- CUTTING REQUIREMENTS
      *DESCRIPTION---------- CUTTING REQUIREMENTS NEEDS REPORT
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FCUC200FM  CF   E             WORKSTN
     FFCUTNEED  IF   E           K DISK
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
      ** REPORT ONLY  Y/N
     D  RPTONL                 1      1
      ** SEQUENCE  A=ALPHA  N=NUMERIC
     D  RPTSEQ                 2      2
      ** SHOW ALL Y/N
     D  SHOALL                 3      3
      ** SOW DATE MDY
     D  SOWDAT                 4      9  0
      ** SOW DATE CYMD
     D  SOWCYM                10     16  0
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
     C                   MOVEL     'A'           CNSTAT
     C                   Z-ADD     0             SOWDAT
     C                   Z-ADD     0             SOWCYM
     C                   Z-ADD     0             YEAR
     C                   Z-ADD     0             WEEK
     C                   Z-ADD     0             OSOWD             6 0
     C                   Z-ADD     0             OYEAR             4 0
     C                   Z-ADD     0             OWEEK             2 0
     C     VendStat      KList
     C                   KFld                    Vendor
     C                   KFld                    CNSTAT
WJB  C*    CNSTAT        SETLL     FCUTNEED
WJB  C     VendStat      SETLL     FCUTNEED
WJB  C*    CNSTAT        READE     FCUTNEED                               92
WJB  C     VendStat      READE     FCUTNEED                               92
      ** IF 92 NOT ON ONLY REPORT CAN RUN
     C                   MOVEL     'A'           RPTSEQ
     C                   MOVE      *BLANKS       ORPTSE            1
     C                   MOVE      *BLANKS       ORPTON            1
     C                   MOVEL     'Y'           SHOALL
     C                   MOVE      *BLANKS       OSHOAL            1
     C                   MOVEL     'XERPRT01'    LPRTR
     C                   MOVEL     '*NAR'        LFORM
     C                   MOVEL     'N'           LJOBQ
     C                   Z-ADD     1             VOUT
     C                   Z-ADD     1             LCOPY
     C                   SETOFF                                       102030
     C                   SETOFF                                       215051
     C                   SETOFF                                       404145
     C                   SETOFF                                       489899
     C                   SETOFF                                       525354
      *
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C                   SETOFF                                       102030
     C                   SETOFF                                       215051
     C                   SETOFF                                       404145
     C                   SETOFF                                       48  99
     C                   SETOFF                                       525354
      ** IF 92 OFF CANCEL REQUEST
     C  N92              DO
     C                   MOVE      'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
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
     C     SHOALL        IFNE      'Y'
     C     SHOALL        ANDNE     'N'
     C                   SETON                                        3099
     C                   GOTO      NXTA
     C                   ENDIF
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
     C                   Z-ADD     CLCYMD        SOWCYM
     C                   END                                                    SOWDAT=0
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
     C     SOWDAT        IFNE      OSOWD
     C     YEAR          ORNE      OYEAR
     C     WEEK          ORNE      OWEEK
     C     RPTSEQ        ORNE      ORPTSE
     C     SHOALL        ORNE      OSHOAL
     C                   SETOFF                                       98
     C                   Z-ADD     YEAR          OYEAR
     C                   Z-ADD     WEEK          OWEEK
     C                   Z-ADD     SOWDAT        OSOWD
     C                   MOVEL     RPTSEQ        ORPTSE
     C                   MOVEL     SHOALL        OSHOAL
     C                   ENDIF
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTA
     C                   ENDDO                                                  N98 DO
      *
     C     END           TAG
     C                   SETON                                        LR
      **
