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
      **PROGRAM NAME-------- SOW300
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CANCEL/RE-ACTIVATE SOW LINE JOBS
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FSOW300FM  CF   E             WORKSTN
     F                                     SFILE(BARSFL:RECNO)
     FFTRAY     UF   E           K DISK
     FFTRAYR    UF   E           K DISK
     FFTRAYJ    UF   E           K DISK
     F                                     RENAME(RTRAY:RTRAYJ)
     FFTRAYJR   UF   E           K DISK
     F                                     RENAME(RTRAYR:RTRAYJR)
     FFBADTR    UF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFCALEN    IF   E           K DISK
     FFCALEX    IF   E           K DISK
     F                                     RENAME(RCALEN:CALEX)
     FFCALENCY  IF   E           K DISK
     F                                     RENAME(RCALEN:CALEN)
     FFSOWSCHJ  UF   E           K DISK
     FFPRODCD   IF   E           K DISK
      *
      * MESSAGE
     D MSG             S             30    DIM(10) CTDATA PERRCD(1)             MESSAGES
      * SCREEN LINES
     D SCR             S             78    DIM(10) CTDATA PERRCD(1)             SCREEN LINES
      *
      *
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
     D  SOWLN                  1      1  0                                      ARC380
     D  LFILE                 11     20
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  RPRTR                134    143

     D  SowDateIn            501    506
     D  JOB#in               507    510

     D  PassedParms    S               N
    ?D StartTag#       S              8S 0
    ?D EndTag#         S              8S 0

      ****************
      * START HERE   *
      ****************
     C     RSTART        TAG
     C                   If        PassedParms
     C                   MoveL     'X'           LCANCL
     C                   GoTo      END
     C                   EndIf
     C                   MOVE      *BLANKS       LCANCL
     C                   SETOFF                                       1020
     C                   UNLOCK    FTRAY
WJB  C                   UNLOCK    FTRAYR
     C                   UNLOCK    FTRAYJ
WJB  C                   UNLOCK    FTRAYJR
     C                   UNLOCK    FBADTR
     C                   UNLOCK    FSOWSCHJ

     C                   If        SowDateIn <> *Blanks
     C                   Move      SowDateIn     SowDat
     C                   Eval      SowDateIn = *Blanks
     C                   Eval      PassedParms = *On
     C                   Move      Job#In        JOB#
     C                   GoTo      SkipA
     C                   EndIf

     C                   Z-ADD     0             JOB#
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C*                    EXFMTSCRNC
      ** CHECK F KEYS
     C     SKIPA         TAG
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
     C     JOBKEY        CHAIN(N)  FSOWSCHJ                           10
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
WJB  C     TRYKEY        SETLL     FTRAYJ                                 60
WJB  C  N60TRYKEY        SETLL     FTRAYJR
     C                   Z-ADD     0             BEGTAG
     C     NXTTRY        TAG
WJB  C     TRYKEY        READE(N)  FTRAYJ                                 91
WJB  C  N60TRYKEY        READE(N)  FTRAYJR                                91
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
wjb  C     SOSTAT        IFEQ      'E'
wjb  C                   MOVEL     MSG(7)        STDESC
wjb  C                   END
     C                   Z-ADD     0             LEFT
     C     SOSTAT        IFNE      'D'
     C     SOSOWT        SUB       SOSOWQ        LEFT
     C                   END
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C                   SETOFF                                       10
      ** CHECK IF RIGHT JOB
     C     YORN          IFNE      'Y'
     C     YORN          ANDNE     'N'
     C                   SETON                                        10
     C                   GOTO      NXTB
     C                   END
      ** IF NO START OVER
     C     YORN          IFEQ      'N'
     C                   GOTO      RSTART
     C                   END
      ** DECIDE WHERE TO GO
     C     SOSTAT        IFEQ      'C'
     C     SOSTAT        OREQ      'S'
     C     SOSTAT        OREQ      'D'
     C                   EXSR      CLOSED
     C                   GOTO      RSTART
     C                   END
     C     SOSTAT        IFEQ      'A'
