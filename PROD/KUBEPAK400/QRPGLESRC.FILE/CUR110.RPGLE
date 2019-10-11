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
      **PROGRAM NAME-------- CUR100
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CALCULATE CUTTING NEEDS FILE
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 12/03/01 EFD DO NOT USE SEEDS PER CELL ALL ORDERS ARE 1 PER ROB
      * 11/17/02 EFD CHANGE FROM 84 TO 105 TRAYS.
      *
     FFCALEN    IF   E           K DISK
     F                                     RENAME(RCALEN:CALENI)
     FFCALEX    IF   E           K DISK
     FFPTABLE   IF   E           K DISK
WJB02F*FMINVTSZ  IF   E           K DISK
WJB02FFMINVTCT  IF   E           K DISK
     FFCUTLOT   UF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFMINVTECKEIF   E           K DISK
      *
      ** PTABLE ARRAYS
     D PMN             S              7  0 DIM(12)                              MINIMUM
     D PMX             S              7  0 DIM(12)                              MAXIMUM
     D PUN             S              5  0 DIM(12)                              FACTOR UNITS
     D PPC             S              5  2 DIM(12)                              FACTOR %
      *
WJB ?D  Item           S                   Like(IMITEM)
WJB ?D  Size           S                   Like(IMSIZE)
WJB ?D  Table          S                   Like(IMFTAB)
WJB ?D  Order          S              7S 1
WJB ?D  ToSow          S              7S 1
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
      *
     D  Vendor         S                   Like(IMVEND)
      *
     IRPTABLE
     I              PTBQ01                      PMN(1)
     I              PTBQ02                      PMN(2)
     I              PTBQ03                      PMN(3)
     I              PTBQ04                      PMN(4)
     I              PTBQ05                      PMN(5)
     I              PTBQ06                      PMN(6)
     I              PTBQ07                      PMN(7)
     I              PTBQ08                      PMN(8)
     I              PTBQ09                      PMN(9)
     I              PTBQ10                      PMN(10)
     I              PTBQ11                      PMN(11)
     I              PTBQ12                      PMN(12)
     I              PTEQ01                      PMX(1)
     I              PTEQ02                      PMX(2)
     I              PTEQ03                      PMX(3)
     I              PTEQ04                      PMX(4)
     I              PTEQ05                      PMX(5)
     I              PTEQ06                      PMX(6)
     I              PTEQ07                      PMX(7)
     I              PTEQ08                      PMX(8)
     I              PTEQ09                      PMX(9)
     I              PTEQ10                      PMX(10)
     I              PTEQ11                      PMX(11)
     I              PTEQ12                      PMX(12)
     I              PTUN01                      PUN(1)
     I              PTUN02                      PUN(2)
     I              PTUN03                      PUN(3)
     I              PTUN04                      PUN(4)
     I              PTUN05                      PUN(5)
     I              PTUN06                      PUN(6)
     I              PTUN07                      PUN(7)
     I              PTUN08                      PUN(8)
     I              PTUN09                      PUN(9)
     I              PTUN10                      PUN(10)
     I              PTUN11                      PUN(11)
     I              PTUN12                      PUN(12)
     I              PTPE01                      PPC(1)
     I              PTPE02                      PPC(2)
     I              PTPE03                      PPC(3)
     I              PTPE04                      PPC(4)
     I              PTPE05                      PPC(5)
     I              PTPE06                      PPC(6)
     I              PTPE07                      PPC(7)
     I              PTPE08                      PPC(8)
     I              PTPE09                      PPC(9)
     I              PTPE10                      PPC(10)
     I              PTPE11                      PPC(11)
     I              PTPE12                      PPC(12)
      ****************
      * START HERE   *
      ****************
WJB02C     *LOVAL        SETLL     FMINVTCT                                                    ARC38
     C     NXT           TAG
WJB02C                   READ      FMINVTCT                               90                   ARC38
WJB02C  N90IMSIZE        CHAIN     FMSIZE                             90
     C   90              GOTO      END
     C     IMFRSZ        IFNE      'CUT'
     C     IMSTAT        OREQ      'D'
