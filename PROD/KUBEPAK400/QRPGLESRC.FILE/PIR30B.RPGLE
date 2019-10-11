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
      **PROGRAM NAME-------- PIR30B
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- POINSETTIA SPREAD SHEET BROKER VERSION
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FPIR30BFM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFMINVT    IF   E           K DISK
     FFPOIITMA  IF   E           K DISK
     FFPOICTL   IF   E           K DISK
      *
      * CONTROL FILE DATE ARRAY
     D PCW             S              6  0 DIM(12)                              WEEK DATES
      * BALANCE FILE ARRAY
     D OH              S              7  0 DIM(12)                              ON-HAND
     D ND              S              7  0 DIM(12)                              NEED
     D SL              S              7  0 DIM(12)                              SOLD
      *
      * SCREEN WORK ARRAY
     D NED             S              6  0 DIM(12)                              NEED
     D SLD             S              6  0 DIM(12)                              SOLD
     D PR              S              6  0 DIM(12)                              PRIOR
     D TOT             S              6  0 DIM(12)                              TOTAL
     D ONH             S              6  0 DIM(12)                              ON-HAND
     D OV              S              6  0 DIM(12)                              +/-
     D IN              S              1    DIM(15)                              START WORD
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
     C     RSTART        TAG
     C                   SETON                                        01
     C                   EXSR      BLDSFL
     C                   Z-ADD     1             PAGE#
     C     NXTSFL        TAG
     C                   EXFMT     RECCTL
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              GOTO      END
     C   KA              DO
     C                   SETON                                        01
     C                   EXSR      BLDSFL
     C                   END
     C   KI              DO
     C                   SETOFF                                       01
     C                   EXSR      BLDSFL
     C                   END
      ** CHECK START WITH
     C     STRTW         IFGT      *BLANKS
     C                   EXSR      GETPAG
     C                   GOTO      NXTSFL
     C                   END
      ** GOTO NXTSFL
     C                   GOTO      NXTSFL
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** GET START PAGE    **
      ***********************
     C     GETPAG        BEGSR
     C                   Z-ADD     1             PAGE#
     C                   Z-ADD     0             RECNO
     C                   MOVEA     STRTW         IN
     C                   Z-ADD     0             X                 2 0
     C     NXTX1         TAG
     C                   ADD       1             X
     C     X             IFLT      16
     C     IN(X)         IFGT      *BLANK
     C                   GOTO      NXTX1
     C                   END
     C                   SUB       1             X
     C                   END
      ** READ THE SUBFILE
     C     NXTPAG        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPAG
     C                   END
     C     RECNO         CHAIN     RECSFL                             90
     C   90              GOTO      NXTPAG
     C     STRTW:X       SCAN      IMDES1                                 89
     C  N89              GOTO      NXTPAG
     C                   Z-ADD     RECNO         PAGE#
     C     ENDPAG        TAG
     C                   ENDSR
      ***********************
      ** BUILD SUB FILE    **
      ***********************
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     RECCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
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
      ** CALC WEEKS
     C                   Z-ADD     0             X                 2 0
     C     NXTX          TAG
     C                   ADD       1             X
     C     X             IFLT      13
     C     PR(X)         ADD       NED(X)        TOT(X)
     C                   ADD       SLD(X)        TOT(X)
     C     ONH(X)        ADD       TOT(X)        OV(X)
     C     X             IFLT      12
     C     X             ADD       1             X1                2 0
     C                   Z-ADD     OV(X)         PR(X1)
     C                   END                                                    X<12
     C                   GOTO      NXTX
     C                   END                                                    X<13
      ** NOW MOVE INTO SCREEN FIELDS
     C   01              Z-ADD     1             X
     C  N01              Z-ADD     4             X
     C     OV(X)         IFGT      0
     C                   Z-ADD     OV(X)         OVER1
     C                   ELSE
     C                   Z-ADD     0             OVER1
     C                   END
     C                   ADD       1             X
     C     OV(X)         IFGT      0
     C                   Z-ADD     OV(X)         OVER2
     C                   ELSE
     C                   Z-ADD     0             OVER2
     C                   END
     C                   ADD       1             X
     C     OV(X)         IFGT      0
     C                   Z-ADD     OV(X)         OVER3
     C                   ELSE
     C                   Z-ADD     0             OVER3
     C                   END
     C                   ADD       1             X
     C     OV(X)         IFGT      0
     C                   Z-ADD     OV(X)         OVER4
     C                   ELSE
     C                   Z-ADD     0             OVER4
     C                   END
     C                   ADD       1             X
     C     OV(X)         IFGT      0
     C                   Z-ADD     OV(X)         OVER5
     C                   ELSE
     C                   Z-ADD     0             OVER5
     C                   END
     C                   ADD       1             X
     C     OV(X)         IFGT      0
     C                   Z-ADD     OV(X)         OVER6
     C                   ELSE
     C                   Z-ADD     0             OVER6
     C                   END
     C                   ADD       1             X
     C     OV(X)         IFGT      0
     C                   Z-ADD     OV(X)         OVER7
     C                   ELSE
     C                   Z-ADD     0             OVER7
     C                   END
     C                   ADD       1             X
     C     OV(X)         IFGT      0
     C                   Z-ADD     OV(X)         OVER8
     C                   ELSE
     C                   Z-ADD     0             OVER8
     C                   END
     C                   ADD       1             X
     C     OV(X)         IFGT      0
     C                   Z-ADD     OV(X)         OVER9
     C                   ELSE
     C                   Z-ADD     0             OVER9
     C                   END
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   GOTO      NXTBLD
     C     ENDBLD        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C   01              Z-ADD     1             X
     C  N01              Z-ADD     4             X
     C                   MOVEL     PCW(X)        DATE1
     C                   ADD       1             X
     C                   MOVEL     PCW(X)        DATE2
     C                   ADD       1             X
     C                   MOVEL     PCW(X)        DATE3
     C                   ADD       1             X
     C                   MOVEL     PCW(X)        DATE4
     C                   ADD       1             X
     C                   MOVEL     PCW(X)        DATE5
     C                   ADD       1             X
     C                   MOVEL     PCW(X)        DATE6
     C                   ADD       1             X
     C                   MOVEL     PCW(X)        DATE7
     C                   ADD       1             X
     C                   MOVEL     PCW(X)        DATE8
     C                   ADD       1             X
     C                   MOVEL     PCW(X)        DATE9
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C*          TDATE     CHAINFCALEN               90
     C*          CALKEY    KLIST
     C*                    KFLD           CLCENT
     C*                    KFLD           CLYEAR
     C*                    KFLD           CLWEEK
     C*                    KFLD           CL#Y
     C*                    Z-ADD1         CL#Y
     C*          CALKEY    CHAINFCALEX               90
     C*                    Z-ADDCLCYMD    FIRST   70
      ** GET THE YEAR
     C                   MOVE      TDATE         YY                2 0
     C     2000          ADD       YY            YEAR              4 0
     C     YEAR          CHAIN     FPOICTL                            LR
     C                   ENDSR
