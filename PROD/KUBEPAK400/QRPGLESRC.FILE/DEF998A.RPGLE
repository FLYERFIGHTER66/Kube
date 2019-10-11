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
      *PROGRAM NAME--------- DEF998A
      *SYSTEM--------------- DEFAULT
      *APPLICATION---------- GLOBAL PROMPT FOR COMPANY NUMBER
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFOECTL    IF   E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
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
     C     USERID        CHAIN     FMUSER                             96
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DEPREP        LPRTR            10
     C     LPRTR         IFLE      *BLANKS
     C                   MOVEL     '999'         USDEPT
     C     USDEPT        CHAIN     FMDEPT                             97
     C                   MOVEL     DEPREP        LPRTR
     C                   ENDIF
      *
     C                   Z-ADD     0             COMP              2 0
     C     COMP          CHAIN     FOECTL                             90
     C                   Z-ADD     OCPRCO        LCO
     C     OCNMCO        IFEQ      1
     C                   GOTO      ONECO
     C                   END
      *
     C                   Z-ADD     01            LCO
      *
     C     ONECO         TAG
      *
     C                   MOVEL     '*NAR'        LFORM
     C                   MOVEL     'N'           LJOBQ
     C                   Z-ADD     01            LCOPY
      *
     C     END           TAG
     C                   SETON                                        LR
      *
