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
      *PROGRAM NAME--------- APC998
      *SYSTEM--------------- ACCOUNTS PAYABLE
      *APPLICATION---------- GLOBAL PROMPT FOR COMPANY NUMBER
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFAPCTL    IF   E           K DISK
     FAPC998FM  CF   E             WORKSTN
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
     D  LGL                    3      3
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
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     0             COMP              2 0
     C     COMP          CHAIN     FAPCTL                             90
     C                   Z-ADD     AZPRCO        LCO
     C     AZNMCO        IFEQ      1
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
     C     LCO           CHAIN     FAPCTL                             90
     C   90              SETON                                        10
     C   10              GOTO      RSTRT
      *
     C     LPROG         IFEQ      'APC080  '
     C                   MOVEL     'LABL'        LFORM
     C                   MOVEL     AZPRTR        LPRTR
     C                   GOTO      END
     C                   ENDIF
     C     LPROG         IFEQ      'APC330  '
     C                   MOVEL     'APCK'        LFORM
     C                   MOVEL     AZPRTC        LPRTR
     C                   GOTO      END
     C                   ENDIF
     C     LPROG         IFEQ      'APC550  '
     C                   MOVEL     '*NAR'        LFORM
     C                   MOVEL     AZPRTC        LPRTR
     C                   MOVEL     '*NO'         LHOLD
     C                   MOVEL     '*NO'         LSAVE
     C                   GOTO      END
     C                   ENDIF
     C                   MOVEL     '*NAR'        LFORM
     C                   MOVEL     AZPRTR        LPRTR
      *
     C     END           TAG
     C                   Z-ADD     01            LCOPY
     C                   MOVEL     'N'           LJOBQ
     C                   SETON                                        LR
      *
