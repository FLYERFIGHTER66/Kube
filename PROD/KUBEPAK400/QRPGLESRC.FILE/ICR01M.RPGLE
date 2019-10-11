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
      **PROGRAM NAME-------- ICR012
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- UPDATE MIX FILE       CALLED
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FICR01MFM  CF   E             WORKSTN
     FFMINVT    IF   E           K DISK
     FFMIX      UF A E           K DISK
      *
      * SCREEN ARRAYS
     D ITM             S              5    DIM(10)                              SCREEN ITEM #
     D QTY             S              2  0 DIM(10)                              SCREEN QTYS
     D DES             S             30    DIM(10)                              SCREEN DESC
      * FILE ARRAYS
     D IT              S             12    DIM(10)                              FILE  ITEM #
     D QT              S              2  0 DIM(10)                              FILE  QTYS
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
      * REDEFINE SCREEN
     ISCRNA
     I              ITM1                        ITM(1)
     I              ITM2                        ITM(2)
     I              ITM3                        ITM(3)
     I              ITM4                        ITM(4)
     I              ITM5                        ITM(5)
     I              ITM6                        ITM(6)
     I              ITM7                        ITM(7)
     I              ITM8                        ITM(8)
     I              ITM9                        ITM(9)
     I              ITM10                       ITM(10)
     I              QTY1                        QTY(1)
     I              QTY2                        QTY(2)
     I              QTY3                        QTY(3)
     I              QTY4                        QTY(4)
     I              QTY5                        QTY(5)
     I              QTY6                        QTY(6)
     I              QTY7                        QTY(7)
     I              QTY8                        QTY(8)
     I              QTY9                        QTY(9)
     I              QTY10                       QTY(10)
     I              DESC1                       DES(1)
     I              DESC2                       DES(2)
     I              DESC3                       DES(3)
     I              DESC4                       DES(4)
     I              DESC5                       DES(5)
     I              DESC6                       DES(6)
     I              DESC7                       DES(7)
     I              DESC8                       DES(8)
     I              DESC9                       DES(9)
     I              DESC10                      DES(10)
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
      *   PARMS      *
      ****************
     C     *ENTRY        PLIST
     C                   PARM                    ITEM             12
     C                   PARM                    SIZE              3
      ***********************
      ** GET MASTER ITEM   **
      ***********************
     C     RSTART        TAG
     C                   UNLOCK    FMIX
     C     MINKEY        KLIST
     C                   KFLD                    ITEM
     C                   KFLD                    SIZE
     C     MINKEY        CHAIN     FMINVT                             LR
     C                   MOVEL     IMDES1        MDESC
     C     MINKEY        CHAIN     FMIX                               95
     C   95              DO
     C                   MOVE      *BLANKS       ITM
     C                   MOVE      *BLANKS       DES
     C                   Z-ADD     0             QTY
     C                   CLEAR                   RMIX
     C                   MOVEL     ITEM          MIITEM
     C                   MOVEL     SIZE          MISIZE
     C                   ENDDO                                                  95 DO
     C  N95              DO
     C                   MOVEL     IT(1)         ITM(1)
     C                   MOVEL     IT(2)         ITM(2)
     C                   MOVEL     IT(3)         ITM(3)
     C                   MOVEL     IT(4)         ITM(4)
     C                   MOVEL     IT(5)         ITM(5)
     C                   MOVEL     IT(6)         ITM(6)
     C                   MOVEL     IT(7)         ITM(7)
     C                   MOVEL     IT(8)         ITM(8)
     C                   MOVEL     IT(9)         ITM(9)
     C                   MOVEL     IT(10)        ITM(10)
     C                   Z-ADD     QT            QTY
     C                   EXSR      GETDES
     C                   ENDDO                                                  N95 DO
      ** OUTPUT SCREEN
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              GOTO      END
      ** CHECK FOR SEARCH
     C                   Z-ADD     1             X
     C     NXTAS         TAG
     C                   MOVEL     ITM(X)        TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   MOVE      ITM(X)        ITM4              4
     C                   MOVEL     ITM4          IMLOOK
     C                   MOVEL     'CUT'         IMSIZE
     C                   CALL      'LKITAL'
     C                   PARM                    IMLOOK
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMDES1
     C                   PARM                    IMDES2
     C                   PARM                    IMDES3
     C                   PARM                    IMDES4
     C                   PARM                    SHPFR             3
     C                   MOVEL     IMITEM        ITM(X)
     C                   END                                                    TST1=? /
     C                   ADD       1             X
     C     X             IFLE      10
     C                   GOTO      NXTAS
     C                   END
      ** CHECK SCREEN
     C                   EXSR      GETDES
     C   99              GOTO      NXTA
     C   98              GOTO      NXTA
      ** IF HERE OK
     C   95              WRITE     RMIX
     C  N95              UPDATE    RMIX
      ** END OF JOB
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** GET SCREEN DESC   **
      ***********************
     C     GETDES        BEGSR
     C                   MOVEA     '00000000'    *IN(10)
     C                   MOVEA     '00000000'    *IN(18)
     C                   MOVEA     '00000000'    *IN(27)
     C                   MOVEA     '00000000'    *IN(35)
     C                   MOVE      '0'           *IN(40)
     C                   MOVE      *BLANKS       DES
     C                   SETOFF                                       999841
     C                   Z-ADD     0             X                 4 0
     C     NXTGD         TAG
     C                   ADD       1             X
     C     X             IFLE      10
     C     ITM(X)        IFGT      *BLANKS
     C     ITM(X)        IFEQ      MIITEM
     C                   SETON                                        4099
     C                   GOTO      NXTGD
     C                   END
     C     ITMKEY        KLIST
     C                   KFLD                    ITMTST
     C                   KFLD                    SIZTST
     C                   MOVEL     ITM(X)        ITMTST           12
     C                   MOVEL     'CUT'         SIZTST            3
     C     ITMKEY        CHAIN     FMINVT                             91
     C   91              DO
     C                   SETON                                        1099
     C     X             ADD       10            X1                4 0
     C                   MOVE      '0'           *IN(X1)
     C                   ENDDO
     C  N91              MOVEL     IMDES1        DES(X)
      ** MUST HAVE QTY
     C     QTY(X)        IFLE      0
     C                   SETON                                        3099
     C     X             ADD       30            X1                4 0
     C                   MOVE      '0'           *IN(X1)
     C                   END                                                    QTY<= 0
     C                   ELSE                                                   ITM>" "
      ** CAN NOT HAVE QTY
     C     QTY(X)        IFGT      0
     C                   SETON                                        30
     C     X             ADD       30            X1                4 0
     C                   MOVE      '0'           *IN(X1)
     C                   END                                                    QTY > 0
     C                   END                                                    ITM > " "
     C     QTY(X)        IFNE      QT(X)
     C     ITM(X)        ORNE      IT(X)
     C                   SETON                                        98
     C                   Z-ADD     QTY(X)        QT(X)
     C                   MOVEL     ITM(X)        IT(X)
     C                   END
     C                   GOTO      NXTGD
     C                   END                                                    X>=10
     C                   XFOOT     QTY           TSTQTY            5 0
     C     TSTQTY        IFLE      0
     C                   SETON                                        4199
     C                   END
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   ENDSR