WJB  C*    IMVEND        ORNE      23
WJB  C     IMVEND        ORNE      Vendor
     C                   GOTO      NXT
     C                   END
      ** GET FIXERS
     C                   EXSR      GETFIX
     C                   GOTO      NXT
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** GET FIXER TRAYS   **
      ***********************
     C     GETFIX        BEGSR
     C     CLRKEY        KLIST
     C                   KFLD                    Vendor
     C                   KFLD                    IMITEM
WJB  C*                  KFLD                    SIZE
WJB  C                   KFLD                    IMSIZE
     C                   MOVEL     'CUT'         SIZE              3
     C     CLRKEY        SETLL     FCUTLOT
     C     NXTFIX        TAG
     C     CLRKEY        READE     FCUTLOT                                91
     C   91              GOTO      ENDFIX
     C*    CLSOWD        IFLT      BEGSCY
     C*                  GOTO      NXTFIX
     C*                  END
      ** GET NUMBER OF FIXER TRAYS
     C                   Z-ADD     CLQTTS        WRKQTY            5 1
     C                   EXSR      LBLRTN
     C                   Sub       CLQTSP        CLQTTS
WJB ?C                   Call      '#SOWFACT71'
WJB ?C                   Parm                    Item
WJB ?C                   Parm                    Size
WJB ?C                   Parm      IMFTAB        Table
WJB ?C                   Parm      CLQTTS        Order
WJB ?C     WRKFLD        Parm                    ToSow
     C                   Add       CLQTSP        CLQTTS
     C                   Add       CLQTSP        ToSow
     C                   Add       CLQTSP        WRKFLD
     C     WRKFLD        IFGT      0
     C     WRKFLD        SUB       WRKQTY        CLQTTF
     C                   ELSE
     C                   Z-ADD     0             CLQTTF
     C                   END
     C     CLQTTS        ADD       CLQTTF        TRAYS             9 1
WJB02C     TRAYS         MULT      SZSALE        CELLS             9 0
     C     CELLS         MULT      IM#SED        CLQTSL                         |Quantity Sold
     C     ECHEKEY       CHAIN     FMINVTECKE
     C     ECHEKEY       KLIST
     C                   KFLD                    CLVEND
     C                   KFLD                    CLITEM
     C                   If        %Found(FMINVTECKE)
     C                   Eval      CLQTSL = CLQTSL / IFACTOR
     C                   EndIf
     C                   UPDATE    RCUTLOT
     C                   GOTO      NXTFIX
     C     ENDFIX        ENDSR
     C**************
     C* LBLRTN     *
     C**************
     C     LBLRTN        BEGSR
     C                   Z-ADD     0             WRKFLD
     C     IMFTAB        IFEQ      '**'
     C                   GOTO      ENDPTB
     C                   END
     C     IMFTAB        CHAIN     FPTABLE                            88
     C   88              GOTO      ENDPTB
     C* CALCULATE NUMBER OF TRAYS
     C                   DO        12            X                 2 0
     C     WRKQTY        IFGE      PMN(X)
     C     WRKQTY        IFLE      PMX(X)
     C     PUN(X)        IFGT      0
     C     WRKQTY        ADD       PUN(X)        WRKFLD            5 1
     C                   ELSE
     C     PPC(X)        DIV(H)    100           PCTWK             5 4
     C     1.00          ADD       PCTWK         PCTM              5 4
     C     WRKQTY        MULT(H)   PCTM          WRKFLD
WJB  C     WRKQTY        MULT(H)   PCTM          WRKFLDdec         9 9
WJB  C*    WRKFLDdec     IFLT      .5
WJB  C*    WRKFLDdec     ANDGT     0
WJB  C     WRKFLDdec     IfGt      0
WJB  C                   ADD       1             WRKFLD
WJB  C                   END
     C                   END
     C                   END
     C                   END
     C                   ENDDO
     C*
     C     ENDPTB        ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C     *Entry        PList
     C                   Parm                    Vendor
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      ** GET LOWEST SOW DATE (THIS WEEK)
     C     TDATE         CHAIN     FCALEN                             90
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    CLWEEK
     C                   KFLD                    CL#Y
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             90
     C                   Z-ADD     CLCYMD        BEGSCY            7 0
     C                   ENDSR
