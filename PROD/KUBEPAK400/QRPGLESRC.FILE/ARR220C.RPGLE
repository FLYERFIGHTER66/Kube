      *
      *
      *
      *
      *
      *
      *****************************************************************
      *   NOTE
      *  ANY CHANGES YOU MAKE HERE MAKE IN ARR220
      *****************************************************************
      *
      *
      *
      *
      *
      *
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
      *PROGRAM NAME-------- ARR220C
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- BALANCE INQUIRY
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      * MJT01 - 07/21/00 - FIX CALCULATIONS FOR DAYS TO PAY SUMMARY
      *       - ALSO REQUIRES A SCREEN CHANGE DTOP REPLACES HSAVDY
      * EFD01 - 08/10/00 - BLANK WORK FIELDS BEFORE CONCAT ADDRESS
      * MJT03 - 08/23/01 - CHANGE ADJUSTMENT DESCRIPTION
      * CAB   - 01/08/03 - CHANGED FAROPN TO LOGICAL FAROPNDD (BY DUE DATE)
      *
CAB  F****FAROPN  IF  E           K        DISK
CAB  FFAROPNDD  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFARHST    IF   E           K DISK
      ***FFMCORG  IF  E           K        DISK
     FFMTERM    IF   E           K DISK
     FFARCTL    IF   E           K DISK
     FARR220FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     FARR22A    O    F  132        PRINTER OFLIND(*INOA)
      *
     D #PP$            S             11  2 DIM(5)                               PRINT LINE $
     D #PD$            S             11  2 DIM(5)                               PAST DUE $
     D #FD$            S             11  2 DIM(5)                               FUTURE DUE $
     D #FD             S              5  0 DIM(4) ASCEND                        AGING DAYS ARRAY
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      *  PROGRAM NAME
     D  PROGID                 1     10
      *  RUN LIBRARY
     D  RLIBR                 81     90
      *  USER I.D.
     D  USERID               254    263
      *  SOURCE LIBRARY
     D  SLIBR                314    323
     D                UDS
     D  LCANCL               133    133
     D  LHIST                134    134
      *
      *-------------------------------------------------------------------------
     C     *ENTRY        PLIST
     C                   PARM                    COMP              2
     C                   PARM                    CUST              6
     C                   MOVEL     COMP          LCO               2 0
     C                   MOVEL     CUST          VACUST
     C                   MOVE      *BLANKS       LCANCL
     C                   MOVE      *BLANKS       LHIST
     C                   GOTO      CALST
     C     RSTRTA        TAG
     C                   SETOFF                                       79
     C                   Z-ADD     1             FCNT
     C                   MOVEL     *BLANKS       CMNAME
     C                   MOVEL     *BLANKS       CANAME
     C                   MOVEL     *BLANKS       CSNAME
     C                   Z-ADD     *ZEROS        VACUST
     C                   Z-ADD     *ZEROS        VSCUST
     C                   Z-ADD     *ZEROS        TOTAR
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       111214
     C                   SETOFF                                       151617
     C                   SETOFF                                       182279
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              GOTO      ENDP
      *
     C     VACUST        IFEQ      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   MOVEL     VALPHA        CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   Z-ADD     CMCUST        VACUST
     C                   MOVEL     CMNAME        CANAME
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * TELEPHONE # SEARCH
      *
     C     VACUST        IFEQ      *ZEROS
     C     VALPHA        ANDEQ     *BLANKS
     C     VATELE        ANDGT     *BLANKS
     C                   MOVEL     VATELE        CMPHON           10 0
     C                   CALL      'LKTELE'
     C                   PARM                    CMPHON
     C                   PARM                    CMCUST            6 0
     C                   PARM                    CMNAME           30
     C                   MOVEL     *BLANKS       VATELE
     C                   Z-ADD     CMCUST        VACUST
     C                   MOVEL     CMNAME        CANAME
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACUST        IFEQ      *ZEROS
     C     VALPHA        ANDEQ     *BLANKS
     C                   SETON                                        1011
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VACUST        IFGT      *ZEROS
     C     VALPHA        ANDGT     *BLANKS
     C                   SETON                                        1012
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     CALST         TAG
     C     VACUST        CHAIN     FMCUST                             31
     C   31              SETON                                        1114
     C   11              GOTO      NXTA
     C                   MOVEL     CMNAME        ANAME
     C                   MOVEL     CMCNAM        MCNAM
     C                   Z-ADD     CMPHON        MPHON
      *
      * SHIP TO CUSTOMER
      *
     C     VSCUST        IFEQ      *ZEROS
     C     VSALPH        ANDGT     *BLANKS
     C                   MOVEL     VSALPH        CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       VSALPH
     C                   MOVEL     CMNAME        CSNAME
     C                   Z-ADD     CMCUST        VSCUST
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * TELEPHONE # SEARCH
      *
     C     VSCUST        IFEQ      *ZEROS
     C     VSALPH        ANDEQ     *BLANKS
     C     VSTELE        ANDGT     *BLANKS
     C                   MOVEL     VSTELE        CMPHON           10 0
     C                   CALL      'LKTELE'
     C                   PARM                    CMPHON
     C                   PARM                    CMCUST            6 0
     C                   PARM                    CMNAME           30
     C                   MOVEL     *BLANKS       VSTELE
     C                   Z-ADD     CMCUST        VSCUST
     C                   MOVEL     CMNAME        CSNAME
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VSCUST        IFGT      *ZEROS
     C     VSALPH        ANDGT     *BLANKS
     C                   SETON                                        1517
     C   17              GOTO      NXTA
     C                   ENDIF
      *
     C     VSCUST        IFGT      *ZEROS
     C     VSCUST        CHAIN     FMCUST                             31
     C  N31              MOVEL     CMNAME        CSNAME           30
     C   31              SETON                                        1615
     C   16              GOTO      NXTA
     C                   ENDIF
      *
      * VALIDATE AGING DATE
      *
     C     INQ01         TAG
     C     VDATE         IFEQ      *ZEROS
     C                   SETON                                        22
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   Z-ADD     VDATE         ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        22
     C                   GOTO      NXTA
     C                   ENDIF
     C                   EXSR      #AGDY
      *
     C     VACUST        CHAIN     FMCUST                             90
      *
