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
      **PROGRAM NAME-------- PUR050
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CREATE TRUCK WORK FILE
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  2/15/02 EFD DO NOT ASSIGN STOPS.   PER BILL
      * 11/07/02 EFD ADD SIZE 105.
      *
     FFHORDRCD  IF   E           K DISK
     F                                     RENAME(RHORDR:HORDR)
     FFIORDR    IF   E           K DISK
     FFCALENCY  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFPUSTAT   UF A E           K DISK
     FFPUUCKS   O    E           K DISK
     FFPUUCKO   O    E           K DISK
      *
      ** MCUST ARRAYS
     D RT              S              2    DIM(7)                               ROUTE M THR S
     D ST              S              3  0 DIM(7)                               STOP #
      *
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
     D  LCO                    1      2  0                                      ARC380
     D  BEGDT                  3      8  0                                      ARC380
     D  ENDDT                  9     14  0                                      ARC380
     D  YEAR                  15     18  0                                      ARC380
     D  WEEK                  19     20  0                                      ARC380
      *
     IRMCUST
     I              CMRTE1                      RT(1)
     I              CMRTE2                      RT(2)
     I              CMRTE3                      RT(3)
     I              CMRTE4                      RT(4)
     I              CMRTE5                      RT(5)
     I              CMRTE6                      RT(6)
     I              CMRTE7                      RT(7)
     I              CMSTP1                      ST(1)
     I              CMSTP2                      ST(2)
     I              CMSTP3                      ST(3)
     I              CMSTP4                      ST(4)
     I              CMSTP5                      ST(5)
     I              CMSTP6                      ST(6)
     I              CMSTP7                      ST(7)
      *****************
      ** START HERE  **
      *****************
      *
     C                   Z-ADD     1             SEQ               6 0
     C*                  Z-ADD     0             OCUST             6 0
     C                   Z-ADD     0             ORDER             6 0
     C     BEGCYM        SETLL     FHORDRCD
      *
     C     NXT           TAG
     C                   READ      FHORDRCD                               90
     C   90              GOTO      END
     C*    OHCUST        IFNE      OCUST
     C*    OCUST         IFGT      0
     C     OHORD#        IFNE      ORDER
     C     ORDER         IFGT      0
     C                   EXSR      GETTOT
     C                   Z-ADD(H)  FLATS         TSQTY1
     C                   Z-ADD     0             FLATS             6 0
     C     TSSVIA        IFNE      '01'
     C                   Z-ADD(H)  CARTS         TSQTY3
     C     TOTCRT        IFGT      *ZERO
     C     TOTCRT        DIV       1             CART30            3 0
     C                   MVR                     MORE              2 2
     C     MORE          IFGT      0
     C                   ADD       1             CART30
     C                   ENDIF
     C                   ENDIF
TEST C                   Z-ADD(H)  CART30        TSQTY3
TEST C                   Z-ADD     *ZERO         TOTCRT
     C                   END
     C                   Z-ADD     BEGCYM        TSSCHD
     C                   Z-ADD     BEGCYM        TSSHPD
     C                   ADD       1             SEQ
     C                   Z-ADD     SEQ           TSSEQ#
