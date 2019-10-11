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
     C     USERID        IFNE      'LINE01'
     C     USERID        ANDNE     'LINE02'
     C     USERID        ANDNE     'LINE03'
     C     USERID        ANDNE     'LINE04'
     C                   Z-ADD     9             SOWLIN
     C                   MOVEL     'P4    '      LPRTR
     C                   MOVEL     'FSOWLAB9'    LFILE
     C                   MOVEL     'NEWSOW9 '    LFORM
     C                   GOTO      END
     C                   END
     C     USERID        IFEQ      'LINE01'
     C                   Z-ADD     1             SOWLIN
     C                   MOVEL     'R1    '      LPRTR
     C                   MOVEL     'FSOWLAB1'    LFILE
     C                   MOVEL     'NEWSOW  '    LFORM
     C                   GOTO      END
     C                   END
     C     USERID        IFEQ      'LINE02'
     C                   Z-ADD     2             SOWLIN
     C                   MOVEL     'R2    '      LPRTR
     C                   MOVEL     'FSOWLAB2'    LFILE
     C                   MOVEL     'NEWSOW  '    LFORM
     C                   GOTO      END
     C                   END
     C     USERID        IFEQ      'LINE03'
     C                   Z-ADD     3             SOWLIN
     C                   MOVEL     'P4    '      LPRTR
     C                   MOVEL     'FSOWLAB3'    LFILE
     C                   MOVEL     'NEWSOW  '    LFORM
     C                   GOTO      END
     C                   END
     C     USERID        IFEQ      'LINE04'
     C                   Z-ADD     4             SOWLIN
     C                   MOVEL     'L4    '      LPRTR
     C                   MOVEL     'FSOWLAB4'    LFILE
     C                   MOVEL     'NEWSOWL4'    LFORM
     C                   GOTO      END
     C                   END
      *
      *END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      *
