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
      **PROGRAM NAME-------- PIR230
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- UPDATE WEEKLY POINSETTIA AVAILABILTY
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FPIR230FM  CF   E             WORKSTN
     F                                     SFILE(AVLSFL:RECNO)
     FFMINVT    IF   E           K DISK
     FFCALEN    IF   E           K DISK
     FFCALEX    IF   E           K DISK
     F                                     RENAME(RCALEN:ICALEN)
     FFPOICTL   IF   E           K DISK
     FFPOIITMA  IF   E           K DISK
     F                                     RENAME(RPOIITM:POIITM)
     FFPOIITM   UF   E           K DISK
      *
      * CONTROL FILE DATE ARRAY
     D PCW             S              6  0 DIM(12)                              WEEK DATES
      *
      * BALANCE FILE DATE ARRAY
     D OH              S              7  0 DIM(12)                              ON-HAND
     D ND              S              7  0 DIM(12)                              NEED
     D SL              S              7  0 DIM(12)                              SOLD
      *
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
     I              PISL12                      SL(12)
      *
      * RENAME BALANCE LOGICAL FILE
     IPOIITM
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
      ***********************
      ** START OR RESTART  **
      ***********************
     C     RSTART        TAG
     C                   Z-ADD     0             FRMDAT
     C                   Z-ADD     0             BEGYY
     C                   Z-ADD     0             BEGWW
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
     C                   SETOFF                                       9899
      ** DISPLAY SCREEN
     C     NXTA          TAG
     C   99              SETOFF                                       98
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   GOTO      END
     C                   ENDDO
     C                   SETOFF                                       102030
     C                   SETOFF                                       405011
     C                   SETOFF                                       1299
      ** CHECK INPUT
      **
      ** CHECK DATE
     C     FRMDAT        IFLE      0
     C     BEGYY         ANDLE     0
     C     BEGWW         ANDLE     0
     C                   SETON                                        10  99
     C                   GOTO      NXTA
     C                   ENDIF
      **
     C     FRMDAT        IFGT      0
     C                   Z-ADD     FRMDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   SETOFF                                       90
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        90
     C                   END
     C  N90              CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        90
     C                   END
     C  N90              Z-ADD     ##CYMD        STRDAT            7 0
     C  N90              CALL      '@DAYWK'
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    #Y                1 0          DAY OF WEEK
     C   90              DO
     C                   SETON                                        1099
     C                   GOTO      NXTA
     C                   ENDDO
     C     #Y            IFNE      1
     C                   SETON                                        101199
     C                   GOTO      NXTA
     C                   END
     C     FRMDAT        CHAIN     FCALEN                             92
     C                   MOVEL     CLCENT        BEGYY
     C                   MOVE      CLYEAR        BEGYY
     C                   Z-ADD     CLWEEK        BEGWW
     C                   ELSE                                                   FRMDAT > 0
     C                   MOVEL     BEGYY         CLCENT
     C                   MOVE      BEGYY         CLYEAR
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    BEGWW
     C                   KFLD                    CL#Y
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             92
     C   92              DO
     C                   SETON                                        2099
     C                   GOTO      NXTA
     C                   ENDDO
     C                   Z-ADD     CLDATE        FRMDAT
     C                   Z-ADD     FRMDAT        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   SETOFF                                       90
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        90
     C                   END
     C  N90              CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        STRDAT            7 0
     C                   END                                                    FRMDAT > 0
      ** CHECK IF IN RANGE OF CONTROL FILE WEEKS
     C                   MOVE      FRMDAT        YY                2 0
     C     2000          ADD       YY            YEAR              4 0
     C     YEAR          CHAIN     FPOICTL                            12
     C  N12              DO
     C                   Z-ADD     1             W                 4 0
     C     FRMDAT        LOOKUP    PCW(W)                                 90
     C  N90              SETON                                        12
     C                   ENDDO
     C   12              DO
     C                   SETON                                        1099
     C                   GOTO      NXTA
     C                   ENDDO
      ** IF FIRST TIME REDISPLAY
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTA
     C                   END
     C                   SETOFF                                       98
      *** BUILD SUB FILE
     C     RSTRTB        TAG
     C                   EXSR      BLDSFL
     C     NXTB          TAG
     C   99              SETOFF                                       98
     C                   SETOFF                                       23
     C                   EXFMT     AVLCTL
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
      ** VERIFY SCREEN
     C  N98              DO
     C                   SETON                                        98
     C                   GOTO      NXTB
     C                   END
      ** IF OK UPDATE FILE
     C   KA              DO
     C                   EXSR      PUTSFL
     C                   GOTO      RSTART
     C                   ENDDO
      ** IF NOT F1 REDISPLAY SCREEN
     C                   GOTO      NXTB
      *** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** BUILD SUB FILE    **
      ***********************
     C     BLDSFL        BEGSR
     C                   MOVEL     '1'           *IN(80)
     C                   WRITE     AVLCTL
     C                   MOVEL     '01'          *IN(80)
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             LSTOLD            5 0
     C                   SETOFF                                       18
     C     YEAR          SETLL     FPOIITMA
     C     NXTBLD        TAG
     C     YEAR          READE(N)  FPOIITMA                               90
     C   90              GOTO      ENDBLD
     C                   MOVEL     'CUT'         VSIZE             3
     C     IMKEY         KLIST
     C                   KFLD                    PIITEM
     C                   KFLD                    VSIZE
     C     IMKEY         CHAIN     FMINVT                             91
     C                   Z-ADD     ND(W)         QTYAL
     C                   Z-ADD     OH(W)         NEWQTY
     C                   Z-ADD     OH(W)         QTYOH
     C                   Z-ADD     OH(W)         OLDQTY
     C                   ADD       1             RECNO
     C                   WRITE     AVLSFL
     C                   Z-ADD     RECNO         LSTOLD
     C                   GOTO      NXTBLD
      ** END OF BUILD ROUTINE
     C     ENDBLD        TAG
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ENDSR
      ***********************
      **   PUT SUB FILE    **
      ***********************
     C     PUTSFL        BEGSR
     C                   Z-ADD     0             RECNO
     C     NXTPUT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPUT
     C                   END
     C     RECNO         CHAIN     AVLSFL                             90
     C   90              GOTO      NXTPUT
     C     NEWQTY        IFEQ      OLDQTY
     C                   GOTO      NXTPUT
     C                   END
      ** UPDATE RECORD
     C     ITMKEY        KLIST
     C                   KFLD                    YEAR
     C                   KFLD                    PIITEM
     C     ITMKEY        CHAIN     FPOIITM                            91
     C  N91              DO
     C                   Z-ADD     NEWQTY        OH(W)
     C                   Z-ADD     TDATE         PIDTLA
     C                   Z-ADD     TIMOD         PITIME
     C                   MOVEL     USERID        PIUSER
     C                   UPDATE    RPOIITM
     C                   ENDDO                                                      N91  DO
     C                   GOTO      NXTPUT
     C     ENDPUT        TAG
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
      ****
