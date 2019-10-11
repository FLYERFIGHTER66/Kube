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
      *PROGRAM NAME-------- GETTORDALL
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- GET TOTAL VALUE OF OPEN ORDERS FOR ALL
      *                      CUSTOMERS
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  3/04/02 EFD ADD GET BROKER I.D.
      *
     FFMCUST    UF   E           K DISK
     FFMCUSTC   IF   F  640     6AIDISK    KEYLOC(2)
     FFOPNORDC  IF   E           K DISK
     F                                     RENAME(ROPNORD:OPNORD)
     FFOPNORDA  IF   E           K DISK
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
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LDAPTO                 1      1  0
      *
     IFMCUSTC   NS
     I*    STATUS
     I                                  1    1  CKSTAT
     I                                279  280  CKTMCD
     I                                288  291 2CKTRDC
     I                                462  462  CKPORQ
     I                                531  531  CKJOBR
     I                                621  625  CKBABB
      **********
      * START  *
      **********
     C     NXTCST        TAG
     C                   READ      FMCUST                                 90
     C   90              GOTO      END
      ** READ OPNORD FILE BY SHIP TO
     C     CMCUST        SETLL     FOPNORDC
     C                   Z-ADD     0             TOTDOL            9 2
     C                   Z-ADD     0             TOTORD            5 0
     C     NXTOPR        TAG
     C     CMCUST        READE     FOPNORDC                               90
     C  N90              DO
     C                   ADD       OOEXT$        TOTDOL
     C                   ADD       1             TOTORD
     C                   GOTO      NXTOPR
     C                   ENDDO
      ** READ OPNORD FILE BY A/R CUST
     C     CMCUST        SETLL     FOPNORDA
     C     NXTAPR        TAG
     C     CMCUST        READE     FOPNORDA                               90
     C  N90              DO
      ** THE SHIP TO HAS ALREADY BEEN ADDED
     C     OOCUST        IFNE      CMCUST
     C                   ADD       OOEXT$        TOTDOL
     C                   ADD       1             TOTORD
     C                   END
     C                   GOTO      NXTAPR
     C                   ENDDO
     C                   Z-ADD     TOTDOL        CMVOPO
     C                   Z-ADD     TOTORD        CMOCUR
     C     CMCUST        IFNE      CMARCU
     C     CMARCU        CHAIN     FMCUSTC                            92
     C  N92              MOVEL     CKBABB        CMBABB
     C                   END
     C                   UPDATE    RMCUST
     C                   GOTO      NXTCST
      **** END OF PROGRAM
     C     END           TAG
     C                   SETON                                        LR
