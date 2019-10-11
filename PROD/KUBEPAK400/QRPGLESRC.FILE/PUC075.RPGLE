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
      **PROGRAM NAME-------- PUC075
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CHANGE TRUCK NUMBER IN SCHEDULE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FPUC075FM  CF   E             WORKSTN
     FPURHDR    UF   F   64    10AIDISK    KEYLOC(1)                            QPK500
     FPURSCH    UF   F   64    12AIDISK    KEYLOC(1)                            QPK500
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
      *
      *
     IPURHDR    NS
     I*    TRUCK #
     I                                  1    4  TRTRK#
     I*    SHIP DATE   YYMMDD
     I                                  5   10 0TRSHDT
     I*  DRIVER
     I                                 11   16  TRDRIV
     I* TIME OF FIRST STOP
     I                                 17   26  TRSTOP
      *
     IPURSCH    NS
     I*    TRUCK #
     I                                  1    4  TRTRK#
     I*    SHIP DATE   YYMMDD
     I                                  5   10 0TRSHDT
     I*    SEQ #
     I                                 11   12 0TRSEQ
     I*    CUST #
     I                                 13   18 0TRCUST
     I*    QUANTITY 1
     I                                 19   22 0TRQTY1
     I*    QUANTITY 2
     I                                 23   26 0TRQTY2
     I*    QUANTITY 3
     I                                 27   30 0TRQTY3
     I*    QUANTITY 4
     I                                 31   34 0TRQTY4
     I*    QUANTITY 5
     I                                 35   38 0TRQTY5
     I*    QUANTITY 6
     I                                 39   42 0TRQTY6
     I* NEW SEQUENCE NUMBER
     I                                 43   44 0TRNSEQ
      ***********************
      ** START HERE        **
      ***********************
     C     RSTART        TAG
     C                   CLEAR                   *IN
     C                   MOVE      *BLANKS       OTRK
     C                   MOVE      *BLANKS       NTRK
     C                   MOVE      *BLANKS       OTRKO             4
     C                   MOVE      *BLANKS       NTRKO             4
     C                   Z-ADD     0             SHPD
     C                   Z-ADD     0             SHPDO             6 0
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C                   SETOFF                                       102030
     C                   SETOFF                                       3132
     C                   SETOFF                                       99
      ** CHECK FIELDS
     C                   Z-ADD     SHPD          ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        1099
     C                   GOTO      NXTA
     C                   END
     C                   MOVE      ##CYMD        TRKKEY           10
     C                   MOVE      ##CYMD        SHPDAT            6 0
      ** OLD TRUCK
     C     OTRK          IFLE      *BLANKS
     C                   SETON                                        202199
     C                   GOTO      NXTA
     C                   END
      ** SEE IF EXISTS
     C                   MOVEL     OTRK          TRKKEY
     C     TRKKEY        CHAIN     PURHDR                             22
     C   22              DO
     C                   SETON                                        20  99
     C                   GOTO      NXTA
     C                   ENDDO
      ** NEW TRUCK
     C     NTRK          IFLE      *BLANKS
     C                   SETON                                        303199
     C                   GOTO      NXTA
     C                   END
      ** SEE IF EXISTS
     C                   MOVEL     NTRK          TRKKEY
     C     TRKKEY        CHAIN     PURHDR                             22
     C  N22              DO
     C                   SETON                                        30  99
     C                   GOTO      NXTA
     C                   ENDDO
      ** IF HERE ALL OK
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTA
     C                   ENDDO
      ** IF 98 AND F2 UPDATE RECORDS
     C   98
     CAN KB              DO
     C                   EXSR      UPDAT
     C                   GOTO      RSTART
     C                   ENDDO
     C                   GOTO      NXTA
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** UPDATE FILES      **
      ***********************
     C     UPDAT         BEGSR
     C                   MOVEL     OTRK          TRKKEY
     C     TRKKEY        CHAIN     PURHDR                             22
     C  N22              EXCEPT    UPHDR
      ** NOW GET SCHEDULE
     C                   MOVEL     TRKKEY        TSCKEY           12
     C     TSCKEY        SETLL     PURSCH
     C     NXTSCH        TAG
     C                   READ      PURSCH                                 90
     C   90              GOTO      ENDSCH
     C     TRTRK#        IFEQ      OTRK
     C     TRSHDT        ANDEQ     SHPDAT
     C                   EXCEPT    UPSCH
     C                   GOTO      NXTSCH
     C                   END
     C     ENDSCH        ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
      ***********************
      * FILE OUTPUTS        *
      ***********************
     OPURHDR    E            UPHDR
     O                       NTRK                 4
     OPURSCH    E            UPSCH
     O                       NTRK                 4
