      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2001
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
      **PROGRAM NAME-------- SDR900
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- MOVE VENDOR PRICES TO HISTORY AND ZERO
      *                      PRICES IF SELECTED.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFSERPRC   UF   E           K DISK
     F                                     RENAME(RSERPRC:SERPRC)
     FFSERPRH   UF A E           K DISK
     FFSERIES   IF   E           K DISK
     F                                     RENAME(RSERIES:SERIES)
     FFSERIEO   UF A E           K DISK
      *
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
     D  LCO                    1      2  0                                      ARC380
      ** YEAR  IE 2001
     D  YEAR                   3      6  0
      ** VENDOR NUMBER
     D  VEND                   7     12  0
      ** CLEAR RECORDS Y/N
     D  SHOWAL                13     13
      ** CANCEL
     D  LCANCL               133    133
      *****************
      ** START HERE  **
      *****************
     C     VEND          IFEQ      999999
     C                   Z-ADD     0             VENDI             6 0
     C                   SETOFF                                       33
     C                   ELSE
     C                   Z-ADD     VEND          VENDI             6 0
     C                   SETON                                        33
     C                   END
     C     VENDI         SETLL     FSERPRC
     C     NXT           TAG
      ** 33 ON VENDOR SELECTED
     C   33VENDI         READE     FSERPRC                                90
     C  N33              READ      FSERPRC                                90
     C   90              GOTO      ENDPRC
     C     HSTKEY        KLIST
     C                   KFLD                    SPVEND
     C                   KFLD                    SPCODE
     C     HSTKEY        CHAIN     FSERPRH                            91
      ** ONLY ADD RECORDS DO NOT REPLACE PER BILL 6/26/01
     C   91              DO
     C                   Z-ADD     TIMOD         SPTIME
     C                   Z-ADD     TDATE         SPDTLA
     C                   MOVEL     USERID        SPUSER
     C                   WRITE     RSERPRC
     C                   ENDDO
     C     SHOWAL        IFEQ      'Y'
     C                   Z-ADD     0             SPPRC1
     C                   Z-ADD     0             SPPRC2
     C                   Z-ADD     0             SPPRC3
     C                   Z-ADD     0             SPPRO1
     C                   Z-ADD     0             SPPRO2
     C                   Z-ADD     0             SPPRO3
     C                   UPDATE    SERPRC
     C                   END
     C                   GOTO      NXT
      ** END SERPRC
     C     ENDPRC        TAG
     C                   MOVE      *BLANKS       SECODE
     C     SECODE        SETLL     FSERIES
     C     NXTSER        TAG
     C                   READ      FSERIES                                90
     C   90              GOTO      END
     C     SECODE        CHAIN     FSERIEO                            81
     C   81              WRITE     RSERIES
     C                   GOTO      NXTSER
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
