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
      *            EFD ENTERPRISES INC.  215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- BIR510
      *SYSTEM-------------- ORDER ENTRY
      *DESCRIPTION--------- POST CUSTOMER SUMMARY SHISTS RECORDS       ARY
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  3/20/00 EFD ADD CLEAR SHISTS
      *
     FFDSALEC   UF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFSHISTS   UF A E           K DISK
      *
      * SHIST ARRAYS
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
     D  USERID               254    263
      * SOURCE LIBRARY
     D  SLIBR                314    323
      *
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
      *
      *
     C                   Z-ADD     1             FIRST             4 0
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C     NXT           TAG
     C                   READ      FDSALEC                                90
     C   90              GOTO      END
      * ? AFFECT S/A CREDIT MEMOS
      *
     C     SDAFSL        IFEQ      'N'
     C     SDCUFL        OREQ      'P'
     C                   GOTO      NXT
     C                   ENDIF
      * CHECK IF SAME COMPANY
     C     SDCOMP        IFNE      LCO
     C                   GOTO      NXT
     C                   END
      *
      * ACCOUNTING PERIOD 99
      *
     C     SDSHPR        IFEQ      99
     C     SDSHPR        ORLE      0
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     OLCUST        IFNE      SDCUST
     C     FIRST         IFGT      1
     C                   EXSR      USHIST
     C                   END
     C     SDCUST        CHAIN(N)  FMCUST                             90
     C                   Z-ADD     SDCUST        SHCUST
     C                   Z-ADD     SDCOMP        SHCOMP
     C                   MOVEL     *BLANKS       SHITEM
     C                   MOVEL     *BLANKS       SHSIZE
     C                   MOVEL     *BLANKS       SHSLSM
     C                   MOVEL     *BLANKS       SHLIST
     C     KEY25         KLIST
     C                   KFLD                    SHCUST
     C                   KFLD                    SHITEM
     C                   KFLD                    SHSIZE
     C                   KFLD                    SHSLSM
     C                   KFLD                    SHCOMP
     C     KEY25         CHAIN     FSHISTS                            92
     C   92              DO
     C                   CLEAR                   RSHISTS
     C                   Z-ADD     SDCUST        SHCUST
     C                   Z-ADD     SDCOMP        SHCOMP
     C                   MOVEL     *BLANKS       SHITEM
     C                   MOVEL     *BLANKS       SHSIZE
     C                   MOVEL     *BLANKS       SHSLSM
     C                   MOVEL     *BLANKS       SHLIST
     C                   ENDDO
     C                   END
      *
     C                   Z-ADD     SDSHPR        P                 2 0
      *
     C                   ADD       SDQSHP        CSQ(P)                         QTY THIS YEAR
     C                   ADD       SDEXT$        CS$(P)                         $ THIS YEAR
     C                   ADD       SDCST$        CC$(P)                         COST THIS YEAR
     C                   ADD       SDWGSH        CLB(P)                         POUNDS THIS YR
      *
     C                   MOVEL     'P'           SDCUFL
     C                   UPDATE    RDSALE
     C                   ADD       1             FIRST
     C                   Z-ADD     SDCUST        OLCUST            6 0
     C                   Z-ADD     SDCOMP        OLCOMP            2 0
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C     FIRST         IFGT      1
     C                   EXSR      USHIST
     C                   END
     C                   SETON                                        LR
      *
     C     USHIST        BEGSR
     C                   XFOOT     CSQ           SHCQTL
     C                   XFOOT     CS$           SHCSTL
     C                   MOVEL     CMLOOK        SHCMAL
     C                   MOVEL     CMCTYP        SHCUTP
     C  N92              UPDATE    RSHISTS
     C  N92              GOTO      NOADD
     C                   MOVEL     'A'           SHSTAT
     C                   MOVEL     *BLANKS       SHITEM
     C                   MOVEL     *BLANKS       SHSIZE
     C                   MOVEL     *BLANKS       SHSLSM
     C                   MOVEL     *BLANKS       SHTERR
     C                   MOVEL     *BLANKS       SHPCL1
     C                   MOVEL     *BLANKS       SHPCL2
     C                   MOVEL     *BLANKS       SHPCL3
     C                   MOVEL     *BLANKS       SHLIST
     C                   Z-ADD     TDATE         SHDTLA
     C                   Z-ADD     TIMOD         SHTIME
     C                   MOVEL     USERID        SHUSER
     C                   MOVEL     'S'           SHDSCD
     C                   MOVEL     *BLANKS       SHITYP
     C                   MOVEL     *BLANKS       SHITAL
     C                   MOVEL     *BLANKS       SHCUTP
     C                   WRITE     RSHISTS
     C     NOADD         TAG
     C                   Z-ADD     0             CS$
     C                   Z-ADD     0             CSQ
     C                   Z-ADD     0             CLB
     C                   Z-ADD     0             CC$
     C                   ENDSR
      **
