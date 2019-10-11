      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES INC.  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.       215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- ARR205
      *SYSTEM-------------- ACCOUNTS RECEIVABLE
      *APPLICATION--------- SUMMARY ENTRY EDIT REGISTER
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFARENT    IF   E           K DISK
     FFMCUST    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFGLDF     IF   E           K DISK
     FFARCTL    UF   E           K DISK
     FARR205    O    F  120        PRINTER OFLIND(*INOF)
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
     D                UDS
     D  LCO                    1      2  0
     D  LFORM                  3      6
     D  LCOPY                  8      9  0
     D  LPRTR                 10     19
     D  LJOB                  20     20
     D  LPROG                 29     36
     D  LNAME                 37     60
     D  LUSER                 61     70
     D  LSEQ                  71     71  0
     D  LCANCL               133    133
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     1             CNT               6 0
     C                   Z-ADD     1             VCNT              6 0
      *
     C     LCO           CHAIN(N)  FARCTL                             88
     C     ACGL          IFEQ      'Y'
     C                   SETON                                        77
     C                   ENDIF
      *
     C     LCO           CHAIN     FMCORG                             88
     C                   EXCEPT    HDG
      *
     C                   MOVEL     '01'          GDTYPE            2
     C     GLDKEY        KLIST
     C                   KFLD                    LCO
     C                   KFLD                    GDTYPE
     C     GLKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    AEGSAL
      *
     C     NXT           TAG
     C                   SETOFF                                       315178
     C                   READ      FARENT                                 90
     C   90              GOTO      END
      *
     C     AESTAT        IFEQ      'D'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C   77              DO
     C                   SETOFF                                       78
     C     GLDKEY        CHAIN     FGLDF                              90
     C     AEGSAL        IFNE      GDSALE
     C     AEMER$        ANDNE     0
     C                   SETON                                        78
     C     GLKEY         CHAIN     FMGLCH                             91
     C  N91              MOVEL     GCDESC        DESC             30
     C                   ENDIF
     C                   ENDDO
      *
     C                   Z-ADD     AETDAT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0
     C                   PARM                    ##MDY             6 0
     C                   PARM                    ##ERR             1
     C                   MOVEL     ##MDY         RDATE             6 0
      *
      * 1=INVOICE  5=CREDIT MEMO  7=LATE CHARGE
      *
     C     AETTYP        IFEQ      01
     C     AETTYP        OREQ      07
     C                   SETON                                        51
     C                   ENDIF
      *
      * COMPANY TOTALS SEPARATED BY INVOICE OR CREDIT MEMO
      *
     C     AEDIS$        ADD       AEQDI$        AMTDIS            7 2
     C                   Z-SUB     AMTDIS        DISAMT            7 2
     C   51              ADD       AEDIS$        TOTDIS            9 2
     C  N51              ADD       AEDIS$        TDISCM            9 2
     C   51              ADD       AEQDI$        TOTQDI            9 2
     C  N51              ADD       AEQDI$        TQDICM            9 2
      *
      * COMBINE 4 TAXES AND ADD TO COMPANY TOTALS
      *
     C                   Z-ADD     0             WORK1
     C                   Z-ADD     0             WORK2
      *
     C     AEAMT1        ADD       AEAMT2        WORK1             7 2
     C                   ADD       AEAMT3        WORK2             7 2
     C     WORK1         ADD       WORK2         TAXAMT            7 2
     C     TAXAMT        ADD       DAYTAX        DAYTAX            9 2
      *
     C   51              ADD       AEAMT1        TOTTX1            9 2
     C  N51              ADD       AEAMT1        TTX1CM            9 2
     C   51              ADD       AEAMT2        TOTTX2            9 2
     C  N51              ADD       AEAMT2        TTX2CM            9 2
     C   51              ADD       AEAMT3        TOTTX3            9 2
     C  N51              ADD       AEAMT3        TTX3CM            9 2
      *
      * ADD ALL AMTS TO TOTALS FOR INVOICE OR CREDIT MEMO
      *
     C   51              ADD       AEMER$        TOTMER           11 2
     C  N51              ADD       AEMER$        TMERCM           11 2
     C   51              ADD       AEFRT$        TOTFRT            9 2
     C  N51              ADD       AEFRT$        TFRTCM            9 2
     C   51              ADD       AESPL$        TOTSPL            9 2
     C  N51              ADD       AESPL$        TSPLCM            9 2
     C   51              ADD       AE$AMT        TOTINV           11 2
     C  N51              ADD       AE$AMT        TINVCM           11 2
     C     AETTYP        IFEQ      07
     C                   ADD       AE$AMT        TOTLCH           11 2
     C                   ENDIF
      *
      * CHAIN TO CUSTOMER MASTER FOR NAME
      *
     C     AECUST        CHAIN     FMCUST                             12
     C                   MOVEL     CMNAME        CNAME            27
     C                   EXCEPT    DETL
     C   78              EXCEPT    DETGL
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   Z-SUB     TOTQDI        QDITOT            9 2
     C                   Z-SUB     TOTDIS        DISTOT            9 2
     C                   EXCEPT    TLR
     C     LCO           CHAIN     FARCTL                             88
     C                   MOVEL     'Y'           ACOKSI
     C                   UPDATE    RARCTL
     C                   SETON                                        LR
      *
     OARR205    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           90 'Company:'
     O                       LCO                 93
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           63 'Summary Invoice Entry'
     O                                           77 'Edit Register'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            1
     O                                           16 ' Inv        A/R'
     O                                           28 'Customer'
     O                                           54 'Invoice'
     O                                           64 'Merch.'
     O                                           75 'Disc.'
     O                                           86 'Freight'
     O                                           97 'Special'
     O                                          119 'Invoice'
     O          E            HDG            1
     O                                            6 'Number'
     O                                           16 'Cust'
     O               77                          28 'G/L Acct'
     O                                           52 'Date'
     O                                           64 'Amount'
     O                                           75 'Amount'
     O                                           86 'Charge'
     O                                           97 'Charge'
     O                                          108 'Taxes'
     O                                          118 'Total'
     O          E            HDG            2
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            DETL           1
     O                       AE$AMT        MB   120
     O                       TAXAMT        MB   109
     O                       AESPL$        MB    98
     O                       AEFRT$        MB    87
     O                       DISAMT        MB    76
     O                       AEMER$        MB    65
     O                       RDATE         Y     54
     O                       CNAME          B    44
     O                       AECUST        ZB    16
     O                       AESUFF         B     9
     O                       AEINV#        ZB     6
     O          E            DETGL          1
     O                                           44 'G/L Sales Account:'
     O                       AEGSAL              54 '    -    '
     O                       DESC                85
     O          E            TLR            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           90 'Company:'
     O                       LCO                 93
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            TLR            2
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           63 'Summary Invoice Entry'
     O                                           77 'Edit Register'
     O                       TIMOD              120 '  :  :  '
     O          E            TLR            3
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            TLR            1
     O                                           59 'C O M P A N Y'
     O                                           73 'T O T A L S'
     O          E            TLR            2
     O                       RGNAMC              75
     O          E            TLR            1
     O                                           42 'Invoices'
     O                                           97 'Credit Memos'
     O          E            TLR            2
     O                                           41 '________________________'
     O                                           65 '________________________'
     O                                           89 '________________________'
     O                                          101 '______________'
     O          E            TLR            2
     O                       TOTMER        KB    38
     O                                           66 'Merchandise'
     O                       TMERCM        KB    90
     O          E            TLR            2
     O                       QDITOT        KB    38
     O                                           66 'Quantity Discount'
     O                       TQDICM        KB    90
     O          E            TLR            2
     O                       DISTOT        KB    38
     O                                           66 'Trade Discount'
     O                       TDISCM        KB    90
     O          E            TLR            2
     O                       TOTFRT        KB    38
     O                                           66 'Freight'
     O                       TFRTCM        KB    90
     O          E            TLR            2
     O                       TOTSPL        KB    38
     O                                           66 'Special Charges'
     O                       TSPLCM        KB    90
     O          E            TLR            2
     O                       TOTLCH        KB    38
     O                                           66 'Late Charges'
     O          E            TLR            2
     O                                           66 'T A X E S'
     O          E            TLR            2
     O                       TOTTX1        KB    38
     O                                           66 'State'
     O                       TTX1CM        KB    90
     O          E            TLR            2
     O                       TOTTX2        KB    38
     O                                           66 'County'
     O                       TTX2CM        KB    90
     O          E            TLR            2
     O                       TOTTX3        KB    38
     O                                           66 'City'
     O                       TTX3CM        KB    90
     O          E            TLR            2
     O                                           38 '------------'
     O                                           90 '------------'
     O          E            TLR            2
     O                       TOTINV        KB    38
     O                                           66 '*** Totals ***'
     O                       TINVCM        KB    90
