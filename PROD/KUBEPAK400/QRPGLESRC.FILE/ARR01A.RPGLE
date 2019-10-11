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
      *PROGRAM NAME-------- ARR01A
      *SYSTEM-------------- MASTER FILES
      *DESCRIPTION--------- UPDATE AROPN WITH NEW CUSTOMER ALPHA
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFAROPN    UF   E           K DISK
     FFMCUST    IF   E           K DISK
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
      *
     C     NXT           TAG
     C                   READ      FAROPN                                 90
     C   90              GOTO      END
      *
     C     ARCUST        CHAIN     FMCUST                             92
     C   92              GOTO      NXT
      *
     C     ARLOOK        IFEQ      CMLOOK
     C                   GOTO      NXT
     C                   ENDIF
      *
     C                   MOVEL     CMLOOK        ARLOOK
     C                   UPDATE    RAROPN
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   SETON                                        LR
      **                                                               ***@DT@B2
