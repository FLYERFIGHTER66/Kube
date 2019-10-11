      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC. 1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- SAR800
      *SYSTEM-------------- GREENHOUSE MANAGEMENT
      *APPLICATION--------- YEAR END SALES HISTORY UPDATE
      *DESCRIPTION--------- YEAR END SALES HISTORY UPDATE MOVES
      *                     CURRENT YEAR BUCKETS TO PRIOR YEAR
      *                     BUCKETS AND ZEROS OUT CURRENT YEAR
      *                     BUCKETS.  ANY RECORD WITH NO ACTIVITY
      *                     FOR TWO YEARS IS DELETED IF REQUESTED.
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FSAR800FM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFSHIST    UF   E           K DISK
     FFSHISTS   UF   E           K DISK
      *
      * SHIST ARRAYS
      *
     D CS$             S              9  2 DIM(13)
     D LS$             S              9  2 DIM(13)
     D CC$             S              9  2 DIM(13)
     D LC$             S              9  2 DIM(13)
     D CSQ             S             11  1 DIM(13)
     D LSQ             S             11  1 DIM(13)
     D CLB             S             11  4 DIM(13)
     D LLB             S             11  4 DIM(13)
      *
      ** SHISTS ARRAYS
      *
     D C$S             S              9  2 DIM(13)
     D L$S             S              9  2 DIM(13)
     D C$C             S              9  2 DIM(13)
     D L$C             S              9  2 DIM(13)
     D CQS             S             11  1 DIM(13)
     D LQS             S             11  1 DIM(13)
     D CBL             S             11  4 DIM(13)
     D LBL             S             11  4 DIM(13)
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
     D  USERID               254    261
      * SOURCE LIBRARY
     D  SLIBR                314    323
      *
     D                UDS
     D  LCO                    1      2  0
     D  LCANCL               133    133
      *
     IRSHIST
     I              SICQ01                      CSQ(1)
     I              SICQ02                      CSQ(2)
     I              SICQ03                      CSQ(3)
     I              SICQ04                      CSQ(4)
     I              SICQ05                      CSQ(5)
     I              SICQ06                      CSQ(6)
     I              SICQ07                      CSQ(7)
     I              SICQ08                      CSQ(8)
     I              SICQ09                      CSQ(9)
     I              SICQ10                      CSQ(10)
     I              SICQ11                      CSQ(11)
     I              SICQ12                      CSQ(12)
     I              SICQ13                      CSQ(13)
      *
     I              SILQ01                      LSQ(1)
     I              SILQ02                      LSQ(2)
     I              SILQ03                      LSQ(3)
     I              SILQ04                      LSQ(4)
     I              SILQ05                      LSQ(5)
     I              SILQ06                      LSQ(6)
     I              SILQ07                      LSQ(7)
     I              SILQ08                      LSQ(8)
     I              SILQ09                      LSQ(9)
     I              SILQ10                      LSQ(10)
     I              SILQ11                      LSQ(11)
     I              SILQ12                      LSQ(12)
     I              SILQ13                      LSQ(13)
      *
     I              SICS01                      CS$(1)
     I              SICS02                      CS$(2)
     I              SICS03                      CS$(3)
     I              SICS04                      CS$(4)
     I              SICS05                      CS$(5)
     I              SICS06                      CS$(6)
     I              SICS07                      CS$(7)
     I              SICS08                      CS$(8)
     I              SICS09                      CS$(9)
     I              SICS10                      CS$(10)
     I              SICS11                      CS$(11)
     I              SICS12                      CS$(12)
     I              SICS13                      CS$(13)
      *
     I              SILS01                      LS$(1)
     I              SILS02                      LS$(2)
     I              SILS03                      LS$(3)
     I              SILS04                      LS$(4)
     I              SILS05                      LS$(5)
     I              SILS06                      LS$(6)
     I              SILS07                      LS$(7)
     I              SILS08                      LS$(8)
     I              SILS09                      LS$(9)
     I              SILS10                      LS$(10)
     I              SILS11                      LS$(11)
     I              SILS12                      LS$(12)
     I              SILS13                      LS$(13)
      *
     I              SICC01                      CC$(1)
     I              SICC02                      CC$(2)
     I              SICC03                      CC$(3)
     I              SICC04                      CC$(4)
     I              SICC05                      CC$(5)
     I              SICC06                      CC$(6)
     I              SICC07                      CC$(7)
     I              SICC08                      CC$(8)
     I              SICC09                      CC$(9)
     I              SICC10                      CC$(10)
     I              SICC11                      CC$(11)
     I              SICC12                      CC$(12)
     I              SICC13                      CC$(13)
      *
     I              SILC01                      LC$(1)
     I              SILC02                      LC$(2)
     I              SILC03                      LC$(3)
     I              SILC04                      LC$(4)
     I              SILC05                      LC$(5)
     I              SILC06                      LC$(6)
     I              SILC07                      LC$(7)
     I              SILC08                      LC$(8)
     I              SILC09                      LC$(9)
     I              SILC10                      LC$(10)
     I              SILC11                      LC$(11)
     I              SILC12                      LC$(12)
     I              SILC13                      LC$(13)
      *
     I              SIC#01                      CLB(1)
     I              SIC#02                      CLB(2)
     I              SIC#03                      CLB(3)
     I              SIC#04                      CLB(4)
     I              SIC#05                      CLB(5)
     I              SIC#06                      CLB(6)
     I              SIC#07                      CLB(7)
     I              SIC#08                      CLB(8)
     I              SIC#09                      CLB(9)
     I              SIC#10                      CLB(10)
     I              SIC#11                      CLB(11)
     I              SIC#12                      CLB(12)
     I              SIC#13                      CLB(13)
      *
     I              SIL#01                      LLB(1)
     I              SIL#02                      LLB(2)
     I              SIL#03                      LLB(3)
     I              SIL#04                      LLB(4)
     I              SIL#05                      LLB(5)
     I              SIL#06                      LLB(6)
     I              SIL#07                      LLB(7)
     I              SIL#08                      LLB(8)
     I              SIL#09                      LLB(9)
     I              SIL#10                      LLB(10)
     I              SIL#11                      LLB(11)
     I              SIL#12                      LLB(12)
     I              SIL#13                      LLB(13)
      *
     IRSHISTS
      *
     I              SHCQ01                      CQS(1)
     I              SHCQ02                      CQS(2)
     I              SHCQ03                      CQS(3)
     I              SHCQ04                      CQS(4)
     I              SHCQ05                      CQS(5)
     I              SHCQ06                      CQS(6)
     I              SHCQ07                      CQS(7)
     I              SHCQ08                      CQS(8)
     I              SHCQ09                      CQS(9)
     I              SHCQ10                      CQS(10)
     I              SHCQ11                      CQS(11)
     I              SHCQ12                      CQS(12)
     I              SHCQ13                      CQS(13)
      *
     I              SHLQ01                      LQS(1)
     I              SHLQ02                      LQS(2)
     I              SHLQ03                      LQS(3)
     I              SHLQ04                      LQS(4)
     I              SHLQ05                      LQS(5)
     I              SHLQ06                      LQS(6)
     I              SHLQ07                      LQS(7)
     I              SHLQ08                      LQS(8)
     I              SHLQ09                      LQS(9)
     I              SHLQ10                      LQS(10)
     I              SHLQ11                      LQS(11)
     I              SHLQ12                      LQS(12)
     I              SHLQ13                      LQS(13)
      *
     I              SHCS01                      C$S(1)
     I              SHCS02                      C$S(2)
     I              SHCS03                      C$S(3)
     I              SHCS04                      C$S(4)
     I              SHCS05                      C$S(5)
     I              SHCS06                      C$S(6)
     I              SHCS07                      C$S(7)
     I              SHCS08                      C$S(8)
     I              SHCS09                      C$S(9)
     I              SHCS10                      C$S(10)
     I              SHCS11                      C$S(11)
     I              SHCS12                      C$S(12)
     I              SHCS13                      C$S(13)
      *
     I              SHLS01                      L$S(1)
     I              SHLS02                      L$S(2)
     I              SHLS03                      L$S(3)
     I              SHLS04                      L$S(4)
     I              SHLS05                      L$S(5)
     I              SHLS06                      L$S(6)
     I              SHLS07                      L$S(7)
     I              SHLS08                      L$S(8)
     I              SHLS09                      L$S(9)
     I              SHLS10                      L$S(10)
     I              SHLS11                      L$S(11)
     I              SHLS12                      L$S(12)
     I              SHLS13                      L$S(13)
      *
     I              SHCC01                      C$C(1)
     I              SHCC02                      C$C(2)
     I              SHCC03                      C$C(3)
     I              SHCC04                      C$C(4)
     I              SHCC05                      C$C(5)
     I              SHCC06                      C$C(6)
     I              SHCC07                      C$C(7)
     I              SHCC08                      C$C(8)
     I              SHCC09                      C$C(9)
     I              SHCC10                      C$C(10)
     I              SHCC11                      C$C(11)
     I              SHCC12                      C$C(12)
     I              SHCC13                      C$C(13)
      *
     I              SHLC01                      L$C(1)
     I              SHLC02                      L$C(2)
     I              SHLC03                      L$C(3)
     I              SHLC04                      L$C(4)
     I              SHLC05                      L$C(5)
     I              SHLC06                      L$C(6)
     I              SHLC07                      L$C(7)
     I              SHLC08                      L$C(8)
     I              SHLC09                      L$C(9)
     I              SHLC10                      L$C(10)
     I              SHLC11                      L$C(11)
     I              SHLC12                      L$C(12)
     I              SHLC13                      L$C(13)
      *
     I              SHC#01                      CBL(1)
     I              SHC#02                      CBL(2)
     I              SHC#03                      CBL(3)
     I              SHC#04                      CBL(4)
     I              SHC#05                      CBL(5)
     I              SHC#06                      CBL(6)
     I              SHC#07                      CBL(7)
     I              SHC#08                      CBL(8)
     I              SHC#09                      CBL(9)
     I              SHC#10                      CBL(10)
     I              SHC#11                      CBL(11)
     I              SHC#12                      CBL(12)
     I              SHC#13                      CBL(13)
      *
     I              SHL#01                      LBL(1)
     I              SHL#02                      LBL(2)
     I              SHL#03                      LBL(3)
     I              SHL#04                      LBL(4)
     I              SHL#05                      LBL(5)
     I              SHL#06                      LBL(6)
     I              SHL#07                      LBL(7)
     I              SHL#08                      LBL(8)
     I              SHL#09                      LBL(9)
     I              SHL#10                      LBL(10)
     I              SHL#11                      LBL(11)
     I              SHL#12                      LBL(12)
     I              SHL#13                      LBL(13)
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     NXT           TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       10
     C                   READ      SCRNA                                  90
     C   KC
     COR KG              GOTO      END
      *
     C     LDEL          IFNE      'Y'                                                      K
     C     LDEL          ANDNE     'N'                                                      K
     C                   SETON                                        10
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LDEL          IFEQ      'Y'                                                      K
     C                   SETON                                        77
     C                   ENDIF
      *
     C     NXTA          TAG
     C                   SETOFF                                       50
     C                   READ      FSHIST                                 90
     C   90              GOTO      NXTB
      *
     C     SICOMP        IFNE      LCO
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C  N77              GOTO      NODEL
      *
      * DELETE SHIST RECORDS WITH NO SALES FOR TWO YEARS
      *
     C     SICQTL        IFNE      0
     C                   GOTO      NODEL
     C                   ENDIF
     C     SILQTL        IFNE      0
     C                   GOTO      NODEL
     C                   ENDIF
     C     SICSTL        IFNE      0
     C                   GOTO      NODEL
     C                   ENDIF
     C     SIPSTL        IFNE      0
     C                   GOTO      NODEL
     C                   ENDIF
      *
     C*  77                DELETRSHIST
      *
     C   77              GOTO      NXTA
      *
     C     NODEL         TAG
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     13
     C                   Z-ADD     CS$(X)        LS$(X)
     C                   Z-ADD     0             CS$(X)
     C                   Z-ADD     CC$(X)        LC$(X)
     C                   Z-ADD     0             CC$(X)
     C                   Z-ADD     CSQ(X)        LSQ(X)
     C                   Z-ADD     0             CSQ(X)
     C                   Z-ADD     CLB(X)        LLB(X)
     C                   Z-ADD     0             CLB(X)
     C                   ADD       1             X
     C                   ENDDO
     C                   Z-ADD     SICQTL        SILQTL
     C                   Z-ADD     SICSTL        SIPSTL
     C                   Z-ADD     0             SICQTL
     C                   Z-ADD     0             SICSTL
      *
     C                   Z-ADD     TIMOD         SITIME
     C                   Z-ADD     TDATE         SIDTLA
     C                   MOVEL     USERID        SIUSER
     C                   UPDATE    RSHIST
     C                   GOTO      NXTA
      *
     C     NXTB          TAG
     C                   SETOFF                                       50
     C                   READ      FSHISTS                                90
     C   90              GOTO      END
      *
     C     SHCOMP        IFNE      LCO
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C  N77              GOTO      NDEL
      *
      * DELETE SHISTS RECORDS WITH NO SALES FOR TWO YEARS
      *
     C     SHCQTL        IFNE      0
     C                   GOTO      NDEL
     C                   ENDIF
     C     SHLQTL        IFNE      0
     C                   GOTO      NDEL
     C                   ENDIF
     C     SHCSTL        IFNE      0
     C                   GOTO      NDEL
     C                   ENDIF
     C     SHPSTL        IFNE      0
     C                   GOTO      NDEL
     C                   ENDIF
      *
     C*  77                DELETRSHISTS
     C                   GOTO      NXTB
      *
     C     NDEL          TAG
      *
     C                   Z-ADD     1             X                 2 0
     C     X             DOUGT     13
     C                   Z-ADD     C$S(X)        L$S(X)
     C                   Z-ADD     0             C$S(X)
     C                   Z-ADD     C$C(X)        L$C(X)
     C                   Z-ADD     0             C$C(X)
     C                   Z-ADD     CQS(X)        LQS(X)
     C                   Z-ADD     0             CQS(X)
     C                   Z-ADD     CBL(X)        LBL(X)
     C                   Z-ADD     0             CBL(X)
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   Z-ADD     SHCQTL        SHLQTL
     C                   Z-ADD     SHCSTL        SHPSTL
     C                   Z-ADD     0             SHCQTL
     C                   Z-ADD     0             SHCSTL
      *
     C                   Z-ADD     TIMOD         SHTIME
     C                   Z-ADD     TDATE         SHDTLA
     C                   MOVEL     USERID        SHUSER
     C                   UPDATE    RSHISTS
     C                   GOTO      NXTB
      *
     C     END           TAG
     C                   SETON                                        LR
      *
