      *--------------------------------------------------------------     ARR510
      *                                                                   ARR510
      *                                                                   ARR510
      *--------------------------------------------------------------     ARR510
      *PROGRAM NAME-------- ARR510                                        ARR510
      *SYSTEM-------------- ACCOUNTS RECEIVABLE                           ARR510
      *APPLICATION--------- PRINT STATEMENTS                              ARR510
      *                                                                   ARR510
      *                                                                   ARR510
      * 34 - A/R CODE EQUAL TO BALANCE FORWARD                            ARR510
      *                                                                   ARR510
     FFARTOT    IF   E           K DISK
     FFAROPNDD  IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFCMREAS   IF   E           K DISK
     FFARCTL    IF   E           K DISK
     FARR510A   O    F  120        PRINTER OFLIND(*INOF)                        ARR510
      *                                                                   ARR510
     D #SL             S             32    DIM(6)
     D #PD$            S             11  2 DIM(3)                               PAST DUE $
     D #FD             S              5  0 DIM(2) ASCEND                        AGING DAYS ARRAY
     D LDAC            S              1  0 DIM(9) ASCEND                        STATEMENT CYCLE  ARR
     D*                   MSG     1  15 30
     D MSG             S             21    DIM(15) CTDATA PERRCD(1)
      *                                                                   ARR510
     D                UDS                                                       ARR510
     D  LCO                    1      2  0
     D  LDATE                  3      8  0
     D  LBCUST                 9     14  0
     D  LECUST                15     20  0
     D  LZERO                 21     21
     D  LCRED                 22     22
     D  LSDATE                23     29  0
     D  LC1                   67     67  0
     D  LC2                   68     68  0
     D  LC3                   69     69  0
     D  LC4                   70     70  0
     D  LC5                   71     71  0
     D  LC6                   72     72  0
     D  LC7                   73     73  0
     D  LC8                   74     74  0
     D  LC9                   75     75  0
     D  LCYCL9                75     75  0
     D  LBFDTE                76     81  0
     D  LSHTOT                82     82
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  LPROG                134    141
     D  LNAME                142    171
      *                                                                   ARR510
     IRMCUST
     I              CMNAME                      #WSLD1
     I              CMADD2                      #WSLD2
     I              CMADD3                      #WSLD3
     I              CMADD4                      #WSLD4
     I              CMCITY                      #WSLCT
     I              CMSTST                      #WSLST
     I              CMZIP                       #WSLZP
      *
     C*                    Z-ADD0         OARINV
      *
     C     LCO           CHAIN     FARCTL                             90                       ARR51
     C                   EXSR      #STDY                                                       ARR51
      *
     C                   MOVEL     ACCOM1        ARMSG1           30                           ARR51
     C                   MOVEL     ACCOM2        ARMSG2           30                           ARR51
     C                   MOVEL     ACCOM3        ARMSG3           30                           ARR51
     C                   MOVEL     ACCOM4        ARMSG4           30                           ARR51
      *
     C                   Z-ADD     LSDATE        ##CYMD
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         RDATE             5 0
      *
      * PRINT ZERO BALANCE STATEMENTS
      *
     C     LZERO         IFEQ      'N'                                                         ARR51
     C                   SETON                                        40
     C                   ENDIF
      *
      * NO CREDIT BALANCE STATEMENTS
      *                                                                   ARR510
     C     LCRED         IFEQ      'N'                                                         ARR51
     C                   SETON                                        41
     C                   ENDIF
      *                                                                   ARR510
      * CHECK FOR SPECIFIC CUSTOMERS
      *                                                                   ARR510
     C     LBCUST        IFGT      0                                                           ARR51
     C                   SETON                                        42
     C                   ENDIF
      *                                                                   ARR510
      * CYCLE CODES
      *
     C                   SORTA     LDAC                                                        ARR51
      *                                                                   ARR510
     C     NXTC          TAG
     C                   Z-ADD     0             PAGE1
     C                   Z-ADD     0             PRT               6 0
     C                   Z-ADD     1             CNT               6 0
     C                   Z-ADD     1             CNTA              6 0
     C                   SETOFF                                       34
     C                   READ      FARTOT                                 90
     C   90              GOTO      END
      *                                                                   ARR510
     C   40RT$AMT        IFEQ      0
     C                   GOTO      NXTC
     C                   ENDIF
      *
     C   41RT$AMT        IFLT      0
     C                   GOTO      NXTC
     C                   ENDIF
      *                                                                   ARR510
     C   42RTCUST        IFLT      LBCUST
     C     RTCUST        ORGT      LECUST
     C                   GOTO      NXTC
     C                   ENDIF
      *                                                                   ARR510
     C     RTCUST        SETLL     FAROPNDD
      *                                                                   ARR510
     C     NXTA          TAG
     C     RTCUST        READE     FAROPNDD                               90
     C     ARCOMP        IFNE      LCO
     C                   GOTO      NXTA
     C                   ENDIF
     C   90              DO
     C                   EXSR      PRINT
     C                   EXCEPT    TL2
