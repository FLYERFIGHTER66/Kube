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
      **PROGRAM NAME-------- PSR125
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- PRINT UN-PRINTED ITEM LOCATIONS
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  3/22/02 EFD DO NOT PRINT READY BAY ORDERS.
      *
     FFPUTORDA  IF   E           K DISK
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
     D  RUNST                  1      1
     D  STRDAT                 4     10  0
     D  PLDATE                11     16  0
     D  ITEM                  17     28
     D  SIZE                  29     31
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  VOUT                 131    131  0
     D  LCANCL               133    133
      ***********************
      ** START HERE        **
      ***********************
     C     LOCKEY        KLIST
     C                   KFLD                    STRDAT
     C     LOCKEY        SETLL     FPUTORDA
     C     NXT           TAG
     C     LOCKEY        READE     FPUTORDA                               90
     C   90              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C     PDPRTD        IFEQ      'Y'
     C     PDRDYB        OREQ      'Y'
     C                   GOTO      NXT
     C                   END
     C                   MOVEL     PDITEM        ITEM
     C                   MOVEL     PDSIZE        SIZE
      ** END PROG
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
