      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.  .  ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- APR331
      **SYSTEM-------------- ACCOUNTS PAYABLE
      **APPLICATION--------- PRINT CHECKS
      **DESCRIPTION-         PRINT A/P CHECKS
      **                     (ONLY PRINTS CHECKS)
      **
      *            CHANGE--DATE-------DESCRIPTION
      * WJB  05/17/04  Added logic to print account number on checks as well as
      *                the Vendor Message.  If the account number is *Blank,
      *                then the Account Number Line is suppressed.
      *
     FFTOPAYCK  UF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFAPCTL    UF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFAPCHK    O    E           K DISK
     FAPR330    O    F  132        PRINTER OFLIND(*INOC)
      *
      * REPORT PRINTS FOR VENDORS CODED "Y" FOR SUMMARY CHECK STUB     EFD
      *
     FAPR33A    O    F  132        PRINTER OFLIND(*INOF)
      *
      * ADDRESS ARRAYS
     D #CO             S             32    DIM(5)
     D #VE             S             32    DIM(6)
      * MESSAGE ARRAY
     D MSG             S             30    DIM(1) CTDATA PERRCD(1)              MESSAGE
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
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LCO                    1      2  0
     D  LPROG                 29     36
     D  LNAME                 37     60
     D  LDATE                 61     66  0
     D  LCHECK                67     72  0
     D  LVOID                 73     74  0
     D  LRERUN                76     76
     D  LPRTR1                81     90
     D  LPRTR2               100    109
     D  LCOPY                114    115  0
     D  LJOB                 116    116
     D  LHOLD                117    120
     D  LSAVE                121    124
     D  LCANCL               133    133
     D  JAMRCV               150    150
      ** FIRST CHECK IN CURRENT RUN
     D  FSTCHK               151    156  0
      ** LAST CHECK IN CURRENT RUN
     D  LSTCHK               157    162  0
     D  LFORM1               163    172
     D  LFORM2               173    182
      ** LAST GOOD CHECK PRINTED
     D  LSTGDC               183    188  0
      *
     IRMCORG
     I              RGNAME                      #WCO1
     I              RGADR1                      #WCO2
     I              RGADR2                      #WCO3
     I              RGADR3                      #WCO4
     I              RGCITY                      #WCOCT
     I              RGSTST                      #WCOST
     I              RGZIP                       #WCOZP
      *
     IRMVEND
     I              VMNAME                      #WVE1
     I              VMADD2                      #WVE2
     I              VMADD3                      #WVE3
     I              VMADD4                      #WVE4
     I              VMCITY                      #WVECT
     I              VMSTST                      #WVEST
     I              VMZIPD                      #WVEZP
      *
      *
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     1             CNT               6 0
      *
     C     LCO           CHAIN     FMCORG                             98
     C                   EXSR      CONAME
      ** GET NUMBER OF LINES ON STUB
     C     LCO           CHAIN(N)  FAPCTL                             90
     C                   Z-ADD     0             SLINES            3 0
      ** SETON OF TO GET HEADING IF NEEDED
     C                   SETON                                        OF  OC
      *
      ** JAM RECOVER
     C*          JAMRCV    IFEQ 'Y'
     C     CHKEY         KLIST
     C                   KFLD                    LCO
     C                   KFLD                    LCHECK
     C     CHKEY         SETLL     FTOPAYCK
     C**                   END
      *
     C     NXT           TAG
     C                   SETOFF                                       31
     C     LCO           READE     FTOPAYCK                               90
     C   90              GOTO      END
     C*          JAMRCV    IFEQ 'Y'
     C*          TPCHEK    ANDGTENDCHK
     C*                    GOTO END
     C**                   END
      *
     C     CNT           IFEQ      1
     C                   Z-ADD     TPVEND        OLVEND            6 0
     C                   EXSR      VENDOR
     C                   MOVEL     VMSUMM        OLSUMM            1
     C                   EXSR      VENADR
     C                   Z-ADD     TPCHEK        CHKNUM            6 0
     C                   ENDIF
      *
     C     CNT           IFGT      1
     C     TPCHEK        ANDNE     CHKNUM
     C                   EXSR      CHECK
      *
      * DIVIDE INTO DOLLARS AND CENTS
      *
     C                   Z-ADD     VNPAID        CENTS             2 2
     C                   Z-ADD     VNPAID        DOLLAR            7 0
      *
