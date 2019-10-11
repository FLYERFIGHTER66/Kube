      *****************************************************************
      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2001
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
      *PROGRAM NAME-------- ARH210
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *DESCRIPTION--------- CHECK # INQUIRY
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FFAROPN    IF   E           K DISK
     F                                     RENAME(RAROPN:AROPNI)
     FFAROPNCC  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFHORDW    IF   E           K DISK
     FFARHIST   IF   E           K DISK
     F                                     RENAME(RARHIS:ARHISI)
     FFARHISTC  IF   E           K DISK
      **FFMTERM  IF  E           K        DISK
      **FFARCTL  IF  E           K        DISK
     FARH210FM  CF   E             WORKSTN
     F                                     SFILE(RECSFL:RECNO)
     F*ARH210    O    F  120        PRINTER OFLIND(*INOF)
     FARH210    O    F   80        PRINTER OFLIND(*INOF)
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
     D  LCO                    1      2  0
     D  LCUST                  3      8  0
     D  LHIST                  9      9
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      *
     C     RSTRTA        TAG
     C                   SETOFF                                       7996
     C**                   Z-ADD1         FCNT
     C                   MOVEL     *BLANKS       ALPHA
     C                   MOVEL     *BLANKS       BEGCHK
     C                   MOVEL     *BLANKS       ENDCHK
     C                   Z-ADD     0             CUST
     C                   Z-ADD     0             BEGDAT
     C                   Z-ADD     0             ENDDAT
      *
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      *
     C   KC
     COR KG              GOTO      ENDP
     C                   SETOFF                                       102030
     C                   SETOFF                                       404145
     C                   SETOFF                                       96
      *
     C     CUST          IFEQ      0
     C     ALPHA         ANDGT     *BLANKS
     C                   MOVEL     ALPHA         CMLOOK
     C                   CALL      'LKCUST'
     C                   PARM                    CMLOOK
     C                   PARM                    CMCUST
     C                   PARM                    CMNAME
     C                   MOVEL     *BLANKS       ALPHA
     C                   Z-ADD     CMCUST        CUST
     C                   GOTO      NXTA
     C                   ENDIF
      *
      * TELEPHONE # SEARCH
      *
     C     CUST          IFEQ      0
     C     ALPHA         ANDEQ     *BLANKS
     C     TELE          ANDGT     *BLANKS
     C                   MOVEL     TELE          CMPHON           10 0
     C                   CALL      'LKTELE'
     C                   PARM                    CMPHON
     C                   PARM                    CMCUST            6 0
     C                   PARM                    CMNAME           30
     C                   MOVEL     *BLANKS       TELE
     C                   Z-ADD     CMCUST        CUST
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     CUST          IFEQ      0
     C                   SETON                                        10
     C                   GOTO      NXTA
     C                   ENDIF
     C     CUST          CHAIN     FMCUST                             10
     C   10              GOTO      NXTA
      *
      * VALIDATE CHECK NUMBERS
      *
     C     BEGCHK        IFGT      *BLANKS
     C     ENDCHK        IFLE      *BLANKS
     C                   MOVEL     BEGCHK        ENDCHK
     C                   END
     C     BEGCHK        IFGT      ENDCHK
     C                   SETON                                        20
     C                   GOTO      NXTA
     C                   END
     C                   END
      *
      * VALIDATE DATES DATE
      *
     C     BEGDAT        IFGT      0
     C                   Z-ADD     BEGDAT        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        40
     C                   GOTO      NXTA
     C                   ENDIF
     C                   MOVEL     ##CYMD        BDATE             7 0
     C                   ELSE
     C                   Z-ADD     0             BDATE
     C                   END
      *
     C     BEGDAT        IFGT      0
     C     ENDDAT        ANDLE     0
     C                   Z-ADD     BEGDAT        ENDDAT
     C                   END
     C     ENDDAT        IFGT      0
     C                   Z-ADD     ENDDAT        ##MDY             6 0
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C     ##ERR         IFEQ      'Y'
     C                   SETON                                        45
     C                   GOTO      NXTA
     C                   ENDIF
     C                   MOVEL     ##CYMD        EDATE             7 0
     C                   ELSE
     C                   Z-ADD     0             EDATE
     C                   END
      *
     C     BDATE         IFGT      EDATE
     C                   SETON                                        4041
     C                   GOTO      NXTA
     C                   END
      ** CHECK FOR AT LEAST 1 SELECTION
     C     BDATE         IFLE      0
     C     BEGCHK        ANDLE     *BLANKS
     C                   SETON                                        30
     C                   GOTO      NXTA
     C                   END
      *
     C     VACUST        SETLL     FAROPN
     C                   MOVE      '1'           *IN80
     C                   WRITE     RECCTL
     C                   MOVE      '0'           *IN80
     C                   Z-ADD     0             RECNO             5 0
      *
     C                   EXSR      BLDSFL
     C     RECNO         IFLE      0
     C                   SETON                                        96
     C                   GOTO      NXTA
     C                   END
      *
     C     NXTFMT        TAG
     C     PAGE#         IFLE      0
     C     PAGE#         ORGT      999
     C                   Z-ADD     1             PAGE#
     C                   END
     C                   EXFMT     RECCTL
     C                   SETOFF                                       77
     C     NOTOT         TAG
     C*  KJ                DO                              COLLECTION COMMENTS
     C*                    EXSR CMNTKJ
     C*                    GOTO NXTFMT
     C*                    ENDDO
     C*  KL                DO                              COMMENTS DISPLAY
     C*                    EXSR CMNTKL
     C*                    GOTO NXTFMT
     C*                    ENDDO
     C   KK              DO                                                     VIEW INVOICEPLAY
     C     LINE          IFLE      0
     C                   SETON                                        77
     C                   GOTO      NXTFMT
     C                   END
     C     LINE          CHAIN     RECSFL                             77
     C   77              GOTO      NXTFMT
     C                   Z-ADD     LINE          PAGE#
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
     C                   Z-ADD     INV#          INVINI           15 5
     C                   CALL      'BIR337CL'
     C                   PARM                    INVINI
     C                   PARM                    TYPO
     C                   GOTO      NXTFMT
     C                   ENDDO
     C   KC
     COR KG              GOTO      ENDP
     C   KH              EXSR      PRINT
     C** KH                GOTO RSTRTA
     C** KI                GOTO RSTRTD
     C** KA                GOTO RSTRTC
     C   KF              GOTO      RSTRTA
     C                   GOTO      NXTFMT
      *
     C     ENDP          TAG
     C                   SETON                                        LR
      *
      ******************
      * BUILD SUB FILE *
      ******************
      *
     C     BLDSFL        BEGSR
     C                   SETON                                        80
     C                   WRITE     RECCTL
     C                   SETOFF                                       80
     C                   Z-ADD     0             RECNO             5 0
     C                   Z-ADD     0             CKTOT            11 2
     C                   MOVE      *BLANKS       OCHEK            10
     C     CHKKEY        KLIST
     C                   KFLD                    CUST
     C                   KFLD                    BEGCHK
     C     CHKKEY        SETLL     FAROPNCC
     C     CHKKEY        SETLL     FARHISTC
      ** READ BOTH FIRST
     C     NAR1          TAG
     C     CUST          READE     FAROPNCC                               91
     C  N91BDATE         IFGT      0
     C     ARTDAT        IFLT      BDATE
     C     ARTDAT        ORGT      EDATE
     C                   GOTO      NAR1
     C                   END
     C                   END
     C     NHS1          TAG
     C     CUST          READE     FARHISTC                               92
     C  N92BDATE         IFGT      0
     C     AHTDAT        IFLT      BDATE
     C     AHTDAT        ORGT      EDATE
     C                   GOTO      NHS1
     C                   END
     C                   END
     C     NXTBLD        TAG
      ** CHECK CHECK NUMBERS
     C     BEGCHK        IFGT      *BLANKS
     C     ARCHEK        IFGT      ENDCHK
     C                   SETON                                        91
     C                   END
     C     AHCHEK        IFGT      ENDCHK
     C                   SETON                                        92
     C                   END
     C                   END
     C   91
     CAN 92              GOTO      ENDBLD
      ** DECIDE WHICH RECORD TO SHOW
     C                   SETOFF                                       939495
     C  N91
     CANN92AHCHEK        COMP      ARCHEK                             939495
     C  N91
     CANN92
     CAN 95AHINV#        COMP      ARINV#                             949393
      ** USE AROPN RECORD
     C   92                                                                     EOF ARHIST
     COR 93              DO
     C     ARCHEK        IFNE      OCHEK
     C     OCHEK         IFGT      *BLANKS
     C                   SETON                                        57
     C                   MOVEL     'Check To'    CHEK
     C                   MOVE      't.'          CHEK
     C                   ADD       1             RECNO
     C                   Z-SUB     CKTOT         AMT$
     C                   MOVEL     'TOT '        TYPE
     C                   WRITE     RECSFL
     C                   END
     C                   MOVEL     ARCHEK        OCHEK
     C                   Z-ADD     0             CKTOT
     C                   SETOFF                                       57
     C                   END
     C                   Z-ADD     AR$AMT        CKAMT            11 2
     C                   Z-ADD     ARTDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         CTRNDT            6 0
     C                   Z-ADD     ARTTYP        CTYP              2 0
     C                   MOVEL     ARCHEK        CHK#             10
     C     OPNKEY        KLIST
     C                   KFLD                    ARCUST
     C                   KFLD                    ARINV#
     C                   KFLD                    ARSUFF
     C                   KFLD                    SEQ#
     C                   Z-ADD     0             SEQ#              3 0
     C     OPNKEY        CHAIN     FAROPN                             71
     C                   EXSR      ARTYP
     C                   Z-ADD     ARTDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         TDAT
     C                   Z-ADD     ARDUDT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         DUDT
     C     AR$AMT        ADD       CKAMT         DUE$
     C                   Z-ADD     ARINV#        INV#
     C                   MOVEL     ARSUFF        SUFF
     C                   MOVEL     ARCHEK        CHEK
     C                   Z-ADD     AR$AMT        AMT$
     C                   SETOFF                                       54
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
      ** NOW OUTPUT THE CHECK RECORD
     C                   MOVEL     'Pymt'        TYPE
     C                   MOVE      *BLANKS       ARSUFF
     C                   Z-ADD     CTRNDT        TDAT
     C                   Z-ADD     0             DUDT
     C                   MOVEL     CHK#          CHEK
     C                   Z-ADD     CKAMT         AMT$
     C                   ADD       CKAMT         CKTOT
     C                   Z-ADD     0             DUE$
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
      **READ NXT AROPNCC RECORD
     C     NAR2          TAG
     C     CUST          READE     FAROPNCC                               91
     C  N91BDATE         IFGT      0
     C     ARTDAT        IFLT      BDATE
     C     ARTDAT        ORGT      EDATE
     C                   GOTO      NAR2
     C                   END
     C                   END
     C                   GOTO      NXTBLD
     C                   ENDDO
      ** USE ARHIST RECORD
     C   91                                                                     EOF AROPN
     COR 94              DO
     C     AHCHEK        IFNE      OCHEK
     C     OCHEK         IFGT      *BLANKS
     C                   SETON                                        57
     C                   MOVEL     'Check To'    CHEK
     C                   MOVE      't.'          CHEK
     C                   ADD       1             RECNO
     C                   Z-SUB     CKTOT         AMT$
     C                   MOVEL     'TOT '        TYPE
     C                   WRITE     RECSFL
     C                   END
     C                   MOVEL     AHCHEK        OCHEK
     C                   Z-ADD     0             CKTOT
     C                   SETOFF                                       57
     C                   END
     C                   Z-ADD     AH$AMT        CKAMT            11 2
     C                   Z-ADD     AHTDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         CTRNDT            6 0
     C                   Z-ADD     AHTTYP        CTYP              2 0
     C                   MOVEL     AHCHEK        CHK#             10
     C     HISKEY        KLIST
     C                   KFLD                    AHCUST
     C                   KFLD                    AHINV#
     C                   KFLD                    AHSUFF
     C                   KFLD                    SEQ#
     C                   Z-ADD     0             SEQ#              3 0
     C     HISKEY        CHAIN     FARHIST                            71
     C                   EXSR      AHTYP
     C                   Z-ADD     AHTDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         TDAT
     C                   Z-ADD     AHDUDT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         DUDT
     C     AH$AMT        ADD       CKAMT         DUE$
     C                   Z-ADD     AHINV#        INV#
     C                   MOVEL     AHSUFF        SUFF
     C                   MOVEL     AHCHEK        CHEK
     C                   Z-ADD     AH$AMT        AMT$
     C                   SETON                                        54
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
      ** NOW OUTPUT THE CHECK RECORD
     C                   MOVEL     'Pymt'        TYPE
     C                   MOVE      *BLANKS       ARSUFF
     C                   Z-ADD     CTRNDT        TDAT
     C                   Z-ADD     0             DUDT
     C                   MOVEL     CHK#          CHEK
     C                   Z-ADD     CKAMT         AMT$
     C                   ADD       CKAMT         CKTOT
     C                   Z-ADD     0             DUE$
     C                   ADD       1             RECNO
     C                   WRITE     RECSFL
      **READ NXT ARHISTC RECORD
     C     NHS2          TAG
     C     CUST          READE     FARHISTC                               92
     C  N92BDATE         IFGT      0
     C     AHTDAT        IFLT      BDATE
     C     AHTDAT        ORGT      EDATE
     C                   GOTO      NHS2
     C                   END
     C                   END
     C                   SETOFF                                       54
     C                   GOTO      NXTBLD
     C                   ENDDO
     C     ENDBLD        TAG
     C     OCHEK         IFGT      *BLANKS
     C                   SETON                                        57
     C                   MOVEL     'Check To'    CHEK
     C                   MOVE      't.'          CHEK
     C                   ADD       1             RECNO
     C                   Z-SUB     CKTOT         AMT$
     C                   MOVEL     'TOT '        TYPE
     C                   WRITE     RECSFL
     C                   END
     C                   SETOFF                                       57
     C                   Z-ADD     RECNO         LSTREC            5 0
     C                   ENDSR
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
     C                   MOVEL     'RetC'        TYPE
     C                   ENDIF
     C     ARTTYP        IFEQ      14
     C                   MOVEL     'CkCh'        TYPE
     C                   ENDIF
     C                   ENDSR
      *
      *
      *********
      * AHTYP
      *********
      *
      *  DETERMINES A/R TYPE
      *
     C     AHTYP         BEGSR
     C     AHTTYP        IFEQ      01
     C                   MOVEL     'Inv '        TYPE
     C                   ENDIF
     C     AHTTYP        IFEQ      02
     C                   MOVEL     'Pymt'        TYPE
     C                   ENDIF
     C     AHTTYP        IFEQ      03
     C                   MOVEL     'Pymt'        TYPE
     C                   ENDIF
     C     AHTTYP        IFEQ      04
     C                   MOVEL     'Adj '        TYPE
     C                   ENDIF
     C     AHTTYP        IFEQ      05
     C                   MOVEL     'Crm '        TYPE
     C                   ENDIF
     C     AHTTYP        IFEQ      06
     C                   MOVEL     'Pymt'        TYPE
     C                   ENDIF
     C     AHTTYP        IFEQ      07
     C                   MOVEL     'L/C '        TYPE
     C                   ENDIF
     C     AHTTYP        IFEQ      08
     C                   MOVEL     'Pymt'        TYPE
     C                   ENDIF
     C     AHTTYP        IFEQ      09
     C                   MOVEL     'Disc'        TYPE
     C                   ENDIF
     C     AHTTYP        IFEQ      10
     C                   MOVEL     'CrCd'        TYPE
     C                   MOVEL     ARCRCD        ARCHEK
     C                   ENDIF
     C     AHTTYP        IFEQ      11
     C                   MOVEL     'DwnP'        TYPE
     C                   ENDIF
     C     AHTTYP        IFEQ      12
     C                   MOVEL     'RetC'        TYPE
     C                   ENDIF
     C     AHTTYP        IFEQ      14
     C                   MOVEL     'CkCh'        TYPE
     C                   ENDIF
     C                   ENDSR
      *
      ***********************
      ** PRINT DETAIL      **
      ***********************
     C     PRINT         BEGSR
     C                   SETON                                        OF
     C                   SETOFF                                       3738
     C     BEGCHK        IFGT      *BLANKS
     C                   SETON                                        37
     C                   END
     C     BEGDAT        IFGT      0
     C                   SETON                                        38
     C                   END
     C                   Z-ADD     0             RECNO
     C     NXTPRT        TAG
     C                   ADD       1             RECNO
     C     RECNO         IFGT      LSTREC
     C                   GOTO      ENDPRT
     C                   END
     C     RECNO         CHAIN     RECSFL                             95
     C   95              GOTO      NXTPRT
     C   OF              DO
     C                   EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   ENDDO
     C     TYPE          IFEQ      'TOT'
     C                   EXCEPT    TOTL
     C                   GOTO      NXTPRT
     C                   END
     C     TYPE          IFEQ      'Pymt'
     C                   EXCEPT    DETP
     C                   GOTO      NXTPRT
     C                   END
     C                   MOVE      *BLANKS       SHIPTO
     C     TYPE          IFEQ      'Inv '
     C     INV#          CHAIN     FHORDW                             55
     C* N55              MOVEL     WHNAME        SHIPTO           30
     C  N55              MOVEL     WHNAME        SHIPTO           26
     C                   END
     C                   EXCEPT    DETL
     C                   GOTO      NXTPRT
     C     ENDPRT        TAG
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
      *
     C                   MOVEL     *BLANKS       LHIST
      *
     C                   ENDSR
      *
     CSR   CMNTKJ        BEGSR
     C                   CALL      'ARR222'
     C                   PARM                    VACUST
     C                   PARM      ' '           RETC             01
     C     RETC          IFEQ      'A'
     C                   EXSR      CMNTKL
     C                   END
     CSR                 ENDSR
      *
      *
     CSR   CMNTKL        BEGSR
     C                   MOVE      LCO           LCOA02           02
     C                   CALL      'ARR223'
     C                   PARM                    VACUST
     C                   PARM      ' '           RETC
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
      *******************
      * PRINT REPORT    *
      *******************
     OARH210    E            HDG            1 03
     O                                            6 'ARH210'
     O                                           21 'Requested by:'
     O                       USERID              32
     O                                           50 'A/R Check Inquiry'
     O                       PAGE          4     80
     O                                           77 'Page:'
     O          E            HDG            1
     O                       TDATE         Y      8
     O                       TIMOD               80 '  :  :  '
     O          E            HDG            1
     O                                            9 'Customer:'
     O                       CMCUST        4     16
     O                       CMNAME              47
     O                                           54 'Phone:'
     O                       CMPHON              67 '   -   -    '
     O          E            HDG            1
     O                                            8 'Contact:'
     O                       CMCNAM              39
     O          E            HDG            2
     O                                           19 'Check number: From-'
     O               37      BEGCHK              30
     O               37                          35 '-To-'
     O               37      ENDCHK              46
     O              N37                          32 '*** All Checks ***'
     O*                                          60 'Date Range:'
     O                                           55 'Date Range:'
     O*              38      BEGDAT        Y     69
     O               38      BEGDAT        Y     64
     O*              38                          76 '-Thru-'
     O               38                          71 '-Thru-'
     O*              38      ENDDAT        Y     85
     O               38      ENDDAT        Y     80
     O*             N38                          78 '*** All Dates ***'
     O              N38                          73 '*** All Dates ***'
     O          E            HDG            1
     O                                           27 '------Dates------'
     O          E            HDG            0
     O                                            6 'Inv.# '
     O                                           18 'Trans '
     O                                           27 'Due '
     O                                           42 'Amount '
     O                                           53 'Check Numb'
     O                                           66 'Ship To Name'
     O          E            HDG            1
     O                                           20 '____________________'
     O                                           40 '____________________'
     O                                           60 '____________________'
     O                                           80 '____________________'
     O*                                          85 '_____'
     O          EF           DETL           1
     O                       INV#          4      6
     O                       SUFF                 9
     O                       TDAT          Y     18
     O                       DUDT          Y     27
     O                       AMT$          K     42
     O*                      SHIPTO              84
     O                       SHIPTO              80
     O          EF           DETP           1
     O**                       INV#  4    6
     O**                       SUFF       9
     O                       TDAT          Y     18
     O                       AMT$          K     42
     O                       CHEK                53
     O          EF           TOTL           1
     O                                           42 '=========='
     O          EF           TOTL           2
     O                                           27 'Check Total=========>'
     O                       AMT$          K     42