CAB  C***        VACUST    SETLLFAROPN
CAB  C     VACUST        SETLL     FAROPNDD
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
      *
     C     RSTRTB        TAG
     C                   SETOFF                                       90
     C   KA              GOTO      RSTRTC
     C   KF              GOTO      RSTRTA
     C   KC
     COR KG              GOTO      ENDP
      *
      * CLEAR TOTAL FIELDS BEFORE AGING
      *
     C                   Z-ADD     *ZEROS        #WKAT$
     C                   Z-ADD     *ZEROS        #WKCR$
     C                   Z-ADD     *ZEROS        #PD$
     C                   Z-ADD     *ZEROS        #PP$
     C                   Z-ADD     *ZEROS        #PP
     C     NXTI          TAG
CAB  C***        VACUST    READEFAROPN                   90
CAB  C     VACUST        READE     FAROPNDD                               90
     C   90              GOTO      DSPL
      *
     C     ARCOMP        IFNE      LCO                                                      #
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C     VSCUST        IFGT      *ZEROS
     C     ARSHCU        ANDNE     VSCUST
     C                   GOTO      NXTI
     C                   ENDIF
      *
     C                   Z-ADD     ARTDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         TDAT              6 0
      *
     C                   Z-ADD     ARDUDT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         DUDT              6 0
      *
     C                   EXSR      ARTYP
     C                   EXSR      AGING
      *
     C     CMCRL$        IFGT      0
     C     #WKAT$        ANDGT     CMCRL$
     C                   SETON                                        79
     C                   ENDIF
      *
     C     ARINV#        IFEQ      OINV
     C     ARTTYP        ANDNE     12
     C                   Z-ADD     *ZEROS        ARDUE$
     C                   ENDIF
      *
     C                   ADD       AR$AMT        TOTAR            11 2
      * CHECK STATEMENT PRINT
     C     ARPRST        IFEQ      'N'
     C                   SETON                                        55
     C                   ELSE
     C                   SETOFF                                       55
     C                   END
      *
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
     C                   Z-ADD     ARINV#        OINV              6 0
     C                   GOTO      NXTI
      *
     C     DSPL          TAG
     C     CMTMCD        CHAIN     FMTERM                             90
     C                   SETOFF                                       55
     C     FCNT          IFGT      1
     C                   GOTO      NOTOT
     C                   ENDIF
     C                   ADD       2             RECNO
     C                   Z-ADD     0             ARINV#
     C                   MOVEL     *BLANKS       ARSUFF
     C                   MOVEL     *BLANKS       TYPE
     C                   Z-ADD     0             TDAT
     C                   Z-ADD     0             DUDT
     C                   Z-ADD     0             ARDUE$
     C                   Z-ADD     0             AR$AMT
     C                   Z-ADD     TOTAR         ARDUE$
     C                   MOVEL     *BLANKS       ARCHEK
     C                   MOVEL     '* Totals'    DESC1            10
     C                   MOVE      ' *'          DESC1
     C                   MOVEL     DESC1         ARCHEK
     C                   WRITE     RECSFL
     C                   ADD       1             FCNT              2 0
      * GET SCREEN TOTALS
     C                   Z-ADD     #PD$(1)       #PF$1
     C                   Z-ADD     #PD$(2)       #PF$2
     C                   Z-ADD     #PD$(3)       #PF$3
     C     #PD$(4)       ADD       #PD$(5)       #PF$4
      *
      *
      *
     C     NXTFMT        TAG
     C                   EXFMT     RECCTL
     C     NOTOT         TAG
     C   KL              DO                                                     COMMENTS DISPLAY
     C                   EXSR      CMNTKL
     C                   GOTO      NXTFMT
     C                   ENDDO
     C   KK              DO                                                     VIEW INVOICEPLAY
     C     LINE          IFLE      0
     C                   SETON                                        77
     C                   GOTO      NXTFMT
     C                   END
     C     LINE          CHAIN     RECSFL                             77
     C   77              GOTO      NXTFMT
     C     TYPE          IFNE      'Inv '
     C     TYPE          ANDNE     'Crm '
     C                   SETON                                        77
     C                   GOTO      NXTFMT
     C                   END
     C     TYPE          IFEQ      'Inv '
     C                   MOVEL     'IN'          TYPO              2
     C                   END
     C     TYPE          IFEQ      'Crm '
     C                   MOVEL     'CM'          TYPO              2
     C                   END
     C                   Z-ADD     ARINV#        INVINI           15 5
     C                   CALL      'BIR337C'
     C                   PARM                    INVINI
     C                   PARM                    TYPO
     C                   GOTO      NXTFMT
     C                   ENDDO
     C   KC
     COR KG              GOTO      ENDP
     C   KH              EXSR      PRINT
     C** KH                GOTO RSTRTA
     C   KI              DO
     C                   Z-ADD     VACUST        LCUST             6 0
     C                   MOVEL     'X'           LHIST
     C                   GOTO      ENDP
     C                   ENDDO
     C   KA              GOTO      RSTRTC
     C   KF              GOTO      RSTRTA
     C                   GOTO      NXTFMT
      *
      * CALCULATE A/R HISTORY FIELDS
      *
     C     RSTRTC        TAG
     C                   SETOFF                                       10
     C                   Z-ADD     *ZEROS        SVAVL$
     C     VACUST        CHAIN     FARHST                             96
