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
      *PROGRAM NAME--------- GLC998
      *SYSTEM--------------- GENERAL LEDGER
      *APPLICATION---------- GLOBAL PROMPT FOR COMPANY NUMBER
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFGLCTL    IF   E           K DISK
     FGLC998FM  CF   E             WORKSTN UsrOpn
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
     C     COMP          CHAIN     FGLCTL                             90
     C                   Z-ADD     GZPRCO        LCO
     C     GZNMCO        IFEQ      1
     C                   GOTO      ONECO
     C                   END
      *
     C     RSTRT         TAG
     C                   SETOFF                                       50
     C                   If        not %Open(GLC998FM)
     C                   Open      GLC998FM
     C                   EndIf
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
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
     C     LCO           CHAIN     FGLCTL                             90
     C   90              SETON                                        10
     C   10              GOTO      RSTRT
      *
     C                   MOVEL     '*NAR'        LFORM
     C                   MOVEL     GZPRTR        LPRTR
     C                   Z-ADD     01            LCOPY
     C                   MOVEL     'N'           LJOBQ
      *
     C     END           TAG
     C                   If        %Open(GLC998FM)
     C                   Close     GLC998FM
     C                   EndIf
     C                   SETON                                        LR
      *
