      *--------------------------------------------------------------
      *
      *   COPYRIGHT EFD ENTERPRISES, INC.    1999
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
      *PROGRAM NAME--------- SAC998
      *SYSTEM--------------- SALES ANALYSIS
      *APPLICATION---------- GLOBAL PROMPT FOR COMPANY NUMBER
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 5/31/01 EFD DEFAULT JOBQ TO Y. PER BILL
      *
      *
     FFOECTL    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FSAC998FM  CF   E             WORKSTN
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
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DEPREP        LPRTR
     C     LPRTR         IFLE      *BLANKS
     C                   MOVEL     '999'         USDEPT
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DEPREP        LPRTR
     C                   ENDIF
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     0             COMP              2 0
     C     COMP          CHAIN     FOECTL                             90
     C                   Z-ADD     OCPRCO        LCO
     C     OCNMCO        IFEQ      1
     C                   GOTO      ONECO
     C                   END
      *
     C     RSTRT         TAG
     C                   SETOFF                                       50
     C                   WRITE     SCRNA
     C                   SETOFF                                       10
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL
     C   KC
     COR KG              GOTO      END
      *
     C     LCO           IFEQ      *ZEROS
     C                   SETON                                        10
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     ONECO         TAG
     C     LCO           CHAIN     FOECTL                             90
     C   90              SETON                                        10
     C   10              GOTO      RSTRT
      *
     C     END           TAG
     C                   MOVEL     '*NAR'        LFORM
     C                   Z-ADD     01            LCOPY
     C                   MOVEL     'Y'           LJOBQ
     C                   SETON                                        LR
      *