MJT01C     *IN96         IFEQ      '1'
MJT01C                   Z-ADD     *ZEROS        HSAVDY                         DAYS TO PAY
MJT01C                   Z-ADD     *ZEROS        HS#PAY                         # OF PAYMENT
MJT01C                   Z-ADD     *ZEROS        DTOP                           AVG DAYS PAY
     C   96              GOTO      ENDP
MJT01C                   END
      *
MJT01C     HS#PAY        IFLE      *ZEROS
MJT01C                   Z-ADD     *ZEROS        DTOP
MJT01C                   END
MJT01C     HS#PAY        IFGT      *ZEROS
MJT01C     HSAVDY        DIV       HS#PAY        DTOP
MJT01C                   END
WHT   *| Use New "Days 2 Pay" calculation.  (Avg Days 2 Pay for last 365 days)
     C                   Call      'DAYS2PAY'
     C                   Parm                    VACUST
     C                   Parm                    Days2Pay          6 1
     C                   Z-Add(H)  Days2Pay      DTOP
      *
     C                   MOVEL     CMTMCD        TRMKEY            2
     C     TRMKEY        CHAIN     FMTERM                             86
      *
     C     HSSIZE        MULT      1000          VBUSSZ            8 0          IN THOUSANDS
      *
EFD01C                   MOVEL     *BLANKS       WORK1
EFD01C                   MOVEL     *BLANKS       CSZ
     C     VACUST        CHAIN     FMCUST                             96
     C     CMCITY        CAT       CMSTST:1      WORK1            21
     C     WORK1         CAT       CMZIP:1       CSZ              31
      *
     C     CMCRL$        IFGT      *ZEROS
     C     CMCRL$        SUB       CMARB$        SVAVL$           11 2
     C                   ENDIF
      *
     C     ENDAR         TAG
     C                   WRITE     SCRNC
     C                   READ      SCRNC                                  90
     C   KC
     COR KG              GOTO      ENDP
     C   KB              GOTO      RSTRTB
     C   KD              GOTO      RSTRTA
     C   KH              EXCEPT    HDAR
     C   KH              EXCEPT    DETAR
     C   KH              GOTO      RSTRTA
     C                   GOTO      RSTRTA
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      *
      *********
      * ARTYP
      *********
      *
      *  DETERMINES A/R TYPE
      *
     C     ARTYP         BEGSR
     C     ARTTYP        IFEQ      01
     C                   MOVEL     'Inv '        TYPE
     C                   ENDIF
     C     ARTTYP        IFEQ      02
     C                   MOVEL     'Pymt'        TYPE
     C                   ENDIF
     C     ARTTYP        IFEQ      03
     C                   MOVEL     'Pymt'        TYPE
     C                   ENDIF
     C     ARTTYP        IFEQ      04
     C                   MOVEL     'Adj '        TYPE
