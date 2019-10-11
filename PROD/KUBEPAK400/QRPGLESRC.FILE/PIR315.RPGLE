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
      **PROGRAM NAME-------- PIR315
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- POINSETTIA AVAILABILITY REPORT
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFMINVT    IF   E           K DISK
     FFPOIITMA  IF   E           K DISK
     FFPOICTL   IF   E           K DISK
     FFPOIEXCL  UF A E           K DISK
     FPIR315    O    F  120        PRINTER OFLIND(*INOF)
      *
      * EXCEL FIELDS ARRAY
     D OVX             S              7  0 DIM(12)                              AVAILABLE
      * CONTROL FILE DATE ARRAY
     D PCW             S              6  0 DIM(12)                              WEEK DATES
      * BALANCE FILE ARRAY
     D OH              S              7  0 DIM(12)                              ON-HAND
     D ND              S              7  0 DIM(12)                              NEED
     D SL              S              7  0 DIM(12)                              SOLD
      *
      * SCREEN WORK ARRAY
     D SLD             S              7  0 DIM(12)                              SOLD
     D NED             S              7  0 DIM(12)                              NEED
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
WJB  D  LHIDE0               172    172
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
     IRPOIEXCL
      * EXCEL FILE
     I              PXOV01                      OVX(1)
     I              PXOV02                      OVX(2)
     I              PXOV03                      OVX(3)
     I              PXOV04                      OVX(4)
     I              PXOV05                      OVX(5)
     I              PXOV06                      OVX(6)
     I              PXOV07                      OVX(7)
     I              PXOV08                      OVX(8)
     I              PXOV09                      OVX(9)
     I              PXOV10                      OVX(10)
     I              PXOV11                      OVX(11)
     I              PXOV12                      OVX(12)
      ****************
      *   START HERE *
      ****************
      ** SEE WHAT COLUMNS TO PRINT
     C                   SETOFF                                       010203
     C                   SETOFF                                       040506
     C                   SETOFF                                       070809
     C                   SETOFF                                       101112
     C                   Z-ADD     1             X
     C     NXTPCW        TAG
     C     X             IFLE      12
     C     PCW(X)        IFLE      0
     C                   MOVEL     '1'           *IN(X)
     C                   END                                                    PCW,X=0
     C                   ADD       1             X
     C                   GOTO      NXTPCW
     C                   ENDIF                                                  X<=12
      ** FOR 2002 SET ON 01 TO NOT PRINT 6/24/02
     C                   SETON                                        01
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
WJB  C     OV(12)        IFGE      *ZERO
WJB  C     LHIDE0        OREQ      'N'
WJB  C                   Z-ADD     PIYEAR        PXYEAR
WJB  C                   Z-ADD     PCW(1)        PX1STW
WJB  C                   MOVE      IMDES1        PXDES1
WJB  C                   MOVE      PILOOK        PXLOOK
WJB  C                   MOVEA     OV            OVX
WJB  C                   WRITE     RPOIEXCL
     C                   EXCEPT    DET
WJB  C                   ENDIF
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
     C   99
     CANN99              READ      FPOIEXCL                               99
     C                   ENDSR
      ******************
      * OUTPUT SPECS   *
      ******************
     OPIR315    E            HEAD           1 03
     O                                            6 'PIR315'
     O                                           24 'Requested by:'
     O                       USERID              35
     O                                           75 'Poinsettia Availability'
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
     O              N12      PCW(12)            120 '  /  /  '
     O              N11      PCW(11)            111 '  /  /  '
     O              N10      PCW(10)            102 '  /  /  '
     O              N09      PCW(9)              93 '  /  /  '
     O              N08      PCW(8)              84 '  /  /  '
     O              N07      PCW(7)              75 '  /  /  '
     O              N06      PCW(6)              66 '  /  /  '
     O              N05      PCW(5)              57 '  /  /  '
     O              N04      PCW(4)              48 '  /  /  '
     O              N03      PCW(3)              39 '  /  /  '
     O              N02      PCW(2)              30 '  /  /  '
     O              N01      PCW(1)              21 '  /  /  '
     O                                           13 'Week:'
     O          EF           DET            1
     O                       IMDES1              30
     O              N12      OV(12)        K    120
     O              N11      OV(11)        K    111
     O              N10      OV(10)        K    102
     O              N09      OV(9)         K     93
     O              N08      OV(8)         K     84
     O              N07      OV(7)         K     75
     O              N06      OV(6)         K     66
     O              N05      OV(5)         K     57
     O              N04      OV(4)         K     48
     O              N03      OV(3)         K     39
     O              N02      OV(2)         K     30
     O              N01      OV(1)         K     21
     O**                                  4 '+/-'
