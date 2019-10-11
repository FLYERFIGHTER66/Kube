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
      **PROGRAM NAME-------- FCR070
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- C.BUCK
      **APPLICATION--------- SERIES MASTER MAINTAINENCE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFCR070FM  CF   E             WORKSTN
     FFFCMSPY   UF   E           K DISK
     FFMINVT    IF   E           K DISK
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
     I**                                      1   20LCO                   ARC380
     C**
     C**     KEYS
     C**
     C     INVKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C**
     C     SPYKEY        KLIST
     C                   KFLD                    CSITEM
     C                   KFLD                    CSSIZE
     C                   KFLD                    CSPPM
     C**
      ***********************
      ** START HERE        **
      ***********************
     C     RSTART        TAG
     C                   MOVEA     '0'           *IN
     C                   UNLOCK    FFCMSPY
     C                   CLEAR                   RCHMSPY
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *ZEROS        PPM
     C                   MOVE      *ZEROS        POLES
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK FKEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C                   SETOFF                                       1020
     C                   SETOFF                                       212223
      ** CHECK ACTION
     C     ACTION        IFNE      'C'
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   END
     C**
     C     PPM           IFNE      *ZEROS
     C                   GOTO      PASS
     C                   END
     C**
      ** CHECK ITEM
     C     ITEM          IFEQ      ' '
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   END
     C**
     C     ITEM          IFNE      '?'
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   END
     C**
     C                   MOVEL     ITEM          TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   CALL      'LKSPRY'
     C                   PARM                    CSITEM
     C                   PARM                    CSPPM
     C                   MOVEL     CSITEM        ITEM              8
     C                   MOVE      CSPPM         PPM               7 2
     C                   GOTO      NXTA
     C                   END
     C*
     C     PASS          TAG
     C**
     C                   MOVE      '700'         SPSIZE            3
     C                   MOVE      ITEM          CSITEM
     C                   MOVE      '700'         CSSIZE
     C                   MOVE      PPM           CSPPM
     C     SPYKEY        CHAIN     FFCMSPY                            91
     C                   MOVE      CSPPM         PPM
     C                   MOVE      CSITEM        ITEM
     C**
     C                   MOVEL     ITEM          IMITEM
     C                   MOVEL     SPSIZE        IMSIZE
     C     INVKEY        CHAIN     FMINVT                             92
     C                   MOVEL     IMDES1        DESC             30
     C*
     C     ACTION        IFEQ      'C'
     C     *IN91         IFEQ      *OFF
     C                   GOTO      NXTB
     C                   END
     C                   END
     C***
      *** SCREEN B
     C     NXTB          TAG
     C*
     C   99              SETOFF                                       98
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
      ** CHECK FKEYS
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTART
     C                   SETOFF                                       102030
     C                   SETOFF                                           99
      ** CHECK ITEM
     C     ITEM          IFLE      *BLANKS
     C                   SETON                                        1099
     C                   GOTO      NXTA
     C                   END
     C**
      ** CHANGE RECORD AND UPDATE RECORD
      ** CHECK NUMBER
     C**
     C     POLES         IFEQ      *ZEROS
     C                   SETON                                        23
     C                   GOTO      NXTB
     C                   END
     C**
     C     ACTION        IFEQ      'C'
     C     *IN91         IFEQ      *OFF
     C                   MOVEL     POLES         CSXPL
     C                   MOVE      TDATE         CSDTLA
     C                   UPDATE    RCHMSPY
     C                   END
     C                   END
     C**
     C                   GOTO      RSTART
     C**
      ** END PROGRAM
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