RPADDC                   EXSR      CLRFLD
     C                   GOTO      NXTC
     C                   ENDDO
     C                   EXSR      CRMEMO                                                      ARR51
      *                                                                   ARR510
     C     CNT           IFEQ      1
     C                   EXSR      VALID                                                       ARR51
     C   97              GOTO      NXTC                                                        ARR51
     C                   ENDIF
      *                                                                   ARR510
      * 34 = BALANCE FORWARD CUSTOMER                                     ARR510
      *                                                                   ARR510
     C   34CNT           IFEQ      1
     C     CMARCD        ANDEQ     'B'
     C                   EXSR      GETBAL                                                      ARR51
     C                   EXSR      #SLD                                                        ARR51
     C                   EXCEPT    HDG                                                         ARR51
     C                   Z-ADD     ARCUST        OLCUST            6 0
     C                   ADD       1             PRT
     C                   ADD       1             CNT
     C                   ENDIF
      *                                                                   ARR510
      *  PRINT ONLY IF TRANS. DATE <= TO AS OF DATE
      *                                                                   ARR510
     C                   Z-ADD     ARTDAT        ##MDY             6 0
      *                                                                   ARR510
     C     ARTDAT        IFGT      LSDATE
     C                   GOTO      NXTA
     C                   ENDIF
      *                                                                   ARR510
     C*  34      ARTDAT    IFLT BDATE
     C*                    GOTO NXTA
     C*                    ENDIF
      *                                                                   ARR510
     C                   EXSR      GETLN                                                       ARR51
      * FOR ON-ACCOUNT MOVE ARDUE$ TO AR$AMT IF ZERO SKIP RECORD.         ARR510
     C     ARSUFF        IFEQ      'OA'
     C                   Z-ADD     ARDUE$        AR$AMT
     C     AR$AMT        IFEQ      0
     C                   GOTO      NXTA
     C                   END
     C                   END
      *                                                                   ARR510
     C                   EXSR      AGING                                                       ARR51
      *                                                                   ARR510
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
     C                   Z-ADD     ##MDY         DDAT              6 0
      *
     C                   ADD       1             CNTA
      *
     C     ARINV#        IFNE      OARINV
