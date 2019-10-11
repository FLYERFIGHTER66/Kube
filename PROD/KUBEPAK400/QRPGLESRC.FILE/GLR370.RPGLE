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
      *PROGRAM NAME-------- GLR370
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- RECURRING JOURNAL ENTRY POST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFGLRJE    UF   E           K DISK
     FFGLCTL    UF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFGLDET    O  A E           K DISK
      *
     D POS             S              1    DIM(13)                              POSTED
     D SOU             S              1    DIM(13)                              SKIP OR USE
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
     D                UDS
     D  LCO                    1      2  0
     D  LACTP                  3      4  0
     D  LBDATE                 5     10  0
     D  LEDATE                11     16  0
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
     IRGLRJE
     I              GJSP01                      SOU(1)
     I              GJSP02                      SOU(2)
     I              GJSP03                      SOU(3)
     I              GJSP04                      SOU(4)
     I              GJSP05                      SOU(5)
     I              GJSP06                      SOU(6)
     I              GJSP07                      SOU(7)
     I              GJSP08                      SOU(8)
     I              GJSP09                      SOU(9)
     I              GJSP10                      SOU(10)
     I              GJSP11                      SOU(11)
     I              GJSP12                      SOU(12)
     I              GJSP13                      SOU(13)
      *
     I              GJPP01                      POS(1)
     I              GJPP02                      POS(2)
     I              GJPP03                      POS(3)
     I              GJPP04                      POS(4)
     I              GJPP05                      POS(5)
     I              GJPP06                      POS(6)
     I              GJPP07                      POS(7)
     I              GJPP08                      POS(8)
     I              GJPP09                      POS(9)
     I              GJPP10                      POS(10)
     I              GJPP11                      POS(11)
     I              GJPP12                      POS(12)
     I              GJPP13                      POS(13)
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   MOVE      TDATE         YR                2 0
      *
     C                   Z-ADD     LACTP         P                 2 0
      *
     C                   Z-ADD     1             CNT               6 0
      *
     C     LCO           CHAIN     FMCORG                             97
      *
     C                   MOVEL     *BLANKS       GJJEPR
     C                   Z-ADD     0             GJJENM
     C                   MOVEL     *BLANKS       GJJESF
     C     GLKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GJJEPR
     C                   KFLD                    GJJENM
     C                   KFLD                    GJJESF
     C     GLKEY         SETLL     FGLRJE
      *
     C     NXT           TAG
     C                   READ      FGLRJE                                 90
     C   90              GOTO      END
      *
     C     GJCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     GJSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     SOU(P)        IFEQ      'S'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     POS(P)        IFEQ      'Y'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   EXSR      UGLDET
     C                   SETON                                        77
     C                   GOTO      NXT
      *
     C     END           TAG
      *
     C     LCO           CHAIN     FGLCTL                             90
     C                   MOVEL     'N'           GZOKRE
     C                   Z-ADD     TDATE         GZRECP
     C                   UPDATE    RGLCTL
     C                   SETON                                        LR
      *********
      * UGLDET
      *********
     C     UGLDET        BEGSR
     C                   MOVEL     'A'           GTSTAT
     C                   Z-ADD     GJCOMP        GTCOMP
     C                   Z-ADD     GJGLAC        GTACCT
     C                   Z-ADD     GJ$AMT        GTDOL$
     C                   Z-ADD     TDATE         GTTDAT
     C                   MOVEL     'J/E'         GTSRCE
     C                   MOVEL     'G/L'         GTAPPL
     C                   MOVEL     *BLANKS       GTPROD
     C                   MOVEL     GJJEPR        GTJEPR
     C                   MOVEL     GJJENM        GTJENM
     C                   MOVEL     GJJESF        GTJESF
     C                   MOVEL     GJJEDS        GTJEDS
     C                   MOVEL     YR            GTAPER
     C                   MOVE      LACTP         GTAPER
     C                   MOVEL     GJJETP        GTDETT
     C                   MOVEL     *BLANKS       GTPOST
     C                   MOVEL     GJDDES        GTSRDS
     C                   Z-ADD     TIMOD         GTTIME
     C                   MOVEL     USERID        GTUSER
     C                   MOVEL     GJSHFR        GTSHFR
     C                   Z-ADD     TDATE         GTDTLA
     C     LBDATE        MULT      10000.01      GTRVDT            6 0
     C                   MOVEL     GTRVDT        YR                2 0
     C     YR            IFGT      70
     C                   MOVEL     0             CENT              1 0
     C                   ELSE
     C                   MOVEL     1             CENT
     C                   ENDIF
     C                   MOVEL     CENT          GTCYMD
     C                   MOVE      GTRVDT        GTCYMD
     C                   WRITE     RGLDET
      *
     C                   MOVEL     'Y'           POS(P)
     C                   Z-ADD     LEDATE        GJPSTL
     C                   UPDATE    RGLRJE
      *
     C                   ENDSR
      *
