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
      **PROGRAM NAME-------- SLR001
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- SET UP SOWLINE NUMBER IN LDA
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FSLC001FM  CF   E             WORKSTN
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
     D  SOWLN#                 1      2  0                                      ARC380
     D  LWSID                 80     89                                         ARC380
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133                                         ARC380
      *******************
      * GET SOW LINE #  *
      *******************
     C                   Z-ADD     0             SOWLN#
     C                   MOVE      *BLANKS       LCANCL
     C                   MOVEL     'SINGLABL'    LFORM
     C                   Z-ADD     1             LCOPY
     C                   MOVEL     'N'           LJOBQ
     C                   MOVEL     '*NO'         LHOLD
     C                   MOVEL     '*NO'         LSAVE
     C     USERID        IFEQ      'LINE01'
     C     USERID        OREQ      'EFD   '
     C     LWSID         IFNE      'DSP02'
     C                   WRITE     SCRNE
     C                   READ      SCRNE                                  90
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   END
     C                   Z-ADD     1             SOWLN#
     C                   MOVEL     'LINE1PRT'    LPRTR
     C                   END
     C     USERID        IFEQ      'LINE02'
     C                   Z-ADD     2             SOWLN#
     C                   END
     C     USERID        IFEQ      'LINE03'
     C                   Z-ADD     3             SOWLN#
     C                   END
     C     SOWLN#        IFLE      0
     C                   WRITE     SCRNE
     C                   READ      SCRNE                                  90
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   END
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