WJB  C     SOSTAT        OREQ      'E'
     C                   EXSR      OPEN
     C                   GOTO      RSTART
     C                   END
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** OPEN CLOSED JOB   **
      ***********************
     C     CLOSED        BEGSR
     C                   EXSR      BLDSFL
     C                   MOVEL     MSG(5)        ACTDES
     C                   MOVEL     SCR(1)        INST1
     C                   MOVEL     SCR(2)        INST2
     C                   MOVEL     'A'           NEWSTA            1
     C                   EXFMT     BARCTL
     C   KF              GOTO      ENDCLO
     C   KA              DO
     C                   EXSR      DELALL
     C                   GOTO      ENDCLO
     C                   END
      ** CHECK FOR DELETE TAGS
     C                   Z-ADD     0             RECNO
     C     RECNO         DOUGT     LSTREC
     C                   ADD       1             RECNO
     C     RECNO         CHAIN     BARSFL                             92
     C                   MOVEL     TRSTAT        NSTAT             1
WJB  C                   SETOFF                                       59
WJB  C  N92TRTAG#        CHAIN     FTRAY                              93
     C  N92
WJB  CAN 93              SETON                                        59
WJB  C   59TRTAG#        CHAIN     FTRAYR                             93
     C  N92
     CANN93              DO
     C     TRSTAT        IFNE      NSTAT
     C     NSTAT         ANDNE     ' '
     C     NSTAT         IFEQ      'D'
     C                   MOVEL     'D'           TRSTAT
     C                   MOVEL     'SLC'         TRREAS
     C                   Z-ADD     TDATE         TRDTLA
     C                   TIME                    TRTIME
     C                   MOVEL     USERID        TRUSER
WJB  C  N59              UPDATE    RTRAY
WJB  C   59              UPDATE    RTRAYR
     C                   Call      'RMVLOTINV'
     C                   Parm      TRTAG#        StartTag#
     C                   Parm      TRTAG#        EndTag#
     C     TRTAG#        CHAIN     FBADTR                             94
     C  N94              DELETE    RBADTR
     C                   END                                                    NSTAT=D
     C     NSTAT         IFEQ      'A'
     C                   MOVEL     'A'           TRSTAT
     C                   MOVE      *BLANKS       TRREAS
     C                   Z-ADD     TDATE         TRDTLA
     C                   TIME                    TRTIME
     C                   MOVEL     USERID        TRUSER
WJB  C  N59              UPDATE    RTRAY
WJB  C   59              UPDATE    RTRAYR
     C                   Call      'ADDLOTINV'
     C                   Parm      TRTAG#        StartTag#
     C                   Parm      TRTAG#        EndTag#
     C     TRTAG#        CHAIN     FBADTR                             94
     C  N94              DELETE    RBADTR
     C                   END                                                    NSTAT=A
     C                   END                                                    NSTAT><TRSTA
     C                   ENDDO
     C                   ENDDO
      ** GET NEW COUNT FOR SOWSCH
     C                   EXSR      GETCNT
     C                   MOVEL     'Y'           #CLOS             1
     C                   EXSR      UPDJOB
     C                   MOVE      *BLANKS       #CLOS
     C     ENDCLO        ENDSR
      ***********************
      ** CLOSE OPEN  JOB   **
      ***********************
     C     OPEN          BEGSR
     C                   EXSR      BLDSFL
     C                   MOVEL     MSG(6)        ACTDES
     C                   MOVEL     SCR(3)        INST1
     C                   MOVEL     SCR(4)        INST2
     C                   MOVEL     'C'           NEWSTA            1
     C                   EXFMT     BARCTL
     C   KF              GOTO      ENDOPN
     C   KA              DO
     C                   EXSR      OPNALL
     C                   GOTO      ENDOPN
     C                   END
      ** CHECK FOR DELETE TAGS
     C                   Z-ADD     0             RECNO
     C     RECNO         DOUGT     LSTREC
     C                   ADD       1             RECNO
     C     RECNO         CHAIN     BARSFL                             92
     C                   MOVEL     TRSTAT        NSTAT             1
     C  N92TRTAG#        CHAIN     FTRAY                              93
     C                   SETOFF                                       61
     C  N92
     CANN93              SETON                                        61
