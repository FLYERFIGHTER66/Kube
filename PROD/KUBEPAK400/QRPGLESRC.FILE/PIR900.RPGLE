      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2002
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
      **PROGRAM NAME-------- PIR900
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- ADJUST WEEKLY POINSETTIA AVAILABILTY
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFPOIITM   UF   E           K DISK
     FFPOISOW   UF A E           K DISK
     FFIORDRPCA IF   E           K DISK
     FFPOICTL   IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFMSIZE    IF   E           K DISK
     FFPTABLE   IF   E           K DISK
      *
     D  Order          S              7S 0
     D  ToSow          S              7S 0
      *
      * CONTROL FILE DATE ARRAY
     D PCW             S              6  0 DIM(12)                              WEEK DATES
      * BALANCE FILE DATE ARRAY
     D OH              S              7  0 DIM(12)                              ON-HAND
     D ND              S              7  0 DIM(12)                              NEED
     D SL              S              7  0 DIM(12)                              SOLD
      ** PTABLE ARRAYS
     D PMN             S              7  0 DIM(12)                              MINIMUM
     D PMX             S              7  0 DIM(12)                              MAXIMUM
     D PUN             S              5  0 DIM(12)                              FACTOR UNITS
     D PPC             S              5  2 DIM(12)                              FACTOR %
      *
      *
     D                 DS
     D OIITMA
     D OIITMA4                 1      4
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10
      ** RUN LIBRARY
     D  RLIBR                 81     90
      * USER I.D.
     D  USERID               254    263
      ** SOURCE LIBRARY
     D  SLIBR                314    323
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
      *
      * RENAME CONTROL FILE
     IRPOICTL
     I              PCW1D                       PCW(1)
     I              PCW2D                       PCW(2)
     I              PCW3D                       PCW(3)
     I              PCW4D                       PCW(4)
     I              PCW5D                       PCW(5)
     I              PCW6D                       PCW(6)
     I              PCW7D                       PCW(7)
     I              PCW8D                       PCW(8)
     I              PCW9D                       PCW(9)
     I              PCW10D                      PCW(10)
     I              PCW11D                      PCW(11)
     I              PCW12D                      PCW(12)
      *
      * RENAME BALANCE FILE
     IRPOIITM
      * ON-HAND
     I              PIOH1                       OH(1)
     I              PIOH2                       OH(2)
     I              PIOH3                       OH(3)
     I              PIOH4                       OH(4)
     I              PIOH5                       OH(5)
     I              PIOH6                       OH(6)
     I              PIOH7                       OH(7)
     I              PIOH8                       OH(8)
     I              PIOH9                       OH(9)
     I              PIOH10                      OH(10)
     I              PIOH11                      OH(11)
     I              PIOH12                      OH(12)
      * NEED
     I              PIND1                       ND(1)
     I              PIND2                       ND(2)
     I              PIND3                       ND(3)
     I              PIND4                       ND(4)
     I              PIND5                       ND(5)
     I              PIND6                       ND(6)
     I              PIND7                       ND(7)
     I              PIND8                       ND(8)
     I              PIND9                       ND(9)
     I              PIND10                      ND(10)
     I              PIND11                      ND(11)
     I              PIND12                      ND(12)
      * SOLD
     I              PISL1                       SL(1)
     I              PISL2                       SL(2)
     I              PISL3                       SL(3)
     I              PISL4                       SL(4)
     I              PISL5                       SL(5)
     I              PISL6                       SL(6)
     I              PISL7                       SL(7)
     I              PISL8                       SL(8)
     I              PISL9                       SL(9)
     I              PISL10                      SL(10)
     I              PISL11                      SL(11)
      ***********************
      ** ZERO NEED ARRAY   **
      ***********************
     C     YEAR          SETLL     FPOIITM
     C     NXTCLR        TAG
     C     YEAR          READE     FPOIITM                                90
     C   90              GOTO      ENDCLR
     C                   Z-ADD     0             ND
     C                   UPDATE    RPOIITM
     C                   GOTO      NXTCLR
     C     ENDCLR        TAG
     C                   UNLOCK    FPOIITM
      ***********************
      ** ZERO SOW SCHEDULE **
      ***********************
     C                   MOVE      *BLANKS       ITEM             12
     C     ITEM          SETLL     FPOISOW
     C     NXTCL1        TAG
     C                   READ      FPOISOW                                90
     C   90              GOTO      ENDCL1
     C     PSSOWD        IFLT      BEGSOW
     C                   GOTO      NXTCL1
     C                   END
     C                   Z-ADD     0             PSQORD
     C                   Z-ADD     0             PSQSHP
     C                   Z-ADD     0             PSQFIX
     C                   Z-ADD     0             PSTOTN
     C                   UPDATE    RPOISOW
     C                   GOTO      NXTCL1
     C     ENDCL1        TAG
     C                   UNLOCK    FPOISOW
      ***********************
      ** GET OPEN ORDERS   **
      ***********************
     C                   MOVEL     '06'          PC                2
     C     PC            SETLL     FIORDRPCA
     C     NXTORD        TAG
     C                   READ      FIORDRPCA                              90
     C   90              GOTO      ENDO
     C*    OIPRCL        IFGT      '09'
     C*                  GOTO      ENDO
     C*                  END
     C     OIITMA4       IFNE      'POI:'
     C     OIITMA4       ANDNE     'STR:'
     C                   GOTO      NXTORD
     C                   END
     C     OISOW         IFGE      BEGSOW
     C     OISOW         ANDLE     ENDSOW
     C     OIQORD        SUB       OIQSHP        QTY
      ** GET UNPROCESSED INVOICES
     C                   ADD       OIQINV        QTY
      ** GET QTY SHIPPED
     C     OIQSHP        SUB       OIQINV        WRKSHP           11 1
     C     SOWKEY        KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OISOW
     C     SOWKEY        CHAIN     FPOISOW                            57
     C     QTY           ADD       WRKSHP        TSTQTY            9 0
     C     TSTQTY        IFGT      0
     C   57              DO
     C                   CLEAR                   RPOISOW
     C                   MOVEL     OIITEM        PSITEM
     C                   MOVEL     OISIZE        PSSIZE
     C                   Z-ADD     OISOW         PSSOWD
     C                   Z-ADD     OIRVDT        PSSHPD
     C                   ADD       QTY           PSQORD
     C                   ADD       WRKSHP        PSQSHP
     C                   WRITE     RPOISOW
     C                   ENDDO                                                  57 DO
     C                   END                                                    TSTQTY>0
     C                   ADD       QTY           PSQORD
     C                   ADD       WRKSHP        PSQSHP
     C  N57              UPDATE    RPOISOW
     C                   END                                                    OISOW>BEGSOW
     C                   GOTO      NXTORD
      ** END OF ORDERS GET FIXERS
     C     ENDO          TAG
     C                   EXSR      CALSOW
      ** END JOB
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** UPDATE FIXERS     **
      ***********************
     C     CALSOW        BEGSR
     C                   MOVE      *BLANKS       ITEM
     C     ITEM          SETLL     FPOISOW
     C     NXTSOW        TAG
     C                   READ      FPOISOW                                90
     C   90              GOTO      ENDSW
     C     PSSOWD        IFLT      BEGSOW
     C                   GOTO      NXTSOW
     C                   END
     C     MINKEY        KLIST
     C                   KFLD                    PSITEM
     C                   KFLD                    PSSIZE
     C     MINKEY        CHAIN     FMINVT                             91
     C   91              GOTO      NXTSOW
     C     PSSIZE        CHAIN     FMSIZE                             91
     C                   If        SZCELL < 1
     C                   Eval      SZCELL = 1
     C                   EndIf
     C                   Z-ADD     0             FIXERS            7 0
     C     IMFTAB        IFEQ      '**'
     C                   GOTO      ENDPTB
     C                   END
     C     IMFTAB        CHAIN     FPTABLE                            91
     C   91              GOTO      ENDPTB
      * CALCULATE NUMBER OF FIXERS
      * INCLUDE ITEMS ALREADY SHIPPED
     C**                   Z-ADDPSQORD    WRKQTY  70
     C     PSQSHP        ADD       PSQORD        WRKQTY            7 0
     C                   Z-ADD     1             X
     C                   DO        12            X                 2 0
     C     WRKQTY        IFGE      PMN(X)
     C     WRKQTY        ANDLE     PMX(X)
     C     PUN(X)        IFGT      0
     C                   Z-ADD     PUN(X)        FIXERS
     C                   ELSE
     C     PPC(X)        DIV(H)    100           PCTWK             5 4
     C     WRKQTY        MULT      PCTWK         FIXERS
     C     WRKQTY        MULT      PCTWK         FIXWK            10 4
     C                   MOVE      FIXWK         TST40             4 0
     C     TST40         IFGT      .0001
     C                   ADD       1             FIXERS
     C                   END
     C                   END                                                    PUN,X>0
     C                   END                                                    WRKQTY TESTS
     C                   ENDDO                                                  X>12 DO
     C     ENDPTB        TAG
     C                   Eval      Order = WRKQTY
