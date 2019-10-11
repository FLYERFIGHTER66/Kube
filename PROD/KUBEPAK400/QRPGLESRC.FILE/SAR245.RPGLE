      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
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
      *PROGRAM NAME-------- SAR245
      *SYSTEM-------------- SALES ANALYSIS
      *APPLICATION--------- STATE INQUIRY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FSAR245FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFSHISTS   IF   E           K DISK
     FFMSTAT    IF   E           K DISK
     FFMCUSTST  IF   E           K DISK
     FFMAPER    IF   E           K DISK
      *
      * SHIST ARRAYS
     D CSD             S              9  2 DIM(13)
     D CCD             S              9  2 DIM(13)
     D PSD             S              9  2 DIM(13)
     D PCD             S              9  2 DIM(13)
     D CSN             S             11  1 DIM(13)
     D PSN             S             11  1 DIM(13)
      * WORK ARRAYS
     D CS$             S              9  2 DIM(13)
     D CC$             S              9  2 DIM(13)
     D PS$             S              9  2 DIM(13)
     D PC$             S              9  2 DIM(13)
     D SVR             S              6  2 DIM(13)
     D QVR             S              6  2 DIM(13)
     D CSQ             S             11  1 DIM(13)
     D PSQ             S             11  1 DIM(13)
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
     IRSHISTS
     I              SHCQ01                      CSN(1)
     I              SHCQ02                      CSN(2)
     I              SHCQ03                      CSN(3)
     I              SHCQ04                      CSN(4)
     I              SHCQ05                      CSN(5)
     I              SHCQ06                      CSN(6)
     I              SHCQ07                      CSN(7)
     I              SHCQ08                      CSN(8)
     I              SHCQ09                      CSN(9)
     I              SHCQ10                      CSN(10)
     I              SHCQ11                      CSN(11)
     I              SHCQ12                      CSN(12)
     I              SHCQ13                      CSN(13)
      *
     I              SHLQ01                      PSN(1)
     I              SHLQ02                      PSN(2)
     I              SHLQ03                      PSN(3)
     I              SHLQ04                      PSN(4)
     I              SHLQ05                      PSN(5)
     I              SHLQ06                      PSN(6)
     I              SHLQ07                      PSN(7)
     I              SHLQ08                      PSN(8)
     I              SHLQ09                      PSN(9)
     I              SHLQ10                      PSN(10)
     I              SHLQ11                      PSN(11)
     I              SHLQ12                      PSN(12)
     I              SHLQ13                      PSN(13)
      *
     I              SHCS01                      CSD(1)
     I              SHCS02                      CSD(2)
     I              SHCS03                      CSD(3)
     I              SHCS04                      CSD(4)
     I              SHCS05                      CSD(5)
     I              SHCS06                      CSD(6)
     I              SHCS07                      CSD(7)
     I              SHCS08                      CSD(8)
     I              SHCS09                      CSD(9)
     I              SHCS10                      CSD(10)
     I              SHCS11                      CSD(11)
     I              SHCS12                      CSD(12)
     I              SHCS13                      CSD(13)
      *
     I              SHLS01                      PSD(1)
     I              SHLS02                      PSD(2)
     I              SHLS03                      PSD(3)
     I              SHLS04                      PSD(4)
     I              SHLS05                      PSD(5)
     I              SHLS06                      PSD(6)
     I              SHLS07                      PSD(7)
     I              SHLS08                      PSD(8)
     I              SHLS09                      PSD(9)
     I              SHLS10                      PSD(10)
     I              SHLS11                      PSD(11)
     I              SHLS12                      PSD(12)
     I              SHLS13                      PSD(13)
      *
     I              SHCC01                      CCD(1)
     I              SHCC02                      CCD(2)
     I              SHCC03                      CCD(3)
     I              SHCC04                      CCD(4)
     I              SHCC05                      CCD(5)
     I              SHCC06                      CCD(6)
     I              SHCC07                      CCD(7)
     I              SHCC08                      CCD(8)
     I              SHCC09                      CCD(9)
     I              SHCC10                      CCD(10)
     I              SHCC11                      CCD(11)
     I              SHCC12                      CCD(12)
     I              SHCC13                      CCD(13)
      *
     I              SHLC01                      PCD(1)
     I              SHLC02                      PCD(2)
     I              SHLC03                      PCD(3)
     I              SHLC04                      PCD(4)
     I              SHLC05                      PCD(5)
     I              SHLC06                      PCD(6)
     I              SHLC07                      PCD(7)
     I              SHLC08                      PCD(8)
     I              SHLC09                      PCD(9)
     I              SHLC10                      PCD(10)
     I              SHLC11                      PCD(11)
     I              SHLC12                      PCD(12)
     I              SHLC13                      PCD(13)
      *
     C     RSTRTA        TAG
     C                   Z-ADD     0             SVR
     C                   Z-ADD     0             QVR
     C                   MOVEL     *BLANKS       STATE
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101214
     C                   SETOFF                                       209092
     C                   SETOFF                                       30
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
      *
     C     1             SUBST     STATE:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     *BLANKS       STCODE
     C                   CALL      'LKSTAT'
     C                   PARM                    STCODE
     C                   PARM                    STNAME
     C                   MOVEL     *BLANKS       STATE
     C                   MOVEL     STCODE        STATE
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     STATE         CHAIN(N)  FMSTAT                             90
     C   90              SETON                                        1012
     C   10              GOTO      NXTA
      *
     C     LCO           CHAIN(N)  FMAPER                             90
     C     ACMPCN        IFEQ      'M'
     C                   SETON                                        30
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       SHSLSM
     C                   Z-ADD     LCO           SHCOMP
     C                   Z-ADD     0             SHCUST
     C                   MOVEL     *BLANKS       SHITEM
     C                   MOVEL     *BLANKS       SHSIZE
     C                   Z-ADD     0             CS$
     C                   Z-ADD     0             CC$
     C                   Z-ADD     0             PS$
     C                   Z-ADD     0             PC$
     C                   Z-ADD     0             SVR
     C                   Z-ADD     0             QVR
     C                   Z-ADD     0             CSQ
     C                   Z-ADD     0             PSQ
     C     STATE         SETLL     FMCUSTST
     C     NXTST         TAG
     C     STATE         READE     FMCUSTST                               90
     C   90              GOTO      ENDST
     C     KEY25         KLIST
     C                   KFLD                    CMCUST
     C                   KFLD                    SHITEM
     C                   KFLD                    SHSIZE
     C                   KFLD                    SHSLSM
     C                   KFLD                    LCO
     C     KEY25         CHAIN     FSHISTS                            92
     C   92              GOTO      NXTST
     C                   ADD       CSD           CS$
     C                   ADD       CCD           CC$
     C                   ADD       PSD           PS$
     C                   ADD       PCD           PC$
     C                   ADD       CSN           CSQ
     C                   ADD       PSN           PSQ
     C                   GOTO      NXTST
      *
     C     ENDST         TAG
     C                   Z-ADD     1             X                 2 0
     C     X             DOUEQ     13
     C     CS$(X)        IFGT      0
     C     PS$(X)        ANDGT     0
     C     CS$(X)        SUB       PS$(X)        DIFF              9 2
     C     DIFF          DIV       PS$(X)        PER               6 4
     C     PER           MULT      100           SVR(X)            6 2
     C                   ENDIF
     C     CS$(X)        IFGT      0
     C     PS$(X)        ANDEQ     0
     C                   Z-ADD     100.00        SVR(X)
     C                   ENDIF
     C     CS$(X)        IFEQ      0
     C     PS$(X)        ANDGT     0
     C                   Z-SUB     100.00        SVR(X)
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   Z-ADD     CS$(1)        SHCS01            9 2
     C                   Z-ADD     CS$(2)        SHCS02            9 2
     C                   Z-ADD     CS$(3)        SHCS03            9 2
     C                   Z-ADD     CS$(4)        SHCS04            9 2
     C                   Z-ADD     CS$(5)        SHCS05            9 2
     C                   Z-ADD     CS$(6)        SHCS06            9 2
     C                   Z-ADD     CS$(7)        SHCS07            9 2
     C                   Z-ADD     CS$(8)        SHCS08            9 2
     C                   Z-ADD     CS$(9)        SHCS09            9 2
     C                   Z-ADD     CS$(10)       SHCS10            9 2
     C                   Z-ADD     CS$(11)       SHCS11            9 2
     C                   Z-ADD     CS$(12)       SHCS12            9 2
     C                   Z-ADD     CS$(13)       SHCS13            9 2
      *
     C                   Z-ADD     PS$(1)        SHLS01            9 2
     C                   Z-ADD     PS$(2)        SHLS02            9 2
     C                   Z-ADD     PS$(3)        SHLS03            9 2
     C                   Z-ADD     PS$(4)        SHLS04            9 2
     C                   Z-ADD     PS$(5)        SHLS05            9 2
     C                   Z-ADD     PS$(6)        SHLS06            9 2
     C                   Z-ADD     PS$(7)        SHLS07            9 2
     C                   Z-ADD     PS$(8)        SHLS08            9 2
     C                   Z-ADD     PS$(9)        SHLS09            9 2
     C                   Z-ADD     PS$(10)       SHLS10            9 2
     C                   Z-ADD     PS$(11)       SHLS11            9 2
     C                   Z-ADD     PS$(12)       SHLS12            9 2
     C                   Z-ADD     PS$(13)       SHLS13            9 2
      *
     C                   Z-ADD     1             S                 2 0
     C*          S         DOUEQ13
     C*          SVR,S     IFEQ 100.00
     C*          SVR,S     OREQ -100.00
     C*                    Z-ADD0         SVR,S
     C*                    ENDIF
     C*                    ADD  1         S
     C*                    ENDDO
      *
     C                   Z-ADD     SVR(1)        SV01
     C                   Z-ADD     SVR(2)        SV02
     C                   Z-ADD     SVR(3)        SV03
     C                   Z-ADD     SVR(4)        SV04
     C                   Z-ADD     SVR(5)        SV05
     C                   Z-ADD     SVR(6)        SV06
     C                   Z-ADD     SVR(7)        SV07
     C                   Z-ADD     SVR(8)        SV08
     C                   Z-ADD     SVR(9)        SV09
     C                   Z-ADD     SVR(10)       SV10
     C                   Z-ADD     SVR(11)       SV11
     C                   Z-ADD     SVR(12)       SV12
     C                   Z-ADD     SVR(13)       SV13
      *
     C                   Z-ADD     1             Y                 2 0
     C     Y             DOUEQ     13
     C     CSQ(Y)        IFGT      0
     C     PSQ(Y)        ANDGT     0
     C     CSQ(Y)        SUB       PSQ(Y)        DIFQ             11 1
     C     DIFQ          DIV       PSQ(Y)        PERQ              6 4
     C     PERQ          MULT      100           QVR(Y)            6 2
     C                   ENDIF
     C     CSQ(Y)        IFGT      0
     C     PSQ(Y)        ANDEQ     0
     C                   Z-ADD     100.00        QVR(Y)
     C                   ENDIF
     C     CSQ(Y)        IFEQ      0
     C     PSQ(Y)        ANDGT     0
     C                   Z-SUB     100.00        QVR(Y)
     C                   ENDIF
     C                   ADD       1             Y
     C                   ENDDO
      *
     C                   Z-ADD     CSQ(1)        SHCQ01            7 0
     C                   Z-ADD     CSQ(2)        SHCQ02            7 0
     C                   Z-ADD     CSQ(3)        SHCQ03            7 0
     C                   Z-ADD     CSQ(4)        SHCQ04            7 0
     C                   Z-ADD     CSQ(5)        SHCQ05            7 0
     C                   Z-ADD     CSQ(6)        SHCQ06            7 0
     C                   Z-ADD     CSQ(7)        SHCQ07            7 0
     C                   Z-ADD     CSQ(8)        SHCQ08            7 0
     C                   Z-ADD     CSQ(9)        SHCQ09            7 0
     C                   Z-ADD     CSQ(10)       SHCQ10            7 0
     C                   Z-ADD     CSQ(11)       SHCQ11            7 0
     C                   Z-ADD     CSQ(12)       SHCQ12            7 0
     C                   Z-ADD     CSQ(13)       SHCQ13            7 0
      *
     C                   Z-ADD     PSQ(1)        SHLQ01            7 0
     C                   Z-ADD     PSQ(2)        SHLQ02            7 0
     C                   Z-ADD     PSQ(3)        SHLQ03            7 0
     C                   Z-ADD     PSQ(4)        SHLQ04            7 0
     C                   Z-ADD     PSQ(5)        SHLQ05            7 0
     C                   Z-ADD     PSQ(6)        SHLQ06            7 0
     C                   Z-ADD     PSQ(7)        SHLQ07            7 0
     C                   Z-ADD     PSQ(8)        SHLQ08            7 0
     C                   Z-ADD     PSQ(9)        SHLQ09            7 0
     C                   Z-ADD     PSQ(10)       SHLQ10            7 0
     C                   Z-ADD     PSQ(11)       SHLQ11            7 0
     C                   Z-ADD     PSQ(12)       SHLQ12            7 0
     C                   Z-ADD     PSQ(13)       SHLQ13            7 0
      *
     C                   Z-ADD     1             Q                 2 0
     C*          Q         DOUEQ13
     C*          QVR,Q     IFEQ 100.00
     C*          QVR,Q     OREQ -100.00
     C*                    Z-ADD0         QVR,Q
     C*                    ENDIF
     C*                    ADD  1         Q
     C*                    ENDDO
      *
     C                   Z-ADD     QVR(1)        QV01
     C                   Z-ADD     QVR(2)        QV02
     C                   Z-ADD     QVR(3)        QV03
     C                   Z-ADD     QVR(4)        QV04
     C                   Z-ADD     QVR(5)        QV05
     C                   Z-ADD     QVR(6)        QV06
     C                   Z-ADD     QVR(7)        QV07
     C                   Z-ADD     QVR(8)        QV08
     C                   Z-ADD     QVR(9)        QV09
     C                   Z-ADD     QVR(10)       QV10
     C                   Z-ADD     QVR(11)       QV11
     C                   Z-ADD     QVR(12)       QV12
     C                   Z-ADD     QVR(13)       QV13
      *
     C                   XFOOT     CS$           TCSLS
     C                   XFOOT     PS$           TPSLS
     C                   XFOOT     CSQ           TCQTY
     C                   XFOOT     PSQ           TLQTY
      *
     C     TCSLS         IFGT      0
     C     TPSLS         ANDGT     0
     C     TCSLS         SUB       TPSLS         TSDF              9 2
     C     TSDF          DIV       TPSLS         TSPR              6 4
     C     TSPR          MULT      100           TSV               6 2
     C                   ENDIF
     C     TCSLS         IFGT      0
     C     TPSLS         ANDEQ     0
     C                   Z-ADD     100.00        TSV
     C                   ENDIF
     C     TCSLS         IFEQ      0
     C     TPSLS         ANDGT     0
     C                   Z-SUB     100.00        TSV
     C                   ENDIF
     C     TCSLS         IFEQ      0
     C     TPSLS         ANDEQ     0
     C                   Z-ADD     0             TSV
     C                   ENDIF
      *
     C     TCQTY         IFGT      0
     C     TLQTY         ANDGT     0
     C     TCQTY         SUB       TLQTY         TQDF             11 1
     C     TQDF          DIV       TLQTY         TQPR              6 4
     C     TQPR          MULT      100           TQV               6 2
     C                   ENDIF
     C     TCQTY         IFGT      0
     C     TLQTY         ANDEQ     0
     C                   Z-ADD     100.00        TQV
     C                   ENDIF
     C     TCQTY         IFEQ      0
     C     TLQTY         ANDGT     0
     C                   Z-SUB     100.00        TQV
     C                   ENDIF
     C     TCQTY         IFEQ      0
     C     TLQTY         ANDEQ     0
     C                   Z-ADD     0             TQV
     C                   ENDIF
      *
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
     C   KC
     COR KG              GOTO      END
      *
     C                   GOTO      RSTRTA
      *
     C     END           TAG
     C                   SETON                                        LR
