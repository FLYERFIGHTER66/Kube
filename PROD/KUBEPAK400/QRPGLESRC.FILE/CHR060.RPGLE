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
      **PROGRAM NAME-------- CHR060
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- C.BUCK
      **APPLICATION--------- SERIES MASTER MAINTAINENCE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FCHR060FM  CF   E             WORKSTN
     FFMINVT    IF   E           K DISK
     FFCHMAPPR  UF   E           K DISK
     FFCHMTOT4  IF   E           K DISK
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
     C     APPKEY        KLIST
     C                   KFLD                    CAITEM
     C                   KFLD                    CAPPM
     C                   KFLD                    CASPRY
     C**
     C     TOTKEY        KLIST
     C                   KFLD                    CTSPIT
     C                   KFLD                    CTPPM
     C                   KFLD                    CTSPRY
      ***********************
      ** START HERE        **
      ***********************
     C     RSTART        TAG
     C                   MOVEA     '0'           *IN
     C                   UNLOCK    FCHMAPPR
     C                   CLEAR                   RCHMAPP
     C                   MOVE      *BLANKS       SPRAY
     C                   MOVE      *BLANKS       ITEM
     C                   MOVE      *ZEROS        PPM
     C                   MOVE      *BLANKS       APP1
     C                   MOVE      *BLANKS       APP2
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
     C     ACTION        IFNE      'A'
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
     C                   CALL      'LKNAME'
     C                   PARM                    CAITEM
     C                   PARM                    CAPPM
     C                   PARM                    CASPRY
     C                   MOVEL     CASPRY        SPRAY             5
     C                   MOVEL     CAITEM        ITEM              8
     C                   MOVEL     CAPPM         PPM               7 2
     C                   GOTO      NXTA
     C                   END
     C*
     C     PASS          TAG
     C**
     C                   MOVE      '700'         SPSIZE            3
     C     APPKEY        CHAIN     FCHMAPPR                           91
     C                   MOVE      CAPPM         PPM
     C                   MOVE      CAITEM        ITEM
     C                   MOVE      CASPRY        SPRAY
     C                   MOVE      CAAPP1        APP1
     C                   MOVE      CAAPP2        APP2
     C**
     C                   MOVE      *ZEROS        GALS
     C                   MOVEL     CAITEM        CTSPIT
     C                   MOVE      CAPPM         CTPPM
     C                   MOVEL     CASPRY        CTSPRY
     C     TOTKEY        CHAIN     FCHMTOT4                           98
     C     *IN98         IFEQ      *OFF
     C                   MOVEL     CTGALS        GALS              5 2
     C                   END
     C**
     C                   MOVEL     ITEM          IMITEM
     C                   MOVEL     SPSIZE        IMSIZE
     C     INVKEY        CHAIN     FMINVT                             92
     C                   MOVEL     IMDES1        DESC             10
     C*
     C     ACTION        IFEQ      'A'
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
     C                   SETOFF                                         2399
     C**
      ** CHECK FOR BLANK 1ST. APPLICATOR
     C**
     C     APP1          IFLE      *BLANKS
     C     APP2          ANDNE     *BLANKS
     C                   SETON                                        23
     C                   GOTO      NXTB
     C                   END
     C**
      ** CHANGE RECORD AND UPDATE RECORD
      ** CHECK APPLICATOR
     C**
     C     ACTION        IFEQ      'A'
     C     *IN91         IFEQ      *OFF
     C**
     C                   MOVEL     APP1          CAAPP1
     C                   MOVEL     APP2          CAAPP2
     C                   MOVE      TDATE         CADTLA
     C                   UPDATE    RCHMAPP
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
