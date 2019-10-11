      *--------------------------------------------------------------
      *
      *   COPYRIGHT EFD ENTERPRISES INC.     1999
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       E F D ENTERPRISES INC. ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *             EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      *PROGRAM NAME-------- APR300
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *DESCRIPTION--------- VOUCHER EDIT LIST
      *
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
     FFAPWK     IF   E           K DISK
     FFAPWKS    IF   E           K DISK
     FFMVEND    IF   E           K DISK
     FFMCORG    IF   E           K DISK
     FFMGLCH    IF   E           K DISK
     FFAPCTL    UF   E           K DISK
     FFAPCTLB   UF A E           K DISK
     FAPR300    O    F  120        PRINTER OFLIND(*INOF)
      *
      * MESSAGE ARRAY
     D MSG             S             30    DIM(5) CTDATA PERRCD(1)              DESCRIPTIONS
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
     D  LSEQ                   3      3  0
     D  LUSER                  4     13
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
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      *
     C                   Z-ADD     1             CNT               6 0
     C                   Z-ADD     1             VCNT              6 0
     C                   Z-ADD     LSEQ          LS                2 0
     C                   MOVE      *BLANKS       ERR               1
     C                   SETOFF                                       139255
     C     LUSER         IFGT      *BLANKS
     C                   SETON                                        55
     C                   END
      *
     C     LCO           CHAIN     FMCORG                             88
     C                   EXCEPT    HDG
      *
     C     NXT           TAG
     C                   SETOFF                                       31
     C                   READ      FAPWK                                  90
     C   90              GOTO      END
      *
     C     AWCOMP        IFNE      LCO
     C     AWSTAT        OREQ      'P'
     C                   GOTO      NXT
     C                   ENDIF
      *
     C     LUSER         IFGT      *BLANKS
     C     AWUSER        ANDNE     LUSER
     C                   GOTO      NXT
     C                   ENDIF
      *
      * CHAIN TO VENDOR MASTER FOR VENDOR NAME
      *
     C     AWVEND        CHAIN     FMVEND                             12
     C  N12VMSTAT        IFEQ      'D'
     C                   SETON                                        12
     C                   END
     C   12              DO
     C                   SETON                                        13
     C                   MOVEL     'Y'           ERR
     C                   ENDDO
     C                   Z-ADD     AW$AMT        SV$AMT            9 2
     C                   Z-SUB     AW$AMT        GL$AMT            9 2
      *
      * MANUAL CHECK
      *
     C     AWITYP        IFEQ      'M'
     C                   SETON                                        31        PAID MANUAL/WIRE
     C                   SETOFF                                       32        WIRES INDICATOR
     C                   Z-ADD     SV$AMT        CHECK$            9 2
     C                   ADD       SV$AMT        MD$AMT            9 2
     C                   ADD       DAVL          MDDAVL            7 2
     C                   ADD       DAVL          MDDTAK            7 2
     C                   ENDIF
      *
      * WIRE
      *
     C     AWITYP        IFEQ      'W'
     C                   SETON                                        31        PAID MANUAL/WIRE
     C                   SETON                                        32        WIRES INDICATOR
     C                   Z-ADD     SV$AMT        WIRES$            9 2
     C                   ADD       SV$AMT        MD$AMT            9 2
     C                   ADD       DAVL          MDDAVL            7 2
     C                   ADD       DAVL          MDDTAK            7 2
     C                   ENDIF
      *
     C     VCNT          IFEQ      1
     C                   EXCEPT    DETL1
     C                   ENDIF
      *
     C     GLKEY         KLIST
     C                   KFLD                    AWCOMP
     C                   KFLD                    AWGLAC
     C     GLKEY         CHAIN     FMGLCH                             91
     C                   MOVEL     GCDESC        GDESC            25
      *
     C                   Z-ADD     0             DISCT             7 2
     C     AWTRAT        IFNE      0
     C     SV$AMT        MULT(H)   AWTRAT        DISCT             7 2
     C                   Z-ADD     DISCT         DAVL              7 2
     C                   ELSE
     C                   Z-ADD     AWDAVL        DAVL
     C                   ENDIF
      * ADD INVOICE AMT, DISCOUNT AVAILABLE AND G/L DISTRIBUTION
      *
     C                   ADD       SV$AMT        DT$AMT            9 2
     C                   ADD       DAVL          DTDAVL            7 2
      *
      * REPORT TOTALS
      *
     C                   ADD       SV$AMT        TOTAMT            9 2
     C                   ADD       AWDAVL        TOTDAV            7 2
     C                   ADD       AWUTX$        TOTUSE            7 2
      *
     C     AWITYP        IFEQ      ' '
     C                   ADD       SV$AMT        TOTREG            9 2
     C                   ADD       SV$AMT        APTOT             9 2
     C                   ENDIF
     C     AWITYP        IFEQ      'M'
     C                   ADD       SV$AMT        TOTMAN            9 2
     C                   ENDIF
     C     AWITYP        IFEQ      'W'
     C                   ADD       SV$AMT        TOTWIR            9 2
     C                   ENDIF
     C     AWITYP        IFEQ      'C'
     C                   ADD       SV$AMT        TOTCRE            9 2
     C                   ADD       SV$AMT        APTOT             9 2
     C                   ENDIF
     C     AWITYP        IFEQ      'F'
     C                   ADD       SV$AMT        TOTFRT            9 2
     C                   ADD       SV$AMT        APTOT             9 2
     C                   ENDIF
     C     AWITYP        IFEQ      'I'
     C                   ADD       SV$AMT        TOTIMM            9 2
     C                   ADD       SV$AMT        APTOT             9 2
     C                   ENDIF
      *
     C  N31              ADD       SV$AMT        RDAPD             9 2
      *
     C  N31              ADD       SV$AMT        RT$AMT            9 2
     C  N31              ADD       SV$AMT        RTAPD             9 2
     C  N31              ADD       DAVL          RTDAVL            7 2
      *
      * EXCEPT DETAIL LINE
      *
     C     AWTBPD        IFEQ      'H'
     C                   SETON                                        82
     C                   ENDIF
      *
     C   OF              EXCEPT    HDG
     C   OF              SETOFF                                       OF
     C*  31                EXCPTMDETL
     C                   EXCEPT    DETL
      *
     C*          AWTRAT    IFNE 0
     C     AWTDES        IFGT      *BLANKS
     C     AWTBPD        OREQ      'H'
     C                   EXCEPT    DDETL
     C                   ENDIF
     C*  31                EXCPTMDETL
      *
      * GET GL INFO
      *
     C                   SETOFF                                       222324
     C                   SETOFF                                       252627
     C                   SETOFF                                       82
      *
      * SETLL ON GL RECORDS
      *
     C                   Z-ADD     0             SEQ               3 0
     C     WKKEY         KLIST
     C                   KFLD                    AWCOMP
     C                   KFLD                    AWVOUC
     C                   KFLD                    AWVEND
     C                   KFLD                    AWINV#
     C                   KFLD                    AWITYP
     C                   KFLD                    SEQ
     C     WKKEYC        KLIST
     C                   KFLD                    AWCOMP
     C                   KFLD                    AWVOUC
     C                   KFLD                    AWVEND
     C                   KFLD                    AWINV#
     C                   KFLD                    AWITYP
     C     WKKEY         SETLL     FAPWKS
      *
      * START HERE FOR EACH DETAIL RECORD
      *
     C     NXTWK         TAG
      *
      * READ GL TYPE RECORDS
      *
     C     NXTG          TAG
     C     WKKEYC        READE     FAPWKS                                 22
     C   22              GOTO      ENDWKS
      *
     C     APSTAT        IFNE      'A'
     C                   GOTO      NXTG
     C                   ENDIF
      *
     C                   ADD       AP$AMT        DTGL$$            9 2
     C                   ADD       AP$AMT        TEST$$           11 2
     C                   ADD       AP$AMT        COGL$$            9 2
      *
     C     KEYGL         KLIST
     C                   KFLD                    APCOMP
     C                   KFLD                    APGLAC
     C     KEYGL         CHAIN     FMGLCH                             91
     C  N91GCSTAT        IFEQ      'D'
     C                   SETON                                        91
     C                   END
     C   91              DO
     C                   SETON                                        92
     C                   MOVEL     'Y'           ERR
     C                   END
     C     APTDES        IFGT      *BLANKS
     C                   MOVEL     APTDES        GDESC            25
     C                   ELSE
     C                   MOVEL     GCDESC        GDESC            25
     C                   ENDIF
      *
     C                   EXCEPT    GDETL
      *
     C                   ADD       1             SEQ
     C                   GOTO      NXTWK
      *
     C     ENDWKS        TAG
      *
      * CHECK IF GL AMOUNT EQUAL INVOICE AMOUNT
      *
     C                   SETOFF                                       98
     C     TEST$$        IFNE      AW$AMT
     C                   SETON                                        9899
     C                   EXCEPT    GLERR
     C                   MOVEL     'Y'           ERR
     C                   END
     C                   Z-ADD     0             TEST$$
     C                   GOTO      NXT
      *
     C     END           TAG
     C                   EXCEPT    TLR
      ** GET CONTROL FILE RECORDS
     C     LCO           CHAIN     FAPCTL                             80
     C     CTLKEY        KLIST
     C                   KFLD                    ABCOMP
     C                   KFLD                    ABUSER
     C                   KFLD                    ABTYPE
     C                   MOVEL     'VOUCH'       ABTYPE
     C                   Z-ADD     LCO           ABCOMP
     C                   MOVEL     LUSER         ABUSER
      * SEE IF ANY ERRORS
     C     ERR           IFEQ      'Y'
     C                   EXCEPT    TLERR
     C                   MOVEL     'N'           AZOKP
     C                   MOVEL     'N'           OK                1
     C                   ELSE
      * IF NO ERRORS AND SELECTED USER LEAVE ALL STATUS ALONE
     C* N55                MOVEL'Y'       AZOKP
