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
      **PROGRAM NAME-------- COUNT
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- COUNT NUMBER OF ITEM NUMBERS
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FCOUNTFM   CF   E             WORKSTN
     FFMINVT    IF   E           K DISK
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
      * START HERE   *
      ****************
     C                   MOVE      *BLANKS       PCOK              1
     C     NXT           TAG
     C                   READ      FMINVT                                 90
     C   90              GOTO      END
     C     IMSTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   END
     C     IMITEM        IFNE      OITEM
     C     PCOK          ANDEQ     'Y'
     C                   ADD       1             TOTAL
     C                   MOVE      *BLANKS       PCOK              1
     C                   MOVEL     IMITEM        OITEM            12
     C                   END
     C     IMPCL1        IFGE      '50'
     C     IMPCL1        ANDLE     '60'
     C                   MOVEL     'Y'           PCOK
     C                   END
     C                   GOTO      NXT
     C     END           TAG
     C     PCOK          IFEQ      'Y'
     C                   ADD       1             TOTAL
     C                   END
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C                   SETON                                        LR
