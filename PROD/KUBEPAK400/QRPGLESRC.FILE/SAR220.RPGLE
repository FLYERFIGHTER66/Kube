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
      *PROGRAM NAME-------- SAR220
      *SYSTEM-------------- SALES ANALYSIS
      *APPLICATION--------- SALESPERSON INQUIRY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FSAR220FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFSHISTS   IF   E           K DISK
     FFMSLSM    IF   E           K DISK
     FFMAPER    IF   E           K DISK
      *
      * SHIST ARRAYS
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
     C                   Z-ADD     *ZEROS        SVR
     C                   Z-ADD     *ZEROS        QVR
     C                   MOVEL     *BLANKS       VSLSM
     C                   MOVEL     *BLANKS       SMNAME
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101214
     C                   SETOFF                                       209092
     C                   SETOFF                                       30
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
      *
     C     1             SUBST     VSLSM:1       VITST             1
     C     VITST         IFEQ      '?'
     C     VITST         OREQ      '/'
     C                   MOVEL     VSLSM         SMSLSM            2
     C                   CALL      'LKSALE'
     C                   PARM                    SMSLSM
     C                   PARM                    SMNAME           30
     C                   MOVEL     *BLANKS       VSLSM
     C                   MOVEL     SMSLSM        VSLSM
     C                   MOVEL     SMNAME        SMNAME
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VSLSM         CHAIN(N)  FMSLSM                             90
     C   90              SETON                                        1012
     C   10              GOTO      NXTA
      *
     C     LCO           CHAIN(N)  FMAPER                             90
     C     ACMPCN        IFEQ      'M'
     C                   SETON                                        30
     C                   ENDIF
      *
     C                   MOVEL     VSLSM         SHSLSM
     C                   Z-ADD     LCO           SHCOMP
     C                   Z-ADD     *ZEROS        SHCUST
     C                   MOVEL     *BLANKS       SHITEM
     C                   MOVEL     *BLANKS       SHSIZE
     C     KEY25         KLIST
     C                   KFLD                    SHCUST
     C                   KFLD                    SHITEM
     C                   KFLD                    SHSIZE
     C                   KFLD                    SHSLSM
     C                   KFLD                    SHCOMP
     C     KEY25         CHAIN     FSHISTS                            92
     C   92              SETON                                        1214
     C   14              GOTO      NXTA
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUEQ     13
     C     CS$(X)        IFGT      *ZEROS
     C     PS$(X)        ANDGT     *ZEROS
     C     CS$(X)        SUB       PS$(X)        DIFF              9 2
     C     DIFF          DIV       PS$(X)        PER               6 4
     C     PER           MULT      100           SVR(X)            6 2
     C                   ENDIF
     C     CS$(X)        IFGT      *ZEROS
     C     PS$(X)        ANDEQ     *ZEROS
     C                   Z-ADD     100.00        SVR(X)
     C                   ENDIF
     C     CS$(X)        IFEQ      *ZEROS
     C     PS$(X)        ANDGT     *ZEROS
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
     C     S             DOUEQ     13
     C     SVR(S)        IFEQ      100.00
     C     SVR(S)        OREQ      -100.00
     C                   Z-ADD     *ZEROS        SVR(S)
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
     C     CSQ(Y)        IFGT      *ZEROS
     C     PSQ(Y)        ANDGT     *ZEROS
     C     CSQ(Y)        SUB       PSQ(Y)        DIFQ             11 1
     C     DIFQ          DIV       PSQ(Y)        PERQ              6 4
     C     PERQ          MULT      100           QVR(Y)            6 2
     C                   ENDIF
     C     CSQ(Y)        IFGT      *ZEROS
     C     PSQ(Y)        ANDEQ     *ZEROS
     C                   Z-ADD     100.00        QVR(Y)
     C                   ENDIF
     C     CSQ(Y)        IFEQ      *ZEROS
     C     PSQ(Y)        ANDGT     *ZEROS
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
     C     Q             DOUEQ     13
     C     QVR(Q)        IFEQ      100.00
     C     QVR(Q)        OREQ      -100.00
     C                   Z-ADD     *ZEROS        QVR(Q)
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
     C                   XFOOT     CS$           TCSLS
     C                   XFOOT     PS$           TPSLS
     C                   XFOOT     CSQ           TCQTY
     C                   XFOOT     PSQ           TLQTY
      *
     C     TCSLS         IFGT      *ZEROS
     C     TPSLS         ANDGT     *ZEROS
     C     TCSLS         SUB       TPSLS         TSDF              9 2
     C     TSDF          DIV       TPSLS         TSPR              6 4
     C     TSPR          MULT      100           TSV               6 2
     C                   ENDIF
     C     TCSLS         IFGT      *ZEROS
     C     TPSLS         ANDEQ     *ZEROS
     C                   Z-ADD     100.00        TSV
     C                   ENDIF
     C     TCSLS         IFEQ      *ZEROS
     C     TPSLS         ANDGT     *ZEROS
     C                   Z-SUB     100.00        TSV
     C                   ENDIF
      *
     C     TCQTY         IFGT      *ZEROS
     C     TLQTY         ANDGT     *ZEROS
     C     TCQTY         SUB       TLQTY         TQDF             11 1
     C     TQDF          DIV       TLQTY         TQPR              6 4
     C     TQPR          MULT      100           TQV               6 2
     C                   ENDIF
     C     TCQTY         IFGT      *ZEROS
     C     TLQTY         ANDEQ     *ZEROS
     C                   Z-ADD     100.00        TQV
     C                   ENDIF
     C     TCQTY         IFEQ      *ZEROS
     C     TLQTY         ANDGT     *ZEROS
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