TEST C                   Z-ADD     TOSEQ#        TSSEQ#
     C*                  Z-ADD     0             OCUST
     C                   Z-ADD     0             ORDER
     C                   WRITE     RPUUCKS
     C                   CLEAR                   RPUUCKS
     C                   END
     C     OHCUST        CHAIN     FMCUST                             70
      ** 3/07/02 DO NOT UPDATE ROUT FROM CUST PER BILL
     C                   GOTO      NOROUT
      ** GET ROUT AND STOP
     C                   Z-ADD     1             X                 2 0
     C     NXTX          TAG
     C     RT(X)         IFGT      *BLANKS
     C                   Z-ADD     X             TSDAY#
     C                   MOVEL     RT(X)         TSROUT
     C**                   Z-ADDST,X      TSSTOP
     C                   ELSE
     C                   ADD       1             X
     C     X             IFLE      7
     C                   GOTO      NXTX
     C                   END
     C                   END
     C     NOROUT        TAG
     C                   Move      OHROUT        TSROUT
     C                   END
     C     OHDTRY        IFGT      ENDCYM
     C                   GOTO      END
     C                   END
     C     OHSTAT        IFEQ      'D'
     C     OHCOFL        OREQ      'Y'
     C                   GOTO      NXT
     C                   END
      ** IF HERE I NEED THIS RECORD
      ** GET COMMON SHIP VIA
     C     OHSHPC        IFNE      '01'
     C                   MOVEL     OHSHPC        TSSVIA
     C                   Eval      TSDAY# = 1
     C                   Eval      TSROUT = OHSHPC
     C                   GOTO      SVOK
     C                   END
     C*    OHSHPC        IFEQ      '05'
     C*    OHSHPC        OREQ      '12'
     C*                  MOVEL     '05'          TSSVIA
     C*                  GOTO      SVOK
     C*                  END
     C*    OHSHPC        IFEQ      '15'
     C*                  MOVEL     '15'          TSSVIA
     C*                  GOTO      SVOK
     C*                  END
     C*    OHSHPC        IFEQ      '17'
     C*    OHSHPC        OREQ      '24'
     C*    OHSHPC        OREQ      '29'
     C*                  MOVEL     '24'          TSSVIA
     C*                  GOTO      SVOK
     C*                  END
     C*    OHSHPC        IFEQ      '18'
     C*                  MOVEL     '18'          TSSVIA
     C*                  GOTO      SVOK
     C*                  END
     C*    OHSHPC        IFEQ      '28'
     C*                  MOVEL     '28'          TSSVIA
     C*                  GOTO      SVOK
     C*                  END
     C*    OHSHPC        IFEQ      '30'
     C*                  MOVEL     '30'          TSSVIA
     C*                  GOTO      SVOK
     C*                  END
      ** IF HERE SHIP VIA NOT NEEDED
     C                   GOTO      NXT
      ** IF HERE SHIP VIA NEEDED
     C     SVOK          TAG
     C                   EXSR      CLCCRT
      ** CHECK IF LINE NEEDED
     C     FLATS         IFLE      0.0
     C     CARTS         ANDLE     0.0
     C                   GOTO      NXT
     C                   END
      ** NOW OUTPUT FILE
     C                   Z-ADD     YEAR          TSYEAR
     C                   Z-ADD     WEEK          TSWEEK
     C                   MOVEL     OHSHPC        TSOVIA
     C                   Z-ADD     OHCUST        TSCUST
     C                   MOVEL     OHSHZP        TSZIP
     C                   MOVEL     OHALPH        TSLOOK
     C                   Z-ADD     OHORD#        TSORD#
     C                   Z-ADD     OHORD#        ORDER
     C                   Z-ADD     BEGCYM        TOSHPD
     C                   Z-ADD     SEQ           TOSEQ#
     C                   Z-ADD     OHORD#        TOORD#
     C                   WRITE     RPUUCKO
     C                   ADD       1             TS#ORD
     C                   GOTO      NXT
      ** END PROGRAM
     C     END           TAG
     C     ORDER         IFGT      0
     C                   EXSR      GETTOT
     C                   Z-ADD(H)  FLATS         TSQTY1
      ** TEST FOR MIN .1 CARTS DONE IN CALC CARTS
     C     TOTCRT        IFGT      *ZERO
     C     TOTCRT        DIV       1             CART30
     C                   MVR                     MORE              2 2
     C     MORE          IFGT      0
     C                   ADD       1             CART30
     C                   ENDIF
     C                   ENDIF
     C                   Z-ADD(H)  CART30        TSQTY3
TEST C                   Z-ADD     *ZERO         TOTCRT            5 2
     C                   Z-ADD     BEGCYM        TSSCHD
     C                   Z-ADD     BEGCYM        TSSHPD
     C                   ADD       1             SEQ
     C                   Z-ADD     SEQ           TSSEQ#
TEST C     TSQTY3        IFGT      *ZERO
     C                   WRITE     RPUUCKS
