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
      **PROGRAM NAME-------- PIR310
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- POINSETTIA SPREAD SHEET
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMINVT    IF   E           K DISK
     FFPOIITMA  IF   E           K DISK
     FFPOICTL   IF   E           K DISK
     FPIR310    O    F  120        PRINTER OFLIND(*INOF)
      *
      * CONTROL FILE DATE ARRAY
     D PCW             S              6  0 DIM(12)                              WEEK DATES
      * BALANCE FILE ARRAY
     D OH              S              7  0 DIM(12)                              ON-HAND
     D ND              S              7  0 DIM(12)                              NEED
     D SL              S              7  0 DIM(12)                              SOLD
      *
      * SCREEN WORK ARRAY
     D NED             S              7  0 DIM(12)                              NEED
     D SLD             S              7  0 DIM(12)                              SOLD
     D PR              S              7  0 DIM(12)                              PRIOR
     D TOT             S              7  0 DIM(12)                              TOTAL
     D ONH             S              7  0 DIM(12)                              ON-HAND
     D OV              S              7  0 DIM(12)                              +/-
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
     D  YEAR                   1      4  0                                      ARC380
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
     I              PISL12                      SL(12)
      ****************
      *   START HERE *
      ****************
     C                   SETON                                        OF
     C                   EXSR      BLDSFL
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** BUILD SUB FILE    **
      ***********************
     C     BLDSFL        BEGSR
     C                   Z-ADD     0             NED
     C                   Z-ADD     0             PR
     C                   Z-ADD     0             TOT
     C                   Z-ADD     0             ONH
     C                   Z-ADD     0             OV
     C     YEAR          SETLL     FPOIITMA
     C     NXTBLD        TAG
     C     YEAR          READE     FPOIITMA                               90
     C   90              GOTO      ENDBLD
     C     MINKEY        KLIST
     C                   KFLD                    PIITEM
     C                   KFLD                    SIZE
     C                   MOVEL     'CUT'         SIZE              3
     C     MINKEY        CHAIN     FMINVT                             91
     C  N91              DO
     C     IMSTAT        IFEQ      'D'
     C                   SETON                                        91
     C                   END                                                    IMSTAT=D
     C                   ENDDO                                                  N91  DO
     C   91              GOTO      NXTBLD
      ** GET THE BALANCE ARRAYS
     C                   Z-ADD     OH            ONH
     C                   Z-SUB     ND            NED
     C                   Z-SUB     SL            SLD
     C                   ADD       SLD           NED
      ** CALC WEEKS
     C                   Z-ADD     0             X                 2 0
     C     NXTX          TAG
     C                   ADD       1             X
     C     X             IFLT      13
     C     PCW(X)        ANDGT     0
     C*          PR,X      IFGT 0
     C*          PR,X      SUB  NED,X     TOT,X
     C*                    ELSE
     C**                   Z-SUBPR,X      WKPR    60
     C*                    Z-SUBNED,X     WKND    60
     C*          PR,X      ADD  WKND      TOT,X
     C*                    END                             PR,X>0
     C*          PR,X      IFEQ 0
     C*                    Z-SUBNED,X     TOT,X
     C*                    END
     C     PR(X)         ADD       NED(X)        TOT(X)
     C*          ONH,X     IFGT 0
     C*          TOT,X     IFGT 0
     C*          ONH,X     SUB  TOT,X     OV,X
     C*                    ELSE
     C     ONH(X)        ADD       TOT(X)        OV(X)
     C*                    END                             TOT,X>0
     C*                    ELSE
     C*                    Z-ADDTOT,X     OV,X
     C*                    END                             TOT,X>0
     C     X             IFLT      12
     C     X             ADD       1             X1                2 0
     C                   Z-ADD     OV(X)         PR(X1)
     C                   END                                                    X<12
     C                   GOTO      NXTX
     C                   END                                                    X<13
      ** PRINT LINE
     C   OF              DO
     C                   EXCEPT    HEAD
     C                   SETOFF                                       OF
     C                   ENDDO                                                  OF  DO
     C                   EXCEPT    DET
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     YEAR          CHAIN     FPOICTL                            LR
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OPIR310    E            HEAD           1 03
     O                                            6 'PIR310'
     O                                           24 'Requested by:'
     O                       USERID              35
     O                                           75 'Poinsettia Spread Sheet'
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HEAD           2
     O                                            9 'Run Date:'
     O                       TDATE         Y     18
     O                                           61 'For Year:'
     O                       YEAR                66
     O                                          111 'Time:'
     O                       TIMOD              120 '  :  :  '
     O          E            HEAD           1
     O                       PCW(12)            120 '  /  /  '
     O                       PCW(11)            111 '  /  /  '
     O                       PCW(10)            102 '  /  /  '
     O                       PCW(9)              93 '  /  /  '
     O                       PCW(8)              84 '  /  /  '
     O                       PCW(7)              75 '  /  /  '
     O                       PCW(6)              66 '  /  /  '
     O                       PCW(5)              57 '  /  /  '
     O                       PCW(4)              48 '  /  /  '
     O                       PCW(3)              39 '  /  /  '
     O                       PCW(2)              30 '  /  /  '
     O                       PCW(1)              21 '  /  /  '
     O                                            5 'Week:'
     O          EF           DET            1
     O                       IMDES1              30
     O          EF           DET            1
     O                       NED(12)       K    120
     O                       NED(11)       K    111
     O                       NED(10)       K    102
     O                       NED(9)        K     93
     O                       NED(8)        K     84
     O                       NED(7)        K     75
     O                       NED(6)        K     66
     O                       NED(5)        K     57
     O                       NED(4)        K     48
     O                       NED(3)        K     39
     O                       NED(2)        K     30
     O                       NED(1)        K     21
     O                                            5 'Need:'
     O          EF           DET            1
     O                       PR(12)        K    120
     O                       PR(11)        K    111
     O                       PR(10)        K    102
     O                       PR(9)         K     93
     O                       PR(8)         K     84
     O                       PR(7)         K     75
     O                       PR(6)         K     66
     O                       PR(5)         K     57
     O                       PR(4)         K     48
     O                       PR(3)         K     39
     O                       PR(2)         K     30
     O                       PR(1)         K     21
     O                                           10 'Prior Bal:'
     O          EF           DET            1
     O                       TOT(12)       K    120
     O                       TOT(11)       K    111
     O                       TOT(10)       K    102
     O                       TOT(9)        K     93
     O                       TOT(8)        K     84
     O                       TOT(7)        K     75
     O                       TOT(6)        K     66
     O                       TOT(5)        K     57
     O                       TOT(4)        K     48
     O                       TOT(3)        K     39
     O                       TOT(2)        K     30
     O                       TOT(1)        K     21
     O                                            6 'Total:'
     O          EF           DET            1
     O                       ONH(12)       K    120
     O                       ONH(11)       K    111
     O                       ONH(10)       K    102
     O                       ONH(9)        K     93
     O                       ONH(8)        K     84
     O                       ONH(7)        K     75
     O                       ONH(6)        K     66
     O                       ONH(5)        K     57
     O                       ONH(4)        K     48
     O                       ONH(3)        K     39
     O                       ONH(2)        K     30
     O                       ONH(1)        K     21
     O                                            8 'On-Hand:'
     O          EF           DET            1
     O                       OV(12)        K    120
     O                       OV(11)        K    111
     O                       OV(10)        K    102
     O                       OV(9)         K     93
     O                       OV(8)         K     84
     O                       OV(7)         K     75
     O                       OV(6)         K     66
     O                       OV(5)         K     57
     O                       OV(4)         K     48
     O                       OV(3)         K     39
     O                       OV(2)         K     30
     O                       OV(1)         K     21
     O                                            4 '+/-'
