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
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- SAR822
      *APPLICATION--------- ANNUAL SALES HISTORY UPDATE
      *DESCRIPTION--------- THIS PROGRAM WILL UPDATE SALES HISTORY
      *                     RECORDS USING PREVIOUSLY UNPOSTED MONTHLY
      *                     SALES RECORDS (MSALE)
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  3/16/01 EFD CLEAR SHIST RECORD IF NO HIT.    EFD01
      *
      *
     FFMSALESL  IF   E           K DISK
     FFSHISTS   UF A E           K DISK
      *
     D CS$             S              9  2 DIM(13)
     D CC$             S              9  2 DIM(13)
     D CSQ             S             11  1 DIM(13)
     D CLB             S             11  4 DIM(13)
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
     D                UDS
     D  LCO                    1      2  0
      *
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
     I              SHC#01                      CLB(1)
     I              SHC#02                      CLB(2)
     I              SHC#03                      CLB(3)
     I              SHC#04                      CLB(4)
     I              SHC#05                      CLB(5)
     I              SHC#06                      CLB(6)
     I              SHC#07                      CLB(7)
     I              SHC#08                      CLB(8)
     I              SHC#09                      CLB(9)
     I              SHC#10                      CLB(10)
     I              SHC#11                      CLB(11)
     I              SHC#12                      CLB(12)
     I              SHC#13                      CLB(13)
     C*
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   SETON                                        50
     C                   Z-ADD     1             FIRST             7 0
      *
EFD  C                   MOVEL     'A '          SLSM              2
EFD  C     MKEY          KLIST
EFD  C                   KFLD                    LCO
EFD  C                   KFLD                    SLSM
EFD  C     MKEY          SETLL     FMSALESL
     C     NXTA          TAG
     C                   READ      FMSALESL                               90
     C   90              GOTO      END
      *
     C     MSSTAT        IFEQ      'D'
     C                   GOTO      NXTA
     C                   ENDIF
      *
EFD  C     MSSHPR        IFNE      99
MOVEDC                   GOTO      NXTA
     C                   ENDIF
      *
      * ? AFFECT S/A CREDIT MEMOS
      *
     C     MSAFSL        IFEQ      'N'
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     MSCOMP        IFNE      LCO
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     MSTDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         TDAT              6 0
     C                   Z-ADD     LCO           CONO              2 0
     C                   Z-ADD     TDAT          TRNDAT            6 0
     C                   CALL      'GETAPER'
     C                   PARM                    CONO              2 0
     C                   PARM                    ACTPER            2 0
     C                   PARM                    BEGDAT            6 0
     C                   PARM                    ENDDAT            6 0
     C                   PARM                    BGCYMD            7 0
     C                   PARM                    ENCYMD            7 0
     C                   PARM                    TRNDAT            6 0
     C                   PARM                    ERR               1 0
     C                   Z-ADD     ACTPER        P                 2 0
      *
     C     P             IFEQ      99
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     FIRST         IFGT      1
EFD  C     OLSLSM        ANDNE     MSSLM1
     C                   EXSR      USHIST
     C                   ENDIF
      *
      * IF FIRST TIME THRU GET SHIST REC
      *
     C     FIRST         IFEQ      1
     C                   EXSR      GETHST
     C                   END
      *
     C                   ADD       MSQSHP        CSQ(P)                                     R
     C                   ADD       MSEXT$        CS$(P)
     C                   ADD       MSCST$        CC$(P)                                     AR
     C                   ADD       MSWGSH        CLB(P)                                     YR
      *
     C                   ADD       1             FIRST
     C                   MOVEL     MSSLM1        OLSLSM            2
     C                   Z-ADD     MSCOMP        OLCOMP            2 0
     C                   GOTO      NXTA
      *
     C     END           TAG
     C     FIRST         IFGT      1
     C                   EXSR      USHIST
     C                   END
     C                   SETON                                        LR
      *
     C     GETHST        BEGSR
     C                   Z-ADD     0             SHCUST
     C                   MOVEL     *BLANKS       SHITEM
     C                   MOVEL     *BLANKS       SHSIZE
     C                   MOVEL     MSSLM1        SHSLSM
     C                   Z-ADD     MSCOMP        SHCOMP
     C     KEY25         KLIST
     C                   KFLD                    SHCUST
     C                   KFLD                    SHITEM
     C                   KFLD                    SHSIZE
     C                   KFLD                    SHSLSM
     C                   KFLD                    SHCOMP
     C     KEY25         CHAIN     FSHISTS                            92
EFD01C   92              DO
EFD01C                   CLEAR                   RSHISTS
EFD01C                   MOVEL     MSSLM1        SHSLSM
EFD01C                   Z-ADD     MSCOMP        SHCOMP
EFD01C                   ENDDO
     C                   ENDSR
      *
     C     USHIST        BEGSR
     C                   XFOOT     CSQ           SHCQTL
     C                   XFOOT     CS$           SHCSTL
     C                   MOVEL     'A'           SHSTAT
     C  N92              UPDATE    RSHISTS
     C  N92              GOTO      NOADD
     C                   Z-ADD     0             SHCUST
EFD01 **                   Z-ADDOLCOMP    SHCOMP
     C                   MOVEL     *BLANKS       SHITEM
     C                   MOVEL     *BLANKS       SHSIZE
EFD01 **                   MOVELOLSLSM    SHSLSM
     C                   MOVEL     *BLANKS       SHPCL1
     C                   MOVEL     *BLANKS       SHPCL2
     C                   MOVEL     *BLANKS       SHPCL3
     C                   Z-ADD     TDATE         SHDTLA
     C                   Z-ADD     TIMOD         SHTIME
     C                   MOVEL     USERID        SHUSER
     C                   MOVEL     'D'           SHDSCD
     C                   MOVEL     *BLANKS       SHITYP
     C                   WRITE     RSHISTS
     C     NOADD         TAG
     C                   Z-ADD     *ZEROS        CS$
     C                   Z-ADD     *ZEROS        CSQ
     C                   Z-ADD     *ZEROS        CLB
     C                   Z-ADD     *ZEROS        CC$
     C                   EXSR      GETHST
     C                   ENDSR
      *
