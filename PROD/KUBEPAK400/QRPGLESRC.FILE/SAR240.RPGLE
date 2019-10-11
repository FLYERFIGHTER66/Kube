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
      *PROGRAM NAME-------- SAR240
      *SYSTEM-------------- SALES ANALYSIS
      *APPLICATION--------- PRODUCT CLASS INQUIRY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FSAR240FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFSHISTPC  IF   E           K DISK
     FFMPRCL    IF   E           K DISK
     FFMAPER    IF   E           K DISK
      *
      * SHIST ARRAYS
     D CS$             S              9  2 DIM(13)
     D CSLS            S              9  2 DIM(13)
     D CC$             S              9  2 DIM(13)
     D PS$             S              9  2 DIM(13)
     D PSLS            S              9  2 DIM(13)
     D PC$             S              9  2 DIM(13)
     D SVR             S              6  2 DIM(13)
     D QVR             S              6  2 DIM(13)
     D CSQ             S             11  1 DIM(13)
     D CQTY            S             11  1 DIM(13)
     D PSQ             S             11  1 DIM(13)
     D PQTY            S             11  1 DIM(13)
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
     I              SHCQ01                      CSQ(1)
     I              SHCQ02                      CSQ(2)
     I              SHCQ03                      CSQ(3)
     I              SHCQ04                      CSQ(4)
     I              SHCQ05                      CSQ(5)
     I              SHCQ06                      CSQ(6)
     I              SHCQ07                      CSQ(7)
     I              SHCQ08                      CSQ(8)
     I              SHCQ09                      CSQ(9)
     I              SHCQ10                      CSQ(10)
     I              SHCQ11                      CSQ(11)
     I              SHCQ12                      CSQ(12)
     I              SHCQ13                      CSQ(13)
      *
     I              SHLQ01                      PSQ(1)
     I              SHLQ02                      PSQ(2)
     I              SHLQ03                      PSQ(3)
     I              SHLQ04                      PSQ(4)
     I              SHLQ05                      PSQ(5)
     I              SHLQ06                      PSQ(6)
     I              SHLQ07                      PSQ(7)
     I              SHLQ08                      PSQ(8)
     I              SHLQ09                      PSQ(9)
     I              SHLQ10                      PSQ(10)
     I              SHLQ11                      PSQ(11)
     I              SHLQ12                      PSQ(12)
     I              SHLQ13                      PSQ(13)
      *
     I              SHCS01                      CS$(1)
     I              SHCS02                      CS$(2)
     I              SHCS03                      CS$(3)
     I              SHCS04                      CS$(4)
     I              SHCS05                      CS$(5)
     I              SHCS06                      CS$(6)
     I              SHCS07                      CS$(7)
     I              SHCS08                      CS$(8)
     I              SHCS09                      CS$(9)
     I              SHCS10                      CS$(10)
     I              SHCS11                      CS$(11)
     I              SHCS12                      CS$(12)
     I              SHCS13                      CS$(13)
      *
     I              SHLS01                      PS$(1)
     I              SHLS02                      PS$(2)
     I              SHLS03                      PS$(3)
     I              SHLS04                      PS$(4)
     I              SHLS05                      PS$(5)
     I              SHLS06                      PS$(6)
     I              SHLS07                      PS$(7)
     I              SHLS08                      PS$(8)
     I              SHLS09                      PS$(9)
     I              SHLS10                      PS$(10)
     I              SHLS11                      PS$(11)
     I              SHLS12                      PS$(12)
     I              SHLS13                      PS$(13)
      *
     I              SHCC01                      CC$(1)
     I              SHCC02                      CC$(2)
     I              SHCC03                      CC$(3)
     I              SHCC04                      CC$(4)
     I              SHCC05                      CC$(5)
     I              SHCC06                      CC$(6)
     I              SHCC07                      CC$(7)
     I              SHCC08                      CC$(8)
     I              SHCC09                      CC$(9)
     I              SHCC10                      CC$(10)
     I              SHCC11                      CC$(11)
     I              SHCC12                      CC$(12)
     I              SHCC13                      CC$(13)
      *
     I              SHLC01                      PC$(1)
     I              SHLC02                      PC$(2)
     I              SHLC03                      PC$(3)
     I              SHLC04                      PC$(4)
     I              SHLC05                      PC$(5)
     I              SHLC06                      PC$(6)
     I              SHLC07                      PC$(7)
     I              SHLC08                      PC$(8)
     I              SHLC09                      PC$(9)
     I              SHLC10                      PC$(10)
     I              SHLC11                      PC$(11)
     I              SHLC12                      PC$(12)
     I              SHLC13                      PC$(13)
      *
     C     RSTRTA        TAG
     C                   Z-ADD     0             SVR
     C                   Z-ADD     0             QVR
     C                   Z-ADD     0             CSLS
     C                   Z-ADD     0             PSLS
     C                   Z-ADD     0             CQTY
     C                   Z-ADD     0             PQTY
     C                   Z-ADD     0             TSV
     C                   Z-ADD     0             TQV
     C                   MOVEL     *BLANKS       VPRCL
     C                   MOVEL     *BLANKS       PCDESC
     C                   MOVEL     *BLANKS       DESC
     C                   Z-ADD     1             CNT               6 0
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101214
     C                   SETOFF                                       209092
     C                   SETOFF                                       30
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
      *
     C     1             SUBST     VPRCL:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     VPRCL         PCPRCL            2
     C                   CALL      'LKPRCL'
     C                   PARM                    PCPRCL
     C                   PARM                    PCDESC           30
     C                   MOVEL     *BLANKS       VPRCL
     C                   MOVEL     PCPRCL        VPRCL
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VPRCL         CHAIN(N)  FMPRCL                             90
     C   90              SETON                                        1012
     C   10              GOTO      NXTA
     C                   MOVEL     PCDESC        DESC             30
      *
     C     LCO           CHAIN(N)  FMAPER                             90
     C     ACMPCN        IFEQ      'M'
     C                   SETON                                        30
     C                   ENDIF
      *
     C     VPRCL         SETLL     FSHISTPC
     C     NXT           TAG
     C     VPRCL         READE     FSHISTPC                               92
     C   92CNT           IFEQ      1
     C                   SETON                                        1214
     C                   GOTO      NXTA
     C                   ENDIF
     C   92              GOTO      OKAY
      *
     C                   Z-ADD     1             Z                 2 0
     C     Z             DOUEQ     13
     C                   ADD       CS$(Z)        CSLS(Z)
     C                   ADD       PS$(Z)        PSLS(Z)
     C                   ADD       CSQ(Z)        CQTY(Z)
     C                   ADD       PSQ(Z)        PQTY(Z)
     C                   ADD       1             Z
     C                   ADD       1             CNT
     C                   ENDDO
      *
     C                   GOTO      NXT
      *
     C     OKAY          TAG
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUEQ     13
     C     CSLS(X)       IFGT      0
     C     PSLS(X)       ANDGT     0
     C     CSLS(X)       SUB       PSLS(X)       DIFF              9 2
     C     DIFF          DIV       PSLS(X)       PER               6 4
     C     PER           MULT      100           SVR(X)            6 2
     C                   ENDIF
     C     CSLS(X)       IFGT      0
     C     PSLS(X)       ANDEQ     0
     C                   Z-ADD     100.00        SVR(X)
     C                   ENDIF
     C     CSLS(X)       IFEQ      0
     C     PSLS(X)       ANDGT     0
     C                   Z-SUB     100.00        SVR(X)
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   Z-ADD     CSLS(1)       CS01
     C                   Z-ADD     CSLS(2)       CS02
     C                   Z-ADD     CSLS(3)       CS03
     C                   Z-ADD     CSLS(4)       CS04
     C                   Z-ADD     CSLS(5)       CS05
     C                   Z-ADD     CSLS(6)       CS06
     C                   Z-ADD     CSLS(7)       CS07
     C                   Z-ADD     CSLS(8)       CS08
     C                   Z-ADD     CSLS(9)       CS09
     C                   Z-ADD     CSLS(10)      CS10
     C                   Z-ADD     CSLS(11)      CS11
     C                   Z-ADD     CSLS(12)      CS12
     C                   Z-ADD     CSLS(13)      CS13
      *
     C                   Z-ADD     PSLS(1)       LS01
     C                   Z-ADD     PSLS(2)       LS02
     C                   Z-ADD     PSLS(3)       LS03
     C                   Z-ADD     PSLS(4)       LS04
     C                   Z-ADD     PSLS(5)       LS05
     C                   Z-ADD     PSLS(6)       LS06
     C                   Z-ADD     PSLS(7)       LS07
     C                   Z-ADD     PSLS(8)       LS08
     C                   Z-ADD     PSLS(9)       LS09
     C                   Z-ADD     PSLS(10)      LS10
     C                   Z-ADD     PSLS(11)      LS11
     C                   Z-ADD     PSLS(12)      LS12
     C                   Z-ADD     PSLS(13)      LS13
      *
     C                   Z-ADD     1             S                 2 0
     C     S             DOUEQ     13
     C     SVR(S)        IFEQ      100.00
     C     SVR(S)        OREQ      -100.00
     C                   Z-ADD     0             SVR(S)
     C                   ENDIF
     C                   ADD       1             S
     C                   ENDDO
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
     C     CQTY(Y)       IFGT      0
     C     PQTY(Y)       ANDGT     0
     C     CQTY(Y)       SUB       PQTY(Y)       DIFQ             11 1
     C     DIFQ          DIV       PQTY(Y)       PERQ              6 4
     C     PERQ          MULT      100           QVR(Y)            6 2
     C                   ENDIF
     C     CQTY(Y)       IFGT      0
     C     PQTY(Y)       ANDEQ     0
     C                   Z-ADD     100.00        QVR(Y)
     C                   ENDIF
     C     CQTY(Y)       IFEQ      0
     C     PQTY(Y)       ANDGT     0
     C                   Z-SUB     100.00        QVR(Y)
     C                   ENDIF
     C                   ADD       1             Y
     C                   ENDDO
      *
     C                   Z-ADD     CQTY(1)       CQ01
     C                   Z-ADD     CQTY(2)       CQ02
     C                   Z-ADD     CQTY(3)       CQ03
     C                   Z-ADD     CQTY(4)       CQ04
     C                   Z-ADD     CQTY(5)       CQ05
     C                   Z-ADD     CQTY(6)       CQ06
     C                   Z-ADD     CQTY(7)       CQ07
     C                   Z-ADD     CQTY(8)       CQ08
     C                   Z-ADD     CQTY(9)       CQ09
     C                   Z-ADD     CQTY(10)      CQ10
     C                   Z-ADD     CQTY(11)      CQ11
     C                   Z-ADD     CQTY(12)      CQ12
     C                   Z-ADD     CQTY(13)      CQ13
      *
     C                   Z-ADD     PQTY(1)       LQ01
     C                   Z-ADD     PQTY(2)       LQ02
     C                   Z-ADD     PQTY(3)       LQ03
     C                   Z-ADD     PQTY(4)       LQ04
     C                   Z-ADD     PQTY(5)       LQ05
     C                   Z-ADD     PQTY(6)       LQ06
     C                   Z-ADD     PQTY(7)       LQ07
     C                   Z-ADD     PQTY(8)       LQ08
     C                   Z-ADD     PQTY(9)       LQ09
     C                   Z-ADD     PQTY(10)      LQ10
     C                   Z-ADD     PQTY(11)      LQ11
     C                   Z-ADD     PQTY(12)      LQ12
     C                   Z-ADD     PQTY(13)      LQ13
      *
     C                   Z-ADD     1             Q                 2 0
     C     Q             DOUEQ     13
     C     QVR(Q)        IFEQ      100.00
     C     QVR(Q)        OREQ      -100.00
     C                   Z-ADD     0             QVR(Q)
     C                   ENDIF
     C                   ADD       1             Q
     C                   ENDDO
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
     C                   XFOOT     CSLS          TCSLS
     C                   XFOOT     PSLS          TPSLS
     C                   XFOOT     CQTY          TCQTY
     C                   XFOOT     PQTY          TLQTY
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
