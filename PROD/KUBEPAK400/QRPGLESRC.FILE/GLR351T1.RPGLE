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
      *PROGRAM NAME-------- GLR351
      *SYSTEM-------------- GENERAL LEDGER
      *APPLICATION--------- POST BALANCE FILE TO TOTAL BALANCE FILE
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFGLBALT1  IF   E           K DISK
     F                                     RENAME(RGLBALT:GLBALT)
     FFGLBALTS  UF A E           K DISK
      *
      *
     D GLP             S             11  2 DIM(13)
     D GLN             S             11  2 DIM(13)
     D GBP             S             11  2 DIM(13)
     D GBN             S             11  2 DIM(13)
     D GSP             S             11  2 DIM(13)
     D GSN             S             11  2 DIM(13)
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
     IGLBALT
     I              GBT01                       GLP(1)
     I              GBT02                       GLP(2)
     I              GBT03                       GLP(3)
     I              GBT04                       GLP(4)
     I              GBT05                       GLP(5)
     I              GBT06                       GLP(6)
     I              GBT07                       GLP(7)
     I              GBT08                       GLP(8)
     I              GBT09                       GLP(9)
     I              GBT10                       GLP(10)
     I              GBT11                       GLP(11)
     I              GBT12                       GLP(12)
     I              GBT13                       GLP(13)
     I              GBL01                       GLN(1)
     I              GBL02                       GLN(2)
     I              GBL03                       GLN(3)
     I              GBL04                       GLN(4)
     I              GBL05                       GLN(5)
     I              GBL06                       GLN(6)
     I              GBL07                       GLN(7)
     I              GBL08                       GLN(8)
     I              GBL09                       GLN(9)
     I              GBL10                       GLN(10)
     I              GBL11                       GLN(11)
     I              GBL12                       GLN(12)
     I              GBL13                       GLN(13)
      **********************
      * READ GLBAL RECORDS *
      **********************
     C     NXT           TAG
     C                   READ      FGLBALT1                               90
     C   90              GOTO      END
      ** ONLY GET ASSETS AND LIAB.
     C     GBGLNO        IFGT      29999999
     C                   GOTO      NXT
     C                   EXSR      GETSUM
     C                   END
     C     BALKEY        KLIST
     C                   KFLD                    GBCOMP
     C                   KFLD                    GBGLNO
     C     BALKEY        CHAIN     FGLBALTS                           78
      ** BUCKETS FOR CURRENT YEAR
     C                   Z-ADD     GLP           GSP
     C                   ADD       GLN           GSN
     C                   ADD       BUD           BBP
     C   03              ADD       BUD           SALE
     C   04              ADD       BUD           EXP
     C                   ADD       BND           BBN
     C                   ADD       GLBALT        GSBALT
     C                   ADD       GLBALL        GSBALL
     C                   ADD       GLBUDT        GSBUDT
     C                   ADD       GLBUDL        GSBUDL
     C     BALKEY        CHAIN     FGLBALT                            77
     C   77              CLEAR                   RGLBALT
     C                   Z-ADD     GCCOMP        GBCOMP
     C                   Z-ADD     GCGLNO        GBGLNO
     C                   Z-ADD     GLBALT        GBBALT
     C                   Z-ADD     GLBALL        GBBALL
      ** GET BEG BALANCE AND PER 1
     C     GBBALT        ADD       GLP(1)        GBP(1)
     C     GBBALL        ADD       GLN(1)        GBN(1)
      ** NOW CALC TOTALS
     C                   Z-ADD     1             X                 2 0
     C                   Z-ADD     2             Y                 2 0
     C     Y             DOUGT     NUM
     C     GBP(X)        ADD       GLP(Y)        GBP(Y)
     C     GBN(X)        ADD       GLN(Y)        GBN(Y)
     C                   ADD       1             Y
     C                   ADD       1             X
     C                   ENDDO
     C                   MOVEL     'A'           GBSTAT
     C                   MOVEL     USERID        GBUSER
     C                   Z-ADD     TIMOD         GBTIME
     C                   Z-ADD     TDATE         GBDTLA
     C   77              WRITE     RGLBALT
     C  N77              UPDATE    RGLBALT
     C                   GOTO      NXT
     C     END           TAG
     C                   EXSR      PUTSUM
     C                   EXSR      GETRET
     C                   SETON                                        LR
      ***********************
      ** GET GLBALS RECORD **
      ***********************
     C     GETSUM        BEGSR
     C                   Z-ADD     GCATYP        S                 2 0
     C                   SETOFF                                       010203
     C                   SETOFF                                       04
     C                   MOVEL     '1'           *IN(S)
     C     GSKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    SUMGLN            8 0
     C     GBKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    BGLNO
     C   01              Z-ADD     10000000      SUMGLN
     C   02              Z-ADD     20000000      SUMGLN
     C   03              Z-ADD     30000000      SUMGLN
     C   04              Z-ADD     50000000      SUMGLN
     C     SUMGLN        ADD       10000         BGLNO
     C     GSKEY         CHAIN     FGLBALS                            57
     C     GBKEY         CHAIN     FGLBALSB                           58
     C                   Z-ADD     0             GSP
     C                   Z-ADD     0             GSN
     C                   Z-ADD     0             BBP
     C                   Z-ADD     0             BBN
     C                   Z-ADD     0             GSBUDT
     C                   Z-ADD     0             GSBUDL
     C   57              DO
     C                   Z-ADD     LCO           GSCOMP
     C                   Z-ADD     SUMGLN        GSGLNO
     C                   ENDDO                                                  57  DO
     C   58              DO
     C                   Z-ADD     LCO           GSCOMP
     C                   ENDDO                                                  58  DO
     C                   MOVEL     'A'           GSSTAT
     C                   MOVEL     USERID        GSUSER
     C                   Z-ADD     TIMOD         GSTIME
     C                   Z-ADD     TDATE         GSDTLA
     C                   Z-ADD     GCATYP        OTYPE             2 0
     C                   ENDSR
      ***********************
      ** PUT GLBALS RECORD **
      ***********************
     C     PUTSUM        BEGSR
     C   57              WRITE     RGLBALS
     C  N57              UPDATE    RGLBALS
     C   58              WRITE     GLBALB
     C  N58              UPDATE    GLBALB
     C                   ENDSR
      ***********************
      ** GET RET EARN REC  **
      ***********************
     C     GETRET        BEGSR
     C     DFKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    DFTYP
     C                   MOVEL     '01'          DFTYP             2
     C     DFKEY         CHAIN     FGLDF                              77
     C   77              GOTO      ENDRET
     C                   Z-ADD     GDINC$        SUMGLN
     C     GSKEY         CHAIN     FGLBAL                             78
     C   78              GOTO      ENDRET
     C                   Z-ADD     99000000      SUMGLN
     C     SUMGLN        ADD       10000         BGLNO
     C     GSKEY         CHAIN     FGLBALS                            57
     C     GBKEY         CHAIN     FGLBALSB                           58
     C                   Z-ADD     0             GSP
     C                   Z-ADD     0             GSN
     C                   Z-ADD     0             GSBUDT
     C                   Z-ADD     0             GSBUDL
     C   57              DO
     C                   Z-ADD     LCO           GSCOMP
     C                   Z-ADD     SUMGLN        GSGLNO
     C                   ENDDO                                                  57  DO
     C   58              DO
     C                   Z-ADD     LCO           GSCOMP
     C                   ENDDO                                                  58  DO
     C                   MOVEL     'A'           GSSTAT
      ** GET SUMMARY
     C                   Z-ADD     GLP           GSP
     C                   Z-ADD     GLN           GSN
     C                   Z-ADD     GLBALT        GSBALT
     C                   Z-ADD     GLBALL        GSBALL
     C                   Z-ADD     GLBUDT        GSBUDT
     C                   Z-ADD     GLBUDL        GSBUDL
     C     SALE          ADD       EXP           BBP
     C                   Z-ADD     0             BBN
     C                   EXSR      PUTSUM
     C     ENDRET        ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     LCO           CHAIN     FMAPER                             99
     C     ACMPCN        IFEQ      'M'
     C                   Z-ADD     12            NUM               2 0
     C                   ELSE
     C                   Z-ADD     13            NUM               2 0
     C                   END
     C                   MOVEA     '0'           *IN
     C                   Z-ADD     1             GCATYP
     C                   EXSR      GETSUM
     C                   ENDSR
