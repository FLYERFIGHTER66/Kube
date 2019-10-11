      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2002
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
      **PROGRAM NAME-------- PSR195
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- BUILD WEEKLY PLUG LOCATION FILE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFCALEN    IF   E           K DISK
     FNPUTORDS  IF   E           K DISK
     FNPTORDC   UF A E           K DISK
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
     D  PLDATE                11     16  0
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  RPRTR                134    143
      ***********************
      ** START HERE        **
      ***********************
     C     PLDATE        CHAIN     FCALEN                             90
     C                   Z-ADD     CLCYMD        WKCYMD            7 0
     C     WKCYMD        SETLL     NPUTORDS
     C                   Z-ADD     0             CONT              5 0
     C     NXT           TAG
     C     WKCYMD        READE     NPUTORDS                               91
     C   91              GOTO      END
     C     PDITEM        IFEQ      PTITEM
     C     PDSIZE        ANDEQ     PTSIZE
     C                   GOTO      NXT
     C                   END
     C     PTOKEY        KLIST
     C                   KFLD                    PDSHPD
     C                   KFLD                    PDMSTR
     C                   KFLD                    PDITEM
     C                   KFLD                    PDSIZE
     C     PTOKEY        CHAIN     NPTORDC                            55
     C   55              DO
     C                   CLEAR                   RPTORDC
     C                   Z-ADD     PDSHPD        PTSHPD
     C                   Z-ADD     PDMSTR        PTMSTR
     C                   MOVEL     PDITEM        PTITEM
     C                   MOVEL     PDSIZE        PTSIZE
     C                   MOVEL     PDLOOK        PTLOOK
     C                   ENDDO                                                  55  DO
     C                   ADD       1             CONT
     C                   Z-ADD     CONT          PTCNTR
     C   55              WRITE     RPTORDC
     C  N55              UPDATE    RPTORDC
     C                   GOTO      NXT
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
