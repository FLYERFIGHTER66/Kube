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
     FFGLBAL01  IF   E           K DISK
     FFGLBALT1  UF A E           K DISK
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
      **********************
      * READ GLBAL RECORDS *
      **********************
     C     NXT           TAG
     C                   READ      FGLBAL01                               90
     C   90              GOTO      END
     C     GLGLNO        IFLE      29999999
     C                   EXSR      ASSET
     C                   ELSE
     C                   EXSR      SALES
     C                   END
     C                   MOVEL     GLSTAT        GBSTAT
     C                   Z-ADD     GLCOMP        GBCOMP
     C                   Z-ADD     GLGLNO        GBGLNO
     C                   WRITE     RGLBALT
     C                   GOTO      NXT
     C     BALKEY        KLIST
     C                   KFLD                    GLCOMP
     C                   KFLD                    GLGLNO
     C     BALKEY        CHAIN     FGLBALT1                           77
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ********************
      * BUILD ASSETS     *
      ********************
     C     ASSET         BEGSR
     C     GLBALL        ADD       GLN(1)        GBBALT
     C                   ADD       GLN(2)        GBBALT
     C                   ADD       GLN(3)        GBBALT
     C                   ADD       GLN(4)        GBBALT
     C                   ADD       GLN(5)        GBBALT
     C                   ADD       GLN(6)        GBBALT
     C                   ADD       GLN(7)        GBBALT
     C                   ADD       GLN(8)        GBBALT
     C                   ADD       GLN(9)        GBBALT
     C     GBBALT        ADD       GLN(10)       GBP(1)
     C     GBP(1)        ADD       GLN(11)       GBP(2)
     C     GBP(2)        ADD       GLN(12)       GBP(3)
     C     GBP(3)        ADD       GLP(4)        GBP(4)
     C     GBP(4)        ADD       GLP(5)        GBP(5)
     C     GBP(5)        ADD       GLP(6)        GBP(6)
     C     GBP(6)        ADD       GLP(7)        GBP(7)
     C     GBP(7)        ADD       GLP(8)        GBP(8)
     C     GBP(8)        ADD       GLP(9)        GBP(9)
     C     GBP(9)        ADD       GLP(10)       GBP(10)
     C     GBP(10)       ADD       GLP(11)       GBP(11)
     C     GBP(11)       ADD       GLP(12)       GBP(12)
      ** GET ACTIVITY BUCKETS
     C                   Z-ADD     GLN(10)       GBN(1)
     C                   Z-ADD     GLN(11)       GBN(2)
     C                   Z-ADD     GLN(12)       GBN(3)
     C                   Z-ADD     GLP(4)        GBN(4)
     C                   Z-ADD     GLP(5)        GBN(5)
     C                   Z-ADD     GLP(6)        GBN(6)
     C                   Z-ADD     GLP(7)        GBN(7)
     C                   Z-ADD     GLP(8)        GBN(8)
     C                   Z-ADD     GLP(9)        GBN(9)
     C                   Z-ADD     GLP(10)       GBN(10)
     C                   Z-ADD     GLP(11)       GBN(11)
     C                   Z-ADD     GLP(12)       GBN(12)
     C                   ENDSR
      ********************
      * BUILD REVENUE    *
      ********************
     C     SALES         BEGSR
     C                   Z-ADD     GLN(10)       GBP(1)
     C     GBP(1)        ADD       GLN(11)       GBP(2)
     C     GBP(2)        ADD       GLN(12)       GBP(3)
     C     GBP(3)        ADD       GLP(4)        GBP(4)
     C     GBP(4)        ADD       GLP(5)        GBP(5)
     C     GBP(5)        ADD       GLP(6)        GBP(6)
     C     GBP(6)        ADD       GLP(7)        GBP(7)
     C     GBP(7)        ADD       GLP(8)        GBP(8)
     C     GBP(8)        ADD       GLP(9)        GBP(9)
     C     GBP(9)        ADD       GLP(10)       GBP(10)
     C     GBP(10)       ADD       GLP(11)       GBP(11)
     C     GBP(11)       ADD       GLP(12)       GBP(12)
      ** GET ACTIVITY BUCKETS
     C                   Z-ADD     GLN(10)       GBN(1)
     C                   Z-ADD     GLN(11)       GBN(2)
     C                   Z-ADD     GLN(12)       GBN(3)
     C                   Z-ADD     GLP(4)        GBN(4)
     C                   Z-ADD     GLP(5)        GBN(5)
     C                   Z-ADD     GLP(6)        GBN(6)
     C                   Z-ADD     GLP(7)        GBN(7)
     C                   Z-ADD     GLP(8)        GBN(8)
     C                   Z-ADD     GLP(9)        GBN(9)
     C                   Z-ADD     GLP(10)       GBN(10)
     C                   Z-ADD     GLP(11)       GBN(11)
     C                   Z-ADD     GLP(12)       GBN(12)
     C                   ENDSR
