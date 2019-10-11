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
     FFGLBAL    IF   E           K DISK
     FFGLBUD    IF   E           K DISK
     FFGLDF     IF   E           K DISK
     FFMGLCHTP  IF   E           K DISK
     FFMAPER    IF   E           K DISK
     FFGLBALT   UF A E           K DISK
     FFGLBALSB  UF A E           K DISK
     F                                     RENAME(RGLBALS:GLBALB)
     FFGLBALS   UF A E           K DISK
      *
      *
     D GLP             S             11  2 DIM(13)
     D GLN             S             11  2 DIM(13)
     D GBP             S             11  2 DIM(13)
     D GBN             S             11  2 DIM(13)
     D GSP             S             11  2 DIM(13)
     D GSN             S             11  2 DIM(13)
      * GLBUD ARRAY
     D BUD             S             11  2 DIM(13)                              BUDG THIS YEAR
     D BND             S             11  2 DIM(13)                              BUDG NEXT YEAR
      * GLBUD ARRAY IN
     D BCY             S             11  2 DIM(13)                              BUDG THIS YEAR
     D BNY             S             11  2 DIM(13)                              BUDG NEXT YEAR
      * GLBALSB ARRAY IN
     D BBP             S             11  2 DIM(13)                              BUDG THIS YEAR
     D BBN             S             11  2 DIM(13)                              BUDG NEXT YEAR
      * SALES/EXPENSES SUMMARY
     D SALE            S             11  2 DIM(13)
     D EXP             S             11  2 DIM(13)
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
      *
     IGLBALB
     I              GSGLNO                      BGLNO
     I              GST01                       BBP(1)
     I              GST02                       BBP(2)
     I              GST03                       BBP(3)
     I              GST04                       BBP(4)
     I              GST05                       BBP(5)
     I              GST06                       BBP(6)
     I              GST07                       BBP(7)
     I              GST08                       BBP(8)
     I              GST09                       BBP(9)
     I              GST10                       BBP(10)
     I              GST11                       BBP(11)
     I              GST12                       BBP(12)
     I              GST13                       BBP(13)
     I              GSL01                       BBN(1)
     I              GSL02                       BBN(2)
     I              GSL03                       BBN(3)
     I              GSL04                       BBN(4)
     I              GSL05                       BBN(5)
     I              GSL06                       BBN(6)
     I              GSL07                       BBN(7)
     I              GSL08                       BBN(8)
     I              GSL09                       BBN(9)
     I              GSL10                       BBN(10)
     I              GSL11                       BBN(11)
     I              GSL12                       BBN(12)
     I              GSL13                       BBN(13)
      *
     IRGLBUD
     I              GBC01                       BUD(1)
     I              GBC02                       BUD(2)
     I              GBC03                       BUD(3)
     I              GBC04                       BUD(4)
     I              GBC05                       BUD(5)
     I              GBC06                       BUD(6)
     I              GBC07                       BUD(7)
     I              GBC08                       BUD(8)
     I              GBC09                       BUD(9)
     I              GBC10                       BUD(10)
     I              GBC11                       BUD(11)
     I              GBC12                       BUD(12)
     I              GBC13                       BUD(13)
     I              GBN01                       BND(1)
     I              GBN02                       BND(2)
     I              GBN03                       BND(3)
     I              GBN04                       BND(4)
     I              GBN05                       BND(5)
     I              GBN06                       BND(6)
     I              GBN07                       BND(7)
     I              GBN08                       BND(8)
     I              GBN09                       BND(9)
     I              GBN10                       BND(10)
     I              GBN11                       BND(11)
     I              GBN12                       BND(12)
      **********************
      * READ GLBAL RECORDS *
      **********************
     C     LCO           SETLL     FMGLCHTP
     C     NXT           TAG
     C     LCO           READE     FMGLCHTP                               90
     C   90              GOTO      END
     C     GCATYP        IFNE      OTYPE
     C                   EXSR      PUTSUM
     C                   EXSR      GETSUM
     C                   Z-ADD     GCATYP        OTYPE             2 0
     C                   END
     C     BALKEY        CHAIN     FGLBAL                             78
     C   78              GOTO      NXT
     C     BALKEY        CHAIN     FGLBUD                             79
     C   79              DO
     C                   Z-ADD     0             BUD
     C                   Z-ADD     0             BND
     C                   ENDDO
      ** GET SUMMARY
     C                   ADD       GLP           GSP
     C                   ADD       GLN           GSN
     C                   ADD       BUD           BBP
     C   03              ADD       BUD           SALE
     C   04              ADD       BUD           EXP
     C                   ADD       BND           BBN
     C                   ADD       GLBALT        GSBALT
     C                   ADD       GLBALL        GSBALL
     C                   ADD       GLBUDT        GSBUDT
     C                   ADD       GLBUDL        GSBUDL
     C     BALKEY        KLIST
     C                   KFLD                    GCCOMP
     C                   KFLD                    GCGLNO
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
