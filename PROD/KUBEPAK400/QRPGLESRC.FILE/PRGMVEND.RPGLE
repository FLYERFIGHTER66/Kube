      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2000
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
      *PROGRAM NAME-------- PRGMVEND
      *SYSTEM-------------- MASTER FILES
      *APPLICATION--------- PURGE DELETED RECORDS FROM MVEND & VENDCM
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMVEND    UF   E           K DISK
     FFVENDCM   UF   E           K DISK
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
      *
     D                UDS
     D  LCO                    1      2  0                                      ARC380
      *****************
      ** READ FMVEND **
      *****************
     C     NXT           TAG
     C                   READ      FMVEND                                 90
     C   90              GOTO      END
      *
     C     VMSTAT        IFNE      'D'
     C     VMCONM        ORNE      LCO
     C                   GOTO      NXT
     C                   END
      *
      * GET VENDCM RECORD
      *
     C     VENKEY        KLIST
     C                   KFLD                    VMVEND
     C     VENKEY        CHAIN     FVENDCM                            71
     C  N71              DELETE    RVENDCM
      *
      * DELETE FMVEND REC
      *
     C                   DELETE    RMVEND
     C                   GOTO      NXT
      *
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