WJB  C   61TRTAG#        CHAIN     FTRAYR                             93
     C  N92
     CANN93              DO
     C     TRSTAT        IFNE      NSTAT
     C     NSTAT         ANDNE     ' '
     C     NSTAT         IFEQ      'D'
     C                   MOVEL     'D'           TRSTAT
     C                   MOVEL     'SLC'         TRREAS
     C                   Z-ADD     TDATE         TRDTLA
     C                   TIME                    TRTIME
     C                   MOVEL     USERID        TRUSER
WJB  C  N61              UPDATE    RTRAY
WJB  C   61              UPDATE    RTRAYR
     C                   Call      'RMVLOTINV'
     C                   Parm      TRTAG#        StartTag#
     C                   Parm      TRTAG#        EndTag#
     C     TRTAG#        CHAIN     FBADTR                             94
     C  N94              DELETE    RBADTR
     C                   END                                                    NSTAT=D
     C     NSTAT         IFEQ      'A'
     C                   MOVEL     'A'           TRSTAT
     C                   MOVE      *BLANKS       TRREAS
     C                   Z-ADD     TDATE         TRDTLA
     C                   TIME                    TRTIME
     C                   MOVEL     USERID        TRUSER
WJB  C  N61              UPDATE    RTRAY
WJB  C   61              UPDATE    RTRAYR
     C                   Call      'ADDLOTINV'
     C                   Parm      TRTAG#        StartTag#
     C                   Parm      TRTAG#        EndTag#
     C     TRTAG#        CHAIN     FBADTR                             94
     C  N94              DELETE    RBADTR
     C                   END                                                    NSTAT=A
     C                   END                                                    NSTAT><TRSTA
     C                   ENDDO
     C                   ENDDO
      ** GET NEW COUNT FOR SOWSCH
     C                   EXSR      GETCNT
     C                   MOVEL     ' '           #CLOS             1
     C                   EXSR      UPDJOB
     C                   MOVE      *BLANKS       #CLOS
     C     ENDOPN        ENDSR
      ***********************
      ** BUILD SUB FILE    **
      ***********************
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     BARCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
WJB  C     TRYKEY        SETLL     FTRAYJ                                 62
WJB  C  N62TRYKEY        SETLL     FTRAYJR
     C     NXTBLD        TAG
WJB  C   62TRYKEY        READE(N)  FTRAYJ                                 91
WJB  C  N62TRYKEY        READE(N)  FTRAYJR                                91
     C   91              GOTO      ENDBLD
     C                   MOVE      *BLANKS       PCDESC
     C     TRREAS        IFGT      *BLANKS
     C     TRREAS        CHAIN     FPRODCD                            91
     C                   END
     C                   ADD       1             RECNO
     C                   WRITE     BARSFL
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ENDSR
      ***********************
      ** DELETE ALL TAGS   **
      ***********************
     C     DELALL        BEGSR
WJB  C     TRYKEY        SETLL     FTRAYJ                                 63
WJB  C  N63TRYKEY        SETLL     FTRAYJR
     C                   Z-ADD     0             TRYCNT            7 0
     C     NXTDEL        TAG
WJB  C   63TRYKEY        READE     FTRAYJ                                 91
WJB  C  N63TRYKEY        READE     FTRAYJR                                91
     C  N91              DO
     C                   MOVEL     'D'           TRSTAT
     C                   Z-ADD     TDATE         TRDTLA
     C                   TIME                    TRTIME
     C                   MOVEL     USERID        TRUSER