RP   C     ARSTAT        OREQ      'L'
     C***        CNTA      ANDGT1
     C**         OARINV    ANDGT0
     C                   EXSR      PRINT
     C                   Z-ADD     TDAT          OTDAT             6 0
     C                   Z-ADD     DDAT          ODDAT             6 0
     C                   Z-ADD     ARCUST        OLCUST            6 0
     C                   Z-ADD     INVAMT        OINV             11 2
     C                   Z-ADD     PAYAMT        OPAY             11 2
     C                   Z-ADD     ARDUE         ODUE             11 2
     C                   Z-ADD     ARINV#        OARINV            6 0
     C                   Z-ADD     ARSEQ#        OSEQ              3 0
     C                   MOVEL     ARSUFF        OSUFF             2
     C                   MOVEL     DESC          ODESC            21
     C                   ADD       1             PRT
     C                   Z-ADD     0             INVAMT
     C                   Z-ADD     0             PAYAMT
     C                   Z-ADD     0             ARDUE
     C                   ADD       1             CNT
     C*                    GOTO NXTA
     C                   ENDIF
      *                                                                   ARR510
EFD01C     ARTTYP        IFEQ      01
EFD01C     ARTTYP        OREQ      14
EFD01C     ARTTYP        OREQ      12
EFD01C     ARTTYP        OREQ      07
EFD01C                   ADD       AR$AMT        INVAMT           11 2
EFD01C                   ENDIF
EFD01 *
EFD01C     ARTTYP        IFEQ      02
EFD01C     ARTTYP        OREQ      03
EFD01C     ARTTYP        OREQ      04
EFD01C     ARTTYP        OREQ      05
EFD01C     ARTTYP        OREQ      10
EFD01C                   ADD       AR$AMT        PAYAMT           11 2
EFD01C                   ENDIF
EFD01 *
     C                   GOTO      NXTA
      *                                                                   ARR510
      * IF OA AND DETAIL SKIP RECORD
      *                                                                   ARR510
     C*          ARSUFF    IFEQ 'OA'
     C*          ARSEQ#    ANDGT000
     C*                    GOTO NXTA
     C*                    END
      *                                                                   ARR510
     C     END           TAG                                                                   ARR51
     C     CNT           IFGT      1
     C                   EXCEPT    TL2                                                         ARR51
     C                   END
     C                   SETON                                        LR
      *                                                                   ARR510
      **********                                                          ARR510
      * PRINT  *                                                          ARR510
      **********                                                          ARR510
      *  DETERMINES IF LINE SHOULD PRINT                                  ARR510
      *                                                                   ARR510
     C     PRINT         BEGSR                                                                 ARR51
     C     INVAMT        ADD       PAYAMT        ARDUE            11 2
     C                   ADD       ARDUE         TOTCUS           11 2
     C     CNT           IFEQ      1
     C                   EXSR      #SLD                                                        ARR51
     C                   EXCEPT    HDG                                                         ARR51
     C                   END
     C   OF              DO                                                                    ARR51
     C                   EXCEPT    HDG                                                         ARR51
     C                   ENDDO
     C*          INVAMT    IFNE 0
     C*          PAYAMT    ANDNE0
     C     CNT           IFNE      1
     C                   EXCEPT    DETL                                                        ARR51
     C                   END
     C                   ENDSR
      *                                                                   ARR510
      **********                                                          ARR510
      * VALID  *                                                          ARR510
      **********                                                          ARR510
      *  DETERMINES IF CUSTOMER SHOULD PRINT THIS CYCLE                   ARR510
      *                                                                   ARR510
     C     VALID         BEGSR                                                                 ARR51
      *                                                                   ARR510
     C     ARCUST        CHAIN     FMCUST                             97                       ARR51
     C   97              GOTO      ENDV                                                        ARR51
      *                                                                   ARR510
      *  VALIDATE STATEMENT CYCLE CODE                                    ARR510
      *                                                                   ARR510
     C                   SETOFF                                       9731                     ARR51
     C                   XFOOT     LDAC          CODE              2 0
     C     CODE          IFEQ      *ZEROS
     C                   GOTO      NCODE
     C                   ENDIF
     C                   MOVE      CMSMCD        STCD              1 0                         ARR51
     C     CMSMCD        IFGT      *ZEROS                                                      ARR51
     C     STCD          LOOKUP    LDAC                                   31                   ARR51
     C  N31              SETON                                        97                       ARR51
     C   97              GOTO      ENDV                                                        ARR51
     C                   ENDIF
     C     NCODE         TAG
      *                                                                   ARR510
      *  IS CUSTOMER BALANCE FORWARD OR OPEN INVOICE                      ARR510
      *                                                                   ARR510
     C     CMARCD        IFEQ      'B'                                                         ARR51
     C                   SETON                                        34                       ARR51
     C                   ENDIF                                                                 ARR51
      *                                                                   ARR510
     C     ENDV          ENDSR                                                                 ARR51
      *                                                                   ARR510
      ***********                                                         ARR510
      * CRMEMO  *                                                         ARR510
      ***********                                                         ARR510
      *  SPREAD CREDIT MEMO AMOUNTS                                       ARR510
      *                                                                   ARR510
     C     CRMEMO        BEGSR                                                                 ARR51
      *                                                                   ARR510
     C     #PD$(3)       IFGT      *ZEROS                                                      ARR51
     C     #PD$(3)       ADD       #WKTCR        #PD$(3)                81                     ARR51
     C  N81              Z-ADD     0             #WKTCR                                        ARR51
     C   81              Z-ADD     #PD$(3)       #WKTCR                                        ARR51
     C   81              Z-ADD     0             #PD$(3)                                       ARR51
     C                   END                                                                   ARR51
      *                                                                   ARR510
     C     #PD$(2)       IFGT      *ZEROS                                                      ARR51
     C     #PD$(2)       ADD       #WKTCR        #PD$(2)                81                     ARR51
     C  N81              Z-ADD     0             #WKTCR                                        ARR51
     C   81              Z-ADD     #PD$(2)       #WKTCR                                        ARR51
     C   81              Z-ADD     0             #PD$(2)                                       ARR51
     C                   END                                                                   ARR51
      *                                                                   ARR510
     C     #PD$(1)       IFGT      *ZEROS                                                      ARR51
     C     #PD$(1)       ADD       #WKTCR        #PD$(1)                81                     ARR51
     C  N81              Z-ADD     0             #WKTCR                                        ARR51
     C   81              Z-ADD     #PD$(1)       #WKTCR                                        ARR51
     C   81              Z-ADD     0             #PD$(1)                                       ARR51
     C                   END                                                                   ARR51
      *                                                                   ARR510
     C   81              ADD       #WKTCR        #WKCR$                                        ARR51
     C                   ENDSR                                                                 ARR51
      *                                                                   ARR510
      **********                                                          ARR510
      * GETLN  *                                                          ARR510
      **********                                                          ARR510
     C     GETLN         BEGSR                                                                 ARR51
      *                                                                   ARR510
     C                   SETOFF                                       010203                   ARR51
     C                   SETOFF                                       040507                   ARR51
     C                   SETOFF                                       0809                     ARR51
      *                                                                   ARR510
      * LOAD DESCRIPTION FIELDS                                           ARR510
      *                                                                   ARR510
     C                   MOVE      *BLANKS       DESC1                                         ARR51
     C                   MOVE      *BLANKS       DESC             21                           ARR51
     C     ARTTYP        IFEQ      01                                                          ARR51
     C                   MOVEL     MSG(1)        DESC                                          ARR51
     C                   ENDIF
     C     ARTTYP        IFEQ      02                                                          ARR51
     C     ARTTYP        OREQ      03                                                          ARR51
     C     ARTTYP        OREQ      08                                                          ARR51
     C                   MOVEL     MSG(2)        DESC                                          ARR51
     C                   ENDIF
     C     ARTTYP        IFEQ      10                                                          ARR51
     C                   MOVEL     MSG(9)        DESC1            24                           ARR51
     C                   MOVE      ARCRCD        DESC1
     C                   MOVEL     DESC1         DESC
     C                   ENDIF
     C     ARTTYP        IFEQ      04                                                          ARR51
     C     ARDESC        ANDGT     *BLANKS
     C                   MOVEL     ARDESC        DESC                                          ARR51
     C                   ENDIF
     C     ARTTYP        IFEQ      04                                                          ARR51
     C     ARDESC        ANDEQ     *BLANKS
     C     RKEY          KLIST
     C                   KFLD                    LCO
     C                   KFLD                    ARREAS
     C     RKEY          CHAIN     FCMREAS                            94
     C                   MOVEL     CRDESC        DESC                                          ARR51
     C                   ENDIF
