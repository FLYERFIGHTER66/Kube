      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- ARR250
      *APPLICATION--------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- DISPLAY OVERDUE CUSTOMERS
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FARR250FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FFMCUSTAL  IF   E           K DISK
     FFARCTL    IF   E           K DISK
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
      *
     D                UDS
     D  LCO                    1      2  0
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     LCO           CHAIN     FARCTL                             90
     C     ACAGPY        ADD       1             AGE2              3 0
     C     ACAGP2        ADD       1             AGE3              3 0
     C     ACAGP3        ADD       1             AGE4              3 0
     C                   Z-ADD     ACAGP2        AGP3              3 0
      *
     C     RSTRTA        TAG
     C                   SETOFF                                       101112
     C                   SETOFF                                       13
     C                   Z-ADD     0             DAYS
     C                   Z-ADD     0             TOTCUR
     C                   Z-ADD     0             TOTAR1
     C                   Z-ADD     0             TOTAR2
     C                   Z-ADD     0             TOTAR3
     C*                    Z-ADD0         TOTAR4
     C                   Z-ADD     0             TOTAR
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       20
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
      *
     C     DAYS          IFGT      ACAGP4
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     DAYS          IFEQ      0
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     DAYS          IFLT      ACAGPY
     C                   SETON                                        10
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     DAYS          IFLT      ACAGP2
     C                   SETON                                        11
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     DAYS          IFLT      ACAGP3
     C                   SETON                                        12
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     DAYS          IFLE      ACAGP4
     C                   SETON                                        13
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     NXTB          TAG
     C                   MOVEL     *BLANKS       CUST             15
     C     CUST          SETLL     FMCUSTAL
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
     C     RSTRTB        TAG
     C                   SETOFF                                       90
     C     NXTC          TAG
     C                   Z-ADD     0             AR3$
     C                   READ      FMCUSTAL                               90
     C   90              GOTO      DSPL
      *
     C     CMCOMP        IFNE      LCO
     C                   GOTO      RSTRTB
     C                   ENDIF
      *
     C     CMSTAT        IFEQ      'D'
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C     CMARB$        IFEQ      0
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C     CMAR1$        ADD       CMAR2$        AGE1T            11 2
     C                   ADD       CMAR3$        AGE1T
     C                   ADD       CMAR4$        AGE1T
     C     CMAR2$        ADD       CMAR3$        AGE2T            11 2
     C                   ADD       CMAR4$        AGE2T
     C     CMAR3$        ADD       CMAR4$        AGE3T            11 2
      *
     C   10AGE1T         IFLE      0
     C                   GOTO      NXTC
     C                   ENDIF
     C   11AGE2T         IFLE      0
     C                   GOTO      NXTC
     C                   ENDIF
     C   12AGE3T         IFLE      0
     C                   GOTO      NXTC
     C                   ENDIF
     C   13CMAR4$        IFLE      0
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C                   MOVEL     CMNAME        NAME
     C                   Z-ADD     CMCUR$        ARCUR
     C                   Z-ADD     CMAR1$        AR1$
     C                   Z-ADD     CMAR2$        AR2$
     C                   ADD       CMAR3$        AR3$
     C                   ADD       CMAR4$        AR3$
     C                   Z-ADD     CMARB$        ARB$
      *
     C                   ADD       CMCUR$        TOTCUR            8 2
     C                   ADD       CMAR1$        TOTAR1            8 2
     C                   ADD       CMAR2$        TOTAR2            8 2
     C                   ADD       CMAR3$        TOTAR3            8 2
     C                   ADD       CMAR4$        TOTAR3
     C                   ADD       CMARB$        TOTAR             9 2
      *
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   GOTO      NXTC
      *
     C     DSPL          TAG
     C                   ADD       2             RECNO
     C                   Z-ADD     0             CMCUST
     C                   MOVEL     *BLANKS       NAME
     C                   MOVEL     '** Total'    DESC1            16
     C                   MOVE      's **    '    DESC1
     C                   MOVE      DESC1         NAME
     C                   Z-ADD     TOTCUR        ARCUR
     C                   Z-ADD     TOTAR1        AR1$
     C                   Z-ADD     TOTAR2        AR2$
     C                   Z-ADD     TOTAR3        AR3$
     C*                    Z-ADDTOTAR4    AR4$
     C                   Z-ADD     TOTAR         ARB$
     C                   WRITE     RECSFL
     C                   EXFMT     RECCTL
     C   KC
     COR KG              GOTO      END
     C                   GOTO      RSTRTA
      *
     C     END           TAG
     C                   SETON                                        LR
      *