TEST C                   ENDIF
     C                   CLEAR                   RPUUCKS
     C*                  Z-ADD     0             OCUST
     C                   Z-ADD     0             ORDER
     C                   END
     C     BEGCYM        CHAIN     FPUSTAT                            91
     C   91              CLEAR                   RPUSTAT
     C                   Z-ADD     BEGCYM        STSHDT
     C                   MOVEL     'Y'           STBLDR
     C                   Z-ADD     TDATE         STBLDD
     C                   Z-ADD     TSSEQ#        STNSEQ
     C                   Z-ADD     TIMOD         STBLDT
     C                   MOVEL     USERID        STBLDU
     C                   ADD       1             SEQ
     C                   Z-ADD     SEQ           STNSEQ
     C   91              WRITE     RPUSTAT
     C  N91              UPDATE    RPUSTAT
     C                   SETON                                        LR
      *
      ***********************
      ** CALCULATE CARTS   **
      ***********************
     C     CLCCRT        BEGSR
     C     OHORD#        SETLL     FIORDR
     C     NXTIOR        TAG
     C     OHORD#        READE     FIORDR                                 91
     C   91              GOTO      ENDIOR
     C     OIQORD        SUB       OIQSHP        OPEN              7 2
     C     OIITYP        IFNE      ' '
     C     OISTAT        OREQ      'D'
WJB  C     OIRVDT        ORNE      BEGCYM
     C     OPEN          ORLE      0
     C                   GOTO      NXTIOR
     C                   END
     C     OISIZE        IFEQ      '512'
     C                   ADD       OPEN          T512
     C                   END
     C     OISIZE        IFEQ      '288'
     C                   ADD       OPEN          T288
     C                   END
     C     OISIZE        IFEQ      '162'
     C                   ADD       OPEN          T162
     C                   END
     C     OISIZE        IFEQ      '84 '
     C     OISIZE        OREQ      '105'
     C                   ADD       OPEN          T84
     C                   END
     C     OISIZE        IFEQ      '48 '
     C                   ADD       OPEN          T48
     C                   END
     C                   ADD       OPEN          FLATS
     C                   GOTO      NXTIOR
     C     ENDIOR        TAG
TEST C                   Z-ADD     *ZERO         #CARTS            5 2
     C                   CALL      'BIR103'
     C                   PARM                    NWRVDT
     C                   PARM                    OHORD#
TEST C     #CARTS        PARM                    CARTS3            5 2
     C                   PARM                    SHOWYN            1
TEST C                   ADD       #CARTS        TOTCRT
     C                   ENDSR
      ***********************
      ** CALCULATE TOTAL   **
      ***********************
     C     GETTOT        BEGSR
     C                   Z-ADD     0             CARTS            10 4
      ** NOW GET CARTS IF SHIP VIA TRUCK
     C     TSSVIA        IFEQ      '01'
     C     T512          DIV(H)    60            WK512            10 4
     C     T288          DIV(H)    60            WK288            10 4
     C     T162          DIV(H)    45            WK162            10 4
     C     T84           DIV(H)    45            WK84             10 4
     C     T48           DIV(H)    45            WK48             10 4
     C     WK512         ADD       WK288         CARTS
     C                   ADD       WK162         CARTS
     C                   ADD       WK84          CARTS
     C                   END
     C                   MOVE      CARTS         TST1              4 4
     C     1             SUB       TST1          WRK1              4 4
     C                   ADD       WRK1          CARTS
     C                   Z-ADD     0             T512              6 0
     C                   Z-ADD     0             T288              6 0
     C                   Z-ADD     0             T162              6 0
     C                   Z-ADD     0             T84               6 0
     C                   Z-ADD     0             T48               6 0
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   Z-ADD     BEGDT         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        BEGCYM            7 0
     C                   Z-ADD     0             YEAR
     C                   Z-ADD     0             WEEK
     C     BEGCYM        CHAIN     FCALENCY                           70
     C                   MOVEL     CLCENT        YEAR
     C                   MOVE      CLYEAR        YEAR
     C                   Z-ADD     CLWEEK        WEEK
     C                   Z-ADD     ENDDT         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        ENDCYM            7 0
WJB  C     OIRVDT        SUB       1000000       NWRVDT            6 0
WJB  C                   MULT      100.0001      NWRVDT
WJB  C                   Z-ADD     BEGDT         NWRVDT
WJB  C   U1              MOVE      'Y'           SHOWYN
WJB  C  NU1              MOVE      'N'           SHOWYN
     C                   ENDSR