MJT01C     ARTTYP        IFEQ      04                                                          ARR51
MJT01C     ARSSUF        IFEQ      'OA'
MJT01C                   MOVEL     MSG(10)       DESC
MJT01C                   END
MJT01C     ARSSUF        IFEQ      'CM'
MJT01C                   MOVEL     MSG(11)       DESC
MJT01C                   MOVEL     ARSINV        DESC08           08
MJT01C                   MOVE      DESC08        DESC
MJT01C                   END
MJT01C                   END
     C     ARTTYP        IFEQ      05                                                          ARR51
     C                   MOVEL     MSG(3)        DESC                                          ARR51
     C                   ENDIF
     C     ARTTYP        IFEQ      07                                                          ARR51
     C                   MOVEL     MSG(4)        DESC                                          ARR51
     C                   ENDIF
     C     ARTTYP        IFEQ      09                                                          ARR51
     C                   MOVEL     MSG(5)        DESC                                          ARR51
     C                   ENDIF
     C     ARTTYP        IFEQ      11                                                          ARR51
     C                   MOVEL     MSG(6)        DESC                                          ARR51
     C                   ENDIF
     C     ARTTYP        IFEQ      12                                                          ARR51
     C                   MOVEL     MSG(7)        DESC                                          ARR51
     C                   ENDIF
     C     ARTTYP        IFEQ      14                                                          ARR51
     C                   MOVEL     MSG(8)        DESC                                          ARR51
     C                   ENDIF
      *                                                                   ARR510
     C     ENDLN         ENDSR                                                                 ARR51
      **********                                                          ARR510
      * GETBAL *                                                          ARR510
      **********                                                          ARR510
     C     GETBAL        BEGSR                                                                 ARR51
     C     RTCUST        SETLL     FAROPNDD                                                    ARR51
     C                   SETOFF                                       35                       ARR51
     C     NXTBAL        TAG
     C     RTCUST        READE     FAROPNDD                               35                   ARR51
     C   35              GOTO      ENDBL                                                       ARR51
      *                                                                   ARR510
     C     ARCOMP        IFNE      LCO
     C                   GOTO      NXTBAL
     C                   ENDIF
      *                                                                   ARR510
     C*          ADATE     IFGT BDATE
     C*                    GOTO NXTBAL
     C*                    ENDIF
      *                                                                   ARR510
     C                   Z-ADD     ARTTYP        #WKTT                                         ARR51
     C                   EXSR      GETLN                                                       ARR51
      *                                                                   ARR510
     C                   EXSR      AGING                                                       ARR51
     C                   EXSR      CRMEMO                                                      ARR51
     C                   ADD       AR$AMT        #WKBLF           11 2                         ARR51
      *                                                                   ARR510
     C                   GOTO      NXTBAL                                                      ARR51
      *                                                                   ARR510
     C     ENDBL         ENDSR                                                                 ARR51
      *                                                                   ARR510
      *********                                                           ARR510
      * AGING *                                                           ARR510
      *********                                                           ARR510
      *    THIS LOADS THE WORK FIELDS NEEDED FOR AGING.                   ARR510
      *                                                                   ARR510
     C     AGING         BEGSR                                                                 ARR51
      *                                                                   ARR510
     C     *LIKE         DEFINE    AR$AMT        #WKAR$                                        ARR51
     C                   Z-ADD     AR$AMT        #WKAR$                                        ARR51
     C                   Z-ADD     ARDUDT        ##CYMD                                        ARR51
     C                   Z-ADD     ARTTYP        #WKTT                                         ARR51
     C                   EXSR      #STDL                                                       ARR51
     C                   ENDSR                                                                 ARR51
      **********                                                          ARR510
      * CLRFLD *                                                          ARR510
      **********                                                          ARR510
     C     CLRFLD        BEGSR                                                                 ARR51
      *                                                                   ARR510
     C                   Z-ADD     0             #WKAT$                                        ARR51
     C                   Z-ADD     *ZEROS        #PD$                                          ARR51
     C                   Z-ADD     0             #WKCR$                                        ARR51
     C                   Z-ADD     0             #WKAR$                                        ARR51
     C                   Z-ADD     0             #WKTCR                                        ARR51
     C                   Z-ADD     0             #WKPCR                                        ARR51
     C                   Z-ADD     0             #WKTT                                         ARR51
     C                   Z-ADD     0             PAGE1                                         ARR51
     C                   ENDSR                                                                 ARR51
      *********                                                           ARR510
      * #STDY *                                                           ARR510
      *********                                                           ARR510
     C     #STDY         BEGSR
      *
      *  USE THIS SUBROUTINE TO LOAD AGING DAYS PRINT HEADINGS
      *  USE THIS SUBROUTINE FOR AGING STATEMENTS ONLY
      *
     C                   Z-ADD     ACAGPY        #WKP1             3 0
     C                   Z-ADD     ACAGP2        #WKP2             3 0
     C                   Z-ADD     1             #WKP0             3 0
     C     #WKP1         ADD       1             #WKP1A            3 0
     C                   Z-ADD     ACAGPY        #FD(1)
     C                   Z-ADD     ACAGP2        #FD(2)
      *
     C                   ENDSR
      *********                                                           ARR510
      * #STDL *                                                           ARR510
      *********                                                           ARR510
     C     #STDL         BEGSR
      *
      *  USE THIS SUBROUTINE TO AGE ITEMS FOR STATEMENT PRINT ONLY
      *  SUBROUTINE ASSUMES ARRAY #FD HAS BEEN LOADED - USE #STDY
      *  SUBROUTINE ASSUMES FIELD #WKAOJ HAS BEEN LOADED
      *  LOAD DUE DATE INTO FIELD ##MDY
      *  LOAD TRANS TYPE INTO FIELD #WKTT
      *  LOAD DOLLAR AMOUNT INTO FIELD #WKAR$
      *  #WKAR$ MUST BE DEFINED IN PGM
      *  USE FIELD #WKCR$ TO PRINT TOTAL CURRENT DOLLAR AMOUNTS
      *  USE ARRAY #PD$ TO PRINT TOTAL PAST DUE AMOUNTS 1 - 3
      *
     C                   MOVE      'P'           #WKCP             1
     C                   MOVE      #WKTT         #WKTT             2 0
     C                   CALL      '@DT@B1'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##DDD             5 0          DAY OF CENT
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##DDD         #WKTRJ            5 0
      *
      *  SUBTRACT AS OF DATE (RDATE) FROM DUE DATE (#WKTRJ)
      *
     C     #WKTRJ        SUB       RDATE         #WKTRJ
      *
      *  ACCUMULATE FOR TOTAL BALANCE
      *
     C                   ADD       #WKAR$        #WKAT$           11 2
      *
      *  INITIALIZE CONTINUATION FLAG FOR AGING ON ACCOUNT AND LATE
      *  CHARGE TRANSACTION TYPES PLUS ANY TRANSACTIONS SUBORDINATE TO
      *  THESE TRANSACTIONS
      *
     C     #WKTT         IFEQ      01
     C                   MOVE      ' '           #WKCON            1
     C                   END
     C     #WKTT         IFEQ      03
     C                   MOVE      'Y'           #WKCON                         ON ACCT
     C                   END
     C     #WKTT         IFEQ      05
     C                   MOVE      ' '           #WKCON
     C                   END
      ** 1/10/02 AGE LATE CHARGES
     C     #WKTT         IFEQ      07                                           LATE CHRGS
     C                   MOVE      ' '           #WKCON
     C                   END
      *
      *  IF CONTINUATION FLAG IS 'Y' FORCE AGING INTO CURRENT AMOUNT
      *
     C     #WKCON        IFEQ      'Y'
     C                   Z-ADD     0             #WKTRJ
     C                   END
      *
      *  TEST DATE RELATIVE TO AGING DAYS - POSITIVE = FUTURE DUE
      *                                     NEGATIVE = PAST DUE
      *
     C     #WKTRJ        IFGE      0
     C                   MOVE      'C'           #WKCP
     C*                    END
      *
      *  ACCUMULATE FOR ALL TRANSACTIONS EXCEPT CREDIT MEMOS
      *
     C     #WKTT         IFNE      05
      *  ACCUMULATE CURRENT AMOUNTS
     C                   ADD       #WKAR$        #WKCR$           11 2
     C                   ELSE
     C                   ADD       #WKAR$        #WKTCR           11 2
     C                   END
     C                   ELSE
      *
      *  AGE PAST DUE AMOUNTS
      *
     C     #WKTT         IFNE      05
     C                   MLLZO     1             #WKTRJ
     C                   Z-ADD     1             X                 1 0
     C     #WKTRJ        LOOKUP    #FD(X)                             90  90
     C   90              ADD       #WKAR$        #PD$(X)
     C  N90              ADD       #WKAR$        #PD$(3)
     C                   ELSE
     C                   ADD       #WKAR$        #WKTCR
     C                   ADD       #WKAR$        #WKPCR           11 2
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      ***********
      * #SLD    *
      ***********
      *  THIS SUBROUTINE REMOVES BLANK ADDRESS LINES FROM THE SOLD TO
      *  ADDRESS.  WORK FIELDS ARE DEFINED AS:
      *
      *                 WORK  = CITY,STATE,ZIP(9 DIGIT)
      *                 WORK1 = CITY, STATE
      *                 WORK2 = ZIP CODE(XXXXX-XXXX)
      *                 WORK3 = STANDARD ZIP CODE(XXXXX)
      *                 WORK4 = ADDITIONAL ZIP CODE(-XXXX)
      *
      *  THE SUBROUTINE REQUIRES MOVING NAME AND ADDRESS INFORMATION TO
      *  BE CONDENSED TO A DATA STRUCTURE
      *
     C     #SLD          BEGSR
      *
     C                   MOVE      *BLANKS       #SL
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WSLD1        #SL(#X)
     C                   ADD       1             #X
     C     #WSLD2        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD1
     C                   MOVEL     #WSLD2        #SL(#X)
     C                   ADD       1             #X
     C     #SLD1         TAG
     C     #WSLD3        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD2
     C                   MOVEL     #WSLD3        #SL(#X)
     C                   ADD       1             #X
     C     #SLD2         TAG
     C     #WSLD4        COMP      *BLANKS                            929291
     C   91              GOTO      #SLD3
     C                   MOVEL     #WSLD4        #SL(#X)
     C                   ADD       1             #X
     C     #SLD3         TAG
     C                   MOVE      *BLANKS       WORK             32
     C                   MOVE      *BLANKS       WORK1            21
     C                   MOVE      *BLANKS       WORK2            10
     C                   MOVE      *BLANKS       WORK3             5
     C                   MOVE      *BLANKS       WORK4             5
     C     #WSLCT        CAT       #WSLST:1      WORK1
     C                   MOVEL     #WSLZP        WORK3
     C                   MOVE      #WSLZP        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #SL(#X)
     C                   SETOFF                                       919293
     C                   ADD       1             #X
     C                   MOVEL     CMCOUN        #SL(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
      *                                                                   ARR510
     OARR510A   E            HDG              04                                ARR510
CAB  O****                               60 'STATEMENT OF ACCOUNT'        ARR510
     O          E            HDG              13                                ARR510
     O                                           80 'D-U-N-S 01-105-3410'       ARR510
     O                       CMCUST        Z      8                             ARR510
     O          E            HDG              14                                ARR510
     O                       #SL(1)              40                             ARR510
     O          E            HDG              15                                ARR510
     O                       #SL(2)              40                             ARR510
     O                                           71 'Date:'                     ARR510
     O                       LDATE         Y     80                             ARR510
     O          E            HDG              16                                ARR510
     O                       #SL(3)              40                             ARR510
     O          E            HDG              17                                ARR510
     O                       #SL(4)              40                             ARR510
     O                       PAGE1         Z     80                             ARR510
     O                                           77 'Page'                      ARR510
     O          E            HDG              18                                ARR510
     O                       #SL(5)              40                             ARR510
     O          E            HDG              19                                ARR510
     O                       #SL(6)              40                             ARR510
     O          E            HDG            1 22                                ARR510
     O                                            9 'Invoice'                   ARR510
     O                                           15 'Due'                       ARR510
     O                                           26 'Invoice'                   ARR510
     O                                           63 'Invoice'                   ARR510
     O                                           75 'Adjust/'                   ARR510
     O                                           87 'Balance'                   ARR510
     O          E            HDG            0                                   ARR510
     O                                            8 'Number'                    ARR510
     O                                           16 'Date'                      ARR510
     O                                           25 'Date'                      ARR510
     O                                           36 'Reference'                 ARR510
     O                                           62 'Total'                     ARR510
     O                                           75 'Payments'                  ARR510
     O                                           85 'Due'                       ARR510
     O          E            HDG            1                                   ARR510
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           87 '_______________'
     O          E            DETL           1                                   ARR510
     O                       ARDUE         JB    87                             ARR510
     O                       PAYAMT        JB    75                             ARR510
     O                       INVAMT        JB    63                             ARR510
     O                       OARINV        ZB     8                             ARR510
     O*                        ARINV#Z    8                               ARR510
     O                       ODDAT         YB    17                             ARR510
     O                       OTDAT         YB    26                             ARR510
     O                       ODESC          B    48                             ARR510
     O          E            TL2              60                                ARR510
     O                                           20 '********************'
     O                                           37 '*****  AGING  *****'
     O                                           52 '***************'
     O          E            TL2            0 61                                ARR510
     O                                           15 'CURRENT'                   ARR510
     O                       #WKP0         3     21                             ARR510
     O                                           22 '-'                         ARR510
     O                       #WKP1         Z     25                             ARR510
     O                       #WKP1A        3     35                             ARR510
     O                                           36 '-'                         ARR510
     O                       #WKP2         Z     39                             ARR510
     O                                           48 'OVER'                      ARR510
     O                       #WKP2         Z     52                             ARR510
     O                                           86 'TOTAL DUE'                 ARR510
     O          E            TL2            1                                   ARR510
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           87 '_______________'
     O          E            TL2              62                                ARR510
     O                       TOTCUS        JB    87                             ARR510
     O*                        #WKAT$J   85                               ARR510
     O*                        #WKAT$JB  67                               ARR510
     O                       #PD$(3)       KB    53                             ARR510
     O                       #PD$(2)       KB    40                             ARR510
     O                       #PD$(1)       KB    26                             ARR510
     O                       #WKCR$        KB    15                             ARR510
      *
**
Invoice
Payment
Credit Memo
Late Charge
Discount
Deposit
Returned Check
Returned Check Charge
Credit Card Payment
On Account Payment
Appl From C/M #xxxxxx
