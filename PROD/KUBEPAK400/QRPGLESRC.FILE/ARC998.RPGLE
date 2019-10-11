      *--------------------------------------------------------------
      *
      *   COPYRIGHT EFD ENTERPRISES, INC.    2000
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
      *PROGRAM NAME--------- ARC998
      *SYSTEM--------------- ACCOUNTS RECEIVABLE
      *APPLICATION---------- GLOBAL PROMPT FOR COMPANY NUMBER
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFARCTL    IF   E           K DISK
     FFGLDF     IF   E           K DISK
     FARC998FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
      *
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     0             COMP              2 0
     C     COMP          CHAIN     FARCTL                             90
     C                   Z-ADD     ACPRCO        LCO
     C     ACNMCO        IFEQ      1
     C                   GOTO      ONECO
     C                   END
      *
     C     RSTRT         TAG
     C                   SETOFF                                       50
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101112
     C                   SETOFF                                       2030
     C                   SETOFF                                       405052
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C     LCO           IFEQ      *ZEROS
     C                   SETON                                        1011
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     ONECO         TAG
     C     LCO           CHAIN     FARCTL                             90
     C   90              SETON                                        1011
     C   10              GOTO      RSTRT
      *
     C     LPROG         IFEQ      'ARR210  '
     C                   MOVEL     '01'          GDTYPE            2
     C     GLDKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GDTYPE
     C     GLDKEY        CHAIN     FGLDF                              91
     C   91              SETON                                        1012
     C   91              GOTO      RSTRT
     C                   ENDIF
      *
     C                   MOVEL     '*NAR'        LFORM
     C                   MOVEL     ACRPTP        LPRTR
     C                   MOVEL     'N'           LJOBQ
     C                   Z-ADD     01            LCOPY
      *
     C     END           TAG
     C                   SETON                                        LR
      *