WJB  C   63              UPDATE    RTRAYJ
WJB  C  N63              UPDATE    RTRAYJR
     C                   Call      'RMVLOTINV'
     C                   Parm      TRTAG#        StartTag#
     C                   Parm      TRTAG#        EndTag#
     C                   GOTO      NXTDEL
     C                   ENDDO                                                  N91 DO
     C                   EXSR      GETCNT
     C                   MOVE      *BLANKS       #CLOS
     C                   EXSR      UPDJOB
     C                   ENDSR
      ***********************
      ** OPEN ALL TAGS     **
      ***********************
     C     OPNALL        BEGSR
WJB  C     TRYKEY        SETLL     FTRAYJ                                 64
WJB  C  N64TRYKEY        SETLL     FTRAYJR
     C                   Z-ADD     0             TRYCNT            7 0
     C     NXTOAL        TAG
WJB  C   64TRYKEY        READE     FTRAYJ                                 91
WJB  C  N64TRYKEY        READE     FTRAYJR                                91
     C  N91              DO
     C                   MOVEL     'A'           TRSTAT
     C                   Z-ADD     TDATE         TRDTLA
     C                   TIME                    TRTIME
     C                   MOVEL     USERID        TRUSER
WJB  C   64              UPDATE    RTRAYJ
WJB  C  N64              UPDATE    RTRAYJR
     C                   Call      'ADDLOTINV'
     C                   Parm      TRTAG#        StartTag#
     C                   Parm      TRTAG#        EndTag#
     C                   GOTO      NXTOAL
     C                   ENDDO                                                  N91 DO
     C                   EXSR      GETCNT
     C                   MOVE      *BLANKS       #CLOS
     C                   EXSR      UPDJOB
     C                   ENDSR
      ***********************
      ** UPDATE JOB        **
      ***********************
     C     UPDJOB        BEGSR
     C     JOBKEY        CHAIN     FSOWSCHJ                           10
     C*          #CLOS     IFNE 'Y'
     C*                    ADD  TRYCNT    SOSOWL
     C*                    ADD  TRYCNT    SOSOWQ
     C*                    ELSE
     C                   Z-ADD     TRYCNT        SOSOWL
     C                   Z-ADD     TRYCNT        SOSOWQ
     C*                    END
     C     SOSOWQ        IFLE      0
     C                   Z-ADD     0             SOSOWQ
     C                   END
     C                   MOVEL     NEWSTA        SOSTAT
     C     SOSOWT        SUB       SOSOWQ        TEST              9 0
     C     TEST          IFEQ      0
     C                   MOVEL     'C'           SOSTAT
     C                   END
     C                   Z-ADD     TDATE         SODTLA
     C                   TIME                    SOTIME
     C                   MOVEL     USERID        SOUSER
     C  N10              UPDATE    RSOWSCH
     C                   ENDSR
      ***********************
      ** GET TRAY COUNT    **
      ***********************
     C     GETCNT        BEGSR
      ** GET NEW COUNT FOR SOWSCH
WJB  C     TRYKEY        SETLL     FTRAYJ                                 65
WJB  C  N65TRYKEY        SETLL     FTRAYJ
     C                   Z-ADD     0             TRYCNT
     C     NXCTRY        TAG
WJB  C   65TRYKEY        READE(N)  FTRAYJ                                 91
WJB  C  N65TRYKEY        READE(N)  FTRAYJR                                91
     C   91              GOTO      ENCTRY
     C     TRSTAT        IFEQ      'A'
     C                   ADD       1             TRYCNT
     C                   END
     C                   GOTO      NXCTRY
     C     ENCTRY        TAG
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
**   Message
Open                                    1
Complete                                2
Deleted                                 3
Scheduled                               4
       Open a Closed Job                5
       Close an Open Job                6
In Error                                7
**   Screen lines
F1=Delete all Bar Codes and Re-Open Job.                 F6=Restart(NO UPDATE) 1
Press F1 to clear all or mark D under Stat to delete specific Bar codes.       2
F1=Re-activate All Bar Codes and Close Job.              F6=Restart(NO UPDATE) 3
Press F1 or mark A Under Stat to re-activate specific Bar codes.               4
