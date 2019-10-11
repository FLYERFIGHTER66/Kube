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
      **PROGRAM NAME-------- PSR700
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- DELETE WEEKS RECORDS FROM LOCATION FILE.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  3/28/02 EFD ADD ORDER WORK FILE
      *  4/04/02 EFD ADD PUT DOWN CONTROL FILE
      *
     FNPUTORDI  UF   E           K DISK
     FNCARTCS   UF   E           K DISK
     FNWKORDS   UF   E           K DISK
     FNPTORDC   UF   E           K DISK
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
     D  STRDAT                 4     10  0
     D  PLDATE                11     16  0
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  RPRTR                134    143
     D  LMASTER              144    145  0
      ***********************
      ** CLEAR PUTORD      **
      ***********************
     C     DateMstr      KList
     C                   KFld                    STRDAT
     C                   KFld                    LMASTER
     C*    STRDAT        SETLL     NPUTORDI
     C     DateMstr      SETLL     NPUTORDI
     C     NXT           TAG
     C*    STRDAT        READE     NPUTORDI                               90
     C     DateMstr      READE     NPUTORDI                               90
     C   90              GOTO      ENDORD
      ** JUST DELETE RECORDS FILE IS REORGANIZED AT NIGHT.
     C                   DELETE    RPUTORD
     C                   GOTO      NXT
      ***********************
      ** CLEAR CARTS       **
      ***********************
     C     ENDORD        TAG
      ** CAN NOT USE STRDATE AS CARTS HAVE ITEM READY DATE IN SHPDATE
     C     NXTCRT        TAG
      ** JUST DELETE RECORDS FILE IS REORGANIZED AT NIGHT.
     C     DateMstr      SetLL     NCARTCS
     C     DateMstr      ReadE     NCARTCS
     C                   DoW       not %EOF(NCARTCS)
     C                   DELETE    RCART
     C     DateMstr      ReadE     NCARTCS
     C                   EndDo
      ***********************
      ** CLEAR ORDER WORK  **
      ***********************
     C     ENDCRT        TAG
     C*    STRDAT        SETLL     NWKORDS
     C     DateMstr      SETLL     NWKORDS
     C     NXTOWK        TAG
     C*    STRDAT        READE     NWKORDS                                90
     C     DateMstr      READE     NWKORDS                                90
     C   90              GOTO      ENDOWK
      ** JUST DELETE RECORDS FILE IS REORGANIZED AT NIGHT.
     C                   DELETE    RWKORD
     C                   GOTO      NXTOWK
     C     ENDOWK        TAG
      ***********************
      ** CLEAR ORDER WORK  **
      ***********************
     C*    STRDAT        SETLL     NPTORDC
     C     DateMstr      SETLL     NPTORDC
     C     NXTPTC        TAG
     C*    STRDAT        READE     NPTORDC                                90
     C     DateMstr      READE     NPTORDC                                90
     C   90              GOTO      ENDPTC
      ** JUST DELETE RECORDS FILE IS REORGANIZED AT NIGHT.
     C                   DELETE    RPTORDC
     C                   GOTO      NXTPTC
     C     ENDPTC        TAG
      *** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