EFD  C                   MOVEL     'Y'           AZOKP
     C                   MOVEL     'Y'           OK
     C                   END
     C  N80              UPDATE    RAPCTL
      * SELECTED USER
     C   55              DO
     C     CTLKEY        CHAIN     FAPCTLB                            81
     C                   MOVEL     OK            ABOK
     C   81              WRITE     RAPCTLB
     C  N81              UPDATE    RAPCTLB
     C                   ENDDO                                                  55 DO
      * ALL USERS
     C  N55              DO
     C     LCO           SETLL     FAPCTLB
     C     NXTUSR        TAG
     C     LCO           READE     FAPCTLB                                81
     C   81              GOTO      ENDUSR
     C                   MOVEL     OK            ABOK
     C                   UPDATE    RAPCTLB
     C                   GOTO      NXTUSR
     C     ENDUSR        TAG
     C                   ENDDO                                                  N55 DO
     C                   SETON                                        LR
      *
     OAPR300    E            HDG            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           95 'Company:'
     O                       LCO                 98
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            HDG            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           58 'Accounts Payable'
     O                                           80 'Voucher Edit Register'
     O                       TIMOD              120 '  :  :  '
     O          E            HDG            2
     O                                           62 'For User I.D.:'
     O               55      LUSER               73
     O              N55                          73 '** All ** '
     O                                            7 'Sorted:'
     O                       MSG(LS)             38
     O          E            HDG            1
     O                                           28 '----- Invoice -----'
     O                                           35 'Due'
     O                                           47 'Invoice'
     O                                           63 '-Discount-'
     O                                           71 'Use'
     O                                          100 '--- G/L Distribution ---'
     O          E            HDG            0
     O                                            6 'Vouch'
     O                                           17 '  #  '
     O                                           26 '#'
     O                                           20 'Typ'
     O                                           28 'Date'
     O                                           35 'Date'
     O                                           47 'Amount'
     O                                           57 'Amt'
     O                                           63 'Pct'
     O                                           71 'Tax'
     O                                           82 'Acct #'
     O                                           93 'Amount'
     O                                          106 'Description'
     O          E            HDG            1
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          EF           DETL1       1  1
     O                       AWVEND        Z      6
     O              N12      VMNAME              37
     O               12      MSG(4)              37
     O               31N32                       47 'Check #:'
     O               31 32                       47 ' Wire #:'
     O               31      AWCHEK        Z     54
     O               31                          61 'Date:'
     O               31      AWCKDT        Y     70
     O               31                          80 'Amount:'
     O               31      SV$AMT        L     91
     O               31                          94 '***'
     O                                          108 'Acctg Period:'
     O                       AWPERD             111
     O                       AWAPER        Y    120
     O          EF           DETL           1
     O                       GDESC              120
     O                       GL$AMT        MB    94
     O                       AWGLAC              83 '    -    '
     O                       AWUTX$        J     72
     O                       AWTRAT        J     64
     O                       AWDAVL        J     58
     O               82                          50 'H'
     O                       SV$AMT        M     48
     O                       AWDUDT        Y     37
     O                       AWIVDT        Y     28
     O                       AWITYP              19
     O                       AWINV#              17
     O                       AWVOUC        Z      6
     O          EF           DDETL       0  0
     O                       AWTDES              37
     O*       EF 2             MDETL
     O          E            GDETL          1
     O              N91      GDESC          B   120
     O               91      MSG(5)             120
     O                       AP$AMT        MB    94
     O                       APGLAC         B    83 '    -    '
     O          E            GLERR       1  1
     O                                          100 '*** GL Out Of Balance **'
     O                                          120 '**********'
     O          E            TLR         1  1
     O                                           35 'Total Vouchers:'
     O                       TOTAMT        M     48
     O                       TOTDAV        MB    58
     O                       TOTUSE        MB    72
     O          E            TLR            1 03
     O                       PROGID              10
     O                                           24 'Requested By:'
     O                       USERID              35
     O                       RGNAMC              75
     O                                           90 'Company:'
     O                       LCO                 93
     O                       PAGE          Z    120
     O                                          116 'Page:'
     O          E            TLR            1
     O                                            9 'Run Date:'
     O                       TDATE         Y     19
     O                                           58 'Accounts Payable'
     O                                           80 'Voucher Edit Register'
     O                       TIMOD              120 '  :  :  '
     O          E            TLR            3
     O                                           24 '________________________'
     O                                           48 '________________________'
     O                                           72 '________________________'
     O                                           96 '________________________'
     O                                          120 '________________________'
     O          E            TLR         1  1
     O                                           42 'Totals By Type ==>'
     O                                           65 'Regular Vouchers:'
     O                       TOTREG        MB    79
     O          E            TLR            1
     O                                           65 'Manual Checks:'
     O                       TOTMAN        MB    79
     O          E            TLR            1
     O                                           65 '        Wires:'
     O                       TOTWIR        MB    79
     O          E            TLR            1
     O                                           65 'Credit Memos:'
     O                       TOTCRE        MB    79
     O          E            TLR            1
     O                                           65 'Freight Invoices:'
     O                       TOTFRT        MB    79
     O          E            TLR            1
     O                                           65 'Immediate Pay:'
     O                       TOTIMM        MB    79
     O          E            TLR         2  2
     O                                           42 'Total Vouchers ==>'
     O                       TOTAMT        MB    79
     O                                           83 '***'
     O          E            TLR         2  2
     O                                           31 'Total To Be Added'
     O                                           42 ' To A/P ==>'
     O                       APTOT         MB    79
     O                                           83 '***'
     O          E            TLR         2  2
     O                                           70 'H = Invoice Is Held'
     O          E       99   TLERR          2
     O                                           43 '********'
     O                                           68 'CANNOT POST GL OUT OF'
     O                                           87 'BALANCE *************'
     O          E       92   TLERR          2
     O                                           43 '***********'
     O                                           65 'CANNOT POST BAD GL AC'
     O                                           86 'COUNT NUMBER ********'
     O          E       13   TLERR          1
     O                                           71 'CANNOT POST BAD VENDO'
     O                                           93 'R NUMBER ************'
** MESSAGE ARRAY
In Order of Entry                      1
In Order By Vendor Alpha               2
In Order By Vendor Number              3
Invalid Vendor Number ********         4
     *** Invalid G/L Number **         5