MJT03C     ARSSUF        IFEQ      'OA'
MJT03C                   MOVE      'OAPY'        TYPE
     C                   MOVEL     'O/A-'        ARCHEK
     C                   MOVE      ARSINV        ARCHEK
MJT03C                   END
MJT03C     ARSSUF        IFEQ      'CM'
MJT03C                   MOVE      'APCM'        TYPE
     C                   MOVEL     'CRM-'        ARCHEK
     C                   MOVE      ARSINV        ARCHEK
MJT03C                   END
     C                   ENDIF
     C     ARTTYP        IFEQ      05
     C                   MOVEL     'Crm '        TYPE
     C                   ENDIF
     C     ARTTYP        IFEQ      06
     C                   MOVEL     'Pymt'        TYPE
     C                   ENDIF
     C     ARTTYP        IFEQ      07
     C                   MOVEL     'L/C '        TYPE
     C                   ENDIF
     C     ARTTYP        IFEQ      08
     C                   MOVEL     'Pymt'        TYPE
     C                   ENDIF
     C     ARTTYP        IFEQ      09
     C                   MOVEL     'Disc'        TYPE
     C                   ENDIF
     C     ARTTYP        IFEQ      10
     C                   MOVEL     'CrCd'        TYPE
     C                   MOVEL     ARCRCD        ARCHEK
     C                   ENDIF
     C     ARTTYP        IFEQ      11
     C                   MOVEL     'DwnP'        TYPE
     C                   ENDIF
     C     ARTTYP        IFEQ      12
     C                   MOVEL     'NSF '        TYPE
     C                   ENDIF
     C                   ENDSR
      *
      ************************************
      *     PRINT SUBROUTINE             *
      ************************************
      *
      * THIS SUBROUTINE PRINTS REPORT IF CMD8 SELECTED FOR PRINT
      *
     C     PRINT         BEGSR
     C                   SETOFF                                       1020
     C                   MOVEL     'N'           OPN
     C                   MOVEL     'XERPRT01'    PRTID
     C     NXTD          TAG
     C                   WRITE     SCRNP
     C                   READ      SCRNP                                  90
     C   KF              GOTO      ENDD
     C                   SETOFF                                       1020
      ** CHECK OPN
     C     OPN           IFNE      'Y'
     C     OPN           ANDNE     'N'
     C                   SETON                                        10
     C                   GOTO      NXTD
     C                   END
      * CHECK PRINTER
     C     PRTID         IFLE      *BLANKS
     C                   SETON                                        20
     C                   GOTO      NXTD
     C                   END
      * INFO OK PRINT REPORT
     C                   MOVEL     LCO           CO
     C                   MOVEL     VACUST        LBCUS
     C                   CALL      'ARC515CCL'
     C                   PARM                    CO                2
     C                   PARM                    LSDAT             7            CYMD
     C                   PARM                    LBCUS             6
     C                   PARM                    OPN               1            ONLY OPEN Y
     C                   PARM                    PRTID
      *
     C     ENDD          ENDSR
      *
      *
      *********
      * #AGDL *
      *********
     C     #AGDL         BEGSR
      *
      *  USE THIS SUBROUTINE TO AGE ITEMS
      *       SUBROUTINE ASSUMES ARRAY #FD HAS BEEN LOADED - USE #AGDY
      *       SUBROUTINE ASSUMES FIELD #WKAOJ HAS BEEN LOADED
      *       LOAD DUE DATE INTO FIELD ##MDY
      *       LOAD DOLLAR AMOUNT INTO FIELD #WKAR$
      *
      *       USE FIELD #PP TO PRINT CURRENT DOLLAR AMOUNTS
      *       USE ARRAY #PP$ TO PRINT PAST DUE AMOUNTS 1 - 5
      *       USE FIELD #WKCR$ TO PRINT TOTAL CURRENT DOLLAR AMOUNTS
      *       USE ARRAY #PD$ TO PRINT TOTAL PAST DUE AMOUNTS 1 - 5
      *       USE ARRAY #FD$ TO FUTURE AGE THE CURRENT AMOUNT
      *
     C                   Z-ADD     0             #PP              11 2
     C                   Z-ADD     *ZEROS        #PP$
     C*                    EXSR @DT@B2
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         #WKTRJ            5 0
      *
      *  SUBTRACT AS OF DATE (JULIAN) FROM DUE DATE (JULIAN)
      *
     C     #WKTRJ        SUB       #WKAOJ        #WKTRJ
     C                   Z-ADD     #WKTRJ        #WKTRR            5 0
      *
      *  ACCUMULATE FOR TOTAL BALANCE
     C                   ADD       #WKAR$        #WKAT$           11 2
      *
      *  TEST DATE RELATIVE TO AGING DAYS - POSITIVE = FUTURE DUE
      *                                     NEGATIVE = PAST DUE
      *
     C     #WKTRJ        IFGE      0
      *
      *  ACCUMULATE CURRENT AMOUNTS AND AGE FUTURE DUE
      *
     C                   ADD       #WKAR$        #WKCR$           11 2
     C                   ADD       #WKAR$        #PP
     C                   Z-ADD     1             X                 1 0
     C     #WKTRJ        LOOKUP    #FD(X)                             90  90
     C   90              ADD       #WKAR$        #FD$(X)
     C  N90              ADD       #WKAR$        #FD$(5)
     C                   ELSE
      *
      *  AGE PAST DUE AMOUNTS
      *
     C                   MLLZO     1             #WKTRJ
     C                   Z-ADD     1             X
     C     #WKTRJ        LOOKUP    #FD(X)                             90  90
     C   90              ADD       #WKAR$        #PD$(X)
     C  N90              ADD       #WKAR$        #PD$(5)
     C   90              ADD       #WKAR$        #PP$(X)
     C  N90              ADD       #WKAR$        #PP$(5)
      *
     C                   END
      *
     C                   ENDSR
     C     #AGDY         BEGSR
      *
      * USE THIS SUBROUTINE TO LOAD AGING DAYS PRINT HEADINGS
      * SUBROUTINE ASSUMES '01' RECORD HAS ALREADY BEEN CHAINED FOR
      * SELECTED COMPANY.
      * LOAD "AS OF DATE" INTO FIELD ##MDY
      *
     C     LCO           CHAIN     FARCTL                             90
     C                   Z-ADD     ACAGPY        #WKP1             3 0
     C                   Z-ADD     ACAGP2        #WKP2             3 0
     C                   Z-ADD     ACAGP3        #WKP3             3 0
     C                   Z-ADD     ACAGP4        #WKP4             3 0
     C                   Z-ADD     1             #WKP0             3 0
     C     #WKP1         ADD       1             #WKP1A            3 0
     C     #WKP2         ADD       1             #WKP2A            3 0
     C     #WKP3         ADD       1             #WKP3A            3 0
     C     #WKP4         ADD       1             #WKP4A            3 0
     C                   Z-ADD     ACAGPY        #FD(1)
     C                   Z-ADD     ACAGP2        #FD(2)
     C                   Z-ADD     ACAGP3        #FD(3)
     C                   Z-ADD     ACAGP4        #FD(4)
      *
      * CONVERT AS OF DATE TO JULIAN DATE
      *
     C*                    EXSR @DT@B2
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE MDY
     C                   PARM                    ##DDD             5 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         #WKAOJ            5 0
      *
     C                   ENDSR
      *********
      * AGING *
      *********
      *    DETERMINE APPROPRIATE AGING AND ACCUMULATE TOTAL
      *
     C     AGING         BEGSR
      *
     C                   Z-ADD     ARDUDT        ##MDY
     C     *LIKE         DEFINE    AR$AMT        #WKAR$
     C                   Z-ADD     AR$AMT        #WKAR$
     C                   EXSR      #AGDL
      *
     C                   ENDSR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     TDATE         VDATE
     C                   Z-ADD     TDATE         ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   MOVEL     ##CYMD        LSDAT
      *
     C                   MOVEL     *BLANKS       LHIST
      *
     C                   ENDSR
      *
      *
      *
     CSR   CMNTKL        BEGSR
     C                   MOVE      LCO           LCOA02           02
     C                   CALL      'ARR223'
     C                   PARM                    VACUST
     C                   PARM      ' '           RETC              1
     C                   PARM                    LCOA02
     C                   PARM                    VDATE             6 0
     C                   PARM                    VACUST            6 0
     C                   PARM                    CMNAME           30
     C                   PARM                    VSCUST            6 0
     C                   PARM                    CSNAME           30
     C                   PARM                    #WKP1             3 0
     C                   PARM                    #PF$1            11 2
     C                   PARM                    CMCNAM           30
     C                   PARM                    #WKP1A            3 0
     C                   PARM                    #WKP2             3 0
     C                   PARM                    #PF$2            11 2
     C                   PARM                    CMPHON           10 0
     C                   PARM                    #WKP2A            3 0
     C                   PARM                    #WKP3             3 0
     C                   PARM                    #PF$3            11 2
     C                   PARM                    CMVOPO            9 2
     C                   PARM                    #WKCR$           11 2
     C                   PARM                    #WKP3A            3 0
     C                   PARM                    #PF$4            11 2
     C                   PARM                    #WKAT$           11 2
     C                   PARM                    CMCRL$            9 2
     CSR                 ENDSR
      *
      *
     OARR22A    E            HDAR           1 03
     O                       PROGID              10
     O**                       RGNAMC    80
     O                       TDATE         Y    120
     O          E            HDAR           2
     O                                           72 'A/R Summary By Customer'
     O                       TIMOD              120 '  :  :  '
     O          E            HDAR           0
     O                                           18 'Customer Name and'
     O                                           26 'Address'
     O                                           71 'Sales and A/R'
     O                                           83 'Information'
     O                                          118 'Y-T-D Information'
     O          E            HDAR           2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETAR          2
     O                                           17 'Customer........'
     O                       HSCUST        Z     24
     O                                           77 'Date First Sale......'
     O                       HSDTFS        Y     86
     O                                          121 'No. Invoices...........'
     O                       HS#INV        Z    127
     O          E            DETAR          1
     O                                           17 'City-ST-Zip.....'
     O                       CMCITY              36
     O                       CMSTST              39
     O                       CMZIP               50
     O                                           77 'Date Last Sale.......'
     O                       HSDTLS        Y     86
     O                                          121 'No. Orders.............'
     O                       HS#ORD        Z    127
     O          E            DETAR          1
     O                                           17 'Telephone #.....'
     O                       CMPHON              30 '   -   -    '
     O                                           77 'Amount Last Sale.....'
     O                       HSAMLS        K     93
     O                                          121 'No. Credit Memos.......'
     O                       HS#CRM        Z    127
     O          E            DETAR          1
     O                                           17 'A/R Contact.....'
     O                       CMCNAM              48
     O          E            DETAR          1
     O                                           77 'Date Last Payment....'
     O                       HSDTLP        Y     86
     O                                          121 'No. Times Delinquent...'
     O                       HSTMDL        Z    127
     O          E            DETAR          1
     O                                           17 'Customer Source.'
     O                       HSSRCE              20
     O                                           77 'Amount Last Payment..'
     O                       HSAMLP        K     93
     O          E            DETAR          1
     O                                           17 'SIC Number......'
     O                       HSSIC#              27
     O                                           77 'Highest A/R Balance..'
     O                       HSHARB        K     93
     O          E            DETAR          1
     O                                           17 'D & B Rating....'
     O                       HSBDRT              23
     O                                           77 'Date Highest Balance.'
     O                       HSDTAR        Y     86
     O          E            DETAR          1
     O                                           17 'Business Size...'
     O                       VBUSSZ        2     28
     O          E            DETAR          1
     O                                           17 'No. Employees...'
     O                       HS#EMP        Z     23
     O                                           77 'Avg # Days To Pay....'
     O                       HSAVDY        Z     83
     O          E            DETAR          1
     O                                           17 'Comments........'
     O                       HSCOM1              48
     O                                           77 'Avg $ Value Order....'
     O                       HSAVOR        K     93
     O          E            DETAR          1
     O                       HSCOM2              48
     O                                           77 'Credit Limit.........'
     O                       CMCRL$        K     93
     O          E            DETAR          1
     O                       HSCOM3              48
     O                                           77 'Available Credit.....'
     O                       SVAVL$        K     93
     O          E            DETAR          1
     O                                           77 'Value Open Orders....'
     O                       CMVOPO        K     93
      *