WJB  C     VMOFIL        IFNE      *BLANKS
WJB  C                   MOVE      *ON           *IN40
WJB  C                   ELSE
WJB  C                   MOVE      *OFF          *IN40
WJB  C                   ENDIF
     C  N31              EXCEPT    TL1
     C     OLSUMM        IFEQ      'Y'
     C                   EXCEPT    RTL1
     C                   ENDIF                                                  OLSUMM=Y
     C                   EXSR      CLARY
     C                   EXSR      CLTOT
     C                   Z-ADD     TPVEND        OLVEND            6 0
     C                   EXSR      VENDOR
     C                   MOVEL     VMSUMM        OLSUMM            1
     C                   EXSR      VENADR
     C                   ENDIF                                                  TPCHK<>CHKNM
      *
     C                   Z-ADD     TPVEND        OLVEND            6 0
     C                   MOVEL     VMSUMM        OLSUMM            1
     C                   ADD       1             CNT
      *
      *
     C                   EXSR      VENTOT
      *
     C                   Z-ADD     TPCHEK        CHKNUM            6 0
      ** MOVE INTO PRINT FIELDS
     C                   MOVE      TPINV#        INVS             10
     C                   Eval      INVS = %Trim(TPINV#)
     C                   Z-ADD     TPIVDT        DTES              6 0
     C                   MOVEL     TPTDES        DSC              25
     C                   Z-ADD     0             AMTWK             9 2
     C     TPDISC        ADD       TP$TOP        AMTWK
     C                   Z-ADD     AMTWK         AMTS              9 2
     C                   Z-ADD     TPDISC        DTKS              7 2
     C                   Z-ADD     TP$TOP        PAYS              9 2
      *  PRINT DETAIL LINES
     C     VMSUMM        IFEQ      'Y'
     C   OF              DO
     C                   EXSR      VENADR
     C                   EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   END
     C                   EXCEPT    DETAIL
     C                   ELSE
     C     SLINES        IFGE      AZSTBL
     C                   EXCEPT    OVERCK
     C                   SETON                                        OC
     C                   Z-ADD     0             SLINES
     C                   END
     C   OC              DO
     C                   EXCEPT    STUB1
     C                   SETOFF                                       OC
     C                   END
     C                   EXCEPT    STUB
     C                   ADD       1             SLINES
     C                   END
     C                   MOVEL     'Y'           CHKP
      *
     C                   GOTO      NXT
      *
     C     END           TAG
     C     CHKP          IFEQ      'Y'
     C                   EXSR      VENADR
     C                   EXSR      CHECK
      *
      * DIVIDE INTO DOLLARS AND CENTS
      *
     C                   Z-ADD     VNPAID        CENTS             2 2
     C                   Z-ADD     VNPAID        DOLLAR            7 0
      *
WJB  C     VMOFIL        IFNE      *BLANKS
WJB  C                   MOVE      *ON           *IN40
WJB  C                   ELSE
WJB  C                   MOVE      *OFF          *IN40
WJB  C                   ENDIF
     C  N31              EXCEPT    TL1
     C     OLSUMM        IFEQ      'Y'
     C                   EXCEPT    RTL1
     C                   ENDIF                                                  OLSUMM=Y
     C                   END                                                    CHKP=Y
     C     LCO           CHAIN     FAPCTL                             90
     C                   Z-ADD     LDATE         AZDTCK
     C                   Z-ADD     TDATE         AZDTLA
     C                   Z-ADD     TIMOD         AZTIME
     C                   MOVEL     USERID        AZUSER
     C                   MOVEL     'Y'           AZCKR
     C                   Z-ADD     CHKNUM        AZLSCK
     C                   UPDATE    RAPCTL
     C                   SETON                                        LR
      *
      *********
      * CHECK *  PRINTS CHECK WITH INV DETAILS AND TOTAL PAID
      *********
      *
     C     CHECK         BEGSR
      *
      * IF ZERO DOLLARS - PRINT VOID CHECK
      *
     C     VNPAID        COMP      0                                      31    ZERO DOLLARS?
     C   31              EXSR      ZERO$
     C   31              GOTO      ECHECK
      *
      * WRITE CHECK FOR SUMMARY CHECK STUB
      *
     C     VMSUMM        IFEQ      'Y'
     C                   EXCEPT    SUMM
     C                   END
      *
      * WRITE CHECK FOR TOTAL NET PAID TO VENDOR
      *
     C*          VMSUMM    IFNE 'Y'
     C*                    EXCPTSTUB
     C*                    ENDIF
      *
     C     ECHECK        TAG
      * OUTPUT FAPCHK RECORD
     C                   MOVEL     'A'           ACSTAT
     C                   Z-ADD     LCO           ACCOMP
     C                   Z-ADD     CHKNUM        ACCHEK
     C                   Z-ADD     LDATE         ACCKDT
     C                   Z-ADD     LDATE         ACPEDT
     C                   Z-ADD     OLVEND        ACVEND
     C                   Z-ADD     VN$DUE        AC$AMT
     C                   Z-ADD     VNDISC        ACDTAK
     C                   Z-ADD     VNPAID        AC$NET
     C                   Z-ADD     TDATE         ACTDAT
     C                   Z-ADD     TDATE         ACDTLA
     C                   Z-ADD     TIMOD         ACTIME
     C                   MOVEL     USERID        ACUSER
     C                   MOVEL     VMMVPC        ACMVPC
     C                   MOVEL     MSG(1)        ACTDES
     C                   WRITE     RAPCHK
      *
     C                   ENDSR
      *
      *********
      * CLARY * SET UP FOR NEW CHECK
      *********
      *
     C     CLARY         BEGSR
      *
     C                   SETOFF                                       31
     C                   Z-ADD     1             K                 2 0
      *
     C     ECLARY        ENDSR
      *
      *********
      * CLTOT * CLEARS VENDOR AND VOUCHER TOTALS
      *********
      *
     C     CLTOT         BEGSR
      *
     C                   Z-ADD     0             VN$DUE            9 2
     C                   Z-ADD     0             VNDISC            7 2
     C                   Z-ADD     0             VNPAID            9 2
     C                   Z-ADD     0             SLINES
     C                   MOVE      *BLANKS       CHKP              1
     C                   SETON                                        OF  OC
      *
     C     ECLTOT        ENDSR
      *
      **********
      * CONAME * MOVE COMPANY NAME AND ADDRESS TO CONDENSED DATA
      **********
      *
     C     CONAME        BEGSR
     C                   MOVE      *BLANKS       #CO
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WCO1         #CO(#X)
     C                   ADD       1             #X
     C     #WCO2         COMP      *BLANKS                            929291
     C   91              GOTO      #CO1
     C                   MOVEL     #WCO2         #CO(#X)
     C                   ADD       1             #X
     C     #CO1          TAG
     C     #WCO3         COMP      *BLANKS                            929291
     C   91              GOTO      #CO2
     C                   MOVEL     #WCO3         #CO(#X)
     C                   ADD       1             #X
     C     #CO2          TAG
     C     #WCO4         COMP      *BLANKS                            929291
     C   91              GOTO      #CO3
     C                   MOVEL     #WCO4         #CO(#X)
     C                   ADD       1             #X
     C     #CO3          TAG
     C                   MOVE      *BLANKS       WORK             32
     C                   MOVE      *BLANKS       WORK1            21
     C                   MOVE      *BLANKS       WORK2            10
     C                   MOVE      *BLANKS       WORK3             5
     C                   MOVE      *BLANKS       WORK4             5
     C     #WCOCT        CAT       #WCOST:1      WORK1
     C                   MOVEL     #WCOZP        WORK3
     C                   MOVE      #WCOZP        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #CO(#X)
     C                   SETOFF                                       919293
     C                   ENDSR
      *
      **********
      * VENADR * CONDENSE VENDOR NAME AND ADDRESS
      **********
     C     VENADR        BEGSR
      *
     C     OLVEND        CHAIN     FMVEND                             11
     C   11              GOTO      EVENAD
      *
     C                   MOVE      *BLANKS       #VE
     C                   Z-ADD     1             #X                1 0
     C                   MOVEL     #WVE1         #VE(#X)
     C                   ADD       1             #X
     C     #WVE2         COMP      *BLANKS                            929291
     C   91              GOTO      #VE1
     C                   MOVEL     #WVE2         #VE(#X)
     C                   ADD       1             #X
     C     #VE1          TAG
     C     #WVE3         COMP      *BLANKS                            929291
     C   91              GOTO      #VE2
     C                   MOVEL     #WVE3         #VE(#X)
     C                   ADD       1             #X
     C     #VE2          TAG
     C     #WVE4         COMP      *BLANKS                            929291
     C   91              GOTO      #VE3
     C                   MOVEL     #WVE4         #VE(#X)
     C                   ADD       1             #X
     C     #VE3          TAG
     C                   MOVE      *BLANKS       WORK             32
     C                   MOVE      *BLANKS       WORK1            21
     C                   MOVE      *BLANKS       WORK2            10
     C                   MOVE      *BLANKS       WORK3             5
     C                   MOVE      *BLANKS       WORK4             5
     C     #WVECT        CAT       #WVEST:1      WORK1
     C                   MOVEL     #WVEZP        WORK3
     C                   MOVE      #WVEZP        WORK4
     C                   MOVEL     ' '           WORK4
     C     WORK4         COMP      '     '                                93
     C  N93              MOVEL     '0'           WORK4
     C  N93WORK4         COMP      '00000'                                93
     C   93              MOVE      *BLANKS       WORK4
     C  N93              MOVEL     '-'           WORK4
     C                   MOVEL     WORK3         WORK2
     C                   MOVE      WORK4         WORK2
     C     WORK1         CAT       WORK2:1       WORK
     C                   MOVE      WORK          #VE(#X)
     C                   ADD       1             #X
     C                   MOVEL     VMCOUN        #VE(#X)
     C                   SETOFF                                       919293
      *
     C     EVENAD        ENDSR
      **********
      * VENDOR * CK FOR MULTI VOUCHERS AND SUMMARY CK STUB
      **********
      *
     C     VENDOR        BEGSR
      *
     C     TPVEND        CHAIN     FMVEND                             11
     C   11              GOTO      EVENDR
      *
     C     EVENDR        ENDSR
      *
      **********
      * VENTOT * ACCUMULATES TOTAL FOR ONE VENDOR
      **********
      *
     C     VENTOT        BEGSR
      *
      * ACCUMULATE VENDOR TOTALS FOR DUE$, DISC, AND PAID $
      *
     C                   ADD       TP$TOP        VN$DUE
     C                   ADD       TPDISC        VN$DUE
     C                   ADD       TPDISC        VNDISC
     C                   ADD       TP$TOP        VNPAID
      *
      * DIVIDE INTO DOLLARS AND CENTS
      *
     C                   Z-ADD     VNPAID        CENTS
     C                   Z-ADD     VNPAID        DOLLAR
      *
     C     EVENTT        ENDSR
      *
      *********
      * CHKLN * STORES DETAIL FROM ONE INVOICE FOR REPORT
      *********
      *
     C     CHKLN         BEGSR
      *
     C   OF              DO
     C                   EXCEPT    HDG
     C                   SETOFF                                       OF
     C                   END
      *
     C                   EXCEPT    DETAIL
      *
     C     ECHKLN        ENDSR
      **********
      * UTOPAY *  SUBROUTINE UPDATES RECORDS IN APOPN
      **********
     C     UTOPAY        BEGSR
      *
      *
      * UPDATE TOPAY RECORD
      *
     C                   Z-ADD     CHKNUM        TPCHEK
     C                   Z-ADD     LDATE         TPCKDT
     C                   MOVEL     'Y'           TPCLCD
     C                   MOVEL     'D'           TPSTAT
     C                   UPDATE    RTOPAY
      *
     C     EUPDTE        ENDSR
      *********
      * ZERO$ *
      *********
      * PRINTS A VOID CHECK IN  AMOUNT OF ZERO $
      * ADDS VOID CHECK RECOR TO APCHK
      *
     C     ZERO$         BEGSR
      *
     C                   EXCEPT    VOIDCK
      *
     C     EZERO$        ENDSR
      *
     O*APR330    H    1P                  0  0
     O*                                            1 '*'
     OAPR330    E            VOIDCK         3
     O                       CHKNUM        Z     39
     O                       LDATE         Y     49
     O                       VN$DUE        1     62
     O                       VNDISC        1     72
     O                       VNPAID        1     81
     O          E            VOIDCK      3  3
     O                       LDATE         Y     70
     O          E            VOIDCK      3  3
     O                                           80 '*** VOID ***'
     O          E            VOIDCK         1
     O                                           42 '**** VOID CHECK ****'
      *
      * CHECK FOR VENDOR NET TOTAL DUE
      *
     O          E            STUB1          1 07
     O          EF           STUB           1
     O                       INVS                10
     O                       DTES                18 '  /  / 0'
     O                       DSC                 50
     O                       AMTS          K     62                             63
     O                       DTKS          2     72                             73
     O                       PAYS          K     81                             83
     O          E            OVERCK      3  3
     O                       LDATE         Y     70
     O          E            OVERCK      3  3
     O                                           80 '*** VOID ***'
     O          E            OVERCK         1
     O                                           42 '**** VOID CHECK ****'
      *
WJB  O          E    40      TL1            1
WJB  O                                           29 'Acct #:'
WJB  O                       VMOFIL              40
WJB  O          E            TL1            1
WJB  O                       VMMSG               82
     O          E            TL1            3 20
     O                       CHKNUM        Z     29
     O                       LDATE         Y     49
     O                       VN$DUE        J     62
     O                       VNDISC        2     72
     O                       VNPAID        J     81
     O          E            TL1         2  3
     O                       LDATE         Y     65
     O          E            TL1         4  2
     O                                           18 'PAY EXACTLY'
     O                       DOLLAR              29 ' ,   ,  *'
     O                                           41 'DOLLARS AND'
     O                       CENTS               44
     O                                           50 'CENTS'
     O                       VNPAID              76 ' ,   ,  *.  '
     O          E            TL1            1
     O                       #VE(1)              42
     O          E            TL1            1
     O                       #VE(2)              42
     O          E            TL1            1
     O                       #VE(3)              42
     O          E            TL1            1
     O                       #VE(4)              42
     O          E            TL1            1
     O                       #VE(5)              42
     O          E            TL1            2
     O                       #VE(6)              42
     O**** PRINT SUMMARY CHECK STUB
     O*
     O          E            SUMM           2 12
     O                                           44 '*** SEE ATTACHED FOR DET'
     O                                           51 'AIL ***'
     OAPR33A    E            HDG            2 03
     O                       PROGID              10
     O                                           55 'Check Remittance Detail'
     O                       LDATE         Y     80
     O          E            HDG            2
     O                                           20 'Check Remitted To:'
     O                                           66 'Check Submitted From:'
     O          E            HDG            1
     O                       #VE(1)              34
     O                       #CO(1)              77
     O          E            HDG            1
     O                       #VE(2)              34
     O                       #CO(2)              77
     O          E            HDG            1
     O                       #VE(3)              34
     O                       #CO(3)              77
     O          E            HDG            1
     O                       #VE(4)              34
     O                       #CO(4)              77
     O          E            HDG            2
     O                       #VE(5)              34
     O                       #CO(5)              77
     O          E            HDG            2
     O                                           24 'Detail For Check Number:'
     O                       CHKNUM        Z     31
     O          E            HDG            1
     O                                           24 '========================'
     O                                           48 '========================'
     O                                           72 '========================'
     O                                           84 '============'
     O          E            HDG            1
     O                                            8 'Invoice'
     O                                           19 'Invoice'
     O                                           33 'Description'
     O                                           59 'Invoice'
     O                                           71 'Discount'
     O                                           81 'Net'
     O          E            HDG            1
     O                                            5 '#'
     O                                           17 'Date'
     O                                           59 'Amount'
     O                                           71 ' Amount '
     O                                           82 'Amount'
     O          E            HDG            2
     O                                           24 '========================'
     O                                           48 '========================'
     O                                           72 '========================'
     O                                           84 '============'
     O          EF           DETAIL         1
     O                       INVS                10
     O                       DTES                19 '  /  / 0'
     O                       DSC                 46
     O                       AMTS          K     60
     O                       DTKS          2     69
     O                       PAYS          K     82
     O          EF           RTL1           1
     O                                           44 'Check Totals:'
     O                       VN$DUE        J     60
     O                       VNDISC        J     70
     O                       VNPAID        J     82
** MESSAGE
A/P Cash Disbursements
