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
      **PROGRAM NAME-------- PIRFXITM
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- MOVE ARRAYS IN FPOIITM
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFPOIITM   UF   E           K DISK
      * BALANCE FILE DATE ARRAY
     D OH              S              7  0 DIM(12)                              ON-HAND
     D ND              S              7  0 DIM(12)                              NEED
     D SL              S              7  0 DIM(12)                              SOLD
     D PT              S              7  0 DIM(12)                              PRINTED
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
      * PRINTED ON LAST REPORT
     I              PIPT1                       PT(1)
     I              PIPT2                       PT(2)
     I              PIPT3                       PT(3)
     I              PIPT4                       PT(4)
     I              PIPT5                       PT(5)
     I              PIPT6                       PT(6)
     I              PIPT7                       PT(7)
     I              PIPT8                       PT(8)
     I              PIPT9                       PT(9)
     I              PIPT10                      PT(10)
     I              PIPT11                      PT(11)
     I              PIPT12                      PT(12)
      ***********************
      ** READ POIITEM FILE
      ***********************
     C     NXT           TAG
     C                   READ      FPOIITM                                90
     C   90              GOTO      END
      ***********************
      ** MOVE ARRAYS   START AT 12 AND MOVE BACKWARD 11-12 10-11
      ***********************
     C                   Z-ADD     11            X                 5 0
     C                   Z-ADD     12            X1                5 0
     C     NXTX          TAG
     C     X             IFGT      0
     C                   Z-ADD     OH(X)         OH(X1)
     C                   Z-ADD     ND(X)         ND(X1)
     C                   Z-ADD     SL(X)         SL(X1)
     C                   Z-ADD     PT(X)         PT(X1)
     C                   SUB       1             X
     C                   SUB       1             X1
     C                   GOTO      NXTX
     C                   END                                                    X>0
      ** ZERO OUT COLUMN 1
     C                   Z-ADD     0             OH(1)
     C                   Z-ADD     0             ND(1)
     C                   Z-ADD     0             SL(1)
     C                   Z-ADD     0             PT(1)
     C                   UPDATE    RPOIITM
     C                   GOTO      NXT
      *** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
