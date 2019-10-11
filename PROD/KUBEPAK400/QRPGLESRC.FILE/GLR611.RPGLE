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
      *PROGRAM NAME-------- GLR611
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- ROLL YEARLY BALANCES
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFMGLCH    IF   E           K DISK
     FFGLBAL    UF   E           K DISK
     FFGLBALT   UF   E           K DISK
     FFGLBALS   UF   E           K DISK
      *
      *
      * GLBAL  ARRAY IN
     D GLP             S             11  2 DIM(13)
     D GLN             S             11  2 DIM(13)
      * GLBALT ARRAY IN
     D GBP             S             11  2 DIM(13)
     D GBN             S             11  2 DIM(13)
      * GLBALS ARRAY IN
     D GSP             S             11  2 DIM(13)
     D GSN             S             11  2 DIM(13)
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
     D                UDS
     D  LCO                    1      2  0
     D  LACTP                  3      4  0
      *
     IRGLBAL
     I              GLT01                       GLP(1)
     I              GLT02                       GLP(2)
     I              GLT03                       GLP(3)
     I              GLT04                       GLP(4)
     I              GLT05                       GLP(5)
     I              GLT06                       GLP(6)
     I              GLT07                       GLP(7)
     I              GLT08                       GLP(8)
     I              GLT09                       GLP(9)
     I              GLT10                       GLP(10)
     I              GLT11                       GLP(11)
     I              GLT12                       GLP(12)
     I              GLT13                       GLP(13)
     I              GLL01                       GLN(1)
     I              GLL02                       GLN(2)
     I              GLL03                       GLN(3)
     I              GLL04                       GLN(4)
     I              GLL05                       GLN(5)
     I              GLL06                       GLN(6)
     I              GLL07                       GLN(7)
     I              GLL08                       GLN(8)
     I              GLL09                       GLN(9)
     I              GLL10                       GLN(10)
     I              GLL11                       GLN(11)
     I              GLL12                       GLN(12)
     I              GLL13                       GLN(13)
      *
     IRGLBALT
     I              GBT01                       GBP(1)
     I              GBT02                       GBP(2)
     I              GBT03                       GBP(3)
     I              GBT04                       GBP(4)
     I              GBT05                       GBP(5)
     I              GBT06                       GBP(6)
     I              GBT07                       GBP(7)
     I              GBT08                       GBP(8)
     I              GBT09                       GBP(9)
     I              GBT10                       GBP(10)
     I              GBT11                       GBP(11)
     I              GBT12                       GBP(12)
     I              GBT13                       GBP(13)
     I              GBL01                       GBN(1)
     I              GBL02                       GBN(2)
     I              GBL03                       GBN(3)
     I              GBL04                       GBN(4)
     I              GBL05                       GBN(5)
     I              GBL06                       GBN(6)
     I              GBL07                       GBN(7)
     I              GBL08                       GBN(8)
     I              GBL09                       GBN(9)
     I              GBL10                       GBN(10)
     I              GBL11                       GBN(11)
     I              GBL12                       GBN(12)
     I              GBL13                       GBN(13)
      *
     IRGLBALS
     I              GST01                       GSP(1)
     I              GST02                       GSP(2)
     I              GST03                       GSP(3)
     I              GST04                       GSP(4)
     I              GST05                       GSP(5)
     I              GST06                       GSP(6)
     I              GST07                       GSP(7)
     I              GST08                       GSP(8)
     I              GST09                       GSP(9)
     I              GST10                       GSP(10)
     I              GST11                       GSP(11)
     I              GST12                       GSP(12)
     I              GST13                       GSP(13)
     I              GSL01                       GSN(1)
     I              GSL02                       GSN(2)
     I              GSL03                       GSN(3)
     I              GSL04                       GSN(4)
     I              GSL05                       GSN(5)
     I              GSL06                       GSN(6)
     I              GSL07                       GSN(7)
     I              GSL08                       GSN(8)
     I              GSL09                       GSN(9)
     I              GSL10                       GSN(10)
     I              GSL11                       GSN(11)
     I              GSL12                       GSN(12)
     I              GSL13                       GSN(13)
      **********************
      * READ GLBAL RECORDS *
      **********************
     C     LCO           SETLL     FGLBAL
     C     NXTBAL        TAG
     C     LCO           READE     FGLBAL                                 90
     C   90              GOTO      ENDBAL
     C                   SETOFF                                       10
      ** TEMP CHECK IF MGLCH REC EXISTS AND IS ACTIVE
     C     GLKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GLGLNO
     C     GLKEY         CHAIN     FMGLCH                             10
     C  N10GCSTAT        IFNE      'A'
     C                   SETON                                        10
     C                   END
     C                   Z-ADD     GLBALT        GLBALL
     C     GCATYP        IFEQ      1
     C     GCATYP        OREQ      2
     C                   XFOOT     GLP           GLBALT
     C                   ADD       GLBALL        GLBALT
     C                   ELSE
     C                   Z-ADD     0             GLBALT
     C                   END
     C                   Z-ADD     GLP           GLN
     C                   Z-ADD     0             GLP
     C                   Z-ADD     1             X                 2 0
     C*          X         DOUGT13
     C*          GLN,X     IFNE 0
     C*                    SETON                     10
     C*                    END
     C*                    ADD  1         X
     C*                    ENDDO
     C   10              DELETE    RGLBAL
     C  N10              UPDATE    RGLBAL
     C                   GOTO      NXTBAL
     C     ENDBAL        TAG
      * GLBALT FILE
     C     LCO           SETLL     FGLBALT
     C     NXTBLT        TAG
     C     LCO           READE     FGLBALT                                90
     C   90              GOTO      ENDBLT
     C                   SETOFF                                       10
      * TEMP CHECK IF MGLCH REC EXISTS AND IS ACTIVE
     C     GLTKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GBGLNO
     C     GLTKEY        CHAIN     FMGLCH                             10
     C  N10GCSTAT        IFNE      'A'
     C                   SETON                                        10
     C                   END
     C                   Z-ADD     GBBALT        GBBALL
     C                   Z-ADD     0             GBBALT
     C                   Z-ADD     GLP           GBN
     C                   Z-ADD     0             GBP
     C                   Z-ADD     1             X                 2 0
     C*          X         DOUGT13
     C*          GBN,X     IFNE 0
     C*                    SETON                     10
     C*                    END
     C*                    ADD  1         X
     C*                    ENDDO
     C   10              DELETE    RGLBALT
     C  N10              UPDATE    RGLBALT
     C                   GOTO      NXTBLT
     C     ENDBLT        TAG
      * GLBALS FILE
     C     LCO           SETLL     FGLBALS
     C     NXTBLS        TAG
     C     LCO           READE     FGLBALS                                90
     C   90              GOTO      ENDBLS
     C                   SETOFF                                       10
      * TEMP CHECK IF MGLCH REC EXISTS AND IS ACTIVE
     C     GLSKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GBGLNO
     C     GLSKEY        CHAIN     FMGLCH                             10
     C  N10GCSTAT        IFNE      'A'
     C                   SETON                                        10
     C                   END
     C                   Z-ADD     GSBALT        GSBALL
     C                   Z-ADD     0             GSBALT
     C                   Z-ADD     GLP           GSN
     C                   Z-ADD     0             GSP
     C                   Z-ADD     1             X                 2 0
     C*          X         DOUGT13
     C*          GSN,X     IFNE 0
     C*                    SETON                     10
     C*                    END
     C*                    ADD  1         X
     C*                    ENDDO
     C   10              DELETE    RGLBALS
     C  N10              UPDATE    RGLBALS
     C                   GOTO      NXTBLS
     C     ENDBLS        TAG
     C                   SETON                                        LR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
