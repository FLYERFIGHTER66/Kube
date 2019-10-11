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
      **PROGRAM NAME-------- ALFD1
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CALCULATE ALOCATIONS TO LOTS
      *           NOTE: FIRST PASS USING ALREADY ALLOCATED FALITEM RECS
      *
      * CHANGE--DATE-------DESCRIPTION
      * 3/27/98 EFD ADD LOGIC FOR CUST 4496(TXP)
      *
     FFALITEMN  IF   E           K DISK
     FFDLOTIRD  UF   E           K DISK
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
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LDAPTO                 1      1  0                                      ARC380
      *
      ***********************
      * READ FALITEM RECS   *
      ***********************
     C                   SETON                                        55
     C     NXTAL         TAG
     C                   READ      FALITEMN                               96
     C   96              GOTO      ENDAL
     C     AIITEM        IFNE      LRITEM
     C     AISIZE        ORNE      LRSIZE
     C     AISHPD        ORNE      LRCRDY
     C     AIGLOC        ORNE      LRGLOC
     C     AICUST        ORNE      LRCUST
     C  N55              DO
      ** 3/27/98
     C     LRCUST        IFEQ      4496
     C                   SUB       LRQTSL        LRQTAL
     C                   END
     C     LRQTOH        SUB       LRQTAL        LRQTAV
     C                   UPDATE    RDLOTRD
     C                   ENDDO
     C                   MOVEL     AIITEM        LRITEM
     C                   MOVEL     AISIZE        LRSIZE
     C                   Z-ADD     AISHPD        LRCRDY
     C                   MOVEL     AIGLOC        LRGLOC
     C                   Z-ADD     AICUST        LRCUST
     C     LTKEY         KLIST
     C                   KFLD                    LRITEM
     C                   KFLD                    LRSIZE
     C                   KFLD                    LRCUST
     C                   KFLD                    LRCRDY
     C     LTKEY         CHAIN     FDLOTIRD                           55
     C                   Z-ADD     0             LRQTAL
     C                   ENDIF
     C                   ADD       AIQTOA        LRQTAL
     C                   GOTO      NXTAL
     C     ENDAL         TAG
     C  N55              DO
      ** 3/27/98
     C     LRCUST        IFEQ      4496
     C                   SUB       LRQTSL        LRQTAL
     C                   END
     C     LRQTOH        SUB       LRQTAL        LRQTAV
     C                   UPDATE    RDLOTRD
     C                   ENDDO
     C     END           TAG
     C                   SETON                                        LR
      ***********************