WJB ?C                   Call      '#SOWFACTOR'
WJB ?C                   Parm                    PSITEM
WJB ?C                   Parm                    PSSIZE
WJB ?C                   Parm                    IMFTAB
WJB ?C                   Parm                    Order
WJB ?C                   Parm                    ToSow
     C                   Eval      FIXERS = ToSow - Order
     C                   Z-ADD     FIXERS        PSQFIX
WJB  C     SZCELL        Mult      PSQORD        PSQORD
WJB  C     SZCELL        Mult      PSQSHP        PSQSHP
WJB  C     SZCELL        Mult      FIXERS        PSQFIX
     C     PSQFIX        ADD       PSQORD        PSTOTN
     C                   Z-ADD     TDATE         PSDTLA
     C                   Z-ADD     TIMOD         PSTIME
     C                   MOVEL     IMLOOK        PSLOOK
     C                   MOVEL     IMPCL1        PSPCL1
     C                   MOVEL     USERID        PSUSER
     C                   UPDATE    RPOISOW
     C     PSQORD        ADD       FIXERS        QTY
     C                   Eval      QTY = PSTOTN
     C     QTY           IFGT      0
     C                   Z-ADD     PSSOWD        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         SOWDAT
     C                   CALL      'PIRALO'
     C                   PARM                    PSITEM
     C                   PARM                    PSSIZE
     C                   PARM                    SOWDAT            6 0
     C                   PARM                    QTY               7 0
     C                   END                                                    QTY>0
     C                   GOTO      NXTSOW
     C     ENDSW         TAG
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   MOVE      TDATE         YY                2 0
     C     2000          ADD       YY            YEAR              4 0
     C     YEAR          CHAIN     FPOICTL                            LR
     C   LR              RETURN
     C                   Z-ADD     PCW(1)        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        BEGSOW            7 0
     C                   Z-ADD     PCW(PCNUMW)   ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        ENDSOW            7 0
     C                   ENDSR
      ****
