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
      *PROGRAM NAME-------- GLRSTY
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- GET INFO FOR LAST YEAR FILES
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FGLRLSTFM  CF   E             WORKSTN
     FFGLCTL    IF   E           K DISK
     FFGLCLOS   IF   E           K DISK
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
     D  LCO                    1      2  0                                      GLR360
     D  LLIBR                 10     18
     D  LCANCL               133    133
      *
      *
     C                   MOVE      *BLANKS       LCANCL
     C                   MOVE      *BLANKS       LLIBR
     C     LCO           CHAIN     FGLCTL                             90
     C  N90LCO           CHAIN     FGLCLOS                            90
     C  N90              DO
     C     GZPRYN        IFNE      'Y'
     C                   SETON                                        90
     C                   END
     C     GZLIBR        IFLE      *BLANKS
     C                   SETON                                        90
     C                   END
     C  N90              MOVEL     GZLIBR        LLIBR
     C                   ENDDO
     C   90              DO
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
     C                   MOVE      'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
      *
     C     END           TAG
     C                   SETON                                        LR
      **
