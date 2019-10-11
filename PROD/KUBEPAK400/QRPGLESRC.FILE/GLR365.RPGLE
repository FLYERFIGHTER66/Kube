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
      *PROGRAM NAME-------- GLR365
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- REVERSING JOURNAL ENTRY POST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 9/28/99 EFD DELETE GLREV RECORD
      *
     FFGLREV    UF   E           K DISK
     FFGLCTL    UF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFGLDET    O  A E           K DISK
      *
      * MAPER ARRAYS
     D BEG             S              6  0 DIM(13)                              BEG DATES
     D DNE             S              6  0 DIM(13)                              END DATES
      *
     D MSG             S             21    DIM(1) CTDATA PERRCD(1)              DESC
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
     IRMAPER
     I              ACST01                      BEG(1)
     I              ACST02                      BEG(2)
     I              ACST03                      BEG(3)
     I              ACST04                      BEG(4)
     I              ACST05                      BEG(5)
     I              ACST06                      BEG(6)
     I              ACST07                      BEG(7)
     I              ACST08                      BEG(8)
     I              ACST09                      BEG(9)
     I              ACST10                      BEG(10)
     I              ACST11                      BEG(11)
     I              ACST12                      BEG(12)
     I              ACST13                      BEG(13)
     I              ACEN01                      DNE(1)
     I              ACEN02                      DNE(2)
     I              ACEN03                      DNE(3)
     I              ACEN04                      DNE(4)
     I              ACEN05                      DNE(5)
     I              ACEN06                      DNE(6)
     I              ACEN07                      DNE(7)
     I              ACEN08                      DNE(8)
     I              ACEN09                      DNE(9)
     I              ACEN10                      DNE(10)
     I              ACEN11                      DNE(11)
     I              ACEN12                      DNE(12)
     I              ACEN13                      DNE(13)
      *
     C                   MOVEL     *BLANKS       GWJEPR
     C                   Z-ADD     0             GWJENM
     C                   MOVEL     *BLANKS       GWJESF
     C     GLKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GWJEPR
     C                   KFLD                    GWJENM
     C                   KFLD                    GWJESF
     C     GLKEY         SETLL     FGLREV
      *
     C     NXT           TAG
     C                   READ      FGLREV                                 90
     C   90              GOTO      END
      *
     C     GWCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     GWSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     GWPOST        IFEQ      'Y'
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHECK FOR DEBIT OR CREDIT AMOUNT
      *
     C                   EXSR      UGLDET
     C                   EXSR      UGLREV
     C                   GOTO      NXT
      *
     C     END           TAG
      *
     C                   MOVEL     'N'           GZOKRV
     C     LCO           CHAIN     FGLCTL                             90
     C                   UPDATE    RGLCTL
     C                   SETON                                        LR
      *********
      * UGLDET
      *********
     C     UGLDET        BEGSR
     C                   Z-ADD     LCO           CONO              2 0
     C                   Z-ADD     GWACDT        TRNDAT            6 0
     C                   CALL      'GETAPER'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    TRNDAT            6 0
     C                   PARM                    ERR               1 0
     C                   Z-ADD     ACTPER        #P                2 0
     C     #P            IFEQ      99
     C                   MOVEL     '9999'        GTAPER
     C                   ELSE
     C                   MOVE      GWACDT        YY                2 0
     C                   MOVEL     YY            GTAPER
     C                   MOVE      #P            GTAPER
     C                   ENDIF
     C                   MOVEL     'A'           GTSTAT
     C                   Z-ADD     GWCOMP        GTCOMP
     C                   Z-ADD     GWGLAC        GTACCT
     C                   Z-ADD     GW$AMT        GTDOL$
     C                   Z-ADD     GWACDT        GTTDAT
     C                   MOVEL     'J/E'         GTSRCE
     C                   MOVEL     'G/L'         GTAPPL
     C                   MOVEL     *BLANKS       GTPROD
     C                   MOVEL     GWJENM        GTJENM
     C                   Z-ADD     GWACDT        GTTDAT
     C                   MOVEL     GWJESF        GTJESF
     C                   MOVEL     GWJEDS        GTJEDS
     C                   MOVEL     GWJETP        GTDETT
     C                   MOVEL     *BLANKS       GTPOST
     C                   MOVEL     GWDDES        GTSRDS
     C                   Z-ADD     TIMOD         GTTIME
     C                   MOVEL     USERID        GTUSER
     C                   MOVEL     GWSHFR        GTSHFR
     C                   Z-ADD     TDATE         GTDTLA
     C     GTTDAT        MULT      10000.01      GTRVDT            6 0
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
     C                   MOVEL     'D'           GWSTAT
     C                   MOVEL     'Y'           GWPOST
     C                   DELETE    RGLREV
      *
     C                   ENDSR
      *
      *********
      * UGLREV - WRITE REVERSING ENTRY
      *********
     C     UGLREV        BEGSR
     C   12#P            IFLT      12
     C     #P            ADD       1             NPER              2 0
     C                   Z-ADD     NPER          X                 2 0
     C                   Z-ADD     DNE(X)        NENDDT            6 0
     C                   Z-ADD     BEG(X)        GWACDT
     C                   MOVE      NENDDT        YY                2 0
     C                   MOVEL     YY            GTAPER
     C                   MOVE      NPER          GTAPER
     C                   GOTO      GOTP
     C                   ELSE
     C                   MOVEL     '9999'        GTAPER
     C                   ENDIF
     C   13#P            IFLT      13
     C     #P            ADD       1             NPER
     C                   Z-ADD     NPER          X                 2 0
     C                   Z-ADD     DNE(X)        NENDDT            6 0
     C                   Z-ADD     BEG(X)        GWACDT
     C                   MOVE      NENDDT        YY                2 0
     C                   MOVEL     YY            GTAPER
     C                   MOVE      NPER          GTAPER
     C                   GOTO      GOTP
     C                   ELSE
     C                   MOVEL     '9999'        GTAPER
     C                   ENDIF
      * IF HERE NEXT YEAR
     C                   Z-ADD     BEG(1)        WKDATE            6 0
     C                   MOVE      WKDATE        YY
     C                   ADD       1             YY
     C                   MOVE      YY            WKDATE
     C                   Z-ADD     WKDATE        NENDDT
     C                   Z-ADD     WKDATE        GWACDT
     C     GOTP          TAG
     C                   MOVEL     'A'           GTSTAT
     C                   Z-ADD     GWCOMP        GTCOMP
     C                   Z-ADD     GWGLAC        GTACCT
     C                   Z-SUB     GW$AMT        GTDOL$
     C                   Z-ADD     GWACDT        GTTDAT
     C                   MOVEL     'J/E'         GTSRCE
     C                   MOVEL     'G/L'         GTAPPL
     C                   MOVEL     *BLANKS       GTPROD
     C                   MOVEL     GWJENM        GTJENM
     C                   Z-ADD     GWACDT        GTTDAT
     C                   MOVEL     GWJESF        GTJESF
     C                   MOVEL     GWJEDS        GTJEDS
     C                   MOVEL     GWJETP        GTDETT
     C                   MOVEL     *BLANKS       GTPOST
     C                   MOVEL     MSG(1)        GTSRDS
     C                   MOVE      GWACDT        GTSRDS
     C                   Z-ADD     TIMOD         GTTIME
     C                   MOVEL     USERID        GTUSER
     C                   MOVEL     GWSHFR        GTSHFR
     C                   Z-ADD     TDATE         GTDTLA
     C     NENDDT        MULT      10000.01      GTRVDT            6 0
     C                   MOVEL     GTRVDT        YR                2 0
     C     YR            IFGT      70
     C                   MOVEL     0             CENT              1 0
     C                   ELSE
     C                   MOVEL     1             CENT
     C                   ENDIF
     C                   MOVEL     CENT          GTCYMD
     C                   MOVE      GTRVDT        GTCYMD
      *
     C                   WRITE     RGLDET
      *
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN(N)  FMAPER                             90
     C     ACMPCN        IFEQ      'M'
     C                   SETON                                        12
     C                   ENDIF
     C     ACMPCN        IFEQ      'P'
     C                   SETON                                        13
     C                   ENDIF
      *
     C                   ENDSR
      *
**
Reversing Entry From:
