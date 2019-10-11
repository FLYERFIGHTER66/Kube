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
      **PROGRAM NAME-------- SOW001
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- SOWLINE OPERATIONS
      *
      *            CHANGE--DATE-------DESCRIPTION
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
     D  SOWLIN                 1      1  0                                      ARC380
     D  LFILE                 11     20
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  RPRTR                134    143
      ******************
      * GET COMMON LDA *
      ******************
     C                   MOVEL     'N'           LJOBQ
     C                   MOVEL     '*NO'         LHOLD
     C                   MOVEL     '*NO'         LSAVE
     C                   MOVE      *BLANKS       LCANCL
     C                   Z-ADD     1             LCOPY
     C                   MOVEL     'P4    '      RPRTR
      ******************
      * CHECK FOR USER *
      ******************
     C                   Z-ADD     3             SOWLIN
     C                   MOVEL     TIMOD         TIM7              7
     C                   MOVE      TIMOD         LFILE
     C                   MOVEL     'FLAB'        LFILE
     C                   MOVEL     'NEWSOW  '    LFORM
      *
      *END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
