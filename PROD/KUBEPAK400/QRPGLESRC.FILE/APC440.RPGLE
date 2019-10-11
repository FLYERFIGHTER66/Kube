      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
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
      *PROGRAM NAME--------- APC440
      *SYSTEM--------------- ACCOUNTS PAYABLE
      *APPLICATION---------- START UP POST TO FAPOPN
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFAPCTL    IF   E           K DISK
     FAPC440FM  CF   E             WORKSTN
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
      *
     D                UDS
     D  LCO                    1      2  0
     D  LCANCL               133    133
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     0             COMP              2 0
     C     COMP          CHAIN     FAPCTL                             90
     C                   Z-ADD     AZPRCO        LCO
      *
     C     RSTRT         TAG
     C                   WRITE     SCRNA
     C                   Z-ADD     0             CNT               2 0
     C                   SETOFF                                       101112
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              MOVE      'X'           LCANCL            1
     C   KC
     COR KG              GOTO      END
      *
     C     LCO           IFEQ      *ZEROS
     C                   SETON                                        1011
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     LCO           CHAIN     FAPCTL                             90
     C   90              SETON                                        1011
     C   10              GOTO      RSTRT
      *
     C     AZOKSU        IFNE      'Y'
     C                   SETON                                        1012
     C                   GOTO      RSTRT
     C                   ENDIF
      *
     C     END           TAG
     C                   SETON                                        LR
      *
