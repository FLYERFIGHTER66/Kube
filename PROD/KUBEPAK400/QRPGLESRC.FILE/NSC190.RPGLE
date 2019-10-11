      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2002
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
      **PROGRAM NAME-------- NSC190
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- BUILD WEEKLY PLUG LOCATION FILE PROMPT
      *
      *            CHANGE--DATE-------DESCRIPTION
WJB   * WJB  5/06/04 ADDED LOGIC TO FASCILITATE SELECTIVELY INCLUDING OR
      *              OMMITTING KUBE PAK ORDERS FROM THE BUILD
      *
     FNSC190FM  CF   E             WORKSTN
     FFCALEN    IF   E           K DISK
     FFCALEX    IF   E           K DISK
     F                                     RENAME(RCALEN:ICALEN)
     FNPLGSCTL  IF   E           K DISK
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
     D  PLDATE                11     16  0
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  RPRTR                134    143
WJB  D  LX1521               144    144
WJB  D  LMASTER              145    146  0
      ***********************
      ** START OR RESTART  **
      ***********************
     C     RSTART        TAG
     C                   Z-ADD     0             FRMDAT
     C                   Z-ADD     0             PLDATE
     C                   Z-ADD     0             BEGYY             4 0
     C                   Z-ADD     0             BEGWW             2 0
     C                   MOVE      *BLANKS       LCANCL
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
     C                   SETOFF                                       989959
WJB  C                   SETOFF                                       22
      ** DISPLAY SCREEN
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
WJB  C                   SETOFF                                       599922
      ** CHECK INPUT
WJB  C     LX1521        IFNE      'Y'
WJB  C     LX1521        ANDNE     'N'
WJB  C                   SETON                                        22
WJB  C                   GOTO      NXTA
WJB  C                   ENDIF
      **
      ** CHECK DATE
     C     FRMDAT        IFLE      0
     C     BEGYY         ANDLE     0
     C     BEGWW         ANDLE     0
     C                   SETON                                        10  99
     C                   GOTO      NXTA
     C                   ENDIF
      **
     C     FRMDAT        IFGT      0
     C                   Z-ADD     FRMDAT        ##MDY
     C                   SETOFF                                       90
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        90
     C                   END
     C  N90              CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C  N90              Z-ADD     ##CYMD        STRDAT            7 0
     C  N90              CALL      '@DAYWK'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    #Y                1 0          DAY OF WEEK
     C   90              DO
     C                   SETON                                        1099
     C                   GOTO      NXTA
     C                   ENDDO
     C*    #Y            IFNE      1
     C*                  SETON                                        101199
     C*                  GOTO      NXTA
     C*                  END
     C     FRMDAT        CHAIN     FCALEN                             92
     C                   MOVEL     CLCENT        BEGYY
     C                   MOVE      CLYEAR        BEGYY
     C                   Z-ADD     CLWEEK        BEGWW
     C                   ELSE                                                   FRMDAT > 0
     C                   MOVEL     BEGYY         CLCENT
     C                   MOVE      BEGYY         CLYEAR
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    BEGWW
     C                   KFLD                    CL#Y
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             92
     C   92              DO
     C                   SETON                                        2099
     C                   GOTO      NXTA
     C                   ENDDO
     C                   Z-ADD     CLDATE        FRMDAT
     C                   Z-ADD     CLCYMD        STRDAT            7 0
     C                   END                                                    FRMDAT > 0
      ** CHECK IF LOCATIONS ENTERED.
     C                   Z-ADD     0             PSCOMP
     C     PSCOMP        CHAIN     NPLGSCTL                           59
     C  N59              DO
     C     STRDAT        IFGT      PSLOCD
     C                   SETON                                        59
     C                   END
     C                   ENDDO                                                  N59  DO
     C   59              DO
     C                   SETON                                        99
     C                   GOTO      NXTA
     C                   ENDDO                                                  59  DO
      ** IF FIRST TIME REDISPLAY
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTA
     C                   END
     C                   Z-ADD     FRMDAT        PLDATE
     C                   Z-ADD     SMASTER       LMASTER
      *** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
WJB  C                   MOVE      'Y'           LX1521
     C                   ENDSR
