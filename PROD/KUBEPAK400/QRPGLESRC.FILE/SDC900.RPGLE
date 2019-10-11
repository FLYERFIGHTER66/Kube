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
      **PROGRAM NAME-------- SDC900
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- VENDOR/SERIES X-REF MOVE TO HISTORY PROMPT
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMVEND    IF   E           K DISK
     FSDC900FM  CF   E             WORKSTN
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
      ** COMPANY
     D  LCO                    1      2  0                                      ARC380
      ** YEAR  IE 2001
     D  YEAR                   3      6  0
      ** VENDOR NUMBER
     D  VEND                   7     12  0
      ** CLEAR RECORDS Y/N
     D  SHOWAL                13     13
      ** HISTORY FILE NAME SERPRC
     D  FILENM                14     21
      ** HISTORY FILE NAME SERIES
     D  FILENS                22     29
      ** CANCEL
     D  LCANCL               133    133
      ***********************
      ** START HERE        **
      ***********************
     C     RSTART        TAG
     C                   Z-ADD     0             VEND
     C                   Z-ADD     0             YEAR
     C                   MOVE      *BLANKS       ALPHA
     C                   MOVE      *BLANKS       SHOWAL
     C                   MOVE      *BLANKS       LCANCL
     C                   SETOFF                                       1020
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C   KF              GOTO      RSTART
     C                   SETOFF                                       051020
      ** CHECK YEAR
     C     YEAR          IFLE      1999
     C     YEAR          ORGT      2020
     C                   SETON                                        05
     C                   GOTO      NXTA
     C                   ENDIF
      ** CHECK VENDOR
     C     VEND          IFLE      0
     C     ALPHA         ANDLE     *BLANKS
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDIF
     C     VEND          IFLE      0
     C     ALPHA         ANDGT     *BLANKS
     C                   MOVEL     ALPHA         VMLOOK
     C                   CALL      'LKVENDOR'
     C                   PARM                    VMLOOK
     C                   PARM                    VMCOMP            2 0
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C                   MOVEL     *BLANKS       ALPHA
     C                   MOVEL     *BLANKS       VMLOOK
     C                   Z-ADD     VMVEND        VEND
     C                   GOTO      NXTA
     C                   ENDIF
     C     VEND          IFLT      999999
     C     VEND          CHAIN     FMVEND                             10
     C   10              GOTO      NXTA
     C                   END
      ** CHECK SHOWAL  PURGE RECORDS
     C     SHOWAL        IFNE      'Y'
     C     SHOWAL        ANDNE     'N'
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
      ** IF HERE SCRNA OK
     C                   MOVEL     'FSPC'        FILENM
     C                   MOVE      YEAR          FILENM
     C                   MOVEL     'FSER'        FILENS
     C                   MOVE      YEAR          FILENS
      ** END
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
