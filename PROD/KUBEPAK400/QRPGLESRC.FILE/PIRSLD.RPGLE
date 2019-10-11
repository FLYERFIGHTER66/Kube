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
      **PROGRAM NAME-------- PIRSLD
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- ALLOCATE POINSETTIA CUTTINGS SOLD  CALLED
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  7/18/02 EFD ADD FPOISOW FILE FOR QTY SOLD OF FINISHED GOODS.
      *
     FFMINVT    IF   E           K DISK
     FFMIX      IF   E           K DISK
     FFPOICTL   IF   E           K DISK
     FFPOIITM   UF   E           K DISK
     FFPOISOW   UF   E           K DISK
      *
      * CONTROL FILE DATE ARRAY
     D PCW             S              6  0 DIM(12)                              WEEK DATES
      *
      * BALANCE FILE DATE ARRAY
     D OH              S              7  0 DIM(12)                              ON-HAND
     D ND              S              7  0 DIM(12)                              NEED
     D SL              S              7  0 DIM(12)                              SOLD
      * MIX FILE ARRAYS
     D IT              S             12    DIM(10)                              FILE  ITEM #
     D QT              S              2  0 DIM(10)                              FILE  QTYS
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
      * REDEFINE FILE
     IRMIX
     I              MIITM1                      IT(1)
     I              MIITM2                      IT(2)
     I              MIITM3                      IT(3)
     I              MIITM4                      IT(4)
     I              MIITM5                      IT(5)
     I              MIITM6                      IT(6)
     I              MIITM7                      IT(7)
     I              MIITM8                      IT(8)
     I              MIITM9                      IT(9)
     I              MIIT10                      IT(10)
     I              MIQTY1                      QT(1)
     I              MIQTY2                      QT(2)
     I              MIQTY3                      QT(3)
     I              MIQTY4                      QT(4)
     I              MIQTY5                      QT(5)
     I              MIQTY6                      QT(6)
     I              MIQTY7                      QT(7)
     I              MIQTY8                      QT(8)
     I              MIQTY9                      QT(9)
     I              MIQT10                      QT(10)
      ****************
      * PARMS        *
      ****************
     C     *ENTRY        PLIST
     C                   PARM                    ITEM             12
     C                   PARM                    SIZE              3
     C                   PARM                    SOWDAT            6 0
     C                   PARM                    SOWCYM            7 0
     C                   PARM                    REQCYM            7 0
     C                   PARM                    QTY               7 0
      ** GET YEAR AND WEEK
     C                   MOVE      SOWDAT        YY                2 0
     C     2000          ADD       YY            YEAR              4 0
     C     YEAR          CHAIN     FPOICTL                            90
     C   90              GOTO      END
     C                   Z-ADD     1             W                 4 0
     C     SOWDAT        LOOKUP    PCW(W)                                 90
     C  N90              GOTO      END
      ** GET MINVT RECORD
     C     MINKEY        KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C     MINKEY        CHAIN     FMINVT                             90
     C   90              GOTO      END
      ** GET POIOSW RECORD
     C     SOWKEY        KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C                   KFLD                    SOWCYM
     C     SOWKEY        CHAIN     FPOISOW                            90
     C  N90              DO
     C                   ADD       QTY           PSQSHP
     C                   SUB       QTY           PSQORD
     C                   UPDATE    RPOISOW
     C                   ENDDO                                                   N90  DO
      ** SEE IF MIX
     C     IM#SED        IFEQ      99
     C                   EXSR      GETMIX
     C                   GOTO      END
     C                   END
      ** ONLY 1 ITEM USED
     C     IM#SED        IFLE      0
     C                   Z-ADD     1             IM#SED
     C                   END
     C                   MOVEL     ITEM          PIITEM
     C     ITMKEY        CHAIN     FPOIITM                            58
     C     QTY           MULT      IM#SED        WORK              7 0
     C                   ADD       WORK          SL(W)
     C  N58              UPDATE    RPOIITM
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** MIX SUB ROUTINE   **
      ***********************
     C     GETMIX        BEGSR
     C     MINKEY        CHAIN     FMIX                               90
     C   90              GOTO      ENDMIX
     C                   Z-ADD     1             M                 2 0
     C     NXTMIX        TAG
     C     IT(M)         IFGT      *BLANKS
     C     ITMKEY        KLIST
     C                   KFLD                    YEAR
     C                   KFLD                    PIITEM
     C                   MOVEL     IT(M)         PIITEM
     C     ITMKEY        CHAIN     FPOIITM                            58
     C     QTY           MULT      QT(M)         WORK              7 0
     C                   ADD       WORK          SL(W)
     C  N58              UPDATE    RPOIITM
     C                   END                                                      IT,M>' '
     C                   ADD       1             M
     C     M             IFLE      10
     C                   GOTO      NXTMIX
     C                   END
     C     ENDMIX        TAG
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
