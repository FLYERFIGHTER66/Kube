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
      *PROGRAM NAME-------- APR991
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- UPDATE A/P CONTROL FILE AFTER MONTH END
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFAPCTL    UF   E           K DISK
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
     D  LCO                    1      2  0
      *  PERIOD SELECTION
     D  LDAPER                 3      4  0
      *  SELECTED PERIOD START DATE
     D  LDABEG                10     15  0
      *  SELECTED PERIOD END DATE
     D  LDAEND                16     21  0
     D  LRPT                  23     23
     D  LPURGE                24     24
     D  LOPNDT                25     30  0
     D  LDTPDT                31     36  0
     D  LAPDET                43     51
     D  LAPMTH                52     60
     D  LAPOPN                61     69
     D  LAPDTP                70     78
     D  LLIBR                 88     97
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
      ***********************
      ** UPDATE FAPCTL     **
      ***********************
     C     LCO           CHAIN     FAPCTL                             90
     C                   Z-ADD     TDATE         AZDTMC
     C                   Z-ADD     TDATE         AZDTLA
     C                   Z-ADD     TIMOD         AZTIME
     C                   MOVEL     USERID        AZUSER
     C  N90              UPDATE    RAPCTL
      * END
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
