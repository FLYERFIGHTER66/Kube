      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1997
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
      **PROGRAM NAME-------- BIR900
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- REBUILD VALUE OF OPEN ORDERS (NON-LOT) IN
      *                      MINVT,
      *            CHANGE--DATE-------DESCRIPTION
      *  3/07/02 EFD ADD CHECK LOTC FLAG FOR SIZE CODE.
      *
     FFIORDISC  IF   E           K DISK
     FFIORDR    IF   E           K DISK
     F                                     RENAME(RIORDR:IORDR)
     FFIORASTN  IF   E           K DISK
     FFMINVT    UF   E           K DISK
      *
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ***********************
      ** CLEAR NON STOCK   **
      ***********************
     C                   MOVE      *BLANKS       IMITEM
     C                   MOVE      *BLANKS       IMSIZE
     C                   MOVE      *BLANKS       IMWHSE
     C     MINKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    IMWHSE
     C     MINKEY        SETLL     FMINVT
     C     NXTCLR        TAG
     C                   READ      FMINVT                                 90
     C   90              GOTO      END
     C     IMSIZE        IFEQ      '512'
     C     IMSIZE        OREQ      '288'
     C     IMSIZE        OREQ      '162'
     C     IMSIZE        OREQ      '84 '
     C                   MOVEL     'Y'           IMLOTC
     C                   Z-ADD     0             IMQTAL
     C                   Z-ADD     0             IMALC2
     C                   Z-ADD     0             IMALC3
     C                   UPDATE    RMINVT
     C                   GOTO      NXTCLR
     C                   END
     C     IMLOTC        IFEQ      'Y'
     C                   Z-ADD     0             IMQTAL
     C                   Z-ADD     0             IMALC2
     C                   Z-ADD     0             IMALC3
     C                   UPDATE    RMINVT
     C                   GOTO      NXTCLR
     C                   END
     C                   Z-ADD     0             IMQTAL
     C                   Z-ADD     0             IMALC2
     C                   Z-ADD     0             IMALC3
     C                   EXSR      GETORD
     C                   EXSR      GETAST
     C     IMQTOH        SUB       IMQTAL        IMQTAV
     C     IMQ2OH        SUB       IMALC2        IMQTA2
     C     IMQ3OH        SUB       IMALC3        IMQTA3
     C                   UPDATE    RMINVT
     C                   GOTO      NXTCLR
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** GET OPEN ORDERS   **
      ***********************
     C     GETORD        BEGSR
     C     ITMKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C     ITMKEY        SETLL     FIORDISC
     C     NXTORD        TAG
     C     ITMKEY        READE     RIORDR                                 91
     C   91              GOTO      ENDORD
     C     OIWHSE        IFNE      IMWHSE
     C     OISTAT        ORNE      'A'
     C     OIQSHP        ORGE      OIQORD
     C                   GOTO      NXTORD
     C                   END
     C     OIQORD        SUB       OIQSHP        OPEN             11 1
     C     OIUUOM        IFEQ      IMPUOM
     C                   ADD       OPEN          IMQTAL
     C                   END
     C     OIUUOM        IFEQ      IMSUOM
     C                   ADD       OPEN          IMALC2
     C                   END
     C     OIUUOM        IFEQ      IM3UOM
     C                   ADD       OPEN          IMALC3
     C                   END
     C                   GOTO      NXTORD
     C     ENDORD        ENDSR
      ***********************
      ** GET ASSORTMENTS   **
      ***********************
     C     GETAST        BEGSR
     C     ITMKEY        SETLL     FIORASTN
     C     NXTAST        TAG
     C     ITMKEY        READE     RIORAST                                91
     C   91              GOTO      ENDAST
     C     IAWHSE        IFNE      IMWHSE
     C     IASTAT        ORNE      'A'
     C     IAQSHP        ORGE      IAQORD
     C                   GOTO      NXTAST
     C                   END
     C     IORKEY        KLIST
     C                   KFLD                    IAORD#
     C                   KFLD                    IAPSEQ
     C     IORKEY        CHAIN     FIORDR                             93
     C  N93              DO
     C     OISTAT        IFEQ      'D'
     C     OIQORD        ORLE      OIQSHP
     C                   SETON                                        93
     C                   END
     C                   ENDDO
     C   93              GOTO      NXTAST
     C     IAQORD        SUB       IAQSHP        OPEN             11 1
     C     IAUUOM        IFEQ      IMPUOM
     C                   ADD       OPEN          IMQTAL
     C                   END
     C     IAUUOM        IFEQ      IMSUOM
     C                   ADD       OPEN          IMALC2
     C                   END
     C     IAUUOM        IFEQ      IM3UOM
     C                   ADD       OPEN          IMALC3
     C                   END
     C                   GOTO      NXTAST
     C     ENDAST        ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
